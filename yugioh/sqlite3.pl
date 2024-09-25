#!/usr/bin/perl

use DBI;
use strict;

my $file = "decklist.txt";
# Use the open() function to create the file.
unless(open FILE, '>'.$file) {
    # Die with error message 
    # if we can't open it.
    die "\nUnable to create $file\n";
}

my $driver   = "SQLite"; 
my $database = "cards.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
   or die $DBI::errstr;

my $filename = 'x.ydk';
my $aux = 666;
my $count = 1;

open(FH, '<', $filename) or die $!;

while(<FH>){
	chomp($_);
	if ($aux !~ $_){
		$aux = $_;
		print FILE ' x'.$count."\n";
		my $stmt = qq(SELECT name FROM texts WHERE id = ?;);
		my $sth = $dbh->prepare( $stmt );
		$sth->bind_param( 1, $_ ); 
		my $rv = $sth->execute() or die $DBI::errstr;
		if($rv < 0) {
			print $DBI::errstr;
		}
		while(my @row = $sth->fetchrow_array()) {
			print FILE $row[0];
		}
		$count = 1;
	} else {$count++;}
}

close(FH);
# close the file.
close FILE;
$dbh->disconnect();