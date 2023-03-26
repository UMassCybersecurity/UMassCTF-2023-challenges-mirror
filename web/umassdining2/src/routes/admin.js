const puppeteer = require('puppeteer')
const middleware = require('./middleware.js')
function getSub(user,upload){
  return new Promise(async (res,rej)=>{
    const browser = await puppeteer.launch({
      executablePath: '/usr/bin/google-chrome-stable',
      args: ['--no-sandbox']
    });
    const page = await browser.newPage();
    page.setExtraHTTPHeaders({
      'Cookie':middleware.createToken('admin')
    });
    await page.goto(`http://127.0.0.1:${process.env.SERVER_PORT}/admin_dashboard?user=${user}&upload=${upload}`);
    return res(await browser.close());
  })
}

module.exports = getSub