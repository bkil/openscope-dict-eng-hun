#1/bin/sh

. ./common.inc.sh

main() {
  ORIG="../szotar/bkil.csv"
  TMP="../dist/bkil.csv.tmp"
  
  sort_dict "$ORIG" > "$TMP"
  mv "$TMP" "$ORIG"
}

main "$@"
