#!/bin/sh
SITEDIR="_site"

rm -rf "$SITEDIR"
mkdir -p "$SITEDIR/etc"

gpp etc/index.md | pandoc \
    --from markdown \
    --to html \
    --standalone \
    --embed-resources=true \
    --metadata title="ICANN Registry System Testing (RST) API Specification" \
    --css=etc/style.css \
    --output="$SITEDIR/index.html"

make spec

cp etc/*.svg "$SITEDIR/etc/"
cp tmp/*.yaml "$SITEDIR/"
cp tmp/*.json "$SITEDIR/"
cp etc/*.html "$SITEDIR/"
