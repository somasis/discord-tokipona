.DELETE_ON_ERROR:

noop: FRC
	@printf "%s\n" \
	    "jan kepeken li wile ala kepeken ilo \"make\"." \
	    "sina jan kepeken la, o lukin e lipu README."   \
	    "sina jan pali la, o kepeken ilo \"make dev\"." \
	    "[users don't need to run \"make\".]" \
	    "[if you're a user, look at the README.]" \
	    "[if you're a developer, use \"make dev\".]" \
	    >&2

manifest.json: index.js manifest.sh i18n/index.js i18n/timestamps.json i18n/tok.json
	./manifest.sh > manifest.json

dev: FRC manifest.json toki_mama_ale.json nimi_taso_lon_toki_ale.txt mama_pi_ante_toki.json mute
clean: FRC
	rm -f toki_mama_ale.json nimi_taso_lon_toki_ale.txt mama_pi_ante_toki.json

edit: FRC toki_mama_ale.json mama_pi_ante_toki.json
	${EDITOR} ./i18n/tok.json ./mama_pi_ante_toki.json ./toki_mama_ale.json

watch: FRC
	${MAKE} -s dev
	@rwc -p Makefile i18n/tok.json | xe -s " \
	    clear; \
	    ${MAKE} -s dev \
	        && PAGER=cat git diff ./i18n/tok.json ./mama_pi_ante_toki.json"

# o kama jo e nimi lon toki mama.
# pali kepeken nasin ni li ike mute. :(
# mi wile e ni: ilo Siko, o pana e toki lon nasin JSON taso tawa mi...
# [fetch original language keys.]
# [doing it this way is really bad. :(]
# [I want this: Discord, please give strings to me using JSON only...]
toki_mama_ale.json:
	./toki_mama.sh ./toki_mama_ale.json

# list of keys existing in both the translation and in original language
nimi_taso_lon_toki_ale.txt: toki_mama_ale.json i18n/tok.json
	./nimi_taso_lon_toki_ale.sh ./nimi_taso_lon_toki_ale.txt

# list of original language keys used as basis for the translation
mama_pi_ante_toki.json: nimi_taso_lon_toki_ale.txt toki_mama_ale.json
	./mama_pi_ante_toki.sh ./mama_pi_ante_toki.json

# calculate amount of translation completed
mute: FRC i18n/tok.json toki_mama_ale.json mama_pi_ante_toki.json
	@mute_ante=$$(jq -r 'keys[]' i18n/tok.json | wc -l); \
	mute_toki_mama=$$(jq -r 'keys[]' toki_mama_ale.json | wc -l); \
	    printf 'nimi lon ante toki pi ilo Siko: %s\n' "$${mute_ante}"; \
	    printf 'nimi lon toki mama: %s\n' "$${mute_toki_mama}"; \
	    printf 'mute pi ante toki: %s\n' \
	        "$$(printf 'scale=4; (%s/%s)*100.00/1.00\n' "$${mute_ante}" "$${mute_toki_mama}" \
	            | bc \
	            | sed 's/0*$$//g')%"

FRC:
