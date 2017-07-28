#include <iostream>
#include <fstream>
#include <iomanip>
using namespace std;

#ifdef _WIN32
char const *d2sfile =
"C:\\Users\\user1\\AppData\\Local\\VirtualStore\\Program Files (x86)\\Diablo II\\Save\\my_d.d2s";
#else
char const *d2sfile =
"/home/xubuntu/.wine/drive_c/Program Files (x86)/Diablo II/Save/my_d.d2s";
#endif

int main () {
  streampos size;
  char * memblock;

  ifstream file (d2sfile, ios::in|ios::binary|ios::ate);
  if (!file.is_open()){
    cout << "unable to open your d2s file." << endl;
    return 1;
  }
  size = file.tellg();
  memblock = new char[size];
  file.seekg (0, ios::beg);
  file.read (memblock, size);
  file.close();
  //int ct = memblock[0] & 0xFF;
  //cout << "now we can read the data:" << ct << endl;
  
  int ct;
  int c = 0;
  for(int addr=0; addr<size; addr++){
    ct = memblock[addr] & 0xFF;
    if(c < 0) ct++;
    int add = 0;
    if((addr >> 2) != 3)
      add = ct;
    c = (c << 1) + add;
  }
  delete[] memblock;
  
  c = (c & 0xff000000) >> 24 | (c & 0xff0000) >> 8 | (c & 0xff00) << 8 | (c & 0xff) << 24;
  // now we convert the integer into hexadecimal.
  cout << "checksum: " << setfill ('0') << setw(8) << hex << c;
  cout << endl;
  return 0;
}