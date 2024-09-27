use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON::Parse 'parse_json';
use Time::HiRes qw(sleep);

my ($auth,$port) = @{ auth() };
my @co = (state());
while (1) {
	my $state = state();
  if ($co[-1] ne $state) {
    push@co,$state;
    print "State: $state\n"
  }
  if ($state eq 'Lobby') {
    zamanf('POST','lol-lobby/v2/lobby/matchmaking/search',undef)   
  } elsif ($state eq 'None') {
    print "Searching for game...\n";
    zamanf('POST','lol-lobby/v2/lobby','{"queueId": 1090}')
  } elsif ($state eq 'Matchmaking') {
    # wait
  } elsif ($state eq 'ReadyCheck') {
    zamanf('POST','lol-matchmaking/v1/ready-check/accept',undef);
    print "Match Accepted\n"; 
		#exit;	  
	}	  
  sleep 5
}
sub state {return zamanf('GET','lol-gameflow/v1/gameflow-phase',undef);}
sub zamanf {
  my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
  my $url = "https://127.0.0.1:$port/$_[1]";
  my $req = HTTP::Request->new($_[0], $url);
  $req->header( 'Accept' => 'application/json' );
  $req->header( 'Content-Type' => 'application/json' );
  $req->header( 'Authorization' => "Basic $auth" );
  $req->content($_[2]);
  my $data = $ua->request($req)->content;
  if ($data) {
    return parse_json($data)
  }      
}
sub auth {
  my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
  if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
    return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
  }
} 
#1090 tft 830 bot intro 840 bot beg 430 blind 450 aram