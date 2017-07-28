#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
char const *d2sfile =
"C:\\Users\\user1\\AppData\\Local\\VirtualStore\\Program Files (x86)\\Diablo II\\Save\\my_d.d2s";
#else
char const *d2sfile =
"/home/xubuntu/.wine/drive_c/Program Files (x86)/Diablo II/Save/my_d.d2s";
#endif

int main(void){
  FILE *f;
  long fsize;
  char *all;
  int ct;
  int c = 0;
  int addr;
  int add;
  /*printf("Your d2s file: %s\n", d2sfile);
  getchar();*/
  f = fopen(d2sfile, "rb");
  if(f == NULL){
    puts("ERROR: Could not open your d2s file.");
    return 1;
  }
  fseek(f, 0, SEEK_END);
  fsize = ftell(f);
  fseek(f, 0, SEEK_SET);
  all = malloc(fsize);
  fread(all, fsize, 1, f);
  fclose(f);
  for(addr=0; addr < fsize; addr++){
    ct = all[addr] & 0xFF;
    if(c < 0) ct++;
    add = 0;
    if((addr >> 2) != 3)
      add = ct;
    c = (c << 1) + add;
  }
  free(all);
  c = (c & 0xff000000) >> 24 | (c & 0xff0000) >> 8 | (c & 0xff00) << 8 | (c & 0xff) << 24;
  printf("checksum: %08X\n", c);
  return 0;
}
