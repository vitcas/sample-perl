use strict;
use warnings;
use Win32::GuiTest qw(:ALL);
use LWP::UserAgent;
use JSON::Parse 'parse_json';
use Data::Dumper;

my $key;
my $level = 0;
my $count = -100;
my $aux = 0;
my @order = ('e','q','w','e','e','r','e','w','e','w','r','w','w','q','q','r','q','q');  

lulz() while 1;

sub lulz {
  $count++;
  my $ua = LWP::UserAgent->new(ssl_opts=>{verify_hostname=>0},protocols_allowed=>['https'] );
  my $req = HTTP::Request->new(GET=>'https://127.0.0.1:2999/liveclientdata/allgamedata') or die $!;
  if ($req && $ua->request($req)->content) {
    my %data = %{parse_json($ua->request($req)->content)};
    $level = $data{activePlayer}{level};
	if ($level > 17){ exit(0); }
	if ($level > $aux){ upskill(); }			
  }
  if ($count == 23){ cure(); }
  sleep(1);
}

sub upskill {
  $key = "%{$order[$level-1]}";
  SendKeys($key);
  $aux = $level;
  print "upou skill $key\n";
}

sub cure{
  SendKeys("{e}");
  sleep(1);
  SendKeys("{t}");
  sleep(1);
  SendKeys("{f}");
  $count = 0;
}