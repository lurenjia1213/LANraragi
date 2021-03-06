#!/bin/sh

#Just do everything 
apk update 
apk add perl perl-io-socket-ssl perl-dev redis libarchive-dev libbz2 openssl-dev zlib-dev 
apk add imagemagick imagemagick-perlmagick libwebp-tools
apk add g++ make pkgconf gnupg wget curl nodejs nodejs-npm
apk add supervisor su-exec shadow

#Hey it's cpanm
curl -L https://cpanmin.us | perl - App::cpanminus 

#Use a patched version of Rijndael for musl support until a proper CPAN release is done
#See https://framagit.org/fiat-tux/hat-softwares/lufi/issues/137
cpanm https://gitlab.com/thedudeabides/crypt-rijndael/-/archive/musl-libc/crypt-rijndael-musl-libc.tar.gz 

#Install Linux::Inotify2 manually since it's not in the base cpanfile (doesn't build on macOS)
cpanm Linux::Inotify2

#Install the LRR dependencies proper
cd tools && cpanm --notest --installdeps . -M https://cpan.metacpan.org && cd ..
npm run lanraragi-installer install-front 

#Cleanup to lighten the image
apk del perl-dev g++ make gnupg wget curl nodejs nodejs-npm openssl-dev 
rm -rf /root/.cpanm/* /usr/local/share/man/* node_modules tools/_screenshots tools/Documentation