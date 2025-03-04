#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @map = `cut -f1,3 ../pcsl/00etc/oid-sl-n-pc.tsv`; chomp @map;
my @map2 = `cat 00etc/more-sl-pc-map.tsv`; chomp @map2;
my %map = (); foreach (@map, @map2) { my($sl,$pc) = split(/\t/,$_); $map{$sl} = $pc }

while (<>) {
    s/(o0[0-3]\d+)/trymap($1)/eg;
    print;
}

1;

################################################################################

sub trymap {
    my $m = shift;
    my $r = $m;
    if ($map{$m}) {
	$r = $map{$m};
    } else {
	warn "$m not in map\n";
    }
    $r;
}
