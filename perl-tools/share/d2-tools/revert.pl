use strict;
use warnings;
use File::Copy;
use myconfig qw/read_config/;

my $D2sDataFile = read_config();
#'C:\Users\user1\AppData\Local\VirtualStore\Program Files (x86)\Diablo II\Save\my_d.d2s';
my $D2sRevertFile = 'revert.d2s';

if( ! -f $D2sRevertFile){
  die 'There is no revert file.';
}
if( ! -f $D2sDataFile){
  die 'Where is the original D2s file?';
}
unlink($D2sDataFile) or die $!;
copy($D2sRevertFile, $D2sDataFile) or die $!;
unlink($D2sRevertFile) or die $!;
CORE::say "Your D2s file has been successfully redeployed."
