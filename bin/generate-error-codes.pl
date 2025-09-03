#!/usr/bin/env perl
use ICANN::RST;
use feature qw(say);
use strict;

say STDERR 'mirroring test specs...';
my $spec = (exists($ENV{RST_TEST_SPEC_VERSION}) ? ICANN::RST::Spec->new_from_version($ENV{RST_TEST_SPEC_VERSION}) : ICANN::RST::Spec->new);

say STDERR 'extracting error codes...';
my @errors = sort map { $_->id } $spec->errors;

say STDERR 'generating YAML fragment for error codes...';
my $yaml = YAML::XS::Dump(\@errors);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
