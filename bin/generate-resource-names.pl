#!/usr/bin/perl
use URI;
use File::Basename qw(dirname);
use File::Spec;
use Cwd qw(abs_path);
use YAML::XS;
use List::Util qw(uniq);
use Data::Mirror qw(mirror_yaml);
use constant SPEC_URL => 'https://icann.github.io/rst-test-specs/rst-test-specs.yaml';
use feature qw(say);
use strict;

say STDERR 'extracting server URLs from API spec...';
my $apiSpec = YAML::XS::LoadFile(File::Spec->catfile(dirname(dirname(__FILE__)), 'rst-api-spec.yaml.in'));
my @servers = map { URI->new($_->{'url'}) } @{$apiSpec->{'servers'}};

say STDERR 'mirroring test specs...';
my $spec = mirror_yaml($ENV{'RST_SPEC_URL'} || SPEC_URL) || die('mirror failed');

say STDERR 'extracting resource names...';
my @names;
RESOURCE: foreach my $resource (values(%{$spec->{'Resources'}})) {
    if ($resource->{'URL'}) {
        my $url = URI->new($resource->{'URL'});

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
$yaml =~ s/^-+ //g;

print $yaml;

say STDERR 'done';
