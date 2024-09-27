use strict;
use warnings;
use Win32::GuiTest qw(:ALL);
use LWP::Simple;
use LWP::UserAgent;
use JSON::Parse 'parse_json';
use JSON;
use Data::Dumper;

my $level = 0;
my $aux = 0;
my $xamp = "Teemo";
my $sumona = "mayumi";

my @merlin;

recon();
getorder();
sleep(3);
lulz() while 1;

sub recon {
    my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
    my $req = HTTP::Request->new( GET => 'https://127.0.0.1:2999/liveclientdata/allgamedata' ) or die $!;
    if ($req && $ua->request($req)->content) {
        my %data = %{parse_json($ua->request($req)->content)};
				$sumona = $data{activePlayer}{summonerName};
				foreach my $cat ( @{ $data{allPlayers} } ){
					if ($cat->{'summonerName'} eq $sumona){
						$xamp = $cat->{'championName'};
						last;
					}
				}  	
				print $xamp;
    }
}

sub lulz {
    my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
    my $req = HTTP::Request->new( GET => 'https://127.0.0.1:2999/liveclientdata/allgamedata' ) or die $!;
    if ($req && $ua->request($req)->content) {
        my %data = %{parse_json($ua->request($req)->content)};
        $level = $data{activePlayer}{level};
				if ($level > 17){ exit(0); }
				if ($level > $aux){ upskill(); }			
    }
		sleep(1);
}

sub getorder {
	my $content = get 'https://pastebin.com/raw/fQgNCpqK';
	my $bazinga = decode_json($content);
	my $needle;
	while( my( $idx, $elem ) = each( @{$bazinga} ) ){
    if( $elem->{'name'} eq $xamp ){
      $needle = $idx;
      last;
    }
	}
	die "unable to find entry" unless defined $needle;
	#print Dumper $bazinga->[$needle]->{order};
	@merlin = @{$bazinga->[$needle]->{order}};
}

sub upskill {
	my $key = "%{$merlin[$level-1]}";
  SendKeys($key);
	$aux = $level;
}