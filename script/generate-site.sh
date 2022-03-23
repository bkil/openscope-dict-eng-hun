#!/bin/sh
set -e

cd `dirname "$0"`
. ./common.inc.sh

main() {
  ./bad-lines.sh

  local DIST="../dist/"
  VAR="../var/"
  WEB="../web/"
  mkdir -p "$DIST" || exit 1
  mkdir -p "$VAR" || exit 1

  ./make-nojs-index.sh
  ./make-js-index.sh
  ./make-dict.sh

  cp -a \
    -t $DIST \
    ../LICENSE \
    ../szotar/glosar.csv

  cat_dict > $DIST/szotar.csv

  touch $DIST/exported.po

  local BAL="$VAR/balancers.private.csv"
  if [ -f "$BAL" ]; then
    BALANCERS="`sed -r ":l; N; s~\n~ ~g; t l" "$BAL"`"
    printf "#_data:after{content:'${BALANCERS}'}\n" > $DIST/balancers.css
  fi
}

main "$@"
