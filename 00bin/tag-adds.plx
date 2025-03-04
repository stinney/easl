#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my $tag = shift @ARGV; $tag =~ s/\\//;
my $src = shift @ARGV;

if ($tag !~ /^[-+1345cdin]$/) {
    die "$0: bad tag $tag\n";
}
if (!-r $src) {
    die "$0: bad src $src\n";
}

my %add = ();
my @src = `cat $src`; chomp @src;
foreach (@src) {
    /(o09\d{5})/ && ++$add{$1};
}

my @tags = `cat 00etc/easl-tags.tsv`;
foreach (@tags) {
    my($o9) = (/(o09\d{5})/);
    if ($o9 && $add{$o9}) {
	s/^/$tag/;
    }
}
open(E,'>00etc/easl-tags.tsv') || die;
print E @tags;
close(E);

1;

################################################################################

