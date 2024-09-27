#gera um nick aleatorio com I e l
use strict;
use warnings;

my @chars = ();
my @cars = ('I','l');
my $lena = 32;
my $string;
while($lena--){ $string .= $cars[rand @cars] };
my $filename = 'temp.txt';
open(FH, '>', $filename) or die $!;
print FH $string;
close(FH);

sub clean {
    my $text = shift;
    $text =~ s/\n//g;
    $text =~ s/\r//g;
    return $text;
}
