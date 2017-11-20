(use-package-modules autotools base bash bison bootloaders cmake commencement
                     compression curl documentation elf file flex gawk gcc
                     libedit libusb multiprecision ncurses pkg-config python
                     shells ssh swig texinfo tls version-control xml)

(packages->manifest
 (list autoconf
       automake
       bash
       bison
       cmake
       coreutils
       curl
       dtc
       diffutils
       doxygen
       expat
       file
       findutils
       flex-2.6.1
       gawk
       gcc-toolchain-6 (list gcc-6 "lib")
       git
       gmp
       gnu-make
       grep
       gzip
       libedit
       libssh2
       libtool
       libusb
       libxml2
       mpc
       mpfr
       ncurses
       openssl
       patchelf
       pkg-config
       python-2
       sed
       swig
       tar
       texinfo
       which
       zlib
       zsh))
