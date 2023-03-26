const router = require('express').Router();
const path = require('path')
const middleware = require('./middleware.js');
const DBHelper = require('./db.js');

//I will add my friends here once I make some 
const ALLOWED = ['admin'];
const FLAG = process.env.FLAG;

router.get('/', (req, res) => {
  res.sendFile(path.join(__dirname,'../static/html/index.html'));
})

router.get('/leaderboard',async (req,res)=>{
  let leaders = (await DBHelper.getAllUsers());
  let topten = leaders
    .sort((a,b)=> b.diamonds - a.diamonds)
    .map(obj=>({'user':obj.username,'diamonds':obj.diamonds}))
    .slice(0,10);
  return res.json({'leaders':topten});
})

router.get('/buyflag/:id',middleware.authReq,async (req,res)=>{
  let result = await DBHelper.getUser(req.user);
  if(result.length>0){
    let user = result[0];
    if(user.diamonds >= 64 && user.name!=='admin'){
      await DBHelper.editDiamonds(req.user,0);
      return res.json({'flag':FLAG});
    }
    return res.json({'error':'not enough diamonds!'})
  }
  res.json({'error':'Could not find character'});
})

router.get('/balance/:id',middleware.authReq,async (req,res)=>{
  let result = await DBHelper.getUser(req.params.id);
  if(result.length>0){
    let user = result[0];
    if(req.params.id === req.user){
      return res.json({'success':{'balance':user.diamonds}})
    }
    else if(req.headers.debug === process.env.DEBUG_HEADER){
      return res.json({'success':{'balance':user.diamonds}})
    }
  }
  res.json({'error':'could not find user!'})
})

router.post('/debugbalance/:id',async (req,res)=>{
  let id = req.body.id ? req.body.id : req.params.id;
  try{
    let resp = await fetch(`http://localhost:3000/balance/${id}`,{headers:{
      'DEBUG':process.env.DEBUG_HEADER
    }});
    let text = await resp.text();
    res.json({'success':text});
  }
  catch(e){
    res.json({'error':e})
  }
})

router.get('/mine/:id',middleware.authReq,async (req,res)=>{
  if(ALLOWED.includes(req.user) || req.headers.debug === process.env.DEBUG_HEADER){
    let user = (await DBHelper.getUser(req.params.id))[0];
    try{
      let diamonds = Math.floor(Math.random()*12) + user.diamonds;
      await DBHelper.editDiamonds(req.params.id,diamonds);
      return res.json({'success':{'diamonds':diamonds}})
    }
    catch(e){
      console.log(e);
      return res.json({'error':"Don't mine at night!"})
    }
  }
  res.json({'error':'Diamonds unavailable at this time.'}).status(403)
})

router.get('/dashboard',middleware.authReq, (req, res) => {
  if(req.user){
    return res.sendFile(path.join(__dirname,'../static/html/dashboard.html'));
  }
  res.redirect('/login')
})

router.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname,'../static/html/login.html'));
})

router.post('/login',async (req,res)=>{
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

router.get('/register',async(req,res)=>{
  res.sendFile(path.join(__dirname,'../static/html/register.html'));
})

router.post('/register', async (req, res) => {
  let user = req.body.user ? req.body.user : "";
  let pass = req.body.pass ? req.body.pass : "";
  if(user === "" || pass === ""){
      return res.status(400).send("User or Password not supplied.")
  }
  let result = await DBHelper.getUser(user);
  if(result.length !== 0){
      return res.status(403).send("SecureBlocks already secured this character!");
  }
  await DBHelper.createUser(user,pass);
  res.redirect("/login");
})

module.exports = router;