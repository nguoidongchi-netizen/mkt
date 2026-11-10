#!/bin/bash
# Chạy mỗi phút (launchd com.netdoor.marketing.link): link trycloudflare đổi → dựng lại trang chuyển hướng + đẩy GitHub Pages.
export PATH="$HOME/.local/bin:/usr/bin:/bin"
cd "$(dirname "$0")" || exit 1
U=$(grep -oE 'https://[a-z0-9-]+\.trycloudflare\.com' "$HOME/marketing-netdoor/jobs/_tunnel.log" | tail -1)
[ -z "$U" ] && exit 0
dung() { mkdir -p "$(dirname "$1")"; sed -e "s#__DICH__#$2#g" -e "s#__TIEUDE__#$3#g" mau.html > "$1"; }
if [ "$U" != "$(cat url.txt 2>/dev/null)" ] || [ "$1" = "--ep" ]; then
  curl -s -o /dev/null --max-time 15 -w "%{http_code}" "$U/" | grep -q 200 || exit 0
  dung index.html "$U" "Marketing Netdoor"
  dung quan-ly/index.html "$U/quan-ly" "trang Quản lý"
  echo "$U" > url.txt
  git add -A && git -c user.name="nguoidongchi-netizen" -c user.email="nguoidongchi@gmail.com" commit -qm "Link mới $(date '+%d/%m %H:%M')" && git push -q && echo "$(date '+%F %T') đã cập nhật $U"
fi
