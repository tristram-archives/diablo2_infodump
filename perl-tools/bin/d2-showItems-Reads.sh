#!/bin/bash

function die {
  echo "$1"
  exit 1
}

if [ ! -d "$DIABLO_II_PATH" ] ; then
  die 'ERROR: diablo 2 path does not exist.'
fi

if [ ! -f "$DIABLO_II_CHAR" ] ; then
  die 'ERROR: your toon does not seem to exist.'
fi

cd ~/d2-temp/ || die 'ERROR: could not CD to ~/d2-temp/'
perl JM-find-codes.pl || die 'somehow JM-find-codes.pl FAILED'
