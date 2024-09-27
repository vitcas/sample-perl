use strict;
use warnings;
use JSON;
use MIME::Base64;
use LWP::UserAgent;

my $arcv = 'normal.json';
my $json = "";
open(FH, '<', $arcv) or die $!;
while(<FH>){ $json = $json.$_;}
close(FH);
my $dcdd = decode_json($json);
my $xamp = 1;
my $auth='cmlvdDpCR3dVX2VYM0lLSm1xbktCcnFrbmJB';my $port=64224;
my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
my $uri = "https://127.0.0.1";

my $lobby = decode_json(clientget('lol-lobby-team-builder/champ-select/v1/session'));
foreach my $cat ( @{ $lobby->{'myTeam'} } ){
    if ($cat->{'summonerId'} == 2677454226359456){
        $xamp = $cat->{'championId'};
        last;
    }
}  
my $runepage;
clientdel('lol-perks/v1/pages/');
while( my( $idx, $elem ) = each( @{$dcdd} ) ){
    if( $elem->{'id'} eq $xamp ){
        $runepage = encode_json($elem);
        last;
    }
} 
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