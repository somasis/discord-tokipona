#!/bin/sh

# Generate manifest using a version based on time.

version=$(TZ=UTC date +%Y%m%d.%H%M%S)

jq -n \
    --arg name "toki pona" \
    --arg version "${version}" \
    --arg description "tenpo pi toki pona li lon a!" \
    --arg author "cominixo, jan Kali / Kylie McClain" \
    --arg license "MIT" \
    --arg website "https://github.com/somasis/discord-tokipona" \
    '$ARGS.named'
