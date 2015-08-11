#! /usr/bin/perl

use strict;
use warnings;

use Expect;
use List::Util qw(shuffle);

my $timeout=1.5;

my ($host, $port) = @ARGV;
$host ||= 'localhost';
$port ||= 2860;
$port =~ /^\d+$/ or $port = 2860;
my $rc = 0;

sub notok {
    my $msg = shift;
    print "not ok - $msg\n";
    print "Bail out!\n";
    exit 1;
}

sub waitfor {
    my ($exp, $re, $msg) = @_;
    print "#   waiting for $msg\n";
    $exp->expect ($timeout,
		  ['timeout', sub { notok ("timeout before $msg")}],
		  ['eof', sub { notok ("EOF before $msg")}],
		  [$re]);
    print "ok - $msg received\n";
}

sub match_keyword {
    my ($exp, $vref, $name) = @_;
    $$vref = ($exp->matchlist)[0];
    print "#   received $name\n";
    exp_continue;
}

my $exp = Expect->new();
$exp->raw_pty(1);
$exp->slave->stty(qw(raw -echo));
$exp->log_user(0);
$exp->spawn('telnet', $host, $port) or die "not ok - unable to launch telnet";
$exp->exp_internal(1);

sub bt {
    my ($out, $in, $comment) = @_;
    print "# $comment\n";
    $exp->send ("$out\r\n") if defined $out;
    waitfor ($exp, $in, $comment);
}

bt (undef, qr/This is connect\.txt/, "connect banner");
bt ("INFO", qr/### Begin INFO( [0-9.]+)?\r\n/, "INFO header");

my ($conn, $size, $ver);
my $in_info = 1;
while ($in_info) {
    $exp->expect ($timeout,
		  ['timeout', sub { notok ('timeout during INFO response'); }],
		  ['eof', sub { notok ('EOF during INFO response'); }],
		  [qr/Connected: (\d+)\r\n/,
		   sub {match_keyword ($exp, \$conn, "connected")}],
		  [qr/Size: (\d+)\r\n/,
		   sub {match_keyword ($exp, \$size, "size")}],
		  [qr/Version: (.+)\r\n/,
		   sub {match_keyword ($exp, \$ver, "version")}],
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

bt ("connect Wizard potrzebie", qr/This is motd\.txt\r\n/, "motd");
bt (undef, qr/This is wizmotd\.txt\r\n/, "wizmotd");
bt ("\@restart", qr/Server just started\. Please try again in a few seconds.\r\n/, "restart-blocked");

# funmath
bt ("think add(1,1)", qr/2\r\n/, "think/add");
bt ("think add(1000000000,3000000000)", qr/4000000000\r\n/, "slow addition");
bt ("think iadd(281474976710656,7625597484987)", qr/289100574195643\r\n/, "long int addition");
bt ("think add(1.3,2.4)", qr/3\.7\r\n/, "slow float addition");
bt ("think ladd(1 -2 3 -4 5 6.3)", qr/9\.3\r\n/, "list add");
bt ("think sub(5,4)", qr/1\r\n/, "subtraction");
bt ("think sub(4000000000,1000000000)", qr/3000000000\r\n/, "slow subtraction");
bt ("think isub(289100574195643,7625597484987)", qr/281474976710656\r\n/, "long int subtraction");
bt ("think sub(9.9,3.3)", qr/6.6\r\n/, "slow float subtraction");

bt ("\@pemit %#=at-pemit works", qr/at-pemit works\r\n/, "\@pemit");
$exp->send (join "", map {"\@wait $_=\@pemit \%#=$_\r\n"} shuffle (0..8));
foreach (0..8) {
    bt (undef, qr/$_\r\n/, "cque wait $_");
}

bt ("\@restart", qr/GAME: Restart by Wizard, please wait\./, "restart-allowed");
bt (undef, qr/GAME: Restart finished.\r\n/, "restart-success");

$timeout = 10;
bt ("think iter(lnum(1,10000),iter(lnum(1,10000),.))",
    qr/GAME: Expensive activity abbreviated.\r\n/, "expensive-time-abort");
$timeout = 1.5;


bt ("QUIT", qr/This is quit\.txt\r\n/, "quit");

exit $rc;
