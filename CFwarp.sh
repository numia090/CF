#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[36m\033[01m$1\033[0m"
}
white(){
    echo -e "\033[1;37m\033[01m$1\033[0m"
}
bblue(){
    echo -e "\033[1;34m\033[01m$1\033[0m"
}
rred(){
    echo -e "\033[1;35m\033[01m$1\033[0m"
}

if [[ $EUID -ne 0 ]]; then
yellow " 请以root模式运行脚本。"
rm -f CFwarp.sh
exit 1
fi

if [[ -f /etc/redhat-release ]]; then
release="Centos"
elif cat /etc/issue | grep -q -E -i "debian"; then
release="Debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
release="Ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
release="Centos"
elif cat /proc/version | grep -q -E -i "debian"; then
release="Debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
release="Ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
release="Centos"
else 
red " 不支持你当前系统，请选择使用Ubuntu,Debian,Centos系统。"
rm -f CFwarp.sh
exit 1
fi

bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`
op=`lsb_release -d >/dev/null 2>&1 | awk -F ':' '{print $2}'`
[[ -n ${op} ]] || op=`hostnamectl | grep -i Operating | awk -F ':' '{print $2}'`
vi=`systemd-detect-virt`

if ! type curl >/dev/null 2>&1; then 
if [ $release = "Centos" ]; then
yellow " curl 未安装，安装中 "
yum -y update && yum install curl -y
else
apt update -y && apt install curl -y
fi	   
else
green " curl 已安装，继续 "
fi

if ! type wget >/dev/null 2>&1; then 
if [ $release = "Centos" ]; then
yellow " wget 未安装，安装中 "
yum -y update && yum install wget -y
else
apt update -y && apt install wget -y
fi	   
else
green " wget 已安装，继续 "
fi 
sleep 1s
yellow " 等待2秒……检测vps中……"
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"

v44=$(curl -s4m6 ip.p3terx.com -k | sed -n 1p)
if [[ -n ${v44} ]]; then
isp4a=`curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v4?lang=zh-CN -k | cut -f13 -d ":" | cut -f2 -d '"'`
isp4b=`curl -sm6 --user-agent "${UA_Browser}" https://api.ip.sb/geoip/$v4 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
[[ -n $isp4a ]] && isp4=$isp4a || isp4=$isp4b
nonf=$(curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v4?lang=zh-CN -k | cut -f2 -d"," | cut -f4 -d '"')
snnf=$(curl -s4m6 ip.p3terx.com -k | sed -n 2p | awk '{print $3}')
if [[ -n $nonf ]]; then
country=$nonf
else
country=$snnf
fi
g4=$country
WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(green "WARP+PLUS已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;;  
on) 
WARPIPv4Status=$(green "WARP已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;; 
off) 
WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v44 ，IP所在区域：$g4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 

v66=$(curl -s6m6 ip.p3terx.com -k | sed -n 1p)
if [[ -n ${v66} ]]; then 
isp6a=`curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v6?lang=zh-CN -k | cut -f13 -d":" | cut -f2 -d '"'`
isp6b=`curl -sm6 --user-agent "${UA_Browser}" https://api.ip.sb/geoip/$v6 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
[[ -n $isp6a ]] && isp6=$isp6a || isp6=$isp6b
nonf=$(curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v6?lang=zh-CN -k | cut -f2 -d"," | cut -f4 -d '"')
snnf=$(curl -s6m6 ip.p3terx.com -k | sed -n 2p | awk '{print $3}')
if [[ -n $nonf ]]; then
country=$nonf
else
country=$snnf
fi
g6=$country
WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(green "WARP+PLUS已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
on) 
WARPIPv6Status=$(green "WARP已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
off) 
WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 

ud4='sed -i "5 s/^/PostUp = ip -4 rule add from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "6 s/^/PostDown = ip -4 rule delete from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
ud6='sed -i "7 s/^/PostUp = ip -6 rule add from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -6 rule delete from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
ud4ud6='sed -i "5 s/^/PostUp = ip -4 rule add from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "6 s/^/PostDown = ip -4 rule delete from $(ip route get 162.159.192.1 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "7 s/^/PostUp = ip -6 rule add from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf && sed -i "8 s/^/PostDown = ip -6 rule delete from $(ip route get 2606:4700:d0::a29f:c001 | grep -oP '"'src \K\S+') lookup main\n/"'" wgcf-profile.conf'
c1="sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf"
c2="sed -i '/\:\:\/0/d' wgcf-profile.conf"
c3="sed -i 's/engage.cloudflareclient.com/162.159.192.1/g' wgcf-profile.conf"
c4="sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf"
c5="sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf"
c6="sed -i 's/1.1.1.1/2001:4860:4860::8888,8.8.8.8/g' wgcf-profile.conf"

Print_ALL_Status_menu() {
white "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
yellow " VPS相关信息如下："
blue " 操作系统名称 -$op "
blue " 系统内核版本 - $version " 
blue " CPU架构名称  - $bit "
blue " 虚拟架构类型 - $vi "
white "------------------------------------------"
blue " WARP状态 + IPv4地址 + IP所在区域: ${WARPIPv4Status}"
blue " WARP状态 + IPv6地址 + IP所在区域: ${WARPIPv6Status}"
white "------------------------------------------"
}

get_char() {
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}

function ins(){
wg-quick down wgcf >/dev/null 2>&1
rm -rf /usr/local/bin/wgcf /etc/wireguard/wgcf.conf /etc/wireguard/wgcf-account.toml /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf

if [[ ${vi} == "lxc" || ${vi} == "openvz" ]]; then
green "正在检测lxc/openvz架构的vps是否开启TUN………！"
sleep 2s
TUN=$(cat /dev/net/tun 2>&1)
if [[ ${TUN} == "cat: /dev/net/tun: File descriptor in bad state" ]]; then
green "检测完毕：已开启TUN，支持安装wireguard-go模式的WARP(+)，继续……"
else
yellow "检测完毕：未开启TUN，不支持安装WARP(+)，请与VPS厂商沟通或后台设置以开启TUN，脚本退出！"
exit 1
fi
fi

if [[ ${vi} == "lxc" ]]; then
if [ $release = "Centos" ]; then
echo -e nameserver 2001:67c:2960:6464:6464:6464:6464:6464 > /etc/resolv.conf
fi
fi

if [ $release = "Centos" ]; then  
yum -y install epel-release
yum -y install curl net-tools wireguard-tools	
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
if [[ ${vi} == "kvm" || ${vi} == "xen" || ${vi} == "microsoft" ]]; then
yellow "内核小于5.6版本，安装WARP内核模块模式"
curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
yum -y install epel-release wireguard-dkms
fi
fi	
yum -y update

elif [ $release = "Debian" ]; then
apt update -y 
apt -y install lsb-release
echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | tee /etc/apt/sources.list.d/backports.list
apt update -y
apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools               		
if [ "$main" -lt 5 ]|| [ "$minor" -lt 6 ]; then 
if [[ ${vi} == "kvm" || ${vi} == "xen" || ${vi} == "microsoft" ]]; then
yellow "内核小于5.6版本，安装WARP内核模块模式"
apt -y --no-install-recommends install linux-headers-$(uname -r);apt -y --no-install-recommends install wireguard-dkms
fi
fi		
apt update -y
	
elif [ $release = "Ubuntu" ]; then
apt update -y  
apt -y --no-install-recommends install net-tools iproute2 openresolv dnsutils wireguard-tools			
fi
	
if [[ ${bit} == "x86_64" ]]; then
wget -N https://cdn.jsdelivr.net/gh/numia090/CF/wgcf_2.2.9_amd64 -O /usr/local/bin/wgcf && chmod +x /usr/local/bin/wgcf         
elif [[ ${bit} == "aarch64" ]]; then
wget -N https://cdn.jsdelivr.net/gh/numia090/CF/wgcf_2.2.9_arm64 -O /usr/local/bin/wgcf && chmod +x /usr/local/bin/wgcf
fi
if [[ ${vi} == "lxc" || ${vi} == "openvz" ]]; then
wget -N https://cdn.jsdelivr.net/gh/numia090/CF/wireguard-go -O /usr/bin/wireguard-go && chmod +x /usr/bin/wireguard-go
fi

mkdir -p /etc/wireguard/ >/dev/null 2>&1
yellow "执行申请WARP账户过程中可能会多次提示：429 Too Many Requests，请耐心等待。"
echo | wgcf register
until [[ -e wgcf-account.toml ]]
do
sleep 1s
echo | wgcf register
done

yellow "继续使用原WARP账户请按回车跳过 \n启用WARP+PLUS账户，请复制WARP+的按键许可证秘钥(26个字符)后回车"
#read -p "按键许可证秘钥(26个字符):" ID

wgcf generate

echo $ABC1 | sh
echo $ABC2 | sh
echo $ABC3 | sh
echo $ABC4 | sh

mv -f wgcf-profile.conf /etc/wireguard/wgcf.conf >/dev/null 2>&1
mv -f wgcf-account.toml /etc/wireguard/wgcf-account.toml >/dev/null 2>&1

wg-quick up wgcf >/dev/null 2>&1
v6=$(curl -s6m6 ip.p3terx.com -k | sed -n 1p)
v4=$(curl -s4m6 ip.p3terx.com -k | sed -n 1p)
until [[ -n $v4 || -n $v6 ]]
do
wg-quick down wgcf >/dev/null 2>&1
wg-quick up wgcf >/dev/null 2>&1
v6=$(curl -s6m6 ip.p3terx.com -k | sed -n 1p)
v4=$(curl -s4m6 ip.p3terx.com -k | sed -n 1p)
done

systemctl enable wg-quick@wgcf >/dev/null 2>&1
wg-quick down wgcf >/dev/null 2>&1
systemctl start wg-quick@wgcf

yellow "添加重启VPS时，自动修复WARP功能"
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/numia090/CF/sip.sh >/dev/null 2>&1
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
if [ ${release} = "Centos" ]; then  
yum install vixie-cron crontabs >/dev/null 2>&1
chkconfig crond on >/dev/null 2>&1
systemctl start crond.service >/dev/null 2>&1
sed -i '/sp.sh/d' /var/spool/cron/root >/dev/null 2>&1
echo "@reboot /root/sp.sh >/dev/null 2>&1" >> /var/spool/cron/root
chmod 777 /var/spool/cron/root
crontab /var/spool/cron/root
systemctl restart crond.service
else
apt install cron >/dev/null 2>&1
sed -i '/sp.sh/d' /var/spool/cron/crontabs/root >/dev/null 2>&1
echo "@reboot /root/sp.sh >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
chmod 777 /var/spool/cron/crontabs/root
crontab /var/spool/cron/crontabs/root
systemctl restart cron.service
fi
green "设置完成"

v44=$(curl -s4m6 ip.p3terx.com -k | sed -n 1p)
if [[ -n ${v44} ]]; then
isp4a=`curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v4?lang=zh-CN -k | cut -f13 -d ":" | cut -f2 -d '"'`
isp4b=`curl -sm6 --user-agent "${UA_Browser}" https://api.ip.sb/geoip/$v4 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
[[ -n $isp4a ]] && isp4=$isp4a || isp4=$isp4b
nonf=$(curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v4?lang=zh-CN -k | cut -f2 -d"," | cut -f4 -d '"')
snnf=$(curl -s4m6 ip.p3terx.com -k | sed -n 2p | awk '{print $3}')
if [[ -n $nonf ]]; then
country=$nonf
else
country=$snnf
fi
g4=$country
WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 

case ${WARPIPv4Status} in 
plus) 
WARPIPv4Status=$(green "WARP+PLUS已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;;  
on) 
WARPIPv4Status=$(green "WARP已开启，当前IPV4地址：$v44 ，IP所在区域：$g4 ") 
;; 
off) 
WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v44 ，IP所在区域：$g4")
esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")
fi 

v66=$(curl -s6m6 ip.p3terx.com -k | sed -n 1p)
if [[ -n ${v66} ]]; then 
isp6a=`curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v6?lang=zh-CN -k | cut -f13 -d":" | cut -f2 -d '"'`
isp6b=`curl -sm6 --user-agent "${UA_Browser}" https://api.ip.sb/geoip/$v6 -k | awk -F "isp" '{print $2}' | awk -F "offset" '{print $1}' | sed "s/[,\":]//g"`
[[ -n $isp6a ]] && isp6=$isp6a || isp6=$isp6b
nonf=$(curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v6?lang=zh-CN -k | cut -f2 -d"," | cut -f4 -d '"')
snnf=$(curl -s6m6 ip.p3terx.com -k | sed -n 2p | awk '{print $3}')
if [[ -n $nonf ]]; then
country=$nonf
else
country=$snnf
fi
g6=$country
WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
case ${WARPIPv6Status} in 
plus) 
WARPIPv6Status=$(green "WARP+PLUS已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;;  
on) 
WARPIPv6Status=$(green "WARP已开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
;; 
off) 
WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v66 ，IP所在区域：$g6 ") 
esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")
fi 

green "安装结束，当前WARP及IP状态如下 "
blue "WARP状态 + IPv4地址 + IP所在区域: ${WARPIPv4Status}"
blue "WARP状态 + IPv6地址 + IP所在区域: ${WARPIPv6Status}"
white "============================================================================================="
#white "返回主菜单，请按任意键"
#white "退出脚本，请按Ctrl+C"
#char=$(get_char)
#bash CFwarp.sh
}

function warpip(){
bash sip.sh
white "============================================================================================="
white "返回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char)
bash CFwarp.sh
}

function warpplus(){
if [ $release = "Centos" ]; then
yum -y install python3
else 
apt -y install python3
fi
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/johnyterry/warp-plus/wp.py
python3 wp.py
}

function upcore(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/numia090/CF/ucore.sh && chmod +x ucore.sh && ./ucore.sh
}

function iptables(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
sudo apt-get purge netfilter-persistent -y
sudo reboot
}

function BBR(){
if [[ ${vi} == "lxc" || ${vi} == "openvz" ]]; then
red " 不支持当前VPS的架构，请使用KVM等主流架构的VPS "
else 
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
lsmod | grep bbr
green "安装原生BBR加速成功"
fi
white "============================================================================================="
white "返回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char)
bash CFwarp.sh
}

function cwarp(){
wg-quick down wgcf >/dev/null 2>&1
systemctl disable wg-quick@wgcf >/dev/null 2>&1
if [ $release = "Centos" ]; then
yum -y autoremove wireguard-tools wireguard-dkms
else 
apt -y autoremove wireguard-tools wireguard-dkms
fi
sed -i '/sp.sh/d' /var/spool/cron/root >/dev/null 2>&1
sed -i '/sp.sh/d' /var/spool/cron/crontabs/root >/dev/null 2>&1
rm -rf /usr/local/bin/wgcf /etc/wireguard/wgcf.conf /etc/wireguard/wgcf-account.toml /usr/bin/wireguard-go wgcf-account.toml wgcf-profile.conf sip.sh ucore.sh nf CFwarp.sh
green "WARP卸载完成"
}

function c1warp(){
wg-quick down wgcf >/dev/null 2>&1
green "临时关闭WARP成功"
white "============================================================================================="
white "返回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char)
bash CFwarp.sh
}

function owarp(){
wg-quick up wgcf >/dev/null 2>&1
green "恢复开启WARP成功"
white "============================================================================================="
white "返回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char)
bash CFwarp.sh
}

function macka(){
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function Netflix(){
if [[ ${bit} == "x86_64" ]]; then
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.61_linux_amd64 && chmod +x nf && clear && ./nf -method full      
elif [[ ${bit} == "aarch64" ]]; then
wget -O nf https://cdn.jsdelivr.net/gh/sjlleo/netflix-verify/CDNRelease/nf_2.61_linux_arm64 && chmod +x nf && clear && ./nf -method full
fi
white "============================================================================================="
white "返回主菜单，请按任意键"
white "退出脚本，请按Ctrl+C"
char=$(get_char)
bash CFwarp.sh
}

function up4(){
wget -N --no-check-certificate https://raw.githubusercontent.com/numia090/CF/main/CFwarp.sh && chmod +x CFwarp.sh && ./CFwarp.sh
}

function start_menu(){
systemctl stop wg-quick@wgcf >/dev/null 2>&1
v44=`ip route get 162.159.192.1 2>/dev/null | grep -oP 'src \K\S+'`
v66=$(curl -s6m6 ip.p3terx.com -k | sed -n 1p)
if [[ -n ${v44} && -n ${v66} ]]; then 
clear
red " 切记：进入脚本快捷方式 bash CFwarp.sh "    
white " ==================一、VPS相关调整选择（更新中）=========================================="    
green "  1. 永久开启甲骨文VPS的ubuntu系统所有端口 "
green "  2. 为5.6以下系统内核更新至5.6以上 "
green "  3. 开启原生BBR加速 "
green "  4. 检测奈飞Netflix是否解锁 "
white " =================二、WARP功能选择（更新中）=========================================="
yellow " 经检测，你的VPS原生类型：双栈IPV6+IPV4"
green "  5. 添加WARP虚拟IPV4，     IP出站流量表现为：IPV6为原生，IPV4由WARP接管，支持IP分流             "
green "  6. 添加WARP虚拟IPV6，     IP出站流量表现为：IPV4为原生，IPV6由WARP接管，支持IP分流      "
green "  7. 添加WARP虚拟IPV4+IPV6，IP出站流量表现为：IPV6与IPV4都由WARP接管，支持IP分流               "    
white " ---------------------------------------------------------------------------------"    
green "  8. 获取WARP+账户无限刷流量 "
green "  9. 手动无限刷新WARP的IP(WARP防失联)"    
green " 10. 卸载WARP功能 "
green " 11. 临时关闭WARP功能 "
green " 12. 开启WARP功能 "
white " ==================三、代理协议脚本选择（更新中）==========================================="
green " 13.使用mack-a脚本（支持Xray, V2ray） "
white " ============================================================================================="
red " 0. 退出脚本 "
Print_ALL_Status_menu
echo
read -p "请输入数字(默认为5):" menuNumberInput
if [[ ${menuNumberInput} == "" ]]; then
  menuNumberInput=5
fi
case "$menuNumberInput" in     
 1 ) iptables;;
 2 ) upcore;;
 3 ) BBR;;
 4 ) Netflix;;    
 5 ) ABC1=${ud4} && ABC2=${c2} && ABC3=${c5}; ins;;
 6 ) ABC1=${ud6} && ABC2=${c1} && ABC3=${c5}; ins;;
 7 ) ABC1=${ud4ud6} && ABC2=${c5}; ins;;
 8 ) warpplus;;
 9 ) warpip;;	
10 ) cwarp;;
11 ) c1warp;;
12 ) owarp;;
13 ) macka;;
 0 ) exit 0;;
esac
  
elif [[ -n ${v66} && -z ${v44} ]]; then
clear
red " 切记：进入脚本快捷方式 bash CFwarp.sh "
white " ==================一、VPS相关调整选择（更新中）==========================================" 
green "  1. 永久开启甲骨文VPS的ubuntu系统所有端口 "
green "  2. 为5.6以下系统内核更新至5.6以上 "
green "  3. 开启原生BBR加速 "
green "  4. 检测奈飞Netflix是否解锁 "
white " ==================二、WARP功能选择（更新中）==============================================="
yellow " 经检测，你的VPS原生类型：纯IPV6"
green "  5. 添加WARP虚拟IPV4，     IP出站流量表现为：IPV6为原生，IPV4由WARP接管，支持IP分流               "
green "  6. 添加WARP虚拟IPV6，     IP出站流量表现为：IPV6由WARP接管，无IPV4，不支持IP分流     "
green "  7. 添加WARP虚拟IPV4+IPV6，IP出站流量表现为：IPV6与IPV4都由WARP接管，支持IP分流               " 
white " ---------------------------------------------------------------------------------"
green "  8. 获取WARP+账户无限刷流量 "
green "  9. 手动无限刷新WARP的IP(WARP防失联)"
green " 10. 卸载WARP功能 "
green " 11. 临时关闭WARP功能 "
green " 12. 临时关闭后开启WARP功能 "
white " ==================三、代理协议脚本选择（更新中）==========================================="
green " 13.使用mack-a脚本（支持Xray, V2ray） "
white " ============================================================================================="
red " 0. 退出脚本 "
Print_ALL_Status_menu
echo
read -p "请输入数字(默认为5):" menuNumberInput
if [[ ${menuNumberInput} == "" ]]; then
  menuNumberInput=5
fi
case "$menuNumberInput" in     
 1 ) iptables;;
 2 ) upcore;;
 3 ) BBR;;
 4 ) Netflix;; 
 5 ) ABC1=${c4} && ABC2=${c2} && ABC3=${c5}; ins;;
 6 ) ABC1=${ud6} && ABC2=${c1} && ABC3=${c4} && ABC4=${c6}; ins;;
 7 ) ABC1=${ud6} && ABC2=${c4} && ABC3=${c5}; ins;;
 8 ) warpplus;;
 9 ) warpip;;	
10 ) cwarp;;
11 ) c1warp;;
12 ) owarp;;
13 ) macka;;
 0 ) exit 0;;
esac

elif [[ -z ${v66} && -n ${v44} ]]; then
clear
red " 切记：进入脚本快捷方式 bash CFwarp.sh "
white " ==================一、VPS相关调整选择（更新中）==========================================" 
green "  1. 永久开启甲骨文VPS的ubuntu系统所有端口 "
green "  2. 为5.6以下系统内核更新至5.6以上 "
green "  3. 开启原生BBR加速 "
green "  4. 检测奈飞Netflix是否解锁 "
white " ==================二、WARP功能选择（更新中）==============================================="
yellow " 经检测，你的VPS原生类型：纯IPV4"
green "  5. 添加WARP虚拟IPV4，     IP出站流量表现为：IPV4由WARP接管，无IPV6，不支持IP分流               "
green "  6. 添加WARP虚拟IPV6，     IP出站流量表现为：IPV4为原生，IPV6由WARP接管，支持IP分流    "
green "  7. 添加WARP虚拟IPV4+IPV6，IP出站流量表现为：IPV6与IPV4都由WARP接管，支持IP分流           "
white " ---------------------------------------------------------------------------------"
green "  8. 获取WARP+账户无限刷流量 "
green "  9. 手动无限刷新WARP的IP(WARP防失联)"
green " 10. 卸载WARP功能 "
green " 11. 临时关闭WARP功能 "
green " 12. 临时关闭后开启WARP功能 "
white " ==================三、代理协议脚本选择（更新中）==========================================="
green " 13.使用mack-a脚本（支持Xray, V2ray） "
white " ============================================================================================="
red " 0. 退出脚本 "
Print_ALL_Status_menu
echo
read -p "请输入数字(默认为5):" menuNumberInput
if [[ ${menuNumberInput} == "" ]]; then
  menuNumberInput=5
fi
case "$menuNumberInput" in     
 1 ) iptables;;
 2 ) upcore;;
 3 ) BBR;;
 4 ) Netflix;;     
 5 ) ABC1=${ud4} && ABC2=${c2} && ABC3=${c3} && ABC4=${c5}; ins;;
 6 ) ABC1=${c1} && ABC2=${c3} && ABC3=${c5}; ins;;
 7 ) ABC1=${ud4} && ABC2=${c3} && ABC3=${c5}; ins;;
 8 ) warpplus;;
 9 ) warpip;;	
10 ) cwarp;;
11 ) c1warp;;
12 ) owarp;;
13 ) macka;;
 0 ) exit 0;;
esac
else
red "无法检测，请向作者反馈。"
exit 1
fi
systemctl start wg-quick@wgcf >/dev/null 2>&1
}
start_menu "first" 
