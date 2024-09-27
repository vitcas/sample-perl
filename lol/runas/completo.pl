use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use LWP::Simple;
use JSON;
use Time::HiRes qw(sleep);

my $xid = 18;
my $runepage;
my $summoner = '2677454226359456';
my $auth = 'cmlvdDo3QlkwVWFpWXdrNFROckZ0ZGk1VlZn'; my $port = 49655;


print 'champion code: ';
$xid = <STDIN>;
chomp $xid;
findchamp();
request('DELETE','lol-perks/v1/pages',undef);
request('POST','lol-perks/v1/pages',$runepage);
qauto();

sub ready_check {request('POST','lol-matchmaking/v1/ready-check/accept',undef);}
sub queue {request('POST','lol-lobby/v2/lobby','{"queueId": 840}')}
sub search {request('POST','lol-lobby/v2/lobby/matchmaking/search',undef)}
sub state {return request('GET','lol-gameflow/v1/gameflow-phase',undef);}
sub findchamp {
	my $content = get 'https://pastebin.com/raw/5WBtRahe';
	my $allrunes = decode_json($content);
	foreach my $item ( @{$allrunes} ){
		if( $item->{id} == $xid ){
      $runepage = to_json($item);
			#print Dumper $runepage;
      return;
    }
	}
	die "unable to find entry";
}
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
    return to_json($data);
  }      
}
sub qauto{
	print 'start here';
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
			champselect($xid);
			exit(0);
		}
		sleep 0.5
	}
}
