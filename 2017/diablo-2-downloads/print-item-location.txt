#!/usr/bin/perl
# XXX this script analyzes the location data of a given file.
use warnings;
use strict;
use feature 'say';
use bignum;
no warnings 'portable';

sub myError{
  my ($msg) = @_;
  die("$msg\nGive me the codes for the JM item please." .
    "\nperl location-location-location.pl 0x1000a0086500646a073707024a4d");
}
#Location is given by: 0x000400080008ef0a
#Give me the dataaaaazzzzzzzz.
my $LOCATION_INFO_GIVER = 0x000400080008ff0a;
#                           1000a00865081880064703024a4d 


# we have an item.
# we need where it's storing its location.
if($#ARGV != 0){
  myError('We need one argument.');
}
if($ARGV[0] !~ /^0x[0-9a-f]{24,120}$/){
  myError('Invalid hex representation.');
}
if(length($ARGV[0]) < 24){
  myError('JM item not long enough.');
}

my $JM_item = hex(substr($ARGV[0], 0, 18));
#my $l = ($JM_item & $LOCATION_INFO_GIVER)->as_hex;
my $l = $JM_item & $LOCATION_INFO_GIVER;
#TODO we need to do a better analysis!!!!
#   match ALL bits you Mother Fucking Lazy Asshole.
my @L = (0,
  $l & 0x4000000000000 ? 1 : 0,
  $l & 0x800000000 ? 1 : 0,
  $l & 0x80000 ? 1 : 0,
  #$l & 0xe000 ? 1 : 0,
  $l & 0x8000 ? 1 : 0,
  $l & 0x4000 ? 1 : 0,
  $l & 0x2000 ? 1 : 0,
  $l & 0x1000 ? 1 : 0,
  #$l & 0xf00 ? 1 : 0,
  $l & 0x800 ? 1 : 0,
  $l & 0x400 ? 1 : 0,
  $l & 0x200 ? 1 : 0,
  $l & 0x100 ? 1 : 0,
  #$l & 0xa ? 1 : 0
  $l & 0x8 ? 1 : 0,
  $l & 0x2 ? 1 : 0
);
#stash:
if(!$L[1] && !$L[3] && !$L[11] && $L[12] && $L[13]){
  say 'in stash.';
}
elsif(!$L[1] && !$L[3] && !$L[4] && !$L[11] && !$L[12] && $L[13]){
  say 'in inventory.'
}
elsif(!$L[1] && !$L[4] && !$L[5] && !$L[6] && !$L[11] && !$L[12] && !$L[13] && $L[3]){
  say 'in belt.'
}
elsif(!$L[3] && !$L[4] && !$L[7] && !$L[8] && !$L[11] && !$L[13] && $L[12]){
  say 'in cube.';
}
else{
  say 'in unknown.'
}

