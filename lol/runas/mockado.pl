use strict;
use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use JSON;

my $mock = "{
    \"autoModifiedSelections\": [],
    \"current\": false,
    \"id\": 1219755115,
    \"isActive\": false,
    \"isDeletable\": true,
    \"isEditable\": true,
    \"isValid\": true,
    \"lastModified\": 1628301854132,
    \"name\": \"devmoe prime\",
    \"order\": 1,
    \"primaryStyleId\": 8400,
    \"selectedPerkIds\": [8439,8401,8473,8242,8345,8347,5007,5002,5003],
    \"subStyleId\": 8300
  }";

#get('lol-perks/v1/pages');
set('lol-perks/v1/pages');
sub get {
  my ($auth,$port) = @{auth()};
  my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
  my $uri = "https://127.0.0.1:$port/$_[0]";
  my $req = HTTP::Request->new('GET', $uri );
  $req->header( 'Accept' => 'application/json' );
  $req->header( 'Content-Type' => 'application/json' );
  $req->header( 'Authorization' => "Basic $auth" );   
  $req->content();
	my $json = $ua->request($req)->content;
	my $file = "temp2.txt";
	unless(open FILE, '>'.$file) {
    die "\nUnable to create $file\n";
	}
	print FILE $json;
	close FILE;
}
sub set {
	my ($auth,$port) = @{auth()};
  my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
  my $uri = "https://127.0.0.1:$port/$_[0]";
	my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
	#my $data = {foo => 'bar', baz => 'quux'};
	#my $encoded_data = encode_json($data);
  my $req = HTTP::Request->new('POST', $uri, $header, $mock);
	my $res = $ua->request($req);
	print $res;
}
sub auth {
  my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
  if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
		return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
   }
} 