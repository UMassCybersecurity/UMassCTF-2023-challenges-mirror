This is a firmware for ESP8266. Included debug info should point out `secret` function
taking in a string and returning value that is used as a password to connect to a Wifi
Access Point. Reimplementing it in C reveals a Base64 decoding function.
Decoding the raw bytes, we find out the password and also the flag of the challenge.