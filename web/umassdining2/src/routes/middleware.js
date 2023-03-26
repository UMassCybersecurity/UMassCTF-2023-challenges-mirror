const jwt = require('jsonwebtoken');

function authReq(req,res,next){
    try{
        let verified = jwt.verify(req.headers.cookie,process.env.JWT_SECRET)
        req.user = verified.user;
        next();
    }
    catch(e){
        next();
    }
}
function createToken(username){
    let token = jwt.sign({user: username},
        process.env.JWT_SECRET,
        {expiresIn: '30m'}
    );
    return token;
}
module.exports = {authReq,createToken};