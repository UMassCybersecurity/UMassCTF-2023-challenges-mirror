use rustpython::vm;
use rustpython::vm::convert::ToPyObject;

fn main() {
    // Enforce a 2 minute max runtime.
    std::thread::spawn(move || {
        let delay = std::time::Duration::from_secs(2 * 60);
        std::thread::sleep(delay);
        println!("Max runtime exceeded.");
        std::process::exit(1);
    });

    let interp = rustpython::InterpreterConfig::new()
        .init_stdlib()
        .init_hook(Box::new(|vm| {
            vm.add_native_module(
                "capability".to_owned(),
                Box::new(vm::capability::rust_py_capability_system::module),
            );
        }))
        .interpreter();

    interp.enter(|vm| {
        let varname = vm.ctx.intern_str("capabilities").to_owned();
        let varname = varname.to_pyobject(vm);

        let scope = vm.new_scope_with_builtins();

        let code_obj = vm
            .compile(
                "import capability",
                vm::compiler::Mode::Exec,
                "<embedded-safe>".to_owned(),
            )
            .map_err(|err| vm.new_syntax_error(&err))
            .unwrap();

        if let Err(e) = vm.run_code_obj(code_obj, scope) {
            println!("Execution failed with error: {:?}", e);
        }

        let scope = vm.new_scope_with_builtins();
        scope
            .globals
            .get_or_insert(vm, varname, || {
                vm::builtins::PyList::from(vec![
                    vm::capability::new_capability("__name__").to_pyobject(vm),
                    vm::capability::new_capability("__doc__").to_pyobject(vm),
                    vm::capability::new_capability("format").to_pyobject(vm),
                    vm::capability::new_capability("len").to_pyobject(vm),
                    vm::capability::new_capability("object").to_pyobject(vm),
                    vm::capability::new_capability("print").to_pyobject(vm),
                    vm::capability::new_capability("range").to_pyobject(vm),
                    vm::capability::new_capability("capability").to_pyobject(vm),
                    vm::capability::new_capability("capability_to_string").to_pyobject(vm),
                    vm::capability::new_capability("target").to_pyobject(vm),
                    vm::capability::new_capability("mac").to_pyobject(vm),
                    vm::capability::new_capability("Exception").to_pyobject(vm),
                ])
                .to_pyobject(vm)
            })
            .expect("couldn't create capabilities");

        let stdin = std::io::read_to_string(std::io::stdin()).expect("read script");
        let code_obj = vm
            .compile(&stdin, vm::compiler::Mode::Exec, "<embedded>".to_owned())
            .map_err(|err| vm.new_syntax_error(&err))
            .unwrap();

        if let Err(e) = vm.run_code_obj(code_obj, scope) {
            println!("Execution failed with error: {:?}", e);
        }
    });
}
