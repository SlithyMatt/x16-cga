#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void main(int argc, char **argv) {
   FILE *ifp;
   FILE *ofp;
   
   uint8_t idata[4];
   char oline[24];
   size_t bytes_read;
   int i;

   if (argc < 3) {
      printf("Usage: %s [binary input] [6502 assembly output]\n", argv[0]);
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
      bytes_read = fread(idata,1,4,ifp);
      if (bytes_read == 4) {
         sprintf(oline,".byte $%02X,$%02X,$%02X,$%02X\n", 
                 idata[0], idata[1], idata[2], idata[3]);
         fputs(oline,ofp);
      } else {
         for (i=0; i<bytes_read; i++) {
            sprintf(oline,".byte $%02X\n", idata[i]);
            fputs(oline,ofp);
         }
      }
   }
   
   fclose(ifp);
   fclose(ofp);
}

