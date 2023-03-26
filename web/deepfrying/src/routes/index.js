const router = require('express').Router();
const path = require('path');
const {createCanvas, Image} = require('canvas');
const fs = require('fs');
const crypto = require('crypto');

const directoryUp = path.join(__dirname, '../uploads');
const directoryFr = path.join(__dirname, '../fries');

setInterval(() => {
    console.log("Clearing uploads and fries!");
    fs.readdir(directoryUp, (err, files) => {
      if (err) throw err;
      for (const file of files) {
          fs.rmSync(path.join(directoryUp,file), { recursive: true, force: true });
      }
    });

    fs.readdir(directoryFr, (err, files) => {
      if (err) throw err;
      for (const file of files) {
          fs.rmSync(path.join(directoryFr,file), { recursive: true, force: true });
      }
    });
}, 15*60*1000);

router.get('/',(req,res)=>{
    res.render(path.resolve('views/ImageSelect.html'));
});

router.get('/ImageSelect',(req,res)=>{
    res.render(path.resolve('views/ImageSelect.html'));
});

router.get('/CaptionSubmit',(req,res)=>{
    res.render(path.resolve('views/CaptionSubmit.html'));
});

router.post('/submitimage', async (req,res)=>{
    let file;
    try {
        file = req.files.submission;
    } catch(error) {}

    let url = req.body.url;

    let filename;
    let data;

    if(file) {
        if(!(path.extname(file.name) == '.jpg')){ // TODO: support .jpegs
            return res.status(400).send("Invalid file type. Expected \".jpg\"");
        }

        filename = file.name;
        data = file.data;
    } else if(url) {
        if(!(path.extname(url) == '.jpg' || '.jpeg')) {
            return res.status(400).send("Invalid file type. Expected \".jpg\" or \".jpeg\"");
        } else if (url.includes('localhost')){
            return res.status(403).send("URL cannot reference localhost.");
        }

        const urlArr = url.split('/');
        filename = urlArr[urlArr.length - 1];
        try {
            const theImage = await fetch(url);
            const buffarr = await theImage.arrayBuffer();
            data = Buffer.from(buffarr);
        } catch(error) {
            return res.status(400).send("Cannot access image URL.");
        }
    } else {
        return res.status(400).send("No submission detected.");
    }

    if(!filename)
    {
        return res.status(400).send("Filename not found");
    }

    if(data)
    {
        try {
            let dir = crypto.randomBytes(16).toString('hex');

            fs.mkdirSync(`uploads/${dir}`);

            fs.writeFileSync(`uploads/${dir}/${filename}`, data);


            res.set('Set-Cookie', `${dir}/${filename}`);

            res.redirect('captionsubmit');
        } catch(error) {
            return res.status(400).send("Error saving file. Is your filename safe?");
        }
    }
})

router.post('/captionsubmit', async (req,res)=>{
    let caption = req.body.caption;
    let image = req.headers.cookie;

    try
    {
        image = image.replaceAll('../','');

        let fried = await fry(caption, image);
        res.set('Set-Cookie', fried);

        res.render(path.resolve('views/Returned.html'),{
            caption: caption,
            fried: fried
        })
    } catch (error)
    {
        return res.status(400).send("ERROR: Something went wrong while Frying");
    }
})

router.all('/restricted_memes/:img', async (req,res, next)=>{
    if(req.ip === '::ffff:127.0.0.1') {
        next();
    } else {
       return res.status(403).send("Unauthorized Request");
    }
})

async function fry(caption,imagepath){
    const data = fs.readFileSync(`uploads/${imagepath}`, 'base64');
    try {
        let image = new Image();
        image.src = `data:image/jpeg;base64,${data}`;
        const canvas = createCanvas(image.width, image.height);
        const ctx = canvas.getContext('2d');
        ctx.drawImage(image, 0, 0);
        desaturate(ctx, -20, 0, 0, image.width, image.height);
        contrast(ctx, 0, 0, image.width, image.height);
        const attachment = canvas.toBuffer('image/jpeg', {quality: 0.2});
        const base64img = canvas.toDataURL('image/jpeg');

        let dir = crypto.randomBytes(16).toString('hex');

        fs.mkdirSync(`fries/${dir}`);

        fs.writeFileSync(`fries/${dir}/fried.jpg`, attachment);

        return base64img;
    } catch (error)
    {
        return data;
    }
}

function contrast(ctx, x, y, width, height) {
    const data = ctx.getImageData(x, y, width, height);
    const factor = (270 / 100) + 1;
    const intercept = 128 * (1 - factor);
    for (let i = 0; i < data.data.length; i+=4) {
        data.data[i] = (data.data[i] * factor) + intercept;
        data.data[i + 1] = (data.data[i + 1] * factor) + intercept;
        data.data[i + 2] = (data.data[i + 2] * factor) + intercept;
    }
    ctx.putImageData(data, x, y);
    return ctx;
}

function desaturate(ctx, level, x, y, width, height) {
    const data = ctx.getImageData(x, y, width, height);
    for (let i = 0; i < height; i++) {
        for (let j = 0; j < width; j++) {
            const dest = ((i * width) + j) * 4;
            const gray = Number.parseInt((0.2125 * data.data[dest]) + (0.7154 * data.data[dest + 1]) + (0.0721 * data.data[dest + 2]), 10);
            data.data[dest] += level * (gray - data.data[dest]);
            data.data[dest + 1] += level * (gray - data.data[dest + 1]);
            data.data[dest] += level * (gray - data.data[dest + 2]);
        }
    }
    ctx.putImageData(data, x, y);
    return ctx;
}
module.exports = router;
