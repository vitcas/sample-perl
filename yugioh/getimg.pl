#!/usr/bin/perl

use strict;
use warnings;
use LWP::UserAgent;

my $lwp = LWP::UserAgent->new(agent=>' Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Firefox/24.0', cookie_jar=>{});

my $link = 'https://storage.googleapis.com/ygoprodeck.com/pics/';
my $aux;

print "deck: ";
my $name = <STDIN>;
chomp $name;


my $filename = 'C:\\ProjectIgnis\\deck\\'.$name.'.ydk';

open(FH, '<', $filename) or die $!;

while(<FH>){
	if ($_ !~ /#/) {
		chomp($_);
		$aux = $link.$_.'.jpg';
		print $aux;
		my $resp = $lwp->mirror($aux, 'download\\'.$_.'.jpg');
		unless($resp->is_success) {
			print $resp->status_line;
		}
	}
}

close(FH);