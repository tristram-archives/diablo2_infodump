use warnings;
use strict;

if(!exists($ENV{DIABLO_II_CHAR})){
  die('DIABLO_II_CHAR global variable does not exist.');
}
my $D2sDataFile = $ENV{DIABLO_II_CHAR};

open(my ${f}, '<', $D2sDataFile) or die $!;

my $all = '';
{
  local $/;
  $all = <$f>;
}

my $skill_loc = index($all, 'if', 767);  #'gf' @ 765
if($skill_loc == -1){ die 'where the hell are we?'; }

my $skill_identity = 1;
for my $loc ($skill_loc + 2 .. $skill_loc + 31){
  #XXX use this for changing
  #print '"@', $loc, 'make', sprintf('%08b', $skill_identity), '"', ' ';

  print unpack('C', substr($all, $loc, 1)), ' ';
  $skill_identity++;
}
print $skill_loc + 2;
print "\n";
