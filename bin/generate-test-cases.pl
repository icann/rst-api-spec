#!/usr/bin/env perl
use ICANN::RST;
use feature qw(say);
use strict;

say STDERR 'mirroring test specs...';
my $spec = (exists($ENV{RST_TEST_SPEC_VERSION}) ? ICANN::RST::Spec->new_from_version($ENV{RST_TEST_SPEC_VERSION}) : ICANN::RST::Spec->new);

say STDERR 'extracting test case mnemonics...';
my @cases = sort(map { $_->id } $spec->cases);

say STDERR 'generating YAML fragment for test cases...';
my $yaml = YAML::XS::Dump(\@cases);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
