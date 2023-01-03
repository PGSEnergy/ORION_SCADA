
@ST = DO(read_text("B_USE/BCU_TGARG.TXT"), ARGUMENT(1),ARGUMENT(2),ARGUMENT(3),ARGUMENT(4), ARGUMENT_COUNT)

;1  F20_T2S          TR       F20_T2S          246      392  590  PICTNAME
;2  F20_T2S          246      F20_T2S          241      397  600  PICTNAME
;3  F20_T2S          241      F20_T2S          250      402  600  PICTNAME
;4  F20_T2S          246      F20_T2S          253      397  600  PICTNAME
;5  F20_T2S          253      F20_T2S          E        397  600  PICTNAME
;6  F20_T2S          246      F20_T2S          240*     392  610  PICTNAME
;7  F20_T2S          240*     F20_T2S         (248)     402  610  PICTNAME
;8  F20_T2S         (248)     F20_T2S          243      407  620  PICTNAME
;9  F20_T2S          243      F20_T2S          252      412  620  PICTNAME
;10 F20_T2S         (248)     F20_T2S          255      407  620  PICTNAME
;11 F20_T2S          255      F20_T2S          E        397  600  PICTNAME
;12 F20_T2S         (248)     F20_T2S          244*     407  620  PICTNAME
;13 F20_T2S          244*     F20_T2S          247      392  620  PICTNAME
;14 F20_T2S          247      F20_T2S          242      397  630  PICTNAME
;15 F20_T2S          242      F20_T2S          251      402  630  PICTNAME
;16 F20_T2S          247      F20_T2S          254      397  630  PICTNAME
;17 F20_T2S          254      F20_T2S          E        397  600  PICTNAME
;18 F20_T2S          TR       L22                       392  580  PICTNAME
;19 F20_T2S                   L23                       392  640  PICTNAME
;20 F20_T2S                   L24                       416  610  PICTNAME


#IF ARGUMENT(1) == "TOC" #THEN #BLOCK

    @X_POINTS = (PARM1_LIST:VX_POS, PARM2_LIST:VX_POS, PARM3_LIST:VX_POS)
    @Y_POINTS = (PARM1_LIST:VY_POS, PARM2_LIST:VY_POS, PARM3_LIST:VY_POS)

    @DeltaX = (%X_POINTS(HIGH_INDEX(%X_POINTS)) - %X_POINTS(LOW_INDEX(%X_POINTS))) DIV 6
    @DeltaY = (%Y_POINTS(HIGH_INDEX(%Y_POINTS)) - %Y_POINTS(LOW_INDEX(%Y_POINTS))) DIV 6

    #IF %X_POINTS(HIGH_INDEX(%Y_POINTS)) == %X_POINTS(LOW_INDEX(%Y_POINTS)) #THEN #BLOCK
      @L_IX  = (1, 2, 3)
      @L1_IX =  LOW_INDEX(%Y_POINTS)
      @L2_IX = HIGH_INDEX(%Y_POINTS)
      @TMP   = DELETE_ELEMENT (%L_IX, (%L1_IX, %L2_IX))
      @L3_IX = %TMP(1)

      @TMP_PARM_L1_LIST = %PARM_L'L1_IX'_LIST
      @TMP_PARM_L2_LIST = %PARM_L'L2_IX'_LIST
      @TMP_PARM_L3_LIST = %PARM_L'L3_IX'_LIST

      @PARM_L1_LIST = %TMP_PARM_L1_LIST
      @PARM_L2_LIST = %TMP_PARM_L2_LIST
      @PARM_L3_LIST = %TMP_PARM_L3_LIST

      @Y1  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 1
      @Y2  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y3  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y4  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y5  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 2
      @Y6  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 3
      @Y7  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 3
      @Y8  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 4
      @Y9  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 4
      @Y10 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 3
      @Y11 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 3
      @Y12 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 4
      @Y13 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 4
      @Y14 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 5
      @Y15 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 5
      @Y16 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 4
      @Y17 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + %DeltaY * 4

      @X1  = %X_POINTS(LOW_INDEX(%X_POINTS))
      @X2  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 5
      @X3  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 10
      @X4  = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5
      @X5  = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5
      @X6  = %X_POINTS(LOW_INDEX(%X_POINTS))
      @X7  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 10
      @X8  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 15
      @X9  = %X_POINTS(LOW_INDEX(%X_POINTS)) + 20
      @X10 = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5 
      @X11 = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5 
      @X12 = %X_POINTS(LOW_INDEX(%X_POINTS)) + 10
      @X13 = %X_POINTS(LOW_INDEX(%X_POINTS)) 
      @X14 = %X_POINTS(LOW_INDEX(%X_POINTS)) + 5
      @X15 = %X_POINTS(LOW_INDEX(%X_POINTS)) + 10
      @X16 = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5 
      @X17 = %X_POINTS(LOW_INDEX(%X_POINTS)) - 5 
    #BLOCK_END
    #ELSE_IF %Y_POINTS(HIGH_INDEX(%X_POINTS)) == %Y_POINTS(LOW_INDEX(%X_POINTS)) #THEN #BLOCK
      @L_IX  = (1, 2, 3)
      @L1_IX =  LOW_INDEX(%X_POINTS)
      @L2_IX = HIGH_INDEX(%X_POINTS)
      @TMP   = DELETE_ELEMENT (%L_IX, (%L1_IX, %L2_IX))
      @L3_IX = %TMP(1)

      @TMP_PARM_L1_LIST = %PARM_L'L1_IX'_LIST
      @TMP_PARM_L2_LIST = %PARM_L'L2_IX'_LIST
      @TMP_PARM_L3_LIST = %PARM_L'L3_IX'_LIST

      @PARM_L1_LIST = %TMP_PARM_L1_LIST
      @PARM_L2_LIST = %TMP_PARM_L2_LIST
      @PARM_L3_LIST = %TMP_PARM_L3_LIST

      @X1  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 1
      @X2  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X3  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X4  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X5  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 2
      @X6  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 3
      @X7  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 3
      @X8  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 4
      @X9  = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 4
      @X10 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 3
      @X11 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 3
      @X12 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 4
      @X13 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 4
      @X14 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 5
      @X15 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 5
      @X16 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 4
      @X17 = %X_POINTS(LOW_INDEX(%X_POINTS)) + %DeltaX * 4

      @Y1  = %Y_POINTS(LOW_INDEX(%Y_POINTS))
      @Y2  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 5
      @Y3  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 10
      @Y4  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
      @Y5  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
      @Y6  = %Y_POINTS(LOW_INDEX(%Y_POINTS))
      @Y7  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 10
      @Y8  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 15
      @Y9  = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 20
      @Y10 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
      @Y11 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
      @Y12 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 10
      @Y13 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) 
      @Y14 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 5
      @Y15 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) + 10
      @Y16 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
      @Y17 = %Y_POINTS(LOW_INDEX(%Y_POINTS)) - 5 
    #BLOCK_END

  #IF PARM1_LIST:VSINGLE #THEN #BLOCK
      ;T3S                       T3S              T1       536  592  BADEN2
      ;T3S                       T3S              T2       536  592  BADEN2
      ;T3S                       L24                       536  580  BADEN2    
      ;T3S              T1       L25                       536  640  BADEN2    
      ;T3S              T2       L26                       560  610  BADEN2    

    #IF %NrOfParam >= 0 #THEN #BLOCK
      #CREATE TOC_LIST:V
      #SET TOC_LIST:VCOLUMN1 = (PARM1_LIST:VPF_NAME, -
                                PARM1_LIST:VPF_NAME, -
                                PARM1_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN2 = (SUBSTR(PARM1_LIST:VPF_NAME,9,8), -
                                SUBSTR(PARM1_LIST:VPF_NAME,9,8), -
                                SUBSTR(PARM1_LIST:VPF_NAME,9,8)) 
      #SET TOC_LIST:VCOLUMN3 = (" ", -
                                " ", -
                                " ") 
      #SET TOC_LIST:VCOLUMN4 = (PARM1_LIST:VPF_NAME, -
                                PARM1_LIST:VPF_NAME, -
                                PARM_L1_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN5 = (SUBSTR(PARM1_LIST:VPF_NAME,9,8), -
                                SUBSTR(PARM1_LIST:VPF_NAME,9,8), -
                                SUBSTR(PARM_L1_LIST:VPF_NAME,9,8))
      #SET TOC_LIST:VCOLUMN6 = ("T1", -
                                "T2", -
                                " ") 
      #SET TOC_LIST:VCOLUMN7 = (DEC(%X1,1), -
                                DEC(%X1,1), -
                                DEC(PARM1_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8 = (DEC(%Y1,1), -
                                DEC(%Y1,1), -
                                DEC(PARM1_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9 = (PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 0
    #BLOCK_END
    #IF %NrOfParam >= 1 #THEN #BLOCK
      ; Second Winding
      #SET TOC_LIST:VCOLUMN1(4) = (PARM1_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN2(4) = (SUBSTR(PARM1_LIST:VPF_NAME,9,8))
      #SET TOC_LIST:VCOLUMN3(4) = ("T1")
      #SET TOC_LIST:VCOLUMN4(4) = (PARM_L2_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN5(4) = (SUBSTR(PARM_L2_LIST:VPF_NAME,9,8))
      #SET TOC_LIST:VCOLUMN6(4) = (" ")
      #SET TOC_LIST:VCOLUMN7(4) = (DEC(PARM2_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8(4) = (DEC(PARM2_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9(4) = (PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 1
    #BLOCK_END
    #IF %NrOfParam == 2 #THEN #BLOCK
      ; Third Winding
      #SET TOC_LIST:VCOLUMN1(5) = (PARM1_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN2(5) = (SUBSTR(PARM1_LIST:VPF_NAME,9,8))
      #SET TOC_LIST:VCOLUMN3(5) = ("T2")
      #SET TOC_LIST:VCOLUMN4(5) = (PARM_L3_LIST:VPF_NAME)
      #SET TOC_LIST:VCOLUMN5(5) = (SUBSTR(PARM_L3_LIST:VPF_NAME,9,8))
      #SET TOC_LIST:VCOLUMN6(5) = (" ")
      #SET TOC_LIST:VCOLUMN7(5) = (DEC(PARM3_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8(5) = (DEC(PARM3_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9(5) = (PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 2
    #BLOCK_END
  #BLOCK_END
  #ELSE #BLOCK
    #CREATE TOC_LIST:V

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
                                DEC(PARM1_LIST:VSWITCH4_IX,1), -
                                " ",-    ;  DEC(PARM1_LIST:VPNODE3_IX,1), -
                                DEC(PARM1_LIST:VSWITCH8_IX,1), -
                                " ",-    ;  DEC(PARM1_LIST:VPNODE3_IX,1), -
                                DEC(PARM1_LIST:VSWITCH5_IX,1), -
                                DEC(PARM1_LIST:VPNODE2_IX,1), -
                                DEC(PARM1_LIST:VSWITCH3_IX,1), -
                                DEC(PARM1_LIST:VPNODE2_IX,1), -
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
                                DEC(PARM1_LIST:VSWITCH4_IX,1), -
                                DEC(PARM1_LIST:VCOLOR3_IX,1), -
                                DEC(PARM1_LIST:VSWITCH8_IX,1), -
                                "E", -
                                DEC(PARM1_LIST:VSWITCH5_IX,1), -
                                DEC(PARM1_LIST:VPNODE2_IX,1), -
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
                                DEC(%X12,1), -
                                DEC(%X13,1), -
                                DEC(%X14,1), -
                                DEC(%X15,1), -
                                DEC(%X16,1), -
                                DEC(%X17,1), -
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
                                DEC(%Y12,1), -
                                DEC(%Y13,1), -
                                DEC(%Y14,1), -
                                DEC(%Y15,1), -
                                DEC(%Y16,1), -
                                DEC(%Y17,1), -
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
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME, -
                                PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 0
    #BLOCK_END
    #IF %NrOfParam >= 1 #THEN #BLOCK
      ; Second Winding

      #SET TOC_LIST:VCOLUMN1(19) = (PARM1_LIST:VLN)
      #SET TOC_LIST:VCOLUMN2(19) = (SUBSTR(PARM1_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN3(19) = (DEC(PARM1_LIST:VPNODE2_IX,1))
      #SET TOC_LIST:VCOLUMN4(19) = (PARM_L2_LIST:VLN)
      #SET TOC_LIST:VCOLUMN5(19) = (SUBSTR(PARM_L2_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN6(19) = (" ")
      #SET TOC_LIST:VCOLUMN7(19) = (DEC(PARM2_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8(19) = (DEC(PARM2_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9(19) = (PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 1
    #BLOCK_END
    #IF %NrOfParam == 2 #THEN #BLOCK
      ; Third Winding

      #SET TOC_LIST:VCOLUMN1(20) = (PARM1_LIST:VLN)
      #SET TOC_LIST:VCOLUMN2(20) = (SUBSTR(PARM1_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN3(20) = (" ")
      #SET TOC_LIST:VCOLUMN4(20) = (PARM_L3_LIST:VLN)
      #SET TOC_LIST:VCOLUMN5(20) = (SUBSTR(PARM_L3_LIST:VLN,9,8))
      #SET TOC_LIST:VCOLUMN6(20) = (" ")
      #SET TOC_LIST:VCOLUMN7(20) = (DEC(PARM3_LIST:VX_POS,1))
      #SET TOC_LIST:VCOLUMN8(20) = (DEC(PARM3_LIST:VY_POS,1))
      #SET TOC_LIST:VCOLUMN9(20) = (PARM1_LIST:VPICT_NAME)
      @NEW_PFC_CTR = 2
    #BLOCK_END
  #BLOCK_END

; Return the template
  @RETURN_VALUE = DO(READ_TEXT("B_USE/BCU_TGOUT.TXT"), ARGUMENT(1), "NONE", %TOC_LIST, %NEW_PFC_CTR)
  #RETURN %RETURN_VALUE
#BLOCK_END

;1                                     SWITCH  TRAFO   F20_T2S  TR      
;2                                     NODE    PASSIVE F20_T2S  246     
;3                                     SWITCH  IS      F20_T2S  241     
;4                                     NODE    ACTIVE  F20_T2S  250     
;5                                     SWITCH  IS      F20_T2S  253
;6                                     NODE    GROUNDEDF20_T2S  E
;7                                     SWITCH  IS      F20_T2S  240     
;8                                     NODE    PASSIVE F20_T2S  248
;9                                     SWITCH  IS      F20_T2S  243     
;10                                    NODE    ACTIVE  F20_T2S  252
;11                                    SWITCH  IS      F20_T2S  255
;12                                    SWITCH  IS      F20_T2S  244          
;13                                    NODE    PASSIVE F20_T2S  247
;14                                    SWITCH  IS      F20_T2S  242     
;15                                    NODE    ACTIVE  F20_T2S  251
;16                                    SWITCH  IS      F20_T2S  254

#IF ARGUMENT(1) == "TOP" #THEN #BLOCK
  #IF PARM1_LIST:VSINGLE #THEN #BLOCK
    #CREATE TOP_LIST:V
    #SET TOP_LIST:VCOLUMN1 = (" ", -
                              " ", -
                              " ")
    #SET TOP_LIST:VCOLUMN2 = (SUBSTR(PARM1_LIST:VPF_NAME,9,8), -
                              SUBSTR(PARM1_LIST:VPF_NAME,9,8), -
                              SUBSTR(PARM1_LIST:VPF_NAME,9,8))
    #SET TOP_LIST:VCOLUMN3 = (" ", -
                              " ", -
                              " ")
    #SET TOP_LIST:VCOLUMN4 = ("NODE", -
                              "SWITCH", -
                              "SWITCH")
    #SET TOP_LIST:VCOLUMN5 = ("PASSIVE", -
                              "TRAFO", -
                              "TRAFO")
    #SET TOP_LIST:VCOLUMN6 = (PARM1_LIST:VPF_NAME, -
                              PARM1_LIST:VPF_NAME, -
                              PARM1_LIST:VPF_NAME)
    #SET TOP_LIST:VCOLUMN7 = (" ", -
                              "T1", -
                              "T2")
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
                              "SWITCH", -
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
                              "IS", -
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
                              DEC(PARM1_LIST:VSWITCH4_IX,1), -
                              DEC(PARM1_LIST:VCOLOR3_IX,1), -
                              DEC(PARM1_LIST:VSWITCH8_IX,1),- 
                              DEC(PARM1_LIST:VSWITCH5_IX,1),- 
                              DEC(PARM1_LIST:VPNODE2_IX,1), -
                              DEC(PARM1_LIST:VSWITCH3_IX,1), -
                              DEC(PARM1_LIST:VCOLOR2_IX,1),-
                              DEC(PARM1_LIST:VSWITCH7_IX,1))
  #BLOCK_END ; (SINGLE)

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

      #IF DATA_TYPE(PARM1_LIST:VPNODE3_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_3
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VPNODE3_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = (" ")
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "54"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH4_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH4_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH4_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "55"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VCOLOR3_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VCOLOR3_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VCOLOR3_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "56"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH8_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH8_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH8_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "55"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VSWITCH5_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_1
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VSWITCH5_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VSWITCH5_IX,1)
        @L = %L + 1
      #BLOCK_END
      #ELSE #BLOCK
        #SET WARNING_LIST:VCOLUMN1(%LW) = "WARNING"
        #SET WARNING_LIST:VCOLUMN2(%LW) = PARM1_LIST:VPF_LN
        #SET WARNING_LIST:VCOLUMN3(%LW) = "55"
        @LW = %LW + 1
      #BLOCK_END

      #IF DATA_TYPE(PARM1_LIST:VPNODE2_IX)<>"NONE" #THEN #BLOCK
        #SET PAR_LIST:VCOLUMN1(%L) = (" ")
        #SET PAR_LIST:VCOLUMN2(%L) = PARM1_LIST:VLN
        #SET PAR_LIST:VCOLUMN3(%L) = SUBSTR(PARM1_LIST:VLN,9,8)
        #SET PAR_LIST:VCOLUMN4(%L) = %POS_ID_3
        #SET PAR_LIST:VCOLUMN5(%L) = DEC(PARM1_LIST:VPNODE2_IX,1)
        #SET PAR_LIST:VCOLUMN6(%L) = DEC(PARM1_LIST:VPNODE2_IX,1)
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
