# Flag

```
UMASS{C0ff33_m@k3s_m3_J@v@_crazy}
```

# How to solve

This java program is obfuscated using a three step obfuscation strategy. To most effectively deobfuscate this program, it is necessary to have debugging tools. 
Statically reversing this would be fun, however I would seriously advise against it.

First and foremost, you must lift the dynamic invocations back to their static forms. There are various different available tools such as Java Deobfuscator
which will do this for you.

Once you have the lifted bytecode, you may begin dynamic analysis. Execute the jar using your favourite debugger and navigate through the code flow, you would eventually
find the code branch of the hashed password `J@v@J1tt3rs&54`. The string, obfuscated by a polymorphic string encryption function, should be manageably reversable by this 
point.

