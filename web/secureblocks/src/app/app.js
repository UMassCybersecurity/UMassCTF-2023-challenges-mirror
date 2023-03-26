const express = require('express');
const app = express();
const bodyParser = require('body-parser');


app.use('/static', express.static('static'));
app.use(express.json());
app.use(bodyParser.urlencoded({ extended:true }));
app.use(require('./routes'))

app.listen(process.env.SERVER_PORT,()=>{
    console.log(`SecureBlocks listening on port ${process.env.SERVER_PORT}`);
})

