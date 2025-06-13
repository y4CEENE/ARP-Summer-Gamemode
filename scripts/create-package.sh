#!/bin/bash

cd build
tar -xzf ../data/samp-server-0.3.7R2-win32.tar
cd ..
cp -r PKG/* build/samp-server-0.3.7R2-win32/
cp build/lwor.amx build/samp-server-0.3.7R2-win32/gamemodes