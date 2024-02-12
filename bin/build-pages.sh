#!/bin/sh
SITEDIR="_site"

rm -rf "$SITEDIR"
mkdir -p "$SITEDIR/etc"

pandoc \
    --from markdown \
    --to html \
    --standalone \
    --embed-resources=true \
    --metadata title="ICANN Registry System Testing (RST) API Specification" \
    --css=etc/style.css \
    --output="$SITEDIR/index.html" \
    README.md

make diagrams spec

cp tmp/*.svg "$SITEDIR/etc/"
cp tmp/*.yaml "$SITEDIR/"
cp etc/*.html "$SITEDIR/"
