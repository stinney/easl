#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";
use ORACC::XML;

use Getopt::Long;

GetOptions(
    );

my %o = (); # convenience data for o-info output

my @b = qw/uruk jn uqair umma misc/;
my @t = qw/g-c-3-X-s.tsv g-c-3-X-p-s.tsv g-c-3-X-u-s.tsv
      	   g-c-4-X-s.tsv g-c-4-X-p-s.tsv g-c-4-X-u-s.tsv/;
my %i = ();
my %n = ();

my %totali = ();
my %totaln = ();


my %u = (); my %useen = (); load_u();

foreach my $b (@b) {
    foreach my $t (@t) {
	my $f = $t;
	$f =~ s/X/$b/;
	warn "reading t/$f\n";
	csl_tsv($b, "t/$f");
    }
}

csl_xml();

################################################################################

sub csl_tsv {
    my($base,$file) = @_;
    my @t = `cat $file`; chomp @t;
    foreach (@t) {
	my($o,$y,$n,$f,$c,$s) = split(/\t/,$_);
	warn "noU\t$o\t$f\n" unless $u{$o} || $useen{$o}++;
	$o{$o} = [ $n , $s , $u{$o} ] unless $o{$o};
	$file =~ /-([34])-/;
	my $time = $1;
	if ($file =~ /-([pu])-/) {
	    if ($y eq 'n') {
		${${$n{$o}}{$base,$time,$1}} = [ $f, $c ];
	    } else {
		${${$i{$o}}{$base,$time,$1}} = [ $f, $c ];
	    }		
	} else {
	    if ($y eq 'n') {
		${${$n{$o}}{$base,$time}} = [ $f, $c ];
		$n{$o,'#'} += $c;
	    } else {
		${${$i{$o}}{$base,$time}} = [ $f, $c ];
		$i{$o,'#'} += $c;
	    }
	}
    }
}

sub csl_xml {
    print '<csltabs>';
    csl_xml_one('ideograms', \%i);
    csl_xml_one('numbers', \%n);
    print '</csltabs>';
}

sub csl_xml_base {
    my($h,$o,$b,$t,$y) = @_;
    my $d;
    if ($y) {
	$d = ${$$h{$o}}{$b,$t,$y};
    } else {
	$d = ${${$h}{$o}}{$b,$t};
    }
    if ($d) {
	my @d = @{$$d};
	my $xf = xmlify($d[0]);
	my $yattr = ($y ? " y=\"$y\"" : '');	
	print "<c t=\"$t\" y=\"$y\" f=\"$xf\" c=\"$d[1]\"/>";
    } else {
	print "<c/>";
    }
}

sub csl_xml_one {
    my($n,$h) = @_;
    print '<csltab n="',$n,'">';
    foreach my $o (sort { ${$o{$a}}[1] <=> ${$o{$b}}[1] } grep(!/#/, keys %$h)) {
	my $xn = xmlify(${$o{$o}}[0]);
	my $u = ${$o{$o}}[2] || '';
	print "<o oid=\"$o\" n=\"$xn\" s=\"${$o{$o}}[1]\" u=\"$u\" c=\"${$h}{$o,'#'}\">";
	foreach my $b (@b) {
	    print "<b n=\"$b\">";
	    csl_xml_base($h,$o,$b,'4','p');
	    csl_xml_base($h,$o,$b,'4','u');
	    csl_xml_base($h,$o,$b,'4','');
	    csl_xml_base($h,$o,$b,'3','p');
	    csl_xml_base($h,$o,$b,'3','u');
	    csl_xml_base($h,$o,$b,'3','');
	    print "</b>";
	}
	print '</o>';
    }
    print '</csltab>';    
}

sub load_u {
    my @u = `cut -f1,3 /home/oracc/pcsl/02pub/unicode.tsv`; chomp @u;
    foreach (@u) {
	my($u,$o) = split(/\t/,$_);
	$u{$o} = $u;
    }
}

1;
