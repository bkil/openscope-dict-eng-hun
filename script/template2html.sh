#!/bin/sh
# TODO: There exist various localization plugins, choose one.
# TODO: We can then import the Hungarian po/msg translations as well.
set -e

main() {
  local IN="${2-../web/index.html.template}"
  local OUT="${2-../dist/index.html}"
  mkdir -p "`dirname "$OUT"`"

  ./bad-lines.sh

  cat "$IN" |
  escape_translation > "$OUT"
}

escape_translation() {
  sed -r "
    s~\{% t '([^']*)' %\}~\1~g
    s~\{% t \"([^\"]*)\" %\}~\1~g
  "
}

main "$@"
