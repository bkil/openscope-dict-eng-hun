#!/bin/sh

cat_dict() {
  {
    cat ../szotar/glosar.csv

    sed -r "s~^([^\t]*\t){2}~&+~" ../szotar/bkil.csv
  } |
  grep --text --invert-match '^$' |
  sed "s~\t~&A~g" |
  sort --ignore-case --unique |
  sed "s~\tA~\t~g"
}
