#!/bin/bash

#misc screenshot difference through composite automator
#purpose: seek the image that can be used pixel-by-pixel to seek:

#- location of cursor (i.e., x=342;y=420)
#- location of crop (i.e., x=200;y=231;width=140;height=230)

#<CONFIGURE>
branches=(
screenshot_over_blank
blank_over_screenshot
)
colors=255
modes=(
exclusion
difference
subtract
minus
divide
bumpmap
)
#</CONFIGURE>

for main_dir in ${branches[*]} ; do
  for mode in ${modes[*]} ; do 
    location=$main_dir/$mode
    mkdir -p $location
    n=0
    for i in Screenshot*.jpg ; do 
      let n++
      [ `echo "$n % 2" | bc` -eq 1 ] && {
        last_jpeg=$i
        continue
      }
      if [ $main_dir = screenshot_over_blank ] ; then
        command="composite -compose $mode $i $last_jpeg $location/$n.png"
        echo $command > $location/readme.txt
        eval $command
      elif [ $main_dir = blank_over_screenshot ] ; then
        command="composite -compose $mode $last_jpeg $i $location/$n.png"
        echo $command > $location/readme.txt
        eval $command
      fi
    done
  done
done

