const express = require('express');
const path = require('path');
const app = express();
const port = 9000;
const rateLimit = require('express-rate-limit')
const puppeteer = require('puppeteer');

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

const limiter = rateLimit({
	windowMs: 5000, // 15 minutes
	max: 1, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
	standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
	legacyHeaders: false, // Disable the `X-RateLimit-*` headers
})

// Apply the rate limiting middleware to all requests
app.use(limiter)
app.use(express.json())


app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname,'public','bot.html'));
})


app.post('/lookup',async (req,res)=>{
    let url = req.body.URL;
    if(url){
        let reg = new RegExp(`^(http|https)://${process.env.DOMAIN}`);
        if(reg.test(url)){
            let resp = await Promise.race([await goToURL(url),await sleep(2000)]);
            resp = resp === undefined ? `Failed when going to ${url}` : resp;
            return res.send({'success':`${resp}`});
        }
        res.send({'error':'Please send a URL from the challenge!'});
    }
    else{
        res.send({'error':'Did not recieve URL'});
    }
})

function goToURL(url){
  return new Promise(async (res,rej)=>{
    const browser = await puppeteer.launch({
      executablePath: '/usr/bin/google-chrome-stable',
      args: ['--no-sandbox']
    });
    const cookies = [{
      'name': 'user',
      'value': process.env.ADMIN_ACCOUNT,
      'domain':process.env.DOMAIN
    }];
    const page = await browser.newPage();
    await page.setCookie(...cookies);
    try{
      await page.goto(url);
      await sleep(2000);
      await browser.close()
      return res('Admin has visited your submission!');

    }
    catch(e){
      return res('Admin could not reach your site')
    }

  })
}


app.listen(port, () => {
  console.log(`Admin bot listening on port ${port}`)
})