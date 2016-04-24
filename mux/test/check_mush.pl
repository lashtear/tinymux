#! /usr/bin/perl

use strict;
use warnings;

use Expect;
use List::Util qw(shuffle);
use Math::BigFloat;

$| = 1;
my $timeout=1.5;

my ($host, $port) = @ARGV;
$host ||= 'localhost';
$port ||= 22860;
$port =~ /^\d+$/ or $port = 22860;
my $rc = 0;

sub notok {
    my $msg = shift;
    print "not ok - $msg\n";
    print "Bail out!\n";
    exit 1;
}

sub waitfor {
    my ($exp, $re, $msg) = @_;
    warn "#   waiting for $msg\n";
    $exp->expect ($timeout,
		  ['timeout', sub { notok ("timeout before $msg")}],
		  ['eof', sub { notok ("EOF before $msg")}],
		  [$re]);
    print "ok - $msg\n";
}

sub match_keyword {
    my ($exp, $vref, $name) = @_;
    $$vref = ($exp->matchlist)[0];
    warn "#   received $name\n";
    exp_continue;
}

sub new_expector {
    my $exp = Expect->new();
    $exp->raw_pty(1);
    $exp->slave->stty(qw(raw -echo));
    $exp->log_user(0);
    $exp->spawn('telnet', $host, $port) or die "not ok - unable to launch telnet";
    $exp->exp_internal(1);
    return $exp;
}

sub bt {
    my ($exp, $out, $in, $comment) = @_;
    warn "# bt $comment\n";
    $exp->send ("$out\r\n") if defined $out;
    waitfor ($exp, $in, $comment);
}
use Carp qw(confess);
$SIG{'__DIE__'} = \&confess;
my $wiz = new_expector();
bt ($wiz, undef, qr/This is connect\.txt/, "connect banner");
bt ($wiz, "INFO", qr/### Begin INFO( [0-9.]+)?\r\n/, "INFO header");

my ($conn, $size, $ver);
my $in_info = 1;
while ($in_info) {
    $wiz->expect ($timeout,
		  ['timeout', sub { notok ('timeout during INFO response'); }],
		  ['eof', sub { notok ('EOF during INFO response'); }],
		  [qr/Connected: (\d+)\r\n/,
		   sub {match_keyword ($wiz, \$conn, "connected")}],
		  [qr/Size: (\d+)\r\n/,
		   sub {match_keyword ($wiz, \$size, "size")}],
		  [qr/Version: (.+)\r\n/,
		   sub {match_keyword ($wiz, \$ver, "version")}],
		  [qr/### End INFO/,
		   sub {$in_info = 0}]);
}
if (defined $conn
    and defined $size
    and defined $ver) {
    print "ok - mush up and responding to info: $ver, $conn connected, $size objects\n";
} else {
    notok ('received mangled info');
}

bt ($wiz, "connect Wizard potrzebie", qr/^This is motd\.txt\r?$/m, "motd");
bt ($wiz, undef, qr/^This is wizmotd\.txt\r?$/m, "wizmotd");
bt ($wiz, "\@restart", qr/^Server just started\. Please try again in a few seconds.\r?$/m, "restart-blocked");
bt ($wiz, "give me=10000", qr/^You give 10000 Pennies to Wizard.\r\nWizard gives you 10000 Pennies.\r?$/mi, "give pennies");

bt ($wiz, "\@set \%#=!halted", qr/^Cleared\.\r?$/m, "clear-halt-before-abort-test");
$timeout = 10;
bt ($wiz, "\@set %#=!halted\r\nthink iter(lnum(1,10000),iter(lnum(1,10000),.))",
    qr/^GAME: Expensive activity abbreviated.\r?$/m, "expensive-time-abort");
$timeout = 1.5;

bt ($wiz, "think orflags(\%#,h)", qr/^1\r?$/m, "self-halted-after-abort");
bt ($wiz, "\@set \%#=!halted", qr/^Cleared\.\r?$/m, "halt-cleared");

sub get_num {
    my ($exp, $comment, $num) = @_;
    $exp->expect ($timeout,
		  ['timeout', sub { notok ("timeout while reading number for $comment")}],
		  ['eof', sub { notok ("EOF while reading number for $comment")}],
		  [qr/^([-+]?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)\r?$/m]);
    my $rnum = Math::BigFloat->new($wiz->match());
    warn "num is $num, rnum is $rnum\n";
    return (Math::BigFloat->babs($num - $rnum) < 0.00001);
}

my %boolbinops = (gt   => sub { 0+($_[0] >  $_[1]) },
		  gte  => sub { 0+($_[0] >= $_[1]) },
		  lt   => sub { 0+($_[0] <  $_[1]) },
		  lte  => sub { 0+($_[0] <= $_[1]) },
		  eq   => sub { 0+($_[0] == $_[1]) },
		  neq  => sub { 0+($_[0] != $_[1]) },
		  add  => sub { $_[0] +  $_[1] },
		  iadd => sub { int($_[0]) + int($_[1]) },
		  sub  => sub { $_[0] - $_[1] },
		  isub => sub { int($_[0]) - int($_[1]) },
		  mul  => sub { $_[0] * $_[1] },
		  imul  => sub { my ($a,$b) = @_;
				 $a = $a->copy();
				 $b = $b->copy();
				 my $limit = Math::BigFloat->new(2);
				 $limit->bpow(64);
				 $a->bint();
				 $b->bint();
				 $a->bmul($b);
				 $a->bmod($limit);
				 return $a },
		  fdiv  => sub { $_[0] / $_[1] },
		  idiv  => sub { int($_[0]) / int($_[1]) },
		  min   => sub { $_[0] <= $_[1] ? $_[0] : $_[1] },
		  max   => sub { $_[0] >= $_[1] ? $_[0] : $_[1] },
		 );
my @tvals = (['int eq',1,1], ['int lt',1,2], ['int gt',2,1],
	     ['long int lt','10000000000','10000000001'],
	     ['long int gt','10000000001','10000000000'],
	     ['long int eq','10000000000','10000000000'],
	     ['float eq','1.1','1.1'],
	     ['float lt','1.2','1.3'],
	     ['float gt','1.3','1.2']);
for my $opname (qw(add iadd sub isub mul imul fdiv idiv 
		   gt gte lt lte eq neq min max)) {
    for my $tcase (@tvals) {
	my ($tname, $a, $b) = @$tcase;
	$a = Math::BigFloat->new($a);
	$b = Math::BigFloat->new($b);
	my $expected = $boolbinops{$opname}->($a,$b);
	$wiz->send ("think $opname"."($a,$b)\r\n");
	if (get_num ($wiz, "$opname on $tname", $expected)) {
	    print "ok - $opname on $tname\n";
	} else {
	    print "not ok - $opname on $tname returned wrong answer\n";
	}
    }
}

bt ($wiz, "\@pemit %#=at-pemit works", qr/^at-pemit works\r?$/m, "\@pemit");
$wiz->send (join "", map {"\@wait $_=\@pemit \%#=$_\r\n"} shuffle (0..8));
foreach (0..8) {
    bt ($wiz, undef, qr/^$_\r?$/m, "cque wait $_");
}

# set up guest
bt ($wiz, "\@create Guest Prototype",
    qr/^Guest Prototype created as object #2\r?$/m, "guest prototype creation");
bt ($wiz, "\@desc #2=A wild guestacean!",
    qr/^Set.\r?$/m, "guest prototype attributes");

bt ($wiz, "\@restart",
    qr/^GAME: Restart by Wizard, please wait\.(?:  \(All SSL connections will be dropped.\))?\r?$/m,
    "restart-allowed");
bt ($wiz, undef, qr/^GAME: Restart finished.\r?$/m, "restart-success");

$wiz->send ("think sql(select \"sql works\")\r\n");
$wiz->expect ($timeout,
	      ['timeout', sub { notok ("timeout for inline sql")}],
	      ['eof', sub { notok ("EOF for inline sql")}],
	      [qr/^sql works\r?$/m, sub { print "ok - inline sql\n" }],
	      [qr/^sql\(select \"sql works\"\)\r?$/m,
	       sub { print "ok - inline sql # SKIP no inline sql support\n" }]);

# test pcre DOT_ALL and such
bt ($wiz, "think regmatch(ab\%r\%xhcd\%xn,^.*\$)",
   qr/^0\r?$/m, "pcre no \%r in .");
bt ($wiz, "think regmatch(ab\%r\%xhcd\%xn,(?s)^.*\$)",
    qr/^1\r?$/m, "pcre dot-all");

my $guest = new_expector();
bt ($guest, undef, qr/^This is connect\.txt\r?$/m, "guest connect banner");
bt ($guest, "connect guest", qr/^This is guest\.txt\r?$/m, "guest banner");
bt ($wiz, undef, qr/^Guest1 has connected\.\r?$/m, "wizard saw guest");
bt ($wiz, "\"hi", qr/^You say, "hi"\r?$/m, "wizard says hi");
bt ($guest, undef, qr/^Wizard says, "hi"\r?$/m, "guest sees wizard greeting");
bt ($guest, ":rotates cheerfully.", qr/^Guest1 rotates cheerfully\.\r?$/m, "guest rotates");
bt ($wiz, undef, qr/^Guest1 rotates cheerfully\.\r?$/m, "wizard sees guest rotation");
bt ($wiz, "look guest1", qr/^A wild guestacean!\r?$/m, "wizard sees guest desc");
bt ($guest, "QUIT", qr/^This is quit\.txt\r?$/m, "guest quit");
bt ($wiz, undef, qr/^Guest1 has disconnected\.\r$/m, "wizard sees guest quit");
bt ($wiz, "QUIT", qr/^This is quit\.txt\r?$/m, "wizard quit");

exit $rc;
