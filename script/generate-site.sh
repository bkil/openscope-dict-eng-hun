#!/bin/sh
set -e

cd `dirname "$0"`
. ./common.inc.sh

main() {
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

  cat_dict > $DIST/szotar.csv

  touch $DIST/exported.po
}

main "$@"
