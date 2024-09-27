use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON::Parse 'parse_json';
use Time::HiRes qw(sleep);

my $auth='cmlvdDpocE1ObjV3Q2k4dzlLNWpuT3A5UHdn';
my $port=55900;
my $string = '{"queueId": 840}';
my @co = (state());
while (1) {
	my $state = state();
  if ($co[-1] ne $state) {
    push@co,$state;
    print "State: $state\n"
  }
  if ($state eq 'Lobby') {
    search()    
  } elsif ($state eq 'None') {
    print "Searching for game...\n";
    queue();
  } elsif ($state eq 'Matchmaking') {
    # wait
  } elsif ($state eq 'ReadyCheck') {
    ready_check();
    print "Match Accepted\n"; 
		exit;	  
	}	  
  sleep 0.05
}
sub ready_check {zamanf('POST','lol-matchmaking/v1/ready-check/accept',undef);}
sub queue {zamanf('POST','lol-lobby/v2/lobby',$string)}
sub search {zamanf('POST','lol-lobby/v2/lobby/matchmaking/search',undef)}
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