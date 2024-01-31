#!/usr/bin/perl
use Data::Mirror qw(mirror_yaml);
use constant {
    SPEC_URL => 'https://raw.githubusercontent.com/icann/rst-test-specs/%s/rst-test-specs.yaml',
};
use strict;

my $branch = shift(@ARGV) || 'dev';

my $url = sprintf(SPEC_URL, $branch);

my $spec = mirror_yaml($url);

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

    # $schema->{$name}->{'examples'} = [$meta{'Example'}] if (exists($meta{'Example'}));
}

my $yaml = YAML::XS::Dump($schema);
$yaml =~ s/^-+\n//g;

print $yaml;
