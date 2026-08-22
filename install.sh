#!/usr/bin/env bash
# Shadow theme installer.
#   ./install.sh            build + install to ~/.themes
#   ./install.sh --apply    …and point XFCE at it (records your current theme)
#   ./install.sh --restore  put your previous theme back
#   ./install.sh --remove   uninstall
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAME="Shadow"
THEMES="${HOME}/.themes"
TERM_SCHEMES="${HOME}/.local/share/xfce4/terminal/colorschemes"
STATE="${HOME}/.local/share/shadow-theme/previous.env"

g=$'\e[32m'; y=$'\e[33m'; o=$'\e[0m'
ok()   { printf '  %s✓%s %s\n' "$g" "$o" "$*"; }
warn() { printf '  %s!%s %s\n' "$y" "$o" "$*"; }

build_and_install() {
  command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1 \
    || { echo "ImageMagick required (magick or convert)" >&2; exit 1; }
  "${HERE}/build-theme.sh" >/dev/null
  install -d "$THEMES" "$TERM_SCHEMES"
  rm -rf "${THEMES:?}/${NAME}"
  cp -a "${HERE}/build/${NAME}" "${THEMES}/${NAME}"
  install -m 644 "${HERE}/build/${NAME}/terminal/shadow.theme" "${TERM_SCHEMES}/shadow.theme"
  ok "installed → ${THEMES}/${NAME}"
  ok "terminal preset → Terminal ▸ Preferences ▸ Colors ▸ Presets ▸ Shadow"
}

apply() {
  command -v xfconf-query >/dev/null || { warn "xfconf-query not found — not XFCE; theme is installed, apply it yourself"; return; }
  install -d "$(dirname "$STATE")"
  if [[ ! -f "$STATE" ]]; then
    printf 'PREV_GTK=%s\nPREV_WM=%s\n' \
      "$(xfconf-query -c xsettings -p /Net/ThemeName 2>/dev/null || true)" \
      "$(xfconf-query -c xfwm4 -p /general/theme 2>/dev/null || true)" > "$STATE"
    ok "previous theme recorded → ${STATE}"
  fi
  xfconf-query -c xsettings -p /Net/ThemeName -s "$NAME"
  xfconf-query -c xfwm4 -p /general/theme -s "$NAME"
  ok "GTK + xfwm4 → ${NAME}"
}

restore() {
  [[ -f "$STATE" ]] || { warn "nothing recorded at ${STATE}"; return; }
  # shellcheck disable=SC1090
  . "$STATE"
  [[ -n "${PREV_GTK:-}" ]] && xfconf-query -c xsettings -p /Net/ThemeName -s "$PREV_GTK"
  [[ -n "${PREV_WM:-}"  ]] && xfconf-query -c xfwm4 -p /general/theme -s "$PREV_WM"
  ok "previous theme restored"
}

case "${1:-}" in
  --apply)   build_and_install; apply ;;
  --restore) restore ;;
  --remove)  restore; rm -rf "${THEMES:?}/${NAME}" "${TERM_SCHEMES}/shadow.theme"; ok "removed" ;;
  "")        build_and_install ;;
  *) sed -n '2,7p' "$0"; exit 2 ;;
esac
