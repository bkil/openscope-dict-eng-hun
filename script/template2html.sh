#!/bin/sh
# TODO: There exist various localization plugins, choose one.
# TODO: We can then import the Hungarian po/msg translations as well.
set -e

main() {
  local IN="${2-../web/index.html.template}"
  local OUT="${2-../dist/index.html}"
  local MARKER="{% GLOSARHTMLTABLE %}"
  mkdir -p "`dirname "$OUT"`"

  ./bad-lines.sh

  {
    sed -n "/$MARKER/,$ ! p" "$IN" |
    escape_translation

    cat "../szotar/glosar.txt" |
    tsv2html_table

    sed -n "1,/$MARKER/ ! p" "$IN" |
    escape_translation
  } > "$OUT"
}

tsv2html_table() {
  echo "<table>"

  sed -r "
    s~^(.*)\t(.*)\t(.*)~ <tr> <td>\1</td><td>\2</td><td>\3</td> </tr>~
  "

  echo "</table>"
}

escape_translation() {
  sed -r "
    s~\{% t '([^']*)' %\}~\1~g
    s~\{% t \"([^\"]*)\" %\}~\1~g
  " "$@"
}

main "$@"
