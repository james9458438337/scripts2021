#!/bin/bash

#downlod and compile 
cd /tmp
wget http://downloads.webmproject.org/releases/webp/libwebp-0.6.1.tar.gz
tar xvfz libwebp-0.6.1.tar.gz
cd libwebp-0.6.1
./configure --prefix=/usr/local/libwebp/0_6_1 \
            --enable-libwebpmux     \
            --enable-libwebpdemux   \
            --enable-libwebpdecoder \
            --enable-libwebpextras  \
            --enable-swap-16bit-csp \
            --disable-static
make
make install

#Create Symbolic Link
#// /usr/local/bin
ln -s  /usr/local/libwebp/0_6_1/bin/cwebp /usr/local/bin/
ln -s  /usr/local/libwebp/0_6_1/bin/dwebp /usr/local/bin/
ln -s  /usr/local/libwebp/0_6_1/bin/img2webp /usr/local/bin/
ln -s  /usr/local/libwebp/0_6_1/bin/webpinfo /usr/local/bin/
ln -s  /usr/local/libwebp/0_6_1/bin/webpmux /usr/local/bin/

#// /usr/local/include
ln -s /usr/local/libwebp/0_6_1/include/webp/decode.h /usr/local/include/
ln -s /usr/local/libwebp/0_6_1/include/webp/demux.h /usr/local/include/
ln -s /usr/local/libwebp/0_6_1/include/webp/encode.h /usr/local/include/
ln -s /usr/local/libwebp/0_6_1/include/webp/mux.h /usr/local/include/
ln -s /usr/local/libwebp/0_6_1/include/webp/mux_types.h /usr/local/include/
ln -s /usr/local/libwebp/0_6_1/include/webp/types.h /usr/local/include/

#// /usr/local/lib
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdecoder.la /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdecoder.so.3.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdecoder.so.3.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdecoder.so.3.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdemux.la /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdemux.so.2.0.3 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdemux.so.2.0.3 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpdemux.so.2.0.3 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebp.la /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpmux.la /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpmux.so.3.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpmux.so.3.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebpmux.so.3.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebp.so.7.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebp.so.7.0.1 /usr/local/lib/
ln -s /usr/local/libwebp/0_6_1/lib/libwebp.so.7.0.1 /usr/local/lib/

#// /usr/local/lib/pkgconfig
ln -s /usr/local/libwebp/0_6_1/lib/pkgconfig/libwebpdecoder.pc /usr/local/lib/pkgconfig/
ln -s /usr/local/libwebp/0_6_1/lib/pkgconfig/libwebpdemux.pc /usr/local/lib/pkgconfig/
ln -s /usr/local/libwebp/0_6_1/lib/pkgconfig/libwebpmux.pc /usr/local/lib/pkgconfig/
ln -s /usr/local/libwebp/0_6_1/lib/pkgconfig/libwebp.pc /usr/local/lib/pkgconfig/

#Set Environment Variable
cat << EOF >> ~/.bash_profile
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF

# load shared libraries in the system
echo "/usr/local/libwebp/0_6_1/lib" >> /etc/ld.so.conf.d/extend.conf
ldconfig && ldconfig -p | grep libwebp
pkg-config libwebp --libs --cflags

