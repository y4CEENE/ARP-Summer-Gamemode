#!/bin/bash

PROJECT_ROOT=`git rev-parse --show-toplevel`
OS_NAME="$(uname -s)"
case "${OS_NAME}" in
    Linux*)     PAWNCC="${PROJECT_ROOT}/data/pawno/pawncc"     && PAWNCC_FLAGS="-w239 -w214 -i${PROJECT_ROOT}/data/pawno/include";;
    CYGWIN*)    PAWNCC="${PROJECT_ROOT}/data/pawno/pawncc.exe" && PAWNCC_FLAGS="";;
    MINGW*)     PAWNCC="${PROJECT_ROOT}/data/pawno/pawncc.exe" && PAWNCC_FLAGS="";;
    Darwin*)    echo "'Mac' is not supported" && exit 1;;
    *)          echo "'${OS_NAME}' is not supported" && exit 1;;
esac

OLD_CWD=`pwd`
cd ${PROJECT_ROOT}/src/gamemode
echo Running: ${PAWNCC}
${PAWNCC} ${PAWNCC_FLAGS} '-;+' '-(+' arp_next.pwn $@
cd ${OLD_CWD}
