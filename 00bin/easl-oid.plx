#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %oidforce = (
    '|DUG~bxU2~b|'=>'o0900450'
    );

my @o = `cat 00etc/o-p-e.tsv`; chomp @o;
my %o = (); my %oo = ();
foreach (@o) {
    my($o,$p,$e) = split(/\t/,$_);
    $o{$e} = [ $o , $p ] unless $o{$e};
    $oo{$o} = [ $e , $p ];
}

my %seen = ();
my @e = `cat 01tmp/easl-gh.tsv`; chomp @e;
my %e = ();
foreach (@e) {
    my($t,$n,$f) = split(/\t/,$_); # $e,
    $n =~ s/\|3$/3|/;
    my $nn = $n; $nn =~ tr/|//d;
    my $nnn = $n; $nnn =~ tr/'/’/;
    my $o = '';
    if ($oidforce{$n}) {
	$o = [ $oidforce{$n} , ${$oo{$oidforce{$n}}}[1] ];
    } elsif ($o{$n}) {
	$o = $o{$n};
    } elsif ($o{$nn}) {
	$o = $o{$nn};
    } elsif ($o{$nnn}) {
	$o = $o{$nnn};
    } else {
	warn "$n not found in o-p-e.tsv\n";
    }
    my ($po, $pp) = @$o;
    print "$po\t$pp\t$_\n";
    ++$seen{$po};
}

#open(D,'>seen.dump'); print D Dumper \%seen; close(D);

#open(S,'>00etc/salt-oid.tsv');
#foreach (sort keys %oo) {
#    unless ($seen{$_}) {
#	my ($e,$p) = @{$oo{$_}};
#	print S "$_\t$e\t$p\n";
#    }
#}
#close(S);

1;
