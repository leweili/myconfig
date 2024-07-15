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
