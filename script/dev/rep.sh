#!/bin/sh

each_char() {
  for V in `seq 0 25`;do
    U="`echo|awk -vV=$V '{printf("%c", 65 + V)}'`"
    u="`echo "$U" | tr A-Z a-z`"
    $1 "$u" "$U"
  done
}

css_small() {
  echo "#$1:checked ~ table > tbody > tr:not([id^=$1 i]) { display: none; }"
}

css_big() {
  echo "#$2:checked ~ table > tbody > tr:not([class*=$1 i]) { display: none; }"
}

input_small() {
  FLAGS=""
  [ "$1" = "a" ] && FLAGS=" checked autofocus"
  echo "<input type=radio name=a id=$1 accesskey=$1$FLAGS>"
}

input_big() {
  echo "<input type=radio name=b id=$2>"
}

main() {
  each_char css_small
  echo

  each_char css_big
  echo

  each_char input_small

  cat << EOF
<br>

<input type=radio name=b id=_ checked>
EOF

  each_char input_big
}

main "$@"
