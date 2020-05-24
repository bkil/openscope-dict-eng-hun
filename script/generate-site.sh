#!/bin/sh
set -e

main() {
  cd `dirname "$0"`
  local OUT="../dist/"

  ./template2html.sh

  mkdir -p "$OUT/js" "$OUT/css"

  cp -a \
    -t $OUT \
    ../LICENSE \
    ../szotar/glosar.txt

  cp -t "$OUT/js/" ../web/js/*
  cp -t "$OUT/css/" ../web/css/*

  touch $OUT/exported.po
}

main "$@"
