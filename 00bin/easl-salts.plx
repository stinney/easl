#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %seen = ();

my @nc = `cat 00etc/nc-cdli.tsv`; chomp @nc;
my %nc = ();
foreach (@nc) {
    my($o,$p,$r,$s) = split(/\t/,$_);
    $nc{$o} = [ $p , $r , $s ];
}

my %r = ();
my %n = ();

my @oep = `cut -f1-3 00etc/easl.tsv`; chomp @oep;
foreach (@oep) {
    my($o,$e,$p) = split(/\t/,$_);
    if ($nc{$o}) {
	++$seen{$o};
	my($ncp,$ncr,$ncs) = @{$nc{$o}};
	if ($ncp ne $p) {
	    warn "$o: PCSL $p != NCV head $ncp\n";
	}
	my @su = ();
	foreach my $s (split(/(.)/,$ncs)) {
	    next unless $s;
	    push @su, sprintf("%X", ord($s));
	}
	$r{$e} = sprintf("%X", ord($ncr));
	$n{$e} = [ @su ];
    }
}

my @f = `cat 00raw/easl-frame.lst`;
open(F,'>00raw/easl-frame.lst');
foreach (@f) {
    next if /\./;
    chomp;
    if ($n{$_}) {
	print F $_, "\n";
	my $n = $#{$n{$_}} + 1;
	for (my $x = 1; $x <= $n; ++$x) {
	    print F "$_.$x\n";
	}
    } else {
	print F $_, "\n";
    }    
}
close(F);


my @c = `cat 00raw/easl-codes.tsv`; chomp @c;
open(C,'>00raw/easl-codes.tsv');
open(G,'>00raw/easl-glyph.tsv');
foreach (@c) {
    my($e,$u) = split(/\t/,$_);
    next if $e =~ /\./;
    if ($n{$e}) {
	print C "$e\t$r{$e}\n";
	print G "$e\t$r{$e}\n";
	my @s = @{$n{$e}};
	my $x = 1;
	for (my $i = 0; $i <= $#s; ++$i) {
	    print C "$e.$x\t$s[$i]\n";
	    ++$x;
	}
    } else {
	print C $_, "\n";
    }
}
close(C);
close(G);


foreach my $o (sort keys %nc) {
    warn "$o: NC head not in easl.tsv\n" unless $seen{$o};
}

1;

################################################################################

