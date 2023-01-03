;LOAD GRAPHICS PROCEDURES INTO SYSTEM VARIABLE

@SYS_VAR_OBJ = MON:BEX

#IF DATA_TYPE('SYS_VAR_OBJ':BSV(7)) <> "LIST" #THEN @UPDATE = TRUE
#ELSE #BLOCK
   @TMP = 'SYS_VAR_OBJ':BSV7
   #ERROR IGNORE
   @CURR_REV = TMP:VREVISION
   #ERROR STOP
   #IF STATUS == 0 #THEN #BLOCK
      @UPDATE = %CURR_REV <> %DISK_REV
   #BLOCK_END
   #ELSE @UPDATE = TRUE
#BLOCK_END

#IF %UPDATE #THEN #BLOCK

@FILES = (-
   "XCSHAD",-
   "XDB",-
   "XDD",-
   "XDRB",-
   "XDRBS",-
   "XDDB",-
   "XDDFR",-
   "XDF",-
   "XDFD",-
   "XDFL",-
   "XDFR",-
   "XDPB",-
   "XDPBS",-
   "XDRB",-
   "XDRBS",-
   "XDSB",-
   "XDSH",-
   "XDSV")

#CREATE OBJ:V


#LOOP_WITH I = 1..LENGTH(%FILES)
   @LN = %FILES(%I)
   @FILENAME = %LN + ".TXT"
   @READ = READ_TEXT("GPRC/'FILENAME'")
   @ATTRIB = %READ(1)
   @SCIL = Compile(%READ(2..))
   #SET OBJ:V'ATTRIB' = SCIL:vCode
#LOOP_END

; Define miscellaneous parameters
#SET OBJ:VSHADOW_THICKNESS = 2
#SET OBJ:VREVISION = %DISK_REV;  FROM LAN_FGDEF.COM
#SET OBJ:VKEY_MARGIN = 1
#SET OBJ:VBORDER_WIDTH = 6

; Load old command procedures to variable
@FILES = (-
   "XRED_D",-
   "XRED_N",-
   "XREF_D",-
   "XREF_N",-
   "XREL_D",-
   "XREL_N",-
   "XREP_A",-
   "XREP_N",-
   "XRER_D",-
   "XRER_N",-
   "XRAD_N",-
   "XRAD_A")

#LOOP_WITH I = 1..LENGTH(%FILES)
   @LN = %FILES(%I)
   @FILENAME = %LN + ".TXT"
   @READ = READ_TEXT("GPRC/'FILENAME'")
   @ATTRIB = %LN
   @SCIL = %READ(2..)
   #SET OBJ:V'ATTRIB' = %SCIL
#LOOP_END

#SET 'SYS_VAR_OBJ':BSV7 = %OBJ

#BLOCK_END

