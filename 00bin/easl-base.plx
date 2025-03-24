#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @nc = `cat 00etc/nc-cdli.tsv`; chomp @nc;
my %nc = (); foreach (@nc) {my @f=split(/\t/,$_); $nc{$f[0]} = $f[3];}
my @tags = `grep -v '^##' 00etc/easl-tags.tsv | cut -f1-2`; chomp @tags;
my %tags = (); foreach (@tags) {my($t,$o)=split(/\t/,$_);$tags{$o} = $t||'';}

open(B,">00etc/easl-base.tsv") || die; select B;
my @e = `cut -f -1,3-5,8 00etc/easl.tsv`; chomp @e;
foreach (@e) {
    my @f = split(/\t/,$_);
    if ($f[2] eq 'I') {
	my($o) = (/^(\S+)/);
	s/\t/\t$tags{$o}\t/;
	my $u = ''; s/\t(\S+)$/\t/; $u = $1;
	if ($nc{$o}) {
	    $_ .= $nc{$o};
	} else {
	    my $c = chr(hex($u));
	    $_ .= $c;
	}
	print $_, "\t/easl/images/$o.png\n";
    }
}
close(B);

1;

################################################################################

