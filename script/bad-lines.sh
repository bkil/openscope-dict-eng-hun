#!/bin/sh

main() {
  filters

  filters 2>&1 |
  grep -q "" && return 1
  return 0
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

  echo >&2
}

main "$@"
