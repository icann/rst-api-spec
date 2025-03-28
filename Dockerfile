FROM alpine:latest

RUN apk update

RUN apk add --quiet \
    git \
    curl \
    jq \
    yq \
    make \
    gcc \
    musl-dev \
    pandoc \
    graphviz \
    perl-dev \
    perl-datetime \
    perl-file-slurp \
    perl-app-cpanminus \
    perl-lwp-protocol-https \
    perl-json-xs \
    perl-text-csv_xs \
    perl-text-unidecode \
    perl-xml-libxml \
    perl-yaml \
    perl-yaml-libyaml

RUN cpanm --notest --quiet https://cpan.metacpan.org/authors/id/G/GB/GBROWN/ICANN-RST-0.03.tar.gz

RUN <<END
wget -qO - https://github.com/logological/gpp/releases/download/2.28/gpp-2.28.tar.bz2 | tar xj
cd gpp-2.28
./configure --quiet
make install
rm -rf ../gpp-2.28
END
