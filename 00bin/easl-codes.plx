#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %map = (
    '1(N30CB)' => '1(N30C~b)'
    );

my @a = `cat ../pcsl/00etc/ap24toap23.tsv` ; chomp @a;
my %a = ();
foreach (@a) {
    my($a,$a23,$a24,$a25) = split(/\t/,$_);
    $a{$a} = [ $a, $a23, $a24, $a25 ];
    my $anov = $a;
    if ($anov =~ s/~v\d+//g) {
	$a{$anov} = [ $a, $a23, $a24, $a25 ];
    }
    if ($map{$a}) {
	$a{$map{$a}} = [ $map{$a}, $a23, $a24, $a25 ];
    }
}

my %seen = ();

my @e = `cat 01tmp/easl-numbered.tsv`; chomp @e;
foreach (@e) {
    my($o,$e,$p,@rest) = split(/\t/, $_);
    my $ok;
    if ($a{$p}) {
	++$seen{$ok=$p};
	my $x = ${$a{$p}}[0];
	++$seen{$x};
    } else {
	my $pv = "$p~v";
	if ($a{$pv}) {
	    ++$seen{$ok=$pv};
	    my $x = ${$a{$pv}}[0];
	    ++$seen{$x};
	} else {
	    my $pnov = $p;
	    if ($pnov =~ s/~v\d+// && $a{$pnov}) {
		++$seen{$ok=$pnov};
		my $x = ${$a{$pnov}}[0];
		++$seen{$x};
	    } else {
		warn "$p/$pv not found in easl.tsv\n";
		$ok = 'BAD';
	    }
	}
    }
    my($a,$a23,$a24,$a25) = @{$a{$ok}};
    $a25 = '' unless $a25;
    print "$_\t$a23\t$a24\t$a25\n";
}

open(C,'>00etc/salt-codes.tsv');
foreach my $a (@a) {
    $a =~ s/\t.*$//;
    $a = $map{$a} if $map{$a};
    my($x,$a23,$a24,$a25) = @{$a{$a}};
    $a25 = '' unless $a25;
    print C "$a\t$a23\t$a24\t$a25\n" unless $seen{$a};
}
close(C);
1;

################################################################################

