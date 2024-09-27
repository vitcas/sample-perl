use strict;
use warnings;
use LWP::Simple;
use JSON;
use Data::Dumper;
use Switch;

my $page = get 'https://pastebin.com/raw/Mz7mBDt4';
my $page2 = get 'https://pastebin.com/raw/i4HAEKFf';
#this is a comment
my $json = $page;
my $json2 = $page2;
#print $page;
#print $page2;
my $text = decode_json($json);
my $text2 = decode_json($json2);
#print  Dumper($text);
my $mod = 0;
my $mod2 = 0;
my $hex;
my $xamp;
my $stone1;
my $stone2;
my $stat1;
my $stat2;
my $stat3;
my @hexa = (0,0,0,0,0,0,0,0,0,0,0);
my $runename;
#my $riot = "17";

print "champ riot code: ";
my $riot = <>;
chomp($riot); #removes newline from input

while( my( $idx, $elem ) = each( @{$text} ) )
{
    if( $elem->{'cid'} eq $riot )
    {
        $hex = $elem->{'rsetup'};
				$runename = $elem->{'rname'};
				$xamp = $elem->{'cname'};
				@hexa = split //, $hex;
        last;
    }
}
die "unable to find entry" unless defined $hex;

switches();
my $rune1 = getriot($hexa[1],$mod);
my $rune2 = getriot($hexa[2],$mod);
my $rune3 = getriot(hex $hexa[3],$mod);
my $rune4 = getriot(hex $hexa[4],$mod);
my $rune5 = getriot(hex $hexa[6],$mod2);
if ($rune5 eq 'invalid'){
	$rune5 = getriot(hex $hexa[6],$mod2); #force each loop to reset
}
my $rune6 = getriot(hex $hexa[7],$mod2);

print "champion: $xamp hex: $hex length:";
print length($hex);
print "\npath1: $stone1\nsel1: $rune1\nsel2: $rune2\nsel3: $rune3\nsel4: $rune4\npath2: $stone2\nsel5: $rune5\nsel6: $rune6\nstats1: $stat1\nstats2: $stat2\nstats3: $stat3\nrune name: $runename\n\n";
#print "\nPress ENTER to exit";
#<STDIN>;

exec($^X, $0, @ARGV); #run again

sub getriot{
    my $param = $_[0] + $_[1];
    my $result = 'invalid';
    while( my ( $key, $obj ) = each( @{$text2} ) ){
				#print "\n$key = ".($param-1) . "?";
        if( $key eq $param-1){
            $result =  $obj->{'eng'};
            last;
        }
    }
    return $result;
}
sub switches{
	switch ($hexa[0]) {
    case ("1") {$stone1 = "precision" ;}
    case ("2") {$stone1 = "domination"; $mod = 13}
    case ("3") {$stone1 = "sorcery"; $mod = 27}
    case ("4") {$stone1 = "resolve"; $mod = 39}
    case ("5") {$stone1 = "inspiration"; $mod = 51}
    else{  $stone1 = "invalid";}
	}
	switch ($hexa[5]) {
    case ("1") {$stone2 = "precision";}
    case ("2") {$stone2 = "domination"; $mod2 = 13}
    case ("3") {$stone2 = "sorcery"; $mod2 = 27}
    case ("4") {$stone2 = "resolve"; $mod2 = 39}
    case ("5") {$stone2 = "inspiration"; $mod2 = 51}
    else{  $stone2 = "invalid";}
	} 
	switch ($hexa[8]) {
    case ("1") {$stat1 = "adaptive dmg";}
    case ("2") {$stat1 = "atk speed";}
    case ("3") {$stat1 = "cdr";}
    case ("4") {$stat1 = "armor";}
    case ("5") {$stat1 = "mr";}
    case ("6") {$stat1 = "health";}
    else{  $stat1 = "invalid";}
	}   
	switch ($hexa[9]) {
    case ("1") {$stat2 = "adaptive dmg";}
    case ("2") {$stat2 = "atk speed";}
    case ("3") {$stat2 = "cdr";}
    case ("4") {$stat2 = "armor";}
    case ("5") {$stat2 = "mr";}
    case ("6") {$stat2 = "health";}
    else{  $stat2 = "invalid";}
	} 
	switch ($hexa[10]) {
    case ("1") {$stat3 = "adaptive dmg";}
    case ("2") {$stat3 = "atk speed";}
    case ("3") {$stat3 = "cdr";}
    case ("4") {$stat3 = "armor";}
    case ("5") {$stat3 = "mr";}
    case ("6") {$stat3 = "health";}
    else{  $stat3 = "invalid";}
	}   
}