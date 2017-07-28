use warnings;
use strict;
my $c = 0;  #checksum
my $loc = 0;
open(my ${f}, '<', 'aTotal_Bitch.d2s') or die $!;
while(sysread(${f}, my $s, 1)){
  my ($byte) = unpack('C', $s);
  if($loc == 12 || $loc == 13 || $loc == 14 || $loc == 15){
    if($loc == 12){
      print "Original checksum: ";
    }
    printf '%X', $byte; #or: print unpack('H2', $s);
    if($loc == 15){
      print "\n";
    }
    $byte = 0;
  }
  if($c < 0){
    $byte++;
  }
  $c = $byte + $c * 2;
  undef $byte;
  ($c) = unpack('l', pack('l', $c));
  $loc++;
}
undef $loc;
close ${f};
printf("Calculated checksum: %s\n", unpack('H8', pack('L', $c)));
undef $c;

