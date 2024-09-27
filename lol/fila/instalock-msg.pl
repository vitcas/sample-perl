use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON::Parse 'parse_json';
use Time::HiRes qw(sleep);

my $championcode = 17; #teemo;
my $chatmsg = "https://www.twitch.tv/awface";
print "Champion to instalock: $championcode CHAT: $chatmsg\n";
my $summoner = ${zamanf('GET','lol-summoner/v1/current-summoner')}{summonerId};
my @co = (state());
#main function
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
        chat($chatmsg);
        print "Exiting...\n";
        exit(0);
    }
    sleep 0.05
}
sub chat {
    my @zomg = @{zamanf('GET','lol-chat/v1/conversations')};
    foreach my $x (0..$#zomg) {
        if ($zomg[$x]{type} eq 'championSelect') {
            zamanf('POST',"lol-chat/v1/conversations/$zomg[$x]{pid}/messages",'{"body": "'.shift.'"}');
        }    
    }
}
sub ready_check {
    zamanf('POST','lol-matchmaking/v1/ready-check/accept',undef);
}
sub queue {
    zamanf('POST','lol-lobby/v2/lobby','{"queueId": 420}')
}
sub search {
    zamanf('POST','lol-lobby/v2/lobby/matchmaking/search',undef)
}
sub state {
    return zamanf('GET','lol-gameflow/v1/gameflow-phase',undef);
}
sub champselect {
    my %hash = %{ zamanf('GET','lol-lobby-team-builder/champ-select/v1/session') };
    foreach my $x (@{$hash{myTeam}}) {
        foreach my $c (keys %{$x}) {
            if ($x->{summonerId} eq $summoner) {
                zamanf('PATCH',
                       "lol-lobby-team-builder/champ-select/v1/session/actions/$x->{cellId}",
                       '{"actorCellId": 0,"championId": '.$_[0].',"completed": true,"id": 0,"isAllyAction": true,"isInProgress": true,"type": "string"}'
                );
                last
            }
        }
    }
}
sub zamanf {
    my ($auth,$port) = @{ auth() };
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