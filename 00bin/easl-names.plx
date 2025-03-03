#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my $SL = 'easl';
my %n = ();
my @e = `cut -f3,8 00etc/${SL}.tsv | rocox -C21 | sed 's/~v[0-9]//g'`; chomp @e;
foreach (@e) { my($u,$n)=split(/\t/,$_); unless ($u =~ /^x/) { $n{$u} = $n }}

my @u = `cut -f1-2 /home/oracc/pcsl/02pub/unicode.tsv | sed 's/^U+//' | sed 's/~v[0-9]//g'`; chomp @u;
foreach (@u) { my($u,$n)=split(/\t/,$_); unless ($u =~ /^x/) {$n{$u} = $n unless $n{$u}} }

my @a = `cut -f2-3 /home/stinney/orc/pcsl/00etc/ap24-repertoire.tsv`; chomp @a;
foreach (@a) { my($u,$n)=split(/\t/,$_); unless ($u =~ /^x/) {$n{$u} = $n unless $n{$u}} }


foreach (sort keys %n) {
    print "$_\t$n{$_}\n";
}

1;

################################################################################

