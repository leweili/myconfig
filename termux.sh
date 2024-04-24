#!/data/data/com.termux/files/usr/bin/sh
pkg update
#termux-change-repo
pkg install wget vim termux-services -y
wget https://github.com/ykxVK8yL5L/alist/releases/latest/download/alist-linux-musl-arm64.tar.gz
tar -zxvf alist-linux-musl-arm64.tar.gz
./alist admin set admin
#./alist server
#vi /etc/resolv.conf   nameserver 114.114.114.114
mkdir -p $PREFIX/var/service/alist/log 
ln -sf $PREFIX/share/termux-services/svlogger $PREFIX/var/service/alist/log/run
#vi $PREFIX/var/service/alist/run
echo '#!/data/data/com.termux/files/usr/bin/sh' > $PREFIX/var/service/alist/run
echo 'exec 2>&1' >> $PREFIX/var/service/alist/run
echo 'cd ~ && ~/alist server' >> $PREFIX/var/service/alist/run
chmod a+x $PREFIX/var/service/alist/run
sv-enable alist 
sv up alist 
