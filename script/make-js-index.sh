#!/bin/sh
set -e

main() {
  WEB="../web/"
  DIST="../dist/"
  SZOTAR="../szotar/glosar.csv"

  DBVERSION="`cat "$SZOTAR" "$WEB/db.template.js" | sha256sum | cut -d " " -f 1`"

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
  cat "$SZOTAR" |
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
