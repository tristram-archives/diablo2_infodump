#!/usr/bin/perl

#/usr/bin/perl: D2 modding: ring attributes x5 for MagicPrefix.txt and MagicSuffix.txt
#2010-11-04 16:54:24

while($_=<STDIN>){chomp;s/(\\d+)(\\s+)(\\d+)(\\s{8,})(.*)ring/$1*5 . $2 . $3*5 . $4 . $5 . "ring"/e;print $_ . "\\n"}

