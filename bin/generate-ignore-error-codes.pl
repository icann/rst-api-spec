#!/usr/bin/env perl
use ICANN::RST;
use feature qw(say);
use strict;

say STDERR 'mirroring test specs...';
my $spec = (exists($ENV{RST_TEST_SPEC_VERSION}) ? ICANN::RST::Spec->new_from_version($ENV{RST_TEST_SPEC_VERSION}) : ICANN::RST::Spec->new);

my $ignore = {};

say STDERR 'generating YAML fragment for ignoreErrorCodes...';

foreach my $case ($spec->cases) {
    $ignore->{$case->id} = {
        type => q{array},
        minItems => 1,
        items => {
            type => q{string},
            enum => [],
        }
    };

    my @errors =    grep { q{ERROR} eq $_->severity }
                    grep { q{RST_EXCEPTION} ne $_->id }
                    $case->errors;

    foreach my $error (@errors) {
        push(@{$ignore->{$case->id}->{items}->{enum}}, $error->id);
    }
}

my $yaml = YAML::XS::Dump($ignore);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
