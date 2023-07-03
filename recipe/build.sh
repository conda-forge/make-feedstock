#!/usr/bin/env bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./build-aux
set -ex

if [[ "$target_platform" == linux* ]]; then
  rm -f tests/scripts/functions/wildcard
elif [[ "$target_platform" == osx* ]]; then
  rm -f tests/scripts/variables/INCLUDE_DIRS
fi

if [[ ${target_platform} =~ .*aarch64.* || ${target_platform} =~ .*ppc64le.* ]]; then
  config_opts="--disable-dependency-tracking"
else
  config_opts=""
fi

./configure --prefix=$PREFIX ${config_opts}
# bootstrap building make without make
bash build.sh
# make
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  ./make check
  ./make install
else
  make install
fi
ln -s make $PREFIX/bin/gmake
