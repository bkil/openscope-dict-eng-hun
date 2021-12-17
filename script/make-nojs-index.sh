#!/bin/sh
# TODO: There exist various localization plugins, choose one.
# TODO: We can then import the Hungarian po/msg translations as well.
set -e

. ./common.inc.sh

main() {
  WEB="../web/"
  DIST="../dist/"

  local MARKER="((db))"
  local IN="$WEB/nojs.template.html"
  {
    sed -n "/$MARKER/,$ ! p" "$IN"

    cat_dict |
    tsv2html_table

    sed -n "1,/$MARKER/ ! p" "$IN"
  } > "$DIST/nojs.html"
}

tsv2html_table() {
  sed -r "
    s~_~*~g

    s~^([^\t])([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)$~<tr class=\"\2\" id=\"\1\2\__\3__\5\"><td>\1\2<td>\3<td>\4<td>\5<td>\6~
    s~_+\"~\"~
    s~____~__~

    t l
    :l
    s~(<tr class=\"[^\" ]*(\" id=\"[^\" ]*)?) +~\1_~
    t l

    s~(\<(class|id)=)\"([0-9a-zA-Z_-]*)\"~\1\3~g

    s~\*\*([^*]*)\*\*~<strong>\1</strong>~g
    s~\*([^*]*)\*~<em>\1</em>~g
  "
}

main "$@"
