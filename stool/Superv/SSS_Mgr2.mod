; Method: GetStatusMessage(i_Status_Code, [b_Return_As_Modified])
; Version: 1.0
; Parameters: i_Status_Code, status code or an error
;             [b_Return_As_Modified], modify status message as text string
; Return data type: t_Status_Message, status message for passed status code 
; Description: Returns SCIL status message for passed status code. Status codes and
;              messages are stored in the keyed file in folder start/status.bin
; ----------------------------------------------------------------------------------

@ERR_CODE__ = argument(1)

#if argument_count == 2 #then @b_Return_As_Modified = argument(2)
   #else @b_Return_As_Modified = FALSE

@ERR_TEXT__ = ""
@t_Error_State__ = error_State
#error ignore
@ERR_KEY__ = rtu_aint(%ERR_CODE__)
#loop_with i__ = 1 .. 9

   @S = status
   #open_file %i__ 0 "start/status.bin" ERR_KL__
   @i_Status__ = status
   #if %i_Status__ == 0 #Then #Block

      @i_Status1__ = 0
      #read %i__ %ERR_KEY__ ERR_RECORD__
      #close_file %i__
      @i_Status1__ = status
      #if %i_Status1__ == 0 #then @t_Status_Message = substr(%ERR_RECORD__, 3, 0)
      #else @ERR_TEXT__ = "Unknown status code"
      #loop_exit

   #block_end
   #else #if %i_Status__ <> 299 #then #block

      @ERR_TEXT__ = "SCM_SERVICE_GET_STATUS_MESSAGE_FILE_READ_ERROR ['i_Status__']"
      #loop_exit

   #block_end
   #else @ERR_TEXT__ = "SCM_SERVICE_GET_STATUS_MESSAGE_FILE_READ_ERROR ['i_Status__']"

#loop_end

#error 't_Error_State__'

#if %ERR_TEXT__ <> "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = %ERR_TEXT__)
#else #block

   #if %b_Return_As_Modified #then #block
      @v_Status_Message = separate(%t_Status_Message, "_")
      
      #loop_with i_Txt_Item = 2 .. length(%v_Status_Message)
         #if %i_Txt_Item == 2 #then @t_Status_Txt = %v_Status_Message(%i_Txt_Item)
            #else @t_Status_Txt = %t_Status_Txt+substr("", 1, 1)+%v_Status_Message(%i_Txt_Item)
      #loop_end
      
      #return list(STATUS = 0, DATA = capitalize(%t_Status_Txt))
   #block_end
      #else #return list(STATUS = 0, DATA = %t_Status_Message)
      
#block_end

; Method: CreateLogBackup(t_Backup_File_Tag, t_Backup_File_Ext)
; Version: 1.0
; Parameters: t_Backup_File_Tag, file tag of log
;             t_Backup_File_Ext, file extension of log
; Description: Creates backup file for passed log file, 
;              as number of events has exceeded the limit
; --------------------------------------------------------------

;read in arguments
@t_Backup_File_Tag = argument(1)
@t_Backup_File_Ext = argument(2)

;read in general info
#if data_type(%l_General_Info) <> "LIST" #then @l_General_Info = APL:BSV45
@t_File_Path = l_General_Info:vFILE_PATH

;define file name for backup file
@v_Date = separate(date, "-")
#if SYS:BTF == 0 #then @t_Backup_Name = %t_Backup_File_Tag + "_" + %v_Date(1) + %v_Date(2) + %v_Date(3)
   #else @t_Backup_Name = %t_Backup_File_Tag + "_" + %v_Date(3) + %v_Date(2) + %v_Date(1)

;define number of backup files (within the day)
@i_Number_of_Files = length(file_manager("LIST", fm_scil_directory(%t_File_Path), "'t_Backup_Name'.*"))

;create backup file
#if %i_Number_of_Files <> 0 #then @t_Backup_Ext = substr(dec(1000+%i_Number_of_Files,3), 2, 0)
   #else @t_Backup_Ext = %t_Backup_File_Ext

@l_Rename_File = file_manager("RENAME", fm_scil_file("'t_File_Path'/'t_Backup_File_Tag'_active.'t_Backup_File_Ext'"), "'t_Backup_Name'.'t_Backup_Ext'")

#if l_Rename_File:vSTATUS == 0 #then #return list(STATUS = 0)
   #else #return list(STATUS = 1, DESCRPTIVE_TEXT = "SCM_SERVICE_CREATE_LOG_BACKUP_FILE_RENAME_ERROR ['l_Rename_File:vSTATUS']")
   
; Method: WriteLogItem(t_Log_Type, [t_Event_Type], [t_Log_File_Type])
; Version: 1.0
; Parameters: t_Log_Type, type of log (e.g. "OSE" - operating system events, "STE" - common system events, "UPE" - unknown process object events)
;             [t_Event_Type], type of event, dependent on the log type (e.g. "MSG_STA")
;             [t_Log_File_Type], type of log file, applies for operating system events (e.g. "SYSTEM", "SECURITY, "APPLICATION") 
; Description: Writes passed log item to a log file
; ------------------------------------------------------------------------------------------------------------------------------------------------

;read in arguments
@t_Log_Type = argument(1)

#if argument_count > 1 #then @t_Event_Type = argument(2)
   #else @t_Event_Type = ""
#if argument_count > 2 #then @t_Log_File_Type = argument(3)
   #else @t_Log_File_Type = ""

;read in general info
#if data_type(%l_General_Info) <> "LIST" #then @l_General_Info = APL:BSV45

;define file path and log separator
@t_File_Path= l_General_Info:vFILE_PATH
@t_Sp = l_General_Info:vLOG_SEPARATOR

;initialize variables
@v_Event = vector()


;Operating System events
#if %t_Log_Type == "OSE" #then #block
   ;define time tag for event
   #if SYS:BTF == 0 #then @t_Time_Tag = dec(year(%rt), 4)+substr(times(%rt), 3, 0)
   #else #block
      @t_Times = times(%rt)   
      @t_Time_Tag = dec(year(%rt), 4)+substr(%t_times, 3, 4)+substr(%t_Times, 1, 2)+substr(%t_Times, 9, 0)
   #block_end
   
   ;define event
   #if %t_Event_Type == "acINIT" #then #block
      @v_Event = append(%v_Event, "### OS_EVENT ###")
      @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp'### SYS_STARTED ###")
      
      @LOG = %t_Log_File_Type
   #block_end
   #else #block
      @v_Event = append(%v_Event, "### OS_EVENT ###")
      @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp''RECORD_NR''t_Sp''EVENT''t_Sp''TYPE''t_Sp''CATEGORY''t_Sp''USER''t_Sp''COMPUTER''t_Sp''DOMAIN''t_Sp''SOURCE''t_Sp''LOG'")
      @v_Event = append(%v_Event, %MESSAGE)
   #block_end

   ;write event to a log file
   @t_File_Ext = "ose"
   #case %LOG
      #when "SYSTEM" #block
         @t_Cnt_Name = "SYS_CNTR:D1"
         @t_File_Tag = "Sye"
      #block_end  
      #when "SECURITY" #block
         @t_Cnt_Name = "SYS_CNTR:D2"
         @t_File_Tag = "See"
      #block_end
      #when "APPLICATION" #block
         @t_Cnt_Name = "SYS_CNTR:D3"
         @t_File_Tag = "Ape"
      #block_end
   #case_end
   
   #error ignore
      @i_Cnt_Value = 't_Cnt_Name'
   #error stop
   #if status <> 0 #then #block
      @l_SYS_CNTR = list(IU = 1, MO = 0, PE = 1, PQ = 4, HR = 5, CM = do(apl:bsv40, "SSS", "GetLanguageText", "Data_Obj_of_SYS_CNTR", true))
      @i_Create_Status = do(apl:bsv40, "SSS", "CreateDataObject", "SYS_CNTR", %l_SYS_CNTR, false, true, 0)
      @i_Cnt_Value = 't_Cnt_Name'
   #block_end
   
   #if %i_Cnt_Value >= l_General_Info:vMAX_LENGTH_OF_LOG #then #block
      @l_Create_Backup = do(apl:bsv40, "SSS", "CreateLogBackup", %t_File_Tag, %t_File_Ext)
      @i_Cnt_Value = 0
   #block_end
   
   @i_Status = write_text("'t_File_Path'/'t_File_Tag'_active.'t_File_Ext'", %v_Event, 1)
#block_end

;common system events
#if %t_Log_Type == "STE" #then #block
	@trm = REPLACE(DEC(%RM, 3), " ", "0")
   ;define time tag for event
   #if SYS:BTF == 0 #then @t_Time_Tag = dec(year(%rt), 4)+substr(times(%rt), 3, 0)+".'trm'"
   #else #block
      @t_Times = times(%rt)   
      @t_Time_Tag = dec(year(%rt), 4)+substr(%t_times, 3, 4)+substr(%t_Times, 1, 2)+substr(%t_Times, 9, 0)+".'trm'"
   #block_end
   
   ;define event
   #case %t_Event_Type
      #when "MSG_NET" @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp'NODE't_Sp''l_Obj_Data:vNUMBER''t_Sp''t_Sp''t_Sp'"+dec(%OV,0))
      #when "MSG_LINE" #block
         @_t_Line = "'t_Time_Tag''t_Sp'NODE_LINK't_Sp''l_Obj_Data:vNUMBER''t_Sp''l_Obj_Data:vND''t_Sp''l_Obj_Data:vNUMBER''t_Sp'" + dec(%OV,0)

         #if substr(upper_case(SYS:BPR), 1, 3) == "SMS" #then #block
            @v_Cx = separate('LN':PCX(%IX), ";")
            @t_PrefDev = "DEVICE="
            @i_Dev = select(%v_Cx, "LOCATE((), %t_PrefDev)==1")

            #if length(%i_Dev) >= 1 #then #block
               #if length(%v_Cx(%i_Dev(1))) > length(%t_PrefDev) #then #block
                  #error ignore
                     @t_Dev = evaluate(substr(%v_Cx(%i_Dev(1)), length(%t_PrefDev)+1, 0))
                     @_t_Line = %_t_Line + %t_Sp + %t_Dev
                  #error stop
                  @i_Status = status
               #block_end
            #block_end
         #block_end

         @v_Event = append(%v_Event, %_t_Line)
      #block_end
      #when "MSG_STA" #block
         @_t_Line = "'t_Time_Tag''t_Sp'STA't_Sp''l_Obj_Data:vNUMBER''t_Sp''l_Obj_Data:vND''t_Sp''l_Obj_Data:vLI''t_Sp'" + dec(%OV,0)

         #if substr(upper_case(SYS:BPR), 1, 3) == "SMS" #then #block
            @v_Cx = separate('LN':PCX(%IX), ";")
            @t_PrefObj = "PRJMGROBJ="
            @t_PrefDev = "DEVICE="
            @i_Obj = select(%v_Cx, "LOCATE((), %t_PrefObj)==1")
            @i_Dev = select(%v_Cx, "LOCATE((), %t_PrefDev)==1")

            #if length(%i_Obj) >= 1 #then #block
               #if length(%v_Cx(%i_Obj(1))) > length(%t_PrefObj) #then @_t_Line = %_t_Line + %t_Sp + substr(%v_Cx(%i_Obj(1)), length(%t_PrefObj)+1, 0)
            #block_end

            #if length(%i_Dev) >= 1 #then #block
               #if length(%v_Cx(%i_Dev(1))) > length(%t_PrefDev) #then #block
                  @t_Dev = substr(%v_Cx(%i_Dev(1)), length(%t_PrefDev)+1, 0)
                  @_t_Line = %_t_Line + %t_Sp + %t_Dev
               #block_end
            #block_end
         #block_end
         @v_Event = append(%v_Event, %_t_Line)
      #block_end

      #when "MSG_PRI" @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp'PRI't_Sp''l_Obj_Data:vNUMBER''t_Sp''l_Obj_Data:vND''t_Sp''l_Obj_Data:vLI''t_Sp'"+dec(%OV,0))
      #when "MSG_SLCM" @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp'SLCM't_Sp''l_Obj_Data:vNUMBER''t_Sp''l_Obj_Data:vND''t_Sp''l_Obj_Data:vLI''t_Sp'"+dec(%OV,0))
      #when "EVENT_STA" @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp''SOURCE''t_Sp''SOURCE_NR''t_Sp''t_Sp''t_Sp''EVENT'")
      #when "EVENT_SYS" #block
         #case l_Obj_Vars:vSOURCE
            #when "PICO_POOL" #block
               @i_Mon_Physical_Number = dec_scan(substr(%SOURCE, 10, 0))
               @v_Mon_Logical_Number = select(APL'l_Obj_Vars:vNUMBER':BMO, "== 'i_Mon_Physical_Number'") 
               #if length(%v_Mon_Logical_Number) > 0 #then @i_Mon_Logical_Number = %v_Mon_Logical_Number(1)
                  #else @i_Mon_Logical_Number = 0
               @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp''l_Obj_Vars:vSOURCE''t_Sp''l_Obj_Vars:vNUMBER''t_Sp''i_Mon_Logical_Number''t_Sp''t_Sp''EVENT'")
            #block_end
            #when "REPR_POOL", "PRIN_POOL" #block
               @t_Pool_Number = substr(%SOURCE, 10, 0)
               @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp''l_Obj_Vars:vSOURCE''t_Sp''l_Obj_Vars:vNUMBER''t_Sp''t_Pool_Number''t_Sp''t_Sp''EVENT'")
            #block_end
            #otherwise @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp''l_Obj_Vars:vSOURCE''t_Sp''l_Obj_Vars:vNUMBER''t_Sp''t_Sp''t_Sp''EVENT'")
         #case_end
      #block_end
      #when "acINIT" @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp'### SYS_STARTED ###")
   #case_end
   
   ;write event to log file
   @t_Cnt_Name = "SYS_CNTR:D4"
   @t_File_Tag = "Stm"
   @t_File_Ext = "sse"
   
   #error ignore
      @i_Cnt_Value = 't_Cnt_Name'
   #error stop
   #if status <> 0 #then #block
      @l_SYS_CNTR = list(IU = 1, MO = 0, PE = 1, PQ = 4, HR = 5, CM = do(apl:bsv40, "SSS", "GetLanguageText", "Data_Obj_of_SYS_CNTR", true))
      @i_Create_Status = do(apl:bsv40, "SSS", "CreateDataObject", "SYS_CNTR", %l_SYS_CNTR, false, true, 0)
      @i_Cnt_Value = 't_Cnt_Name'
   #block_end

   #if %i_Cnt_Value >= l_General_Info:vMAX_LENGTH_OF_LOG #then #block
      @l_Create_Backup = do(apl:bsv40, "SSS", "CreateLogBackup", %t_File_Tag, %t_File_Ext)
      @i_Cnt_Value = 0
   #block_end
   
   @i_Status = write_text("'t_File_Path'/'t_File_Tag'_active.'t_File_ext'", %v_Event, 1)   
#block_end

;unknown process object events 
#if %t_Log_Type == "UPE" #then #block
   ;define time tag for event
   #if SYS:BTF == 0 #then @t_Time_Tag = dec(year,4)+substr(times,3,0)
   #else #block
      @t_Times = times   
      @t_Time_Tag = dec(year,4)+substr(%t_times,3,4)+substr(%t_Times,1,2)+substr(%t_Times,9,0)
   #block_end
   
   ;define event
   #if %t_Event_Type == "acINIT" #then @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp'### SYS_STARTED ###")
      #else @v_Event = append(%v_Event, "'t_Time_Tag''t_Sp'UN't_Sp''UN''t_Sp'OA't_Sp''OA'")
   
   ;write event to log file
   @t_Cnt_Name = "SYS_CNTR:D5"
   @t_File_Tag = "Upo"
   @t_File_Ext = "sse"
   
   #error ignore
      @i_Cnt_Value = 't_Cnt_Name'
   #error stop
   #if status <> 0 #then #block
      @l_SYS_CNTR = list(IU = 1, MO = 0, PE = 1, PQ = 4, HR = 5, CM = do(apl:bsv40, "SSS", "GetLanguageText", "Data_Obj_of_SYS_CNTR", true))
      @i_Create_Status = do(apl:bsv40, "SSS", "CreateDataObject", "SYS_CNTR", %l_SYS_CNTR, false, true, 0)
      @i_Cnt_Value = 't_Cnt_Name'
   #block_end
   
   #if %i_Cnt_Value >= l_General_Info:vMAX_LENGTH_OF_LOG #then #block
      @l_Create_Backup = do(apl:bsv40, "SSS", "CreateLogBackup", %t_File_Tag, %t_File_Ext)
      @i_Cnt_Value = 0
   #block_end
   
   @i_Status = write_text("'t_File_Path'/'t_File_Tag'_active.'t_File_ext'", %v_Event, 1)   
#block_end

;update counter value
#set 't_Cnt_Name' = %i_Cnt_Value + 1

; Method: GetObjectNumbers(t_Obj_Type, [x_Information])
; Version: 1.0
; Parameters: t_Obj_Type, type of object having attribute value, e.g. "STATION"
;             [x_Information], the number of the NET object or signal engineering file/device nr
; Return data type: v_Object_Numbers, objects numbers for specified type.
; Description: Reads object numbers from the configuration file and returns in specified
;              format.
; ----------------------------------------------------------------------------------------------

@t_Obj_Type = argument(1)

@x_Information = ""
#if argument_count == 2 #then @x_Information = argument(2)

@l_General_Info = apl:bsv45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI

#case %t_Obj_Type

   #when "NODE" @v_Ini_Pars = ("NODES", "Node_Numbers")
   #when "NODE_LINK" @v_Ini_Pars = ("NODE_'x_Information'_LINKS", "Node_Link_Numbers")
   #when "STATION" @v_Ini_Pars = ("STATIONS", "Station_Numbers")
   #when "PRINTER" @v_Ini_Pars = ("PRINTERS", "Printer_Numbers")
   #when "SLCM" @v_Ini_Pars = ("SLCM", "SLCM_Numbers")
   #when "APPLICATION" @v_Ini_Pars = ("APPLICATIONS", "Application_Numbers")
   #when "UNDEF_PROC" @v_Ini_Pars = ("UNDEF_PROC", "Station_Numbers")
   #otherwise @v_Ini_Pars = vector(%t_Obj_Type, "OBJECT_DOES_NOT_EXIST")

#case_end

@l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Ini_Pars(1), %v_Ini_Pars(2))

#if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

   #if length(l_Ini_Read:vVALUE) == 1 #then @v_Obj_Numbers = dec_scan(separate(l_Ini_Read:vVALUE, ","))
   #else #block

      #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == ",-" #then @v_Obj_Numbers = dec_scan(separate(substr(l_Ini_Read:vVALUE, 1, length(l_Ini_Read:vVALUE) - 2), ","))
         #else @v_Obj_Numbers = dec_scan(separate(l_Ini_Read:vVALUE, ","))

   #block_end
   
   @i_Highest_Number = 1
   ;read in continuos key items (if any)
   #loop_with i_Numbers = 2 .. 10000

      @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Ini_Pars(1), %v_Ini_Pars(2) + "_'i_Numbers'")

      #if l_Ini_Read:vSTATUS == 0 #then #block

         #if l_Ini_Read:vVALUE <> "" #then #block

            #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == ",-" #then @v_Obj_Numbers = append(%v_Obj_Numbers, dec_scan(separate(substr(l_Ini_Read:vVALUE, 1, length(l_Ini_Read:vVALUE) - 2), ",")))
            #else #block
               @v_Obj_Numbers = append(%v_Obj_Numbers, dec_scan(separate(l_Ini_Read:vVALUE, ",")))
               @i_Highest_Number = %i_Numbers
               #loop_exit
            #block_end

         #block_end
         #else #loop_exit

      #block_end
         #else #loop_exit

   #loop_end   

   #return list(STATUS = 0, DATA = %v_Obj_Numbers, HIGH_ELEMENT = %i_Highest_Number)

#block_end

#if l_Ini_Read:vSTATUS == 558 or l_Ini_Read:vSTATUS == 559 #then #return list(STATUS = -1, DATA = vector())
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_OBJECT_NUMBERS_READ_ERROR ['l_Ini_Read:vSTATUS']")

; Method: GetLanguageText(t_Text_Item, [b_Return_As_Text])
; version: 1.0
; Parameters: t_Text_Item, text item of language dependent text
; Return data type: t_Text_String, language dependent text for passed text item
;                   [b_Return_As_Text], returns language dependent text as text, default as list
; Description: Returns language dependent text for passed text item. Language dependent texts are
;              stored in the parametrization file in folder SysConf/Lang_Texts/SSS_Texts.ini
; ------------------------------------------------------------------------------------------------

@t_Text_Item = argument(1)

@b_Return_As_Text = FALSE
#if argument_count == 2 #then @b_Return_As_Text = argument(2)

;read in general info
@l_General_Info = apl:bsv45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_LANG_INI

;define used application language
#if APL:BLA <> "" #then @t_Ini_Section = APL:BLA
   #else @t_Ini_Section = "EN"

;read in text item
@l_Ini_Read = read_parameter(%t_Conf_Data_File, %t_Ini_Section, %t_Text_Item)
#if l_Ini_Read:vSTATUS == 558 or l_Ini_Read:vSTATUS == 559 #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, "EN", %t_Text_Item)

#if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

   #if %b_Return_As_Text #then #return evaluate(l_Ini_Read:vVALUE)
      #else #return list(STATUS = 0, DATA = evaluate(l_Ini_Read:vVALUE))

#block_end

#if %b_Return_As_Text #then #return ""
#else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_LANGUAGE_TEXT_READ_ERROR ['l_Ini_Read:vSTATUS']")

; Method: CreateTimeChannel(t_Time_Channel_Name, [l_Attributes_and_Values], [b_Modify])
; Version: 1.0
; Parameters: t_Time_Channel_Name, name of time channel to be created/modified
;             [l_Attributes_and_Values], attributes to be modified according to passed values
;             [b_Modify], modify existing time channel (default: false)
; Description: Creates (or modifies) time channel according to passed values.
; ---------------------------------------------------------------------------------------------

@t_Time_Channel_Name = argument(1)

@l_Attributes_and_Values = list()
@b_Modify = FALSE
#if argument_count == 2 #then @l_Attributes_and_Values = argument(2)
#if argument_count == 3 #then #block
   @l_Attributes_and_Values = argument(2)
   @b_Modify = argument(3)
#block_end

@l_Obj = fetch(0, "T", %t_Time_Channel_Name)

#if l_Obj:vIU == -1 #then #block

   #error ignore
   @i_Status = status
   #create 't_Time_Channel_Name':T = list()
   @i_Status = status
   #error stop
   
   #if %i_Status == 0 #then @b_Modify = TRUE
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_TIME_CHANNEL_CREATE_ERROR ['i_Status'] ('t_Time_Channel_Name')")

#block_end   

#if %b_Modify #then #block    
   
   #error ignore
   @i_Status = status
   @v_Attributes = list_attr(%l_Attributes_and_Values)
   #loop_with i_Attribute = 1 .. length(%v_Attributes)
      @t_Attribute = %v_Attributes(%i_Attribute)
      #modify 't_Time_Channel_Name':T = list('t_Attribute' = l_Attributes_and_Values:v't_Attribute')
   #loop_end
   @i_Status = status
   #error stop
   
   #if %i_Status == 0 #then #return list(STATUS = 0)
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_TIME_CHANNEL_MODIFY_ERROR ['i_Status'] ('t_Time_Channel_Name')")

#block_end
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_TIME_CHANNEL_ALREADY_EXIST ('t_Time_Channel_Name')")

; Method: CreateDataObject(t_Data_Object_Name, [l_Attributes_and_Values], [b_Modify], [b_Initialize_Registrations], [i_Registration_Value])
; Version: 1.0
; Parameters: t_Data_Object_Name, name of data object to be created/modified
;             [l_Attributes_and_Values], attributes to be modified according to passed values
;             [b_Modify], modify existing data object (default: false)
;             [b_Initialize_Registrations], initialize history registration at object creation/modification (default: false)
;             [i_Registration_Value], initialized value of history registrations (default: 0)
; Description: Creates (or modifies) data object according to passed values.
; ------------------------------------------------------------------------------------------------------------------------------------------

@t_Data_Object_Name = argument(1)

@l_Attributes_and_Values = list()
@b_Modify = FALSE
@b_Initialize_Registrations = FALSE
@i_Registration_Value = 0
#if argument_count == 2 #then @l_Attributes_and_Values = argument(2)
#if argument_count == 3 #then #block
   @l_Attributes_and_Values = argument(2)
   @b_Modify = argument(3)
#block_end
#if argument_count == 4 #then #block
   @l_Attributes_and_Values = argument(2)
   @b_Modify = argument(3)
   @b_Initialize_Registrations = argument(4)   
#block_end
#if argument_count == 5 #then #block
   @l_Attributes_and_Values = argument(2)
   @b_Modify = argument(3)
   @b_Initialize_Registrations = argument(4)
   @i_Registration_Value = argument(5)
#block_end

@l_Obj = fetch(0, "D", %t_Data_Object_Name)

#if l_Obj:vIU == -1 #then #block

   #error ignore
   @i_Status = status
   #create 't_Data_Object_Name':D = list()
   @i_Status = status
   #error stop
   
   #if %i_Status == 0 #then @b_Modify = TRUE
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_DATA_OBJECT_CREATE_ERROR ['i_Status'] ('t_Data_Object_Name')")

#block_end   
#else @b_Modify = TRUE

#if %b_Modify #then #block    
   
   #error ignore
   @i_Status = status
   @v_Attributes = list_attr(%l_Attributes_and_Values)
   #loop_with i_Attribute = 1 .. length(%v_Attributes)
      @t_Attribute = %v_Attributes(%i_Attribute)
      #modify 't_Data_Object_Name':D = list('t_Attribute' = l_Attributes_and_Values:v't_Attribute')
   #loop_end
   #if %b_Initialize_Registrations #then #set 't_Data_Object_Name':DOV(..) = %i_Registration_Value
   @i_Status = status
   #error stop
   
   #if %i_Status == 0 #then #return list(STATUS = 0)
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_DATA_OBJECT_MODIFY_ERROR ['i_Status'] ('t_Data_Object_Name')")      

#block_end
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_DATA_OBJECT_ALREADY_EXIST ('t_Data_Object_Name')")  

; Method: CreateCommandProcedure(t_Command_Procedure_Name, [l_Attributes_and_Values], [b_Compilation], [b_Modify], [t_Instruction_Action], [b_Duplicate])
; Version: 1.0
; Parameters: t_Command_Procedure_Name, name of command procedure to be created/modified
;             [l_Attributes_and_Values], attributes to be modified according to passed values
;             [b_Compilation], compilation of instruction (default: not compiled )
;             [b_Modify], modify existing command procedure according to passed values (default: not modified)
;             [t_Instruction_Action], action of instruction for existing command procedure ("acOVER" [default], "acAPPEND_TOP", "acAPPEND_BOTTOM")
;             [b_Duplicate], duplicate attributes (before mofifications) to backup file stored in directory pict/'t_Command_Procedure_Name'.bak (default: not duplicated)
; Description: Creates (or modifies) command procedure according to passed values.
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

@t_Command_Procedure_Name = argument(1)

@l_Attributes_and_Values = list()
@b_Compilation = FALSE
@b_Modify = FALSE
@t_Instruction_Action = "acOVER"
@b_Duplicate = FALSE

#if argument_count > 1 #then @l_Attributes_and_Values = argument(2)
#if argument_count > 2 #then @b_Compilation = argument(3)
#if argument_count > 3 #then @b_Modify = argument(4)
#if argument_count > 4 #then @t_Instruction_Action = argument(5)
#if argument_count > 5 #then @b_Duplicate = argument(6)

@l_Obj = fetch(0, "C", %t_Command_Procedure_Name)

#if l_Obj:vIU == -1 #then #block

   #error ignore
   @i_Status = status
   #create 't_Command_Procedure_Name':C = list()
   @i_Status = status
   #error stop
   
   #if %i_Status == 0 #then @b_Modify = TRUE
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_COMMAND_PROCEDURE_CREATE_ERROR ['i_Status'] ('t_Command_Procedure_Name')")
      
#block_end

#if %b_Modify #then #block

   #if %b_Duplicate #then @i_Duplicate_Status = do(apl:bsv40, "SSS", "DuplicateCommandProcedure", %t_Command_Procedure_Name)

   #error ignore
   @i_Status = status
   @v_Attributes = list_attr(%l_Attributes_and_Values)
   #loop_with i_Attribute = 1 .. length(%v_Attributes)
      @t_Attribute = %v_Attributes(%i_Attribute)
      #if %t_Attribute == "IN" #then #block
         #case upper_case(%t_Instruction_Action)
            #when "ACOVER" #modify 't_Command_Procedure_Name':C = list(IN = l_Attributes_and_Values:vIN)
            #when "ACAPPEND_TOP" #block
               @v_Comment_Lines = vector()
               @i_Line = 1
               #loop edit(substr('t_Command_Procedure_Name':CIN(%i_Line), 1, 1), "LEFT_TRIM") == ";"
                  @v_Comment_Lines = append(%v_Comment_Lines, 't_Command_Procedure_Name':CIN(%i_Line))
                  @i_Line = %i_Line+1
               #loop_end length('t_Command_Procedure_Name':CIN)
               @v_Instruction_Lines = append(%v_Comment_Lines, "")
               @v_Instruction_Lines = append(%v_Instruction_Lines, l_Attributes_and_Values:vIN)
               @v_Instruction_Lines = append(%v_Instruction_Lines, 't_Command_Procedure_Name':CIN(%i_Line ..))
               #modify 't_Command_Procedure_Name':C = list(IN = %v_Instruction_Lines)
            #block_end
            #when "ACAPPEND_BOTTOM" #modify 't_Command_Procedure_Name':C = list(IN = append('t_Command_Procedure_Name':CIN, l_Attributes_and_Values:vIN))
            #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_COMMAND_PROCEDURE_INSTRUCTION_ACTION_NOT_DEFINED ('t_Command_Procedure_Name')")
         #case_end
      #block_end
         #else #modify 't_Command_Procedure_Name':C = list('t_Attribute' = l_Attributes_and_Values:v't_Attribute')
   #loop_end
   #if %b_Compilation #then #block
      @l_Compile = compile('t_Command_Procedure_Name':CIN)
      #if l_Compile:vSTATUS == 0 #then #modify 't_Command_Procedure_Name':C = list(CP = l_Compile:vCODE)
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_COMMAND_PROCEDURE_COMPILATION_ERROR ('t_Command_Procedure_Name')")
   #block_end
   @i_Status = status
   #error stop    
   
   #if %i_Status == 0 #then #return list(STATUS = 0)
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_COMMAND_PROCEDURE_MODIFY_ERROR ['i_Status'] ('t_Command_Procedure_Name')")      

#block_end
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_COMMAND_PROCEDURE_ALREADY_EXIST ('t_Command_Procedure_Name')")
   
; Method: DuplicateCommandProcedure(t_Duplicate_Name)
; version: 1.0
; Parameters: t_Duplicate_Name, name of command procedure to be duplicated
; Description: Duplicates passed command procedure attributes to backup file stored
;              in directory pict/'t_Duplicate_Name'.bak
; ------------------------------------------------------------------------------------

@t_Duplicate_Name = argument(1)

#search 1 0 "C" "A" "" LN == upper_case(%t_Duplicate_Name)
@l_Obj_Attr = next(1)

#if l_Obj_Attr:vIU <> -1 #then #block

   ;define object vector
   @v_Obj_Attr = vector()
   @v_Obj_Attr = append(%v_Obj_Attr, "LN: 'l_Obj_Attr:vLN', CM: 'l_Obj_Attr:vCM'")
   @v_Obj_Attr = append(%v_Obj_Attr, "IU: 'l_Obj_Attr:vIU', TS: 'l_Obj_Attr:vTS', MO: 'l_Obj_Attr:vMO', SE: 'l_Obj_Attr:vSE'" + -
                                     "PE: 'l_Obj_Attr:vPE', PQ: 'l_Obj_Attr:vPQ', TC: 'l_Obj_Attr:vTC', HN: 'l_Obj_Attr:vHN', EP: 'l_Obj_Attr:vEP'")
   @v_Obj_Attr = append(%v_Obj_Attr, "")
   @v_Obj_Attr = append(%v_Obj_Attr, l_Obj_Attr:vIN)

#block_end
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DUPLICATE_COMMAND_PROCEDURE_DUPLICATE_ERROR ('t_Duplicate_Name')")

;backup copy      
@v_File_Path = path("PICT")
@i_Number_of_Files = length(file_manager("LIST", fm_directory(%v_File_Path(1)), "'t_Duplicate_Name'.*"))

#if %i_Number_of_Files <> 0 #then @t_File_Ext = substr(dec(1000+%i_Number_of_Files,3),2,0)
   #else @t_File_Ext = "bak"

@i_Create_Status = write_text("PICT/'t_Duplicate_Name'.'t_File_ext'", %v_Obj_Attr, 1)

#if %i_Create_Status == 0 #then #return list(STATUS = 0)
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DUPLICATE_COMMAND_PROCEDURE_DUPLICATE_ERROR ['i_Create_Status'] ('t_Duplicate_Name')")

; Method: DeleteCommandProcedure(t_Command_Procedure_Name)
; Version: 1.0
; Parameters: t_Command_Procedure_Name, name of command procedure to be deleted
; Description: Deletes command procedure according to passed value
; -------------------------------------------------------------------------------

@t_Command_Procedure_Name = argument(1)

@l_Obj = fetch(0, "C", %t_Command_Procedure_Name)

#if l_Obj:vIU == -1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_COMMAND_PROCEDURE_DOES_NOT_EXIST ('t_Command_Procedure_Name')")
   #else #delete 't_Command_Procedure_Name':C
   
#return list(STATUS = 0)

; Method: DeleteDataObject(t_Data_Object_Name, [l_Attributes_and_Values], [b_Modify])
; Version: 1.0
; Parameters: t_Data_Object_Name, name of data object to be deleted
; Description: Deletes data object according to passed value
; ------------------------------------------------------------------------------------

@t_Data_Object_Name = argument(1)

@l_Obj = fetch(0, "D", %t_Data_Object_Name)

#if l_Obj:vIU == -1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_DATA_OBJECT_DOES_NOT_EXIST ('t_Data_Object_Name')")
   #else #delete 't_Data_Object_Name':D
   
#return list(STATUS = 0)   

; Method: DeleteTimeChannel(t_Time_Channel_Name)
; Version: 1.0
; Parameters: t_Time_Channel_Name, name of time channel to be deleted
; Description: Deletes time channel according to passed values (if no objects attached)
; --------------------------------------------------------------------------------------

@t_Time_Channel_Name = upper_case(argument(1))

@l_Obj = fetch(0, "T", %t_Time_Channel_Name)

#if l_Obj:vIU == -1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_TIME_CHANNEL_DOES_NOT_EXIST ('t_Time_Channel_Name')")
#else #block

   @l_Attached_Procedures = application_object_list(0, "C", "", "", "", upper_case("TC == %t_Time_Channel_Name"))
   @l_Attached_Objects = application_object_list(0, "D", "", "", "", upper_case("TC == %t_Time_Channel_Name"))

   #if l_Attached_Procedures:vCOUNT == 0 and l_Attached_Objects:vCOUNT == 0 #then #delete 't_Time_Channel_Name':T
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_TIME_CHANNEL_NOT_EMPTY ('t_Time_Channel_Name')")

#block_end

#return list(STATUS = 0)

; Method: GetObjectAttributeMapping(t_Parameter_File_Type, t_Obj_Type)
; Version: 1.0
; Parameters: t_Parameter_File_Type, type of parametrization file ("CONF", "EVENT", FILTER")
;             t_Obj_Type, type of object having attribute values, e.g. "STATION"
; Return data type: l_Object_Attributes, objects attributes for specified type.
; Description: Reads object attribute mapping from the configuration file and returns in 
;              specified format.
; ----------------------------------------------------------------------------------------------

@t_Parameter_File_Type = argument(1)
@t_Obj_Type = argument(2)

@l_General_Info = apl:bsv45

#case upper_case(%t_Parameter_File_Type)

   #when "CONF" #block
   
      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI

      #case upper_case(%t_Obj_Type)
         #when "ROUTING" @t_Ini_Par = "Routing_Attributes"
         #when "NODE" @t_Ini_Par = "Node_Attributes"
         #when "NODE_LINK" @t_Ini_Par = "Node_Link_Attributes"
         #when "STATION" @t_Ini_Par = "Station_Attributes"
         #when "PRINTER" @t_Ini_Par = "Printer_Attributes"
         #when "SLCM" @t_Ini_Par = "SLCM_Attributes"
         #when "OPERATING_SYSTEM" @t_Ini_Par = "Operating_System_Attributes"
         #when "APPLICATION" @t_Ini_Par = "Application_Attributes"
         #otherwise @t_Ini_Par = "ATTRIBUTE_MAPPING_DOES_NOT_EXIST"
      #case_end

   #block_end
   
   #when "EVENT" #block

      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

      #case upper_case(%t_Obj_Type)
         #when "EVENT" @t_Ini_Par = "Event_Attributes"
         #when "ALARM" @t_Ini_Par = "Alarm_Attributes"
         #otherwise @t_Ini_Par = "ATTRIBUTE_DOES_NOT_EXIST"
      #case_end

   #block_end   

   #when "FILTER" #block

      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_FILTER_INI

      #case upper_case(%t_Obj_Type)
         #when "EVENT" @t_Ini_Par = "Event_Attributes"
         #otherwise @t_Ini_Par = "ATTRIBUTE_DOES_NOT_EXIST"
      #case_end

   #block_end

   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_OBJECT_ATTRIBUTE_MAPPING_USAGE_ERROR")
   
#case_end

@l_Ini_Read = read_parameter(%t_Conf_Data_File, "ATTRIBUTE_MAPPING", %t_Ini_Par)

#if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block
   
   @v_Ini_Items = separate(l_Ini_Read:vVALUE, ",")
      
   #return list(STATUS = 0, DATA = %v_Ini_Items)
   
#block_end

#return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_OBJECT_ATTRIBUTE_MAPPING_DOES_NOT_EXIST")

; Method: DeleteEventChannel(t_Event_Channel_Name, [t_Object_Name], [t_Object_Type])
; Version: 1.0
; Parameters: t_Event_Channel_Name, name of event channel to be deleted (if no objects attached)
;             [t_Object_Name], name of object to be deleted from the attached object list
;             [t_Object_Type], type of application object attached to event channel, default "C" ("C", "D", "T")
; Description: Deletes event channel or/and removes attached object from event channel according to passed values.
; -----------------------------------------------------------------------------------------------------------------

@t_Event_Channel_Name = argument(1)

@t_Object_Type = "C"
#if argument_count == 2 #then @t_Object_Name  = argument(2)
   #else @t_Object_Name = %t_Event_Channel_Name
#if argument_count == 3 #then #block
   @t_Object_Name = argument(2)
   @t_Object_Type = argument(3)
#block_end

@l_Obj = fetch(0, "A", %t_Event_Channel_Name)

#if l_Obj:vIU == -1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_EVENT_CHANNEL_DOES_NOT_EXIST ('t_Event_Channel_Name')")
#else #block

   @v_Activated_Objects = append(vector('t_Event_Channel_Name':AON), 't_Event_Channel_Name':ASN)
   @v_Activated_Object_Types = append(vector('t_Event_Channel_Name':AOT), 't_Event_Channel_Name':AST)
      
   #if length(select(%v_Activated_Objects, upper_case("== %t_Object_Name"))) > 0 #then #block
            
      @v_Objects = vector()
      @v_Types = vector()
      
      #loop_with i_Objects = 1 .. length(%v_Activated_Objects)
      
         #if %v_Activated_Objects(%i_Objects) <> upper_case(%t_Object_Name) or -
            %v_Activated_Object_Types(%i_Objects) <> upper_case(%t_Object_Type) #then #block
         
            @v_Objects = append(%v_Objects, %v_Activated_Objects(%i_Objects))
            @v_Types = append(%v_Types, %v_Activated_Object_Types(%i_Objects))
         
         #block_end
      
      #loop_end   

      #case length(%v_Objects)
         
         #when 0 #delete 't_Event_Channel_Name':A
         
         #when 1 #block
            #modify 't_Event_Channel_Name':A = list(-
               ON                            = %v_Objects(1),-
               OT                            = %v_Types(1),-
               ST                            = vector(),-
               SN                            = vector())
         #block_end
         
         #otherwise #block
            #modify 't_Event_Channel_Name':A = list(-
               ON                            = %v_Objects(1),-
               OT                            = %v_Types(1),-
               ST                            = %v_Objects(2..),-
               SN                            = %v_Types(2..))
         #block_end
      
      #case_end

   #block_end
   
#block_end
   
#return list(STATUS = 0)

; Method: CreateScaleObject(t_Scale_Object_Name, [l_Attributes_and_Values], [b_Modify])
; Version: 1.0
; Parameters: t_Scale_Object_Name, name of scale object to be created/modified
;             [l_Attributes_and_Values], attributes to be modified according to passed values
;             [b_Modify], modify existing scale object (default: false)
; Description: Creates (or modifies) scale object according to passed values.
; ---------------------------------------------------------------------------------------------

@t_Scale_Object_Name = argument(1)

@l_Attributes_and_Values = list()
@b_Modify = FALSE
#if argument_count == 2 #then @l_Attributes_and_Values = argument(2)
#if argument_count == 3 #then #block
   @l_Attributes_and_Values = argument(2)
   @b_Modify = argument(3)
#block_end

@l_Obj = fetch(0, "X", %t_Scale_Object_Name)

#if l_Obj:vIU == -1 #then #block

   #error ignore
   @i_Status = status
   #create 't_Scale_Object_Name':X = list(SA = 0)
   @i_Status = status
   #error stop
   
   #if %i_Status == 0 #then @b_Modify = TRUE
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_SCALE_OBJECT_CREATE_ERROR ['i_Status'] ('t_Scale_Object_Name')")

#block_end   

#if %b_Modify #then #block    
   
   #error ignore
   @i_Status = status
   @v_Attributes = list_attr(%l_Attributes_and_Values)
   #loop_with i_Attribute = 1 .. length(%v_Attributes)
      @t_Attribute = %v_Attributes(%i_Attribute)
      #modify 't_Scale_Object_Name':X = list('t_Attribute' = l_Attributes_and_Values:v't_Attribute')
   #loop_end
   @i_Status = status
   #error stop
   
   #if %i_Status == 0 #then #return list(STATUS = 0)
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_SCALE_OBJECT_MODIFY_ERROR ['i_Status'] ('t_Scale_Object_Name')")      

#block_end
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_SCALE_OBJECT_ALREADY_EXIST ('t_Scale_Object_Name')")  

; Method: DeleteScaleObject(t_Scale_Object_Name)
; Version: 1.0
; Parameters: t_Scale_Object_Name, name of scale object to be deleted
; Description: Deletes scale object according to passed value (if no process objects attached)
; ---------------------------------------------------------------------------------------------

@t_Scale_Object_Name = argument(1)

@l_Obj = fetch(0, "X", %t_Scale_Object_Name)

#if l_Obj:vIU == -1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_SCALE_OBJECT_DOES_NOT_EXIST ('t_Scale_Object_Name')")
#else #block

   @l_Attached_Objects = application_object_list(0, "IX", "", "", "", upper_case("SN == %t_Scale_Object_Name"))
   
   #if l_Attached_Objects:vCOUNT == 0 #then #delete 't_Scale_Object_Name':X
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_SCALE_OBJECT_NOT_EMPTY ('t_Scale_Object_Name')")

#block_end
   
#return list(STATUS = 0)   

; Method: GetObjectIdentification(t_Station_Identification, t_Bay_Identification, t_Device_Identification)
; Version: 1.0
; Parameters: t_Station_Identification, text to be attached to Station identification field
;             t_Bay_Identification, text to be attached to Bay identification field
;             t_Device_Identification, text to be attached to Device identification field
; Return data type: t_OI
; Description: Reads the configuration of OI attribute from the application system variable and returns
;              OI attribute with passed values in specified format
;--------------------------------------------------------------------------------------------------------

@t_Station_Identification = argument(1)
@t_Bay_Identification = argument(2)
@t_Device_Identification = argument(3)

@t_OI = ""

;read in OI configuration
@t_Error_State = error_state
#error ignore
@i_Status = status
@l_Apl_Bsv15 = APL:BSV15
@l_Process_Objects = l_Apl_Bsv15:vPROCESS_OBJECTS
@l_OI = l_Process_Objects:vOI
@i_Status = status
#error 't_Error_State'

;set defaults, if APL:BSV15 not correctly defined
#if %i_Status <> 0 #then @l_OI = list(-
      FIELD1                   = vector("STA"),-
      FIELD2                   = vector("BAY"),-
      FIELD3                   = vector("DEV"),-
      FIELD4                   = vector(""),-
      FIELD5                   = vector(""),-
      LENGTH1                  = 10,-
      LENGTH2                  = 15,-
      LENGTH3                  = 5,-
      LENGTH4                  = 0,-
      LENGTH5                  = 0)

;define OI attribute with passed values
@i_Nbr_of_Fields = length(select(list_attr(%l_OI), "==""FIELD*""", "WILDCARDS"))

#loop_with i_Field = 1 .. %i_Nbr_of_Fields

   #if l_OI:vLENGTH'i_Field' > 0 #then #block

      @v_Field_Id = l_OI:vFIELD'i_Field'

      #case %v_Field_Id(1)
         #when "STA" @t_OI = %t_OI+substr(%t_Station_Identification, 1, l_OI:vLENGTH'i_Field'-1)+substr("", 1, 1)
         #when "BAY" @t_OI = %t_OI+substr(%t_Bay_Identification, 1, l_OI:vLENGTH'i_Field'-1)+substr("", 1, 1)
         #when "DEV" @t_OI = %t_OI+substr(%t_Device_Identification, 1, l_OI:vLENGTH'i_Field'-1)+substr("", 1, 1)
         #otherwise @t_OI = %t_OI+substr("SSS", 1, l_OI:vLENGTH'i_Field'-1)+substr("", 1, 1) ; ID 15219
      #case_end

      @v_Field_Identifiers(%i_Field) = %v_Field_Id(1)
   
   #block_end

#loop_end

;modify OI attribute, if Device identification field doesn't exist
#if length(select(%v_Field_Identifiers, "== ""DEV""")) == 0 #then #block

   @t_OI = ""

   #loop_with i_Field = 1 .. length(%v_Field_Identifiers)

      #case %v_Field_Identifiers(%i_Field)
         #when "STA" @t_OI = %t_OI+substr(%t_Station_Identification, 1, l_OI:vLENGTH'i_Field'-1)+substr("", 1, 1)
         #when "BAY" #block
            @t_Identification = %t_Bay_Identification+substr("", 1, 1)+%t_Device_Identification
            @t_OI = %t_OI+substr(%t_Identification, 1, l_OI:vLENGTH'i_Field'-1)+substr("", 1, 1)
         #block_end
         #otherwise @t_OI = %t_OI+substr("", 1, l_OI:vLENGTH'i')
      #case_end

   #loop_end

#block_end

#return list(STATUS = 0, DATA =  %t_OI)

; Method: CheckProcedureInstruction(t_Command_Procedure_Name, v_Instruction)
; Version: 1.0
; Parameters: t_Procedure_Name, name of command procedure
;             v_Instruction, instruction line/-s to be checked
; Return data type: b_Exist 
; Description: Checks if specified instruction exist already in command procedure's instruction line
; ---------------------------------------------------------------------------------------------------

@t_Procedure_Name = argument(1)
@v_Instruction = argument(2)

@b_Exist =  TRUE

@l_Obj = fetch(0, "C", %t_Procedure_Name)

#if l_Obj:vIU == -1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CHECK_PROCEDURE_INSTRUCTION_COMMAND_PROCEDURE_DOES_NOT_EXIST ('t_Procedure_Name')")
#else #block

   #loop_with i_Line = 1 .. length(%v_Instruction)

      #if length(select(locate(upper_case('t_Procedure_Name':CIN), upper_case(%v_Instruction(%i_Line))), "<>0")) == 0 #then -
         @b_Exist = FALSE

   #loop_end
   
#block_end

#return list(STATUS = 0, DATA = %b_Exist)

; Method: GetLogicalNameAndIndex(t_Process Object_Notation)
; Version: 1.0
; Parameters: t_Process Object_Notation, notation of process object e.g. "SYS_S0021:P10"
; Return data type: l_Object_Notation
; Description: Reads logical name and index from passed process object notation and returns in 
;              specified format
; ---------------------------------------------------------------------------------------------------

;read in arguments
@t_Process_Object_Notation = argument(1)

;initialize variables
@t_Descriptive_Text = ""

;define LN and IX
@v_Process_Object_Notation_Items = separate(%t_Process_Object_Notation, ":")

#if length(%v_Process_Object_Notation_Items) == 1 #then @t_Descriptive_Text = "SCM_SERVICE_GET_LOGICAL_NAME_AND_INDEX_NOTATION_ERROR ('t_Process_Object_Notation')"
#else #block
   @t_Error_State = error_state
   #error ignore
      @i_Status = status
      @l_Process_Object_Notation = list(LN = %v_Process_Object_Notation_Items(1), IX = dec_scan(substr(%v_Process_Object_Notation_Items(2), 2, 0)))
   #error 't_Error_State'

   #if status <> 0 #then @t_Descriptive_Text = "SCM_SERVICE_GET_LOGICAL_NAME_AND_INDEX_NOTATION_TYPE_ERROR"
#block_end

#if %t_Descriptive_Text == "" #then #return list(STATUS = 0, LN = l_Process_Object_Notation:vLN, IX = l_Process_Object_Notation:vIX)
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = %t_Descriptive_Text)

; Method: CompareAttributeList(t_Object_Type, i_Object_Number, l_Attr_List, [x_Information])
; Version: 1.0
; Parameters: t_Object_Type, object type of list items to be compared
;             i_Object_Number, object number of list items to be compared
;             l_Attr_List, list of items to be compared with object configuration
; Return data: text, result of comparision of list items ("DUPLICATE" or "NONE DUPLICATE")
; Description: Given attribute list is compared with arguments defined in the configuration file 
;              and return value of the comparision is returned with specified format
; ------------------------------------------------------------------------------------------------

@t_Object_Type = argument(1)
@i_Object_Number = argument(2)
@l_Attr_List = argument(3)

#if argument_count > 3 #then @x_Information = argument(4)
   #else @x_Information = ""

@l_General_Info = apl:bsv45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI


@b_Duplicate = TRUE

@v_Attributes = list_attr(%l_Attr_List)

#loop_with i_Attribute = 1 .. length(%v_Attributes)

   @t_Attribute = %v_Attributes(%i_Attribute)
   
   #if upper_case(%t_Object_Type) <> "NODE_LINK" #then @l_Attribute_In_Conf_File = -
      do(apl:bsv40, "SSS", "GetObjectAttribute", %t_Object_Type, %i_Object_Number, %t_Attribute)
   #else @l_Attribute_In_Conf_File = -
      do(apl:bsv40, "SSS", "GetObjectAttribute", %t_Object_Type, %i_Object_Number, %t_Attribute, %x_Information)
   
   @t_Error_State = error_state
   #error ignore
      @i_Status = status
      #if l_Attribute_In_Conf_File:v't_Attribute' <> l_Attr_List:v't_Attribute' #then @b_Duplicate = FALSE
      @i_Status = status
   #error 't_Error_State'
   
#loop_end

#if %i_Status == 0 #then #block 
   #if %b_Duplicate #then #return list(STATUS = 0, DATA = "DUPLICATE")
      #else #return list(STATUS = 0, DATA = "NONE DUPLICATE")
#block_end
   #else #return list(STATUS = -1, DESCRIPTIVE_TEXT = "SCM_SERVICE_COMPARE_ATTRIBUTE_LIST_ERROR ['i_Status']")
