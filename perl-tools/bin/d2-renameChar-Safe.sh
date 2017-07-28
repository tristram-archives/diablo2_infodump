#!/bin/bash

function die {
  echo "$1"
  exit 1
}

if [ -z "$2" -o -z "$1" ] ; then
  die 'd2-renameChar.sh XXX StraightUp'
fi

if [ ! -d "$DIABLO_II_PATH" ] ; then
  die 'ERROR: diablo 2 path does not exist.'
fi

if [ ! -f "$DIABLO_II_CHAR" ] ; then
  die 'ERROR: your toon does not seem to exist.'
fi

cd ~/d2-temp/ || die 'ERROR: could not CD to ~/d2-temp/'
perl rename-toon.pl "$1" "$2" || die 'rename-toon.pl FAILED'
echo 'Please fix .bashrc with correct DIABLO_II_CHAR'
