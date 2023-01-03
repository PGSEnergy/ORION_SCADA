;*******************************************************************************************************************************************
;
;Process object description file for devices monitored via SNMP. 
;If the device description is found here Standard Function Tool (SFT) will show it
;
;Meaning of keys:
;
;INDEX: Index of the process object (IX)
;INDEX_TYPE: BI (Binary Input), DB (Double Binary) or AI (Analog Input) 
;OBJECT_TEXT: Object text (OX)
;HISTORY_ENABLED: 0 = No events, 1 = Events are generated to Event List (HE)
;DYNAMIC_EVENT_TEXT: Event handling object, the dynamic text in Event List. some existing can be used or create your own one (EH)
:ALARM_CLASS: Alarm class, 0 = no alarms, >0 alarm is generated (AC)
;ALARM_ACTIVATION: Value of AG if INDEX_TYPE = BI, Value of LA if INDEX_TYPE = DB, values of LI:LW:HW:HI if INDEX_TYPE = AI
;
;New device type can be added by introducing it in DEVICE_TEMPLATES/DEVICE_TYPES and adding the section with the
;same name to the end of the file. In new device type every key value must exist.
;The length of the each key value (INDEX, INDEX_TYPE ...) must be the same i.e. there has to be the same amount of commas.
;If You need to modify this file, copy it to sc\apl\'apl name'\aplmod4\inst directory and make the changes there
;
;*******************************************************************************************************************************************


[DEVICE_TEMPLATES]
DEVICE_TYPES=Network Switch 20 ports,GPS,Computer,Printer

[Network Switch 20 ports] 
INDEX=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,100,102,103
INDEX_TYPE=DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,DB,AI,DB,DB
OBJECT_TEXT=Port1,Port2,Port3,Port4,Port5,Port6,Port7,Port8,Port9,Port10,Port11,Port12,Port13,Port14,Port15,Port16,Port17,Port18,Port19,Port20,Temperature,Power Supply 1,Power Supply 2
HISTORY_ENABLED=1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DYNAMIC_EVENT_TEXT=SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPAI4_0,SAGR_FORM5FPDB3_0,SAGR_FORM5FPDB3_0
ALARM_CLASS=1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1
ALARM_ACTIVATION=12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,0:0:0:0,10,10

[GPS] 
INDEX=1,2,3,4,5,6
INDEX_TYPE=AI,DB,AI,DB,DB,DB
OBJECT_TEXT=NTP State,GPS State,Satellites,LAN Port1,LAN Port2,LAN Port3
HISTORY_ENABLED=1,1,1,1,1,1
DYNAMIC_EVENT_TEXT=SAGR_FORM5FPAI7_0,SAGR_FORM5FPDB4_0,SAGR_FORM5FPAI3_1,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0
ALARM_CLASS=1,1,1,1,1,1
ALARM_ACTIVATION=0:0:0:0,13,0:0:0:0,12,12,12

[Computer] 
INDEX=1,2,3,4,5,6,7
INDEX_TYPE=AI,AI,AI,AI,AI,DB,DB
OBJECT_TEXT=Cooling Devices,Power Supply,Temperature status,Temperature value,RAID status,LAN Port1,LAN Port2
HISTORY_ENABLED=1,1,1,1,1,1,1
DYNAMIC_EVENT_TEXT=SAGR_FORM5FPAI8_0,SAGR_FORM5FPAI8_0,SAGR_FORM5FPAI8_0,SAGR_FORM5FPAI3_1,SAGR_FORM5FPAI9_0,SAGR_FORM5FPDB2_0,SAGR_FORM5FPDB2_0
ALARM_CLASS=1,1,1,1,1,1,1
ALARM_ACTIVATION=0:0:0:0,0:0:0:0,0:0:0:0,0:0:0:0,0:0:0:0,12,12

[Printer]
INDEX=1,2,3,4,5,6,7,8
INDEX_TYPE=DB,DB,DB,DB,DB,DB,DB,DB
OBJECT_TEXT=Paper low,Paper empty,Toner low,Toner empty,Door,Jammed,Online,Service requested
HISTORY_ENABLED=1,1,1,1,1,1,1,1
DYNAMIC_EVENT_TEXT=SAGR_FORM5FPDB5_0,SAGR_FORM5FPDB6_0,SAGR_FORM5FPDB5_0,SAGR_FORM5FPDB6_0,SAGR_FORM5FPDB7_0,SAGR_FORM5FPDB8_0,SAGR_FORM5FPDB9_0,SAGR_FORM5FPDB10_0
ALARM_CLASS=1,1,1,1,1,1,1,1
ALARM_ACTIVATION=11,11,11,11,11,11,11,11