#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

SITEDIR="_site"
TMPDIR="tmp"

rm -rf "$SITEDIR"
mkdir -p "$SITEDIR" "$TMPDIR"

git config --global --add safe.directory /app

CURRENT_RELEASE="$(git tag | tail -1)"

if [ -z "$CURRENT_RELEASE" ] ; then
    echo "No release tag found! Tag list follows..."
    git tag --list
    exit 1
fi

echo "Current release is $CURRENT_RELEASE"

echo "Creating index file..."
gpp -x "-DRELEASE=$CURRENT_RELEASE" etc/index.md | pandoc \
    --from markdown \
    --to html \
    --standalone \
    --embed-resources=true \
    --metadata title="ICANN Registry System Testing (RST) API Specification" \
    --css=etc/style.css \
    --output="$SITEDIR/index.html"

echo "Retrieving list of releases..."
curl --fail --silent https://api.github.com/repos/icann/rst-api-spec/releases > "$TMPDIR/releases.json"

echo "Syncing historical releases..."

pushd "$SITEDIR" > /dev/null

jq -r '.[] | .assets[] | .browser_download_url' "../$TMPDIR/releases.json" | \
    wget \
        --mirror \
        --quiet \
        --input-file - \
        --no-host-directories \
        --cut-dirs 4

popd > /dev/null

echo "Generating release list..."

echo -n > "$TMPDIR/releases.md"

jq -r '.[] | "* [" + .name + "](/rst-api-spec.html?version=" + .name + ") (" + (.published_at | fromdate | strftime("%B %e, %Y")) + ")"' tmp/releases.json > tmp/releases.md
printf "\n\n<< [Back](.)\n" >> "$TMPDIR/releases.md"

pandoc \
    --from markdown \
    --to html \
    --standalone \
    --embed-resources=true \
    --metadata title="List of API Spec Releases" \
    --css=etc/style.css \
    --output="$SITEDIR/releases.html" \
    "$TMPDIR/releases.md"

echo "Creating Swagger UI file..."

gpp "-DRELEASE=$CURRENT_RELEASE" etc/rst-api-spec.html > "$SITEDIR/rst-api-spec.html"

echo "Installing Swagger UI libraries..."
SWAGGER_TMPDIR="_swagger_ui_tmp"
rm -rf "$SWAGGER_TMPDIR"
mkdir "$SWAGGER_TMPDIR"

SWAGGER_UI_TAR=$(curl --silent --fail https://api.github.com/repos/swagger-api/swagger-ui/releases/latest | jq -r .tarball_url)

curl --silent --location --fail --output "$SWAGGER_TMPDIR/swagger.tgz" "$SWAGGER_UI_TAR"

cd "$SWAGGER_TMPDIR"
tar zx --strip-components 1 -f swagger.tgz
cd ..

mv "$SWAGGER_TMPDIR/dist" "$SITEDIR/swagger-ui"

rm -rf "$SWAGGER_TMPDIR"

echo "done"
