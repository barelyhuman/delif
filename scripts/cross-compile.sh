#!/bin/bash

set -euxo pipefail

NIM_VERSION="1.6.4"

# TODO: replace according to project
bin_name='example'
src='src/example.nim'

declare -a build_options=(
    "-o:bin/linux-amd64/$bin_name"
    "--cpu:arm64 --os:linux -o:bin/linux-arm64/$bin_name"
    "-d:mingw --cpu:i386 -o:bin/windows-386/$bin_name.exe"
    "-d:mingw --cpu:amd64 -o:bin/windows-amd64/$bin_name.exe"
)

build_commands="choosenim $NIM_VERSION ; nimble install -y"

for option in ${build_options[@]}; do
    build_commands+=" ; nim c -d:release $option $src"
done

# cleanup
rm -rf bin

# run a docker container with osxcross and cross compile everything
docker run -it --rm -v `pwd`:/usr/local/src \
   chrishellerappsian/docker-nim-cross:latest \
   /bin/bash -c "choosenim stable && $build_commands"


if [ "$(uname -s)" = "Darwin" ]
then
    nim c -d:release --os:macosx --cpu:amd64 -o:"bin/darwin-amd64/$bin_name" $src
    nim c -d:release --os:macosx --cpu:arm64 -o:"bin/darwin-arm64/$bin_name" $src
fi

# create archives
cd bin
for dir in $(ls -d *);
do
    tar cfzv "$dir".tgz $dir
    rm -rf $dir
done
cd ..