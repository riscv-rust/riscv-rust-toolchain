# Rust Toolchain for RISCV
## Supported boards
* hifive (RV32IMAC)

## Getting started
1. Get the source
```sh
git clone --recursive https://github.com/dvc94ch/riscv-rust
cd riscv-rust
```

2. Install build dependencies
autoconf automake bash bison cmake coreutils curl
diffutils doxygen expat file findutils flex-2.6.1
gawk gcc-toolchain-6 (list gcc-6 "lib") git gmp
gnu-make grep gzip libedit libssh2 libtool libusb
libxml2 mpc mpfr ncurses openssl patchelf pkg-config
python-2 sed swig tar texinfo which zlib zsh

3. Build the toolchain
```sh
# Builds llvm openocd binutils rust and xargo
make toolchain
```

4. Build hello world


5. Upload

## RISCV crates
* [riscv](https://github.com/dvc94ch/riscv) crate provides routines for riscv
specific asm instructions and reading/writing csr's.

* [riscv-rt](https://github.com/dvc94ch/riscv-rt) crate provides startup code,
linker script and interrupt handling code.

* [e310x](https://github.com/dvc94ch/e310x) crate is a svd2rust generated api
to Freedom E310 MCU peripherals.

* [hifive](https://github.com/dvc94ch/hifive) crate is a board support crate for
the hifive board.

* [riscv-rtfm](https://github.com/dvc94ch/riscv-rtfm)

## License
ISC License

Copyright (c) 2017, David Craven

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
