#!/bin/sh
set -e

main() {
  cd `dirname "$0"`
  ./bad-lines.sh

  local DIST="../dist/"
  mkdir -p "$DIST" || exit 1

  ./make-nojs-index.sh
  ./make-js-index.sh
  ./make-dict.sh

  cp -a \
    -t $DIST \
    ../LICENSE \
    ../szotar/glosar.csv

  touch $DIST/exported.po
}

main "$@"
