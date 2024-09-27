use strict;
use warnings;
use Win32::GuiTest qw(:ALL);
use LWP::UserAgent;
use JSON::Parse 'parse_json';
use Data::Dumper;

my ($level,$zmf,@lvl);
my %passive = (
    # passive name                champ       lvl2/lvl3    upgrade order (e->q->w in shaco's case)
    'Backstab'              => { 'Shaco'    => ['q','e',  'e','q','w'] },
    'Guerrilla Warfare'     => { 'Teemo'    => ['e','w',  'q','e','w'] },
);
lulz();
my $zamanf = [@_=%{$passive{$zmf}}]->[1|rand@_];
lulz() while 1;
sub lulz {
    my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
    my $req = HTTP::Request->new( GET => 'https://127.0.0.1:2999/liveclientdata/allgamedata' ) or die $!;
    if ($req && $ua->request($req)->content) {
        my %data = %{parse_json($ua->request($req)->content)};
        $level = $data{activePlayer}{level};
        if (exists $passive{ $data{activePlayer}{abilities}{Passive}{displayName} }) {
            $zmf = $data{activePlayer}{abilities}{Passive}{displayName};
        } else {
            exit(0)
        }
        zamanf()
    }
}
sub zamanf {
	shift @lvl if $#lvl == 2;
    push @lvl, $level;
    if ($#lvl == 2) {
        if ($lvl[0] < $lvl[1]) {
            if ($lvl[1] == 2) {
                SendKeys("^$zamanf->[0]",1);
            }
            if ($lvl[1] == 3) {
                SendKeys("^$zamanf->[1]",1);
            }
            if ($lvl[1] =~ /^(?:4|5|7|9)$/) {
                SendKeys("^$zamanf->[2]",1);
            }
            if ($lvl[1] =~ /^(?:8|10|12|13)$/) {
                SendKeys("^$zamanf->[3]",1);
            }
            if ($lvl[1] =~ /^(?:14|15|17|18)$/) {
                SendKeys("^$zamanf->[4]",1);
            }
            if ($lvl[1] =~ /^(?:6|11|16)$/) {
                SendKeys("^\x72",1);
            }
            if ($lvl[1] == 18) {
                exit(0);
            }
        }
    }
} 