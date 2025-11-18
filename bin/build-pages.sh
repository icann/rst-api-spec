#!/bin/sh
SITEDIR="_site"

rm -rf "$SITEDIR"
mkdir -p "$SITEDIR"

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

echo "Syncing spec files..."
git tag | grep "^v" | while read RELEASE ; do
    for extn in yaml json ; do
        curl --silent --fail --location --output "$SITEDIR/rst-api-spec-$RELEASE.$extn" "https://github.com/icann/rst-api-spec/releases/download/$CURRENT_RELEASE/rst-api-spec.$extn"
    done
done

echo "Creating Swagger UI file..."
gpp "-DRELEASE=$CURRENT_RELEASE" etc/rst-api-spec.html \
    > "$SITEDIR/rst-api-spec.html"

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
