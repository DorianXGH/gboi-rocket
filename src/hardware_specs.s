; ///////// Hardware Spec \\\\\\\\\
.ROMDMG
.NAME "PONGDEMO"
.CARTRIDGETYPE 0
.RAMSIZE 0
.COMPUTEGBCHECKSUM
.COMPUTEGBCOMPLEMENTCHECK
.LICENSEECODENEW "00"
.EMPTYFILL $00

.MEMORYMAP
	SLOTSIZE $4000
	DEFAULTSLOT 0
	SLOT 0 $0000
	SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

.BANK 0 SLOT 0
; \\\\\\\\\ Hardware Spec /////////

;Logo Nintendo, mandatory...
.NINTENDOLOGO
