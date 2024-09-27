use strict;
use warnings;
use JSON;
use MIME::Base64;
use LWP::UserAgent;

my ($auth,$port) = @{auth()};
my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
my $uri = "https://127.0.0.1";

my $summoner = decode_json(clientget('lol-summoner/v1/current-summoner'));
my $acid = $summoner->{'accountId'};
my $arquivo = 'moana.txt';

unless(open FILE, '>'.$arquivo) {
    die "\nUnable to create $arquivo\n";
}
print FILE "token=".clean($auth)."\n";
print FILE "port=".$port."\n";;
print FILE "account id:".$acid;
close(FILE);

sub clientget{   
    my $req = HTTP::Request->new('GET', "$uri:$port/$_[0]", $header ); 
    my $response = $ua->request($req);
    my $json = $response->content;   
    return $json;
}
sub auth{
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
}
sub clean {
    my $text = shift;
    $text =~ s/\n//g;
    $text =~ s/\r//g;
    return $text;
}