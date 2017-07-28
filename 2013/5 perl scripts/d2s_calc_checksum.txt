use warnings;
use strict;
my $c = 0;  #checksum
my $loc = 0;
open(my ${f}, '<', 'aTotal_Bitch.d2s') or die $!;
while(sysread(${f}, my $s, 1)){
  my ($byte) = unpack('C', $s);
  $byte = 0 if($loc == 12 || $loc == 13 || $loc == 14 || $loc == 15);
  $byte++ if($c < 0);
  $c = $byte + $c * 2;
  ($c) = unpack('l', pack('l', $c));
  $loc++;
}
printf("Calculated checksum: %s\n", unpack('H8', pack('L', $c)));

