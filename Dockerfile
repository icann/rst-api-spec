FROM minlag/mermaid-cli:latest

USER root

RUN ln -s /home/mermaidcli/node_modules/.bin/mmdc /usr/local/bin/

RUN apk update

RUN apk add --quiet \
    curl \
    yq \
    make \
    gcc \
    musl-dev \
    pandoc \
    perl-file-slurp \
    perl-app-cpanminus \
    perl-lwp-protocol-https \
    perl-json-xs \
    perl-text-csv_xs \
    perl-xml-libxml \
    perl-yaml \
    perl-yaml-libyaml

RUN cpanm --quiet Data::Mirror

RUN <<END
wget -qO - https://github.com/logological/gpp/releases/download/2.28/gpp-2.28.tar.bz2 | tar xj
cd gpp-2.28
./configure --quiet
make install
rm -rf ../gpp-2.28
END

ENTRYPOINT ["docker-entrypoint.sh"]

USER mermaidcli
