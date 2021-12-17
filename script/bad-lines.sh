#!/bin/sh

. ./common.inc.sh

main() {
  filters

  local ERRORS="`filters 2>/dev/null | wc -l`"
  echo "errors: $ERRORS" >&2
  [ "$ERRORS" -eq 0 ]
}

filters() {
  filter_neg \
    "Missing English word" \
    '^\t'

  filter_pos \
    "Missing Hungarian translation" \
    '^[^\t]+\t[^\t]*\t[^\t]'

  filter_pos \
   "Invalid column count" \
   '^([^\t]*\t){4}[^\t]*$'

  filter_neg \
    "Double space" \
    '  '

  filter_neg \
    "Underscore (_) used instead of asterisk (*)" \
    '_'

  filter_neg \
    "Space around double asterisk (*)" \
    ' [*][*] '

  filter_neg \
    "Space around asterisk (*)" \
    ' [*] '

  filter_neg \
    "Leading or trailing space" \
    ' \t|\t '

  filter_neg \
    "Double hyphen" \
    '--'

  filter_neg \
    "HTML chars (<>&)" \
    '[<>&]'

  filter_neg \
    "Uncommon characters" \
    "^[^][0-9a-zA-Zʌˈ'.,?!~;*+=→/:()„”\t _–-]*$"

  filter_neg \
    "Header row" \
    '(^|\t)([eE]nglish|[aA]ngolul|[sS]ófaj|[mM]agyar(ul)?|[kK]ontextus)(\t|$)'
}

filter_neg() {
  filter_generic "$@" "T"
}

filter_pos() {
  filter_generic "$@" "t"
}

filter_generic() {
  local MSG="$1"
  local REGEXP="$2"
  local BRANCH="$3"

  echo "- $MSG" >&2

  cat_dict |
  sed -rn "
    s/$REGEXP/&/
    $BRANCH e
    p
    :e
    " |
  while read ERROR; do
    printf " %s\n" "$ERROR" >&2

    printf "  %s\n" "$ERROR" |
    cat -A
  done
}

main "$@"
