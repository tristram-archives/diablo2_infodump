use warnings;
use strict;
use Data::Dumper;

=pod
114d_MagicPrefix.txt 76 lines match 'ring'
114d_MagicSuffix.txt 122 lines match 'ring'
=cut

open(my ${f}, '<', '114d_MagicSuffix.txt') or die $!;
my $line;
my $found_ring = 0;
while(!eof(${f})){
  defined($line = readline(${f})) or die $!;
  chomp($line);
  if($line =~ /\bring\b/){
    $found_ring++;
  }
}
print('Found rings: ', $found_ring, "\n");
