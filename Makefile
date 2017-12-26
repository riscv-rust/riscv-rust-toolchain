root_dir           := $(CURDIR)
build_dir          := $(root_dir)/build
sysroot_dir        := $(root_dir)/toolchain
target             := riscv32-unknown-elf
ccache             := $(shell which ccache)
nproc              :=
ccache             := $(shell which ccache)


all: toolchain

clean:
	git clean -qdfx

toolchain: llvm openocd binutils rust xargo
	@echo All Tools Installed


# LLVM
llvm_src   := $(root_dir)/llvm
llvm_build := $(build_dir)/llvm
llvm_dest  := $(sysroot_dir)

llvm-configure: $(llvm_src)
	mkdir -p $(llvm_build)
	cd $(llvm_build); \
	cmake $(llvm_src) -G "Ninja" \
		$(if $(ccache),-DCMAKE_C_COMPILER_LAUNCHER="$(ccache)") \
		$(if $(ccache),-DCMAKE_CXX_COMPILER_LAUNCHER="$(ccache)") \
										-DCMAKE_INSTALL_PREFIX=$(llvm_dest) \
										-DCMAKE_BUILD_TYPE="Debug" \
										-DLLVM_USE_SPLIT_DWARF=True \
										-DLLVM_OPTIMIZED_TABLEGEN=True \
										-DLLVM_BUILD_TESTS=True \
	                  -DLLVM_BUILD_LLVM_DYLIB=ON \
	                  -DLLVM_LINK_LLVM_DYLIB=ON \
	                  -DLLVM_ENABLE_ASSERTIONS=ON \
	                  -DLLVM_INSTALL_UTILS=ON \
	                  -DLLVM_TARGETS_TO_BUILD="X86" \
                    -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="RISCV"
$(llvm_build): llvm-configure

llvm-build: $(llvm_build)
	cmake --build $(llvm_build) -- $(if $(nproc),-j$(nproc))
$(llvm_build)/bin/llc: llvm-build

llvm-install: $(llvm_build)/bin/llc
	cmake --build $(llvm_build) --target install
$(llvm_dest)/bin/llc: llvm-install

llvm-check: $(llvm_build)/bin/llc
	cmake --build $(llvm_build) --target check-all

lld-check: $(llvm_build)/bin/llc
	cmake --build $(llvm_build) --target check-lld

llvm: $(llvm_dest)/bin/llc


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
  # --disable-manage-submodules
	cd $(rust_src) && \
	./configure --enable-debug \
              --enable-extended \
	            --prefix=$(rust_dest) \
              --sysconfdir=$(rust_dest)/etc \
              --localstatedir=$(rust_dest)/var/lib \
              --datadir=$(rust_dest)/share \
              --infodir=$(rust_dest)/share/info \
              --default-linker=gcc \
              --llvm-root=$(llvm_dest) \
              --enable-llvm-link-shared \
		--enable-ccache
	cd $(rust_src) && make
	cd $(rust_src) && make install
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
		--enable-remote-bitbang \
    --enable-ftdi \
		$(if $(ccache),CC="$(ccache) $(CC)") \
		$(if $(ccache),CXX="$(ccache) $(CXX)")
	$(MAKE) -C $(openocd_build)
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
	$(MAKE) -C $(binutils_build)
	$(MAKE) -C $(binutils_build) install
$(binutils_dest)/bin/$(target)-gdb: binutils-build
binutils: $(binutils_dest)/bin/$(target)-gdb
