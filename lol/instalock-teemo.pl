use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON::Parse 'parse_json';
use Time::HiRes qw(sleep);

my $xid = 18;
my $summoner = '2677454226359456';
my $auth = 'cmlvdDoxOU9Iei1odVZWd0lIOUNjRGVjZURn'; my $port = 57877;
my @co = (state());

print 'champion code: ';
$xid = <STDIN>;
chomp $xid;
print '\n';

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
    champselect($xid);
    exit(0);
  }
  sleep 0.5
}

sub ready_check {request('POST','lol-matchmaking/v1/ready-check/accept',undef);}
sub queue {request('POST','lol-lobby/v2/lobby','{"queueId": 840}')}
sub search {request('POST','lol-lobby/v2/lobby/matchmaking/search',undef)}
sub state {return request('GET','lol-gameflow/v1/gameflow-phase',undef);}
sub champselect {
  my %hash = %{ request('GET','lol-lobby-team-builder/champ-select/v1/session') };
  foreach my $x (@{$hash{myTeam}}) {
    foreach my $c (keys %{$x}) {
      if ($x->{summonerId} eq $summoner) {
        request('PATCH',"lol-lobby-team-builder/champ-select/v1/session/actions/$x->{cellId}",'{"actorCellId": 0,"championId": '.$_[0].',"completed": true,"id": 0,"isAllyAction": true,"isInProgress": true,"type": "string"}');
        last
      }
     }
  }
}
sub request {
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
