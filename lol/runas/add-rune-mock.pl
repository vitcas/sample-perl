use strict;
use warnings;
use JSON;
use MIME::Base64;
use LWP::UserAgent;

my $xamp = 1;
my $runepage = '{"autoModifiedSelections":[],"current":true,"id":887,"isActive":false,"isDeletable":true,"isEditable":true,"isValid":true,"lastModified":1628301854132,"name":"sexo","order":1,"primaryStyleId":8000,"selectedPerkIds":[8010,8009,9104,8299,8473,8451,5005,5008,5001],"subStyleId":8400}';
my ($auth,$port) = @{auth()};
my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
my $uri = "https://127.0.0.1";

my $lobby = decode_json(clientget('lol-lobby-team-builder/champ-select/v1/session'));
foreach my $player ( @{ $lobby->{'myTeam'} } ){
    if ($player->{'summonerId'} == 2677454226359456){
        $xamp = $player->{'championId'};
        last;
    }
}  
clientdel('lol-perks/v1/pages/');
clientset('lol-perks/v1/pages');

sub clientdel{            
    my $req = HTTP::Request->new('DELETE', "$uri:$port/$_[0]", $header, 510);
    my $response = $ua->request($req);      
}
sub clientget{   
    my $req = HTTP::Request->new('GET', "$uri:$port/$_[0]", $header ); 
    my $response = $ua->request($req);
    my $json = $response->content;   
    return $json;
}
sub clientset{    
    my $req = HTTP::Request->new('POST', "$uri:$port/$_[0]", $header, $runepage);
    my $response = $ua->request($req);
}
sub auth{
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
}