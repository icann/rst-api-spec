#!/usr/bin/perl
use Data::Mirror qw(mirror_yaml);
use constant SPEC_URL => 'https://icann.github.io/rst-test-specs/rst-test-specs.yaml';
use feature qw(say);
use strict;

say STDERR 'mirroring test specs...';
my $spec = mirror_yaml($ENV{'RST_SPEC_URL'} || SPEC_URL) || die('mirror failed');

say STDERR 'extracting input parameter schemas...';
my $schema = {};
while (my ($name, $ref) = each(%{$spec->{'Input-Parameters'}})) {
    my %meta = %{$ref};

    if (!exists($meta{'Schema'})) {
        printf(STDERR "missing schema for '%s'\n", $name);
        exit(1);

    } else {
        $schema->{$name} = $meta{'Schema'};

    }

    $schema->{$name}->{'description'} = $meta{'Description'};
    $schema->{$name}->{'example'} = $meta{'Example'} if (exists($meta{'Example'}));
}

say STDERR 'generating YAML fragment for input parameter schemas...';
$YAML::XS::SortKeys = 1;

my $yaml = YAML::XS::Dump($schema);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
