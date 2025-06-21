#!/bin/bash

# Set variables
TARGET=i686-elf
PREFIX=/usr/local/cross
PATH="$PREFIX/bin:$PATH"

# 1. Create required directories
mkdir -p ~/src ~/build-binutils ~/build-gcc

# 2. Extract source archives (assumes files are in archive-files/)
tar -xf archive-files/binutils-*.tar.gz -C ~/src
tar -xf archive-files/gcc-*.tar.gz -C ~/src

# 3. Get directory names
BINUTILS_DIR=$(find ~/src -maxdepth 1 -type d -name "binutils-*")
GCC_DIR=$(find ~/src -maxdepth 1 -type d -name "gcc-*")

# 4. Build and install binutils
cd ~/build-binutils
$BINUTILS_DIR/configure \
  --target=$TARGET \
  --prefix=$PREFIX \
  --with-sysroot \
  --disable-nls \
  --disable-werror
make -j$(nproc)
sudo make install

# 5. Export PATH (append to ~/.bashrc if needed)
if ! grep -q "$PREFIX/bin" ~/.bashrc; then
  echo "export PATH=\"$PREFIX/bin:\$PATH\"" >> ~/.bashrc
fi
export PATH="$PREFIX/bin:$PATH"

# 6. Build and install GCC (C only, without headers)
cd ~/build-gcc
$GCC_DIR/configure \
  --target=$TARGET \
  --prefix=$PREFIX \
  --disable-nls \
  --enable-languages=c \
  --without-headers
make all-gcc -j$(nproc)
make all-target-libgcc -j$(nproc)
sudo make install-gcc
sudo make install-target-libgcc

# 7. Verify installation
i686-elf-gcc --version
i686-elf-as --version

echo "Cross GCC and Binutils installed successfully."
