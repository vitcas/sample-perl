use warnings;
use MIME::Base64;
use LWP::UserAgent;
use Data::Dumper;
use LWP::Simple;
use JSON;
use Time::HiRes qw(sleep);

require 'C:\temp\scripts\perl\teste\auth.pl';

my ($auth,$port) = @{auth()};
my $token = clean($auth);
my $runepage ='{"autoModifiedSelections":[],"current":true,"id":1,"isActive":false,"isDeletable":true,"isEditable":true,"isValid":true,"lastModified":1628301854132,"name":"troll","order":1,"primaryStyleId":8300,"selectedPerkIds":[8360,8313,8316,8347,8275,8234,5007,5002,5002],"subStyleId":8200}';
request('DELETE','lol-perks/v1/pages',undef);
request('POST','lol-perks/v1/pages',$runepage);

sub request {
  my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
  my $url = "https://127.0.0.1:$port/$_[1]";
  my $req = HTTP::Request->new($_[0], $url);
  $req->header( 'Accept' => 'application/json' );
  $req->header( 'Content-Type' => 'application/json' );
  $req->header( 'Authorization' => "Basic $token" );
  $req->content($_[2]);
  my $data = $ua->request($req)->content;
  if ($data) {
    return to_json($data);
  }      
}