#!/bin/sh

sort_dict() {
  grep -v '^$' "$@" |
  sed "s~\t~&A~g" |
  sort -f -u |
  sed "s~\tA~\t~g"
}

cat_dict() {
  {
    cat ../szotar/glosar.csv

    sed -r "s~^([^\t]*\t){2}~&+~" ../szotar/bkil.csv
  } |
  sort_dict
}
