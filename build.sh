#!/bin/bash

docker run -i --rm -e vim_version=9.0.1582 -v "$PWD":/out -w /root alpine /bin/sh <<EOF
set -e

# install build-time dependencies
apk add gcc make musl-dev ncurses-static curl upx

# download vim tarball and extract it
curl -Ls https://github.com/vim/vim/archive/refs/tags/v\$vim_version.tar.gz | tar xz
cd vim-*

# configure, compile and install
LDFLAGS="-static" \
	./configure --disable-channel \
		--disable-gpm \
		--disable-gtktest \
		--disable-gui \
		--disable-netbeans \
		--disable-nls \
		--disable-selinux \
		--disable-smack \
		--disable-sysmouse \
		--disable-xsmp \
		--enable-multibyte \
		--with-features=huge \
		--without-x \
		--with-tlib=ncursesw
make -j3
make install

# copy compiled output
mkdir -p /out/vim
cp -r /usr/local/* /out/vim

# make it smaller
strip /out/vim/bin/vim
upx /out/vim/bin/vim

chown -R $(id -u):$(id -g) /out/vim
EOF
