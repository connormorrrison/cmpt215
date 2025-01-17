#!/bin/bash

# tvi340


if [ "$1" == "--qemu" ]
then
(/student/cmpt215/qemu/bin/qemu-riscv32 $2)
elif [ "$1" == "--qemu-gdb" ]
then
let x=$((30000 + $RANDOM % 10000))
printf "Opened port %d\n" $x
(/student/cmpt215/qemu/bin/qemu-riscv32 -g $x $2)
elif [ "$1" == "--gdb" ]
then
(/usr/local/riscvmulti/bin/riscv64-unknown-elf-gdb $2)
fi
