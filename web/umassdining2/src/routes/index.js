const router = require('express').Router();
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');

const getSub = require('./admin.js')
const middleware = require('./middleware.js');
const DBHelper = require('./db.js');

const directory = path.join(__dirname, '../uploads');

setInterval(() => {
    console.log("Clearing uploads!");
    fs.readdir(directory, (err, files) => {
      if (err) throw err;
      for (const file of files) {
          fs.rmSync(path.join(directory,file), { recursive: true, force: true });
      }
    });
}, 15*60*1000);

router.get('/',(req,res)=>{
    res.render(path.resolve('views/home.html'));
});

router.get('/register',middleware.authReq,(req,res)=>{
    if(req.user){return res.redirect('/dashboard')}
    res.render(path.resolve('views/register.html'));
})

router.get('/login',middleware.authReq,(req,res)=>{
    if(req.user){return res.redirect('/dashboard')}
    res.render(path.resolve('views/login.html'))
})
router.get('/dashboard',middleware.authReq,(req,res)=>{
    if(req.user){
        return res.render(path.resolve('views/dashboard.html'),{user:req.user});
    }
    res.redirect('/login');
})

router.get('/admin_dashboard',middleware.authReq,(req,res)=>{
    if(req.user && req.user==='admin'){
        if(req.ip === '::ffff:127.0.0.1'){
            return res.render(path.resolve('views/admin.html'),{
                user: req.query.user,
                upload: req.query.upload,
                flag: process.env.FLAG
            })
        }
        return res.status(403).send("Unauthorized request");
    }
    res.redirect('/login');
})
router.post('/register',async (req,res)=>{
    let user = req.body.user ? req.body.user : "";
    let pass = req.body.pass ? req.body.pass : "";
    if(user === "" || pass === ""){
        return res.status(400).send("User or Password not supplied.")
    }
    let result = await DBHelper.getUser(user);
    if(result.length !==0){
        return res.status(403).send("This user already exists :/");
    }
    await DBHelper.createUser(user,pass);
    res.redirect("/login");
})

router.post('/login',async (req,res) => {
    let user = req.body.user;
    let pass = req.body.pass;
    let result = await DBHelper.authUser(user,pass);
    if(result[0]){
        let token = middleware.createToken(result[0].username);
        res.set('Set-Cookie',token);
        return res.redirect("/dashboard");
    }
    res.redirect("/login");
})

router.post('/submit',middleware.authReq,(req,res)=>{
    if(!req.user){return res.status(403).send('Unauthorized action!')}
    let file = req.files.submission;
    if(path.extname(file.name)!=='.png'){
        res.status(400).send("Invalid file type. Expected \".png\"")
    }

    let dir = crypto.createHash('md5').update(req.user).digest('hex');
    if(!fs.existsSync(`uploads/${dir}`)){
        fs.mkdirSync(`uploads/${dir}`);
    }
    fs.writeFileSync(`uploads/${dir}/${file.name}`,file.data);

    getSub(req.user,file.name);
    res.send("Admin is gonna check this out.");
})
module.exports = router;