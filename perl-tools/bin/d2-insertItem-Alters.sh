#!/bin/bash

function die {
  echo "$1"
  exit 1
}

if [ -z "$1" ] ; then
  die 'd2-insertItem.sh 4a4d10008009239123d02'
fi

if [ ! -d "$DIABLO_II_PATH" ] ; then
  die 'ERROR: diablo 2 path does not exist.'
fi

if [ ! -f "$DIABLO_II_CHAR" ] ; then
  die 'ERROR: your toon does not seem to exist.'
fi

cd ~/d2-temp/ || die 'ERROR: could not CD to ~/d2-temp/'
go run JM-inserter.go "$1" || die 'JM-inserter.go FAILED' #insert the file.
perl change.pl '@5make00000000' || die 'change.pl FAILED' #fix the checksum.

