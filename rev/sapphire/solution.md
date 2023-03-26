Overall, the challenge asks for a string input and prints "You've got the flag!"
if the input is the right flag.

This challenge uses a method known as Heaven's Gate, escaping Windows WOW64
as a 32-bit executable. In the executable, there is a code section that is copied
to executable memory. The code can be partially but wrongly decoded by the
decompiler if it assumes x86-32.

The hint is in `retf` call with 0x33 parameter, which is a call to switch to 64-bit segment.
Debugger by default might skip or fail to catch this switch.
Decoding the following code as x86-64 should reveal the true code that was executed
behind the scene: a XOR function with key size of 4.
Reversing by XOR-ing the key again reveals the flag.