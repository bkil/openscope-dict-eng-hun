#!/bin/sh
# The output will need some serious manual editing, but should save time

main() {
  local IN="${1-../../kkemenczy-openscope/szotar/index.php}"
  local OUT="${2-../web/index.html.template}"

  local T="'"
  cat "$IN" |
  sed -r '
    s~<\?php print \$prod_name; \?>~openscope.org szótár~g
    s~<\?php print \$prod_name\.'"$T $T"'\.\$prod_ver\?>~openscope.org szótár 0.2~g
    s~<\?php print \$keyword; \?>~~g
    s~ _\("([^'$T'"]*)"\)~ {% t '"$T\1$T"' %}~g
    s~ _\("([^"]*)"\)~ {% t "\1" %}~g
    s~(<\?php |^)echo *(\{% t "[^"]*" %\});? *(\?>|$)~\2~g
    s~(<\?php |^)echo *(\{% t '$T'[^'$T']*'$T' %\});? *(\?>|$)~\2~g
    s~ *$~~
  ' |
  grep -vE "^(<\?php|\?>) *$" > "$OUT"

  ls -l "$OUT" >&2
}

main "$@"
