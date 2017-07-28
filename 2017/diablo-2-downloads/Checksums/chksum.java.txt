import java.io.*;

public class chksum{
  public static void main(String[] args){
    String os = System.getProperty("os.name");
    String d2sfile = 
"/home/xubuntu/.wine/drive_c/Program Files (x86)/Diablo II/Save/my_d.d2s";
    if(!os.equals("Linux"))
      d2sfile = 
"C:\\Users\\user1\\AppData\\Local\\VirtualStore\\Program Files (x86)\\Diablo II\\Save\\my_d.d2s";

    File f = new File(d2sfile);
    if(!f.exists() || !f.canRead()){
      o("Your d2s file doesn't exist! Youch!");
      return;
    }

    FileInputStream fis;
    try{
      fis = new FileInputStream(f);
    }
    catch(Exception ex){
      o("what....the...FUCK.");
      return;
    }

    int toread = 0;
    try{
      toread = fis.available();
    }
    catch(Exception ex){
      o("Sorry folks. can't read your stupid d2s file.");
      return;
    }
    byte[] all = new byte[toread];
    try{
      if(fis.read(all) != toread){
        o("FUCK YOU JAVA");
        return;
      }
      fis.close();
    }
    catch(Exception ex){
      ex.printStackTrace();
      return;
    }
    //o(Integer.toString(ub(all[0])));
    
    int ct;
    int c = 0;
    for(int addr=0; addr<toread; addr++){
      ct = ub(all[addr]);
      if(c < 0) ct++;
      int add = 0;
      if((addr >> 2) != 3)
        add = ct;
      c = (c << 1) + add;      
    }
    c = (c & 0xff000000) >> 24 | (c & 0xff0000) >> 8 | (c & 0xff00) << 8 | (c & 0xff) << 24;
    String chksum = Integer.toHexString(c).toUpperCase();
    while(chksum.length() < 8)  //pad that shit. just in case.
      chksum = "0" + chksum;
    /*chksum = chksum.substring(6, 8) +
             chksum.substring(4, 6) +
             chksum.substring(2, 4) +
             chksum.substring(0, 2);
    */
    o("Checksum: " + chksum);
  }
  public static int ub(byte _b) { return _b & 0xFF; }
  private static void o(String _o){ System.out.println(_o); }
}
