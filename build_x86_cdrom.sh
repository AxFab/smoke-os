#!/bin/bash

export iso_name=OsCore.iso
export ret=0

clear
mkdir -p iso/{bin,boot/grub}

# Clean up
rm -rf obj lib $iso_name

# Build the kernel
make -f kernel/Makefile prefix=iso/boot ARCH=x86
if [ $? -ne 0 ]; then
  echo "ERROR :: Build kernel failed." 1>&2
  exit -1
fi

# Build standard libraries
make -f axc/Makefile MODE=cross
if [ $? -ne 0 ]; then
  echo "ERROR :: Build standard libraries failed." 1>&2
  exit -1
fi

# Build utilities
make -f system/Makefile prefix=iso/bin MODE=cross
if [ $? -ne 0 ]; then
  echo "ERROR :: Build utilities failed." 1>&2
  exit -1
fi

cp _x86/grub.cfg iso/boot/grub/grub.cfg


# Create ISO file
echo "    ISO "$iso_name
grub-mkrescue -o $iso_name iso >/dev/null

if [ $? -ne 0 ]; then
  echo "ERROR :: Can't create iso file"
fi
#  rm -rf iso
rm -rf obj lib
ls -lh $iso_name

