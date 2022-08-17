#!/bin/sh

# Generate manifest using a version based on commit count

version=$(git rev-list --count HEAD -- index.js i18n)

# if worktree state is dirty, add one so it's the same after committing
if git diff-files --quiet; then
    version=$((version + 1))
fi

jq -n \
    --arg name "toki pona" \
    --arg version "${version}" \
    --arg description "tenpo pi toki pona li lon a!" \
    --arg author "cominixo, jan Juli / Kylie McClain" \
    --arg license "MIT" \
    --arg website "https://github.com/somasis/discord-tokipona" \
    '$ARGS.named'
