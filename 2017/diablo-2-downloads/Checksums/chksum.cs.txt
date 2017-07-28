using System;
using System.IO;
namespace Hello{
  class Hello{
    static void o(string _s){Console.WriteLine(_s);}
    static int Main(string[] args){
      string os = System.Environment.OSVersion.ToString();
      string d2sfile = "/home/xubuntu/.wine/drive_c/Program Files (x86)/Diablo II/Save/my_d.d2s";
      if (os.StartsWith("Microsoft Windows"))
        d2sfile = "C:\\Users\\user1\\AppData\\Local\\VirtualStore\\Program Files (x86)\\Diablo II\\Save\\my_d.d2s";

      try
      {
        FileStream fs = new FileStream(d2sfile, FileMode.Open);
        int ct;
        int c = 0;
        int addr = 0;
        while((ct = fs.ReadByte()) > -1)
        {
          if (c < 0)
          {
            //Console.WriteLine("Is negative: " + c.ToString());
            ct++;
          }
          int add = 0;
          if ((addr >> 2) != 3)
            add = ct;
          c = (c << 1) + add;
          addr++;
        }
        uint c2 = ((uint)c & 0xff000000) >> 24 | ((uint)c & 0xff0000) >> 8 | ((uint)c & 0xff00) << 8 | ((uint)c & 0xff) << 24;
        string chksum = c2.ToString("X8");
        o("Checksum: " + chksum);
        //Console.WriteLine("Checksum: " + chksum.Substring(6, 2) + chksum.Substring(4, 2) 
        //  + chksum.Substring(2, 2) + chksum.Substring(0, 2));
      }
      catch (Exception ex)
      {
        Console.WriteLine(ex.Message);
      }
      Console.WriteLine("Press ENTER to continue/exit.");
      Console.ReadKey();
      return 0;
    }
  }
}
