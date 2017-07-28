================================
Diablo II Tools!
================================

TODO:
Fix all these scripts before running.

And here are the tools to call in bin/
1) d2-backupChar-Reads.sh
copies $DIABLO_II_CHAR to ~/d2-temp/d2_backups/anumber.d2s
2) d2-changeSkills-Reads.sh
prints out the codes from $DIABLO_II_CHAR to copy-and-paste into
  ~/d2-temp/change skill.html ..Then in the HTML file you press the export
  button and copy and paste that into your terminal:
  cd ~/d2-temp/
  perl change.pl *copy-and-paste-here*
3) d2-insertItem-Alters.sh
insert an item via the first argument sent.
be sure your cube is empty before executing this!
and if you don't have a cube..
  d2-insertItem-Alters.sh 1000800065000022f6860782251813be86e03f #adds cube to top-left inventory
                                                                 #be sure that is clear before injecting
Add a rune example:
  d2-insertItem-Alters.sh runes_El  #adds El rune to cube
  d2-insertItem-Alters.sh runes_zod #adds Zod to cube
Add a gem example:
  d2-insertItem-Alters.sh gems_a     #adds a P. amethyst to cube
  d2-insertItem-Alters.sh gems_skull #adds a P. skull to your cube
Add a coded item:
  #the following two sequentially add the viper amulet and horadric staff in the cube for
  # act 2 normal!
  d2-insertItem-Alters.sh 10008000650000d83667068210710183c8c1075a3e9ce049c1b382a7054f17e37f
  d2-insertItem-Alters.sh 100080006500606897060702f7088e34c78d3d7040450295164bff01
4) d2-makeFree-Safe.sh
can access nightmare/hell & has all waypoints.
5) d2-renameChar-Safe.sh
safely rename a character ...
6) d2-showItems-Reads.sh
show the codes of the current items in stash/inventory/cube/equipped.
7) d2-stam2rejuv-Reads.sh
reads all of the stamina potions inside of your character and then you paste
  the output into here:
cd ~/d2-temp/
perl change.pl *copy-and-paste-here*
# and that will change your toon from stamina to rejuvs.
