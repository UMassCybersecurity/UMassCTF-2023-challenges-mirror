FROM rust:1.68-slim

WORKDIR /usr/src/myapp

COPY . .

# Fix symbolic links in RustPython/vm/Lib/python_builtins
RUN cd /usr/src/myapp/RustPython/vm/Lib/python_builtins && \
    rm _frozen_importlib.py && \
    ln -s ../../../Lib/importlib/_bootstrap.py _frozen_importlib.py && \
    rm _frozen_importlib_external.py && \
    ln -s ../../../Lib/importlib/_bootstrap_external.py _frozen_importlib_external.py && \
    rm _thread.py && \
    ln -s ../../../Lib/_dummy_thread.py _thread.py

# Fix symbolic links in RustPython/vm/Lib/core_modules
RUN cd /usr/src/myapp/RustPython/vm/Lib/core_modules && \
    rm codecs.py && \
    ln -s ../../../Lib/codecs.py codecs.py && \
    rm copyreg.py && \
    ln -s ../../../Lib/copyreg.py copyreg.py && \
    rm encodings_utf_8.py && \
    ln -s ../../../Lib/encodings/utf_8.py encodings_utf_8.py

RUN cargo install --bin interpreter --path ./webide
RUN cargo install --bin webide --path ./webide

ENV HMAC_KEY ThY1qjwSmhc6HEB7McBIqqb9ry4dwmenoYa8dVSiiBgjAkHC0SJLSc7WmJ3QreOn

CMD ["webide"]
