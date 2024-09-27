# contact: zamanf @ elitepvpers
# run this script to search for a game and instantly pick your champion

use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON::Parse 'parse_json';
use Time::HiRes qw(sleep);

my %setting = (
    CHAMPION    => ucfirst('Teemo'),
    POSITION    => 'SUP BITCHEZ',
    AUTOSEARCH  => 1,
    AUTOACCEPT  => 1,
    AUTOCALL    => 1,
    AUTOCHAMP   => 1,
);

my %list = (
        'Aatrox'         => 266,
        'Ahri'           => 103,
        'Akali'          => 84,
        'Alistar'        => 12,
        'Amumu'          => 32,
        'Anivia'         => 34,
        'Annie'          => 1,
        'Aphelios'       => 523,
        'Ashe'           => 22,
        'AurelionSol'    => 136,
        'Azir'           => 268,
        'Bard'           => 432,
        'Blitzcrank'     => 53,
        'Brand'          => 63,
        'Braum'          => 201,
        'Caitlyn'        => 51,
        'Camille'        => 164,
        'Cassiopeia'     => 69,
        'Chogath'        => 31,
        'Corki'          => 42,
        'Darius'         => 122,
        'Diana'          => 131,
        'DrMundo'        => 36,
        'Draven'         => 119,
        'Ekko'           => 245,
        'Elise'          => 60,
        'Evelynn'        => 28,
        'Ezreal'         => 81,
        'Fiddlesticks'   => 9,
        'Fiora'          => 114,
        'Fizz'           => 105,
        'Galio'          => 3,
        'Gangplank'      => 41,
        'Garen'          => 86,
        'Gnar'           => 150,
        'Gragas'         => 79,
        'Graves'         => 104,
        'Hecarim'        => 120,
        'Heimerdinger'   => 74,
        'Illaoi'         => 420,
        'Irelia'         => 39,
        'Ivern'          => 427,
        'Janna'          => 40,
        'JarvanIV'       => 59,
        'Jax'            => 24,
        'Jayce'          => 126,
        'Jhin'           => 202,
        'Jinx'           => 222,
        'Kaisa'          => 145,
        'Kalista'        => 429,
        'Karma'          => 43,
        'Karthus'        => 30,
        'Kassadin'       => 38,
        'Katarina'       => 55,
        'Kayle'          => 10,
        'Kayn'           => 141,
        'Kennen'         => 85,
        'Khazix'         => 121,
        'Kindred'        => 203,
        'Kled'           => 240,
        'KogMaw'         => 96,
        'Leblanc'        => 7,
        'LeeSin'         => 64,
        'Leona'          => 89,
        'Lillia'         => 876,
        'Lissandra'      => 127,
        'Lucian'         => 236,
        'Lulu'           => 117,
        'Lux'            => 99,
        'Malphite'       => 54,
        'Malzahar'       => 90,
        'Maokai'         => 57,
        'MasterYi'       => 11,
        'MissFortune'    => 21,
        'MonkeyKing'     => 62,
        'Mordekaiser'    => 82,
        'Morgana'        => 25,
        'Nami'           => 267,
        'Nasus'          => 75,
        'Nautilus'       => 111,
        'Neeko'          => 518,
        'Nidalee'        => 76,
        'Nocturne'       => 56,
        'Nunu'           => 20,
        'Olaf'           => 2,
        'Orianna'        => 61,
        'Ornn'           => 516,
        'Pantheon'       => 80,
        'Poppy'          => 78,
        'Pyke'           => 555,
        'Qiyana'         => 246,
        'Quinn'          => 133,
        'Rakan'          => 497,
        'Rammus'         => 33,
        'RekSai'         => 421,
        'Renekton'       => 58,
        'Rengar'         => 107,
        'Riven'          => 92,
        'Rumble'         => 68,
        'Ryze'           => 13,
        'Sejuani'        => 113,
        'Senna'          => 235,
        'Sett'           => 875,
        'Shaco'          => 35,
        'Shen'           => 98,
        'Shyvana'        => 102,
        'Singed'         => 27,
        'Sion'           => 14,
        'Sivir'          => 15,
        'Skarner'        => 72,
        'Sona'           => 37,
        'Soraka'         => 16,
        'Swain'          => 50,
        'Sylas'          => 517,
        'Syndra'         => 134,
        'TahmKench'      => 223,
        'Taliyah'        => 163,
        'Talon'          => 91,
        'Taric'          => 44,
        'Teemo'          => 17,
        'Thresh'         => 412,
        'Tristana'       => 18,
        'Trundle'        => 48,
        'Tryndamere'     => 23,
        'TwistedFate'    => 4,
        'Twitch'         => 29,
        'Udyr'           => 77,
        'Urgot'          => 6,
        'Varus'          => 110,
        'Vayne'          => 67,
        'Veigar'         => 45,
        'Velkoz'         => 161,
        'Vi'             => 254,
        'Viktor'         => 112,
        'Vladimir'       => 8,
        'Volibear'       => 106,
        'Warwick'        => 19,
        'Xayah'          => 498,
        'Xerath'         => 101,
        'XinZhao'        => 5,
        'Yasuo'          => 157,
        'Yone'           => 777,
        'Yorick'         => 83,
        'Yuumi'          => 350,
        'Zac'            => 154,
        'Zed'            => 238,
        'Ziggs'          => 115,
        'Zilean'         => 26,
        'Zoe'            => 142,
        'Zyra'           => 143,
);

if ($list{$setting{CHAMPION}}) {
    print "Champion to instalock: $setting{CHAMPION} ($list{$setting{CHAMPION}}) POSITION: $setting{POSITION}\n";
} else {
    print "Champion ($setting{CHAMPION}) not properly set or not on the list.\nExiting...";
    exit(0)
}

my $summoner = ${zamanf('GET','lol-summoner/v1/current-summoner')}{summonerId};

my @co = (state());

while (1) {
    my $state = state();
    
    if ($co[-1] ne $state) {
        push@co,$state;
        print "State: $state\n"
    }
        
    if ($state eq 'Lobby') {
        
        if ($setting{AUTOSEARCH} == 1) {
            search()    
        }
        
    } elsif ($state eq 'None') {
        
        if ($setting{AUTOSEARCH} == 1) {
            print "Searching for game...\n";
            queue();
        }
        
    } elsif ($state eq 'Matchmaking') {
        # wait
    } elsif ($state eq 'ReadyCheck') {
        
        if ($setting{AUTOACCEPT} == 1) {
            ready_check();
            print "Match Accepted\n";
        }
        
    } elsif ($state eq 'ChampSelect') {
        
        champselect($list{$setting{CHAMPION}}) if $setting{AUTOCHAMP} == 1;
        
        chat($setting{POSITION}) if $setting{AUTOCALL}  == 1;
        
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
    zamanf('POST','lol-lobby/v2/lobby','{"queueId": 430}')
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