root_dir           := $(CURDIR)
build_dir          := $(root_dir)/build
sysroot_dir        := $(root_dir)/toolchain
target             := riscv32-unknown-elf
jobs               :=
makeflags          := $(if $(jobs),-j$(jobs))
ccache             := $(shell which ccache)


all: toolchain

clean:
	$(RM) -r build toolchain

toolchain: openocd binutils
	@echo All Tools Installed


# RUST + CARGO
rust_src   := $(root_dir)/rust
rust_dest  := $(sysroot_dir)
cargo_build := $(build_dir)/cargo

export RUST_TARGET_PATH=$(root_dir)
export CARGO_HOME=$(cargo_build)

$(sysroot_dir)/bin/cc:
	mkdir -p $(sysroot_dir)/bin
	ln -s $(shell which gcc) $(sysroot_dir)/bin/cc

rust-build: $(sysroot_dir)/bin/cc
	python2 rust/x.py install
$(rust_dest)/bin/rustc: rust-build
rust: $(rust_dest)/bin/rustc

# XARGO
xargo_build := $(build_dir)/xargo
export XARGO_HOME=$(xargo_build)
export XARGO_RUST_SRC=$(rust_src)/src

xargo-build:
	mkdir -p $(xargo_build)
	cargo install xargo --root=$(rust_dest)
$(rust_dest)/bin/xargo: xargo-build
xargo: $(rust_dest)/bin/xargo

# OPENOCD
openocd_src   := $(root_dir)/riscv-openocd
openocd_build := $(build_dir)/openocd
openocd_dest  := $(sysroot_dir)

openocd-build: $(openocd_src)
	rm -rf $(openocd_build)
	mkdir -p $(openocd_build)
	cd $(openocd_src) && autoreconf -i
	cd $(openocd_build) && $</configure \
    --prefix=$(openocd_dest) \
    --disable-werror \
    --enable-riscv \
		--enable-remote-bitbang \
    --enable-ftdi \
		$(if $(ccache),CC="$(ccache) $(CC)") \
		$(if $(ccache),CXX="$(ccache) $(CXX)")
	$(MAKE) -C $(openocd_build) $(makeflags)
	$(MAKE) -C $(openocd_build) install
$(openocd_dest)/bin/openocd: openocd-build
openocd: $(openocd_dest)/bin/openocd

# BINUTILS
binutils_src   := $(root_dir)/riscv-binutils-gdb
binutils_build := $(build_dir)/binutils
binutils_dest  := $(sysroot_dir)

binutils-build: $(binutils_src)
	rm -rf $(binutils_build)
	mkdir -p $(binutils_build)
	cd $(binutils_build) && $</configure \
		--target=$(target) \
		--prefix=$(binutils_dest) \
		--disable-werror \
		--enable-debug \
		--without-guile \
		--enable-python \
		$(if $(ccache),CC="$(ccache) $(CC)") \
		$(if $(ccache),CXX="$(ccache) $(CXX)")
	$(MAKE) -C $(binutils_build) $(makeflags)
	$(MAKE) -C $(binutils_build) install
$(binutils_dest)/bin/$(target)-gdb: binutils-build
binutils: $(binutils_dest)/bin/$(target)-gdb
