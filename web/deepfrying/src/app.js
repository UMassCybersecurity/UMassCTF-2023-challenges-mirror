const express = require('express')
const app = express()
const hostname = "0.0.0.0";
const port = 3000;
const nunjucks = require('nunjucks');
const fileUpload = require('express-fileupload');
const bodyParser = require('body-parser');

nunjucks.configure('views',{
    autoescape: true,
    express: app
});

app.set('views','./views');

app.use(bodyParser.urlencoded({extended:true }));

app.use(fileUpload());
app.use(require('./routes'));

app.use('/uploads', express.static('uploads'));
app.use('/fries', express.static('fries'));
app.use('/restricted_memes', express.static('restricted_memes'));

app.listen(port, () => {
    console.log(`Server running at http://${hostname}:${port}/`);
});
