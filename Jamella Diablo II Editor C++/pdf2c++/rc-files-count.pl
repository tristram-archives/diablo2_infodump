#!/usr/bin/perl

use warnings;
use strict;
use feature 'say';

foreach my $txt_file (<pages4/*.txt>){
  open(my ${f}, '<', $txt_file) or die $!;
  my $line = <$f>;
  chomp($line);
  if($line !~ m#\.(h|cpp)$#){
    say $txt_file, ': ', $line;
    #last;
  }
  close(${f});
  #last;
}
