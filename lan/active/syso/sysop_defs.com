
#IF %DEV_TYPE == "THN" #THEN #BLOCK

   #CREATE THN_DEFS:V;   DEFAULT VALUES
   #SET THN_DEFS:VXX="NO DEFAULT VALUES DEFINED FOR THN"

#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "LIN" #THEN #BLOCK
@MAXPROT = 26;   MAX NUMBER OF PROTOCOLS

   ;ATTRIBUTE-PROTOCOL MASK

   ;ansi X3.28 FD
   @LINATTR1=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","RE","TI","EN","ER","NA")
   ;ansi X3.28 HD
   @LINATTR2=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","RE","TI","EN","DE","PD","PP","RP")
   ;Common ram
   @LINATTR3=("PO","IU","MI","MS","LK","PS","RE","TI")
   ;ascii printer
   @LINATTR4=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","OS")
   ;digitizer
   @LINATTR5=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD")
   ;RP570 master
   @LINATTR7=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","TI","EN","DE","PD","PP","RP")
   ;ADLP80 slave
   @LINATTR8=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","RE","TI","DE","PD","PP")
   ;P214
   @LINATTR9=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","RE","TI")
   ;ADLP180 slave
   @LINATTR10=("PO","IU","MI","MS","PS","BR","SB","PY","RD","TD","DE")
   ;COMLI slave
   @LINATTR11=("PO","IU","MI","MS","PS","BR","SB","PY","RD","TD","DE")
   ;LCU500
   @LINATTR12=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","RE","TI")
   ;ADLP180 master
   @LINATTR13=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","RE","TI","DE","PD","PP")
   ;SPA
   @LINATTR14=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","RE","TI","DE","PD","PP")
   ;general ascii
   @LINATTR15=("PO","IU","MI","MS","PS","BR","SB","PY","RD","TD","RE","TI","DE")
   ;RP570 slave
   @LINATTR16=("PO","IU","MI","MS","PS","BR","SB","PY","RD","TD","RE","TI","DE")
   ;RCOM
   @LINATTR17=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","TI","DE","PD","PP")
   ;F4F
   @LINATTR18=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","DE")
   ;MODBUS
   @LINATTR25=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","TI","DE","PD","PP")
   ;IEC1107
   @LINATTR26=("PO","IU","MI","MS","LK","PS","BR","SB","PY","RD","TD","TI","DE","PD","EN")


   #CREATE LIN_DEFS:V;   DEFAULT VALUES

   #SET LIN_DEFS:VIU(1..%MAXPROT)=1
   #SET LIN_DEFS:VMI(1..%MAXPROT)=0
   #SET LIN_DEFS:VMS(1..%MAXPROT)=1
   #SET LIN_DEFS:VLK(1..%MAXPROT)=0
   #SET LIN_DEFS:VLK(14)=10
   #SET LIN_DEFS:VPS(1..%MAXPROT)=20
   #SET LIN_DEFS:VBR(1..%MAXPROT)=1200
   #SET LIN_DEFS:VBR(14)=9600
   #SET LIN_DEFS:VBR(26)=2400
   #SET LIN_DEFS:VSB(1..%MAXPROT)=1
   #SET LIN_DEFS:VPY=(2,2,0,0,0,0,2,1,2,2,1,1,1,2,2,2,1,0,0,0,0,0,0,0,0,2)
   #SET LIN_DEFS:VRD(1..%MAXPROT)=8
   #SET LIN_DEFS:VRD(14)=7
   #SET LIN_DEFS:VRD(26)=7
   #SET LIN_DEFS:VTD(1..%MAXPROT)=8
   #SET LIN_DEFS:VTD(14)=7
   #SET LIN_DEFS:VTD(26)=7
   #SET LIN_DEFS:VRE=(2,2,2,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
   #SET LIN_DEFS:VTI(1..%MAXPROT)=2
   #SET LIN_DEFS:VTI(26)=15
   #SET LIN_DEFS:VTI(15) = 90
   #SET LIN_DEFS:VEN(1..%MAXPROT)=2
   #SET LIN_DEFS:VDE(1..%MAXPROT)=0
   #SET LIN_DEFS:VDE(26)=50
   #SET LIN_DEFS:VPD(1..%MAXPROT)=100
   #SET LIN_DEFS:VPD(14)=0
   #SET LIN_DEFS:VPD(26)=600
   #SET LIN_DEFS:VPP(1..%MAXPROT)=4
   #SET LIN_DEFS:VRP(1..%MAXPROT)=4
   #SET LIN_DEFS:VER(1..%MAXPROT)=1
   #SET LIN_DEFS:VNA(1..%MAXPROT)=3
   #SET LIN_DEFS:VOS=(0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
#BLOCK_END 

;--------------------------------------------------------------------------
   ;ATTRIBUTE-PRINTER MASK
#IF %DEV_TYPE == "PRI" #THEN #BLOCK

   @PRIATTR=("DN","PT","LI","IU","MI","MS")


   #CREATE PRI_DEFS:V;   DEFAULT VALUES

   #SET PRI_DEFS:VPT=1
   #SET PRI_DEFS:VDN=%DEV_NR
   #SET PRI_DEFS:VLI=1
   #SET PRI_DEFS:VAL=0
   #SET PRI_DEFS:VAS=1
   #SET PRI_DEFS:VIU=1
   #SET PRI_DEFS:VMI=0
   #SET PRI_DEFS:VMS=1
#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "STA" #THEN #BLOCK
@MAXSTA = 28;   MAX STATION TYPE NR 

   ;ATTRIBUTE-STATYPE MASK

   ;STA
   @STAATTR3=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","DE","DI","FS","SP","SU","NM")
   ;RTU
   @STAATTR4=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;SIN
   @STAATTR5=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;PCL
   @STAATTR6=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;SID
   @STAATTR7=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;PAC
   @STAATTR8=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;SAT
   @STAATTR9=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;RCT
   @STAATTR10=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;LCU
   @STAATTR20=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;SPA
   @STAATTR21=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;SPI
   @STAATTR22=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;ADE
   @STAATTR24=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;PCO
   @STAATTR25=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;WES
   @STAATTR26=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")
   ;ATR
   @STAATTR27=("DV","DN","LI","AL","AS","IU","MI","MS","NM")
   ;PLC
   @STAATTR28=("DV","DN","LI","AL","AS","IU","MI","MS","SA","RT","NM")


   #CREATE STA_DEFS:V;   DEFAULT VALUES

   #SET STA_DEFS:VLI(3..%MAXSTA)=1
   #SET STA_DEFS:VDN(3..%MAXSTA)=1
   #SET STA_DEFS:VAL(3..%MAXSTA)=1
   #SET STA_DEFS:VAS(3..%MAXSTA)=1
   #SET STA_DEFS:VIU(3..%MAXSTA)=1
   #SET STA_DEFS:VMI(3..%MAXSTA)=0
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

   @APLATTR=("DN","TN","NN","SW","SU","NM")


   #CREATE APL_DEFS:V;   DEFAULT VALUES

   #SET APL_DEFS:VSL=1
   #SET APL_DEFS:VDN=%DEV_NR
   #SET APL_DEFS:VAL=0
   #SET APL_DEFS:VAS=0
   #SET APL_DEFS:VIU=1
   #SET APL_DEFS:VMI=0
   #SET APL_DEFS:VMS=1
   #SET APL_DEFS:VTN=1
   #SET APL_DEFS:VNN=1
   #SET APL_DEFS:VSW=5
   #SET APL_DEFS:VSU=60
   #SET APL_DEFS:VPH=""
#BLOCK_END 

;--------------------------------------------------------------------------
#IF %DEV_TYPE == "NOD" #THEN #BLOCK
   ;ATTRIBUTE-NODE MASK

   @NODATTR=("DN","LI","SA")


   #CREATE NOD_DEFS:V;   DEFAULT VALUES

   #SET NOD_DEFS:VLI=1
   #SET NOD_DEFS:VDN=%DEV_NR
   #SET NOD_DEFS:VAL=0
   #SET NOD_DEFS:VAS=1
   #SET NOD_DEFS:VIU=1
   #SET NOD_DEFS:VMI=0
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

