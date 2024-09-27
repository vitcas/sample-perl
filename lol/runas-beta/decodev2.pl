use strict;
use warnings;
use LWP::Simple;
use JSON;
use Data::Dumper;
use Switch;
use MIME::Base64;
use LWP::UserAgent;

my $page = get 'https://pastebin.com/raw/Mz7mBDt4';
my $page2 = get 'https://pastebin.com/raw/i4HAEKFf';
my $json = $page;
my $json2 = $page2;
my $text = decode_json($json);
my $text2 = decode_json($json2);
my $hex;
my $xamp;
my @hexa = (0,0,0,0,0,0,0,0,0,0,0);
my @mods =  (0, 5008, 5005, 5007, 5002, 5003, 5001);
my @styles = (0, 8000, 8100, 8200, 8400, 8300);
my @sums = (0, 0, 13, 27, 39, 51);
my $runename;

print "champ riot code: ";
my $riot = <>;
chomp($riot); #removes newline from input

while( my( $idx, $elem ) = each( @{$text} ) ){
    if( $elem->{'cid'} eq $riot ){
        $hex = $elem->{'rsetup'};
	#$runename = $elem->{'rname'};
	$xamp = $elem->{'cname'};
	@hexa = split //, $hex;
        last;
    }
}
die "unable to find entry" unless defined $hex;

my $mod = $sums[$hexa[0]];
my $mod2 = $sums[$hexa[5]];
my $path1 = $styles[$hexa[0]];
my $path2 = $styles[$hexa[5]];
my $rune1 = getriot($hexa[1],$mod);
my $rune2 = getriot($hexa[2],$mod);
my $rune3 = getriot(hex $hexa[3],$mod);
my $rune4 = getriot(hex $hexa[4],$mod);
my $rune5 = getriot(hex $hexa[6],$mod2);
#force each loop to reset
if ($rune5 eq 'invalid'){ $rune5 = getriot(hex $hexa[6],$mod2); }
my $rune6 = getriot(hex $hexa[7],$mod2);
my $stat1 = $mods[$hexa[8]];
my $stat2 = $mods[$hexa[9]];
my $stat3 = $mods[$hexa[10]];
my $mock = "{
  \"autoModifiedSelections\": [],
  \"current\": false,
  \"id\": 666,
  \"isActive\": false,
  \"isDeletable\": true,
  \"isEditable\": true,
  \"isValid\": true,
  \"lastModified\": 1628301854132,
  \"name\": \"devmoe $xamp\",
  \"order\": 1,
  \"primaryStyleId\": $path1,
  \"selectedPerkIds\": [$rune1,$rune2,$rune3,$rune4,$rune5,$rune6,$stat1,$stat2,$stat3],
  \"subStyleId\": $path2
}";

my ($auth,$port) = @{auth()};
my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => 0 }, protocols_allowed => ['https'] );
clientget('lol-perks/v1/pages');
clientset('lol-perks/v1/pages');
print "\nPress ENTER to exit";
<STDIN>;

sub getriot{
    my $param = $_[0] + $_[1];
    my $result = 'invalid';
    while( my ( $key, $obj ) = each( @{$text2} ) ){
        if( $key eq $param-1){
            $result =  $obj->{'riotid'};
            last;
        }
    }
    return $result;
}
sub clientget{
    my $uri = "https://127.0.0.1:$port/$_[0]";
    my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
    my $req = HTTP::Request->new('GET', $uri, $header ); 
    $req->content();
    my $json = $ua->request($req)->content;
    my $file = "temp3.txt";
    unless(open FILE, '>'.$file) { die "\nUnable to create $file\n"; }
    print FILE $json;
    close FILE;
}
sub clientset{    
    my $uri = "https://127.0.0.1:$port/$_[0]";
    my $header = ['Accept' => 'application/json','Content-Type' => 'application/json','Authorization' => "Basic $auth"];
    #my $data = {foo => 'bar', baz => 'quux'};
    #my $encoded_data = encode_json($data);
    my $req = HTTP::Request->new('POST', $uri, $header, $mock);
    my $res = $ua->request($req);
    print $res;
}
sub auth{
    my $proc = `WMIC path win32_process get Caption,Commandline | find "--remoting-auth-token="`;
    if ($proc =~ /--remoting-auth-token=(\S+)".*?--app-port=(\d+)/) {
        return [ encode_base64(qq(\x72\x69\x6f\x74:$1)), $2 ]
    }
} 