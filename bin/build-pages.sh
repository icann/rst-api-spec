#!/bin/sh
SITEDIR="_site"

rm -rf "$SITEDIR"
mkdir -p "$SITEDIR/etc"

git config --global --add safe.directory /app

CURRENT_RELEASE="$(git tag | tail -1)"

gpp -x "-DRELEASE=$CURRENT_RELEASE" etc/index.md | pandoc \
    --from markdown \
    --to html \
    --standalone \
    --embed-resources=true \
    --metadata title="ICANN Registry System Testing (RST) API Specification" \
    --css=etc/style.css \
    --output="$SITEDIR/index.html"

gpp "-DRELEASE=$CURRENT_RELEASE" etc/rst-api-spec.html \
    > "$SITEDIR/rst-api-spec.html"

cp etc/*.svg "$SITEDIR/etc/"

git tag | grep "^v" | while read RELEASE ; do
    curl --silent --fail --location --output "$SITEDIR/rst-api-spec-$RELEASE.yaml" "https://github.com/icann/rst-api-spec/releases/download/$RELEASE/rst-api-spec.yaml"
    curl --silent --fail --location --output "$SITEDIR/rst-api-spec-$RELEASE.json" "https://github.com/icann/rst-api-spec/releases/download/$RELEASE/rst-api-spec.json"
done
