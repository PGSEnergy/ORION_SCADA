; Method: CreateEventChannel(t_Event_Channel_Name, [t_Command_Procedure_Name], [t_Object_Type], [l_Attributes_and_Values])
; Version: 1.0
; Parameters: t_Event_Channel_Name, name of event channel to be created/modified
;             [t_Command_Procedure_Name], name of command procedure to be attached, if not passed same as event channel name
;             [t_Object_Type], type of application object to be attached, default "C"
;             [l_Attributes_and_Values], attributes to be modified according to passed values
; Description: Creates event channel and attach the passed command procedure into it. The command procedure SYS_INIT_1 and
;              SYS_SSSRT is always attached as first item in the secondary object list of event channel.
; --------------------------------------------------------------------------------------------------------------------------

@t_Event_Channel_Name = argument(1)
@t_Command_Procedure_Name = %t_Event_Channel_Name
@t_Object_Type = "C"
@l_Attributes_and_Values = list()
#if argument_count > 1 #then @t_Command_Procedure_Name = argument(2)
#if argument_count > 2 #then @t_Object_Type = argument(3)
#if argument_count > 3 #then @l_Attributes_and_Values = argument(4)

@MAX_SECONDARY_OBJECT_COUNT = 10
@i_Status = 0
@t_Descriptive_Text = ""
@l_Obj = fetch(0, "A", %t_Event_Channel_Name)
#if l_Obj:vIU == -1 #then #create 't_Event_Channel_Name':A = list(OT = %t_Object_Type, ON = %t_Command_Procedure_Name)

#if l_Obj:vIU == 1 #then #block
   @v_Activated_Objects = 't_Event_Channel_Name':ASN
   @v_Activated_Object_Types = 't_Event_Channel_Name':AST

   #if length(select(append(vector('t_Event_Channel_Name':AON), %v_Activated_Objects), "==upper_case(%t_Command_Procedure_Name)")) == 0 #then #block

      #if length(%v_Activated_Objects) == %MAX_SECONDARY_OBJECT_COUNT #then #block

         @t_Removed_Object = %v_Activated_Objects(%MAX_SECONDARY_OBJECT_COUNT)
         @t_Removed_Type = %v_Activated_Object_Types(%MAX_SECONDARY_OBJECT_COUNT)
         @t_Descriptive_Text = "SCM_SERVICE_CREATE_EVENT_CHANNEL_MAXIMUM_SECONDARY_OBJECT_COUNT_EXCEEDED"
         @i_Status = 1
         @v_Activated_Objects = delete_element(%v_Activated_Objects, %MAX_SECONDARY_OBJECT_COUNT)
         @v_Activated_Object_Types = delete_element(%v_Activated_Object_Types, %MAX_SECONDARY_OBJECT_COUNT)

      #block_end
      #if upper_case(%t_Command_Procedure_Name) == "SYS_INIT_1" or upper_case(%t_Command_Procedure_Name) == "SYS_SSSRT" #then #modify 't_Event_Channel_Name':A = list(SN = append(vector(%t_Command_Procedure_Name), %v_Activated_Objects),-
         ST = append(vector(%t_Object_Type), %v_Activated_Object_Types))
      #else #modify 't_Event_Channel_Name':A = list(SN = append(%v_Activated_Objects, %t_Command_Procedure_Name),-
         ST = append(%v_Activated_Object_Types, %t_Object_Type))
   #block_end
#block_end

#modify 't_Event_Channel_Name':A = list(IU = 1)

@v_Attributes = list_attr(%l_Attributes_and_Values)
#loop_with i_Attribute = 1 .. length(%v_Attributes)
   @t_Attribute = %v_Attributes(%i_Attribute)
   #modify 't_Event_Channel_Name':A = list('t_Attribute' = l_Attributes_and_Values:v't_Attribute')
#loop_end

#if %i_Status == 0 #then #return list(STATUS = %i_Status)
#else #return list(STATUS = %i_Status, DESCRIPTIVE_TEXT = %t_Descriptive_Text)

; Method: GetObjectAttributes(t_Obj_Type, i_Obj_Nr, i_Obj_Net_Nr, b_Return_as_Text)
; Version: 1.0
; Description: Reads all attribute values from the configuration file and returns in specified format.
; ----------------------------------------------------------------------------------------------------

#case argument_count
   #when 1 @l_Status_SCM = do (APL:BSV40, "SSS", "GetObjectAttribute", argument(1), 0, "All")
   #when 2 @l_Status_SCM = do (APL:BSV40, "SSS", "GetObjectAttribute", argument(1), argument(2), "All")
   #when 3 @l_Status_SCM = do (APL:BSV40, "SSS", "GetObjectAttribute", argument(1), argument(2), "All", argument(3))
#case_end

#return %l_Status_SCM

; Method: GetObjectAttribute(t_Obj_Type, i_Obj_Nr, t_Attr_Name, i_Obj_Net_Nr, b_Return_as_Text)
; Version: 1.0
; Parameters: t_Obj_Type, type of object having attribute value, e.g. "BASE_SYSTEM_LINK"
;             i_Obj_Nr, number of the object having attribute value, e.g. 12
;             t_Attr_Name, name of the attribute having required value, e.g. "LT"
;             [i_Obj_Net_Nr], number of the NET object.
;             [b_Return_as_Text], return value as text format, default as real format.
; Description: Reads attribute value from the configuration file and returns in specified
;              format.
; ---------------------------------------------------------------------------------------

@t_Obj_Type = argument(1)
@i_Obj_Nr = argument(2)

@t_Attr_Name = ""
@i_Obj_Net_Nr = 0
#if argument_count > 2 #then @t_Attr_Name = argument(3)
#if argument_count > 3 #then @i_Obj_Net_Nr = argument(4)

@b_Return_as_Text = FALSE
@l_General_Info = APL:BSV45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI

#case %t_Obj_Type
   #when "NODE" @v_Get_Pars = ("Node_Attributes", "NODES", "Node", "CONF", "NODE")
   #when "NODE_EVENT" #block
      @v_Get_Pars = ("Event_Attributes", "EVENTS", "Node_'i_Obj_Nr'_'i_Obj_Net_Nr'", "EVENT", "EVENT")
      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI
   #block_end
   #when "NODE_ALARM" #block
      @v_Get_Pars = ("Alarm_Attributes", "ALARMS", "Node_'i_Obj_Nr'_'i_Obj_Net_Nr'", "EVENT", "ALARM")
      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI
   #block_end
   #when "NODE_LINK" @v_Get_Pars = ("Node_Link_Attributes", "NODE_'i_Obj_Net_Nr'_LINKS", "Node_Link", "CONF", "NODE_LINK")
   #when "STATION" @v_Get_Pars = ("Station_Attributes", "STATIONS", "Station", "CONF", "STATION")
   #when "STATION_EVENT" #block
      @v_Get_Pars = ("Event_Attributes", "EVENTS", "Station_'i_Obj_Nr'_'i_Obj_Net_Nr'", "EVENT", "EVENT")
      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI
   #block_end
   #when "STATION_ALARM" #block
      @v_Get_Pars = ("Alarm_Attributes", "ALARMS", "Station_'i_Obj_Nr'_'i_Obj_Net_Nr'", "EVENT", "ALARM")
      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI
   #block_end
   #when "PRINTER_EVENT" #block
      @v_Get_Pars = ("Event_Attributes", "EVENTS", "Printer_'i_Obj_Nr'_'i_Obj_Net_Nr'", "EVENT", "EVENT")
      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI
   #block_end
   #when "PRINTER_ALARM" #block
      @v_Get_Pars = ("Alarm_Attributes", "ALARMS", "Printer_'i_Obj_Nr'_'i_Obj_Net_Nr'", "EVENT", "ALARM")
      @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI
   #block_end
   #when "SLCM" @v_Get_Pars = ("SLCM_Attributes", "SLCM", "SLCM", "CONF", "SLCM")
   #when "PRINTER" @v_Get_Pars = ("Printer_Attributes", "PRINTERS", "Printer", "CONF", "PRINTER")
   #when "APPLICATION" @v_Get_Pars = ("Application_Attributes", "APPLICATIONS", "Application", "CONF", "APPLICATION")
   #when "OPERATING_SYSTEM" @v_Get_Pars = ("Operating_System_Attributes", "OPERATING_SYSTEM", "Operating_System", "CONF", "OPERATING_SYSTEM")
   #when "UNDEF_PROC" #block

      @l_Ini_Read = read_parameter(%t_Conf_Data_File, %t_Obj_Type, %i_Obj_Nr)
      #if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #return list(STATUS = 0, DATA = evaluate(l_Ini_Read:vVALUE))
      @x_Obj_Item = upper_case(%i_Obj_Nr)
      #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_KEY_NAME_'x_Obj_Item'_DOES_NOT_EXIST")

   #block_end
#case_end

@l_Read_Mapping = do(APL:BSV40, "SSS", "GetObjectAttributeMapping", %v_Get_Pars(4), %v_Get_Pars(5))
#if l_Read_Mapping:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_READ_ATTRIBUTE_MAPPING_ERROR")
@v_Attr_Mapping = l_Read_Mapping:vDATA
@b_Found_as_Vector = FALSE
@i_Attr_Index = 0
@v_Found_Index = select(upper_case(%v_Attr_Mapping), "==upper_case(%t_Attr_Name)")

#if length(%v_Found_Index) > 0 #then @i_Attr_Index = %v_Found_Index(1)
#else #block

   #if l_Ini_Read:vSTATUS == 0 #then #block

      @b_Found_as_Vector = TRUE
      #if upper_case(%t_Obj_Type) == "OPERATING_SYSTEM" #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3))
         #else @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Obj_Nr'")
      #if upper_case(%t_Obj_Type) == "EVENT" or upper_case(%t_Obj_Type) == "ALARM" #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3))

      #if l_Ini_Read:vSTATUS == 0 #then #block

         @v_Ini_Values = separate(l_Ini_Read:vVALUE, ",")
         #if length(l_Ini_Read:vVALUE) == 1 #then #return vector(evaluate(l_Ini_Read:vVALUE))

         #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == ",-" #then @v_Ini_Values = %v_Ini_Values(1 .. length(%v_Ini_Values) - 1)
         #else #block

            @v_Ini_Values_as_Text = separate(l_Ini_Read:vVALUE, ",")
            @v_Ini_Values_as_Real = vector()
            @i_1 = 1

            #loop (%i_1 < (length(%v_Ini_Values_as_Text) + 1))

               #if %v_Ini_Values_as_Text(%i_1) == "" #then @v_Ini_Values_as_Text(%i_1) = """#"""
               @v_Ini_Values_as_Real(length(%v_Ini_Values_as_Real) + 1) = evaluate(%v_Ini_Values_as_Text(%i_1))
               @i_1 = %i_1 + 1

            #loop_end

            @l_Return_Data = list(STATUS = 0)
            #loop_with i_2 = 1 .. length(%v_Attr_Mapping)
               @t_Attr_Mapping = %v_Attr_Mapping(%i_2)
               #if %i_2 <= length(%v_Ini_Values_as_Real) #then #set l_Return_Data:v't_Attr_Mapping' = %v_Ini_Values_as_Real(%i_2)
               #else #set l_Return_Data:v't_Attr_Mapping' = "#"
            #loop_end

            #return %l_Return_Data

         #block_end

         @v_All_Values = %v_Ini_Values

         #loop_with i_3 = 2 .. 10000 ; VJ/AZ 10.6.2004 (ID=8422)

            @v_Ini_Values = vector()

            ; VJ/AZ 10.6.2004 begin (ID=8422)
            ;#if upper_case(%t_Obj_Type) <> "OPERATING_SYSTEM" #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Obj_Nr'_'i'")
            ;   #else @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i'")
            #if upper_case(%t_Obj_Type) <> "OPERATING_SYSTEM" #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Obj_Nr'_'i_3'")
               #else @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_3'")
            ; VJ/AZ 10.6.2004 end

            #if l_Ini_Read:vSTATUS == 0 #then #block

               @v_Current_Values = separate(l_Ini_Read:vVALUE, ",")

               #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 1) == "," #then #block

                  @v_Current_Values = %v_Current_Values(1 .. length(%v_Current_Values) - 1)
                  @v_All_Values = append(%v_All_Values, %v_Current_Values)

               #block_end
               #else #block

                  @v_All_Values = append(%v_All_Values, %v_Current_Values)
                  @v_Int_Values_as_Real = vector()
                  @i_1 = 1                     

                  #loop (%i_1 < (length(%v_All_Values) + 1))

                     #if %v_All_Values(%i_1) == "" #then @v_All_Values(%i_1) = """#""" ; VJ/AZ 10.6.2004 (ID=8422)
                     @v_Int_Values_as_Real(length(%v_Int_Values_as_Real) + 1) = evaluate(%v_All_Values(%i_1))
                     @i_1 = %i_1 + 1

                  #loop_end

                  ; VJ/AZ 10.6.2004 begin (ID=8422)
                  @l_Return_Data = list(STATUS = 0)
                  #loop_with i_2 = 1 .. length(%v_Attr_Mapping)

                     @t_Attr_Mapping = %v_Attr_Mapping(%i_2)
                     #set l_Return_Data:v't_Attr_Mapping' = %v_Int_Values_as_Real(%i_2)

                  #loop_end
    
                  #return %l_Return_Data
                  ;#return %v_Int_Values_as_Real
                  ; VJ/AZ 10.6.2004 end

               #block_end

            #block_end
            #else #loop_exit

         #loop_end

      #block_end
      #else #block

         #if l_Ini_Read:vSTATUS == 558 or l_Ini_Read:vSTATUS == 559 #then #return list(STATUS = -1)
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = upper_case("SCM_SERVICE_GET_OBJECT_ATTRIBUTE_CONF_FILE_READING_ERROR ['l_Ini_Read:vSTATUS']"))

      #block_end

   #block_end

#block_end

#if not %b_Found_as_Vector #then #block

   #if upper_case(%t_Obj_Type) <> "OPERATING_SYSTEM" #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_" + dec(%i_Obj_Nr, 0))
      #else @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3))

   #if l_Ini_Read:vSTATUS == 0 #then #block

      @v_Ini_Values = separate(l_Ini_Read:vVALUE, ",")

      #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE), 1) <> "-" #then #block

         #if %b_Return_as_Text #then #return %v_Ini_Values(%i_Attr_Index)
         #else #block

            #if %i_Attr_Index == 0 #then #return list(STATUS = -1, DESCRIPTIVE_TEXT = "SCM_ATTRIBUTE_NOT_FOUND")
            @v_Ini_Values_as_Text = separate(l_Ini_Read:vVALUE, ",")
            @v_Ini_Values_as_Real = vector()
            @i_1 = 1                     

            #loop (%i_1 < (length(%v_Ini_Values_as_Text) + 1))

               #if %v_Ini_Values_as_Text(%i_1) == "" #then @v_Ini_Values_as_Text(%i_1) = """#"""
               @v_Ini_Values_as_Real(length(%v_Ini_Values_as_Real) + 1) = evaluate(%v_Ini_Values_as_Text(%i_1))
               @i_1 = %i_1 + 1

            #loop_end

            #if %v_Ini_Values(%i_Attr_Index) <> "" #then #return list(STATUS = 0, 't_Attr_Name' = %v_Ini_Values_as_Real(%i_Attr_Index))
               #else #return list(STATUS = -1)

         #block_end

      #block_end
      #else #block

         #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 1) == "," #then @v_Ini_Values = %v_Ini_Values(1 .. length(%v_Ini_Values) - 1)

         #loop_with i_3 = 2 .. 10000 ; VJ/AZ 10.6.2004 (ID=8422)

            ; VJ/AZ 10.6.2004 begin (ID=8422)
            ;#if upper_case(%t_Obj_Type) <> "OPERATING_SYSTEM" #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Obj_Nr'_" + dec(%i, 0))
            #if upper_case(%t_Obj_Type) <> "OPERATING_SYSTEM" #then @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Obj_Nr'_" + dec(%i_3, 0))
            ; VJ/AZ 10.6.2004 end
               #else @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Get_Pars(2), %v_Get_Pars(3))

            #if l_Ini_Read:vSTATUS == 0 #then #block

               @v_Ini_Values = append(%v_Ini_Values, separate(l_Ini_Read:vVALUE, ","))

               #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE), 1) == "-" #then #block

                  #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 1) == "," #then @v_Ini_Values = %v_Ini_Values(1 .. length(%v_Ini_Values) - 1)

               #block_end

            #block_end
            #else #loop_exit

         #loop_end

         #if length(%v_Ini_Values(%i_Attr_Index)) > 1 #then #block

            #if substr(%v_Ini_Values(%i_Attr_Index), length(%v_Ini_Values(%i_Attr_Index)) - 1, 1) == "+" #then #block

               @t_Start_Line = substr(%v_Ini_Values(%i_Attr_Index), 1, length(%v_Ini_Values(%i_Attr_Index)) - 3)
               @t_End_Line = substr(%v_Ini_Values(%i_Attr_Index + 1), 2, length(%v_Ini_Values(%i_Attr_Index + 1)) - 1)
               #return evaluate(%t_Start_Line + %t_End_Line)

            #block_end

         #block_end

         ; VJ/AZ 10.6.2004 begin (ID=8422)
         #if %b_Return_as_Text #then #return %v_Ini_Values(%i_Attr_Index)
         #else #block

            #if %i_Attr_Index == 0 #then #return list(STATUS = -1, DESCRIPTIVE_TEXT = "SCM_ATTRIBUTE_NOT_FOUND")
            @v_Ini_Values_as_Real = vector()
            @i_1 = 1                     

            #loop (%i_1 < (length(%v_Ini_Values) + 1))

               #if %v_Ini_Values(%i_1) == "" #then @v_Ini_Values(%i_1) = """#"""
               @v_Ini_Values_as_Real(length(%v_Ini_Values_as_Real) + 1) = evaluate(%v_Ini_Values(%i_1))
               @i_1 = %i_1 + 1

            #loop_end

            #if %v_Ini_Values(%i_Attr_Index) <> "" #then #return list(STATUS = 0, 't_Attr_Name' = %v_Ini_Values_as_Real(%i_Attr_Index))
            #else #return list(STATUS = -1)

         #block_end

         ;#return evaluate(%v_Ini_Values(%i_Attr_Index))
         ; VJ/AZ 10.6.2004 end

      #block_end

   #block_end

   #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_OBJECT_ATTRIBUTE_READ_OBJECT_ERROR ['l_Ini_Read:vSTATUS']")

#block_end

; Method: GetObjectDefinitions(t_Obj_Type, t_LN, i_IX)
; Version: 1.0
; Parameters: t_Obj_Type, type of object having attribute value, e.g. "ROUTINGS_STATION"
; Return data type: v_Data, definitions for requested object
; Description: Reads definitions from system self supervision configuration file, and returns
;              definitions related to requested data.
; -------------------------------------------------------------------------------------------

@t_Obj_Type = argument(1)
@t_LN = argument(2)
@i_IX = argument(3)

@l_General_Info = apl:bsv45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI

#case %t_Obj_Type

   #when "ROUTINGS_STATION" @v_Ini_Pars = vector("ROUTINGS", "Station_'t_LN'_'i_IX'", "STATIONS", "Station_")
   #when "ROUTINGS_NODE" @v_Ini_Pars = vector("ROUTINGS", "Node_'t_LN'_'i_IX'", "NODES", "Node_")
   #when "ROUTINGS_NODE_LINK" @v_Ini_Pars = vector("ROUTINGS", "Node_Link_'t_LN'_'i_IX'", "", "Node_Link_")
   #when "ROUTINGS_PRINTER" @v_Ini_Pars = vector("ROUTINGS", "Printer_'t_LN'_'i_IX'", "PRINTERS", "Printer_")
   #when "ROUTINGS_SLCM" @v_Ini_Pars = vector("ROUTINGS", "SLCM_'t_LN'_'i_IX'", "SLCM", "SLCM_")
   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_OBJECT_DEFINITIONS_TYPE_PARAMETER_NOT_FOUND_ERROR")

#case_end

@l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Ini_Pars(1), %v_Ini_Pars(2))

#if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

   @v_Obj_Numbers = separate(l_Ini_Read:vVALUE, ",")
   @i_Obj_Nr = %v_Obj_Numbers(1)
   #if %t_Obj_Type == "ROUTINGS_NODE_LINK" #then #block

      @i_Parent_Nr = %v_Obj_Numbers(2)
      @v_Ini_Pars(3) = "NODE_'i_Parent_Nr'_LINKS"

   #block_end
   @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Ini_Pars(3), %v_Ini_Pars(4) + %i_Obj_Nr)

   #if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

      @v_Ini_Items = separate(l_Ini_Read:vVALUE, ",")

      #case %t_Obj_Type

         #when "ROUTINGS_STATION" #block

            #if %v_Ini_Items(1) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_ST_ATTRIBUTE_ERROR")
               #else_if %v_Ini_Items(2) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_LI_ATTRIBUTE_ERROR")
                  #else_if %v_Ini_Items(3) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_ND_ATTRIBUTE_ERROR")
                     #else_if %v_Ini_Items(4) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_INDICATION_ATTRIBUTE_ERROR")
                        #return list(STATUS = 0, NUMBER = evaluate(%i_Obj_Nr), ST = evaluate(%v_Ini_Items(1)), LI = evaluate(%v_Ini_Items(2)), ND = evaluate(%v_Ini_Items(3)), INDICATION = evaluate(%v_Ini_Items(4)))

         #block_end
         #when "ROUTINGS_NODE" #block

            #if %v_Ini_Items(1) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_TYPE_ATTRIBUTE_ERROR")
               #else_if %v_Ini_Items(1) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_INDICATION_ATTRIBUTE_ERROR")
                  #if evaluate(%v_Obj_Numbers(3)) == "PRIMARY" #then @i_Node_Index = 2
                     #else @i_Node_Index = 3
                  #return list(STATUS = 0, NUMBER = evaluate(%i_Obj_Nr), TYPE = evaluate(%v_Ini_Items(1)), INDICATION = evaluate(%v_Ini_Items(%i_Node_Index)))

         #block_end
         #when "ROUTINGS_NODE_LINK" #block

            #if %v_Ini_Items(1) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_PO_ATTRIBUTE_ERROR")
               #else_if %v_Ini_Items(2) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_INDICATION_ATTRIBUTE_ERROR")
                  #else #return list(STATUS = 0, NUMBER = evaluate(%i_Obj_Nr), ND = evaluate(%i_Parent_Nr), PO = evaluate(%v_Ini_Items(1)), INDICATION = evaluate(%v_Ini_Items(2)))

         #block_end
         #when "ROUTINGS_PRINTER" #block

            #if %v_Ini_Items(3) == "" #then @i_LI = 0
               #else @i_LI = evaluate(%v_Ini_Items(3))

            #if %v_Ini_Items(1) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_DC_ATTRIBUTE_ERROR")
               #else_if %v_Ini_Items(2) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_DT_ATTRIBUTE_ERROR")
                  #else_if %v_Ini_Items(4) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_ND_ATTRIBUTE_ERROR")
                     #else_if %v_Ini_Items(5) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_INDICATION_ATTRIBUTE_ERROR")
                        #return list(STATUS = 0, NUMBER = evaluate(%i_Obj_Nr), DC = evaluate(%v_Ini_Items(1)), DT = evaluate(%v_Ini_Items(2)), LI = %i_LI, ND = evaluate(%v_Ini_Items(4)), INDICATION = evaluate(%v_Ini_Items(5)))

         #block_end
         #when "ROUTINGS_SLCM" #block

            @v_Ini_Pars(3) = "STATIONS"
            @v_Ini_Pars(4) = "Station_"
            @l_Ini_Read = read_parameter(%t_Conf_Data_File, %v_Ini_Pars(3), %v_Ini_Pars(4) + %i_Obj_Nr)

            #if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

               @v_Ini_Stas = separate(l_Ini_Read:vVALUE, ",")
               #if %v_Ini_Stas(3) == "" #then @t_CX = ""
                  #else @t_CX = evaluate(%v_Obj_Numbers(3))
               #if evaluate(%v_Obj_Numbers(3)) == "PRIMARY" #then @i_SLCM_Index = 1
                  #else @i_SLCM_Index = 2

               #if %v_Ini_Stas(2) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_LI_ATTRIBUTE_ERROR")
                  #else_if %v_Ini_Stas(3) == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_GET_OBJECT_DEFINITIONS_READ_ND_ATTRIBUTE_ERROR")
                     #return list(STATUS = 0, NUMBER = evaluate(%i_Obj_Nr), INDICATION = evaluate(%v_Ini_Items(%i_SLCM_Index)), CX = %t_CX, LI = evaluate(%v_Ini_Stas(2)), ND = evaluate(%v_Ini_Stas(3)))

            #block_end

         #block_end

      #case_end

   #block_end

#block_end
#return list(STATUS = 1, DESCRIPTIVE_TEXT = upper_case("SCM_SERVICE_GET_OBJECT_DEFINITIONS_CONF_FILE_READING_ERROR ['l_Ini_Read:vSTATUS']"))

; Method: GetFilterAttributes(t_Obj_Type, i_OV)
; Version: 1.0
; Parameters: t_Obj_Type, type of object having attribute value, e.g. "BASE_SYSTEM_LINK"
; Return data type: v_Object_Numbers, objects numbers for specified type.
; Description: Reads object numbers from the configuration file and returns in specified
;              format.
; ----------------------------------------------------------------------------------------------

@t_Obj_Type = argument(1)
@i_OV = argument(2)

#if argument_count == 3 #then @t_Event = argument(3)

@l_General_Info = APL:BSV45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_FILTER_INI

#if %t_Obj_Type == "SYS_MSG_SLCM" #then #block

   @l_Ini_Read = read_parameter(%t_Conf_Data_File, %t_Obj_Type, "Faulty_Bit_Numbers")

   #if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

      #if locate(l_Ini_Read:vVALUE, ascii(9)) > 0 #then #set l_Ini_Read:vVALUE = substr(l_Ini_Read:vVALUE, 1, locate(l_Ini_Read:vVALUE, ascii(9)) - 1)
         #else_if locate(l_Ini_Read:vVALUE, " ") > 0 #then #set l_Ini_Read:vVALUE = substr(l_Ini_Read:vVALUE, 1, locate(l_Ini_Read:vVALUE, " ") - 1)

      @i_Status = status
      #error ignore
         @v_Bit_Numbers = dec_scan(separate(l_Ini_Read:vVALUE, ","))
      #error stop
      @i_Status = status
      #if %i_Status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FILTER_ATTRIBUTES_FILTER_FILE_READING_ERROR ['i_Status']")
      @v_Status_Sum = sum(get_status(%v_Bit_Numbers))
      #if %v_Status_Sum(1) > 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FILTER_ATTRIBUTES_FILTER_FILE_READING_ERROR")

      @l_Ini_Read = read_parameter(%t_Conf_Data_File, %t_Obj_Type, "Faulty_Bit_Values")

      #if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

         #if locate(l_Ini_Read:vVALUE, ascii(9)) > 0 #then #set l_Ini_Read:vVALUE = substr(l_Ini_Read:vVALUE, 1, locate(l_Ini_Read:vVALUE, ascii(9)) - 1)
            #else_if locate(l_Ini_Read:vVALUE, " ") > 0 #then #set l_Ini_Read:vVALUE = substr(l_Ini_Read:vVALUE, 1, locate(l_Ini_Read:vVALUE, " ") - 1)

         @t_State = "NORMAL"
         @i_Status = status
         #error ignore
            @v_Bit_Values = dec_scan(separate(l_Ini_Read:vVALUE, ","))
         #error stop
         @i_Status = status
         #if %i_Status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FILTER_ATTRIBUTES_FILTER_FILE_READING_ERROR ['i_Status']")
         @v_Status_Sum = sum(get_status(%v_Bit_Values))
         #if %v_Status_Sum(1) > 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FILTER_ATTRIBUTES_FILTER_FILE_READING_ERROR")

         #if bit(%i_OV, %v_Bit_Numbers(1)) == %v_Bit_Values(1) or bit(%i_OV, %v_Bit_Numbers(2)) == %v_Bit_Values(2) or bit(%i_OV,%v_Bit_Numbers(3)) == %v_Bit_Values(3) or bit(%i_OV,%v_Bit_Numbers(4)) == %v_Bit_Values(4) #then @t_State = "FAULTY"
         @l_Ini_Read = read_parameter(%t_Conf_Data_File, %t_Obj_Type, "Status_'t_State'")

         #if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

            #if locate(l_Ini_Read:vVALUE, " ") > 0 #then #set l_Ini_Read:vVALUE = substr(l_Ini_Read:vVALUE, 1, locate(l_Ini_Read:vVALUE, " ") - 1)
            @v_Ini_Items = separate(l_Ini_Read:vVALUE, ",")
            #return list(STATUS = 0, STATE = %t_State, LOG = evaluate(%v_Ini_Items(1)), EVENT = evaluate(%v_Ini_Items(2)), ALARM = evaluate(%v_Ini_Items(3)))

         #block_end

      #block_end

   #block_end

#block_end
#else #block

   #case %t_Obj_Type

      #when "APL_EVENT", "SYS_EVENT", "OS_EVENT" @l_Ini_Read = read_parameter(%t_Conf_Data_File, %t_Obj_Type, "Status_'i_OV'_'t_Event'")
      #otherwise @l_Ini_Read = read_parameter(%t_Conf_Data_File, %t_Obj_Type, "Status_'i_OV'")

   #case_end

   #if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

      #if locate(l_Ini_Read:vVALUE, " ") > 0 #then #set l_Ini_Read:vVALUE = substr(l_Ini_Read:vVALUE, 1, locate(l_Ini_Read:vVALUE, " ") - 1)
      @v_Ini_Items = separate(l_Ini_Read:vVALUE, ",")
      #return list(STATUS = 0, LOG = evaluate(%v_Ini_Items(1)), EVENT = evaluate(%v_Ini_Items(2)), ALARM = evaluate(%v_Ini_Items(3)))

   #block_end

   #if l_Ini_Read:vSTATUS == 558 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = upper_case("SCM_SECTION_'t_Obj_Type'_DOES_NOT_EXIST [558]"))
   #else_if l_Ini_Read:vSTATUS == 559 #then #return list(STATUS = -1)
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FILTER_ATTRIBUTES_FILTER_FILE_READING_ERROR ['l_Ini_Read:vSTATUS']")

#block_end
#return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FILTER_ATTRIBUTES_USAGE_ERROR")

; Method: GetEvents(t_Event_Type, t_Object_Type, i_Sta_Nr, i_OV, [x_Information])
; Version: 1.0
; Parameters: t_Event_Type, type of event in request, e.g. "EVENT", "ALARM"
;             t_Object_Type, type of object in request, e.g. "STATION", "PRINTER", "SLCM"
;             i_Sta_Nr, 
;             i_OV,
;             x_Information,
; Return data type: l_Data, STATUS information with EVENT or ALARM attribute with indication point
; Description: Reads event or alarm definition from the event configuration file and returns data
;              in specified format.
; ------------------------------------------------------------------------------------------------

@t_Event_Type = argument(1)
@t_Object_Type = argument(2)
@i_Sta_Nr = argument(3)
@l_Event_Data = argument(4)
@x_Information = ""
#if argument_count > 4 #then @x_Information = argument(5)
#if data_type(%x_Information) == "TEXT" #then #if %x_Information <> "" #then @x_Information = "_" + %x_Information
@x_Additional = ""
#if data_type(%x_Additional) == "TEXT" #then #if %x_Additional <> "" #then @x_Additional = "_" + %x_Additional

@l_General_Info = APL:BSV45
#if data_type(l_Event_Data:vEVENT) == "TEXT" #then #set l_Event_Data:vEVENT = replace(l_Event_Data:vEVENT, " ", "_")

#case upper_case(%t_Object_Type)

   #when "APPLICATION" @l_Ini_Read = read_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Application_'i_Sta_Nr'_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT''x_Information'")
   #when "OPERATING_SYSTEM" @l_Ini_Read = read_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Operating_System_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT'")
   #when "BASE_SYSTEM" @l_Ini_Read = read_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Node_'i_Sta_Nr'_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT''x_Information'")
   #when "NODE_LINK" @l_Ini_Read = read_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Node_'i_Sta_Nr'_Link_'x_Information'_'l_Event_Data:vEVENT''x_Additional'")
   #otherwise #block

      #if length(select(list_attr(%l_Event_Data), "==""SOURCE""")) > 0 #then @l_Ini_Read = read_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "'t_Object_Type'_'i_Sta_Nr'_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT'")
         #else @l_Ini_Read = read_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "'t_Object_Type'_'i_Sta_Nr'_'l_Event_Data:vEVENT'")

   #block_end

#case_end

#if l_Ini_Read:vSTATUS == 0 #then #if l_Ini_Read:vVALUE <> "" #then #block

   @l_Solve_DB = do(apl:bsv40, "SSS", "GetLogicalNameAndIndex", evaluate(l_Ini_Read:vVALUE))

   #if l_Solve_DB:vSTATUS == 0 #then #block

      @t_Found_LN_DB = l_Solve_DB:vLN
      @i_Found_IX_DB = l_Solve_DB:vIX
      @i_Found_from_DB = fetch(0, "P", %t_Found_LN_DB, %i_Found_IX_DB)

      #if %i_Found_from_DB.IU >= 0 #then #return list(STATUS = 0, 't_Event_Type' = evaluate(l_Ini_Read:vVALUE))
      #else #block

         #case upper_case(%t_Object_Type)

            #when "APPLICATION" @l_Ini_Delete = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Application_'i_Sta_Nr'_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT''x_Information'")
            #when "OPERATING_SYSTEM" @l_Ini_Delete = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Operating_System_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT'")
            #when "BASE_SYSTEM" @l_Ini_Delete = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Node_'i_Sta_Nr'_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT''x_Information'")
            #when "NODE_LINK" @l_Ini_Delete = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "Node_'i_Sta_Nr'_Link_'x_Information'_'l_Event_Data:vEVENT''x_Additional'")
            #otherwise #block

               #if length(select(list_attr(%l_Event_Data), "==""SOURCE""")) > 0 #then @l_Ini_Delete = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "'t_Object_Type'_'i_Sta_Nr'_'l_Event_Data:vSOURCE'_'l_Event_Data:vEVENT'")
                  #else @l_Ini_Delete = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, %t_Event_Type + "S", "'t_Object_Type'_'i_Sta_Nr'_'l_Event_Data:vEVENT'")

            #block_end

         #case_end

         #return list(STATUS = 1, DESCRIPTIVE_TEXT = upper_case("SCM_'t_Event_Type'_POINT_DOES_NOT_EXIST"))
      #block_end

   #block_end
#block_end
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = upper_case("SCM_'t_Event_Type'_POINT_DOES_NOT_EXIST"))
#return list(STATUS = -1)

; Method: CreateProcessObject(t_Object_Type, i_Supervision_Type, i_Object_Number, l_Attributes_and_Values)
; Version: 1.0
; --------------------------------------------------------------------------------------------------

@t_Object_Type = argument(1)
@t_Supervision_Type = argument(2) ; Indication, Routing, Event, Alarm
@i_Object_Number = argument(3)
@x_Attributes_and_Values = list()
#if argument_count > 3 #then @x_Attributes_and_Values = argument(4)
@t_Recursive_Operation = ""
#if argument_count > 4 #then #if data_type(argument(5)) <> "NONE" #then @t_Recursive_Operation = argument(5)
@l_Additional_Create_Attributes = list()
#if argument_count > 5 #then @l_Additional_Create_Attributes = argument(6)

#if %t_Object_Type == "OPERATING_SYSTEM" #then @i_Object_Number = SYS:BND

@b_Modify_Existing = FALSE
@b_Is_Binary_Input = FALSE
@b_Is_Presentation_Object = FALSE
@t_Object_Number = substr("0000", length(dec(%i_Object_Number, 0)) + 1, 0) + dec(%i_Object_Number, 0)
@t_Bay_Text = ""
@t_Text_Item = ""
@t_Suffix = "PRIMARY"
#if length(select(list_attr(%l_Additional_Create_Attributes), "==""CX""")) > 0 #then @t_CX = l_Additional_Create_Attributes:vCX
   #else @t_CX = ""
#if length(select(list_attr(%l_Additional_Create_Attributes), "==""SE""")) > 0 #then @i_SE = l_Additional_Create_Attributes:vSE
   #else @i_SE = 0
#if length(select(list_attr(%l_Additional_Create_Attributes), "==""BINARY_MODEL""")) > 0 #then @b_Binary_Model = l_Additional_Create_Attributes:vBINARY_MODEL
   #else @b_Binary_Model = FALSE

#case %t_Object_Type

   #when "STATION", "SLCM" #block

      @t_ST_Value = ""
      @t_CX_Value = ""

      #if %t_Supervision_Type == "INDICATION" or %t_Supervision_Type == "ROUTING" #then #block

         @l_Status_SCM = do (apl:bsv40, "SSS", "GetLanguageText", "Status_of_'t_Object_Type'")
         #if %t_Recursive_Operation == "REDUNDANT" #then @t_Suffix = "SECONDARY"

      #block_end
      #else #block

         #if data_type(x_Attributes_and_Values:vEVENT) == "INTEGER" #then #block

            @x_Attributes_and_Values = x_Attributes_and_Values:vEVENT
            @l_Status_SCM = do (APL:BSV40, "SSS", "GetStatusMessage", %x_Attributes_and_Values, TRUE)
            #if l_Status_SCM:vSTATUS == 0 #then #set l_Status_SCM:vDATA = l_Status_SCM:vDATA + " [" + dec(%x_Attributes_and_Values, 0) + "]"

         #block_end
         #else #block

            #if data_type(x_Attributes_and_Values:vEVENT) == "TEXT" #then #set x_Attributes_and_Values:vEVENT = replace(x_Attributes_and_Values:vEVENT, " ", "_")
            #if length(select(list_attr(%x_Attributes_and_Values), "==""SOURCE""")) > 0 #then @x_Attributes_and_Values = x_Attributes_and_Values:vSOURCE + "_" + x_Attributes_and_Values:vEVENT
               #else @x_Attributes_and_Values = x_Attributes_and_Values:vEVENT

            @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "'t_Object_Type'_'x_Attributes_and_Values'")

         #block_end
         
      #block_end

      #if l_Status_SCM:vSTATUS == 0 #then @t_Text_Item = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_TEXT_ITEM_DOES_NOT_EXIST")

      @l_Status_SCM = do(apl:bsv40, "SSS", "GetObjectAttributes", "STATION", %i_Object_Number)
      #if %t_Supervision_Type == "INDICATION" #then @i_Index_Value = 10
         #else_if %t_Supervision_Type == "ROUTING" and not %b_Binary_Model #then @i_Index_Value = 110
            #else_if %t_Supervision_Type == "ROUTING" and %b_Binary_Model #then @i_Index_Value = 210

      #if %t_Supervision_Type == "INDICATION" or %t_Supervision_Type == "ROUTING" #then #block

         #if l_Status_SCM:vSTATUS == 0 #then #block

            @t_ST_Value = l_Status_SCM:vST
            @t_CX_Value = l_Status_SCM:vCX
            @i_ND_Value = l_Status_SCM:vND
            @i_LI_Value = l_Status_SCM:vLI

            #case %t_ST_Value
               #when "RTU" #if %t_Recursive_Operation == "REDUNDANT" and not %b_Binary_Model #then @i_Index_Value = %i_Index_Value + 1
               #when "LMK" #block
                  #if %t_Object_Type == "SLCM" #then #block
                     #if locate(%t_CX_Value, "SLCM") > 0 #then #block
                        #if %t_Recursive_Operation == "" #then #block
                           @i_Index_Value = %i_Index_Value + 1
                           @t_Suffix = "PRIMARY"
                        #block_end
                        #else_if %t_Recursive_Operation == "REDUNDANT" #then #block
                           @i_Index_Value = %i_Index_Value + 2
                           @t_Suffix = "SECONDARY"
                        #block_end
                     #block_end
                     #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_SLCM_NOT_IN_CX_ATTRIBUTE")
                  #block_end
               #block_end
            #case_end

         #block_end
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_READ_STATION_TYPE_ERROR")

      #block_end

      #case %t_Supervision_Type

         #when "INDICATION" @v_Object_Info = ("SYS_S't_Object_Number'I", %i_Index_Value, 9, "9", "BSWSTAISTA", "", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)

         #when "ROUTING" #block

            #if %t_Object_Type == "STATION" #then #block
               #if not %b_Binary_Model #then @v_Object_Info = ("SYS_S't_Object_Number'I", %i_Index_Value, 9, "9", "BSWSTAXSTA", "SYS_STAMR", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)
                  #else @v_Object_Info = ("SYS_S't_Object_Number'I", %i_Index_Value, 3, "3", "BSWSTAXSTA", "", "'t_Text_Item''i_Object_Number'", 0, 0, 0, 0, 0, 2)
            #block_end
            #else @v_Object_Info = ("SYS_S't_Object_Number'I", %i_Index_Value, 9, "9", "BSWSTAXSTA", "SYS_STAMR", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)

            #if %t_Object_Type == "STATION" #then #block

               @i_Status = status

          #if %t_ST_Value <> "RTU" #then #block

                  #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) > 0 #then @i_MI = l_Additional_Create_Attributes:vMI
                  #else #block
   
                     #error ignore
                        @i_MI = STA'i_Object_Number':SMI
                     #error stop
                     @i_Status = status

                     #if %i_Status <> 0 #then #block
                        @i_MI = 1000 + %i_Object_Number
                        @i_Status = 0
                     #block_end
   
                  #block_end

               #block_end
          #else #block

                  #if %t_Recursive_Operation == "" #then @b_Low_Index = TRUE
                  #else @b_Low_Index = (%b_Binary_Model == TRUE)

                  #if %b_Low_Index #then #block

                     #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) > 0 #then @i_MI = l_Additional_Create_Attributes:vMI(1)
                     #else #block
   
                        #error ignore
                           @i_MI = STA'i_Object_Number':SMI1
                        #error stop
                        @i_Status = status

                        #if %i_Status <> 0 #then #block
                           @i_MI = 8000 + %i_Object_Number
                           @i_Status = 0
                        #block_end
  
                     #block_end

                  #block_end
                  #else #block

                     #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) > 0 #then @i_MI = l_Additional_Create_Attributes:vMI(2)
                     #else #block
   
                        #error ignore
                           @i_MI = STA'i_Object_Number':SMI2
                        #error stop
                        @i_Status = status

                        #if %i_Status <> 0 #then #block
                           @i_MI = 8500 + %i_Object_Number
                           @i_Status = 0
                        #block_end
   
                     #block_end
               

                  #block_end

               #block_end

               #if %i_Status == 0 #then @v_Object_Info(9) = %i_MI
               #else_if %i_MI == 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_READ_STATION_MI_ATTRIBUTE_ERROR ['i_Status']")

            #block_end
            #else_if upper_case(%t_Object_Type) == "SLCM" #then #block

               @v_Object_Info(3) = 6
               @v_Object_Info(4) = "X9"
               @v_Object_Info(6) = "SYS_SLCMR"

            #block_end

         #block_end

         #when "EVENT" @v_Object_Info = ("SYS_S't_Object_Number'E", 1, 3, "3", "BSWSTAXSTA", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)
         #when "ALARM" @v_Object_Info = ("SYS_S't_Object_Number'A", 1, 3, "3", "BSWSTAXSTA", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)

      #case_end

      #if %t_Object_Type == "SLCM" #then @v_Object_Info(5) = substr(%v_Object_Info(5), 1, 7) + "LCM"
      @l_Status_SCM = do (apl:bsv40, "SSS", "GetLanguageText", "Prefix_of_'t_Object_Type'")
      #if l_Status_SCM:vSTATUS == 0 #then @t_Bay_Text = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_TEXT_ITEM_GENERATION_ERROR")

   #block_end

   #when "PRINTER" #block

      #if %t_Supervision_Type == "INDICATION" or %t_Supervision_Type == "ROUTING" #then #block

         @l_Status_SCM = do (apl:bsv40, "SSS", "GetLanguageText", "Status_of_Printer")
         #if %t_Recursive_Operation == "REDUNDANT" #then @t_Suffix = "SECONDARY"

      #block_end
      #else #block

         @l_Printer_Type = do(apl:bsv40, "SSS", "GetObjectAttribute", "PRINTER", %i_Object_Number, "DC")
         #if l_Printer_Type:vSTATUS == 0 #then #block

            #if l_Printer_Type:vDC == "NET" #then #block

               #if data_type(x_Attributes_and_Values:vEVENT) == "TEXT" #then #set x_Attributes_and_Values:vEVENT = replace(x_Attributes_and_Values:vEVENT, " ", "_")
               #if length(select(list_attr(%x_Attributes_and_Values), "==""SOURCE""")) > 0 #then @x_Attributes_and_Values = x_Attributes_and_Values:vSOURCE + "_" + x_Attributes_and_Values:vEVENT
                  #else @x_Attributes_and_Values = x_Attributes_and_Values:vEVENT

               #if data_type(%x_Attributes_and_Values) == "INTEGER" #then #block
               
                  @l_Status_SCM = do (APL:BSV40, "SSS", "GetStatusMessage", %x_Attributes_and_Values, TRUE)
                  #if l_Status_SCM:vSTATUS == 0 #then #set l_Status_SCM:vDATA = l_Status_SCM:vDATA + " [" + dec(%x_Attributes_and_Values, 0) + "]"

               #block_end
               #else @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "'t_Object_Type'_'x_Attributes_and_Values'")

            #block_end
            #else #block

               #if data_type(x_Attributes_and_Values:vEVENT) == "TEXT" #then #set x_Attributes_and_Values:vEVENT = replace(x_Attributes_and_Values:vEVENT, " ", "_")
               #if length(select(list_attr(%x_Attributes_and_Values), "==""SOURCE""")) > 0 #then @x_Attributes_and_Values = x_Attributes_and_Values:vSOURCE + "_" + x_Attributes_and_Values:vEVENT
                  #else @x_Attributes_and_Values = x_Attributes_and_Values:vEVENT

               @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "'t_Object_Type'_'x_Attributes_and_Values'")

            #block_end

         #block_end

      #block_end

      #if l_Status_SCM:vSTATUS == 0 #then @t_Text_Item = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_TEXT_ITEM_GENERATION_ERROR")

      #case %t_Supervision_Type

         #when "INDICATION" @v_Object_Info = ("SYS_P't_Object_Number'I", 10, 9, "9", "BSWPRIIPRI", "", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)
         #when "ROUTING" #block

            @v_Object_Info = ("SYS_P't_Object_Number'I", 110, 9, "9", "BSWPRIXPRI", "SYS_PRIMR", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)
            @i_Status = status

            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) > 0 #then @i_MI = l_Additional_Create_Attributes:vMI
            #else #block

               #error ignore
                  @i_MI = PRI'i_Object_Number':SMI
               #error stop
               @i_Status = status

            #block_end

            #if %i_Status == 0 #then @v_Object_Info(9) = %i_MI
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_READ_PRINTER_MI_ATTRIBUTE_ERROR ['i_Status']")

         #block_end

         #when "EVENT" @v_Object_Info = ("SYS_P't_Object_Number'E", 1, 3, "3", "BSWPRIXPRI", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)
         #when "ALARM" @v_Object_Info = ("SYS_P't_Object_Number'A", 1, 3, "3", "BSWPRIXPRI", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)

      #case_end

      @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Prefix_of_Printer")
      #if l_Status_SCM:vSTATUS == 0 #then @t_Bay_Text = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_TEXT_ITEM_DOES_NOT_EXIST")

   #block_end

   #when "NODE" #block

      #if %t_Supervision_Type == "INDICATION" or %t_Supervision_Type == "ROUTING" #then #block

         #if %t_Recursive_Operation == "REDUNDANT" #then @t_Suffix = "SECONDARY"
         @l_Node_Type = do(apl:bsv40, "SSS", "GetObjectAttribute", "NODE", %i_Object_Number, "TYPE")
         #if l_Node_Type:vSTATUS == 0 #then #block

            #if l_Node_Type:vTYPE == "BASE SYSTEM" #then @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Status_of_Base_System")
            #else #block

               #if %t_Recursive_Operation == "REDUNDANT" and not %b_Binary_Model #then @l_Status_SCM = do (apl:bsv40, "SSS", "GetLanguageText", "Status_of_NET_Redundant")
                  #else @l_Status_SCM = do (apl:bsv40, "SSS", "GetLanguageText", "Status_of_NET")

            #block_end

         #block_end
         #else #return %l_Node_Type

      #block_end
      #else #block

         @l_Node_Type = do(apl:bsv40, "SSS", "GetObjectAttribute", "NODE", %i_Object_Number, "TYPE")
         #if l_Node_Type:vSTATUS == 0 #then #block

            #if data_type(x_Attributes_and_Values:vEVENT) == "INTEGER" #then #block

               @x_Attributes_and_Values = x_Attributes_and_Values:vEVENT
               @l_Status_SCM = do (APL:BSV40, "SSS", "GetStatusMessage", %x_Attributes_and_Values, TRUE)
               #if l_Status_SCM:vSTATUS == 0 #then #set l_Status_SCM:vDATA = l_Status_SCM:vDATA + " [" + dec(%x_Attributes_and_Values, 0) + "]"

            #block_end
            #else #block

               #set x_Attributes_and_Values:vEVENT = replace(x_Attributes_and_Values:vEVENT, " ", "_")
               #if length(select(list_attr(%x_Attributes_and_Values), "==""SOURCE""")) > 0 #then @x_Attributes_and_Values = x_Attributes_and_Values:vSOURCE + "_" + x_Attributes_and_Values:vEVENT
                  #else @x_Attributes_and_Values = x_Attributes_and_Values:vEVENT

               @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "'t_Object_Type'_'x_Attributes_and_Values'")

            #block_end

         #block_end
         #else #return %l_Node_Type

      #block_end

      #if l_Status_SCM:vSTATUS == 0 #then @t_Text_Item = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_TEXT_ITEM_GENERATION_ERROR")

      #case %t_Supervision_Type

         #when "INDICATION" #block

            #if %t_Recursive_Operation == "" or %t_Recursive_Operation == "PRIMARY" #then @i_OS_Index = 10
            #else_if %t_Recursive_Operation == "REDUNDANT" #then @i_OS_Index = 11

            #if l_Node_Type:vTYPE == "BASE SYSTEM" #then #block
               @v_Object_Info = ("SYS_N't_Object_Number'I", %i_OS_Index, 3, "3", "BSWSYSISYS", "", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)
               @b_Is_Binary_Input = TRUE ; ID 13294
            #block_end
            #else @v_Object_Info = ("SYS_N't_Object_Number'I", %i_OS_Index, 9, "9", "BSWNETINET", "", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)

         #block_end
         #when "ROUTING" #block

            #if %t_Recursive_Operation == "" or %t_Recursive_Operation == "PRIMARY" #then @i_OS_Index = 110
            #else_if %t_Recursive_Operation == "REDUNDANT" and not %b_Binary_Model #then @i_OS_Index = 111
            #else_if %t_Recursive_Operation == "REDUNDANT" and %b_Binary_Model #then @i_OS_Index = 210

            #if not %b_Binary_Model #then @v_Object_Info = ("SYS_N't_Object_Number'I", %i_OS_Index, 9, "9", "BSWNETXNET", "SYS_NETMR", "'t_Text_Item''i_Object_Number'", 0, 0, 16, 0, 0, 2)
               #else @v_Object_Info = ("SYS_N't_Object_Number'I", %i_OS_Index, 3, "3", "BSWNETXNET", "", "'t_Text_Item''i_Object_Number'", 0, 0, 0, 0, 0, 2)

            @i_Status = status

            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) > 0 #then @i_MI = l_Additional_Create_Attributes:vMI
            #else #block

               #if %t_Recursive_Operation == "REDUNDANT" and not %b_Binary_Model #then @i_Dec_MI = 100
                  #else @i_Dec_MI = 0

               #error ignore
                  @i_MI = NOD'i_Object_Number':SMI - %i_Dec_MI
               #error stop
               @i_Status = status

            #block_end

            #if %i_Status == 0 #then @v_Object_Info(9) = %i_MI
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_NODE_MI_ATTRIBUTE_READ_ERROR ['i_Status']")

         #block_end
         #when "EVENT" @v_Object_Info = ("SYS_N't_Object_Number'E", 1, 3, "3", "BSWNETXNET", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)
         #when "ALARM" @v_Object_Info = ("SYS_N't_Object_Number'A", 1, 3, "3", "BSWNETXNET", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)

      #case_end

      #if l_Node_Type:vTYPE == "BASE SYSTEM" #then @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Prefix_of_Base_System")
         #else @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Prefix_of_Net")
      #if l_Status_SCM:vSTATUS == 0 #then @t_Bay_Text = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_TEXT_ITEM_DOES_NOT_EXIST")

   #block_end

   #when "NODE_LINK" #block

      #if %t_Supervision_Type == "INDICATION" or %t_Supervision_Type == "ROUTING" #then #block

         @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Status_of_NET_Line")
         @l_Status_SCM_2 = do (APL:BSV40, "SSS", "GetLanguageText", "Status_of_Node")
         @t_Last_Part = ""
         #if l_Status_SCM_2:vSTATUS == 0 #then @t_Last_Part = " (" + l_Status_SCM_2:vDATA + "'i_Object_Number')" 
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_TEXT_ITEM_GENERATION_ERROR")

      #block_end
      #else #block

         @x_Attributes_and_Values = x_Attributes_and_Values:vEVENT
         @l_Status_SCM = do (APL:BSV40, "SSS", "GetStatusMessage", %x_Attributes_and_Values, TRUE)
         #if l_Status_SCM:vSTATUS == 0 #then #set l_Status_SCM:vDATA = l_Status_SCM:vDATA + " [" + dec(%x_Attributes_and_Values, 0) + "]"

      #block_end

      #if l_Status_SCM:vSTATUS == 0 #then @t_Text_Item = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_TEXT_ITEM_GENERATION_ERROR")

      #case %t_Supervision_Type

         #when "INDICATION" #block

            @i_OS_Index = 20 + %x_Attributes_and_Values
            @v_Object_Info = ("SYS_N't_Object_Number'I", %i_OS_Index, 9, "9", "BSWNETILIN", "", "'t_Text_Item''x_Attributes_and_Values''t_Last_Part'", 0, 0, 16, 0, 0, 2)

         #block_end
         #when "ROUTING" #block

            #if not %b_Binary_Model #then @i_OS_Index = 120 + %x_Attributes_and_Values
            #else #block

               @i_OS_Index = 220 + %x_Attributes_and_Values
               @t_Suffix = "SECONDARY"

            #block_end

            #if not %b_Binary_Model #then @v_Object_Info = ("SYS_N't_Object_Number'I", %i_OS_Index, 9, "9", "BSWNETXLIN", "SYS_NETLMR", "'t_Text_Item''x_Attributes_and_Values''t_Last_Part'", 0, 0, 16, 0, 0, 2)
               #else @v_Object_Info = ("SYS_N't_Object_Number'I", %i_OS_Index, 3, "3", "BSWNETXLIN", "", "'t_Text_Item''x_Attributes_and_Values''t_Last_Part'", 0, 0, 0, 0, 0, 2)

            @i_Status = status

            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) > 0 #then @i_MI = l_Additional_Create_Attributes:vMI
            #else #block

               #error ignore
                  @i_MI = NOD'i_Object_Number':SMI'x_Attributes_and_Values'
               #error stop
               @i_Status = status

            #block_end

            #if %i_Status == 0 #then @v_Object_Info(9) = %i_MI
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_NODE_LINK_MI_ATTRIBUTE_READ_ERROR ['i_Status']")

         #block_end
         #when "EVENT" @v_Object_Info = ("SYS_N't_Object_Number'E", 1, 3, "3", "BSWNETXNET", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)
         #when "ALARM" @v_Object_Info = ("SYS_N't_Object_Number'A", 1, 3, "3", "BSWNETXNET", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)

      #case_end

      @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Prefix_of_Net_Line")
      #if l_Status_SCM:vSTATUS == 0 #then @t_Bay_Text = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_TEXT_ITEM_DOES_NOT_EXIST")

   #block_end

   #when "OPERATING_SYSTEM" #block

      @t_Part_Operation = %t_Recursive_Operation
      #if %t_Part_Operation == "" #then @t_Part_Operation = "SYS"

      #if %t_Supervision_Type == "INDICATION" #then #block

         @b_Is_Binary_Input = TRUE
         @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Operating_System_'t_Part_Operation'")

      #block_end
      #else #block

         #set x_Attributes_and_Values:vEVENT = replace(x_Attributes_and_Values:vEVENT, " ", "_")
         #set x_Attributes_and_Values:v't_Supervision_Type' = "'x_Attributes_and_Values:vSOURCE'_'x_Attributes_and_Values:vEVENT'"
         @t_Event_or_Alarm_Item = x_Attributes_and_Values:v't_Supervision_Type'
         @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "'t_Object_Type'_'t_Event_or_Alarm_Item'")

      #block_end

      #if l_Status_SCM:vSTATUS == 0 #then @t_Text_Item = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_TEXT_ITEM_GENERATION_ERROR")

      #if %t_Recursive_Operation == "" #then @i_OS_Index = 10
      #else_if %t_Recursive_Operation == "SEC" #then @i_OS_Index = 20
      #else_if %t_Recursive_Operation == "APL" #then @i_OS_Index = 30

      #case %t_Supervision_Type

         #when "INDICATION" @v_Object_Info = ("SYS_O't_Object_Number'I", %i_OS_Index, 3, "3", "BSWOSYIOSY", "", "'t_Text_Item'", 0, 0, 16, 0, 0, 2)
         #when "EVENT" @v_Object_Info = ("SYS_O't_Object_Number'E", %i_OS_Index, 3, "3", "BSWOSYXOSY", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)
         #when "ALARM" @v_Object_Info = ("SYS_O't_Object_Number'A", %i_OS_Index, 3, "3", "BSWOSYXOSY", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)

      #case_end

      @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Prefix_of_Operating_System")
      #if l_Status_SCM:vSTATUS == 0 #then @t_Bay_Text = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_TEXT_ITEM_DOES_NOT_EXIST")

   #block_end

   #when "APPLICATION" #block

      #if %t_Supervision_Type == "INDICATION" #then #block

         #if data_type(%x_Attributes_and_Values) == "LIST" #then @t_Suffix = "PRIMARY"
            #else @t_Suffix = upper_case(%x_Attributes_and_Values)

         @t_Part_Operation = %t_Recursive_Operation
         #if %t_Part_Operation == "" #then @t_Part_Operation = "AS"

         @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Status_of_Application_'t_Part_Operation'_'t_Suffix'")

         #case %t_Recursive_Operation

            #when "" #block

               @i_OS_Index = 10
            
               #if data_type(%x_Attributes_and_Values) == "LIST" #then #block
                  #if attribute_exists(%x_Attributes_and_Values, "NODE_NUMBER") #then #block
                     @b_Is_Presentation_Object = TRUE
                     #if x_Attributes_and_Values:vNODE_NUMBER == 0 #then @i_OS_Index = %i_Object_Number + 100
                     #else #block
                        @i_OS_Index = (x_Attributes_and_Values:vNODE_NUMBER * 100) + %i_Object_Number + 1000 ; HSB
                        #if l_Status_SCM:vSTATUS == 0 #then #block
                           @l_Status_SCM_2 = do (APL:BSV40, "SSS", "GetLanguageText", "Status_of_Node")
                           #if l_Status_SCM_2:vSTATUS == 0 #then #set l_Status_SCM:vDATA = l_Status_SCM:vDATA + " (" + l_Status_SCM_2:vDATA + " " + dec(x_Attributes_and_Values:vNODE_NUMBER, 0) + ")"
                        #block_end
                     #block_end
                  #block_end
               #block_end

            #block_end

            #when "SP" @i_OS_Index = 20
            #when "POOL" @i_OS_Index = 30
            #when "QUEUE" @i_OS_Index = 40
         #case_end

         #if %t_Suffix == "SECONDARY" #then @i_OS_Index = %i_OS_Index + 1

      #block_end
      #else #block

         #if %t_Recursive_Operation == "SECONDARY" #then @t_Suffix = "SECONDARY"
         #set x_Attributes_and_Values:vEVENT = replace(x_Attributes_and_Values:vEVENT, " ", "_")
         #set x_Attributes_and_Values:v't_Supervision_Type' = "'x_Attributes_and_Values:vSOURCE'_'x_Attributes_and_Values:vEVENT'"
         @t_Event_or_Alarm_Item = x_Attributes_and_Values:v't_Supervision_Type'
         @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "'t_Object_Type'_'t_Event_or_Alarm_Item'_'t_Suffix'")

      #block_end

      #if l_Status_SCM:vSTATUS == 0 #then @t_Text_Item = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_TEXT_ITEM_GENERATION_ERROR")

      #case %t_Supervision_Type

         #when "INDICATION" #block

            #if %t_Recursive_Operation == "" or %t_Recursive_Operation == "SP" #then -
               @v_Object_Info = ("SYS_A't_Object_Number'I", %i_OS_Index, 9, "9", "BSWAPLIAPL", "", "'t_Text_Item'", 0, 0, 16, 0, 0, 2)
            #else #block

               @v_Object_Info = ("SYS_A't_Object_Number'I", %i_OS_Index, 3, "3", "BSWAPLIAPL", "", "'t_Text_Item'", 0, 0, 16, 0, 0, 2)
               @b_Is_Binary_Input = TRUE

            #block_end

         #block_end
         #when "EVENT" @v_Object_Info = ("SYS_A't_Object_Number'E", 1, 3, "3", "BSWAPLXAPL", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)
         #when "ALARM" @v_Object_Info = ("SYS_A't_Object_Number'A", 1, 3, "3", "BSWAPLXAPL", "", "'t_Text_Item'", 0, 0, 16, 2, 2, 1)

      #case_end

      @l_Status_SCM = do (APL:BSV40, "SSS", "GetLanguageText", "Prefix_of_Application")
      #if l_Status_SCM:vSTATUS == 0 #then @t_Bay_Text = l_Status_SCM:vDATA
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_TEXT_ITEM_DOES_NOT_EXIST")

   #block_end

#case_end

#if %t_Object_Type == "STATION" or %t_Object_Type == "PRINTER" or %t_Object_Type == "NODE" or %t_Object_Type == "OPERATING_SYSTEM" or %t_Object_Type == "APPLICATION" or %t_Object_Type == "SLCM" #then #block

   #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then #block

      @i_Object_Address_Count = 1
      @i_Default_Index = 0
      #loop (%i_Object_Address_Count == 1)

         @i_Default_Index = %i_Default_Index + 1
         @l_Fetch = fetch(0, "P", %v_Object_Info(1), %i_Default_Index)
         #if %l_Fetch.IU == -1 #then @i_Object_Address_Count = 0

      #loop_end 10000

      @v_Object_Info(2) = %i_Default_Index

   #block_end

#block_end

#if %t_Object_Type == "NODE_LINK" #then #block

   #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then #block

      @l_Status = do (APL:BSV40, "SSS", "GetObjectIdentification", SYS:BCX, %t_Bay_Text, dec(%t_Recursive_Operation, 0))

      @i_Object_Address_Count = 1
      @i_Default_Index = 0
      #loop (%i_Object_Address_Count == 1)

         @i_Default_Index = %i_Default_Index + 1
         @l_Fetch = fetch(0, "P", %v_Object_Info(1), %i_Default_Index)
         #if %l_Fetch.IU == -1 #then @i_Object_Address_Count = 0

      #loop_end 10000

      @v_Object_Info(2) = %i_Default_Index

   #block_end
      #else @l_Status = do (APL:BSV40, "SSS", "GetObjectIdentification", SYS:BCX, %t_Bay_Text, dec(%x_Attributes_and_Values, 0))
#block_end
   #else @l_Status = do (APL:BSV40, "SSS", "GetObjectIdentification", SYS:BCX, %t_Bay_Text, dec(%i_Object_Number, 0))

#if l_Status:VSTATUS == 0 #then @v_Object_Info(length(%v_Object_Info) + 1) = l_Status:VDATA
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_OBJECT_IDENTIFIER_GENERATION_ERROR")
@t_RX_Part = %v_Object_Info(5)

#case %t_Object_Type

   #when "STATION", "SLCM", "PRINTER", "NODE", "NODE_LINK", "APPLICATION", "OPERATING_SYSTEM" #block

   #case %t_Supervision_Type

   #when "INDICATION" #block

      #if %b_Is_Presentation_Object #then @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),-
         IU = 1,SN = "1_1",SS = %v_Object_Info(13),HI = 0,HW = 0,LW = 0,LI = 0, AC = 0, RC = 1, EE = 1, HE = 1, HA = 1, HF = 1, HL = bit_mask(15), PA = 1, LD = bit_mask(1), PU = 1,-
         PF = "FORM5SAGR1", AN = %v_Object_Info(6), RX = "                    't_RX_Part'", EH = "SAGR_FORM5FPAI6_0")
      #else #block

      #if %b_Is_Binary_Input #then -
         @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SS = %v_Object_Info(13),-
            AC = 1,RC = 1,EE = 1,HE = 1,HA = %v_Object_Info(12),HF = 1,HL = bit_mask(15),PA = %v_Object_Info(11),PU = 1,PF = "FORM4BSBI",AN = %v_Object_Info(6),RX = "                    't_RX_Part'")
      #else -
         @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SN = "1_1",SS = %v_Object_Info(13),HI = 9.5,HW = 9.5,LW = -0.5,LI = -0.5,-
            AC = 1,RC = 1,EE = 1,HE = 1,HA = %v_Object_Info(12),HF = 1,HL = bit_mask(15),PA = %v_Object_Info(11),LD = bit_mask(1),PU = 1,PF = "FORM4BSAI",AN = %v_Object_Info(6),RX = "                    't_RX_Part'")

      #block_end

   #block_end
   #when "ROUTING" #block

      #if %t_Object_Type == "SLCM" #then @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SS = %v_Object_Info(13),-
         AN = %v_Object_Info(6),RX = "                    't_RX_Part'",SZ = 1, AE = 1, AA = 2, AF = 1, EE = 0)
      #else #block

   #case %t_Object_Type

      #when "STATION", "NODE_LINK", "NODE" #block
              #if not %b_Binary_Model #then #block
                 @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SN = "1_1",SS = %v_Object_Info(13),-
                    AN = %v_Object_Info(6),RX = "                    't_RX_Part'",SZ = 1, AE = 1, AA = 2, AF = 1, EE = 0)
              #block_end
              #else #block
                 @v_Object_Info(9) = %v_Object_Info(9) + 16777216
                 @v_Object_Info(7) = %v_Object_Info(7) + " [BI]"
                 @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SS = %v_Object_Info(13),-
                    AC = 1,RC = 1,EE = 1,HE = 1,HA = %v_Object_Info(12),HF = 1,HL = bit_mask(15),PA = %v_Object_Info(11),PU = 1,PF = "FORM4BSBI",AN = %v_Object_Info(6),RX = "                    't_RX_Part'",-
                    EH = "SAGR_FORM5FPBI1_40", SZ = 1, AE = 0, AA = 0, AF = 0, AG = 0)
              #block_end
      #block_end

      #otherwise @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SN = "1_1",SS = %v_Object_Info(13),-
              AN = %v_Object_Info(6),RX = "                    't_RX_Part'",SZ = 1, AE = 1, AA = 2, AF = 1, EE = 0)

   #case_end

      #block_end

      #if upper_case(%t_Object_Type) == "SLCM" #then #block
         #set l_Input_Object:vEE = 1
         #set l_Input_Object:vOA = 255 * %i_Object_Number
         #if %t_Recursive_Operation == "REDUNDANT" #then #set l_Input_Object:vOA = l_Input_Object:vOA + 127
         @v_Object_Info(8) = %i_Object_Number
         @v_Object_Info(9) = l_Input_Object:vOA
         #set l_Input_Object:vUN = %i_Object_Number
      #block_end

   #block_end
   #when "EVENT" -
      @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SS = %v_Object_Info(13),-
         HE = 1,HA = %v_Object_Info(12),HF = 1,HL = bit_mask(15),LD = bit_mask(1),PA = %v_Object_Info(11),PU = 1,PF = "FORM4BSBI",AN = %v_Object_Info(6),RX = "                    't_RX_Part'")
   #when "ALARM" -
      @l_Input_Object = list(OI = %v_Object_Info(14),OX = %v_Object_Info(7),UN = %v_Object_Info(8),OA = %v_Object_Info(9),PT = %v_Object_Info(3),DX = %v_Object_Info(4),IU = 1,SS = %v_Object_Info(13),-
         AC = 1,RC = 1,AN = %v_Object_Info(6),LD = bit_mask(1),RX = "                    't_RX_Part'",PF = "FORM4BSBI", AG = 2)

   #case_end

      #if %t_CX <> "" #then #set l_Input_Object:vCX = %t_CX

   #block_end

#case_end

@t_Process_Object_Name = %v_Object_Info(1)
@i_Process_Object_Index = %v_Object_Info(2)

#if %v_Object_Info(8) <> 0 or %v_Object_Info(9) <> 0 #then #block ; Address overlap situation possible

   #if %v_Object_Info(10) < 16 #then #block

      @l_Previous_Object_Address = application_object_list(0, "IX", "U", "F", %v_Object_Info(8), "OB==%v_Object_Info(10) and OA==%v_Object_Info(9)", vector("PT"))
      #set l_Input_Object:VOB = %v_Object_Info(10)

   #block_end
   #else @l_Previous_Object_Address = application_object_list(0, "IX", "U", "F", %v_Object_Info(8), "OA==%v_Object_Info(9)", vector("PT"))

   @i_Previous_Object_Address_Count = l_Previous_Object_Address:vCOUNT

#block_end
#else #block

   @i_Previous_Object_Address_Count = 0
   @l_Previous_Object_Address = list(LN = vector(%v_Object_Info(1)), IX = vector(%v_Object_Info(2)))

#block_end

#if %i_Previous_Object_Address_Count == 0 #then #block

   @l_Fetch = fetch(0, "P", %t_Process_Object_Name, %i_Process_Object_Index)

   #if %l_Fetch.IU == -1 #then #block

      @i_Status = status
      #error ignore
         #create 't_Process_Object_Name':P(%i_Process_Object_Index) = %l_Input_Object
      #error stop

      #if status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_PROCESS_OBJECT_CREATION_ERROR")

   #block_end
   #else #block

      #if %l_Fetch.PT == %l_Input_Object.PT #then @b_Modify_Existing = TRUE
      #else #block

         @i_Status = status
         #error ignore
            #delete 't_Process_Object_Name':P(%i_Process_Object_Index)
            #create 't_Process_Object_Name':P(%i_Process_Object_Index) = %l_Input_Object
         #error stop

         #if status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_PROCESS_OBJECT_CREATION_ERROR")

      #block_end
   #block_end

#block_end
#else #block

   #if %l_Previous_Object_Address.PT(1) == %l_Input_Object.PT #then #block

      @t_Process_Object_Name = l_Previous_Object_Address:vLN(1)
      @i_Process_Object_Index = l_Previous_Object_Address:vIX(1)
      @b_Modify_Existing = TRUE

   #block_end
   #else #block

      @i_Status = status
      #error ignore
         #delete 't_Process_Object_Name':P(%i_Process_Object_Index)
         #create 't_Process_Object_Name':P(%i_Process_Object_Index) = %l_Input_Object
      #error stop
      @i_Status = status

      #if %i_Status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_PROCESS_OBJECT_CREATION_ERROR ['i_Status']")

   #block_end

#block_end

#if %b_Modify_Existing #then #block

   #if length(l_Previous_Object_Address:vLN) > 0 #then #delete l_Input_Object:vAN
   #delete l_Input_Object:vOI
   #delete l_Input_Object:vOX

   @i_Status = status
   #error ignore
      #modify 't_Process_Object_Name':P(%i_Process_Object_Index) = %l_Input_Object
   #error stop

   #if status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_PROCESS_OBJECT_MODIFY_ERROR")

   #if length(l_Previous_Object_Address:vLN) > 0 #then #block

      @l_Status_SCM = do(APL:BSV40, "SSS", "AttachEventChannel", "acAttach", l_Previous_Object_Address:vLN(1), l_Previous_Object_Address:vIX(1), %v_Object_Info(6))
      #if l_Status_SCM:vSTATUS <> 0 #then #return %l_Status_SCM

   #block_end

#block_end

@v_Object_Info(1) = %t_Process_Object_Name
@v_Object_Info(2) = %i_Process_Object_Index

#case %t_Object_Type

   #when "STATION", "SLCM" #block

      #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then -
         @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "'t_Object_Type'", %t_Supervision_Type, %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values)
      #else #block

         @l_General_Info = APL:BSV45
         #if attribute_exists(%l_General_Info, "ENABLE_BINARY_MODEL") #then @b_Binary_Model_In_Use = l_General_Info:vENABLE_BINARY_MODEL
            #else @b_Binary_Model_In_Use = FALSE

         #if %t_Recursive_Operation == "REDUNDANT" and %t_ST_Value == "RTU" and %b_Binary_Model and %b_Binary_Model_In_Use and %t_Supervision_Type == "ROUTING" #then #block
            @t_CX_Reference = %v_Object_Info(1) + ":P" + dec(%v_Object_Info(2), 0)
            @l_Status_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", "STATIONS", %i_Object_Number, list(CX = %t_CX_Reference))
            @l_Status_SCM = do(APL:BSV40, "SSS", "PutObjectAttribute", "STATION", "ROUTING_SECONDARY", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), -1)
         #block_end
         #else @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "'t_Object_Type'", "'t_Supervision_Type'_'t_Suffix'", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1))

         #if %t_Recursive_Operation == "" and %t_ST_Value == "RTU" #then #block
         
            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) == 0 #then -
               @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "STATION", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT")
            #else @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "STATION", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT",-
               list(MI = vector(l_Additional_Create_Attributes:vMI(1), l_Additional_Create_Attributes:vMI(2))))
         #block_end
         #else_if %t_Recursive_Operation == "" and %t_ST_Value == "LMK" and locate(%t_CX_Value, "SLCM") > 0 and upper_case(%t_Object_Type) == "SLCM" #then -
            @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "SLCM", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT")
         #else_if %t_Recursive_Operation == "" and %i_SE == 4 #then #block
            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) == 0 #then -
               @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "STATION", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT", list(BINARY_MODEL = TRUE))
            #else @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "STATION", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT",-
               list(MI = l_Additional_Create_Attributes:vMI, BINARY_MODEL = TRUE))
         #block_end
         #else_if %t_Recursive_Operation == "REDUNDANT" and %t_ST_Value == "RTU" and not %b_Binary_Model and %b_Binary_Model_In_Use and %t_Supervision_Type == "ROUTING" #then #block
            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) == 0 #then -
               @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "STATION", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT", list(BINARY_MODEL = TRUE))
            #else @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "STATION", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT",-
               list(MI = vector(l_Additional_Create_Attributes:vMI(1), l_Additional_Create_Attributes:vMI(2)), BINARY_MODEL = TRUE))
         #block_end

      #block_end
      #return %l_Status_SCM

   #block_end

   #when "PRINTER" #block

      #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "PRINTER", %t_Supervision_Type, %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values)
         #else @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "PRINTER", "'t_Supervision_Type'_'t_Suffix'", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1))
      #return %l_Status_SCM

   #block_end

   #when "NODE" #block

      #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "NODE", %t_Supervision_Type, %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values)
      #else #block

         @l_Status_SCM = do (apl:bsv40, "SSS", "PutObjectAttribute", "NODE", "'t_Supervision_Type'_'t_Suffix'", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1))

         #if %t_Recursive_Operation == "" and (l_Node_Type:vTYPE == "PCNET" or l_Node_Type:vTYPE == "61850NET") and %t_Supervision_Type == "ROUTING" #then #block
            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) == 0 #then -
               @l_Status_SCM = do (apl:bsv40, "SSS", "CreateProcessObject", "NODE", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT", list(BINARY_MODEL = TRUE))
            #else @l_Status_SCM = do (apl:bsv40, "SSS", "CreateProcessObject", "NODE", "'t_Supervision_Type'", 'i_Object_Number', list(), "REDUNDANT", list(MI = l_Additional_Create_Attributes:vMI, BINARY_MODEL = TRUE))
         #block_end

         #if l_Node_Type:vTYPE == "MFL" and %t_Recursive_Operation == "REDUNDANT" #then #block

            #if length(select(list_attr(%l_Additional_Create_Attributes), "==""MI""")) == 0 #then -
               @l_Status_SCM = do (apl:bsv40, "SSS", "CreateProcessObject", "NODE", "'t_Supervision_Type'", 'i_Object_Number', list(), "PRIMARY")
            #else @l_Status_SCM = do (apl:bsv40, "SSS", "CreateProcessObject", "NODE", "'t_Supervision_Type'", 'i_Object_Number', list(), "PRIMARY", list(MI = l_Additional_Create_Attributes:vMI - 100))

         #block_end

      #block_end

      #return %l_Status_SCM

   #block_end

   #when "NODE_LINK" #block

      #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then -
         @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "NODE_LINK", %t_Supervision_Type, %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values, %t_Recursive_Operation)
      #else @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "NODE_LINK", "'t_Supervision_Type'_'t_Suffix'", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values)

      #if %t_Supervision_Type == "ROUTING" #then #block
         #if %t_Recursive_Operation == "" and %i_SE == 4 #then -
            @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "NODE_LINK", "'t_Supervision_Type'", 'i_Object_Number', 'x_Attributes_and_Values',-
               "REDUNDANT", list(MI = l_Additional_Create_Attributes:vMI, BINARY_MODEL = TRUE))
      #block_end

      #return %l_Status_SCM

   #block_end

   #when "OPERATING_SYSTEM" #block

      #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then -
         @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "OPERATING_SYSTEM", %t_Supervision_Type, %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values)
      #else #block

         @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "OPERATING_SYSTEM", "'t_Part_Operation'", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values)
         #if %t_Recursive_Operation == "" #then @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "OPERATING_SYSTEM", "INDICATION", 0, list(), "SEC")
         #else_if %t_Recursive_Operation == "SEC" #then @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "OPERATING_SYSTEM", "INDICATION", 0, list(), "APL")

      #block_end

      #return %l_Status_SCM

   #block_end

   #when "APPLICATION" #block

      #if %t_Supervision_Type == "EVENT" or %t_Supervision_Type == "ALARM" #then -
         @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "APPLICATION", %t_Supervision_Type, %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1), %x_Attributes_and_Values, "'t_Recursive_Operation'")
      #else #block

         #if not %b_Is_Presentation_Object #then @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "APPLICATION", "'t_Part_Operation'_'t_Suffix'", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1))
         #else @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectAttribute", "APPLICATION", "Presentation", %i_Object_Number, %v_Object_Info(2), %v_Object_Info(1))

         #if %t_Recursive_Operation == "" and not %b_Is_Presentation_Object #then @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "APPLICATION", "INDICATION", 'i_Object_Number', "'t_Suffix'", "SP")
         #else_if %t_Recursive_Operation == "SP" and not %b_Is_Presentation_Object #then @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "APPLICATION", "INDICATION", 'i_Object_Number', "'t_Suffix'", "POOL")
         #else_if %t_Recursive_Operation == "POOL" and not %b_Is_Presentation_Object #then @l_Status_SCM = do (APL:BSV40, "SSS", "CreateProcessObject", "APPLICATION", "INDICATION", 'i_Object_Number', "'t_Suffix'", "QUEUE")

      #block_end

      #return %l_Status_SCM

   #block_end

   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_PROCESS_OBJECT_'t_Object_Type'_CONFIGURATION_FILE_UPDATE_NOT_YET_SUPPORTED")

#case_end

; Method: PutObjectAttribute(t_Write_Object_Type, t_Write_Type, x_Information, x_Write_Additional, t_Point_LN, [t_Write_Event_Value], [t_HSB_Tag])
; Version: 1.0
; Description: Stores passed information into system self supervision parameter file
; --------------------------------------------------------------------------------------------------

@t_Write_Object_Type = argument(1)
@t_Write_Type = argument(2)
@x_Write_Information = argument(3)
@x_Write_Additional = argument(4)
@t_Point_LN = argument(5)
@t_Write_Event_Value = 0
#if argument_count > 5 #then @t_Write_Event_Value = argument(6) ; -1 if only ROUTINGS section to be handled
@t_HSB_Tag = ""
#if argument_count > 6 #then @t_HSB_Tag = argument(7)

@l_General_Info = APL:BSV45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI

#case upper_case(%t_Write_Object_Type)

   #when "STATION", "SLCM" #block

      @t_Parameter = "STATIONS"
      #if upper_case(%t_Write_Object_Type) == "SLCM" #then @t_Parameter = "SLCM"

      #case %t_Write_Type

         #when "ROUTING_PRIMARY", "ROUTING_SECONDARY" #block

            @t_Write_SSS_Type = upper_case(%t_Write_Object_Type)
            #if %t_Write_SSS_Type == "STATION" #then @t_Write_SSS_Type = "Station"
            @t_Mode_Type = substr(%t_Write_Type, locate(%t_Write_Type, "_") + 1, 0)
            @v_Write_Parameters = ("ROUTINGS", "'t_Write_SSS_Type'_'t_Point_LN'_'x_Write_Additional'", "'t_Parameter'")
            @l_Write_SCM_Status = write_parameter(%t_Conf_Data_File, %v_Write_Parameters(1), %v_Write_Parameters(2), "'x_Write_Information',,""" + %t_Mode_Type + """")

            #if data_type(%t_Write_Event_Value) == "INTEGER" #then #block ; only ROUTINGS handled
               #if %t_Write_Event_Value == -1 #then #return list(STATUS = 0)
            #block_end

         #block_end

         #when "INDICATION_PRIMARY", "INDICATION_SECONDARY" @v_Write_Parameters = ("", "", "'t_Parameter'")
         #when "EVENT" @v_Write_Parameters = ("", "", "'t_Parameter'_EVENT")
         #when "ALARM" @v_Write_Parameters = ("", "", "'t_Parameter'_ALARM")

      #case_end

      @t_Point_Info = %t_Point_LN + ":P" + dec(%x_Write_Additional, 0)
      #if upper_case(%t_Write_Type) <> "EVENT" and upper_case(%t_Write_Type) <> "ALARM" #then @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info))
         #else @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info), %t_Write_Event_Value)
      #if l_Put_SCM:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_WRITE_ATTRIBUTE_ERROR")
      @l_Write_SCM = do(APL:BSV40, "SSS", "PutObjectNumber", %t_Write_Object_Type, %i_Object_Number)
      #if l_Write_SCM:vSTATUS <> 0 #then #return %l_Write_SCM

      #case %t_Put_Attr_Type

         #when "STATIONS_EVENT", "STATIONS_ALARM", "SLCM_EVENT", "SLCM_ALARM" #return list(STATUS = 0, 't_Change_Name' = %v_Put_Values(1))
         #otherwise #return list(STATUS = 0)

      #case_end

   #block_end

   #when "PRINTER" #block

      #case %t_Write_Type

         #when "ROUTING_PRIMARY", "ROUTING_SECONDARY" #block

            @t_Mode_Type = substr(%t_Write_Type, locate(%t_Write_Type, "_") + 1, 0)
            @v_Write_Parameters = ("ROUTINGS", "Printer_'t_Point_LN'_'x_Write_Additional'", "PRINTERS")
            @l_Write_SCM_Status = write_parameter(%t_Conf_Data_File, %v_Write_Parameters(1), %v_Write_Parameters(2), "'x_Write_Information',,""" + %t_Mode_Type + """")

         #block_end

         #when "INDICATION_PRIMARY", "INDICATION_SECONDARY" @v_Write_Parameters = ("", "", "PRINTERS")
         #when "EVENT" @v_Write_Parameters = ("", "", "PRINTERS_EVENT")
         #when "ALARM" @v_Write_Parameters = ("", "", "PRINTERS_ALARM")

      #case_end

      @t_Point_Info = %t_Point_LN + ":P" + dec(%x_Write_Additional, 0)
      #if upper_case(%t_Write_Type) <> "EVENT" and upper_case(%t_Write_Type) <> "ALARM" #then @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info))
         #else @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info), %t_Write_Event_Value)
      #if l_Put_SCM:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_WRITE_ATTRIBUTE_ERROR")
      @l_Write_SCM = do(APL:BSV40, "SSS", "PutObjectNumber", %t_Write_Object_Type, %i_Object_Number)

      #case %t_Put_Attr_Type

         #when "PRINTERS_EVENT", "PRINTERS_ALARM" #return list(STATUS = 0, 't_Change_Name' = %v_Put_Values(1))
         #otherwise #return list(STATUS = 0)

      #case_end

   #block_end

   #when "NODE" #block

      #case %t_Write_Type

         #when "ROUTING_PRIMARY", "ROUTING_SECONDARY" #block

            @t_Mode_Type = substr(%t_Write_Type, locate(%t_Write_Type, "_") + 1, 0)
            @v_Write_Parameters = ("ROUTINGS", "Node_'t_Point_LN'_'x_Write_Additional'", "NODES")
            @l_Write_SCM_Status = write_parameter(%t_Conf_Data_File, %v_Write_Parameters(1), %v_Write_Parameters(2), "'x_Write_Information',,""" + %t_Mode_Type + """")

         #block_end

         #when "INDICATION_PRIMARY", "INDICATION_SECONDARY" @v_Write_Parameters = ("", "", "NODES")
         #when "EVENT" @v_Write_Parameters = ("", "", "NODES_EVENT")
         #when "ALARM" @v_Write_Parameters = ("", "", "NODES_ALARM")

      #case_end

      @t_Point_Info = %t_Point_LN + ":P" + dec(%x_Write_Additional, 0)
      #if upper_case(%t_Write_Type) <> "EVENT" and upper_case(%t_Write_Type) <> "ALARM" #then @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info))
         #else @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info), %t_Write_Event_Value)
      #if l_Put_SCM:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_PUT_OBJECT_ATTRIBUTE_WRITE_ATTRIBUTE_ERROR")
      @l_Write_SCM = do(APL:BSV40, "SSS", "PutObjectNumber", %t_Write_Object_Type, %i_Object_Number)
      #if l_Write_SCM:vSTATUS <> 0 #then #return %l_Write_SCM

      #case %t_Put_Attr_Type

         #when "NODES_EVENT", "NODES_ALARM" #return list(STATUS = 0, 't_Change_Name' = %v_Put_Values(1))
         #otherwise #return list(STATUS = 0)

      #case_end

   #block_end

   #when "NODE_LINK" #block

      #case %t_Write_Type

         #when "ROUTING_PRIMARY", "ROUTING_SECONDARY" #block

            @t_Mode_Type = substr(%t_Write_Type, locate(%t_Write_Type, "_") + 1, 0)
            @v_Write_Parameters = ("ROUTINGS", "Node_Link_'t_Point_LN'_'x_Write_Additional'", "NODE_'x_Write_Information'_LINKS")
            @l_Write_SCM_Status = write_parameter(%t_Conf_Data_File, %v_Write_Parameters(1), %v_Write_Parameters(2), "'x_Attributes_and_Values','x_Write_Information',""" + %t_Mode_Type + """")

         #block_end

         #when "INDICATION_PRIMARY", "INDICATION_SECONDARY" @v_Write_Parameters = ("", "", "NODE_'x_Write_Information'_LINKS")
         #when "EVENT" @v_Write_Parameters = ("", "", "NODE_'i_Object_Number'_LINKS_EVENT")
         #when "ALARM" @v_Write_Parameters = ("", "", "NODE_'i_Object_Number'_LINKS_ALARM")

      #case_end

      @t_Point_Info = %t_Point_LN + ":P" + dec(%x_Write_Additional, 0)
      #if upper_case(%t_Write_Type) <> "EVENT" and upper_case(%t_Write_Type) <> "ALARM" #then @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %x_Attributes_and_Values, list('t_Write_Type' = %t_Point_Info))
         #else @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %t_Recursive_Operation, list('t_Write_Type' = %t_Point_Info), %t_Write_Event_Value)
      #if l_Put_SCM:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_PUT_OBJECT_ATTRIBUTE_WRITE_ATTRIBUTE_ERROR")

      #if upper_case(%t_Write_Type) <> "EVENT" and upper_case(%t_Write_Type) <> "ALARM" #then #block
         #if %t_Write_Event_Value <> 0 #then @l_Write_SCM = do(APL:BSV40, "SSS", "PutObjectNumber", %t_Write_Object_Type, %t_Write_Event_Value, %x_Write_Information)
            #else @l_Write_SCM = do(APL:BSV40, "SSS", "PutObjectNumber", %t_Write_Object_Type, %t_Write_Additional, %x_Write_Information)
      #block_end
         #else @l_Write_SCM = do(APL:BSV40, "SSS", "PutObjectNumber", %t_Write_Object_Type, %t_HSB_Tag, %x_Write_Information)
      #if l_Write_SCM:vSTATUS <> 0 #then #return %l_Write_SCM

      #if locate(%t_Put_Attr_Type, "EVENT") > 0 or locate(%t_Put_Attr_Type, "ALARM") > 0 #then #return list(STATUS = 0, 't_Change_Name' = %v_Put_Values(1))
         #else #return list(STATUS = 0)

   #block_end

   #when "OPERATING_SYSTEM" #block

      #case %t_Write_Type

         #when "ROUTING" #block

            @v_Write_Parameters = ("ROUTINGS", "Node_'t_Point_LN'_'x_Write_Additional'", "NODES")
            @l_Write_SCM_Status = write_parameter(%t_Conf_Data_File, %v_Write_Parameters(1), %v_Write_Parameters(2), "'x_Write_Information',,")

         #block_end

         #when "SYS", "SEC", "APL" @v_Write_Parameters = ("", "", "OPERATING_SYSTEM")
         #when "EVENT" @v_Write_Parameters = ("", "", "OPERATING_SYSTEM_EVENT")
         #when "ALARM" @v_Write_Parameters = ("", "", "OPERATING_SYSTEM_ALARM")

      #case_end

      @t_Point_Info = %t_Point_LN + ":P" + dec(%x_Write_Additional, 0)
      #if upper_case(%t_Write_Type) <> "EVENT" and upper_case(%t_Write_Type) <> "ALARM" #then @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info))
         #else @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info), %t_Write_Event_Value)
      #if l_Put_SCM:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_WRITE_ATTRIBUTE_ERROR")

      #case %t_Put_Attr_Type

         #when "OPERATING_SYSTEM_EVENT", "OPERATING_SYSTEM_ALARM" #return list(STATUS = 0, 't_Change_Name' = %v_Put_Values(1))
         #otherwise #return list(STATUS = 0)

      #case_end

   #block_end

   #when "APPLICATION" #block

      #case %t_Write_Type

         #when "AS_PRIMARY","SP_PRIMARY","POOL_PRIMARY","QUEUE_PRIMARY","AS_SECONDARY","SP_SECONDARY","POOL_SECONDARY","QUEUE_SECONDARY","PRESENTATION" @v_Write_Parameters = ("", "", "APPLICATIONS")
         #when "EVENT" @v_Write_Parameters = ("", "", "APPLICATION_EVENT")
         #when "ALARM" @v_Write_Parameters = ("", "", "APPLICATION_ALARM")

      #case_end

      @t_Point_Info = %t_Point_LN + ":P" + dec(%x_Write_Additional, 0)
      #if upper_case(%t_Write_Type) <> "EVENT" and upper_case(%t_Write_Type) <> "ALARM" #then @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info))
         #else @l_Put_SCM = do(APL:BSV40, "SSS", "PutObjectAttributes", %v_Write_Parameters(3), %i_Object_Number, list('t_Write_Type' = %t_Point_Info), %t_Write_Event_Value, "'t_HSB_Tag'")
      #if l_Put_SCM:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_WRITE_ATTRIBUTE_ERROR")
      @l_Write_SCM = do(APL:BSV40, "SSS", "PutObjectNumber", %t_Write_Object_Type, %i_Object_Number)
      #if l_Write_SCM:vSTATUS <> 0 #then #return %l_Write_SCM

      #case %t_Put_Attr_Type

         #when "APPLICATION_EVENT", "APPLICATION_ALARM" #return list(STATUS = 0, 't_Change_Name' = %v_Put_Values(1))
         #otherwise #return list(STATUS = 0)

      #case_end

   #block_end

#case_end

; Method: AttachEventChannel(t_Attach_Mode, t_Object_LN, i_Object_IX, t_Attach_Event_Channel)
; Version: 1.0
; Parameters: t_Attach_Mode, the mode of modification, acAttach or acRemove
;             t_Object_LN, the LN for the process object to be attached
;             i_Object_IX, the IX for the process object to be attached
;             t_Attach_Event_Channel, includes the attached event channel name
; Description:
; -------------------------------------------------------------------------------------------

@t_Attach_Mode = argument(1)
@t_Object_LN = argument(2)
@i_Object_IX = argument(3)
@t_Attach_Event_Channel = argument(4)

#case upper_case(%t_Attach_Mode)

   #when "ACATTACH" #block

      @t_Event_Channel = 't_Object_LN':PAN(%i_Object_IX)
      @l_Event_Channel = fetch(0, "A", %t_Event_Channel)

      #if %t_Attach_Event_Channel == "" #then #modify 't_Object_LN':P(%i_Object_IX) = list(AN = "'t_Event_Channel'")
      #else_if length(%t_Event_Channel) > 0 and l_Event_Channel:VIU <> -1 #then #block

         ; If action name does not exist in primary or secondary object list, then append it
         #if length(select(upper_case(append(vector('t_Event_Channel':AON), 't_Event_Channel':ASN)), "==""'t_Attach_Event_Channel'""")) == 0 #then #block

            #if length('t_Event_Channel':ASN) > 9 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_PROCESS_OBJECT_SECONDARY_OBJECT_LIST_FULL")
            #modify 't_Event_Channel':A = list(IU = 1, SN = append('t_Event_Channel':ASN, "'t_Attach_Event_Channel'"), ST = append('t_Event_Channel':AST, "C"))

         #block_end
         #else #modify 't_Event_Channel':A = list(IU = 1)

      #block_end
      #else #modify 't_Object_LN':P(%i_Object_IX) = list(AN = "'t_Attach_Event_Channel'")

   #block_end

   #when "ACREMOVE" #block

      #if upper_case('t_Object_LN':pAN(%i_Object_IX)) == %t_Attach_Event_Channel #then #modify 't_Object_LN':p(%i_Object_IX) = list(AN = "")
      #else_if 't_Object_LN':pAN(%i_Object_IX) <> "" #then #block

         @t_Event_Channel = 't_Object_LN':PAN(%i_Object_IX)
         @v_Object_Names = 't_Event_Channel':ASN
         @v_Object_Types = 't_Event_Channel':AST

         #if length(select(upper_case(%v_Object_Names), "==""'t_Attach_Event_Channel'""")) > 0 #then #block

            @v_Deleted_Object = select(upper_case(%v_Object_Names), "==""'t_Attach_Event_Channel'""")
            @v_Object_Names = delete_element(%v_Object_Names, %v_Deleted_Object)
            @v_Object_Types = delete_element(%v_Object_Types, %v_Deleted_Object)

            #modify 't_Event_Channel':A = list(SN = %v_Object_Names, ST = %v_Object_Types)

         #block_end

      #block_end

   #block_end

#case_end

#return list(STATUS = 0)

; Method: PutObjectNumber(t_Put_Type, i_Put_Number, [x_Put_Addition], [x_Put_Direction])
; Version: 1.0
; Description: Update object numbers to the configuration file
; --------------------------------------------------------------------------------------

@t_Put_Type = argument(1)
@i_Put_Number = argument(2)
@x_Put_Addition = 0
#if argument_count > 2 #then @x_Put_Addition = argument(3)
@t_Put_Direction = "acAdd"
#if argument_count > 3 #then @t_Put_Direction = argument(4)

@v_Numbers_as_Text = vector()
@i_Signal_Count = 1
@l_General_Info = APL:BSV45
@t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI

#if %x_Put_Addition == 0 #then @l_Inside_SCM = do(APL:BSV40, "SSS", "GetObjectNumbers", %t_Put_Type)
#else @l_Inside_SCM = do(APL:BSV40, "SSS", "GetObjectNumbers", %t_Put_Type, %x_Put_Addition)

#if l_Inside_SCM:vSTATUS > 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_READ_OBJECT_NUMBERS_ERROR")
   #else_if l_Inside_SCM:vSTATUS < 0 #then @l_Inside_SCM = list(DATA = vector(), HIGH_ELEMENT = 0)

#case %t_Put_Direction

   #when "acAdd" #block

      #if length(select(l_Inside_SCM:vDATA, "==%i_Put_Number")) > 0 #then #return list(STATUS = 0, EXIST = TRUE)
         #else @v_Put_Numbers = append(l_Inside_SCM:vDATA, %i_Put_Number)

   #block_end

   #when "acDelete" #block

      #if length(select(l_Inside_SCM:vDATA, "==%i_Put_Number")) == 0 #then #return list(STATUS = 0, EXIST = FALSE)
      #else @v_Put_Numbers = delete_element(l_Inside_SCM:vDATA, select(l_Inside_SCM:vDATA, "==%i_Put_Number"))

   #block_end

#case_end

@v_Put_Numbers = pick(%v_Put_Numbers, sort(%v_Put_Numbers))

#case %t_Put_Type

   #when "STATION" @v_Put_Types = ("STATIONS", "Station_Numbers")
   #when "NODE" @v_Put_Types = ("NODES", "Node_Numbers")
   #when "PRINTER" @v_Put_Types = ("PRINTERS", "Printer_Numbers")
   #when "SLCM" @v_Put_Types = ("SLCM", "SLCM_Numbers")
   #when "APPLICATION" @v_Put_Types = ("APPLICATIONS", "Application_Numbers")
   #when "UNDEF_PROC" @v_Put_Types = ("UNDEF_PROC", "Station_Numbers")
   #when "NODE_LINK" #block
      @v_Put_Types = ("NODE_'x_Put_Addition'_LINKS", "Node_Link_Numbers")
      #if %i_Put_Number > 12 #then #return list(STATUS = 0)
   #block_end

#case_end

#if length(%v_Put_Numbers) == 0 #then #block

   @l_Delete_Status = delete_parameter(%t_Conf_Data_File, %v_Put_Types(1), %v_Put_Types(2))
   #return list(STATUS = l_Delete_Status:vSTATUS)

#block_end
#else #block

   #loop_with i_3 = 1 .. length(%v_Put_Numbers)
   
      @v_Previous_Numbers_as_Text = %v_Numbers_as_Text
      @v_Numbers_as_Text = append(%v_Numbers_as_Text, collect(dump(%v_Put_Numbers(%i_3)), ","))
      @i_Row_Width = length(collect(%v_Numbers_as_Text, ","))
   
      #if %i_Row_Width > 200 #then #block
   
         #if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_Conf_Data_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Previous_Numbers_as_Text, ",") + ",-")
         #else @i_Status = write_parameter(%t_Conf_Data_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Previous_Numbers_as_Text, ",") + ",-")
   
         @v_Numbers_as_Text = vector(%v_Numbers_as_Text(length(%v_Numbers_as_Text)))
         @i_Signal_Count = %i_Signal_Count + 1
   
      #block_end
   
   #loop_end
   
   #if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_Conf_Data_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Numbers_as_Text, ","))
      #else @i_Status = write_parameter(%t_Conf_Data_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Numbers_as_Text, ","))

   ; ID 7822 / MV 10.9.2003
   #if l_Inside_SCM:vHIGH_ELEMENT > %i_Signal_Count and upper_case(%t_Put_Direction) == "ACDELETE" #then #block
      #loop_with i_4 = %i_Signal_Count + 1 .. l_Inside_SCM:vHIGH_ELEMENT
         @l_Delete_Status = delete_parameter(%t_Conf_Data_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_4'")
      #loop_end
   #block_end

   #return list(STATUS = 0, EXIST = (%t_Put_Direction == "acDelete"))

#block_end

; Method: PutObjectAttributes(t_Put_Attr_Type, i_Put_Number, l_Put_Attrs_and_Values)
; Version: 1.0
; Description: Updates contents of passed data in the configuration file.
; ----------------------------------------------------------------------------------

@t_Put_Attr_Type = argument(1)
@i_Put_Number = argument(2)
@l_Put_Attrs_and_Values = argument(3)
@x_Put_Event_Value = 0
#if argument_count > 3 #then @x_Put_Event_Value = argument(4)
@t_Tag_for_HSB = ""
#if argument_count > 4 #then #if argument(5) <> "" #then @t_Tag_for_HSB = "_" + argument(5)

#if data_type(%i_Put_Number) == "TEXT" #then @i_Put_Number = dec_scan(%i_Put_Number)
@l_General_Info = APL:BSV45
@t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_CONF_INI
@v_Values_as_Text = vector()
@i_Signal_Count = 1
@v_Put_Values = vector()
@b_Is_Node_Link = FALSE

#case %t_Put_Attr_Type

   #when "STATIONS" @v_Put_Types = ("STATIONS", "Station_'i_Put_Number'", "Station_Attributes", "CONF", "STATION", "STATION")
   #when "STATIONS_EVENT" #block

      @v_Put_Types = ("EVENTS", "Station_'i_Put_Number'_'x_Put_Event_Value'", "Event_Attributes", "EVENT", "EVENT", "STATION_EVENT")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "STATIONS_ALARM" #block

      @v_Put_Types = ("ALARMS", "Station_'i_Put_Number'_'x_Put_Event_Value'", "Alarm_Attributes", "EVENT", "ALARM", "STATION_ALARM")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "PRINTERS_EVENT" #block

      @v_Put_Types = ("EVENTS", "Printer_'i_Put_Number'_'x_Put_Event_Value'", "Event_Attributes", "EVENT", "EVENT", "PRINTER_EVENT")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "PRINTERS_ALARM" #block

      @v_Put_Types = ("ALARMS", "Printer_'i_Put_Number'_'x_Put_Event_Value'", "Alarm_Attributes", "EVENT", "ALARM", "PRINTER_ALARM")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "PRINTERS" @v_Put_Types = ("PRINTERS", "Printer_'i_Put_Number'", "Printer_Attributes", "CONF", "PRINTER", "PRINTER")
   #when "NODES" @v_Put_Types = ("NODES", "Node_'i_Put_Number'", "Node_Attributes", "CONF", "NODE", "NODE")
   #when "NODES_ALARM" #block

      @v_Put_Types = ("ALARMS", "Node_'i_Put_Number'_'x_Put_Event_Value'", "Alarm_Attributes", "EVENT", "ALARM", "NODE_ALARM")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "NODES_EVENT" #block

      @v_Put_Types = ("EVENTS", "Node_'i_Put_Number'_'x_Put_Event_Value'", "Alarm_Attributes", "EVENT", "EVENT", "NODE_EVENT")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "SLCM" @v_Put_Types = ("SLCM", "SLCM_'i_Put_Number'", "SLCM_Attributes", "CONF", "SLCM", "SLCM")
   #when "SLCM_EVENT" #block

      @v_Put_Types = ("EVENTS", "SLCM_'i_Put_Number'_'x_Put_Event_Value'", "Event_Attributes", "EVENT", "EVENT", "STATION_EVENT")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "SLCM_ALARM" #block

      @v_Put_Types = ("ALARMS", "SLCM_'i_Put_Number'_'x_Put_Event_Value'", "Alarm_Attributes", "EVENT", "ALARM", "STATION_ALARM")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "APPLICATIONS", "APPLICATION" @v_Put_Types = ("APPLICATIONS", "Application_'i_Put_Number'", "Application_Attributes", "CONF", "APPLICATION", "APPLICATION")
   #when "APPLICATION_EVENT" #block

      @t_Put_Item = x_Put_Event_Value:vEVENT
      @v_Put_Types = ("EVENTS", "Application_'i_Put_Number'_'t_Put_Item''t_Tag_for_HSB'", "Event_Attributes", "EVENT", "EVENT", "APPLICATION")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "APPLICATION_ALARM" #block

      @t_Put_Item = x_Put_Event_Value:vALARM
      @v_Put_Types = ("ALARMS", "Application_'i_Put_Number'_'t_Put_Item''t_Tag_for_HSB'", "Alarm_Attributes", "EVENT", "ALARM", "APPLICATION")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "OPERATING_SYSTEM" @v_Put_Types = ("OPERATING_SYSTEM", "Operating_System", "Operating_System_Attributes", "CONF", "OPERATING_SYSTEM", "OPERATING_SYSTEM")
   #when "OPERATING_SYSTEM_EVENT" #block

      @t_Put_Item = x_Put_Event_Value:vEVENT
      @v_Put_Types = ("EVENTS", "Operating_System_'t_Put_Item'", "Event_Attributes", "EVENT", "EVENT", "OPERATING_SYSTEM")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #when "OPERATING_SYSTEM_ALARM" #block

      @t_Put_Item = x_Put_Event_Value:vALARM
      @v_Put_Types = ("ALARMS", "Operating_System_'t_Put_Item'", "Alarm_Attributes", "EVENT", "ALARM", "OPERATING_SYSTEM")
      @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

   #block_end
   #otherwise #block
      @i_Node_Location = locate(upper_case(%t_Put_Attr_Type), "NODE")
      @i_Links_Location = locate(upper_case(%t_Put_Attr_Type), "LINKS")
      
      #if %i_Node_Location > 0 and %i_Links_Location > 0 #then #block

         #if %i_Links_Location < 7 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_PUT_OBJECT_ATTRIBUTES_PARAMETER_ERROR")
         @b_Is_Node_Link = TRUE
         @i_Middle_Node_Nr = dec_scan(substr(%t_Put_Attr_Type, %i_Node_Location + 5, %i_Links_Location - 7))

         #if locate(upper_case(%t_Put_Attr_Type), "EVENT") == 0 and locate(upper_case(%t_Put_Attr_Type), "ALARM") == 0 #then #block

            @v_Put_Types = (%t_Put_Attr_Type, "Node_Link_'i_Put_Number'", "Node_Link_Attributes", "CONF", "NODE_LINK", "NODE_LINK")

         #block_end
         #else #block

            @v_Put_Event_Type = list_attr(%l_Put_Attrs_and_Values)
            @t_Put_Event_Type = %v_Put_Event_Type(1)
            @v_Put_Types = ("'t_Put_Event_Type'S", "Node_'i_Middle_Node_Nr'_Link_'i_Put_Number'_'x_Put_Event_Value'", "'t_Put_Event_Type'_Attributes", "EVENT", %t_Put_Event_Type, "NODE_LINK")
            @t_Conf_Internal_File = l_General_Info:vFILE_NAME_OF_EVENT_INI
         
         #block_end

      #block_end
   #block_end
#case_end

@l_Read_Mapping = do(APL:BSV40, "SSS", "GetObjectAttributeMapping", %v_Put_Types(4), %v_Put_Types(5))
#if l_Read_Mapping:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_READ_ATTRIBUTE_MAPPING_ERROR")
@v_Attr_Names = l_Read_Mapping:vDATA

#if %t_Put_Attr_Type <> "STATIONS_EVENT" and %t_Put_Attr_Type <> "STATIONS_ALARM" #then #block

   #if locate(upper_case(%t_Put_Attr_Type), "NODE") > 0 and locate(upper_case(%t_Put_Attr_Type), "LINKS") > 0 #then -
      @l_Get_Status = do(APL:BSV40, "SSS", "GetObjectAttributes", %v_Put_Types(6), %i_Put_Number, %i_Middle_Node_Nr)
   #else @l_Get_Status = do(APL:BSV40, "SSS", "GetObjectAttributes", %v_Put_Types(6), %i_Put_Number)

#block_end
#else @l_Get_Status = do(APL:BSV40, "SSS", "GetObjectAttributes", %v_Put_Types(6), %i_Put_Number, %x_Put_Event_Value)

#if l_Get_Status:vSTATUS <> 0 #then #block

   @l_Get_Status = list()
   #loop_with i_3 = 1 .. length(%v_Attr_Names)

      @t_Change_Name = %v_Attr_Names(%i_3)
      #set l_Get_Status:v't_Change_Name' = ""

   #loop_end

#block_end

@v_Attrs = list_attr(%l_Put_Attrs_and_Values)

#loop_with i_3 = 1 .. length(%v_Attrs)

   @t_Change_Name = %v_Attrs(%i_3)
   #set l_Get_Status:v't_Change_Name' = l_Put_Attrs_and_Values:v't_Change_Name'

#loop_end

#loop_with i_3 = 1 .. length(%v_Attr_Names)

   @t_Change_Name = %v_Attr_Names(%i_3)
   @v_Put_Values(%i_3) = l_Get_Status:v't_Change_Name'

#loop_end

@b_Can_be_Deleted = FALSE
@i_Incremented = 1
#if %t_Put_Attr_Type == "OPERATING_SYSTEM" or %t_Put_Attr_Type == "SLCM" #then @i_Incremented = 0
   #else_if %t_Put_Attr_Type == "APPLICATION" and attribute_exists(%l_Put_Attrs_and_Values, "PRESENTATION") #then @i_Incremented = 3

@i_Put_Status = status
#error ignore
   @v_Put_Items = length(select(%v_Put_Values(1 .. length(%v_Put_Values) - %i_Incremented), "<>"""" and <>""#"""))
#error stop
#if status == 0 #then #if length(select(%v_Put_Values(1 .. length(%v_Put_Values) - %i_Incremented), "<>"""" and <>""#""")) == 0 #then @b_Can_be_Deleted = TRUE

#if not %b_Can_be_Deleted #then #block
   
   #loop_with i_3 = 1 .. length(%v_Put_Values)
   
      @v_Previous_Values_as_Text = %v_Values_as_Text
      #if data_type(%v_Put_Values(%i_3)) == "TEXT" #then #block
   
         #if %v_Put_Values(%i_3) == "" or %v_Put_Values(%i_3) == "#" #then @v_Values_as_Text = append(%v_Values_as_Text, "")
            ; VJ/AZ 10.6.2004 begin (ID=8422)
            ;#else @v_Values_as_Text = append(%v_Values_as_Text, collect(dump(%v_Put_Values(%i_3)), ","))
            #else @v_Values_as_Text = append(%v_Values_as_Text, """" + %v_Put_Values(%i_3) + """")
            ; VJ/AZ 10.6.2004 end

      #block_end
      #else @v_Values_as_Text = append(%v_Values_as_Text, collect(dump(%v_Put_Values(%i_3)), ","))
   
      @i_Row_Width = length(collect(%v_Values_as_Text, ","))
   
      #if %i_Row_Width > 200 #then #block

         #if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_Conf_Internal_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Previous_Values_as_Text, ",") + ",-")
         #else @i_Status = write_parameter(%t_Conf_Internal_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Previous_Values_as_Text, ",") + ",-")

         @v_Values_as_Text = vector(%v_Values_as_Text(length(%v_Values_as_Text)))
         @i_Signal_Count = %i_Signal_Count + 1

      #block_end

   #loop_end

   #if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_Conf_Internal_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Values_as_Text, ","))
   #else @i_Status = write_parameter(%t_Conf_Internal_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Values_as_Text, ","))

#block_end
#else #block

   @l_Delete_Status = list(STATUS = 0)

   #case %t_Put_Attr_Type

      #when "STATIONS","PRINTERS","NODES","SLCM","OPERATING_SYSTEM","APPLICATION","APPLICATIONS" @l_Delete_Status = delete_parameter(%t_Conf_Internal_File, %v_Put_Types(1), %v_Put_Types(2))

   #case_end

   #if %b_Is_Node_Link #then @l_Delete_Status = delete_parameter(%t_Conf_Internal_File, %t_Put_Attr_Type, %v_Put_Types(2))

   #if l_Delete_Status:vSTATUS == 0 #then #block

      #case %t_Put_Attr_Type

         #when "STATIONS" @l_Remove_Number = do(apl:bsv40, "SSS", "DeleteObjectNumber", "STATION", 'i_Put_Number')
         #when "PRINTERS" @l_Remove_Number = do(apl:bsv40, "SSS", "DeleteObjectNumber", "PRINTER", 'i_Put_Number')
         #when "NODES" @l_Remove_Number = do(apl:bsv40, "SSS", "DeleteObjectNumber", "NODE", 'i_Put_Number')
         #when "SLCM" @l_Remove_Number = do(apl:bsv40, "SSS", "DeleteObjectNumber", "SLCM", 'i_Put_Number')
         #when "APPLICATION", "APPLICATIONS" @l_Remove_Number = do(apl:bsv40, "SSS", "DeleteObjectNumber", "APPLICATION", 'i_Put_Number')
         #when "OPERATING_SYSTEM" @l_Remove_Number = list(STATUS = 0)
         #otherwise #if not %b_Is_Node_Link #then @l_Remove_Number = list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_PUT_OBJECT_ATTRIBUTES_UNKNOWN_SUPERVISION_OBJECT_TYPE_ERROR")

      #case_end

      #if %b_Is_Node_Link #then @l_Remove_Number = do(apl:bsv40, "SSS", "DeleteObjectNumber", "NODE_LINK", 'i_Put_Number', 'i_Middle_Node_Nr')
      #if l_Remove_Number:vSTATUS <> 0 #then #return %l_Remove_Number

   #block_end
   #else #return %l_Delete_Status

#block_end

#if length(select(list_attr(%l_Put_Attrs_and_Values), "==""EVENT""")) == 0 #then #block

@v_Put_AE_Chars = vector()

#case %t_Put_Attr_Type

   #when "STATIONS","PRINTERS","NODES","SLCM","APPLICATION","APPLICATIONS" #block

      @t_Delete_AE_Number = substr("0000", length(dec(%i_Put_Number, 0)) + 1, 0) + dec(%i_Put_Number, 0)

      #case %t_Put_Attr_Type
         #when "STATIONS", "SLCM" @v_Put_AE_Chars = ("SYS_S" + %t_Delete_AE_Number + "E", "SYS_S" + %t_Delete_AE_Number + "A")
         #when "PRINTERS" @v_Put_AE_Chars = ("SYS_P" + %t_Delete_AE_Number + "E", "SYS_P" + %t_Delete_AE_Number + "A")
         #when "NODES" @v_Put_AE_Chars = ("SYS_N" + %t_Delete_AE_Number + "E", "SYS_N" + %t_Delete_AE_Number + "A")
         #when "APPLICATIONS", "APPLICATION" @v_Put_AE_Chars = ("SYS_A" + %t_Delete_AE_Number + "E", "SYS_A" + %t_Delete_AE_Number + "A")
      #case_end

   #block_end

   #otherwise #block

      #if %b_Is_Node_Link #then #block

         @t_Delete_AE_Number = substr("0000", length(dec(%i_Put_Number, 0)) + 1, 0) + dec(%i_Put_Number, 0)
         @v_Put_AE_Chars = ("SYS_N" + %t_Delete_AE_Number + "E", "SYS_N" + %t_Delete_AE_Number + "A")

      #block_end

   #block_end

#case_end   

#if data_type(%v_Put_Values(1)) == "TEXT" #then @b_Event_Alarm_Prohibited = ((locate(%v_Put_Values(1), "A:") > 0) or (locate(%v_Put_Values(1), "E:") > 0))
   #else @b_Event_Alarm_Prohibited = FALSE

#if length(%v_Put_AE_Chars) > 0 and not %b_Event_Alarm_Prohibited #then #block

   @t_Put_AE_Chars = %v_Put_AE_Chars(1)
   @l_Fetch = fetch(0, "P", %t_Put_AE_Chars)

   #if %l_Fetch.IU >= 0 #then #block
   
      @l_Event_or_Alarm_Query = application_object_list(0, "IX", "I", "F", "'t_Put_AE_Chars'", "")
      @v_Whole_SSSEvent_Ini = read_text(l_General_Info:vFILE_NAME_OF_EVENT_INI)

      #loop_with i_Event_or_Alarm_Index = 1 .. l_Event_or_Alarm_Query:vCOUNT

         @t_Event_or_Alarm_to_be_Deleted = %t_Put_AE_Chars + ":P" + dec(l_Event_or_Alarm_Query:vIX(%i_Event_or_Alarm_Index), 0)
         @v_Found_Tag = select(locate(%v_Whole_SSSEvent_Ini, "=""'t_Event_or_Alarm_to_be_Deleted'"), ">0")
         #if length(%v_Found_Tag) > 0 #then #block
            @b_Can_be_AE_Deleted = TRUE
            #if %t_Put_Attr_Type == "NODES" #then #block
               @t_AE_Prefix = "NODE_'i_Put_Number'_LINK"
               #if upper_case(substr(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), 1, length(%t_AE_Prefix))) == %t_AE_Prefix #then @b_Can_be_AE_Deleted = FALSE
            #block_end
            #else_if %b_Is_Node_Link #then #block
               @t_AE_Prefix = "NODE_'i_Put_Number'_LINK"
               #if upper_case(substr(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), 1, length(%t_AE_Prefix))) <> %t_AE_Prefix #then @b_Can_be_AE_Deleted = FALSE
            #block_end

            #if %b_Can_be_AE_Deleted #then #block
               @l_Delete_Event_or_Alarm = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, "EVENTS", substr(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), 1, locate(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), "=") - 1))
               #delete 't_Put_AE_Chars':P(l_Event_or_Alarm_Query:vIX(%i_Event_or_Alarm_Index))
            #block_end
         #block_end

      #loop_end
      
      #error ignore
         #delete 't_Put_AE_Chars':P
      #error stop

      @i_Status = status
      
   #block_end

   @t_Put_AE_Chars = %v_Put_AE_Chars(2)
   @l_Fetch = fetch(0, "P", %t_Put_AE_Chars)
   
   #if %l_Fetch.IU >= 0 #then #block

      @l_Event_or_Alarm_Query = application_object_list(0, "IX", "I", "F", "'t_Put_AE_Chars'", "")

      #loop_with i_Event_or_Alarm_Index = 1 .. l_Event_or_Alarm_Query:vCOUNT

         @t_Event_or_Alarm_to_be_Deleted = %t_Put_AE_Chars + ":P" + dec(l_Event_or_Alarm_Query:vIX(%i_Event_or_Alarm_Index), 0)
         @v_Found_Tag = select(locate(%v_Whole_SSSEvent_Ini, "=""'t_Event_or_Alarm_to_be_Deleted'"), ">0")
         #if length(%v_Found_Tag) > 0 #then #block
            @b_Can_be_AE_Deleted = TRUE
            #if %t_Put_Attr_Type == "NODES" #then #block
               @t_AE_Prefix = "NODE_'i_Put_Number'_LINK"
               #if upper_case(substr(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), 1, length(%t_AE_Prefix))) == %t_AE_Prefix #then @b_Can_be_AE_Deleted = FALSE
            #block_end
            #else_if %b_Is_Node_Link #then #block
               @t_AE_Prefix = "NODE_'i_Put_Number'_LINK"
               #if upper_case(substr(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), 1, length(%t_AE_Prefix))) <> %t_AE_Prefix #then @b_Can_be_AE_Deleted = FALSE
            #block_end

            #if %b_Can_be_AE_Deleted #then #block
               @l_Delete_Event_or_Alarm = delete_parameter(l_General_Info:vFILE_NAME_OF_EVENT_INI, "ALARMS", substr(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), 1, locate(%v_Whole_SSSEvent_Ini(%v_Found_Tag(1)), "=") - 1))
               #delete 't_Put_AE_Chars':P(l_Event_or_Alarm_Query:vIX(%i_Event_or_Alarm_Index))
            #block_end
         #block_end

      #loop_end

      #error ignore
         #delete 't_Put_AE_Chars':P
      #error stop

      @i_Status = status
      
   #block_end

#block_end

#block_end

#return list(STATUS = 0)

; Method: GetStationNumbers(t_Get_Station_Type, i_Get_Node_Number, [i_Get_Node_Link_Number])
; Version: 1.0
; Parameters: t_Get_Station_Type, the type of query, e.g. for stations behind node or node link
;             i_Get_Node_Number, the number of node, e.g. 3 for NET allocated to node 3
;             [i_Get_Node_Link_Number], the communication line number, e.g. 1 for line connected to NET
; Description: Finds out from the SSS configuration file, the station allocated to the certain
;              node or node link.
; -----------------------------------------------------------------------------------------------------

@t_Get_Station_Type = argument(1)
@i_Get_Node_Number = argument(2)
@i_Get_Node_Link_Number = 0
#if argument_count > 2 #then @i_Get_Node_Link_Number = argument(3)
@t_Get_Object_CX = ""
@b_CX_Included = FALSE
#if argument_count > 3 #then #block

   @t_Get_Object_CX = argument(4)
   @b_CX_Included = TRUE

#block_end

@v_Included_Stations = vector()
@l_Get_Station_Status = do (apl:bsv40, "SSS", "GetObjectNumbers", "STATION")
#if l_Get_Station_Status:vSTATUS <> 0 #then #return %l_Get_Station_Status

#case upper_case(%t_Get_Station_Type)

   #when "NODE", "NODE_LINK" #block

      #loop_with i_Get_Station = 1 .. length(l_Get_Station_Status:vDATA)

         @l_Get_Station_Attribute_Status = do (apl:bsv40, "SSS", "GetObjectAttribute", "STATION", l_Get_Station_Status:vDATA(%i_Get_Station), "All")
         #if l_Get_Station_Attribute_Status:vSTATUS <> 0 #then #return %l_Get_Station_Attribute_Status
         #else #block

            #case upper_case(%t_Get_Station_Type)

               #when "NODE" #if l_Get_Station_Attribute_Status:vND == %i_Get_Node_Number #then @v_Included_Stations = append(%v_Included_Stations, l_Get_Station_Status:vDATA(%i_Get_Station))
               #when "NODE_LINK" -
                  #if l_Get_Station_Attribute_Status:vND == %i_Get_Node_Number and l_Get_Station_Attribute_Status:vLI == %i_Get_Node_Link_Number #then @v_Included_Stations = append(%v_Included_Stations, l_Get_Station_Status:vDATA(%i_Get_Station))

            #case_end

         #block_end

      #loop_end

      #if upper_case(%t_Get_Station_Type) == "NODE" #then @t_Get_Object_CX = %i_Get_Node_Link_Number
      #if data_type(%i_Get_Node_Link_Number) == "TEXT" #then @b_CX_Included = TRUE

      #if %b_CX_Included #then #block

      #if %t_Get_Object_CX <> "" and %t_Get_Object_CX <> "#" #then #block

         #if locate(upper_case(%t_Get_Object_CX), "REDUNDANT_") > 0 #then #block

            @v_MFL_Node_Info = separate(%t_Get_Object_CX, "_")
            @i_Peer_MFL_Node_Number = dec_scan(%v_MFL_Node_Info(2))

            #loop_with i_Get_Station = 1 .. length(l_Get_Station_Status:vDATA)

               @l_Get_Station_Attribute_Status = do (apl:bsv40, "SSS", "GetObjectAttribute", "STATION", l_Get_Station_Status:vDATA(%i_Get_Station), "All")
               #if l_Get_Station_Attribute_Status:vSTATUS <> 0 #then #return %l_Get_Station_Attribute_Status
               #else #block

                  #case upper_case(%t_Get_Station_Type)

                     #when "NODE" #if l_Get_Station_Attribute_Status:vND == %i_Peer_MFL_Node_Number #then @v_Included_Stations = append(%v_Included_Stations, l_Get_Station_Status:vDATA(%i_Get_Station))
                     #when "NODE_LINK" -
                      #if l_Get_Station_Attribute_Status:vND == %i_Peer_MFL_Node_Number and l_Get_Station_Attribute_Status:vLI == %i_Get_Node_Link_Number #then @v_Included_Stations = append(%v_Included_Stations, l_Get_Station_Status:vDATA(%i_Get_Station))

                  #case_end

               #block_end

            #loop_end

         #block_end

      #block_end

      #block_end

   #block_end

   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_STATION_NUMBERS_PARAMETER_TYPE_ERROR")

#case_end

#return list(STATUS = 0, DATA = %v_Included_Stations)

; Method: GetLogItem(t_Get_Log_Type)
; Version: 1.0
; --------------------------------------------------------------------

@t_Get_Log_Type = argument(1)
@t_Item_2 = argument(2)
@t_Item_3 = ""
#if argument_count > 2 #then @t_Item_3 = argument(3)
@t_Item_4 = ""
#if argument_count > 3 #then @t_Item_4 = argument(4)
@t_Item_5 = ""
#if argument_count > 4 #then @t_Item_5 = argument(5)
@t_Item_6 = ""
#if argument_count > 5 #then @t_Item_6 = argument(6)

#if argument_count == 5 #then #block

   #if data_type(%t_Item_2) <> "TEXT" or data_type(%t_Item_3) <> "TEXT" or data_type(%t_Item_4) <> "TEXT" or data_type(%t_Item_5) <> "TEXT" #then -
      #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_LOG_ITEM_PARAMETER_ERROR")

#block_end
#else_if argument_count == 6 #then #block

   #if data_type(%t_Item_2) <> "TEXT" or data_type(%t_Item_3) <> "TEXT" or data_type(%t_Item_4) <> "TEXT" or data_type(%t_Item_5) <> "TEXT" or data_type(%t_Item_6) <> "TEXT" #then -
      #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_LOG_ITEM_PARAMETER_ERROR")

#block_end

@t_Log_Item_Text = ""

#if argument_count == 2 #then #block

   #if upper_case(%t_Item_2) == "### SYS_STARTED ###" #then #block

      @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_SYS_STARTED")
      #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
      @t_Log_Item_Text = l_Status_SCM_1:vDATA
      
   #block_end
   #else @t_Log_Item_Text = %t_Item_2

#block_end
#else #block

   #case upper_case(%t_Get_Log_Type)
   
      #when "STM" #block
   
         #case upper_case(%t_Item_2)
   
            #when "STA" #block

               #if substr(upper_case(SYS:BPR), 1, 3) == "SMS" #then #block

                  @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Object")
                  #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
                  @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Device")
                  #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2

                  #if argument_count == 5 #then #block

                     @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetStatusMessage", dec_scan(%t_Item_5), TRUE)
                     #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3

                     #if locate(%t_Item_4, "_") > 0 #then #block

                        @l_Status_SCM_4 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Address")
                        #if l_Status_SCM_4:vSTATUS <> 0 #then #return %l_Status_SCM_4

                        @t_Identify_Type = substr(%t_Item_4, 1, locate(%t_Item_4, "_") - 1)
                        @t_Identify_Address = substr(%t_Item_4, locate(%t_Item_4, "_") + 1, 0)
                        @t_Item_4 = %t_Identify_Type + " - " + l_Status_SCM_4:vDATA + " " + %t_Identify_Address

                     #block_end

                     @t_Log_Item_Text = l_Status_SCM_1:vDATA + " " + %t_Item_3 + " [" + %t_Item_4 + "]: " + l_Status_SCM_3:vDATA + " ['t_Item_5']"

                  #block_end
                  #else #block

                     @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetStatusMessage", dec_scan(%t_Item_6), TRUE)
                     #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3
                     @l_Status_SCM_4 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Station")
                     #if l_Status_SCM_4:vSTATUS <> 0 #then #return %l_Status_SCM_4
                     @l_Status_SCM_5 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Node")
                     #if l_Status_SCM_5:vSTATUS <> 0 #then #return %l_Status_SCM_5
                     @l_Status_SCM_6 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Line")
                     #if l_Status_SCM_6:vSTATUS <> 0 #then #return %l_Status_SCM_6

                     @t_Log_Item_Text = l_Status_SCM_1:vDATA + " [" + l_Status_SCM_4:vDATA + " " + %t_Item_3 + "], " + lower_case(l_Status_SCM_2:vDATA) + " [" + -
                        lower_case(l_Status_SCM_5:vDATA) + " " + %t_Item_4 + ", " + lower_case(l_Status_SCM_6:vDATA) + " " + %t_Item_5 + "]: " + l_Status_SCM_3:vDATA + " ['t_Item_6']"

                  #block_end

               #block_end
               #else #block

                  @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Station")
                  #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
                  @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Node")
                  #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
                  @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Line")
                  #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3
                  @l_Status_SCM_4 = do (apl:bsv40, "SSS", "GetStatusMessage", dec_scan(%t_Item_6), TRUE)
                  #if l_Status_SCM_4:vSTATUS <> 0 #then #return %l_Status_SCM_4

                  @t_Log_Item_Text = l_Status_SCM_1:vDATA + " " + %t_Item_3 + ", " + lower_case(l_Status_SCM_2:vDATA) + " " + %t_Item_4 + ", " + -
                     lower_case(l_Status_SCM_3:vDATA) + " " + %t_Item_5 + ": " + l_Status_SCM_4:vDATA + " ['t_Item_6']"

               #block_end

            #block_end

            #when "APL_AS", "APL_SP", "APL_AS_EXT", "APL_SP_EXT" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Application")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_'t_Item_6'")
               #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
               #if locate(upper_case(%t_Item_2), "EXT") > 0 #then #block

                  @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_EXT")
                  #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3
                     #else @t_Item_4 = l_Status_SCM_3:vDATA

               #block_end

               @t_Log_Item_Text = l_Status_SCM_1:vDATA + " " + %t_Item_3 + ", " + l_Status_SCM_2:vDATA + " " + %t_Item_4

            #block_end

            #when "PICO_POOL", "REPR_POOL", "PRIN_POOL", "APL_EM", "APL_QM1", "APL_QM2", "APL_QM3", "APL_QM4", "APL_PM1", "APL_PM2" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Application")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_'t_Item_2'_'t_Item_6'")
               #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2

               @t_End_Text = ""
               @l_Status_SCM_3 = list(STATUS = 0)
               @b_Apl_Queue = FALSE

               #case upper_case(%t_Item_2)
                  #when "PICO_POOL" @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Monitor")
                  #when "REPR_POOL" @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Queue")
                  #when "PRIN_POOL" #block

                     #if %t_Item_4 == "1" #then @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Process_Printouts")
                        #else_if %t_Item_4 == "2" #then @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Report_Printouts")
                           #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_LOG_ITEM_PARAMETER_ERROR")
                  #block_end
                  #when "APL_EM","APL_QM1","APL_QM2","APL_QM3","APL_QM4","APL_PM1","APL_PM2" #block
                     @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Queue")
                     @b_Apl_Queue = TRUE
                  #block_end
               #case_end
               #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3
               #else #block

                  #if upper_case(%t_Item_2) == "PICO_POOL" or upper_case(%t_Item_2) == "REPR_POOL" #then @t_End_Text = ", " + l_Status_SCM_3:vDATA + " " + %t_Item_4
                     #else #block
                        #if not %b_Apl_Queue #then @t_End_Text = ", " + l_Status_SCM_3:vDATA
                           #else @t_End_Text = ", " + l_Status_SCM_3:vDATA + " " + %t_Item_3
                     #block_end

               #block_end

               @t_Log_Item_Text = l_Status_SCM_1:vDATA + " " + %t_Item_3 + ", " + l_Status_SCM_2:vDATA + %t_End_Text

            #block_end

            #when "NOD" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_NET")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Node")
               #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
               
               @t_Msg_Char = ""
               #if upper_case(%t_Item_6) == "FOUND" #then @t_Msg_Char = "started"
                  #else_if upper_case(%t_Item_6) == "LOST" #then @t_Msg_Char = "stopped"
               @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_NET_'t_Msg_Char'")
               #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3

               @t_Log_Item_Text = l_Status_SCM_1:vDATA + ", " + lower_case(l_Status_SCM_2:vDATA) + " 't_Item_3' " + l_Status_SCM_3:vDATA
            
            #block_end

            #when "PRI" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Printer")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_'t_Item_6'")
               #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2

               @t_Log_Item_Text = l_Status_SCM_1:vDATA + " 't_Item_3': " + l_Status_SCM_2:vDATA

            #block_end

            #when "GLOBAL_POOL" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Global_Pool_'t_Item_6'")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @t_Log_Item_Text = l_Status_SCM_1:vDATA

            #block_end

            #when "NODE" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_NET")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Node")
               #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
               @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetStatusMessage", dec_scan(%t_Item_6), TRUE)
               #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3

               @t_Log_Item_Text = l_Status_SCM_1:vDATA + ", " + lower_case(l_Status_SCM_2:vDATA) + " 't_Item_3': " + l_Status_SCM_3:vDATA + " ['t_Item_6']"

            #block_end

            #when "NODE_LINK" #block

               #if substr(upper_case(SYS:BPR), 1, 3) == "SMS" #then #block

                  @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Device")
                  #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1

                  #if argument_count == 4 #then #block
                     @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetStatusMessage", dec_scan(%t_Item_4), TRUE)
                     #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2

                     @t_Log_Item_Text = l_Status_SCM_1:vDATA + " 't_Item_3': " + l_Status_SCM_2:vDATA + " ['t_Item_4']"
                  #block_end
                  #else #block
                     @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_NET_Line")
                     #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
                     @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Node")
                     #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3
                     @l_Status_SCM_4 = do (apl:bsv40, "SSS", "GetStatusMessage", dec_scan(%t_Item_6), TRUE)
                     #if l_Status_SCM_4:vSTATUS <> 0 #then #return %l_Status_SCM_4

                     @t_Log_Item_Text = l_Status_SCM_1:vDATA + " [" + -
                         l_Status_SCM_2:vDATA + " 't_Item_3', " + l_Status_SCM_3:vDATA + " 't_Item_4']: " + l_Status_SCM_4:vDATA + " ['t_Item_6']"
                  #block_end
               #block_end
               #else #block
                  @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_NET_Line")
                  #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
                  @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Node")
                  #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
                  @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetStatusMessage", dec_scan(%t_Item_6), TRUE)
                  #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3

                  @t_Log_Item_Text = l_Status_SCM_1:vDATA + " 't_Item_3', " + l_Status_SCM_2:vDATA + " 't_Item_4': " + l_Status_SCM_3:vDATA + " ['t_Item_6']"
               #block_end

            #block_end

            #when "UN" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_UN")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_UN_'t_Item_6'")
               #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2

               @t_Log_Item_Text = l_Status_SCM_1:vDATA + " 't_Item_3': " + l_Status_SCM_2:vDATA

            #block_end

            #when "SLCM" #block

               @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_SLCM")
               #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
               @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Node")
               #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
               @l_Status_SCM_3 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Line")
               #if l_Status_SCM_3:vSTATUS <> 0 #then #return %l_Status_SCM_3

               @t_State = "NORMAL"
               @v_Texts = vector()
               @v_Bit_Values = (0,0,1,1)
               @v_Bit_Numbers = (0,1,2,6)
               @i_OV = dec_scan(%t_Item_6)

               #if bit(%i_OV, %v_Bit_Numbers(1)) == %v_Bit_Values(1) or bit(%i_OV, %v_Bit_Numbers(2)) == %v_Bit_Values(2) or bit(%i_OV,%v_Bit_Numbers(3)) == %v_Bit_Values(3) or bit(%i_OV,%v_Bit_Numbers(4)) == %v_Bit_Values(4) #then @t_State = "FAULTY"

               @l_Status_SCM_4 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_SLCM_'t_State'")
               #if l_Status_SCM_4:vSTATUS <> 0 #then #return %l_Status_SCM_4
               @l_Status_SCM_5 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_SLCM_Bit")
               #if l_Status_SCM_5:vSTATUS <> 0 #then #return %l_Status_SCM_5

               @t_Log_Item_Text = l_Status_SCM_1:vDATA + " " + %t_Item_3 + ", " + lower_case(l_Status_SCM_2:vDATA) + " " + %t_Item_4 + ", " + -
                  lower_case(l_Status_SCM_3:vDATA) + " " + %t_Item_5 + ": " + l_Status_SCM_4:vDATA

               #loop_with i_Bit_Number = 1 .. length(%v_Bit_Values)

                  @i_Bit_Nr = %v_Bit_Numbers(%i_Bit_Number)
                  @i_Bit_Value = bit(%i_OV, %i_Bit_Nr)
                  #if %i_Bit_Value == %v_Bit_Values(%i_Bit_Number) #then @t_State = "FAULTY"
                     #else @t_State = "NORMAL"

                  @l_Status_SCM_6 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_SLCM_Bit_'i_Bit_Nr'_Value_'i_Bit_Value'")
                  #if l_Status_SCM_6:vSTATUS <> 0 #then #return %l_Status_SCM_6

                  @l_Status_SCM_7 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_SLCM_'t_State'")
                  #if l_Status_SCM_7:vSTATUS <> 0 #then #return %l_Status_SCM_7

                  @t_Log_Bit_Text = l_Status_SCM_6:vDATA + ": 'l_Status_SCM_7:vDATA'"

                  @v_Texts(%i_Bit_Number) = %t_Log_Bit_Text

               #loop_end

               #return list(STATUS = 0, DATA = %t_Log_Item_Text, BIT_TEXTS = %v_Texts)

            #block_end

         #case_end

      #block_end

      #when "UPO" #block

         #case upper_case(%t_Item_2)

            #when "UN" #block

               #if %t_Item_3 == "0" #then #block

                  @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_UN_0")
                  #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
                  @t_Suffix_Text = %t_Item_5

               #block_end
               #else #block

                  @l_Status_SCM_1 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Message_Station")
                  #if l_Status_SCM_1:vSTATUS <> 0 #then #return %l_Status_SCM_1
                  @l_Status_SCM_2 = do (apl:bsv40, "SSS", "GetLanguageText", "Log_Prefix_of_Into_Object_Address")
                  #if l_Status_SCM_2:vSTATUS <> 0 #then #return %l_Status_SCM_2
                  @t_Suffix_Text = %t_Item_3 + " " + l_Status_SCM_2:vDATA + " 't_Item_5'"
                  
               #block_end
   
               @t_Log_Item_Text = l_Status_SCM_1:vDATA + " " + %t_Suffix_Text
   
            #block_end

         #case_end

      #block_end

      #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_LOG_ITEM_PARAMETER_ERROR")

   #case_end

#block_end

#return list(STATUS = 0, DATA = %t_Log_Item_Text)

; Method: DeleteObjectNumber(t_Delete_Type, t_Delete_Number, [x_Delete_Addition], [x_Delete_Direction])
; Version: 1.0
; Parameters: t_Delete_Type, the type of object to be removed
;             t_Delete_Number, the number of object to be removed
;             [x_Delete_Addition], additional parameter for NODE_LINK
; Description: Deletes the appropriate object number from the configuration file.
; -------------------------------------------------------------------------------

#case argument_count
   #when 2 @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectNumber", argument(1), argument(2), 0, "acDelete")
   #when 3 @l_Status_SCM = do (APL:BSV40, "SSS", "PutObjectNumber", argument(1), argument(2), argument(3), "acDelete")
#case_end

#return %l_Status_SCM

; Method: DeleteProcessObject(t_Delete_Object_Type, t_Delete_Supervision_Type, i_Delete_Object_Number, x_Delete_Attributes_and_Values)
; Version: 1.0
; Parameters: t_Delete_Object_Type
;             t_Delete_Supervision_Type
;             i_Delete_Object_Number
;             x_Delete_Attributes_and_Values
;             t_Delete_Recursive_Operation
; Description: Deletes the appropriate process object from the database and its interrelationships to configuration file.
; -----------------------------------------------------------------------------------------------------------------------

@t_Delete_Object_Type = argument(1)
@t_Delete_Supervision_Type = argument(2) ; Indication, Routing, Event, Alarm
@i_Delete_Object_Number = argument(3)
@x_Delete_Attributes_and_Values = list()
#if argument_count > 3 #then @x_Delete_Attributes_and_Values = argument(4)
@t_Delete_Recursive_Operation = ""
#if argument_count > 4 #then @t_Delete_Recursive_Operation = argument(5)
@t_Delete_Redundant_Operation = "" ; LIST type for Binary Model
#if argument_count > 5 #then @t_Delete_Redundant_Operation = argument(6)
@t_Delete_Additional_Info = ""
#if argument_count > 6 #then @t_Delete_Additional_Info = argument(7)

#if %t_Delete_Object_Type == "OPERATING_SYSTEM" #then @i_Delete_Object_Number = SYS:BND

@b_Binary_Model = FALSE
#if data_type(%t_Delete_Redundant_Operation) == "LIST" #then #block
   #if length(select(list_attr(%t_Delete_Redundant_Operation), "==""BINARY_MODEL""")) > 0 #then @b_Binary_Model = t_Delete_Redundant_Operation:vBINARY_MODEL
#block_end

@b_Modify_Existing = FALSE
@b_Is_Binary_Input = FALSE
@b_Is_Presentation_Object = FALSE
@t_Delete_Object_Number = substr("0000", length(dec(%i_Delete_Object_Number, 0)) + 1, 0) + dec(%i_Delete_Object_Number, 0)
@t_Bay_Text = ""
@t_Text_Item = ""
@t_Suffix = "PRIMARY"
@t_Delete_Reference = ""
@b_Reference_Unknown = FALSE

#case %t_Delete_Object_Type

   #when "STATION", "SLCM" #block

      @t_ST_Value = ""
      @t_CX_Value = ""

      @l_Status_SCM = do(apl:bsv40, "SSS", "GetObjectAttributes", "STATION", %i_Delete_Object_Number)
      #if %t_Delete_Supervision_Type == "INDICATION" #then @i_Index_Value = 10
         #else_if %t_Delete_Supervision_Type == "ROUTING" and not %b_Binary_Model #then @i_Index_Value = 110
            #else_if %t_Delete_Supervision_Type == "ROUTING" and %b_Binary_Model #then @i_Index_Value = 210

      #if l_Status_SCM:vSTATUS == 0 #then #block

         @t_ST_Value = l_Status_SCM:vST
         @t_CX_Value = l_Status_SCM:vCX

         #case %t_ST_Value
            #when "RTU" #if %t_Delete_Recursive_Operation == "REDUNDANT" and not %b_Binary_Model #then #block
               @i_Index_Value = %i_Index_Value + 1
               @t_Suffix = "SECONDARY"
            #block_end
            #when "LMK" #block
               #if locate(%t_CX_Value, "SLCM") > 0 #then #block
                  #if %t_Delete_Recursive_Operation == "ACTIVE" or %t_Delete_Recursive_Operation == "" #then @i_Index_Value = %i_Index_Value + 1
                     #else_if %t_Delete_Recursive_Operation == "REDUNDANT" #then #block
                        @i_Index_Value = %i_Index_Value + 2
                        @t_Suffix = "SECONDARY"
                     #block_end
               #block_end
            #block_end
         #case_end

      #block_end
      #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_READ_STATION_TYPE_ERROR")

      #if %t_Delete_Supervision_Type == "INDICATION" or %t_Delete_Supervision_Type == "ROUTING" #then #block

         #if %t_Delete_Supervision_Type == "ROUTING" and %b_Binary_Model #then @t_Suffix = "SECONDARY"

         #if %t_Delete_Additional_Info <> "" #then @t_Delete_Reference = %t_Delete_Additional_Info
         #else #block
      
            @l_Existing_Data = do(apl:bsv40, "SSS", "GetObjectAttribute", "'t_Delete_Object_Type'", %i_Delete_Object_Number, "'t_Delete_Supervision_Type'_'t_Suffix'")
      
            #if l_Existing_Data:vSTATUS == 0 #then @t_Delete_Reference = l_Existing_Data:v't_Delete_Supervision_Type'_'t_Suffix'
               #else @b_Reference_Unknown = TRUE

         #block_end

      #block_end

      #case %t_Delete_Supervision_Type

         #when "INDICATION" @v_Object_Info = ("SYS_S't_Delete_Object_Number'I", %i_Index_Value, "")

         #when "ROUTING" #block

            @v_Object_Info = ("SYS_S't_Delete_Object_Number'I", %i_Index_Value, "SYS_STAMR")
            #if %t_Delete_Object_Type == "SLCM" #then @v_Object_Info(3) = "SYS_SLCMR"

         #block_end

         #when "EVENT" @v_Object_Info = vector("SYS_S't_Delete_Object_Number'E")
         #when "ALARM" @v_Object_Info = vector("SYS_S't_Delete_Object_Number'A")

      #case_end

   #block_end

   #when "PRINTER" #block

      #if %t_Delete_Supervision_Type == "INDICATION" or %t_Delete_Supervision_Type == "ROUTING" #then #block

         #if %t_Delete_Recursive_Operation == "REDUNDANT" #then @t_Suffix = "SECONDARY"

         @l_Existing_Data = do(apl:bsv40, "SSS", "GetObjectAttribute", "PRINTER", %i_Delete_Object_Number, "'t_Delete_Supervision_Type'_'t_Suffix'")
         #if l_Existing_Data:vSTATUS == 0 #then @t_Delete_Reference = l_Existing_Data:v't_Delete_Supervision_Type'_'t_Suffix'
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_READ_PRINTER_ATTRIBUTE_ERROR")

      #block_end

      #case %t_Delete_Supervision_Type

         #when "INDICATION" @v_Object_Info = ("SYS_P't_Delete_Object_Number'I", 10, "")
         #when "ROUTING" @v_Object_Info = ("SYS_P't_Delete_Object_Number'I", 110, "SYS_PRIMR")
         #when "EVENT" @v_Object_Info = ("SYS_P't_Delete_Object_Number'E", 1, "")
         #when "ALARM" @v_Object_Info = ("SYS_P't_Delete_Object_Number'A", 1, "")

      #case_end

   #block_end

   #when "NODE" #block

      #if %t_Delete_Supervision_Type == "INDICATION" or %t_Delete_Supervision_Type == "ROUTING" #then #block

         #if %t_Delete_Recursive_Operation == "REDUNDANT" #then @t_Suffix = "SECONDARY"
         @l_Node_Type = do(apl:bsv40, "SSS", "GetObjectAttributes", "NODE", %i_Delete_Object_Number)
         #if l_Node_Type:vSTATUS <> 0 #then #return %l_Node_Type
            #else @t_Delete_Reference = l_Node_Type:v't_Delete_Supervision_Type'_'t_Suffix'

      #block_end

      #case %t_Delete_Supervision_Type

         #when "INDICATION" #block

            #if %t_Delete_Recursive_Operation == "" or %t_Delete_Recursive_Operation == "PRIMARY" #then @i_OS_Index = 10
               #else_if %t_Delete_Recursive_Operation == "REDUNDANT" #then @i_OS_Index = 11
            @v_Object_Info = ("SYS_N't_Delete_Object_Number'I", %i_OS_Index, "")

         #block_end
         #when "ROUTING" #block

            #if %t_Delete_Recursive_Operation == "" or %t_Delete_Recursive_Operation == "PRIMARY" #then @i_OS_Index = 110
            #else_if %t_Delete_Recursive_Operation == "REDUNDANT" and not %b_Binary_Model #then @i_OS_Index = 111
            #else_if %t_Delete_Recursive_Operation == "REDUNDANT" and %b_Binary_Model #then @i_OS_Index = 210

            @v_Object_Info = ("SYS_N't_Delete_Object_Number'I", %i_OS_Index, "SYS_NETMR")

         #block_end
         #when "EVENT" @v_Object_Info = vector("SYS_N't_Delete_Object_Number'E")
         #when "ALARM" @v_Object_Info = vector("SYS_N't_Delete_Object_Number'A")

      #case_end

   #block_end

   #when "NODE_LINK" #block

      #if %t_Delete_Recursive_Operation == "REDUNDANT" #then @t_Suffix = "SECONDARY"

      #if %t_Delete_Supervision_Type == "INDICATION" or %t_Delete_Supervision_Type == "ROUTING" #then #block

         @l_Existing_Data = do(apl:bsv40, "SSS", "GetObjectAttribute", "NODE_LINK", %x_Delete_Attributes_and_Values, "'t_Delete_Supervision_Type'_'t_Suffix'", %i_Delete_Object_Number)
         #if l_Existing_Data:vSTATUS == 0 #then @t_Delete_Reference = l_Existing_Data:v't_Delete_Supervision_Type'_'t_Suffix'
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_READ_NODE_LINK_ATTRIBUTE_ERROR")

      #block_end

      #case %t_Delete_Supervision_Type

         #when "INDICATION" #block

            @i_OS_Index = 20 + %x_Delete_Attributes_and_Values
            @v_Object_Info = ("SYS_N't_Delete_Object_Number'I", %i_OS_Index, "")

         #block_end
         #when "ROUTING" #block

            @i_OS_Index = 120 + %x_Delete_Attributes_and_Values
            #if %b_Binary_Model #then @i_OS_Index = %i_OS_Index + 100

            @v_Object_Info = ("SYS_N't_Delete_Object_Number'I", %i_OS_Index, "SYS_NETLMR")

         #block_end
         #when "EVENT" @v_Object_Info = vector("SYS_N't_Delete_Object_Number'E")
         #when "ALARM" @v_Object_Info = vector("SYS_N't_Delete_Object_Number'A")

      #case_end

   #block_end

   #when "OPERATING_SYSTEM" #block

      @t_Part_Operation = %t_Delete_Recursive_Operation
      #if %t_Part_Operation == "" #then @t_Part_Operation = "SYS"

      #if %t_Delete_Supervision_Type == "INDICATION" #then #block

         @l_Existing_Data = do(apl:bsv40, "SSS", "GetObjectAttribute", "OPERATING_SYSTEM", %i_Delete_Object_Number, "'t_Part_Operation'")
         #if l_Existing_Data:vSTATUS == 0 #then @t_Delete_Reference = l_Existing_Data:v't_Part_Operation'
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_READ_OPERATING_SYSTEM_ATTRIBUTE_ERROR")

      #block_end

      #if %t_Delete_Recursive_Operation == "" #then @i_OS_Index = 10
      #else_if %t_Delete_Recursive_Operation == "SEC" #then @i_OS_Index = 11
      #else_if %t_Delete_Recursive_Operation == "APL" #then @i_OS_Index = 12

      #case %t_Delete_Supervision_Type

         #when "INDICATION" @v_Object_Info = ("SYS_O't_Delete_Object_Number'I", %i_OS_Index, "")
         #when "EVENT" @v_Object_Info = ("SYS_O't_Delete_Object_Number'E", %i_OS_Index, "")
         #when "ALARM" @v_Object_Info = ("SYS_O't_Delete_Object_Number'A", %i_OS_Index, "")

      #case_end

   #block_end

   #when "APPLICATION" #block

      @t_Part_Operation = %t_Delete_Recursive_Operation

      #if %t_Delete_Redundant_Operation == "" #then #block

         #if %t_Part_Operation == "" #then @t_Part_Operation = "AS_PRIMARY"
            #else @t_Part_Operation = %t_Part_Operation + "_PRIMARY"
            
      #block_end
      #else #block

         #if %t_Part_Operation == "" #then @t_Part_Operation = "AS_SECONDARY"
            #else @t_Part_Operation = %t_Part_Operation + "_SECONDARY"
      
      #block_end

      #if %t_Delete_Supervision_Type == "INDICATION" #then #block

         #if data_type(%x_Delete_Attributes_and_Values) == "LIST" #then #block
            #if attribute_exists(%x_Delete_Attributes_and_Values, "NODE_NUMBER") #then #block
               @b_Is_Presentation_Object = TRUE
               @t_Part_Operation = "PRESENTATION"
            #block_end
         #block_end

         @l_Existing_Data = do(apl:bsv40, "SSS", "GetObjectAttribute", "APPLICATION", %i_Delete_Object_Number, "'t_Part_Operation'")
         #if l_Existing_Data:vSTATUS == 0 #then @t_Delete_Reference = l_Existing_Data:v't_Part_Operation'
            #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_READ_APPLICATION_ATTRIBUTE_ERROR")

      #block_end

      #case %t_Delete_Recursive_Operation

         #when "" #block

            @i_OS_Index = 10

            #if %b_Is_Presentation_Object #then #block
               #if x_Delete_Attributes_and_Values:vNODE_NUMBER == 0 #then @i_OS_Index = %i_Delete_Object_Number + 100
                  #else @i_OS_Index = (x_Delete_Attributes_and_Values:vNODE_NUMBER * 100) + %i_Delete_Object_Number + 1000 ; HSB
            #block_end

         #block_end
         #when "SP" @i_OS_Index = 20
         #when "POOL" @i_OS_Index = 30
         #when "QUEUE" @i_OS_Index = 40

      #case_end

      #if %t_Delete_Redundant_Operation == "SECONDARY" #then @i_OS_Index = %i_OS_Index + 1

      #case %t_Delete_Supervision_Type

         #when "INDICATION" @v_Object_Info = ("SYS_A't_Delete_Object_Number'I", %i_OS_Index, "")
         #when "EVENT" @v_Object_Info = ("SYS_A't_Delete_Object_Number'E", %i_OS_Index, "")
         #when "ALARM" @v_Object_Info = ("SYS_A't_Delete_Object_Number'A", %i_OS_Index, "")

      #case_end

   #block_end
   
#case_end

   #if %t_Delete_Supervision_Type == "EVENT" or %t_Delete_Supervision_Type == "ALARM" #then #block

      @t_LN = %v_Object_Info(1)
      @l_Fetch = fetch(0, "P", %t_LN)

      #if %l_Fetch.IU >= 0 #then #block
      
         @l_Index_Count = application_object_list(0, "IX", "I", "F", "'t_LN'", "")
         @l_Existing_Data = list(LN = %v_Object_Info(1))

         @v_Delete_Indices = vector()
         #if l_Index_Count:vCOUNT > 0 #then @v_Delete_Indices = l_Index_Count:vIX

         #loop_with i_Delete_Count = 1 .. length(%v_Delete_Indices)

            @i_Index_to_be_Deleted = %v_Delete_Indices(%i_Delete_Count)

            @i_Status = status
            #error ignore
               #delete 'l_Existing_Data:vLN':P(%i_Index_to_be_Deleted)
            #error stop

            #if status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_PROCESS_OBJECT_DELETION_ERROR")

         #loop_end
         
      #block_end

   #block_end
   #else #block

      #if not %b_Reference_Unknown #then #block

         @l_Existing_Data = do(apl:bsv40, "SSS", "GetLogicalNameAndIndex", %t_Delete_Reference)

         #if l_Existing_Data:vSTATUS == 0 #then #block

            #if l_Existing_Data:vLN == %v_Object_Info(1) and l_Existing_Data:vIX == %v_Object_Info(2) #then #block

               @i_Status = status
               #error ignore
                  #delete 'l_Existing_Data:vLN':P(l_Existing_Data:vIX)
               #error stop

               #if status <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_PROCESS_OBJECT_DELETION_ERROR")
               #else #block

                  #error ignore
                     #delete 'l_Existing_Data:vLN':P
                  #error stop

               #block_end

            #block_end
            #else #block

               ; In the case of supervision routing, remove also attached event channel from existing process object
               #if %t_Delete_Supervision_Type == "ROUTING" #then #block

                  @l_Update_Data = do(apl:bsv40, "SSS", "AttachEventChannel", "acRemove", l_Existing_Data:vLN, l_Existing_Data:vIX, %v_Object_Info(3))
                  #if l_Update_Data:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_EVENT_CHANNEL_REMOVE_ERROR")

               #block_end

            #block_end

            #if %t_Delete_Supervision_Type == "ROUTING" #then #block

               #if %t_Delete_Object_Type <> "OPERATING_SYSTEM" and %t_Delete_Object_Type <> "APPLICATION" #then #block

                  @l_General_Info = APL:BSV45
                  @t_Conf_Data_File = l_General_Info:vFILE_NAME_OF_CONF_INI
                  @l_Delete_Status = delete_parameter(%t_Conf_Data_File, "ROUTINGS", "'t_Delete_Object_Type'_'l_Existing_Data:vLN'_'l_Existing_Data:vIX'")
                  #if l_Delete_Status:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_PARAMETER_DELETION_ERROR")

               #block_end

            #block_end

         #block_end
         #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_EXTRACT_LN_AND_IX_ERROR")

      #block_end

   #block_end

   #if %t_Delete_Supervision_Type == "INDICATION" or %t_Delete_Supervision_Type == "ROUTING" #then #block

      #case %t_Delete_Object_Type

         #when "STATION", "SLCM" #block

            @l_General_Info = APL:BSV45
            #if attribute_exists(%l_General_Info, "ENABLE_BINARY_MODEL") #then @b_Binary_Model_In_Use = l_General_Info:vENABLE_BINARY_MODEL
               #else @b_Binary_Model_In_Use = FALSE

            @t_Parameter = "STATIONS"
            #if upper_case(%t_Delete_Object_Type) == "SLCM" #then @t_Parameter = "SLCM"

            @l_Current_Data = do(apl:bsv40, "SSS", "PutObjectAttributes", "'t_Parameter'", %i_Delete_Object_Number, list('t_Delete_Supervision_Type'_'t_Suffix' = ""))

            #if %t_Delete_Recursive_Operation == "" and %t_ST_Value == "RTU" #then #block
               @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "STATION", "'t_Delete_Supervision_Type'", 'i_Delete_Object_Number', list(), "REDUNDANT")
            #block_end
            #else_if %t_Delete_Recursive_Operation == "" and %t_Delete_Object_Type == "SLCM" and %t_ST_Value == "LMK" and %t_CX_Value == "SLCM" #then -
               @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "SLCM", "'t_Delete_Supervision_Type'", 'i_Delete_Object_Number', list(), "REDUNDANT")
            #else_if %t_Delete_Recursive_Operation == "" and %b_Binary_Model_In_Use #then -
               @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "STATION", "'t_Delete_Supervision_Type'", 'i_Delete_Object_Number', list(), "REDUNDANT", list(BINARY_MODEL = TRUE))
            #else_if %t_Delete_Recursive_Operation == "REDUNDANT" and %t_ST_Value == "RTU" and not %b_Binary_Model and %b_Binary_Model_In_Use and %t_Delete_Supervision_Type == "ROUTING" #then #block
               @l_Existing_CX = do(apl:bsv40, "SSS", "GetObjectAttribute", "'t_Delete_Object_Type'", %i_Delete_Object_Number, "CX")
               #if l_Existing_CX:vSTATUS == 0 #then @t_Passed_CX = l_Existing_CX:vCX
                  #else @t_Passed_CX = ""
               @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "STATION", "'t_Delete_Supervision_Type'", 'i_Delete_Object_Number', list(), "REDUNDANT", list(BINARY_MODEL = TRUE), %t_Passed_CX)
            #block_end

         #block_end

         #when "PRINTER" @l_Current_Data = do(apl:bsv40, "SSS", "PutObjectAttributes", "PRINTERS", %i_Delete_Object_Number, list('t_Delete_Supervision_Type'_'t_Suffix' = ""))

         #when "NODE" #block

            @l_General_Info = APL:BSV45
            #if attribute_exists(%l_General_Info, "ENABLE_BINARY_MODEL") #then @b_Binary_Model_In_Use = l_General_Info:vENABLE_BINARY_MODEL
               #else @b_Binary_Model_In_Use = FALSE
         
            @l_Current_Data = do(apl:bsv40, "SSS", "PutObjectAttributes", "NODES", %i_Delete_Object_Number, list('t_Delete_Supervision_Type'_'t_Suffix' = ""))

            #if %t_Delete_Recursive_Operation == "" and (l_Node_Type:vTYPE == "PCNET" or l_Node_Type:vTYPE == "61850NET") and not %b_Binary_Model and %b_Binary_Model_In_Use #then #block
               @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "NODE", "'t_Delete_Supervision_Type'", 'i_Delete_Object_Number', list(), "REDUNDANT", list(BINARY_MODEL = TRUE))
            #block_end
            #else_if l_Node_Type:vTYPE == "MFL" and %t_Delete_Recursive_Operation == "REDUNDANT" #then @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "NODE", "'t_Delete_Supervision_Type'", 'i_Delete_Object_Number', list(), "PRIMARY")

         #block_end

         #when "NODE_LINK" #block

            @l_General_Info = APL:BSV45
            #if attribute_exists(%l_General_Info, "ENABLE_BINARY_MODEL") #then @b_Binary_Model_In_Use = l_General_Info:vENABLE_BINARY_MODEL
               #else @b_Binary_Model_In_Use = FALSE
         
            @l_Current_Data = do (APL:BSV40, "SSS", "PutObjectAttributes", "NODE_'i_Delete_Object_Number'_LINKS", "'x_Delete_Attributes_and_Values'", list('t_Delete_Supervision_Type'_'t_Suffix' = ""))

            #if %t_Delete_Recursive_Operation == "" and %b_Binary_Model_In_Use and %t_Delete_Supervision_Type == "ROUTING" #then -
               @l_Status_SCM = do(APL:BSV40, "SSS", "DeleteProcessObject", "NODE_LINK", "ROUTING", 'i_Delete_Object_Number', 'x_Delete_Attributes_and_Values', "REDUNDANT", list(BINARY_MODEL = TRUE))

         #block_end

         #when "OPERATING_SYSTEM" #block

            @l_Current_Data = do (APL:BSV40, "SSS", "PutObjectAttributes", "OPERATING_SYSTEM", %i_Delete_Object_Number, list('t_Part_Operation' = ""))
            #if %t_Delete_Recursive_Operation == "" #then @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "OPERATING_SYSTEM", "INDICATION", 0, list(), "SEC")
            #else_if %t_Delete_Recursive_Operation == "SEC" #then @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "OPERATING_SYSTEM", "INDICATION", 0, list(), "APL")

         #block_end

         #when "APPLICATION" #block

            @l_Current_Data = do (APL:BSV40, "SSS", "PutObjectAttributes", "APPLICATION", %i_Delete_Object_Number, list('t_Part_Operation' = ""))
            #if %t_Delete_Recursive_Operation == "" or %t_Delete_Recursive_Operation == "AS" #then -
               @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "APPLICATION", "INDICATION", 'i_Delete_Object_Number', list(), "SP", "'t_Delete_Redundant_Operation'")
            #else_if %t_Delete_Recursive_Operation == "SP" #then @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "APPLICATION", "INDICATION", 'i_Delete_Object_Number', list(), "POOL", "'t_Delete_Redundant_Operation'")
            #else_if %t_Delete_Recursive_Operation == "POOL" #then @l_Status_SCM = do (APL:BSV40, "SSS", "DeleteProcessObject", "APPLICATION", "INDICATION", 'i_Delete_Object_Number', list(), "QUEUE", "'t_Delete_Redundant_Operation'")
         
         #block_end

      #case_end

   #block_end
   #else_if %t_Delete_Supervision_Type == "EVENT" or %t_Delete_Supervision_Type == "ALARM" #then #block

      @l_General_Info = APL:BSV45
      @t_Event_Data_File = l_General_Info:vFILE_NAME_OF_EVENT_INI

      @v_Whole_File = read_text(%t_Event_Data_File, 1, 10000)

      #if %t_Delete_Object_Type == "SLCM" #then @t_Object_Prefix = "STATION"
         #else @t_Object_Prefix = "'t_Delete_Object_Type'"

      @t_Station_to_be_Deleted = "'t_Object_Prefix'_'i_Delete_Object_Number'_"
      @v_Delimiter_Placement = select(%v_Whole_File, "==""[ALARMS]""")
      #if length(%v_Delimiter_Placement) == 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_ALARMS_SECTION_NOT_FOUND_ERROR")

      @v_Founds = select(substr(upper_case(%v_Whole_File), 1, length(%t_Station_to_be_Deleted)), "==""STATION_'i_Delete_Object_Number'_""")

      #if %t_Delete_Supervision_Type == "EVENT" #then @v_Found_Indices = pick(%v_Founds, select(%v_Founds, "<%v_Delimiter_Placement(1)"))
         #else_if %t_Delete_Supervision_Type == "ALARM" #then @v_Found_Indices = pick(%v_Founds, select(%v_Founds, ">%v_Delimiter_Placement(1)"))

      #loop_with i_Status_Count = 1 .. length(%v_Found_Indices)

         @i_Equal_Sign = locate(%v_Whole_File(%v_Found_Indices(%i_Status_Count)), "=")
         @t_Status_Code = substr(%v_Whole_File(%v_Found_Indices(%i_Status_Count)), length(%t_Station_to_be_Deleted) + 1, %i_Equal_Sign - length(%t_Station_to_be_Deleted) - 1)

         @l_Delete_Status = delete_parameter(%t_Event_Data_File, "'t_Delete_Supervision_Type'S", "'t_Object_Prefix'_'i_Delete_Object_Number'_'t_Status_Code'")
         #if l_Delete_Status:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_PARAMETER_DELETION_ERROR")
            #else @l_Current_Data = list(STATUS = 0)

      #loop_end

   #block_end

   #if l_Current_Data:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_PROCESS_OBJECT_STATION_ATTRIBUTE_UPDATE_ERROR")

#return %l_Current_Data

; Method: GetPrinterNumbers(t_Get_Node_Type, i_Get_Node_Number)
; Version: 1.0
; Parameters: t_Get_Node_Type, the type of object in request, e.g. NODE
;             i_Get_Node_Number, the number of node, e.g. 3 for NET allocated to node 3
; Description: Finds out from the SSS configuration file, the printers allocated to the certain node.
; ---------------------------------------------------------------------------------------------------

@t_Get_Node_Type = argument(1)
@i_Get_Node_Number = argument(2)
@t_Get_Object_CX = ""
#if argument_count > 2 #then @t_Get_Object_CX = argument(3)

@v_Included_Printers = vector()

#case upper_case(%t_Get_Node_Type)

   #when "NODE" #block

      @l_Get_Printer_Status = do (apl:bsv40, "SSS", "GetObjectNumbers", "PRINTER")
      #if l_Get_Printer_Status:vSTATUS <> 0 #then #return list(STATUS = 0, DATA = vector())

   #block_end

   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_PRINTER_NUMBERS_OBJECT_TYPE_PARAMETER_ERROR")

#case_end

#loop_with i_Get_Printer = 1 .. length(l_Get_Printer_Status:vDATA)

   @l_Get_Printer_Attribute_Status = do (apl:bsv40, "SSS", "GetObjectAttribute", "PRINTER", l_Get_Printer_Status:vDATA(%i_Get_Printer), "All")

   #if l_Get_Printer_Attribute_Status:vSTATUS <> 0 #then #return %l_Get_Printer_Attribute_Status
      #else #if l_Get_Printer_Attribute_Status:vND == %i_Get_Node_Number #then @v_Included_Printers = append(%v_Included_Printers, l_Get_Printer_Status:vDATA(%i_Get_Printer))

#loop_end

#if %t_Get_Object_CX <> "" and %t_Get_Object_CX <> "#" #then #block

   #if locate(upper_case(%t_Get_Object_CX), "REDUNDANT_") > 0 #then #block

      @v_MFL_Node_Info = separate(%t_Get_Object_CX, "_")
      @i_Peer_MFL_Node_Number = dec_scan(%v_MFL_Node_Info(2))

      #loop_with i_Get_Printer = 1 .. length(l_Get_Printer_Status:vDATA)

         @l_Get_Printer_Attribute_Status = do (apl:bsv40, "SSS", "GetObjectAttribute", "PRINTER", l_Get_Printer_Status:vDATA(%i_Get_Printer), "All")
         #if l_Get_Printer_Attribute_Status:vSTATUS <> 0 #then #return %l_Get_Printer_Attribute_Status
            #else #if l_Get_Printer_Attribute_Status:vND == %i_Peer_MFL_Node_Number #then @v_Included_Printers = append(%v_Included_Printers, l_Get_Printer_Status:vDATA(%i_Get_Printer))

      #loop_end

   #block_end

#block_end

#return list(STATUS = 0, DATA = %v_Included_Printers)
