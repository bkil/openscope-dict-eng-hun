#!/bin/sh
set -e

. ./common.inc.sh

main() {
  WEB="../web/"
  DIST="../dist/"

  DBVERSION="`{ cat_dict; cat "$WEB/db.template.js"; } | sha256sum | cut -d " " -f 1`"

  gen_js_db

  sed "s~((dbVersion))~${DBVERSION}~g" \
    "$WEB/index.template.html" > "$DIST/index.html"
}

gen_js_db() {
  local DB="`printf %s "$(get_db_concat)"`"
  sed "
    s~((dbVersion))~${DBVERSION}~g
    s@((dict))@${DB}@g
  " "$WEB/db.template.js" > "$DIST/db.js"
}

get_db_concat() {
  cat_dict |
  sed -r "
    s~\t+$~~
    s~_~*~g
  " |
  sed -r "
    t l
    :l
    N
    s~\n~_~
    t l
  "
}

main "$@"
