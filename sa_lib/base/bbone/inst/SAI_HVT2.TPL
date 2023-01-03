
@ST = DO(read_text("B_USE/BCU_TGARG.TXT"), ARGUMENT(1),ARGUMENT(2),ARGUMENT(3),ARGUMENT(4), ARGUMENT_COUNT)

;1  F20_T2S          TR       F20_T2S          246      392  590  PICTNAME
;2  F20_T2S          246      F20_T2S          241      397  600  PICTNAME
;3  F20_T2S          241      F20_T2S          250      402  600  PICTNAME
;4  F20_T2S          246      F20_T2S          253      397  600  PICTNAME
;5  F20_T2S          253      F20_T2S          E        397  600  PICTNAME
;6  F20_T2S          246      F20_T2S          240*     392  610  PICTNAME
;7  F20_T2S          240*     F20_T2S         (247)     392  620  PICTNAME
;14 F20_T2S         (247)     F20_T2S          242      397  630  PICTNAME
;15 F20_T2S          242      F20_T2S          251      402  630  PICTNAME
;16 F20_T2S         (247)     F20_T2S          254      397  630  PICTNAME
;17 F20_T2S          254      F20_T2S          E        397  600  PICTNAME
;18 F20_T2S          TR       L22                       392  580  PICTNAME
;19 F20_T2S                   L23                       392  640  PICTNAME

#IF ARGUMENT(1) == "TOC" #THEN #BLOCK
  #IF PARM1_LIST:VSINGLE #THEN #BLOCK
    #CREATE TOC_LIST:V
    #IF %NrOfParam >= 0 #THEN #BLOCK
      #SET TOC_LIST:VCOLUMN1(1) = (PARM1_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN2(1) = (SUBSTR(PARM1_LIST:VPF_NAME,9,8))
      #SET TOC_LIST:VCOLUMN3(1) = (" ")
      #SET TOC_LIST:VCOLUMN4(1) = (PARM_L1_LIST:VLN)
      #SET TOC_LIST:VCOLUMN5(1) = (SUBSTR(PARM_L1_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN6(1) = (" ")
      #SET TOC_LIST:VCOLUMN7(1) = (DEC(PARM1_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8(1) = (DEC(PARM1_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9(1) = (PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 0
    #BLOCK_END
    #IF %NrOfParam == 1 #THEN #BLOCK
      #SET TOC_LIST:VCOLUMN1(2) = (PARM1_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN2(2) = (SUBSTR(PARM1_LIST:VPF_NAME,9,8))
      #SET TOC_LIST:VCOLUMN3(2) = (" ")
      #SET TOC_LIST:VCOLUMN4(2) = (PARM_L2_LIST:VLN)
      #SET TOC_LIST:VCOLUMN5(2) = (SUBSTR(PARM_L2_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN6(2) = (" ")
      #SET TOC_LIST:VCOLUMN7(2) = (DEC(PARM2_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8(2) = (DEC(PARM2_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9(2) = (PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 1
    #BLOCK_END
  #BLOCK_END
  #ELSE #BLOCK
    #CREATE TOC_LIST:V
    @X_POINTS = (PARM1_LIST:VX_POS, PARM2_LIST:VX_POS)
    @Y_POINTS = (PARM1_LIST:VY_POS, PARM2_LIST:VY_POS)

    @DeltaX = (%X_POINTS(HIGH_INDEX(%X_POINTS)) - %X_POINTS(LOW_INDEX(%X_POINTS))) DIV 6
    @DeltaY = (%Y_POINTS(HIGH_INDEX(%Y_POINTS)) - %Y_POINTS(LOW_INDEX(%Y_POINTS))) DIV 6

    #IF %X_POINTS(HIGH_INDEX(%Y_POINTS)) == %X_POINTS(LOW_INDEX(%Y_POINTS)) #THEN #BLOCK
      @Y1  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 1
      @Y2  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y3  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y4  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y5  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y6  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 3
      @Y7  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 4
      @Y8  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 5
      @Y9  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 5
      @Y10 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 5
      @Y11 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 5

      @X1  = %X_POINTS(LOW_INDEX(%X_POINTS))
      @X2  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 5
      @X3  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 10
      @X4  = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5
      @X5  = %X_POINTS(LOW_INDEX(%X_POINTS)) - 10
      @X6  = %X_POINTS(LOW_INDEX(%X_POINTS))
      @X7  = %X_POINTS(LOW_INDEX(%X_POINTS)) 
      @X8  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 5
      @X9  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 10
      @X10 = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5 
      @X11 = %X_POINTS(LOW_INDEX(%X_POINTS)) - 10
    #BLOCK_END
    #ELSE_IF %Y_POINTS(HIGH_INDEX(%X_POINTS)) == %Y_POINTS(LOW_INDEX(%X_POINTS)) #THEN #BLOCK
      @X1  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 1
      @X2  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X3  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X4  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X5  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X6  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 3
      @X7  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 4
      @X8  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 5
      @X9  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 5
      @X10 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 5
      @X11 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 5

      @Y1  = %Y_POINTS(LOW_INDEX(%Y_POINTS))
      @Y2  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 5
      @Y3  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 10
      @Y4  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
      @Y5  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 10
      @Y6  = %Y_POINTS(LOW_INDEX(%Y_POINTS))
      @Y7  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) 
      @Y8  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 5
      @Y9  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 10
      @Y10 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
      @Y11 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 10
    #BLOCK_END

    #IF %NrOfParam >= 0 #THEN #BLOCK
      #CREATE TOC_LIST:V
      #SET TOC_LIST:VCOLUMN1 = (PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN)
      #SET TOC_LIST:VCOLUMN2 = (SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN3 =  ("TR", -
                                DEC(PARM1_LIST:VPNODE1_IX,1), -
                                DEC(PARM1_LIST:VSWITCH2_IX,1), -
                                DEC(PARM1_LIST:VPNODE1_IX,1), -
                                DEC(PARM1_LIST:VSWITCH6_IX,1), -
                                DEC(PARM1_LIST:VPNODE1_IX,1), -
                                DEC(PARM1_LIST:VSWITCH1_IX,1), -
                                " ",-    ;  DEC(PARM1_LIST:VPNODE3_IX,1), -
                                DEC(PARM1_LIST:VSWITCH3_IX,1), -
                                " ",-    ;  DEC(PARM1_LIST:VPNODE3_IX,1), -
                                DEC(PARM1_LIST:VSWITCH7_IX,1), -
                                "TR")
      #SET TOC_LIST:VCOLUMN4 = (PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM1_LIST:VLN, -
                                PARM_L1_LIST:VLN)
      #SET TOC_LIST:VCOLUMN5 = (SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM1_LIST:VLN,9,8), -
                                SUBSTR(PARM_L1_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN6 = (DEC(PARM1_LIST:VPNODE1_IX,1), -
                                DEC(PARM1_LIST:VSWITCH2_IX,1), -
                                DEC(PARM1_LIST:VCOLOR1_IX,1), -
                                DEC(PARM1_LIST:VSWITCH6_IX,1), -
                                "E", -
                                DEC(PARM1_LIST:VSWITCH1_IX,1), -
                                " ",-      ; DEC(PARM1_LIST:VPNODE3_IX,1), -
                                DEC(PARM1_LIST:VSWITCH3_IX,1), -
                                DEC(PARM1_LIST:VCOLOR2_IX,1), -
                                DEC(PARM1_LIST:VSWITCH7_IX,1), -
                                "E", -
                                " ")
      #SET TOC_LIST:VCOLUMN7 = (DEC(%X1,1), -
                                DEC(%X2,1), -
                                DEC(%X3,1), -
                                DEC(%X4,1), -
                                DEC(%X5,1), -
                                DEC(%X6,1), -
                                DEC(%X7,1), -
                                DEC(%X8,1), -
                                DEC(%X9,1), -
                                DEC(%X10,1), -
                                DEC(%X11,1), -
                                DEC(PARM1_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8 = (DEC(%Y1,1), -
                                DEC(%Y2,1), -
                                DEC(%Y3,1), -
                                DEC(%Y4,1), -
                                DEC(%Y5,1), -
                                DEC(%Y6,1), -
                                DEC(%Y7,1), -
                                DEC(%Y8,1), -
                                DEC(%Y9,1), -
                                DEC(%Y10,1), -
                                DEC(%Y11,1), -
                                DEC(PARM1_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9 = (PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME)
    @NEW_PFC_CTR = 0
    #BLOCK_END
    #IF %NrOfParam == 1 #THEN #BLOCK
      #SET TOC_LIST:VCOLUMN1(13) = (PARM1_LIST:VLN)
      #SET TOC_LIST:VCOLUMN2(13) = (SUBSTR(PARM1_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN3(13) = (" ")
      #SET TOC_LIST:VCOLUMN4(13) = (PARM_L2_LIST:VLN)
      #SET TOC_LIST:VCOLUMN5(13) = (SUBSTR(PARM_L2_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN6(13) = (" ")
      #SET TOC_LIST:VCOLUMN7(13) = (DEC(PARM2_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8(13) = (DEC(PARM2_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9(13) = (PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 1
    #BLOCK_END

  #BLOCK_END

; Return the template
  @RETURN_VALUE = DO(READ_TEXT("B_USE/BCU_TGOUT.TXT"), ARGUMENT(1), "NONE", %TOC_LIST, %NEW_PFC_CTR)
  #RETURN %RETURN_VALUE
#BLOCK_END

;                                    SWITCH  TRAFO   F20_T3S  TR      
;                                    NODE    PASSIVE F20_T3S  246     
;                                    SWITCH  IS      F20_T3S  241     
;                                    NODE    ACTIVE  F20_T3S  250     
;                                    SWITCH  IS      F20_T3S  253     
;                                    NODE    GROUNDEDF20_T3S  E       
;                                    SWITCH  IS      F20_T3S  240     
;                                    NODE    PASSIVE F20_T3S (247)
;                                    SWITCH  IS      F20_T3S  242     
;                                    NODE    ACTIVE  F20_T3S  251     
;                                    SWITCH  IS      F20_T3S  254     


#IF ARGUMENT(1) == "TOP" #THEN #BLOCK
  #IF PARM1_LIST:VSINGLE #THEN #BLOCK
    #CREATE TOP_LIST:V
    #SET TOP_LIST:VCOLUMN1 = VECTOR(" ")
    #SET TOP_LIST:VCOLUMN2 = VECTOR(SUBSTR(PARM1_LIST:VPF_NAME,9,8))
    #SET TOP_LIST:VCOLUMN3 = VECTOR(" ")
    #SET TOP_LIST:VCOLUMN4 = VECTOR("SWITCH")
    #SET TOP_LIST:VCOLUMN5 = VECTOR("TRAFO")
    #SET TOP_LIST:VCOLUMN6 = VECTOR(PARM1_LIST:VPF_NAME)
    #SET TOP_LIST:VCOLUMN7 = VECTOR(" ")
  #BLOCK_END
  #ELSE #BLOCK
    #CREATE TOP_LIST:V
    #SET TOP_LIST:VCOLUMN1 = (" ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ")
    #SET TOP_LIST:VCOLUMN2 = (SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8), -
                              SUBSTR(PARM1_LIST:VLN,9,8))
    #SET TOP_LIST:VCOLUMN3 = (" ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ", -
                              " ")
    #SET TOP_LIST:VCOLUMN4 = ("SWITCH", -
                              "NODE", -
                              "SWITCH", -
                              "NODE", -
                              "SWITCH", -
                              "NODE", -
                              "SWITCH", -
                              "NODE", -
                              "SWITCH", -
                              "NODE", -
                              "SWITCH")
    #SET TOP_LIST:VCOLUMN5 =  ("TRAFO", -
                              "PASSIVE", -
                              "IS", -
                              "ACTIVE", -
                              "IS", -
                              "GROUNDED", -
                              "IS", -
                              "PASSIVE", -
                              "IS", -
                              "ACTIVE", -
                              "IS")
    #SET TOP_LIST:VCOLUMN6 = (PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN, -
                              PARM1_LIST:VLN)
    #SET TOP_LIST:VCOLUMN7 = ("TR", -
                              DEC(PARM1_LIST:VPNODE1_IX,1), -
                              DEC(PARM1_LIST:VSWITCH2_IX,1), -
                              DEC(PARM1_LIST:VCOLOR1_IX,1), -
                              DEC(PARM1_LIST:VSWITCH6_IX,1), -
                              "E", -
                              DEC(PARM1_LIST:VSWITCH1_IX,1), -
                              " ",-    ; DEC(PARM1_LIST:VPNODE3_IX,1), -
                              DEC(PARM1_LIST:VSWITCH3_IX,1), -
                              DEC(PARM1_LIST:VCOLOR2_IX,1), -
                              DEC(PARM1_LIST:VSWITCH7_IX,1))
  #BLOCK_END

; Return the template
  @RETURN_VALUE = DO(READ_TEXT("B_USE/BCU_TGOUT.TXT"), ARGUMENT(1), "NONE", %TOP_LIST)
  #RETURN %RETURN_VALUE
#BLOCK_END

;
;
;
; PAR
;
;

#IF ARGUMENT(1) == "PAR" #THEN #BLOCK
  #IF DATA_TYPE(PARM1_LIST:VLN) == "NONE" AND -
       PARM1_LIST:VLN == "" #THEN #BLOCK
    #SET WARNING_LIST:VCOLUMN1(%LW) = "ERROR"
    #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_NAME
    #SET WARNING_LIST:VCOLUMN3(%LW) = "1"
    @LW = %LW + 1
    #RETURN %WARNING_LIST 
  #BLOCK_END

  #IF (PARM1_LIST:VSINGLE) #THEN #BLOCK
         ; Do nothing, variables in draw pgm. are missing.
         ; Only single color defined by connecting line will be used.
         ; No entry in .par file necessary.
  #BLOCK_END 
  #ELSE_IF DATA_TYPE(PARM1_LIST:VCOLOR_SPLIT)<>"NONE" #THEN #BLOCK 
       ; Bidirectional version of Trafo PF. Added with V1.10 of BB coloring

    #IF PARM1_LIST:VCOLOR_SPLIT<>"NONE" #THEN #BLOCK 

      #IF DATA_TYPE(PARM1_LIST:VPNODE1_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_3
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VPNODE1_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VPNODE1_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "50"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH2_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH2_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH2_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "51"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VCOLOR1_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VCOLOR1_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VCOLOR1_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "52"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH6_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH6_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH6_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "53"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH1_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH1_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH1_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "53"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VPNODE2_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_3
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VPNODE2_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = (" ")      ; DEC(PARM1_LIST:VPNODE2_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "54"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH3_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH3_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH3_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "55"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VCOLOR2_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VCOLOR2_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VCOLOR2_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "56"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH7_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH7_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH7_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "55"
        @LW = %LW + 1
      #BLOCK_END

    #BLOCK_END  ;(IF COLOR_SPLIT <> "NONE") 
    #ELSE #BLOCK   
         ; No active coloring configured. Single Color defined by connecting line will
         ; be used. No entry in .par file necessary.
    #BLOCK_END  ;(ELSE COLOR_SPLIT<>"NONE")
  #BLOCK_END  ;(DATA_TYPE(COLOR_SPLIT)<>"NONE")

; Return the template 
  @RETURN_VALUE = DO(READ_TEXT("B_USE/BCU_TGOUT.TXT"), ARGUMENT(1), %WARNING_LIST, %PAR_LIST)
  #RETURN %RETURN_VALUE
    
#BLOCK_END ;(PAR)




