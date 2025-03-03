#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @o = `cut -f1,3 00etc/easl.tsv`; chomp @o;
my %o = (); foreach (@o) { my($o,$e)=split(/\t/,$_); $o{$o} = $e }

my @g = `cat ../pcsl/00etc/glyf.tsv`; chomp @g;
foreach (@g) {
    my($o,$s) = split(/\t/,$_);
    if ($o{$o}) {
	my @s = split(/\s+/, $s);
	my $x = 1;
	foreach my $xs (@s) {
	    s/^\S+\s+//;
	    my($o,$u) = split(/:/,$_);
	}
    } else {
	warn "OID $o not found in 00etc/easl.tsv\n";
    }
}

1;

################################################################################

