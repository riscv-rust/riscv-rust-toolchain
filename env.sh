export TOOLCHAIN=$(realpath ./toolchain)
export PATH=$TOOLCHAIN/bin:$(realpath ./profile/bin):$PATH
export RUST_TARGET_PATH=$(realpath .)
export CARGO_HOME=$(realpath ./build/cargo)
export XARGO_HOME=$(realpath ./build/xargo)
export XARGO_RUST_SRC=$(realpath ./rust/src)
