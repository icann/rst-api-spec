#!/usr/bin/env perl
use File::Slurp;
use JSON::XS;
use constant ANNOTATION_KEY => q{x-field-extra-annotation};
use vars qw($JSON $VALUE);
use common::sense;

$JSON = JSON::XS->new->utf8->canonical->pretty;

$VALUE = $JSON->decode(join('', read_file($ARGV[0])));

unannotate($VALUE);

print $JSON->encode($VALUE);

sub unannotate {
    my $value = shift;

    if (q{HASH} eq ref($value)) {
        foreach my $key (keys(%{$value})) {
            if (lc($key) eq ANNOTATION_KEY) {
                delete($value->{$key});
            } else {
                unannotate($value->{$key});
            }
        }

    } elsif (q{ARRAY} eq ref($value)) {
        for (my $i = 0 ; $i < scalar(@{$value}) ; $i++) {
            unannotate($value->[$i]);
        }
    }
}
