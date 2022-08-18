#!/bin/sh

# lipu ilo ni li pali e ni:
#   1. o jo e nimi lon toki mama. o jo e nimi lon toki ante.
#   2. kepeken ilo grep(1) la, o lukin e lipu nimi tu ni.
#      o weka e nimi lon ala lipu tu taso.
#   3. o open e lipu pi nimi ni taso.
#   4. kepeken ilo jq(1) la, o pona e nasin pi lipu sin.
#      (wile sona pi nasin pona la, o lukin e toki mi
#      lon lipu ilo toki_mama.sh)

set -e
[ "$#" -gt 0 ] || set -- mama_pi_ante_toki.json

nimi_taso=$(mktemp)
taso=$(mktemp)
pona=$(mktemp)

# nimi $PS3 li weka tan ni: toki tan ilo make(1) la, ni li kama sama lukin
PS3=

set -x

grep -f nimi_taso_lon_toki_ale.txt toki_mama_ale.json >"${nimi_taso}"

sed \
    -E \
    -e 's/^\s*//' \
    -e 's/,$//; s/$/,/' \
    -e '1 { s/^/{/ }; $ { s/,$//; s/$/}/ }' \
    <"${nimi_taso}" \
    >"${taso}"

jq --indent 2 -S <"${taso}" >"${pona}"

mv "${pona}" "$1"
rm -f "${nimi_taso}" "${taso}"
