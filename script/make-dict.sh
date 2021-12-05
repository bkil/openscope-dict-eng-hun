#!/bin/sh

main() {
  which dictfmt >/dev/null && which dictzip >/dev/null || {
    echo "warning: missing dictfmt or dictzip - skipping dictionary generation" >&2
    exit
  }

  IN="../szotar/glosar.csv"
  BASE="OpenScope-szotar2"

  cat "$IN" |
  sed -r "s~^([^\t]*)\t([^\t]*)\t([^\t]*)\t(.*)~:\1:\3 (\2 \4)~" |
  dictfmt \
    --utf8 \
    --allchars \
    -s "OpenScope szotar2" \
    -j "$BASE" &&
  dictzip "$BASE.dict"

  mv -t ../dist/ *.dz *.index
}

main "$@"
