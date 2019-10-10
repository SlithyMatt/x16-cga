#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void main(int argc, char **argv) {
   FILE *ifp;
   FILE *ofp;
   
   uint8_t idata[2];
   uint8_t odata;

   if (argc < 3) {
      printf("Usage: %s [1ppb input] [4ppb output]\n", argv[0]);
      return;
   }

   ifp = fopen(argv[1], "r");
   if (ifp == NULL) {
      printf("Error opening %s for reading\n", argv[1]);
      return;
   }
   ofp = fopen(argv[2], "w");
   if (ofp == NULL) {
      printf("Error opening %s for writing\n", argv[2]);
      return;
   }
   
   while (!feof(ifp)) {
      if (fread(idata,1,2,ifp) > 0) {
         odata = (idata[0] & 0xf) << 4;
         odata |= idata[1] & 0xf;
         fwrite(&odata,1,1,ofp);
      }
   }
}   

