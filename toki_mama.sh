#!/bin/sh

# lipu ilo ni li pali e ni:
#   1. kepeken ilo curl(1) la, o kama jo e lipu sin pi ilo Siko
#   2. kepeken ilo sed(1) kepeken ilo grep(1) la, o nasin e toki tan lipu.
#      o weka e toki ala tan lipu, o jo e toki taso. o jo ala e toki ilo.
#   3. kepeken ilo jq(1) la, o pona e nasin pi toki mama.
#      nasin pona li ni:
#       open lipu la, nimi lili A, en nimi lili E, en nimi lili I li lon.
#       pini lipu la, nimi lili T, en nimi lili U, en nimi lili W li lon.

set -e

url="https://raw.githubusercontent.com/Discord-Datamining/Discord-Datamining/master/current.js"
url_replugged="https://raw.githubusercontent.com/replugged-org/replugged/main/i18n/en-US.json"
[ "$#" -gt 0 ] || set -- toki_mama_ale.json

mama=$(mktemp)
mama_replugged=$(mktemp)
taso=$(mktemp)
pona=$(mktemp)

# nimi $PS3 li weka tan ni: toki tan ilo make(1) la, ni li kama sama lukin
PS3=

set -x

curl -Lf# -o "${mama}" "${url}"
curl -Lf# -o "${mama_replugged}" "${url_replugged}"

sed "s/^\s*//" "${mama}" \
    | grep -E \
        -e "^[A-Z][A-Z0-9_]{2,}:\s+['\"].*['\"],$" \
        -e "^e\.[A-Z][A-Z0-9_]{2,} = \".*\";$" \
    | grep -Ev \
        -e "['\"] \+ ['\"]?" \
        -e ": ['\"]hsl\(" \
        -e ": ['\"]#[a-fA-F0-9]{6}['\"],$" \
    | sed -E \
        -e "/^e\..* = \"([A-Z_]+|[a-z/_-]+|[a-z]+[A-Z][a-z]+)\";/d" \
        -e "/^e\./ { \
            s/^e\.//; \
            s/ = /: /; \
            s/;$//; \
        }" \
    | sed -E \
        -e 's/,$//; s/$/,/' \
        -e "s/^(.+): \"/\"\1\": \"/" \
        -e "/^(.+): '(.*)',?/ { \
            s/\"/\\\\\"/g; \
            s/^(.+): '(.*)',?/\"\1\": \"\2\",/; \
            s/\\\'/'/g; \
            s/^\"\\\\\"/\"/ \
        }" \
        -e '1 { s/^/{/ }; $ { s/,$//; s/$/}/ }' \
        >"${taso}"

jq --indent 4 -S -s 'add' "${taso}" "${mama_replugged}" >"${pona}"

mv "${pona}" "$1"
rm -f "${mama}" "${taso}"
