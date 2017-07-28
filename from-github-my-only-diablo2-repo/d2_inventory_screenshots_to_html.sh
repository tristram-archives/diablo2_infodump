#!/bin/bash
/bin/bash: d2_inventory_screenshots_to_html.sh version 0.01

#2010-11-07 20:10:47

#!/bin/bash
# d2_inventory_screenshots_to_html.sh version 0.01
# screenshot:
# http://diablo2linux.hostpo.net/from_scripts/d2_inventory_html_v0.01.jpg
#
# purpose move last 15 minutes screenshots from D2 to a tempdir
# create 'emptied.png'
# using emptied, get the cursor location
# using emptied, get the location/size of what to show of screenshot
# using 'cursor location' and location/size, create the map HTML MAP line
#   export the cropped image to directory images/ as 'cropped_1.jpg ...'
# convert 'emptied.png'->'images/emptied.jpg'
# create 'index.html' to hold the HTML file that expresses the
#   'emptied.jpg', the JavaScript for the MAP onmouseover,onmouseout,
#   and using the HTML that would hold the images...

#$: convert --version
#Version: ImageMagick 6.6.0-4 2010-08-11 Q16...

#$: bash --version
#GNU bash, version 4.1.5(1)-release (i486-pc-linux-gnu)...

#$: perl --version
#...v5.10.1 (*)...(with 46 registered patches,...

#$: awk --version
#GNU Awk 3.1.5...

#$: sed --version
#GNU sed version 4.1.5

work_area=~/d2_inventory_html_`perl '-mString::Random=random_regex' -e 'print random_regex("[a-z]{5}");'`
mkdir $work_area || exit 1
echo $work_area
cd $work_area || exit 1
find ~/diablo2/drive_c/D2 -maxdepth 1 -type f -name "Screenshot*.jpg" -cmin -15 -exec cp '{}' . \;
[ "`echo *.jpg`" = '*.jpg' ] && { echo "no screens." ; exit 1 ; }
screenshot_jpegs=*.jpg
for i in $screenshot_jpegs ; do 
  convert "$i" "$i.txt"
done
sed -si '/^#/d;s/#.*//;s/[,:()]/ /g;s/...$//;s/  */_/g;s/^[0-9]\+_[0-9]\+_//' *.txt
paste -d ' ' *.txt > emptied_predata.dat

echo '# ImageMagick pixel enumeration: 800,600,255,rgb' > emptied_image.txt

perl -MPOSIX -e '
sub get_x_y{
  my $line_num=shift;
  my @out=(0,0);
  $out[1] = floor($line_num / 800);
  $out[0] = $line_num - $out[1] * 800;
  return @out;
}
my $line_number=0;
my $section=0;
my $number_of_shots=0;
my %identity_popularity;
open(FH, "<", "emptied_predata.dat");
open(FH2, ">>", "emptied_image.txt");
while(<FH>){
  chomp;
  $number_of_shots = tr/ // if($number_of_shots == 0);
  for $rgb (split / /){
    $section++;
    if($section > $number_of_shots){
      $section=0;
      $mostpopular=0;
      $mostpopular_identity="";
      for $i (keys %identity_popularity){
        if($identity_popularity{$i} > $mostpopular){
          #if($mostpopular == 1){
          #  print "A mostpopular is a 1???????\n";
          #}
          $mostpopular=$identity_popularity{$i};
          $mostpopular_identity=$i;
        }
      }
      my @position = get_x_y($line_number);
      my @rgb_list = split /_/, $mostpopular_identity;
      printf FH2 "%d,%d: (%3d,%3d,%3d)\n", @position, @rgb_list;
      $line_number++;
      %identity_popularity = undef;
    }

    $identity_popularity{$rgb}++;
  }
}
'
convert emptied_image.txt emptied.png
mkdir txts_for_creation_of_emptied && \
mv *.txt txts_for_creation_of_emptied/
n=0
for i in *.jpg ; do 
  let n++
  save_png_as=`printf '%03d_get_crop_and_cursor.png' $n`
  composite -compose subtract $i emptied.png $save_png_as
done

mkdir d2inv_images
convert -quality 70 emptied.png d2inv_images/emptied.jpg
mkdir png_for_creation_of_png_to_process
mv emptied.png png_for_creation_of_png_to_process/

for i in *.png ; do
  convert $i $i.txt
done
sed -si '/^#/d;s/#.*//;s/[,:()]/ /g;s/...$//;s/  */ /g;s/^[0-9]\+ [0-9]\+ //' *.txt


n=0
images_to_crop=*.jpg
echo "<!-- Created by d2_inventory_screenshots_to_html.sh version 0.01  --><script>
function change_css(classname,element,value) 
{
  var cssRules;
  var added = false;
  for (var S = 0; S < document.styleSheets.length; S++){
    if (document.styleSheets[S]['rules']) {
      cssRules = 'rules';
    } else if (document.styleSheets[S]['cssRules']) {
      cssRules = 'cssRules';
    } else {
      return;
    }

    for (var R = 0; R < document.styleSheets[S][cssRules].length; R++) 
    {
      if (document.styleSheets[S][cssRules][R].selectorText == classname) {
        if(document.styleSheets[S][cssRules][R].style[element]){
          document.styleSheets[S][cssRules][R].style[element] = value;
          added=true;
          break;
        }
      }
    }
    if(!added)
    {
      try{
        document.styleSheets[S].insertRule(classname+' { '+element+': '+value+'; }',document.styleSheets[S][cssRules].length);
      } catch(err){
        try{document.styleSheets[S].addRule(classname,element+': '+value+';');}catch(err){}
      }
    }
  }
}
</script>
<style>
.redrect{background-color:rgba(255, 0, 0, 0.3)}
</style>
<div style=\"position:relative\">" > index.html
for i in *.txt ; do
let n++
cursor_loc_and_crop_rect=$(perl -MPOSIX -e '
sub get_x_y{
  my $line_num=shift;
  my @out=(0,0);
  $out[1] = floor($line_num / 800);
  $out[0] = $line_num - $out[1] * 800;
  return @out;
}
my $line_number=0;
my @x;
my @y;
my $x_min=799;
my $y_min=599;
my $x_max=0;
my $y_max=0;
open(FH, "<", $ARGV[0]);
while(<FH>){
  chomp;
  @rgb = split / /;
  if($rgb[0] != 0 || $rgb[1] != 0 || $rgb[2] != 0){
    @xy = get_x_y($line_number);
    if($rgb[0] >= 246 && $rgb[0] <= 254 && 
      $rgb[1] >= 0 && $rgb[1] <= 21 &&
      $rgb[2] >= 236 && $rgb[2] <= 254){
      push @x, $xy[0];
      push @y, $xy[1];
    }
    $x_min = $xy[0] if($xy[0] < $x_min);
    $y_min = $xy[1] if($y_min == 599);
    $x_max = $xy[0] if($xy[0] > $x_max);
    $y_max = $xy[1] if($xy[1] > $y_max);
  }
  $line_number++;
}
@x = sort {$a <=> $b} @x;
@y = sort {$a <=> $b} @y;
print $x[floor($#x/2)] . " " . $y[floor($#y/2)] . " $x_min $y_min $x_max $y_max" . "\n";
' $i)
crop_x=`echo "$cursor_loc_and_crop_rect" | awk '{print $3}'`
crop_y=`echo "$cursor_loc_and_crop_rect" | awk '{print $4}'`
crop_width=`echo "$cursor_loc_and_crop_rect" | awk "{print \\$5, \" - $crop_x\"}" | bc`
crop_height=`echo "$cursor_loc_and_crop_rect" | awk "{print \\$6, \" - $crop_y\"}" | bc`
convert -crop ${crop_width}x$crop_height+$crop_x+$crop_y `echo $images_to_crop | awk "{print \\$$n}"` -quality 70 d2inv_images/cropped_$n.jpg
mouse_over_width=37
mouse_over_height=30
cursor_location_x=`echo "$cursor_loc_and_crop_rect" | awk '{print $1}'`
cursor_location_y=`echo "$cursor_loc_and_crop_rect" | awk '{print $2}'`
rect_location_x=`echo $cursor_location_x - $mouse_over_width / 2 | bc`
rect_location_y=`echo $cursor_location_y - $mouse_over_height / 2 | bc`
echo "<img src=\"d2inv_images/cropped_$n.jpg\" id=\"crop$n\" style=\"position:absolute;left:${crop_x}px;top:${crop_y}px;display:none\"><div class=\"redrect\" style=\"position:absolute;width:${mouse_over_width}px;height:${mouse_over_height}px;left:${rect_location_x}px;top:${rect_location_y}px\" onmouseover=\"document.getElementById('crop$n').style.display='block';change_css('.redrect', 'background-color', 'rgba(255, 0, 0, 0)')\" onmouseout=\"document.getElementById('crop$n').style.display='none';change_css('.redrect', 'background-color', 'rgba(255, 0, 0, 0.3)')\"></div>" >> index.html
done

echo '<img src="d2inv_images/emptied.jpg" width="800" height="600" usemap="#d2char" style="border-style:none"></div>' >> index.html

