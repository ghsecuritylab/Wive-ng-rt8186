#!/bin/bash

ROOTDIR=`pwd`
CONFOPTS="--host=mips"
CONFOPTS="$CONFOPTS --prefix=$ROOTDIR/filesystem"
CC=mips-linux-gcc STRIP=mips-linux-strip
CFLAGS="-s -Os" LDFLAGS="-s -Os"
export CC STRIP CFLAGS LDFLAGS
./configure $CONFOPTS
