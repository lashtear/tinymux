#! /usr/bin/perl

use strict;
use warnings;

use Expect;
use Net::Telnet ();

my $timeout=1;

my ($host, $port) = @ARGV;
$host ||= 'localhost';
$port ||= 2860;
$port =~ /^\d+$/ or $port = 2860;
my $rc = 0;

sub notok {
    my $msg = shift;
    print "not ok - $msg\n";
    $rc = 1;
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

$exp->spawn('telnet', $host, $port);

waitfor ($exp, qr/This is connect\.txt/, "connect banner");

print "# sending INFO command\n";
$exp->send ("INFO\r\n");
waitfor ($exp, qr/### Begin INFO( [0-9.]+)?\r\n/, "INFO header");

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

print "# trying to log in\n";
$exp->send ("connect Wizard potrzebie\r\n");
waitfor ($exp, qr/This is motd\.txt\r\n/, "motd");
waitfor ($exp, qr/This is wizmotd\.txt\r\n/, "wizmotd");

print "# testing think/add\n";
$exp->send ("think add(1,1)\r\n");
waitfor ($exp, qr/2\r\n/, "addition");

$exp->send ("QUIT\r\n");
waitfor ($exp, qr/This is quit\.txt\r\n/, "quit");

exit $rc;
