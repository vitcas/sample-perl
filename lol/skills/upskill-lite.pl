use strict;
use warnings;
use Win32::GuiTest qw(:ALL);
use LWP::UserAgent;
use JSON::Parse 'parse_json';
use Data::Dumper;

my $level = 0;
my $aux = 0;
my @order = ('e','q','w','e','e','r','e','q','e','q','r','q','q','w','w','r','w','w');  

lulz() while 1;

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

sub upskill {
	my $key = "%{$order[$level-1]}";
  SendKeys($key);
	$aux = $level;
}