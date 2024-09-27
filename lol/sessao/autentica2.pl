use strict;
use warnings;
use JSON;
use MIME::Base64;
use LWP::UserAgent;

my $json = "";
my ($auth,$port) = @{auth()};
my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
my $uri = "https://127.0.0.1";
my $filename = 'c:\temp\test3.txt';
open(FH, '>', $filename) or die $!;
print FH $auth;
print FH $port;
close(FH);

sub auth{
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
}