#!/usr/bin/perl
use Data::Mirror qw(mirror_yaml);
use constant SPEC_URL => 'https://icann.github.io/rst-test-specs/rst-test-specs.yaml';
use feature qw(say);
use strict;

my $url = $ENV{'RST_SPEC_URL'} || SPEC_URL;
printf(STDERR "mirroring test specs from %s...\n", $url);
my $spec = mirror_yaml($ENV{'RST_SPEC_URL'} || SPEC_URL) || die('mirror failed');

say STDERR 'extracting input parameter schemas...';
my $schema = {};
while (my ($name, $ref) = each(%{$spec->{'Input-Parameters'}})) {
    my %meta = %{$ref};

    if (exists($meta{'Schema'})) {
        $schema->{$name} = $meta{'Schema'};

    } else {
        $schema->{$name} = {
            'type' => ('file' eq $meta{'Type'} ? 'string' : $meta{'Type'}),
        };
    }

    $schema->{$name}->{'description'} = $meta{'Description'};

    $schema->{$name}->{'examples'} = [$meta{'Example'}] if (!defined($schema->{$name}->{'examples'}) && defined($meta{'Example'}));
}

say STDERR 'generating YAML fragment for input parameter schemas...';
$YAML::XS::SortKeys = 1;

my $yaml = YAML::XS::Dump($schema);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';
