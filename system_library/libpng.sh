#!/bin/bash

#downlod and compile (install zlib-1.2.11 first)
cd /tmp
wget https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
tar xvfz libpng-1.6.37.tar.gz
cd libpng-1.6.37
./configure --prefix=/usr/local/libpng/1_6_37
make
make install

#Create Symbolic Link
#// /usr/local/bin
ln -s /usr/local/libpng/1_6_37/bin/libpng16-config /usr/local/bin/
ln -s /usr/local/libpng/1_6_37/bin/libpng-config /usr/local/bin/
ln -s /usr/local/libpng/1_6_37/bin/pngfix /usr/local/bin/
ln -s /usr/local/libpng/1_6_37/bin/png-fix-itxt /usr/local/bin/

#// /usr/local/include
ln -s /usr/local/libpng/1_6_37/include/libpng16 /usr/local/include/
ln -s /usr/local/libpng/1_6_37/include/pngconf.h /usr/local/include/
ln -s /usr/local/libpng/1_6_37/include/png.h /usr/local/include/
ln -s /usr/local/libpng/1_6_37/include/pnglibconf.h /usr/local/include/

#// /usr/local/lib
ln -s /usr/local/libpng/1_6_37/lib/libpng16.a /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng16.la /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng16.so /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng16.so.16 /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng16.so.16.37.0 /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng.a /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng.a /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng.la /usr/local/lib/
ln -s /usr/local/libpng/1_6_37/lib/libpng.so /usr/local/lib/

#// /usr/local/lib/pkgconfig
ln -s /usr/local/libpng/1_6_37/lib/pkgconfig/libpng16.pc /usr/local/lib/pkgconfig/
ln -s /usr/local/libpng/1_6_37/lib/pkgconfig/libpng.pc /usr/local/lib/pkgconfig/

#Set Environment Variable
cat << EOF >> ~/.bash_profile
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
EOF

# load shared libraries in the system
echo "/usr/local/libpng/1_6_37/lib" >> /etc/ld.so.conf.d/extend.conf
ldconfig && ldconfig -p | grep libpng
pkg-config libpng --libs --cflags

