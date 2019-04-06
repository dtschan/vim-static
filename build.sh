#!/bin/bash

docker run -i --rm -v "$PWD":/out -w /root alpine /bin/sh <<EOF
apk add gcc make musl-dev ncurses-static
wget https://github.com/vim/vim/archive/v8.1.1045.tar.gz
tar xvfz v8.1.1045.tar.gz
cd vim-*
LDFLAGS="-static" ./configure --disable-channel --disable-gpm --disable-gtktest --disable-gui --disable-netbeans --disable-nls --disable-selinux --disable-smack --disable-sysmouse --disable-xsmp --enable-multibyte --with-features=huge --without-x --with-tlib=ncursesw
make
make install
mkdir -p /out/vim
cp -r /usr/local/* /out/vim
strip /out/bin/vim
chown -R $(id -u):$(id -g) /out/vim
EOF
