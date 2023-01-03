#IF %DEV_TYPE == "THN" #THEN #BLOCK

   #CREATE THN_DEFS:V;   DEFAULT VALUES
   #SET THN_DEFS:VXX="NO DEFAULT VALUES DEFINED FOR THN"

#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "LIN" #THEN #BLOCK
@MAXPROT = 9;   MAX NUMBER OF PROTOCOLS

   ;ATTRIBUTE-PROTOCOL MASK

   @A=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD")
   @B=("RE","TI","EN","ER","NA")
   @LINATTR1=APPEND(%A,%B)
   @A=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD")
   @B=("RE","TI","EN","DE","PD","PP","RP")
   @LINATTR2=APPEND(%A,%B)
   @LINATTR7=APPEND(%A,%B)
   @LINATTR3=("PO","IU","MI","MS","LK","PS","RE","TI")
   @LINATTR4=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","OS")
   @LINATTR5=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD")
   @A=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD")
   @B=("RE","TI","DE","PD","PP")
   @LINATTR8=APPEND(%A,%B)
   @A=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD")
   @B=("RE","TI")
   @LINATTR9=APPEND(%A,%B)


   #CREATE LIN_DEFS:V;   DEFAULT VALUES

   #SET LIN_DEFS:VIU(1..%MAXPROT)=1
   #SET LIN_DEFS:VMI(1..%MAXPROT)=6100+%DEV_NR
   #SET LIN_DEFS:VMS(1..%MAXPROT)=1
   #SET LIN_DEFS:VLK(1..%MAXPROT)=0
   #SET LIN_DEFS:VPS(1..%MAXPROT)=20
   #SET LIN_DEFS:VBR(1..%MAXPROT)=2400
   #SET LIN_DEFS:VSB(1..%MAXPROT)=1
   #SET LIN_DEFS:VPY=(2,2,0,0,0,0,2,2,2)
   #SET LIN_DEFS:VRD(1..%MAXPROT)=8
   #SET LIN_DEFS:VTD(1..%MAXPROT)=8
   #SET LIN_DEFS:VRE=(2,2,2,0,0,0,2,2,2)
   #SET LIN_DEFS:VTI(1..%MAXPROT)=2
   #SET LIN_DEFS:VEN(1..%MAXPROT)=2
   #SET LIN_DEFS:VDE(1..%MAXPROT)=100
   #SET LIN_DEFS:VPD(1..%MAXPROT)=300
   #SET LIN_DEFS:VPP(1..%MAXPROT)=4
   #SET LIN_DEFS:VRP(1..%MAXPROT)=4
   #SET LIN_DEFS:VER(1..%MAXPROT)=1
   #SET LIN_DEFS:VNA(1..%MAXPROT)=3
   #SET LIN_DEFS:VOS(1..%MAXPROT)=1
#BLOCK_END 

;--------------------------------------------------------------------------
   ;ATTRIBUTE-PRINTER MASK
#IF %DEV_TYPE == "PRI" #THEN #BLOCK

   @PRIATTR=("PT","LI","AL","AS","IU","MI","MS")


   #CREATE PRI_DEFS:V;   DEFAULT VALUES

   #SET PRI_DEFS:VPT=1
   #SET PRI_DEFS:VDN=%DEV_NR
   #SET PRI_DEFS:VLI=1
   #SET PRI_DEFS:VAL=0
   #SET PRI_DEFS:VAS=1
   #SET PRI_DEFS:VIU=1
   #SET PRI_DEFS:VMI=3000+%DEV_NR
   #SET PRI_DEFS:VMS=1
#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "STA" #THEN #BLOCK
@MAXSTA = 10;   MAX STATION TYPE NR 

   ;ATTRIBUTE-STATYPE MASK

   @A=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")
   @B=("DE","DI","FS","SP","SU")
   @STAATTR3=APPEND(%A,%B)
   @STAATTR4=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")
   @STAATTR5=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")
   @STAATTR6=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")
   @STAATTR7=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")
   @STAATTR8=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")
   @STAATTR9=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")
   @STAATTR10=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","PH")


   #CREATE STA_DEFS:V;   DEFAULT VALUES

   #SET STA_DEFS:VLI(3..%MAXSTA)=1
   #SET STA_DEFS:VDN(3..%MAXSTA)=1
   #SET STA_DEFS:VAL(3..%MAXSTA)=0
   #SET STA_DEFS:VAS(3..%MAXSTA)=1
   #SET STA_DEFS:VIU(3..%MAXSTA)=1
   #SET STA_DEFS:VMI(3..%MAXSTA)=1000+%DEV_NR
   #SET STA_DEFS:VMI(4)=8000+%DEV_NR
   #SET STA_DEFS:VMS(3..%MAXSTA)=1
   #SET STA_DEFS:VSA(3..%MAXSTA)=8
   #SET STA_DEFS:VDE(3..%MAXSTA)=0
   #SET STA_DEFS:VDI(3..%MAXSTA)=60
   #SET STA_DEFS:VFS(3..%MAXSTA)=0
   #SET STA_DEFS:VRT(3..%MAXSTA)=45
   #SET STA_DEFS:VSP(3..%MAXSTA)=0
   #SET STA_DEFS:VSU(3..%MAXSTA)=60
   #SET STA_DEFS:VPH(3..%MAXSTA)=""
#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "APL" #THEN #BLOCK
   ;ATTRIBUTE-APL MASK

   @APLATTR=("SL","IU","TN","NN","SW","SU","PH")


   #CREATE APL_DEFS:V;   DEFAULT VALUES

   #SET APL_DEFS:VSL=1
   #SET APL_DEFS:VDN=%DEV_NR
   #SET APL_DEFS:VAL=0
   #SET APL_DEFS:VAS=1
   #SET APL_DEFS:VIU=1
   #SET APL_DEFS:VMI=0
   #SET APL_DEFS:VMS=1
   #SET APL_DEFS:VTN=1
   #SET APL_DEFS:VNN=1
   #SET APL_DEFS:VSW=5
   #SET APL_DEFS:VSU=4
   #SET APL_DEFS:VPH=""
#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "NOD" #THEN #BLOCK
   ;ATTRIBUTE-NODE MASK

   @NODATTR=("LI","SA")


   #CREATE NOD_DEFS:V;   DEFAULT VALUES

   #SET NOD_DEFS:VLI=1
   #SET NOD_DEFS:VDN=%DEV_NR
   #SET NOD_DEFS:VAL=0
   #SET NOD_DEFS:VAS=1
   #SET NOD_DEFS:VIU=1
   #SET NOD_DEFS:VMI=6000+%DEV_NR
   #SET NOD_DEFS:VMS=1
   #SET NOD_DEFS:VSA=9
#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "RUN" #THEN #BLOCK
   ;ATTRIBUTE-RUNG MASK

   @RUNATTR=("SN","RN","DT","CO","AD","LE","AT","BF","TS","SL")


   #CREATE RUN_DEFS:V;   DEFAULT VALUES

   #SET RUN_DEFS:VSN=1
   #SET RUN_DEFS:VRN=%DEV_NR
   #SET RUN_DEFS:VDT=1
   #SET RUN_DEFS:VCO=1
   #SET RUN_DEFS:VAD=0
   #SET RUN_DEFS:VLE=1
   #SET RUN_DEFS:VAT=0
   #SET RUN_DEFS:VBF=1
   #SET RUN_DEFS:VTS=0
   #SET RUN_DEFS:VSL=1
#BLOCK_END 
;--------------------------------------------------------------------------
