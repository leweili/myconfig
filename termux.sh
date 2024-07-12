#!/data/data/com.termux/files/usr/bin/sh
termux-change-repo
pkg update
echo '安装依赖'
pkg instal termux-services tsu python rustscan -y
apt install -y wget dpkg
pip install requests
echo '下载Python文件'
wget https://mirror.ghproxy.com/https://github.com/ykxVK8yL5L/myconfig/raw/main/address.py -O address.py
echo '安装Alist'
wget https://mirror.ghproxy.com/https://github.com/ykxVK8yL5L/termux-packages/releases/latest/download/alist_1_aarch64.deb -O alist.deb
dpkg -i alist.deb
echo '配置Alist，默认密码:admin,端口:10002'
alist admin set admin
sed -i 's/5244/10002/g' data/config.json
echo '创建开机启动服务'
mkdir -p $PREFIX/var/service/alist/log 
ln -sf $PREFIX/share/termux-services/svlogger $PREFIX/var/service/alist/log/run
echo '#!/data/data/com.termux/files/usr/bin/sh' > $PREFIX/var/service/alist/run
echo 'exec 2>&1' >> $PREFIX/var/service/alist/run
echo 'cd ~ && alist server' >> $PREFIX/var/service/alist/run
chmod a+x $PREFIX/var/service/alist/run
sv enable alist 
sv up alist 
echo '请重启termux'
