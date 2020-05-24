#!/bin/sh

main() {
  filters

  local ERRORS="`filters 2>/dev/null | wc -l`"
  echo "errors: $ERRORS" >&2
  [ "$ERRORS" -eq 0 ]
}

filters() {
  filter \
    "Missing translation" \
    '^[^\t]+\t[^\t]'

  filter \
    "Missing status" \
    '^[^\t]*\t\t|^([^\t]*\t){3,}|^([^\t]*\t){2}[?\!]$'

  filter \
   "Invalid column count" \
   '^([^\t]*\t){2}[^\t]*$'

}

filter() {
  local MSG="$1"
  local REGEXP="$2"

  echo "$MSG:" >&2

  sed -rn "
    s/$REGEXP/&/
    t e
    p
    :e
    " \
    ../szotar/glosar.txt |
  cat -A
}

main "$@"
