#!/bin/sh
main() {
  IN="../szotar/glosar.txt"
  BASE="OpenScope-szotar2"

  cat "$IN" |
  sed -r "s~^(.*)\t(.*)\t(.*)~:\1:\2 (\3)~" |
  dictfmt \
    --utf8 \
    --allchars \
    -s "OpenScope szotar2" \
    -j "$BASE" &&
  dictzip "$BASE.dict"
}

main "$@"
