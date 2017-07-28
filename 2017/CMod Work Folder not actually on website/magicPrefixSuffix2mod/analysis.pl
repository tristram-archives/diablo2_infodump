use warnings;
use strict;
use Data::Dumper;

=pod
114d_MagicSuffix.txt: 39 columns, 749 lines.
114d_MagicPrefix.txt: 41 columns, 671 lines.
=cut

my %cols = ();
open(my ${f}, '<', '114d_MagicPrefix.txt') or die $!;
my $line;
while(!eof(${f})){
  defined($line = readline(${f})) or die $!;
  chomp($line);
  $cols{scalar(split(/\t/, $line))}++;
}
print Dumper(%cols);
