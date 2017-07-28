use warnings;
use strict;
use Data::Dumper;

#<config>
my $SELECTED = 'suffix';
#</config>




#enr = energy
#mag% = magic find
my %haMods = (
'suffix' => [
  qw/abs-cold abs-fire abs-ltng cast1 dex dmg-pois dmg-max dmg-min enr gold% hp lifesteal light mag% mana manasteal red-dmg red-mag regen str/
],
'prefix' => [
  qw/att light mag% mana mana-kill res-all res-cold res-fire res-ltng res-pois stam/
]
);
my $file_name = '';
my $mods = [];
my $total_columns = 0;
my $out_filename = '';
if($SELECTED eq 'suffix'){
  $file_name = '114d_MagicSuffix.txt';
  $mods = $haMods{'suffix'};
  $total_columns = 39;
  $out_filename = 'mod_MagicSuffix.txt';
}
elsif($SELECTED eq 'prefix'){
  $file_name = '114d_MagicPrefix.txt';
  $mods = $haMods{'prefix'};
  $total_columns = 41;
  $out_filename = 'mod_MagicPrefix.txt';
}
else{
  die('error');
}

open(my ${f}, '<', $file_name) or die $!;
my $line;
my @out_lines = ();
while(!eof(${f})){
  defined($line = readline(${f})) or die $!;
  chomp($line);
  chop($line);
  if($line =~ /\bring\b/){
    my @exploded = split(/\t/, $line);
    if(scalar(@exploded) != $total_columns){
      die("Columns don't match: " . scalar(@exploded));
    }
    for my $mod (@$mods){
      if($exploded[12] eq $mod){
        $exploded[14] *= 5;
        $exploded[15] *= 5;
        print('Mod installed: ' . $mod . '; Values=' . $exploded[14] . 
          ', ' . $exploded[15], "\n");
        last;
      }
    }
    push(@out_lines, join("\t", @exploded));
=pod
    for my $mod (@$mods){
      if($exploded[12] eq $mod){
        print('Found mod: ' . $mod . '; Values=' . $exploded[14] . ', ' . $exploded[15], "\n");
        last;
      }
    }
=cut
  }
  else{
    push(@out_lines, $line);
  }
} #<----- DONE reading original Suffix/Prefix.txt
close(${f});

#now it's time to output
print('creating ', $out_filename, "\n");
open(my ${f2}, '>', $out_filename) or die $!;
print ${f2} join("\r\n", @out_lines), "\r\n"

