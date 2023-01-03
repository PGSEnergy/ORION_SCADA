;DEFINITIONS FOR P-OBJECT DEFINITION TOOL


;-------------- TYPE SPECIFIC OBJECT DEFINITIONS --------------------------

;------------ ANSI (OTHERS) ------------------

#CREATE PTYPE_3:V    = LIST( -
   HEADER_TEXT       = "BINARY INPUT (ANSI)",-
   PT                = 3,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A3")

#CREATE PTYPE_5:V    = LIST( -
   HEADER_TEXT       = "BINARY OUTPUT (ANSI)",-
   PT                = 5,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A5")

#CREATE PTYPE_6:V    = LIST( -
   HEADER_TEXT       = "DIGITAL INPUT (ANSI)",-
   PT                = 6,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A6")

#CREATE PTYPE_7:V    = LIST( -
   HEADER_TEXT       = "DIGITAL OUTPUT (ANSI)",-
   PT                = 7,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A7")

#CREATE PTYPE_9:V    = LIST( -
   HEADER_TEXT       = "ANALOG INPUT (ANSI)",-
   PT                = 9,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A9")

#CREATE PTYPE_11:V   = LIST( -
   HEADER_TEXT       = "ANALOG OUTPUT (ANSI)",-
   PT                = 11,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A11")

#CREATE PTYPE_12:V   = LIST( -
   HEADER_TEXT       = "DOUBLE INDICATION (ANSI)",-
   PT                = 12,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A12")

#CREATE PTYPE_13:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (ANSI)",-
   PT                = 13,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A13")

#CREATE PTYPE_14:V   = LIST( -
   HEADER_TEXT       = "BIT STREAM (ANSI)",-
   PT                = 14,-
   STATION_TYPE      = ("STA","SIN","SID","PAC"),-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A14")



;---------------- SPA ------------------------

#CREATE PTYPE_N1:V   = LIST( -
   HEADER_TEXT       = "OBJECT COMMAND (SPA)",-
   PT                = 5,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR1")

#CREATE PTYPE_N3:V   = LIST( -
   HEADER_TEXT       = "DIGITAL SETPOINT (SPA)",-
   PT                = 7,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR3")

#CREATE PTYPE_N4:V   = LIST( -
   HEADER_TEXT       = "ANALOG SETPOINT (SPA)",-
   PT                = 11,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR4")

#CREATE PTYPE_N6:V   = LIST( -
   HEADER_TEXT       = "ANALOG VALUE (SPA)",-
   PT                = 9,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR6")

#CREATE PTYPE_N7S:V  = LIST( -
   HEADER_TEXT       = "SINGLE INDICATION (SPA)",-
   PT                = 3,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR7S")

#CREATE PTYPE_N7D:V  = LIST( -
   HEADER_TEXT       = "DOUBLE INDICATION (SPA)",-
   PT                = 12,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR7D")

#CREATE PTYPE_N8:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (SPA)",-
   PT                = 13,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR8")

#CREATE PTYPE_N9:V   = LIST( -
   HEADER_TEXT       = "DIGITAL VALUE (SPA)",-
   PT                = 6,-
   STATION_TYPE      = "SPA",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR9")

;---------------- REX ------------------------

#CREATE PTYPE_X1:V   = LIST( -
   HEADER_TEXT       = "OBJECT COMMAND (REX)",-
   PT                = 5,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR1")

#CREATE PTYPE_X3:V   = LIST( -
   HEADER_TEXT       = "DIGITAL SETPOINT (REX)",-
   PT                = 7,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR3")

#CREATE PTYPE_X4:V   = LIST( -
   HEADER_TEXT       = "ANALOG SETPOINT (REX)",-
   PT                = 11,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR4")

#CREATE PTYPE_X6:V   = LIST( -
   HEADER_TEXT       = "ANALOG VALUE (REX)",-
   PT                = 9,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "A9")
   
#CREATE PTYPE_X6E:V   = LIST( -
   HEADER_TEXT       = "COMMAND TERMINATION (REX)",-
   PT                = 9,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "A9")

#CREATE PTYPE_X7S:V  = LIST( -
   HEADER_TEXT       = "SINGLE INDICATION (REX)",-
   PT                = 3,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "A3")

#CREATE PTYPE_X7D:V  = LIST( -
   HEADER_TEXT       = "DOUBLE INDICATION (REX)",-
   PT                = 12,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "A12")

#CREATE PTYPE_X8:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (REX)",-
   PT                = 13,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR8")

#CREATE PTYPE_X9:V   = LIST( -
   HEADER_TEXT       = "DIGITAL VALUE (REX)",-
   PT                = 6,-
   STATION_TYPE      = "REX",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR9")



;--------- RTU-200 WITH FTAB -----------------

#CREATE PTYPE_R1:V   = LIST( -
   HEADER_TEXT       = "OBJECT COMMAND (RTU-200)(EDU)",-
   PT                = 5,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "AR1")

#CREATE PTYPE_R2:V   = LIST( -
   HEADER_TEXT       = "REGULATION COMMAND (RTU-200)(EDU)",-
   PT                = 5,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "AR2")

#CREATE PTYPE_R3:V   = LIST( -
   HEADER_TEXT       = "DIGITAL SETPOINT (RTU-200)(EDU)",-
   PT                = 7,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "AR3")

#CREATE PTYPE_R4:V   = LIST( -
   HEADER_TEXT       = "ANALOG SETPOINT (RTU-200)(EDU)",-
   PT                = 11,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "AR4")

#CREATE PTYPE_R5:V   = LIST( -
   HEADER_TEXT       = "GENERAL PERSISTANT OUTPUT (RTU-200)(EDU)",-
   PT                = 11,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "AR5")

#CREATE PTYPE_R6:V   = LIST( -
   HEADER_TEXT       = "ANALOG VALUE (RTU-200)(EDU)",-
   PT                = 9,-
   SZ                = 0,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   EVENT_REC_OBJ_DX  = "R11",-
   ATTRIBUTE_PICTURE = "AR6")

#CREATE PTYPE_R7S:V  = LIST( -
   HEADER_TEXT       = "SINGLE INDICATION (RTU-200)(EDU)",-
   PT                = 3,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   EVENT_REC_OBJ_DX  = "R10S",-
   ATTRIBUTE_PICTURE = "AR7S")

#CREATE PTYPE_R7D:V  = LIST( -
   HEADER_TEXT       = "DOUBLE INDICATION (RTU-200)(EDU)",-
   PT                = 12,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   EVENT_REC_OBJ_DX  = "R10D",-
   ATTRIBUTE_PICTURE = "AR7D")

#CREATE PTYPE_R8:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (RTU-200)(EDU)",-
   PT                = 13,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "AR8")

#CREATE PTYPE_R9:V   = LIST( -
   HEADER_TEXT       = "DIGITAL VALUE (RTU-200)(EDU)",-
   PT                = 6,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "AR9")

#CREATE PTYPE_R10S:V = LIST( -
   HEADER_TEXT       = "SINGLE INDICATION EVENT RECORDING (RTU-200)(EDU)",-
   PT                = 3,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "XXXXX")

#CREATE PTYPE_R10D:V = LIST( -
   HEADER_TEXT       ="DOUBLE INDICATION EVENT RECORDING (RTU-200)(EDU)",-
   PT                = 12,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "XXXXX")


#CREATE PTYPE_R11:V  = LIST( -
   HEADER_TEXT       = "ANALOG VALUE EVENT RECORDING (RTU-200)(EDU)",-
   PT                = 9,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = FALSE,-
   ATTRIBUTE_PICTURE = "XXXXX")



;---------- RTU-200 WITHOUT FTAB -------------

#CREATE PTYPE_I1:V   = LIST( -
   HEADER_TEXT       = "OBJECT COMMAND (RTU-200)",-
   PT                = 5,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR1")

#CREATE PTYPE_I2:V   = LIST( -
   HEADER_TEXT       = "REGULATION COMMAND (RTU-200)",-
   PT                = 5,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR2")

#CREATE PTYPE_I3:V   = LIST( -
   HEADER_TEXT       = "DIGITAL SETPOINT (RTU-200)",-
   PT                = 7,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR3")

#CREATE PTYPE_I4:V   = LIST( -
   HEADER_TEXT       = "ANALOG SETPOINT (RTU-200)",-
   PT                = 11,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR4")

#CREATE PTYPE_I5:V   = LIST( -
   HEADER_TEXT       = "GENERAL PERSISTANT OUTPUT (RTU-200)",-
   PT                = 11,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR5")

#CREATE PTYPE_I6:V   = LIST( -
   HEADER_TEXT       = "ANALOG VALUE (RTU-200)",-
   PT                = 9,-
   SZ                = 0,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   EVENT_REC_OBJ_DX  = "I11",-
   ATTRIBUTE_PICTURE = "AR6")

#CREATE PTYPE_I7S:V  = LIST( -
   HEADER_TEXT       = "SINGLE INDICATION (RTU-200)",-
   PT                = 3,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   EVENT_REC_OBJ_DX  = "I10S",-
   ATTRIBUTE_PICTURE = "AR7S")

#CREATE PTYPE_I7D:V  = LIST( -
   HEADER_TEXT       = "DOUBLE INDICATION (RTU-200)",-
   PT                = 12,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   EVENT_REC_OBJ_DX  = "I10D",-
   ATTRIBUTE_PICTURE = "AR7D")

#CREATE PTYPE_I8:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (RTU-200)",-
   PT                = 13,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR8")

#CREATE PTYPE_I9:V   = LIST( -
   HEADER_TEXT       = "DIGITAL VALUE (RTU-200)",-
   PT                = 6,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR9")

#CREATE PTYPE_I10S:V = LIST( -
   HEADER_TEXT       = "SINGLE INDICATION EVENT RECORDING (RTU-200)",-
   PT                = 3,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "XXXXX")

#CREATE PTYPE_I10D:V = LIST( -
   HEADER_TEXT       = "DOUBLE INDICATION EVENT RECORDING (RTU-200)",-
   PT                = 12,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "XXXXX")


#CREATE PTYPE_I11:V  = LIST( -
   HEADER_TEXT       = "ANALOG VALUE EVENT RECORDING (RTU-200)",-
   PT                = 9,-
   STATION_TYPE      = "RTU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "XXXXX")



;------------- LCU ---------------------------

#CREATE PTYPE_L2:V   = LIST( -
   HEADER_TEXT       = "BINARY OUTPUT (LCU)",-
   PT                = 5,-
   STATION_TYPE      = "LCU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR2")

#CREATE PTYPE_L4:V   = LIST( -
   HEADER_TEXT       = "ANALOG OUTPUT (LCU)",-
   PT                = 11,-
   STATION_TYPE      = "LCU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR4")

#CREATE PTYPE_L6:V   = LIST( -
   HEADER_TEXT       = "ANALOG INPUT (LCU)",-
   PT                = 9,-
   STATION_TYPE      = "LCU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR6")

#CREATE PTYPE_L8:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (LCU)",-
   PT                = 13,-
   STATION_TYPE      = "LCU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR8")

#CREATE PTYPE_L9:V   = LIST( -
   HEADER_TEXT       = "DIGITAL INPUT (LCU)",-
   PT                = 6,-
   STATION_TYPE      = "LCU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = TRUE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "AR9")

#CREATE PTYPE_L14:V  = LIST( -
   HEADER_TEXT       = "BIT STREAM (LCU)",-
   PT                = 14,-
   STATION_TYPE      = "LCU",-
   ADDRESS_ENCODING  = "RTU_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   IGNORE_FTAB       = TRUE,-
   ATTRIBUTE_PICTURE = "A14")



;-------------- PROCOL -----------------------

#CREATE PTYPE_O1:V   = LIST( -
   HEADER_TEXT       = "INDICATION (PROCOL)",-
   PT                = 3,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A3")

#CREATE PTYPE_O2:V   = LIST( -
   HEADER_TEXT       = "ANALOG MEASURAND (PROCOL)",-
   PT                = 9,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A9")

#CREATE PTYPE_O3:V   = LIST( -
   HEADER_TEXT       = "DIGITAL MEASURAND (PROCOL)",-
   PT                = 6,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A6")

#CREATE PTYPE_O4:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (PROCOL)",-
   PT                = 13,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A13")

#CREATE PTYPE_O5:V   = LIST( -
   HEADER_TEXT       = "ANALOG SETPOINT (PROCOL)",-
   PT                = 11,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A11")

#CREATE PTYPE_O6:V   = LIST( -
   HEADER_TEXT       = "DIGITAL SETPOINT (PROCOL)",-
   PT                = 7,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A7")

#CREATE PTYPE_O7:V   = LIST( -
   HEADER_TEXT       = "CONTROL COMMAND (PROCOL)",-
   PT                = 7,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A7")

#CREATE PTYPE_O8:V   = LIST( -
   HEADER_TEXT       = "BINARY OUTPUT (PROCOL)",-
   PT                = 5,-
   STATION_TYPE      = "RCT",-
   ADDRESS_ENCODING  = "PROCOL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A5")



;------------- SATTCON -----------------------

#CREATE PTYPE_S1:V   = LIST( -
   HEADER_TEXT       = "DIGITAL SETPOINT (SATTCON)",-
   PT                = 6,-
   STATION_TYPE      = "SAT",-
   ADDRESS_ENCODING  = "SATTCON_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A6")

#CREATE PTYPE_S2:V   = LIST( -
   HEADER_TEXT       = "CONTROL COMMAND (SATTCON)",-
   PT                = 6,-
   STATION_TYPE      = "SAT",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A6")

#CREATE PTYPE_S3:V   = LIST( -
   HEADER_TEXT       = "TIME SET INSTRUCTION (SATTCON)",-
   PT                = 6,-
   STATION_TYPE      = "SAT",-
   ADDRESS_ENCODING  = "SATTCON_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A6")



;-------------- P-214 ------------------------

#CREATE PTYPE_P1:V   = LIST( -
   HEADER_TEXT       = "COMMAND OUTPUT (P-214)",-
   PT                = 5,-
   STATION_TYPE      = "PCL",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A5")

#CREATE PTYPE_P2:V   = LIST( -
   HEADER_TEXT       = "SET POINT (P-214)",-
   PT                = 11,-
   STATION_TYPE      = "PCL",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A11")

#CREATE PTYPE_P3:V   = LIST( -
   HEADER_TEXT       = "COUNTER (P-214)",-
   PT                = 13,-
   STATION_TYPE      = "PCL",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A13")

#CREATE PTYPE_P4:V   = LIST( -
   HEADER_TEXT       = "SIMPLE DATA (P-214)",-
   PT                = 3,-
   STATION_TYPE      = "PCL",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= TRUE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A3")

#CREATE PTYPE_P5:V   = LIST( -
   HEADER_TEXT       = "MEASURAND (P-214)",-
   PT                = 9,-
   STATION_TYPE      = "PCL",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A9")
   
;----------------- IEC ---------------------

#CREATE PTYPE_C3:V    = LIST( -
   HEADER_TEXT       = "BINARY INPUT (IEC)",-
   PT                = 3,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A3")

#CREATE PTYPE_C5:V    = LIST( -
   HEADER_TEXT       = "BINARY OUTPUT (IEC)",-
   PT                = 5,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A5")

#CREATE PTYPE_C6:V    = LIST( -
   HEADER_TEXT       = "DIGITAL INPUT (IEC)",-
   PT                = 6,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A6")

#CREATE PTYPE_C7:V    = LIST( -
   HEADER_TEXT       = "DIGITAL OUTPUT (IEC)",-
   PT                = 7,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A7")

#CREATE PTYPE_C9:V    = LIST( -
   HEADER_TEXT       = "ANALOG INPUT (IEC)",-
   PT                = 9,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A9")
   
#CREATE PTYPE_C9E:V   = LIST( -
   HEADER_TEXT       = "COMMAND TERMINATION (IEC)",-
   PT                = 9,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A9")
   
#CREATE PTYPE_C11:V   = LIST( -
   HEADER_TEXT       = "ANALOG OUTPUT (IEC)",-
   PT                = 11,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A11")

#CREATE PTYPE_C12:V   = LIST( -
   HEADER_TEXT       = "DOUBLE INDICATION (IEC)",-
   PT                = 12,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A12")

#CREATE PTYPE_C13:V   = LIST( -
   HEADER_TEXT       = "PULSE COUNTER (IEC)",-
   PT                = 13,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A13")

#CREATE PTYPE_C14:V   = LIST( -
   HEADER_TEXT       = "BIT STREAM (IEC)",-
   PT                = 14,-
   STATION_TYPE      = "IEC",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A14")

   
;--------------------- ATR ---------------------

#CREATE PTYPE_A14:V   = LIST( -
   HEADER_TEXT       = "BIT STREAM (ATR)",-
   PT                = 14,-
   STATION_TYPE      = "ATR",-
   ADDRESS_ENCODING  = "NORMAL_ENCODING",-
   ENABLE_BIT_ADDRESS= FALSE,-
   RTU_OBJECT        = FALSE,-
   ATTRIBUTE_PICTURE = "A14")





;------------- COMMON ATTRIBUTES ------------------------------------------

@COMATTR1 UN=0,OA=0,OB=16,IU=1,OT=0,SS=2,AC=0,AB=0,RC=0,PA=0,PU=0,LD=0,
@COMATTR2 PF="",PD=0,PI="",AE=0,AF=0,AA=0,AN="",HE=0,HF=0,HA=0,EE=0,
@COMATTR3 FI=0,FX="",HL=BIT_MASK(15),
@COMATTR=%COMATTR1+%COMATTR2+%COMATTR3


;------------- POINT TYPE SPECIFIC ATTRIBUTES -----------------------------

@TYP3ATTR BI=0,AG=0,PT=3,CE=0,CL=0                                    ; Binary Input
@TYP5ATTR BO=0,PT=5,CE=0,CL=0                                         ; Binary Output
@TYP6ATTR DI=0,PT=6                                                   ; Digital Input
@TYP7ATTR DO=0,PT=7                                                   ; Digital Output
@TYP9ATTR AI=0,HI=0,LI=0,LW=0,HW=0,SZ=1,ST="",SN="",ZE=0,ZD=0.0,PT=9  ; Analog Input
@TYP11ATTR AO=0,HO=0,LO=0,ST="",SN="",PT=11                           ; Analog Output
@TYP12ATTR DB=0,LA=0,NV=4,PT=12,CE=0,CL=0                             ; Double Binary Indication
@TYP13ATTR PC=0,BC=31,ST="",SC=1,PT=13                                ; Pulse Counter
@TYP14ATTR BS=BIT_SCAN("0"),PT=14                                     ; Bit Stream


;---------- INFO FOR UPPDATING DX ATTRIBUTE -------------------------------

;------ STA TYPE / ADDRESS ENCODING METHODS --------
@ADDR_ENCOD = LIST(-
   NONE= "NORMAL_ENCODING",-
   STA = "NORMAL_ENCODING",-
   SPA = "RTU_ENCODING",-
   REX = "NORMAL_ENCODING",-
   RTU = "RTU_ENCODING",-
   PCL = "NORMAL_ENCODING",-
   SIN = "NORMAL_ENCODING",-
   SID = "NORMAL_ENCODING",-
   PAC = "NORMAL_ENCODING",-
   SAT = "SATTCON_ENCODING",-
   RCT = "PROCOL_ENCODING",-
   LCU = "RTU_ENCODING",-
   IEC = "NORMAL_ENCODING",-
   ATR = "NORMAL_ENCODING")

;---- STA TYPE / FIRST LETTER IN DX ---------------
@DX_LETTER  = LIST(-
   NONE= "",-
   STA = "",-
   SPA = "N",-
   REX = "X",-
   RTU = "I",-
   PCL = "P",-
   SIN = "",-
   SID = "",-
   PAC = "",-
   SAT = "S",-
   RCT = "O",-
   LCU = "L",-
   IEC = "C",-
   ATR = "A")


;---------------------- MENU TEXTS ----------------------------------------

;--------------- STATION TYPE/PROTOCOL ---------------------

@STAT_T_P = ("ANSI (OTHERS)       ", -
             "SPA                 ", -
             "REX                 ", -
             "RTU-200 WITH EDU    ", -
             "RTU-200 WITHOUT EDU ", -
             "LCU                 ", -
             "PROCOL              ", -
             "SATTCON             ", -
             "P-214               ",-
             "IEC                 ",-
             "ATR                 ")




;------------------ OBJECT TYPE ----------------------------


;-------------- ANSI (OTHERS) ---------------
@OBJ_TYPE(1) = ("ANALOG  INPUT       ", -
                "DIGITAL INPUT       ", -
                "BINARY INPUT        ", -
                "DOUBLE INDICAT.     ", -
                "PULSE COUNTER       ", -
                "                    ", -
                "ANALOG  OUTPUT      ", -
                "DIGITAL OUTPUT      ", -
                "BINARY OUTPUT       ", -
                "BIT STREAM          ")
@DX_ATTR(1) = ("9","6","3","12","13","","11","7","5","14")

;----------------- SPA ----------------------
@OBJ_TYPE(2) = ("ANALOG  VALUE       ", -
                "DIGITAL VALUE       ", -
                "SINGLE INDICAT.     ", -
                "DOUBLE INDICAT.     ", -
                "PULSE COUNTER       ", -
                "                    ", -
                "ANALOG SET POINT    ", -
                "DIGITAL SET POINT   ", -
                "OBJECT COMMAND      ")
@DX_ATTR(2) = ("N6","N9","N7S","N7D","N8","","N4","N3","N1")

;----------------- REX ----------------------
@OBJ_TYPE(3) = ("ANALOG  VALUE       ", -
                "COMMAND TERMINATION ", -
                "DIGITAL VALUE       ", -
                "SINGLE INDICAT.     ", -
                "DOUBLE INDICAT.     ", -
                "PULSE COUNTER       ", -
                "                    ", -
                "ANALOG SET POINT    ", -
                "DIGITAL SET POINT   ", -
                "OBJECT COMMAND      ")
@DX_ATTR(3) = ("X6","X6E","X9","X7S","X7D","X8","","X4","X3","X1")

;---------- RTU-200 WITH EDU ----------------
@OBJ_TYPE(4) = ("ANALOG  VALUE       ", -
                "DIGITAL VALUE       ", -
                "SINGLE INDICAT.     ", -
                "DOUBLE INDICAT.     ", -
                "PULSE COUNTER       ", -
                "                    ", -
                "ANALOG  SET POINT   ", -
                "DIGITAL SET POINT   ", -
                "OBJECT COMMAND      ", -
                "REGULATION COMMAND  ", -
                "GEN. PERSIST. OUTPUT")
@DX_ATTR(4) = ("R6","R9","R7S","R7D","R8","","R4","R3","R1","R2","R5")

;---------- RTU-200 WITHOUT EDU -------------
@OBJ_TYPE(5) = %OBJ_TYPE(4)
@DX_ATTR(5) = ("I6","I9","I7S","I7D","I8","","I4","I3","I1","I2","I5")

;---------------- LCU -----------------------
@OBJ_TYPE(6) = ("ANALOG  INPUT       ", -
                "DIGITAL INPUT       ", -
                "PULSE COUNTER       ", -
                "                    ", -
                "ANALOG OUTPUT       ", -
                "BINARY OUTPUT       ", -
                "BIT STREAM          ")
@DX_ATTR(6) = ("L6","L9","L8","","L4","L2","L14")

;-------------- PROCOL ----------------------
@OBJ_TYPE(7) = ("INDICATION          ", -
                "ANALOG  MEASURAND   ", -
                "DIGITAL MEASURAND   ", -
                "PULSE COUNTER       ", -
                "                    ", -
                "ANALOG  SET POINT   ", -
                "DIGITAL SET POINT   ", -
                "CONTROL COMMAND     ", -
                "BINARY OUTPUT       ")
@DX_ATTR(7) = ("O1","O2","O3","O4","","O5","O6","O7","O8")

;--------------- SATTCON --------------------
@OBJ_TYPE(8) = ("DIGITAL SET POINT   ", -
                "CONTROL COMMAND     ", -
                "TIME SET INSTRUCT.  ")
@DX_ATTR(8) = ("S1","S2","S3")

;--------------- P-214 ----------------------
@OBJ_TYPE(9) = ("COUNTER             ", -
                "SIMPLE DATA         ", -
                "MEASURAND           ", -
                "                    ", -
                "COMMAND OUTPUT      ", -
                "SET POINT           ")
@DX_ATTR(9) = ("P3","P4","P5","","P1","P2")

;--------------- IEC ---------------------
@OBJ_TYPE(10) = ("ANALOG  INPUT       ", -
                 "COMMAND TERMINATION ", -
                 "DIGITAL INPUT       ", -
                 "BINARY INPUT        ", -
                 "DOUBLE INDICAT.     ", -
                 "PULSE COUNTER       ", -
                 "                    ", -
                 "ANALOG  OUTPUT      ", -
                 "DIGITAL OUTPUT      ", -
                 "BINARY OUTPUT       ", -
                 "BIT STREAM          ")
@DX_ATTR(10) = ("C9","C9E","C6","C3","C12","C13","","C11","C7","C5","C14")

;--------------- ATR ---------------------
@OBJ_TYPE(11) = VECTOR("BIT STREAM          ")
@DX_ATTR(11) = VECTOR("A14")
