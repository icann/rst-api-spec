#!/usr/bin/env perl
use ICANN::RST;
use feature qw(say);
use strict;

say STDERR 'mirroring test specs...';
my $spec = (exists($ENV{RST_TEST_SPEC_VERSION}) ? ICANN::RST::Spec->new_from_version($ENV{RST_TEST_SPEC_VERSION}) : ICANN::RST::Spec->new);

say STDERR 'extracting test plan mnemonics...';
my @plans = map { $_->id } sort { $a->{'Order'} <=> $b->{'Order'} } $spec->plans;

say STDERR 'generating YAML fragment for test plan mnemonics...';
my $yaml = YAML::XS::Dump(\@plans);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
