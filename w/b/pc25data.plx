#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my $header = 0;

GetOptions(
    header=>\$header,
    );

if ($header) {
    print "pc25u\tpc25c\tap24u\tap24c\tpc25pcsl\tap24pcsl\tpc25uname\tap24uname\toid\n";
    exit 0;
}

my %ap24 = ();
my @ap24 = `cat ~/orc/pcsl/00etc/ap24-repertoire.tsv`; chomp @ap24;
foreach (@ap24) { my($o,$u,$p,$n) = split(/\t/, $_); $ap24{$u} = [ $p, $n] }

my %pc25 = ();
my @pc25 = `cat ~/orc/pcsl/pc25/pc25-repertoire.tsv`; chomp @pc25;
foreach (@pc25) { my($nu, $oc, $ou, $nn, $o, $p) = split(/\t/,$_); $pc25{$ou} = [ $nu, $nn, $o, $p ] }

my %seen = ();

foreach my $ou (sort keys %pc25) {
    my %data = ();
    if ($ap24{$ou}) {
	my($p,$n) = @{$ap24{$ou}};
	$data{'ap24p'} = $p;
	$data{'ap24n'} = $n;
    } else {
	$data{'ap24p'} = $data{'ap24n'} = '';
    }
    my($nu,$nn,$o,$np) = @{$pc25{$ou}};
    $nn =~ s/PROTO-CUNEIFORM SIGN //;
    $data{'pc25u'} = $nu;
    $data{'pc25n'} = $nn;
    $data{'pc25o'} = $o;
    $data{'pc25p'} = $np;
    printf "$data{'pc25u'}\t%c\t$ou\t%c\t$data{'pc25p'}\t$data{'ap24p'}\t$data{'pc25n'}\t$data{'ap24n'}\t$data{'pc25o'}\n", hex($data{'pc25u'}), hex($ou);
}

1;

################################################################################

