use hmac::{Hmac, Mac};
use sha2::Sha256;

use std::os::unix::ffi::OsStrExt;

type HmacSha256 = Hmac<Sha256>;

#[pymodule]
pub mod rust_py_capability_system {
    use crate::{PyObject, PyObjectRef, PyResult, TryFromBorrowedObject, VirtualMachine};

    #[pyattr]
    #[pyclass(module = "capability", name = "Capability")]
    #[derive(Clone, Debug, PyPayload)]
    pub struct Capability {
        pub target: String,
        pub mac: [u8; 16],
    }

    #[pyclass]
    impl Capability {}

    impl TryFromBorrowedObject for Capability {
        fn try_from_borrowed_object(vm: &VirtualMachine, obj: &PyObject) -> PyResult<Self> {
            let target = obj.get_attr("target", vm)?.try_into_value::<String>(vm)?;
            let mac = obj.get_attr("mac", vm)?.try_into_value::<Vec<u8>>(vm)?;
            // TODO: Shouldn't unwrap.
            Ok(Capability {
                target: target,
                mac: mac.try_into().unwrap(),
            })
        }
    }

    #[pyfunction]
    fn capability_to_string(capability: Capability, _vm: &VirtualMachine) -> String {
        if super::validate_capability(&capability) {
            format!("<Capability: {}>", capability.target)
        } else {
            format!("<CORRUPTED Capability: {}>", capability.target)
        }
    }

    pub fn module(vm: &VirtualMachine) -> PyObjectRef {
        make_module(vm)
    }
}

pub use rust_py_capability_system::Capability;

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

pub fn new_capability(target: &str) -> Capability {
    let mut mac =
        HmacSha256::new_from_slice(std::env::var_os("HMAC_KEY").unwrap().as_bytes()).unwrap();
    mac.update(target.as_bytes());
    let result = mac.finalize().into_bytes();
    Capability {
        target: target.into(),
        mac: [
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14],
            result[15],
        ],
    }
}
