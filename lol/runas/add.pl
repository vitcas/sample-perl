use strict;
use warnings;
use JSON;
use Data::Dumper;
use MIME::Base64;
use LWP::Simple;
use LWP::UserAgent;

my $aux = 0;
my @hexa = (0,0,0,0,0,0,0,0,0,0,0);
my @mods =  (0, 5008, 5005, 5007, 5002, 5003, 5001);
my @styles = (0, 8000, 8100, 8200, 8400, 8300);
my @sums = (0, 0, 13, 27, 39, 51);
my @mock = (8400,8439,8401,8473,8242,8345,8347,5007,5002,5003,8300);
my $runepage  = '{"autoModifiedSelections":[],"current":false,"id":510,"isActive":false,"isDeletable":true,"isEditable":true,"isValid":true,"lastModified":1628301854132,"name":"mock","order":0,"primaryStyleId":8000,"selectedPerkIds":[8008,9111,9105,8017,9101,8017,5005,5002,5003],"subStyleId":8100}';
my $xname = "mock";
my $ram = int(rand(1000));
my $rem = int(rand(157));
  
clientset('lol-perks/v1/pages','lpset: ');

sub clientset{    
    my ($auth,$port) = @{auth()};
    my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
    my $uri = "https://127.0.0.1:$port/$_[0]";
    my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
    my $req = HTTP::Request->new('POST', $uri, $header, $runepage);
    my $response = $ua->request($req);
    print $_[1];
    if ($response->is_success) {
        print $response->code, "\n";
    } else {
        print STDERR $response->status_line, "\n";
        die "rune add failed";
    }
}
sub auth{
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
} 