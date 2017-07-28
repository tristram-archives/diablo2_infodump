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
perl 'get skill data.pl' || die 'get skill data.pl FAILED'
echo 'firefox "/home/mint/d2-temp/change skill.html"'
echo 'cd ~/d2-temp'
echo 'perl change.pl'
