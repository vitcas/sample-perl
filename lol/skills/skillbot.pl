use strict;
use warnings;
use Win32::GuiTest qw(:ALL);
use LWP::UserAgent;
use JSON::Parse 'parse_json';

my $key;
my $gati = 0;
my $cool = 0;
my $level = 0;
my $gold = 500;
my $aux = 0;
my @order = ('q','w','e','q','w','r','e','q','w','e','r','q','w','e','q','r','w','e');  

lulz() while 1;

sub lulz {
  my $ua = LWP::UserAgent->new(ssl_opts=>{verify_hostname=>0},protocols_allowed=>['https'] );
  my $req = HTTP::Request->new(GET=>'https://127.0.0.1:2999/liveclientdata/allgamedata') or die $!;
  if ($req && $ua->request($req)->content) {
    my %data = %{parse_json($ua->request($req)->content)};
    $level = $data{activePlayer}{level};
    $gold = int($data{activePlayer}{currentGold});
    $gati = int($data{gameData}{gameTime});
  }
	if ($level < 18){ upskill() }
  if ($gati > 900){ surrender() }
  sleep(3);
}

sub upskill {
  $key = "%{$order[$level-1]}";
  SendKeys($key);
  $aux = $level;
}

sub surrender {
  $cool = $cool - 3;;
  if ($cool < 0){
    SendKeys("~");
    SendKeys("/ff");
    SendKeys("~");
    $cool = 180;
  }
}