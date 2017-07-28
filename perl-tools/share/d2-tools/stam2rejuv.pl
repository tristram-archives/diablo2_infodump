#!/usr/bin/perl
# XXX this script converts a STAMINA potion
#     into a MOTHER FUCKING antidote potion...bitch.
use warnings;
use strict;
use feature 'say';
use bignum;
no warnings 'portable';

sub myError{
  my ($msg) = @_;
  die("$msg\nperl stam2ant.pl 0x1000a0086500646a073707024a4d 830");
}

# 0xff says: "I want this."
# 0x00 says: "Ignore this."
my $STRIP_LOCATION_BIT_MASK = 0xfffbfff7fff710f5ffffffffffff;

my $ANTIDOTE_ID = 0x1000a00065000090073707024a4d;
my $STAMINA_ID  = 0x1000a00065000060073707024a4d;
my $REJUV_ID    = 0x1000a00065000020673707024a4d;
my $LIMIT       = 0xffffffffffffffffffffffffffff;

# we have stamina potions.
# we want to turn them to antidote potions.
if($#ARGV != 1){
  myError('We need two arguments.');
}
if(length($ARGV[0]) != 30){
  myError('Invalid length of hex representation.');
}
if($ARGV[0] !~ /^0x[0-9a-f]{28}$/){
  myError('Invalid hex representation.');
}
if($ARGV[1] !~ /^[0-9]{1,4}$/){
  myError('Invalid address.');
}


#my $stamina_potion  = 0x1000a0086500646a073707024a4d;
my $stamina_potion = hex($ARGV[0]);
my $addr_in_d2s_file = $ARGV[1];

#XXX is this a stamina potion?
if(($stamina_potion & $STAMINA_ID) != $STAMINA_ID){
  exit(0);  #not a stamina potion..ignoring.
  die($stamina_potion->as_hex, ' is not a stamina potion...');
}

#my $rejuv_id = ($potion & $STRIP_LOCATION_BIT_MASK)->as_hex;
#say('Rejuv ID: ', $rejuv_id);
#exit(0);

#my $stamina_id  = ($stamina_potion  & $STRIP_LOCATION_BIT_MASK)->as_hex;
#say('Antidote ID: ', $antidote_id);
#say(' Stamina ID: ', $stamina_id);
#this basically means


#my $antidote_potion = 0x1000a00865000098073707024a4d;
my $rejuv_potion = ($stamina_potion & ~$STAMINA_ID | $REJUV_ID)->as_hex;
# XXX say 'Here is the new DATA: ', $antidote_potion;


create_change_pl($stamina_potion->as_hex . '', $rejuv_potion);
#Here is the new DATA: 0x1000a0086500649a073707024a4d

sub create_change_pl{
  my ($from, $to) = @_;
  #for(my $i=0; $i
  $from = substr($from, 2);
  $to   = substr($to,   2);
  if(length($from) != 28 || length($to) != 28){
    die 'stamina and rejuv potions need to be the same length.';
  }
  #say('from: ', $from, "\n  to: ", $to);
  for my $i(0 .. 13){     #which byte
    my $offset = $i * 2;  #location of the byte in the string
    if(substr($from, $offset, 2) ne substr($to, $offset, 2)){
      print('"@', $addr_in_d2s_file + $i, 'make', sprintf('%08B', hex(substr($to, $offset, 2))), '" ');
    }
  }
  #print("\n");
}

=pod
XXX use this to get your IDs
#my $antidote_id = ($antidote_potion & $STRIP_LOCATION_BIT_MASK)->as_hex;
#my $stamina_id  = ($stamina_potion  & $STRIP_LOCATION_BIT_MASK)->as_hex;
#say('Antidote ID: ', $antidote_id);
#say(' Stamina ID: ', $stamina_id);
#this basically means
=cut

