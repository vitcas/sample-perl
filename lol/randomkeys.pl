use strict;
use warnings;
use Win32::GuiTest qw(:ALL);
use Switch;

my $key = "{t}";
my $range = 13;
#my $random_number = rand($range);

rndkey() while 1;

sub rndkey {
	donk();
  SendKeys($key);
	sleep(3);
}

sub donk{
	switch(int(rand($range))) {
	 case 0   {$key = "{b}"}
   case 1		 {$key = "{q}"}
   case 2    {$key = "{w}"}
   case 3    {$key = "{e}"}
   case 4    {$key = "{r}"}
   case 5    {$key = "{d}"}
   case 6    {$key = "{f}"}
   case 7    {$key = "{t}"}
   case 8    {$key = "{4}"}
	 case 9    {$key = "{3}"}
	 case 10   {$key = "%{1}"}
	 case 12   {$key = "%{2}"}
	 case 12   {$key = "%{3}"}
	 case 13   {$key = "%{4}"}  
	}
}



