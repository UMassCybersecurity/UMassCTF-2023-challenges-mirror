const express = require('express');
const app = express();
var bodyParser = require('body-parser');
const nunjucks = require('nunjucks');
const fileUpload = require('express-fileupload');

nunjucks.configure('views',{
    autoescape: true,
    express: app
});


app.use(bodyParser.urlencoded({extended:true }));

app.use(fileUpload());
app.use(require('./routes'));

app.use('/static', express.static('public'));
app.use('/uploads',express.static('uploads'));

app.listen(process.env.SERVER_PORT,()=>{
    console.log(`UMassDining2 listening on port ${process.env.SERVER_PORT}`);
})

