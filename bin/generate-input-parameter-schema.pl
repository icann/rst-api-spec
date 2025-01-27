#!/usr/bin/env perl
use Data::Mirror qw(mirror_yaml);
use constant SPEC_URL => 'https://icann.github.io/rst-test-specs/rst-test-specs.yaml';
use feature qw(say);
use strict;

$YAML::XS::Boolean = q{JSON::PP};

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

    add_constraints($schema->{$name});
}

say STDERR 'generating YAML fragment for input parameter schemas...';
$YAML::XS::SortKeys = 1;

my $yaml = YAML::XS::Dump($schema);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';

sub add_constraints {
    my $schema = shift;

    if ('url' eq $schema->{format}) {
        $schema->{'x-constraints'} = '@ValidUrl';

    } elsif ('array' eq $schema->{type}) {
        if ('ipv4' eq $schema->{items}->{format}) {
            $schema->{'x-constraints'} = '@ValidIpv4List';

        } elsif ('ipv6' eq $schema->{items}->{format}) {
            $schema->{'x-constraints'} = '@ValidIpv6List';

        } else {
            add_constraints($schema->{items}) if ($schema->{items});

        }

    } elsif ('object' eq $schema->{type}) {
        foreach my $property (keys(%{$schema->{properties}})) {
            add_constraints($schema->{properties}->{$property});
        }
    }
}
