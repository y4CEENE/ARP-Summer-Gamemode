#!/bin/bash

#./data/pawno/pawncc.exe $(cygpath $(pwd) -w)\\src\\gamemode\\lwor.pwn -Dbuild -i$(cygpath $(pwd) -w)\\src\\gamemode "-;+" "-(+" "-d3"
#=$(git rev-parse --show-toplevel)
git_project=`git rev-parse --show-toplevel`
#build_cmd=${git_project}'/data/pawno/pawncc '"'-;+' '-(+'"' "arp_next.pwn"'
echo Running: ${git_project}'/data/pawno/pawncc -;+ -(+ "arp_next.pwn"'
old_cwd=`pwd`
cd ${git_project}/src/gamemode
${git_project}/data/pawno/pawncc '-;+' '-(+' "arp_next.pwn"
cd ${old_cwd}

