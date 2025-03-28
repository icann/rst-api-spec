#!/usr/bin/env perl
use ICANN::RST;
use feature qw(say);
use strict;

$YAML::XS::Boolean = q{JSON::PP};

say STDERR 'mirroring test specs...';
my $spec = (exists($ENV{RST_TEST_SPEC_VERSION}) ? ICANN::RST::Spec->new_from_version($ENV{RST_TEST_SPEC_VERSION}) : ICANN::RST::Spec->new);

say STDERR 'extracting input parameter schemas...';
my $schema = {};
foreach my $input ($spec->inputs) {

    if (!exists($input->{Schema})) {
        printf(STDERR "missing schema for '%s'\n", $input->id);
        exit(1);

    } else {
        $schema->{$input->id} = $input->{Schema};

    }

    $schema->{$input->id}->{'description'} = $input->{Description};
    $schema->{$input->id}->{'example'} = $input->example if (exists($input->{'Example'}));

    munge_schema($schema->{$input->id});
}

say STDERR 'generating YAML fragment for input parameter schemas...';
$YAML::XS::SortKeys = 1;

my $yaml = YAML::XS::Dump($schema);
$yaml =~ s/^-+\n//g;

print $yaml;

say STDERR 'done';

sub munge_schema {
    my $schema = shift;

    if (!exists($schema->{example}) && exists($schema->{default})) {
        $schema->{example} = $schema->{default};
    }

    if ('url' eq $schema->{format}) {
        $schema->{'x-constraints'} = '@ValidUrl';

    } elsif ('array' eq $schema->{type}) {
        if ('ipv4' eq $schema->{items}->{format}) {
            $schema->{'x-constraints'} = '@ValidIpv4List';

        } elsif ('ipv6' eq $schema->{items}->{format}) {
            $schema->{'x-constraints'} = '@ValidIpv6List';

        } else {
            munge_schema($schema->{items}) if ($schema->{items});

        }

    } elsif ('object' eq $schema->{type}) {
        foreach my $property (keys(%{$schema->{properties}})) {
            munge_schema($schema->{properties}->{$property});
        }
    }
}
