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

my $sl = 'easl'; my $SL = 'EASL';
my @sl = ();

my $fm = "$sl-codes.tsv";
my %fm = load_map($fm, 1, 0); my %fm_seen = ();

my $nm = "$sl-notes.tsv";
my %nm = load_map($nm,0, 0);

my $rm = "$sl-rows.tsv";
my %rm = load_map($rm, 1, 0); my %rm_seen = ();

my $sm = "$sl-names.tsv";
my %sm = load_map($sm, 0, 0);

my $tm = "$sl-tags.tsv";
my %tm = load_map($tm, 0, 0);

my $om = "$sl-oids.tsv";
my %om = load_map($om, 0, 0);

my %f = ();
my %seen = ();
my $sign_flag = 0;
my %subseen = ();

while (<>) {
    chomp;
    warn "$0: duplicate slframe entry $_\n" and next if $seen{$_}++;
    $sign_flag = s/◀//;
    my($sl,$num,$sub,$feat) = (/^($SL)(\d{3,4})(·?[a-z]+)?(\.\S+)?/o);
    $sub = '-' unless $sub;
    $feat = '-' unless $feat;
    if ($sl) {
	my $ln = "$sl$num";
	if ($sign_flag) {
	    $ln .= $sub;
	    $sub = '';
	}
	push @sl, $ln unless $f{$ln};
	push @{${$f{$ln}}{$sub}}, $feat;
    } else {
	warn "unexpected form $_\n";
    }
}

gapcheck('stdin',@sl);

print "<sl n=\"$sl\">";
#foreach (sort { $a <=> $b } keys %f) {
foreach (@sl) {

    my $ln = $_;

    my $o = $om{$ln};
    if ($o) {
	$o = " oid=\"$o\"";
    } else {
	$o = '';
    }
    
    my $r = $rm{$ln};
    if ($r) {
	++$rm_seen{$ln};
	$r = " row=\"$r\"";
    } else {
	$r = '';
    }

    my $t = $tm{$ln};
    my $seq = '';
    my $not = '';
    if ($t) {
	$t = " tags=\"$t\"";
	if ($t =~ /([.:!])/) {
	    $seq = " seq=\"$1\"";
	}
	if ($t =~ /[-15di\#]/) {
	    $not = " not=\"1\"";
	}
    } else {
	$t = '';	
    }
    
    print "<sign n=\"$ln\" xml:id=\"s.$ln\"$o$t$seq$not$r>";
    my @subs = keys %{$f{$ln}};
    foreach my $s (sort @subs) {
	my $ss = ($s eq '-' ? '' : $s);
	my $fc = ''; # feature class
	my $c = ''; # character
	my $sn = ''; # sign name
	my $k = "$ln$ss";
	my $ku = $fm{$k};
	++$fm_seen{$k};
	my $kup = '';
	$kup = " u=\"$ku\"" if $ku;
	($fc,$c,$sn) = feachr($ku) if $ku;
	print "<s xml:id=\"$k\"$kup$fc$c$sn>";
	if (${$f{$ln}}{$s}) {
	    $fc = $c = $sn = '';
	    my @f = sort @{${$f{$ln}}{$s}};
	    foreach my $f (grep (!/^-$/, @f)) {
		my $fk = "$ln$ss$f";
		my $fu = $fm{$fk};
		++$fm_seen{$fk};
		($fc,$c,$sn) = feachr($fu) if $fu; # $sn ignored in <f>
		my $fup = '';
		$fup = " u=\"$fu\"" if $fu;
		print "<f xml:id=\"$fk\"$fup$fc$c/>";
	    }
	}
	if ($nm{$k}) {
	    my $xn = xmlify($nm{$k});
	    print "<n>$xn</n>";
	}
	print "</s>";
    }
    print '</sign>';
}
print '</sl>';

foreach my $f (sort keys %fm) {
    warn "$fm: unused sign $f\n" unless $fm_seen{$f};
}

foreach my $r (sort keys %rm) {
    warn "$rm: unused row $r\n" unless $rm_seen{$r};
}

1;

################################################################################

sub feachr {
    my $h = $_[0];
    my $c = '';
    my $fc = '';
    my $sn = '';
    $h =~ s/^[-*]$//;
    if ($h) {
	$h =~ tr/*//d;
	$fc = ''; # feature class
	if ($h =~ s/\.(.*)$//) {
	    my $f = $1;
	    $f = "salt$f" if $f =~ /^\d/;
	    $fc = " class=\"$f\"";
	}
	warn "bad hex $h\n" unless $h =~ /^[0-9A-F]+$/;
	$c = sprintf(" c=\"%c\"", hex($h));
	if ($sm{$h}) {
	    my $xn = xmlify($sm{$h});
	    $sn = " sn=\"$xn\"";
	} else {
	    warn "$sm: no name found for $h\n";
	}
    }
    ($fc,$c,$sn);
}


# gapcheck can be subverted by adding dummy entries to the data field;
# these consist of a single hyphen, -
sub gapcheck {
    my $e = shift;
    my $n = 0;
    my $last = '';
    foreach (@_) {
	my ($x,$s) = (/(\d+)([a-z]*(?:\.\d)?)?/);
	if ($x != $n) {
	    warn "$_ - $last != 1\n" unless $x - $n == 1;
	    $n = $x;
	    $last = $_;
	}
    }
}

# A map must begin with the SLKEY and at least one data field it can
# contain more fields which are ignored here.
sub load_map {
    my ($m,$gapc,$must) = @_;
    my %m = ();
    if (-r $m || $must) {
	my @m = ();
	open(M,$m) || die "$0: unable to open map $m\n";
	while (<M>) {
	    chomp;
	    my($s,$u) = split(/\t/,$_);
	    if ($s && $u) {
		if ($m{$s}) {
		    warn "$m:$.: duplicate map entry $s\n";
		} else {
		    push @m, $s;
		    $m{$s} = $u unless $u eq '-';
		}
	    } else {
		warn "$m:$.: malformed map entry\n";
	    }
	}
	close(M);
	gapcheck($m, @m)
	    if $gapc;
    }
    %m;
}
