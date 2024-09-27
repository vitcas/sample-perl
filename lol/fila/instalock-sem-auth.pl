use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON::Parse 'parse_json';
use Time::HiRes qw(sleep);

my $championcode = 18;
my $auth = 'cmlvdDpnNWtTMzV5T3JjaUtzOV9qVWkxVkFB';
my $port = 62997;
my $summoner = '2677454226359456';
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
  } elsif ($state eq 'ChampSelect') {
    champselect($championcode);
    exit(0);
  }
  sleep 0.05
}

sub ready_check {zamanf('POST','lol-matchmaking/v1/ready-check/accept',undef);}
sub queue {zamanf('POST','lol-lobby/v2/lobby','{"queueId": 840}')}
sub search {zamanf('POST','lol-lobby/v2/lobby/matchmaking/search',undef)}
sub state {return zamanf('GET','lol-gameflow/v1/gameflow-phase',undef);}
sub champselect {
  my %hash = %{ zamanf('GET','lol-lobby-team-builder/champ-select/v1/session') };
  foreach my $x (@{$hash{myTeam}}) {
    foreach my $c (keys %{$x}) {
      if ($x->{summonerId} eq $summoner) {
        zamanf('PATCH',"lol-lobby-team-builder/champ-select/v1/session/actions/$x->{cellId}",'{"actorCellId": 0,"championId": '.$_[0].',"completed": true,"id": 0,"isAllyAction": true,"isInProgress": true,"type": "string"}');
        last
      }
     }
  }
}
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