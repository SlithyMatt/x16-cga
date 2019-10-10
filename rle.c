#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void main(int argc, char **argv) {
   FILE *ifp;
   FILE *ofp;
   
   int count;
   int bytesread;
   uint8_t lastbyte;
   uint8_t nextbyte;
   uint8_t odata[2];

   if (argc < 3) {
      printf("Usage: %s [raw input] [LRE compressed output]\n", argv[0]);
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
   
   fread(&lastbyte,1,1,ifp);
   count = 1;
   while (!feof(ifp)) {
      bytesread = fread(&nextbyte,1,1,ifp);
      if ((count == 255) || (nextbyte != lastbyte) || (bytesread == 0)) {
         odata[0] = count;
         odata[1] = lastbyte;
         fwrite(odata,1,2,ofp);
         lastbyte = nextbyte;
         count = 1;
      } else {         
         count++;
      }
   }
}
