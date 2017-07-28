package main
import ("fmt"; "io/ioutil"; "strconv"; "os"; "strings")
var p = fmt.Println
func check(_error error){
  if _error != nil {
    panic(_error)
  }
}
func getGemCode(_g string) string {
  pre := "1000a000650000"
  post := "02"
  middle := ""
  _g = strings.ToLower(_g)
  if strings.HasPrefix(_g, "gems_sk") {       //skull
    middle = "38b7a607"
  } else if strings.HasPrefix(_g, "gems_s") { //sapphire
    middle = "78062706"
  } else if strings.HasPrefix(_g, "gems_a") { //amethyst
    middle = "78066707"
  } else if strings.HasPrefix(_g, "gems_e") { //emerald
    middle = "78067706"
  } else if strings.HasPrefix(_g, "gems_d") { //diamond
    middle = "78067707"
  } else if strings.HasPrefix(_g, "gems_r") { //ruby
    middle = "78062707"
  } else if strings.HasPrefix(_g, "gems_t") { //topaz
    middle = "78069707"
  }
  if middle == "" {
    panic("invalid gem name")
    return "" //what a strange gem!
  }
  return pre + middle + post
}
func getRuneCode(_r string) string {
  pre := "1000a00065000028"
  post := "30302"
  middle := ""
  _r = strings.ToLower(_r)
  if _r == "runes_el" {
    middle = "071"
  } else if _r == "runes_eld" {
    middle = "072"
  } else if _r == "runes_tir" {
    middle = "073"
  } else if _r == "runes_nef" {
    middle = "074"
  } else if _r == "runes_eth" {
    middle = "075"
  } else if _r == "runes_ith" {
    middle = "076"
  } else if _r == "runes_tal" {
    middle = "077"
  } else if _r == "runes_ral" {
    middle = "078"
  } else if _r == "runes_ort" {
    middle = "079"
  } else if _r == "runes_thul" {
    middle = "170"
  } else if _r == "runes_amn" {
    middle = "171"
  } else if _r == "runes_sol" {
    middle = "172"
  } else if _r == "runes_shael" {
    middle = "173"
  } else if _r == "runes_dol" {
    middle = "174"
  } else if _r == "runes_hel" {
    middle = "175"
  } else if _r == "runes_io" {
    middle = "176"
  } else if _r == "runes_lum" {
    middle = "177"
  } else if _r == "runes_ko" {
    middle = "178"
  } else if _r == "runes_fal" {
    middle = "179"
  } else if _r == "runes_lem" {
    middle = "270"
  } else if _r == "runes_pul" {
    middle = "271"
  } else if _r == "runes_um" {
    middle = "272"
  } else if _r == "runes_mal" {
    middle = "273"
  } else if _r == "runes_ist" {
    middle = "274"
  } else if _r == "runes_gul" {
    middle = "275"
  } else if _r == "runes_vex" {
    middle = "276"
  } else if _r == "runes_ohm" {
    middle = "277"
  } else if _r == "runes_lo" {
    middle = "278"
  } else if _r == "runes_sur" {
    middle = "279"
  } else if _r == "runes_ber" {
    middle = "370"
  } else if _r == "runes_jah" {
    middle = "371"
  } else if _r == "runes_cham" {
    middle = "372"
  } else if _r == "runes_zod" {
    middle = "373"
  }
  if middle == "" {
    panic("invalid rune name")
    return "" //what a strange rune :D
  }
  return pre + middle + post
}
func main(){
  if len(os.Args) != 2 {
    panic("go run JM-inserter.go 4a4d10008040d97e79c90a09")
  }
  FirstItem := os.Args[1]
  if strings.HasPrefix(FirstItem, "runes_") {
    FirstItem = getRuneCode(FirstItem)
    p("Rune code is " + FirstItem)
  } else if strings.HasPrefix(FirstItem, "gems_") {
    FirstItem = getGemCode(FirstItem)
    p("Gem code is " + FirstItem)
  }
  if len(FirstItem) < 10 {  //FIXME what limit shouldwe have?
    panic("The item is only 10 words?")
  }
  if len(FirstItem) % 2 != 0 {
    panic("The item you want to insert needs to be % 2 == 0")
  }
  //TODO prepend 4a4d if it does not have it
  if !strings.HasPrefix(FirstItem, "4a4d") {
    FirstItem = "4a4d" + FirstItem
  }
  //TODO verify the item starts with '4a4d100'
  if !strings.HasPrefix(FirstItem, "4a4d100") {
    panic("This item is invalid. Needs to start with 4a4d100")
  }

  d2s_char_location := os.Getenv("DIABLO_II_CHAR")
  if len(d2s_char_location) == 0 {
    panic("Could not get d2 character from environment.")
  }
  dat, err := ioutil.ReadFile(d2s_char_location)
  check(err)
  oldFileSize := len(dat)
  p("the old file size is: ", oldFileSize)
  //p("searching for J from 0x330-0x370")
  item_number_location := 0
  first_item_location := 0
  for i := 0x330; i < 0x370; i++ {
    if dat[i] == 0x4a {
      if dat[i+1] == 0x4d {
        if item_number_location == 0 {
          item_number_location = i + 2
        } else {
          first_item_location = i
          break
        }
      }
    }
  }
  if first_item_location == 0 {
    panic("No JM itemmzzzzzzz ?! D:")
  }
  //we're adding one item
  fmt.Printf("Old item count: @%X\n", dat[item_number_location])
  dat[item_number_location] += 1
  fmt.Printf("New item count: @%X\n", dat[item_number_location])

/*
4a4d1000a0006500002207130302  //El and Eld
4a4d1000a0006500022207230302
*/
  FirstItemInBytes := []byte{}
  for i:=0; i<len(FirstItem); i+=2 {
    myword := FirstItem[i:i+2]
    mybyte, err := strconv.ParseUint(myword, 16, 8)
    check(err)
    mybyte2 := byte(mybyte)
    p("Appending byte to first item: ", mybyte2)
    FirstItemInBytes = append(FirstItemInBytes, mybyte2)
  }

  newFileSize := uint32(oldFileSize + len(FirstItem) / 2);
  //REMEMBER: shifting is first.
  dat[8]  = (byte)(newFileSize & 0xff)
  dat[9]  = (byte)(newFileSize >> 8 & 0xff)
  dat[10] = (byte)(newFileSize >> 16 & 0xff)
  dat[11] = (byte)(newFileSize >> 24 & 0xff)
  fmt.Printf("Setted new filesize as: %02X%02X%02X%02X\n", dat[8], dat[9], dat[10], dat[11])

  finalByteArray := []byte{}
  finalByteArray = append(finalByteArray, dat[0:first_item_location]...)
  finalByteArray = append(finalByteArray, FirstItemInBytes...)
  finalByteArray = append(finalByteArray, dat[first_item_location:]...)

  f, err := os.Create(d2s_char_location)
  check(err)
  n2, err := f.Write(finalByteArray)
  check(err)
  p("So we have successfully written ", n2, " bytes to:\n", d2s_char_location)
}
