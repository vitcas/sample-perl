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
my $runepage ='{"autoModifiedSelections":[],"current":true,"id":12,"isActive":false,"isDeletable":true,"isEditable":true,"isValid":true,"lastModified":1628301854132,"name":"rush","order":1,"primaryStyleId":8200,"selectedPerkIds":[8230,8275,8210,8237,8321,8347,5007,5008,5003],"subStyleId":8300}';
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