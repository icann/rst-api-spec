#!/usr/bin/env perl
use URI;
use File::Basename qw(dirname);
use File::Spec;
use Cwd qw(abs_path);
use YAML::XS;
use ICANN::RST;
use List::Util qw(uniq);
use feature qw(say);
use strict;

say STDERR 'extracting server URLs from API spec...';
my $apiSpec = YAML::XS::LoadFile(File::Spec->catfile(dirname(dirname(__FILE__)), 'rst-api-spec.yaml.in'));
my @servers = map { URI->new($_->{'url'}) } @{$apiSpec->{'servers'}};

say STDERR 'mirroring test specs...';
my $spec = (exists($ENV{RST_TEST_SPEC_VERSION}) ? ICANN::RST::Spec->new_from_version($ENV{RST_TEST_SPEC_VERSION}) : ICANN::RST::Spec->new);

say STDERR 'extracting resource names...';
my @names;
RESOURCE: foreach my $resource ($spec->resources) {
    if ($resource->{'URL'}) {
        my $url = $resource->url;

        foreach my $server (@servers) {
            if ($server->authority eq $url->authority) {
                push(@names, [$url->path_segments]->[-1]);
                next RESOURCE;
            }
        }
    }
}

if (scalar(@names) < 1) {
    say STDERR 'no resources found!';
    exit(1);
}

say STDERR 'generating YAML fragment for resource names...';
my $yaml = YAML::XS::Dump([sort(uniq(@names))]);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
