#!/bin/bash

# drivers for mt7615
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/mt package/new/mt
svn co https://github.com/Lienol/openwrt/trunk/package/lean/MTK7615-DBDC-LINUX5.4 package/new/mt
wget -P feeds/luci/modules/luci-base/htdocs/luci-static/resources/icons/ https://github.com/coolsnowwolf/luci/raw/master/modules/luci-base/htdocs/luci-static/resources/icons/wifi_big.png
wget -P feeds/luci/modules/luci-base/htdocs/luci-static/resources/icons/ https://github.com/coolsnowwolf/luci/raw/master/modules/luci-base/htdocs/luci-static/resources/icons/wifi_big_disabled.png

# access control
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-accesscontrol package/new/luci-app-accesscontrol
# DNSFilter
git clone --depth 1 https://github.com/garypang13/luci-app-dnsfilter package/new/luci-app-dnsfilter
# FullCone
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-21.02/package/kernel/fullconenat package/network/fullconenat
wget -P target/linux/generic/hack-5.4/ https://raw.githubusercontent.com/immortalwrt/immortalwrt/openwrt-21.02/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
pushd feeds/luci
cat ../../../patches/fullconenat-luci.patch | git apply
popd
mkdir -p package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://raw.githubusercontent.com/immortalwrt/immortalwrt/openwrt-21.02/package/network/config/firewall/patches/fullconenat.patch
# IPv6 helper
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipv6-helper package/new/ipv6-helper
# Passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/new/luci-app-passwall
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/xray-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/new/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/new/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2socks package/new/dns2socks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ipt2socks package/new/ipt2socks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/kcptun package/new/kcptun
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/microsocks package/new/microsocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/naiveproxy package/new/naiveproxy
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt package/new/pdnsd
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/simple-obfs package/new/simple-obfs
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/new/tcping
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/new/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/new/trojan-plus
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocks-rust package/new/shadowsocks-rust
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/shadowsocksr-libev package/new/shadowsocksr-libev
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-plugin package/new/v2ray-plugin
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core package/new/xray-core
# Scheduled Reboot
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-autoreboot package/new/luci-app-autoreboot
# SeverChan
git clone -b master --depth 1 --single-branch https://github.com/tty228/luci-app-serverchan package/new/luci-app-serverchan
# upx & ucl
svn co https://github.com/coolsnowwolf/lede/trunk/tools/ucl tools/ucl
svn co https://github.com/coolsnowwolf/lede/trunk/tools/upx tools/upx
sed -i '/builddir dependencies/i\tools-y += ucl upx' tools/Makefile
sed -i '/builddir dependencies/a\$(curdir)/upx/compile := $(curdir)/ucl/compile' tools/Makefile

# default settings and translate
cp -rf ../default-settings package/new/lean-translate
#内穿
git clone https://github.com/jasonandy999/packages.git package/luci-app-frpc
#自定义名字
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' package/lean/luci-app-flowoffload/po/zh-cn/flowoffload.po
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' package/lean/luci-app-sfe/po/zh-cn/sfe.po
sed -i 's/"实时流量监测"/"流量"/g' package/lean/luci-app-wrtbwmon/po/zh-cn/wrtbwmon.po
sed -i 's/"KMS 服务器"/"KMS激活"/g' package/lean/luci-app-vlmcsd/po/zh-cn/vlmcsd.zh-cn.po
sed -i 's/"USB 打印服务器"/"打印服务"/g' package/lean/luci-app-usb-printer/po/zh-cn/usb-printer.po
sed -i 's/"网络存储"/"存储"/g' package/lean/luci-app-usb-printer/po/zh-cn/usb-printer.po
sed -i 's/TTYD 终端/命令窗/g' feeds/luci/transplant/luci-app-ttyd/po/zh-cn/terminal.po
sed -i 's/"Web 管理"/"Web管理"/g' package/lean/luci-app-webadmin/po/zh-cn/webadmin.po

# Add helloworld :D
echo "src-git helloworld https://github.com/fw876/helloworld.git" >> feeds.conf.default
# Add a feed source增加默认源地址
#sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default

# Add luci-theme-argon
#删除原默认主题
rm -rf package/lean/luci-theme-argon 
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

#取消原主题luci-theme-bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Change opkg source
echo "sed -i 's#https://mirrors.cloud.tencent.com/lede/snapshots#https://op.supes.top#g' /etc/opkg/distfeeds.conf" >> package/lean/default-settings/files/zzz-default-settings

# 修改主机名字，把OpenWrt-123修改你喜欢的就行（不能使用中文）
sed -i '/uci commit system/i\uci set system.@system[0].hostname='K2P'' package/default-settings/files/zzz-default-settings

# 修改默认wifi名称ssid为iMei
#sed -i 's/ssid=OpenWrt/ssid=iMei/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改默认wifi密码key为12345678
#sed -i 's/key=password/key=12345678/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

exit 0
