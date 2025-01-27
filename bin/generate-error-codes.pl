#!/usr/bin/env perl
use Data::Mirror qw(mirror_yaml);
use constant SPEC_URL => 'https://icann.github.io/rst-test-specs/rst-test-specs.yaml';
use feature qw(say);
use strict;

my $url = $ENV{'RST_SPEC_URL'} || SPEC_URL;
printf(STDERR "mirroring test specs from %s...\n", $url);
my $spec = mirror_yaml($url) || die('mirror failed');

say STDERR 'extracting error codes...';
my @errors = sort keys(%{$spec->{'Errors'}});

say STDERR 'generating YAML fragment for error codes...';
my $yaml = YAML::XS::Dump(\@errors);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
