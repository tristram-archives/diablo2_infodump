#!/usr/bin/perl
use warnings;
use strict;
use feature 'say';
use Data::Dumper;

if(!exists($ENV{DIABLO_II_CHAR})){
  die('DIABLO_II_CHAR global variable does not exist.');
}
#XXX open the d2s file for understanding the JM{Location} codes.
my $d2s_to_open = $ENV{DIABLO_II_CHAR};
print("$d2s_to_open:\n");
open(my ${myd2s}, '<', "$d2s_to_open") or die $!;
my $d2s_contents = '';
{
  local $/;
  $d2s_contents = <$myd2s>;
}
close(${myd2s});

#XXX find all instances of JM.
my @JM_locations = ();
my $pos=0x330;
while( ($pos = index($d2s_contents, 'JM', $pos)) > -1){
  #printf("JM @ %X\t", $pos);
  push(@JM_locations, $pos+2);
  $pos++;
}

my $GF_location = index($d2s_contents, 'gf', 0x2f1);  #target=0x2fd (765)
if($GF_location == -1){die 'gf';}
my $IF_location = index($d2s_contents, 'if', 0x31e);  #target=0x32e (814)
if($IF_location == -1){die 'if';}

#say('apparently the filesize is: ', join('', unpack('I', substr($d2s_contents, 8, 4))));
my $real_filesize = (stat("$d2s_to_open"))[7];
my $hex_fs = sprintf('%08X', $real_filesize);
$hex_fs = substr($hex_fs, 6, 2) . substr($hex_fs, 4, 2) . substr($hex_fs, 2, 2) . substr($hex_fs, 0, 2);
say('Just in case: the real filesize is: ', $real_filesize, ' AKA: ', $hex_fs);

#XXX get data @ all JMs and give me the Location information.
for my $i(0 .. $#JM_locations){
  my $sugar_slice = '';
  if($i == $#JM_locations){
    $sugar_slice = substr($d2s_contents, $JM_locations[$i]);
  }
  else{
    $sugar_slice = substr($d2s_contents, $JM_locations[$i], $JM_locations[$i+1] - $JM_locations[$i] - 2);
  }
  my $sugar_slice_hex = join('', unpack('H*', $sugar_slice));
  
  #XXX uncomment this if you only want to target shit.
#  if(length($sugar_slice_hex) != 24){
#    next;
#  }

#=pod
  if(length($sugar_slice_hex) == 24){
    say('inserted-rune?potion? @', $JM_locations[$i], ' ', $sugar_slice_hex);
    next;
  }
  elsif(length($sugar_slice_hex) < 29){    #it's not even a potion.
    say('found an anonymous JM-item slice @ ', $JM_locations[$i], ': ', $sugar_slice_hex);
    next;
  }
  #else{
  #  next; #ignore items for now.
  #}
  my $sugar_slice_binary = join('', unpack('B*', $sugar_slice));
  #say('our item is ', length($sugar_slice_binary)/8, ' bytes, ', length($sugar_slice_hex), ' words, ', length($sugar_slice_binary), ' bits long...');
  print('JM#', sprintf('%03d', $i+1), ' @ addr ', sprintf('%04d', $JM_locations[$i]), ': ', $sugar_slice_hex);
  #<collect data shit>
  my $isUnid = substr($sugar_slice_binary, 3, 1) ? 0 : 1;
  my $hasSockets = substr($sugar_slice_binary, 12, 1) ? 1 : 0;
  
  #</collect data shit>

  #<report data shit>
  if($isUnid){print(' (is Unid)');}
  if($hasSockets){print(' (has Sockets)');}
  #</report data shit>
#=cut
  #print('JM#', sprintf('%03d', $i+1), ' @ addr ', sprintf('%04d', $JM_locations[$i]), ': ', $sugar_slice_hex);

  print("\n");
  #say($sugar_slice_hex);
  system('perl', 'print-item-location.pl', '0x' . $sugar_slice_hex);
  sleep(1);
  #exit(0);
}

sub bin{
  my ($_bin_string) = @_;
  return oct('0b' . $_bin_string);
}


