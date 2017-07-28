#!/usr/bin/perl
use warnings;
use strict;
use feature 'say';


if(!exists($ENV{DIABLO_II_CHAR})){
  die('DIABLO_II_CHAR global variable does not exist.');
}
my $d2s_to_open = $ENV{DIABLO_II_CHAR};
print("$d2s_to_open:\n");
open(my ${myd2s}, '<', "$d2s_to_open") or die $!;
my $d2s_contents = '';
{
  local $/;
  $d2s_contents = <$myd2s>;
}
close(${myd2s});

my @JM_locations = ();
my $pos=0x330;
while( ($pos = index($d2s_contents, 'JM', $pos)) > -1){
  push(@JM_locations, $pos+2);
  $pos++;
}

for my $i(0 .. $#JM_locations){
  my $sugar_slice = '';
  if($i == $#JM_locations){
    $sugar_slice = substr($d2s_contents, $JM_locations[$i]);
  }
  else{
    $sugar_slice = substr($d2s_contents, $JM_locations[$i], $JM_locations[$i+1] - $JM_locations[$i]);
  }
  my $sugar_slice_hex = join('', unpack('H*', $sugar_slice));
  #XXX potion.....Could be a stamina potion :D
  if(length($sugar_slice_hex) == 28){
    # XXX say('Potion ID', sprintf('%03d', $i+1), ' @ addr ', $JM_locations[$i], ': ', $sugar_slice_hex);
    system('perl', 'stam2rejuv.pl', '0x' . $sugar_slice_hex, $JM_locations[$i]);
    #exit(0);
  }
}
print "\n";

