# OBSOLETE

This is no longer the recommended way to get a Rust toolchain for RISCV.
Instead, you can clone the [riscv-rust/rust](https://github.com/riscv-rust/rust)
fork of Rust and build it as normal:

    ./x.py build

# Rust Toolchain for RISCV
## Supported boards
* hifive (RV32IMAC)

## Getting started
1. Get the source
```sh
git clone --recursive https://github.com/riscv-rust/riscv-rust-toolchain
cd riscv-rust-toolchain
```

2. Install build dependencies
See [manifest.scm](https://github.com/riscv-rust/riscv-rust-toolchain/blob/master/manifest.scm)
for a list of the required build dependencies.

3. Build the toolchain
A list of all set environment variables is in build-env.sh, adapt
to your distro if necessary.

```sh
# Builds llvm openocd binutils rust and xargo
make toolchain
```

4. Clone quickstart template
```sh
git clone https://github.com/riscv-rust/riscv-rust-quickstart
cd riscv-rust-quickstart
```

5. Follow instructions in riscv-rust-quickstart's [README.md](https://github.com/riscv-rust/riscv-rust-quickstart/blob/master/README.md)

## RISCV crates
* [riscv](https://github.com/riscv-rust/riscv) crate provides routines for riscv
specific asm instructions and reading/writing csr's.

* [riscv-rt](https://github.com/riscv-rust/riscv-rt) crate provides startup code,
linker script and interrupt handling code.

* [e310x](https://github.com/riscv-rust/e310x) crate is a svd2rust generated api
to Freedom E310 MCU peripherals.

* [hifive](https://github.com/riscv-rust/hifive) crate is a board support crate for
the hifive board.

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
