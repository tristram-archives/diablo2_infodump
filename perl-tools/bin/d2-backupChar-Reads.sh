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

num=1
while [ -f d2s_backups/$num.d2s ] ; do
  let num++
done
cp -i "$DIABLO_II_CHAR" d2s_backups/$num.d2s || die 'copying your character to backups FAILED'
echo 'Back-up success!'
echo "~/d2-temp/d2s_backups/$num.d2s"
