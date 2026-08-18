# asus-lamparray-init

（适用天选6P）一个小补丁，为采用 I2C-HID Microsoft LampArray 控制器的 ASUS 笔记本，在 Linux 冷启动时自动初始化键盘 RGB 背光，以解决键盘背光不亮的问题。

已在以下硬件验证：

- ASUS TX Gaming / 天选 6 Pro（FA608FM）
- HID ID：`0018:0B05:19B6`
- 控制器：ITE LampArray，单灯区 RGB

设备键盘在 Windows 初始化后热重启到 Linux 通常可以正常亮起，但长时间关机再直接启动 Linux 时可能保持熄灭。原因是当前 `asusctl` 没有发现位于 I2C-HID 总线上的 LampArray 控制器。本工具直接使用标准 HID LampArray Feature Report 完成初始化；之后 KDE 仍可通过系统键盘亮度控制器调节亮度。

## 安装

```bash
git clone https://github.com/slwyts/asus-lamparray-init
cd asus-lamparray-init
sudo ./install.sh
```

## 配置颜色

编辑：

```bash
sudo nano /etc/asus-lamparray-init.conf
```

默认配置：

```ini
COLOR=00ffff
INTENSITY=255
```

颜色使用六位十六进制 RGB，例如：

- 红色：`ff0000`
- 蓝色：`0066ff`
- 白色：`ffffff`
- 紫色：`a855f7`
- 青色：`00ffff`

修改后立即应用：

```bash
sudo systemctl restart asus-lamparray-init.service
```

查看日志：

```bash
systemctl status asus-lamparray-init.service
journalctl -u asus-lamparray-init.service -b
```

## 手动使用

```bash
sudo asus-lamparray-init --color 0066ff --intensity 255
```

检测设备但不发送指令：

```bash
sudo asus-lamparray-init --probe
```

默认只匹配 ASUS `0B05:19B6` I2C-HID LampArray

## 卸载

```bash
sudo ./uninstall.sh
```

卸载会保留 `/etc/asus-lamparray-init.conf`，方便以后重新安装。

## 工作原理

工具读取 HID LampArray Attributes Report `0x41` 获取灯区数量，然后发送：

1. LampArray Control Report `0x46`：关闭自主模式，切换为主机控制。
2. Lamp Range Update Report `0x45`：向全部灯区设置 RGB 与强度。


## License

MIT
