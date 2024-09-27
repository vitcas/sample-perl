#ativava o bonus no aram
use strict;
use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON::Parse 'parse_json';

blah('lol-champ-select/v1/team-boost/purchase/');

sub blah {
    my ($auth,$port) = @{auth()};
    my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
    my $uri = "https://127.0.0.1:$port/$_[0]";
    my $req = HTTP::Request->new('POST', $uri );
    $req->header( 'Accept' => 'application/json' );
    $req->header( 'Content-Type' => 'application/json' );
    $req->header( 'Authorization' => "Basic $auth" );
    
    $req->content();
    
    print Dumper parse_json($ua->request($req)->content )
}

sub auth {
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
} 
