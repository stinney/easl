#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my $f = shift @ARGV;
die unless -r $f;

my @f = `cat $f`; chomp @f;
my %f = ();
foreach (@f) {
    /\t(\S+)\t/;
    $f{$1} = $_;
}
open(S,'>01tmp/easl.sort'); print S join("\n", keys %f), "\n"; close(S);
my @s = `gdlx -g <01tmp/easl.sort 2>/dev/null`; chomp @s;
my %s = ();
my $x = 0;
foreach (@s) {
    $s{$_} = ++$x;
}

foreach (sort { $s{$a} <=> $s{$b} } keys %f) {
    print $f{$_}, "\n";
}

1;

################################################################################

