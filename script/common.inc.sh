#!/bin/sh

cat_dict() {
  {
    cat ../szotar/glosar.csv

    sed -r "s~^([^\t]*\t){2}~&+~" ../szotar/bkil.csv
  } |
  grep -v '^$' |
  sed "s~\t~&A~g" |
  sort -f -u |
  sed "s~\tA~\t~g"
}
