#!/usr/bin/perl

use warnings;
use strict;
use feature 'say';
use File::Basename;

if(!exists($ENV{DIABLO_II_CHAR})){
  die('DIABLO_II_CHAR global variable does not exist.');
}
my $D2S_DIR_LOCATION = dirname($ENV{DIABLO_II_CHAR});

sub myError{
  my ($msg) = @_;
  die($msg . "\nperl rename-toon.pl OldName NewName\nperl rename-toon.pl OldName.d2s NewName.d2s");
}

if(scalar(@ARGV) != 2){
  myError('we need two arguments.');
}

if($ARGV[0] !~ /^[a-zA-Z_]{2,15}(\.d2s)?$/){
  myError('first argument is a wrong name.');
}

if($ARGV[1] !~ /^[a-zA-Z_]{2,15}(\.d2s)?$/){
  myError('second argument is a wrong name.');
}

if( ! -d $D2S_DIR_LOCATION){
  die("$D2S_DIR_LOCATION DNE");
}

my $orig_d2s_filename = '';
my $orig_d2s_character_name = '';
if(substr($ARGV[0], -4) eq '.d2s'){
  $orig_d2s_filename = $ARGV[0];
  ($orig_d2s_character_name) = $orig_d2s_filename =~ /^([a-zA-Z_]+)/;
}
else{
  $orig_d2s_filename = $ARGV[0] . ".d2s";
  $orig_d2s_character_name = $ARGV[0];
}

if(! -f "$D2S_DIR_LOCATION/$orig_d2s_filename"){
  die("$D2S_DIR_LOCATION/$orig_d2s_filename DNE");
}

my $new_d2s_filename = '';
my $new_d2s_character_name = '';
if(substr($ARGV[1], -4) eq '.d2s'){
  $new_d2s_filename = $ARGV[1];
  ($new_d2s_character_name) = $new_d2s_filename =~ /^([a-zA-Z_]+)/;
}
else{
  $new_d2s_filename = $ARGV[1] . ".d2s";
  $new_d2s_character_name = $ARGV[1];
}

if(-f "$D2S_DIR_LOCATION/$new_d2s_filename"){
  die("$D2S_DIR_LOCATION/$new_d2s_filename already exists");
}

say('cd ~/d2-temp/');
print('perl change.pl ');
my $STARTING_POS=0x14;
for my $offset(0 .. 15){
  if($offset >= length($new_d2s_character_name)){
    print('\'@', $STARTING_POS + $offset, 'make00000000\'');
  }
  else{
    #Pluses have higher precedence than periods
    printf('\'@' . ($STARTING_POS + $offset) . 'make%08B\'', ord(substr($new_d2s_character_name, $offset, 1)));
  }
  print(' ');
}
print("\n");
say(qq{mv '$D2S_DIR_LOCATION/$orig_d2s_filename' '$D2S_DIR_LOCATION/$new_d2s_filename'});
