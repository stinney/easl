#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @o = `cat o-p-e.tsv`; chomp @o;
my %o = ();
foreach (@o) {
    my($o,$p,$e) = split(/\t/,$_);
    $o{$e} = [ $o , $p ];
}
my @e = `cat easl.tsv`; chomp @e;
my %e = ();
foreach (@e) {
    my($e,$t,$n,$f) = split(/\t/,$_);
    $n =~ s/\|3$/3|/;
    my $nn = $n; $nn =~ tr/|//d;
    my $nnn = $n; $nnn =~ tr/'/’/;
    my $o = '';
    if ($o{$n}) {
	$o = $o{$n};
    } elsif ($o{$nn}) {
	$o = $o{$nn};
    } elsif ($o{$nnn}) {
	$o = $o{$nnn};
    } else {
	warn "$e: $n not found in o-p-e.tsv\n";
    }
    my ($po, $pp) = @$o;
    print "$po\t$pp\t$_\n";
}

1;
