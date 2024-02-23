#!/usr/bin/perl
use Data::Mirror qw(mirror_yaml);
use constant SPEC_URL => 'https://icann.github.io/rst-test-specs/rst-test-specs.yaml';
use feature qw(say);
use strict;

say STDERR 'mirroring test specs...';
my $spec = mirror_yaml(SPEC_URL) || die('mirror failed');

say STDERR 'extracting test plan mnemonics...';
my @plans = sort { $spec->{'Test-Plans'}->{$a}->{'Order'} <=> $spec->{'Test-Plans'}->{$b}->{'Order'} } keys(%{$spec->{'Test-Plans'}});

say STDERR 'generating YAML fragment for test plan mnemonics...';
my $yaml = YAML::XS::Dump(\@plans);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
