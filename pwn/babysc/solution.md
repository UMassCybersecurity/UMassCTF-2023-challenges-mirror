# babysc

Flag: `UMASS{b3_6l4d_y0u_d1dn7_h4v3_70_3xpl017_5p3c7r3}`

In short: you can only access Python globals and methods if you have a `Capability` in scope whose `target` is the name of the global or method you're trying to access.
By default, you don't have the capabilities necessary to call `open`, or anything useful, so you need to forge a capability.
Fortunately, any object with a `target` and `mac` field can be converted into a `Capability`:

```rust
impl TryFromBorrowedObject for Capability {
    fn try_from_borrowed_object(vm: &VirtualMachine, obj: &PyObject) -> PyResult<Self> {
        let target = obj.get_attr("target", vm)?.try_into_value::<String>(vm)?;
        let mac = obj.get_attr("mac", vm)?.try_into_value::<Vec<u8>>(vm)?;
        Ok(Capability {
            target: target,
            mac: mac.try_into().unwrap(),
        })
    }
}
```

Furthermore, the algorithm for validating the `mac` is susceptible to a timing attack:

```rust
pub fn validate_capability(cap: &Capability) -> bool {
    for i in 0..=15 {
        let mut mac =
            HmacSha256::new_from_slice(std::env::var_os("HMAC_KEY").unwrap().as_bytes()).unwrap();
        mac.update(cap.target.as_bytes());
        let result = mac.finalize().into_bytes();
        if result[i] != cap.mac[i] {
            return false;
        }
    }

    true
}
```

So you can brute-force the `mac` of a capability with an arbitrary `target`.
There are a few ways to proceed from here, but the most obvious would be to forge capabilities for `open` and `read`, and placing them in the `capabilities` global, so that you can execute `open("flag.txt").read()`.
