#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
    echo "请使用 sudo ./install.sh" >&2
    exit 1
fi

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

install -Dm755 "$repo_dir/asus-lamparray-init" /usr/local/bin/asus-lamparray-init
install -Dm644 "$repo_dir/asus-lamparray-init.service" /etc/systemd/system/asus-lamparray-init.service

if [[ ! -e /etc/asus-lamparray-init.conf ]]; then
    install -Dm644 "$repo_dir/asus-lamparray-init.conf" /etc/asus-lamparray-init.conf
else
    echo "保留现有配置：/etc/asus-lamparray-init.conf"
fi

systemctl daemon-reload
systemctl enable --now asus-lamparray-init.service

echo "安装完成。配置文件：/etc/asus-lamparray-init.conf"
