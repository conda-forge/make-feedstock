#!/usr/bin/env bash
set -ex

show_errors_and_exit() {
    find tests -name '*.diff*' -print -exec cat '{}' \;
    exit 1
}

if [[ "$(uname)" == 'Linux' ]]; then
  rm -f tests/scripts/functions/wildcard
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
./make check || show_errors_and_exit
./make install

ln -s make $PREFIX/bin/gmake
