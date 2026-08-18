#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
    echo "请使用 sudo ./uninstall.sh" >&2
    exit 1
fi

systemctl disable --now asus-lamparray-init.service 2>/dev/null || true
rm -f /etc/systemd/system/asus-lamparray-init.service
rm -f /usr/local/bin/asus-lamparray-init
systemctl daemon-reload

echo "已卸载，配置文件 /etc/asus-lamparray-init.conf 已保留。"
