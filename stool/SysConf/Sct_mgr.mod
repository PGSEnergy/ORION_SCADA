; Method: GetObjAttrs(t_Obj_Type)
; Version: 1.0
; Parameters: t_Obj_Type, type of object having attribute names, e.g. "BASE_SYSTEM_LINK"
; Return data type: v_Object_Attrs, objects attributes for specified type.
; Description: Reads object attributes from the configuration file and returns in specified
;              format.
; -----------------------------------------------------------------------------------------

@t_Obj_Type = argument(1)

@l_System_Configuration_Data = SYS:BSV2
@t_System_Conf_File = l_System_Configuration_Data:vt_System_Configuration_File

#case %t_Obj_Type

   #when "BASE_SYSTEM_LINK" @t_Ini_Par = "Link_Attributes"

   #when "BASE_SYSTEM_NODE" #block

      @t_Ini_Par = "Node_B_Attributes"
      #error ignore
         @l_Ini_Read = read_parameter(%t_System_Conf_File, "ATTRIBUTE_MAPPING", %t_Ini_Par)
      #error stop
      #if %l_Ini_Read.Status == 559 #then #block
         @t_Ini_Par = "Node_Attributes"
      #block_end

   #block_end
   
   #when "NET_NODE" @t_Ini_Par = "Node_N_Attributes"

   #when "BASE_SYSTEM_STATION" @t_Ini_Par = "Station_B_Attributes"

   #when "NET_STATION" @t_Ini_Par = "Station_N_Attributes"

   #when "BASE_SYSTEM_STATION_TYPE" @t_Ini_Par = "Station_Type_Attributes"

   #when "NET_LINK" @t_Ini_Par = "Node_Link_Attributes"

#case_end

@v_Obj_Attributes = vector()
@l_Ini_Read = read_parameter(%t_System_Conf_File, "ATTRIBUTE_MAPPING", %t_Ini_Par)

#if l_Ini_Read:vSTATUS == 0 #then #block

   @v_Objects = separate(l_Ini_Read:vVALUE, ",")

   #if l_Ini_Read:vVALUE <> "" #then @v_Obj_Attributes = %v_Objects

#block_end

@l_Ini_Read = read_parameter(%t_System_Conf_File, "ATTRIBUTE_MAPPING", %t_Ini_Par + "_Vector")

#if l_Ini_Read:vSTATUS == 0 #then #block

   @v_Objects = separate(l_Ini_Read:vVALUE, ",")
   
   #if l_Ini_Read:vVALUE <> "" #then @v_Obj_Attributes = append(%v_Obj_Attributes, %v_Objects)
   
#block_end

@l_Ini_Read = read_parameter(%t_System_Conf_File, "ATTRIBUTE_MAPPING", %t_Ini_Par + "_List")

#if l_Ini_Read:vSTATUS == 0 #then #block

   @v_Objects = separate(l_Ini_Read:vVALUE, ",")
   
   #if l_Ini_Read:vVALUE <> "" #then @v_Obj_Attributes = append(%v_Obj_Attributes, %v_Objects)
   
#block_end

#return %v_Obj_Attributes
; Method: GetObjNrs(t_Obj_Type, [x_Information])
; Version: 1.0
; Parameters: t_Obj_Type, type of object having attribute value, e.g. "BASE_SYSTEM_LINK"
;             [x_Information], the number of the NET object or signal engineering file/device nr
; Return data type: v_Object_Numbers, objects numbers for specified type.
; Description: Reads object numbers from the configuration file and returns in specified
;              format.
; ----------------------------------------------------------------------------------------------

@t_Obj_Type = argument(1)

#if argument_count == 2 #then @x_Information = argument(2)

@l_System_Configuration_Data = SYS:BSV2
@t_System_Conf_File = l_System_Configuration_Data:vt_System_Configuration_File
@v_Obj_Numbers = vector(0)
#if %t_Obj_Type == "NET_POINTS_DNP" #then @v_Obj_Numbers = vector(-1)

#case %t_Obj_Type

   #when "BASE_SYSTEM_LINK" @v_Ini_Pars = ("LINKS", "Link_Numbers")
   #when "BASE_SYSTEM_NODE" @v_Ini_Pars = ("NODES", "Node_Numbers")
   #when "BASE_SYSTEM_STATION" @v_Ini_Pars = ("STATIONS", "Station_Numbers")
   #when "NET_STATION" @v_Ini_Pars = ("STATIONS", "Station_Numbers")
   #when "BASE_SYSTEM_STATION_TYPE" @v_Ini_Pars = ("STATION_TYPES", "Station_Type_Numbers")
   #when "NET_LINK" @v_Ini_Pars = ("NODE_'x_Information'_LINKS", "Node_Link_Numbers")
   #when "NET_DEVICES_REX" @v_Ini_Pars = ("REX_Device_Points", "Device_Numbers")
   #when "NET_DEVICES_PLC" @v_Ini_Pars = ("PLC_Device_Points", "Device_Numbers")
   #when "NET_DEVICES_STA" @v_Ini_Pars = ("STA_Device_Points", "Device_Numbers")
   #when "NET_DEVICES_LMK" @v_Ini_Pars = ("LMK_Device_Points", "Device_Numbers")
   #when "NET_DEVICES_SPA" @v_Ini_Pars = ("SPA_Device_Points", "Device_Numbers")
   #when "NET_DEVICES_DNP" @v_Ini_Pars = ("DNP_Device_Points", "Device_Numbers")
   #when "NET_POINTS_REX" @v_Ini_Pars = ("REX_Device_Points", "Device_Points")
   #when "NET_POINTS_PLC" @v_Ini_Pars = ("PLC_Device_Points", "Device_Points")
   #when "NET_POINTS_LMK" @v_Ini_Pars = ("LMK_Device_Points", "Device_Points")
   #when "NET_POINTS_SPA" @v_Ini_Pars = ("SPA_Device_Points", "Device_Points")
   #when "NET_POINTS_STA" @v_Ini_Pars = ("STA_Device_Points", "Device_Points")
   #when "NET_POINTS_DNP" @v_Ini_Pars = ("DNP_Device_Points", "Device_Points")
   #when "NET_EVENTS_SPA" @v_Ini_Pars = ("SPA_Device_Points", "Device_Events")
   #otherwise #return "#"

#case_end

#if length(select(("NET_DEVICES_REX", "NET_DEVICES_PLC", "NET_DEVICES_STA", "NET_DEVICES_LMK", "NET_DEVICES_SPA", "NET_DEVICES_DNP"), "==%t_Obj_Type")) > 0 #then @t_System_Conf_File = %x_Information
#else_if length(select(("NET_POINTS_REX", "NET_POINTS_PLC", "NET_POINTS_STA", "NET_POINTS_LMK", "NET_POINTS_SPA", "NET_POINTS_DNP", "NET_EVENTS_SPA"), "==%t_Obj_Type")) > 0 #then #block

   @t_System_Conf_File = %x_Information(1)
   @v_Ini_Pars(2) = %v_Ini_Pars(2) + "_" + dec(%x_Information(2), 0)

#block_end
@l_Ini_Read = read_parameter(%t_System_Conf_File, %v_Ini_Pars(1), %v_Ini_Pars(2))

#if l_Ini_Read:vSTATUS == 0 #then #block

   #if l_Ini_Read:vVALUE <> "" #then #block

      #if length(l_Ini_Read:vVALUE) == 1 #then @v_Obj_Numbers = dec_scan(separate(l_Ini_Read:vVALUE, ","))
      #else #block

         #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == ",-" #then @v_Obj_Numbers = dec_scan(separate(substr(l_Ini_Read:vVALUE, 1, length(l_Ini_Read:vVALUE) - 2), ","))
         #else_if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == "+-" #then @v_Obj_Numbers = dec_scan(separate(substr(l_Ini_Read:vVALUE, 1, length(l_Ini_Read:vVALUE) - 2), ","))
         #else @v_Obj_Numbers = dec_scan(separate(l_Ini_Read:vVALUE, ","))

      #block_end

   #block_end

#block_end

#loop_with i_Numbers = 2 .. 10000

   @l_Ini_Read = read_parameter(%t_System_Conf_File, %v_Ini_Pars(1), %v_Ini_Pars(2) + "_'i_Numbers'")

   #if l_Ini_Read:vSTATUS == 0 #then #block

      #if l_Ini_Read:vVALUE <> "" #then @v_Current_Values = separate(l_Ini_Read:vVALUE, ",")
      #else #block

         @v_Current_Values = vector()
         #set l_Ini_Read:vVALUE = "  "

      #block_end

      #if length(l_Ini_Read:vVALUE) == 1 #then @v_Obj_Numbers = append(%v_Obj_Numbers, dec_scan(%v_Current_Values))
      #else #block

         #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == ",-" #then #block

            @v_Current_Values = %v_Current_Values(1 .. length(%v_Current_Values) - 1)
            @v_Obj_Numbers = append(%v_Obj_Numbers, dec_scan(%v_Current_Values))

         #block_end
         #else #block

            @v_Obj_Numbers = append(%v_Obj_Numbers, dec_scan(%v_Current_Values))
            #loop_exit

         #block_end

      #block_end

   #block_end
   #else #loop_exit

#loop_end

#return %v_Obj_Numbers

; Method: GetAttr(t_Obj_Type, i_Obj_Nr, t_Attr_Name, i_Obj_Net_Nr, b_Return_as_Text)
; Version: 1.0
; Parameters: t_Obj_Type, type of object having attribute value, e.g. "BASE_SYSTEM_LINK"
;             i_Obj_Nr, number of the object having attribute value, e.g. 12
;             t_Attr_Name, name of the attribute having required value, e.g. "LT"
;             [i_Obj_Net_Nr], number of the NET object.
;             [b_Return_as_Text], return value as text format, default as real format.
; Description: Reads attribute value from the configuration file and returns in specified
;              format.
; ---------------------------------------------------------------------------------------
#argument t_Obj_Type,-
          i_Obj_Nr,-
          t_Attr_Name
#local b_Return_as_Text = false,-
       i_Obj_Net_Nr,-
       l_System_Configuration_Data = SYS:BSV2,-
       t_System_Conf_File = l_System_Configuration_Data.t_System_Configuration_File,-
       t_Attr_Mapping,-
       t_Obj_Section,-
       t_Key_Name_Prefix,-
       l_Ini_Read,-
       l_test_1,-
       l_test_2,-
       v_Ini_Values,-
       b_Found_as_Vector,-
       b_Found_as_List,-
       i_Attr_Index,-
       v_Ini_Values_as_Text,-
       v_Ini_Values_as_Real,-
       i_1,-
       i_Offset,-
       v_All_Values,-
       i,-
       i_Status,-
       v_Current_Values,-
       v_Int_Values_as_Real,-
       t_Start_Line,-
       t_End_Line,-
       v_IS,-
       t_tmp,-
       t_Line,-
       b_Continue = FALSE,-
       v_Fields,-
       ii

#if argument_count == 4 #then #block
   #if t_Obj_Type == "NET_LINK" #then i_Obj_Net_Nr = argument(4)
   #else b_Return_as_Text = true
#block_end

#if argument_count == 5 #then #block
   i_Obj_Net_Nr = argument(4)
   b_Return_as_Text = true
#block_end

#case t_Obj_Type

   #when "BASE_SYSTEM_LINK" #block

      t_Attr_Mapping = "Link_Attributes"
      t_Obj_Section = "LINKS"
      t_Key_Name_Prefix = "Link"

   #block_end

   #when "BASE_SYSTEM_NODE" #block

      t_Attr_Mapping = "Node_B_Attributes"
      t_Obj_Section = "NODES"
      
      #error ignore
         i_Status = status
         l_Ini_Read = read_parameter(t_System_Conf_File, "ATTRIBUTE_MAPPING", t_Attr_Mapping)
         i_Status = status
      #error stop
      #if l_Ini_Read.Status == status_code("SCIL_KEY_DOES_NOT_EXIST") #then #block
         t_Attr_Mapping = "Node_Attributes"
      #block_end
      
      t_Key_Name_Prefix = "Node_B"
      
      #loop_with i = 1 .. MAX_NODE_NUMBER
      
         l_test_1 = read_parameter(t_System_Conf_File, t_Obj_Section, "Node_B" + "_'i'")

         #if l_test_1.Status == status_code("SCIL_KEY_DOES_NOT_EXIST") #then #block
         
            l_test_2 = read_parameter(t_System_Conf_File, t_Obj_Section, "Node" + "_'i'")
            
            #if l_test_2.Status == 0 #then #block
               t_Key_Name_Prefix = "Node"
               #loop_exit
            #block_end
            
         #block_end
         #else_if l_test_1.Status == 0 #then #block
         
            t_Key_Name_Prefix = "Node_B"
            #loop_exit
            
         #block_end
                  
      #loop_end      

   #block_end
   
   #when "NET_NODE" #block

      t_Attr_Mapping = "Node_N_Attributes"
      t_Obj_Section = "NODES"
      t_Key_Name_Prefix = "Node_N"
      
      l_Ini_Read = read_parameter(t_System_Conf_File, "ATTRIBUTE_MAPPING", t_Attr_Mapping)

      #if l_Ini_Read.Status == status_code("SCIL_KEY_DOES_NOT_EXIST") #then #block
         #return "#"
      #block_end
      
   #block_end

   #when "BASE_SYSTEM_STATION" #block

      t_Attr_Mapping = "Station_B_Attributes"
      t_Obj_Section = "STATIONS"
      t_Key_Name_Prefix = "Station_B"

   #block_end

   #when "BASE_SYSTEM_STATION_TYPE" #block

      t_Attr_Mapping = "Station_Type_Attributes"
      t_Obj_Section = "STATION_TYPES"
      t_Key_Name_Prefix = "Station_Type"

   #block_end

   #when "NET_STATION" #block

      t_Attr_Mapping = "Station_N_Attributes"
      t_Obj_Section = "STATIONS"
      t_Key_Name_Prefix = "Station_N"

   #block_end

   #when "NET_LINK" #block

      t_Attr_Mapping = "Node_Link_Attributes"
      t_Obj_Section = "NODE_'i_Obj_Net_Nr'_LINKS"
      t_Key_Name_Prefix = "Node_Link"

   #block_end

#case_end

l_Ini_Read = read_parameter(t_System_Conf_File, "ATTRIBUTE_MAPPING", t_Attr_Mapping)
v_Ini_Values = separate(l_Ini_Read.VALUE, ",")
b_Found_as_Vector = false
b_Found_as_List = false
i_Attr_Index = find_element(v_Ini_Values, t_Attr_Name)

#if i_Attr_Index == 0 #then #block

   l_Ini_Read = read_parameter(t_System_Conf_File, "ATTRIBUTE_MAPPING", t_Attr_Mapping + "_Vector")

   #if l_Ini_Read.STATUS == 0 #then #block

      v_Ini_Values = separate(l_Ini_Read.VALUE, ",")
      i_Attr_Index = find_element(v_Ini_Values, t_Attr_Name)

      #if i_Attr_Index > 0 #then #block

         b_Found_as_Vector = true

         l_Ini_Read = read_parameter(t_System_Conf_File, t_Obj_Section, t_Key_Name_Prefix + "_'i_Obj_Nr'_'t_Attr_Name'_Vector")
         #if l_Ini_Read.STATUS == 0 #then #block
         
            v_Ini_Values = separate(l_Ini_Read.VALUE, ",")
            #if (t_Attr_Name == "XA" or t_Attr_Name == "NC" or t_Attr_Name == "SY") and length(l_Ini_Read.VALUE) == 0 #then #return vector()

            #if length(l_Ini_Read.VALUE) == 1 #then #block

               #if b_Return_as_Text #then #return "vector('l_Ini_Read.VALUE')"
               #else #return vector(evaluate(l_Ini_Read.VALUE))

            #block_end
;;;AAa
            #if length(l_Ini_Read.VALUE) <= 1 #then #return ""
;;;AAa
            #if substr(l_Ini_Read.VALUE, length(l_Ini_Read.VALUE) - 1, 2) == ",-" #then v_Ini_Values = v_Ini_Values(1 .. length(v_Ini_Values) - 1)
            #else #block

               v_Ini_Values_as_Text = separate(l_Ini_Read.VALUE, ",")
               v_Ini_Values_as_Real = vector()
               i_1 = 1

               #if t_Attr_Name == "XA" #then i_Offset = 6
               #else_if t_Attr_Name == "NC" #then i_Offset = 5
               #else_if t_Attr_Name == "SY" #then i_Offset = 2
               #else_if t_Attr_Name == "NE" #then i_Offset = 2
               #else_if t_Attr_Name == "IS" #then i_Offset = 2

               #loop (i_1 < (length(v_Ini_Values_as_Text) + 1))

                  #if t_Attr_Name == "XA" or t_Attr_Name == "NC" or -
                      t_Attr_Name == "SY" or t_Attr_Name == "NE" or t_Attr_Name == "IS" #then #block

                    v_Ini_Values_as_Real(length(v_Ini_Values_as_Real) + 1) = evaluate(collect(v_Ini_Values_as_Text((i_Offset * (length(v_Ini_Values_as_Real) + 1) - (i_Offset - 1)) .. (i_Offset * (length(v_Ini_Values_as_Real) + 1))), ","))
                    i_1 = i_1 + i_Offset

                  #block_end
                  #else #block

                     v_Ini_Values_as_Real(length(v_Ini_Values_as_Real) + 1) = evaluate(v_Ini_Values_as_Text(i_1))
                     i_1 = i_1 + 1

                  #block_end

               #loop_end

               #if t_Attr_Name == "XA" or t_Attr_Name == "NC" or -
                   t_Attr_Name == "SY" or t_Attr_Name == "NE" or t_Attr_Name == "IS" #then #return v_Ini_Values_as_Real
               #else_if t_Attr_Name <> "CT" #then #if b_Return_as_Text #then #return "vector('l_Ini_Read.VALUE')"
               #else #return v_Ini_Values_as_Real
            
            #block_end

            v_All_Values = v_Ini_Values

            #loop_with i = 2 .. 10000

               v_Ini_Values = vector()
               l_Ini_Read = read_parameter(t_System_Conf_File, t_Obj_Section, t_Key_Name_Prefix + "_'i_Obj_Nr'_'t_Attr_Name'_Vector_'i'")

               #if l_Ini_Read.STATUS == 0 #then #block

                  #if (t_Attr_Name == "XA" or t_Attr_Name == "NC" or -
                       t_Attr_Name == "SY" or t_Attr_Name == "NE" or t_Attr_Name == "IS") and l_Ini_Read.VALUE == "" #then #block

                     v_Current_Values = vector()
                     l_Ini_Read.VALUE = "  "

                  #block_end
                  #else v_Current_Values = separate(l_Ini_Read.VALUE, ",")

                  #if v_Current_Values(length(v_Current_Values)) == "-" #then #block

                     v_Current_Values = v_Current_Values(1 .. length(v_Current_Values) - 1)
                     v_All_Values = append(v_All_Values, v_Current_Values)

                  #block_end
                  #else #block

                     v_All_Values = append(v_All_Values, v_Current_Values)
                     v_Int_Values_as_Real = vector()
                     i_1 = 1

                     #if t_Attr_Name == "XA" #then i_Offset = 6
                     #else_if t_Attr_Name == "NC" #then i_Offset = 5
                     #else_if t_Attr_Name == "SY" #then i_Offset = 2
                     #else_if t_Attr_Name == "NE" #then i_Offset = 2
                     #else_if t_Attr_Name == "IS" #then i_Offset = 2

                     #loop (i_1 < (length(v_All_Values) + 1))

                        #if t_Attr_Name == "XA" or t_Attr_Name == "NC" or -
                            t_Attr_Name == "SY" or t_Attr_Name == "NE" or t_Attr_Name == "IS" #then #block

                           v_Int_Values_as_Real(length(v_Int_Values_as_Real) + 1) = evaluate(collect(v_All_Values((i_Offset * (length(v_Int_Values_as_Real) + 1) - (i_Offset - 1)) .. (i_Offset * (length(v_Int_Values_as_Real) + 1))), ","))
                           i_1 = i_1 + i_Offset

                        #block_end
                        #else #block

                           v_Int_Values_as_Real(length(v_Int_Values_as_Real) + 1) = evaluate(v_All_Values(i_1))
                           i_1 = i_1 + 1

                        #block_end

                     #loop_end

;                     #if t_Attr_Name <> "CT" #then #return v_Int_Values_as_Real   ?????
;                     #else #return v_Int_Values_as_Real                           ?????

                      #if t_Attr_Name == "XA" or t_Attr_Name == "NC" or -
                      t_Attr_Name == "SY" or t_Attr_Name == "NE" or t_Attr_Name == "IS" or -
                      t_Attr_Name == "CT" #then #return v_Int_Values_as_Real
                      #else_if b_Return_as_Text #then #block
                         t_tmp = collect(v_All_Values,",")
                         #return "vector('t_tmp')"
                      #block_end
                      #else #return v_Int_Values_as_Real

                  #block_end

               #block_end
               #else #loop_exit

            #loop_end

         #block_end
         #else #return "#"

      #block_end
      
      #else #block   ;LIST begin
      
         b_Found_as_List = true

         l_Ini_Read = read_parameter(t_System_Conf_File, t_Obj_Section, t_Key_Name_Prefix + "_'i_Obj_Nr'_'t_Attr_Name'_List")
         #if l_Ini_Read.STATUS == 0 #then #block
            
            #return evaluate(l_ini_read.VALUE)
            
         #block_end
      
      #block_end  ;LIST end

   #block_end

#block_end

#if not b_Found_as_Vector #then #block

   l_Ini_Read = read_parameter(t_System_Conf_File, t_Obj_Section, t_Key_Name_Prefix + "_'i_Obj_Nr'")

   #if l_Ini_Read.STATUS == 0 #then #block

      v_Ini_Values = separate(l_Ini_Read.VALUE, ",")

      #if substr(l_Ini_Read.VALUE, length(l_Ini_Read.VALUE), 1) <> "-" #then #block

         #if b_Return_as_Text #then #return v_Ini_Values(i_Attr_Index)
         #else #block

            #if i_Attr_Index == 0 #then #return list(STATUS = "SCF_ATTRIBUTE_NAME_NOT_FOUND")
            #if v_Ini_Values(i_Attr_Index) <> "" #then #return evaluate(v_Ini_Values(i_Attr_Index))
            #else #return "#"

         #block_end

      #block_end
      #else #block

         #if substr(l_Ini_Read.VALUE, length(l_Ini_Read.VALUE) - 1, 1) == "," #then v_Ini_Values = v_Ini_Values(1 .. length(v_Ini_Values) - 1)
 
         #else_if substr(l_Ini_Read.VALUE, length(l_Ini_Read.VALUE) - 1, 1) == "+" #then b_Continue = TRUE

         #loop_with i = 2 .. 10000

            l_Ini_Read = read_parameter(t_System_Conf_File, t_Obj_Section, t_Key_Name_Prefix + "_'i_Obj_Nr'_'i'")

            #if l_Ini_Read.STATUS == 0 #then #block

               v_Fields = separate(l_Ini_Read.VALUE, ",")

               #loop_with ii = 1 .. length(v_Fields)
                  #if b_Continue #then #block
                     v_Ini_Values(length(v_Ini_Values)) = -
                     substr(v_Ini_Values(length(v_Ini_Values)),1,length(v_Ini_Values(length(v_Ini_Values))) - 3 ) + substr(v_Fields(ii),2,length(v_Fields(ii))-1)
                     b_Continue = FALSE
                  #block_end
                  #else #block
                     v_Ini_Values(length(v_Ini_Values) + 1) = v_Fields(ii)
                  #block_end
               #loop_end
               
               #if substr(l_Ini_Read.VALUE, length(l_Ini_Read.VALUE), 1) == "-" #then #block

                  #if substr(l_Ini_Read.VALUE, length(l_Ini_Read.VALUE) - 1, 1) == "," #then v_Ini_Values = v_Ini_Values(1 .. length(v_Ini_Values) - 1)
                  
                  #else_if substr(l_Ini_Read.VALUE, length(l_Ini_Read.VALUE) - 1, 1) == "+" #then b_Continue = TRUE

               #block_end

            #block_end
            #else #loop_exit

         #loop_end

         #if length(v_Ini_Values(i_Attr_Index)) > 1 #then #block

            #if substr(v_Ini_Values(i_Attr_Index), length(v_Ini_Values(i_Attr_Index)) - 1, 1) == "+" #then #block

               t_Start_Line = substr(v_Ini_Values(i_Attr_Index), 1, length(v_Ini_Values(i_Attr_Index)) - 3)
               t_End_Line = substr(v_Ini_Values(i_Attr_Index + 1), 2, length(v_Ini_Values(i_Attr_Index + 1)) - 1)

               #if b_Return_as_Text #then #return t_Start_Line + t_End_Line
               #else #return evaluate(t_Start_Line + t_End_Line)

            #block_end

         #block_end

         #if b_Return_as_Text #then #return v_Ini_Values(i_Attr_Index)
;;         #else #return evaluate(v_Ini_Values(i_Attr_Index))
         #else_if v_Ini_Values(i_Attr_Index) <> "" #then #return evaluate(v_Ini_Values(i_Attr_Index))
            #else #return "#"

      #block_end

   #block_end

#block_end
; Method: GetErrStr()
; Version: 1.0
; Parameters:  SCIL status code
; Description: Returns SCIL error text
;------------------------------------

#argument i_Status_Code

#local t_Mnemonic = status_code_name(i_Status_Code)

#if t_Mnemonic == "" #then t_Mnemonic =  "Unknown status code"

#return t_Mnemonic

; Method: GetObjectNumbers(t_Passed_Type, [x_Passed_Information])
; Version: 1.0
; Parameters: t_Passed_Type, object type in request, e.g. "BASE_SYSTEM_STATION"
;             x_Passed_Information, additional parameter to specify the node links number
; Description: Reads the contents of instantiated object numbers into system configuration file.
; ----------------------------------------------------------------------------------------------

#case argument_count

   #when 1 @v_Return_Data = do(%Gv_SCT_Mgr__, "GETOBJNRS", argument(1))
   #when 2 @v_Return_Data = do(%Gv_SCT_Mgr__, "GETOBJNRS", "NET_LINK", argument(2))

#case_end

#if data_type(%v_Return_Data) == "TEXT" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_OBJECT_TYPE_DOES_NOT_EXIST")
   #else_if length(%v_Return_Data) == 1 #then #if %v_Return_Data(1) == 0 #then @v_Return_Data = vector()

#return list(STATUS = 0, DATA = %v_Return_Data)

; Method: GetObjectAttributes()
; Version: 1.0
; Description: Reads the contents of specified attribute of instantiated object in system configuration file.
; -----------------------------------------------------------------------------------------------------------

#case argument_count

   #when 2 @x_Return_Data = do(%Gv_SCT_Mgr__, "GetObjectAttribute", argument(1), argument(2), "acAll")
   #when 3 @x_Return_Data = do(%Gv_SCT_Mgr__, "GetObjectAttribute", "NODE_LINKS", argument(2), "acAll", argument(3))

#case_end

#return %x_Return_Data

; Method: PutObjectAttributes(t_Put_Attr_Type, i_Put_Number, l_Put_Attrs_and_Values)
; Version: 1.0
; Description: Updates contents of passed data in the configuration file.
; ----------------------------------------------------------------------------------

@t_Put_Attr_Type = argument(1)
@i_Put_Number = argument(2)
@l_Put_Attrs_and_Values = argument(3)
@i_Put_Net_Nr = 0
#if argument_count > 3 #then @i_Put_Net_Nr = argument(4)
@t_Put_Additional = ""
#if argument_count > 4 #then @t_Put_Additional = argument(5)

@b_Online = TRUE
@v_Values_as_Text = vector()
@i_Signal_Count = 1
@v_Put_Values = vector()
@l_System_Configuration_Data = SYS:BSV2
@t_System_Conf_File = l_System_Configuration_Data:vt_System_Configuration_File

#case %t_Put_Attr_Type

   #when "NET_STATION" @v_Put_Types = ("STATIONS", "Station_N_'i_Put_Number'", "NET_STATION", %t_Put_Attr_Type)
   #when "BASE_SYSTEM_STATION" @v_Put_Types = ("STATIONS", "Station_B_'i_Put_Number'", "BASE_SYSTEM_STATION", %t_Put_Attr_Type)
   #when "NODE_LINK" @v_Put_Types = ("NODE_'i_Put_Net_Nr'_LINKS", "Node_Link_'i_Put_Number'", "NODE_LINKS", "NET_LINK")

#case_end

@v_Attr_Names = do(%Gv_SCT_Mgr__, "GetObjAttrs", %v_Put_Types(4))
#if %t_Put_Attr_Type == "NET_STATION" #then @v_Attr_Names = delete_element(%v_Attr_Names, select(%v_Attr_Names, "==""HS"" or ==""MS"""))
   #else_if %t_Put_Attr_Type == "NODE_LINK" #then @v_Attr_Names = delete_element(%v_Attr_Names, select(%v_Attr_Names, "==""CF"" or ==""NC"" or ==""XA"""))

#if %t_Put_Attr_Type == "NODE_LINK" #then @l_Get_Status = do(%Gv_SCT_Mgr__, "GetObjectAttribute", %v_Put_Types(3), %i_Put_Number, "All", %i_Put_Net_Nr)
   #else @l_Get_Status = do(%Gv_SCT_Mgr__, "GetObjectAttribute", %v_Put_Types(3), %i_Put_Number, "All")

@v_New_Attrs = list_attr(%l_Put_Attrs_and_Values)
@b_Update_with_New_Attribute = FALSE

#if %t_Put_Attr_Type == "NET_STATION" #then #block

   #if length(select(%v_New_Attrs, "==""TC""")) > 0 #then #block

      ; Update TC value only for REX stations
      @l_Get_Base_Status = do(%Gv_SCT_Mgr__, "GetObjectAttribute", "BASE_SYSTEM_STATION", %i_Put_Number, "ST")
      #if l_Get_Base_Status:vSTATUS == 0 #then #if l_Get_Base_Status:vST <> "REX" #then #set l_Put_Attrs_and_Values:vTC = "#"

   #block_end

#block_end

#loop_with i_New = 1 .. length(%v_New_Attrs)

   ; Extends the attribute mapping if new attribute encountered
   @t_New_Attribute = %v_New_Attrs(%i_New)

   #if length(select(%v_Attr_Names, "==%t_New_Attribute")) == 0 #then #block

      #case %t_Put_Attr_Type

         #when "NET_STATION" #block

            @v_Attr_Names = append(%v_Attr_Names, %t_New_Attribute)
            @i_Status = write_parameter(%t_System_Conf_File, "ATTRIBUTE_MAPPING", "Station_N_Attributes", collect(%v_Attr_Names, ","))
            @b_Update_with_New_Attribute = TRUE
            #loop_exit

         #block_end

      #case_end

   #block_end

#loop_end

#if data_type(%l_Get_Status) == "LIST" #then #block

   @v_Attrs = list_attr(%l_Get_Status)

   #if %t_Put_Attr_Type == "NET_STATION" #then #block

      #loop_with i_3 = 1 .. length(%l_Get_Status)

         @t_Change_Name = %v_Attrs(%i_3)

         #if data_type(l_Get_Status:v't_Change_Name') == "TEXT" #then #block

            #if l_Get_Status:v't_Change_Name' == "" #then #set l_Get_Status:v't_Change_Name' = "#"

         #block_end

      #loop_end

   #block_end

#block_end

#if data_type(%l_Get_Status) <> "LIST" #then #block

   @l_Get_Status = list()
   #loop_with i_3 = 1 .. length(%v_Attr_Names)

      @t_Change_Name = %v_Attr_Names(%i_3)
      #set l_Get_Status:v't_Change_Name' = "#"

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

#loop_with i_3 = 1 .. length(%v_Put_Values)

   @v_Previous_Values_as_Text = %v_Values_as_Text
   #if data_type(%v_Put_Values(%i_3)) == "TEXT" #then #block

      #if %v_Put_Values(%i_3) == "#" #then @v_Values_as_Text = append(%v_Values_as_Text, "")
         #else @v_Values_as_Text = append(%v_Values_as_Text, collect(dump(%v_Put_Values(%i_3)), ","))

   #block_end
   #else @v_Values_as_Text = append(%v_Values_as_Text, collect(dump(%v_Put_Values(%i_3)), ","))

   @i_Row_Width = length(collect(%v_Values_as_Text, ","))

   #if %i_Row_Width > 200 #then #block

      #if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Previous_Values_as_Text, ",") + ",-")
      #else @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Previous_Values_as_Text, ",") + ",-")

      @v_Values_as_Text = vector(%v_Values_as_Text(length(%v_Values_as_Text)))
      @i_Signal_Count = %i_Signal_Count + 1

   #block_end

#loop_end

#if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Values_as_Text, ","))
#else @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Values_as_Text, ","))

#case upper_case(%t_Put_Attr_Type)

   #when "NODE_LINK" #block

      #if upper_case(%t_Put_Additional) == "ACONLINE" #then #block

         @i_Status = status
         #error ignore
            #set net'i_Put_Net_Nr':sIU'i_Put_Number' = 0
         #error stop
         @i_Status = status

         #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         @v_Node_Link_Attributes = list_attr(%l_Put_Attrs_and_Values)

         #loop_with i_Line_Specific_Count = 1 .. length(%v_Node_Link_Attributes)

            @t_Attribute_Name = %v_Node_Link_Attributes(%i_Line_Specific_Count)

            @i_Status = status
            #error ignore
               #set net'i_Put_Net_Nr':s't_Attribute_Name''i_Put_Number' = l_Put_Attrs_and_Values:v't_Attribute_Name'
            #error stop
            @i_Status = status

            #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         #loop_end

         @i_Status = status
         #error ignore
            #set net'i_Put_Net_Nr':sIU'i_Put_Number' = 1
         #error stop
         @i_Status = status

         #return list(STATUS = 0, ONLINE = %b_Online)

      #block_end

   #block_end

   #when "NET_STATION" #block

      #if data_type(%i_Put_Net_Nr) == "TEXT" #then #if upper_case(%i_Put_Net_Nr) == "ACONLINE" #then #block

         #if upper_case(%t_Put_Additional) <> "ACFIRSTCREATE" #then #block

            @i_Status = status
            #error ignore
               #set sta'i_Put_Number':sIU = 0
            #error stop
            @i_Status = status

            #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         #block_end

         @v_Station_N_Attributes = list_attr(%l_Put_Attrs_and_Values)

         #loop_with i_Station_Specific_Count = 1 .. length(%v_Station_N_Attributes)

            @t_Attribute_Name = %v_Station_N_Attributes(%i_Station_Specific_Count)

            #if %t_Attribute_Name <> "SM" and (%t_Attribute_Name <> "IU" and upper_case(%t_Put_Additional) <> "ACFIRSTCREATE") #then #block

               @i_Status = status
               #error ignore
                  #set sta'i_Put_Number':s't_Attribute_Name' = l_Put_Attrs_and_Values:v't_Attribute_Name'
               #error stop
               @i_Status = status

               #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

            #block_end

         #loop_end

         #if upper_case(%t_Put_Additional) <> "ACFIRSTCREATE" #then #block

            @i_Status = status
            #error ignore
               #set sta'i_Put_Number':sIU = 1
            #error stop
            @i_Status = status

         #block_end

         #if %b_Update_with_New_Attribute #then #block

            @l_All_Stations = do(%Gv_SCT_Mgr__, "GetObjectNumbers", "NET_STATION")
            @v_Update_Vector = vector()

            #if l_All_Stations:vSTATUS == 0 #then #block

               #loop_with i_Station_Ongoing = 1 .. length(l_All_Stations:vDATA)

                  @i_This_Nr = l_All_Stations:vDATA(%i_Station_Ongoing)

                  #if %i_This_Nr <> %i_Put_Number #then @v_Update_Vector(length(%v_Update_Vector) + 1) = -
                     "@l_Update_with_New_Attribute = do (%Gv_SCT_Mgr__, ""PutObjectAttributes"", ""NET_STATION"", 'i_This_Nr', list('t_New_Attribute' = ""#""))"

               #loop_end

               #do %v_Update_Vector
               @v_Update_Vector

            #block_end

         #block_end

         #return list(STATUS = 0, ONLINE = %b_Online)

      #block_end

   #block_end

   #when "BASE_SYSTEM_STATION" #block

      #if data_type(%i_Put_Net_Nr) == "TEXT" #then #if upper_case(%i_Put_Net_Nr) == "ACONLINE" #then #block

         @v_All_Station_B_Attributes = list_attr(%l_Put_Attrs_and_Values)

         #loop_with i_Station_Specific_Count = 1 .. length(%l_Put_Attrs_and_Values)

            @t_Attribute_Name = %v_All_Station_B_Attributes(%i_Station_Specific_Count)

            @i_Status = status
            #error ignore
               #set sta'i_Put_Number':b't_Attribute_Name' = l_Put_Attrs_and_Values:v't_Attribute_Name'
            #error stop
            @i_Status = status

            #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         #loop_end

         #return list(STATUS = 0, ONLINE = %b_Online)

      #block_end

   #block_end

#case_end

#return list(STATUS = 0)

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

@t_Get_Type = argument(1)
@i_Get_Nr = argument(2)

@t_Attr_Name = ""
@i_Get_Net_Nr = 0
#if argument_count > 2 #then @t_Attr_Name = argument(3)
#if argument_count > 3 and %t_Get_Type == "NODE_LINKS" #then @i_Get_Net_Nr = argument(4)

@b_Return_as_Text = FALSE
@l_System_Configuration_Data = SYS:BSV2
@t_System_Conf_File = l_System_Configuration_Data:vt_System_Configuration_File

#case %t_Get_Type
   #when "BASE_SYSTEM_NODE" @v_Get_Pars = ("Node_B_Attributes", "NODES", "Node_B", %t_Get_Type)
   #when "NET_NODE" @v_Get_Pars = ("Node_N_Attributes", "NODES", "Node_N", %t_Get_Type)
   #when "BASE_SYSTEM_LINK" @v_Get_Pars = ("Link_Attributes", "LINKS", "Link", %t_Get_Type)
   #when "NODE_LINKS" @v_Get_Pars = ("Node_Link_Attributes", "NODE_'i_Get_Net_Nr'_LINKS", "Node_Link", "NET_LINK")
   #when "NET_STATION" @v_Get_Pars = ("Station_N_Attributes", "STATIONS", "Station_N", %t_Get_Type)
   #when "BASE_SYSTEM_STATION" @v_Get_Pars = ("Station_B_Attributes", "STATIONS", "Station_B", %t_Get_Type)
#case_end

@v_Attr_Mapping = do(%Gv_SCT_Mgr__, "GetObjAttrs", %v_Get_Pars(4))
#if %t_Get_Type == "NET_STATION" #then @v_Attr_Mapping = delete_element(%v_Attr_Mapping, select(%v_Attr_Mapping, "==""HS"" or ==""MS"""))
   #else_if %t_Get_Type == "NODE_LINKS" #then @v_Attr_Mapping = delete_element(%v_Attr_Mapping, select(%v_Attr_Mapping, "==""CF"" or ==""NC"" or ==""XA"""))

@b_Found_as_Vector = FALSE
@i_Attr_Index = 0
@v_Found_Index = select(upper_case(%v_Attr_Mapping), "==upper_case(%t_Attr_Name)")

#if length(%v_Found_Index) > 0 #then @i_Attr_Index = %v_Found_Index(1)
#else #block

   @b_Found_as_Vector = TRUE
   @l_Ini_Read = read_parameter(%t_System_Conf_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Get_Nr'")

   #if l_Ini_Read:vSTATUS == 0 #then #block

      @v_Ini_Values = separate(l_Ini_Read:vVALUE, ",")

      #if length(l_Ini_Read:vVALUE) == 1 #then #return vector(evaluate(l_Ini_Read:vVALUE))

      #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == ",-" #then @v_Ini_Values = %v_Ini_Values(1 .. length(%v_Ini_Values) - 1)
      #else_if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == "+-" #then @b_Continue = TRUE
      #else #block

         @v_Ini_Values_as_Text = separate(l_Ini_Read:vVALUE, ",")
         @v_Ini_Values_as_Real = vector()
         @i_1 = 1

         #loop (%i_1 < (length(%v_Ini_Values_as_Text) + 1))

            #if %v_Ini_Values_as_Text(%i_1) == "" #then @v_Ini_Values_as_Text(%i_1) = """#"""
            @v_Ini_Values_as_Real(length(%v_Ini_Values_as_Real) + 1) = evaluate(%v_Ini_Values_as_Text(%i_1))
            @i_1 = %i_1 + 1

         #loop_end

         @l_Return_Data = list()

         #loop_with i_2 = 1 .. length(%v_Attr_Mapping)

            @t_Attr_Mapping = %v_Attr_Mapping(%i_2)

            #if %i_2 > length(%v_Ini_Values_as_Real) #then #set l_Return_Data:v't_Attr_Mapping' = ""
               #else #set l_Return_Data:v't_Attr_Mapping' = %v_Ini_Values_as_Real(%i_2)

         #loop_end

         #return %l_Return_Data

      #block_end

      #loop_with i = 2 .. 10000

         @l_Ini_Read = read_parameter(%t_System_Conf_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Get_Nr'_'i'")

         #if l_Ini_Read:vSTATUS == 0 #then #block

               @v_Current_Values = separate(l_Ini_Read:vVALUE, ",")

               #loop_with j = 1 .. length(%v_Current_Values)
                  #if %b_Continue #then #block
                     @v_Ini_Values(length(%v_Ini_Values)) = -
                     substr(%v_Ini_Values(length(%v_Ini_Values)),1,length(%v_Ini_Values(length(%v_Ini_Values)))-3 ) + substr(%v_Current_Values(%j),2,length(%v_Current_Values(%j))-1)
                     @b_Continue = FALSE
                  #block_end
                  #else #block
                     @v_Ini_Values(length(%v_Ini_Values) + 1) = %v_Current_Values(%j)
                  #block_end
               #loop_end
               
               #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE), 1) == "-" #then #block

                  #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 1) == "," #then #block
                     @v_Ini_Values = %v_Ini_Values(1 .. length(%v_Ini_Values) - 1)
                  #block_end
                  
                  #else_if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 1) == "+" #then @b_Continue = TRUE

               #block_end
               #else #block

                  @v_Int_Values_as_Real = vector()
                  @i_1 = 1
   
                  #loop (%i_1 < (length(%v_Ini_Values) + 1))
   
                     @v_Int_Values_as_Real(length(%v_Int_Values_as_Real) + 1) = %v_Ini_Values(%i_1)
                     @i_1 = %i_1 + 1
   
                  #loop_end
                  
                  #return %v_Int_Values_as_Real
   
               #block_end

            #block_end
            #else #loop_exit
         
      #loop_end
      
   #block_end
   #else #return "#"

#block_end

#if not %b_Found_as_Vector #then #block

   @l_Ini_Read = read_parameter(%t_System_Conf_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Get_Nr'")

   #if l_Ini_Read:vSTATUS == 0 #then #block

      @v_Ini_Values = separate(l_Ini_Read:vVALUE, ",")

      #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE), 1) <> "-" #then #block

         #if %b_Return_as_Text #then #return %v_Ini_Values(%i_Attr_Index)
         #else #block

            #if %i_Attr_Index == 0 #then #return list(STATUS = -1, DESCRIPTIVE_TEXT = "SCM_ATTRIBUTE_NOT_FOUND")

            ; #if %v_Ini_Values(%i_Attr_Index) <> "" #then #return list(STATUS = 0, 't_Attr_Name' = %v_Ini_Values_as_Real(%i_Attr_Index))
            #if %v_Ini_Values(%i_Attr_Index) <> "" #then #return list(STATUS = 0, 't_Attr_Name' = evaluate(%v_Ini_Values(%i_Attr_Index)))
               #else #return list(STATUS = -1)

         #block_end

      #block_end
      #else #block

         #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 2) == "+-" #then @b_List = TRUE
         #else @b_List = FALSE
         
         #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 1) == "," #then @v_Ini_Values = %v_Ini_Values(1 .. length(%v_Ini_Values) - 1)

         #loop_with i = 2 .. 10000

            @l_Ini_Read = read_parameter(%t_System_Conf_File, %v_Get_Pars(2), %v_Get_Pars(3) + "_'i_Get_Nr'_" + dec(%i, 0))

            #if l_Ini_Read:vSTATUS == 0 #then #block

               @v_Ini_Values = append(%v_Ini_Values, separate(l_Ini_Read:vVALUE, ","))

               #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE), 1) == "-" #then #block

                  #if substr(l_Ini_Read:vVALUE, length(l_Ini_Read:vVALUE) - 1, 1) == "," #then @v_Ini_Values = %v_Ini_Values(1 .. length(%v_Ini_Values) - 1)

               #block_end

            #block_end
            #else #loop_exit

         #loop_end
         
         @v_Combined = vector()
         @v_Delete_Index = vector()
         
         #loop_with k = 1 .. length(%v_Ini_Values)
         
            #if length(%v_Ini_Values(%k)) > 1 #then @x = substr(%v_Ini_Values(%k),length(%v_Ini_Values(%k)) - 1, 2)
            #else @x = ""
            
            #if %x == "+-" #then #block
            
               @y = dump(evaluate(substr(%v_Ini_Values(%k), 1, length(%v_Ini_Values(%k)) - 2)) + evaluate(substr(%v_Ini_Values(%k+1), 1, length(%v_Ini_Values(%k+1)))), 1000)
               @v_Combined(length(%v_Combined) + 1) = %y(1)
               @v_Delete_Index(length(%v_Delete_Index) + 1) = %k+1
            
            #block_end
            #else @v_Combined(length(%v_Combined)+1) = %v_Ini_Values(%k)
         
         #loop_end
         
         @v_Combined = delete_element(%v_Combined, %v_Delete_Index)
         
         @v_Ini_Values = %v_Combined

         #if length(%v_Ini_Values(%i_Attr_Index)) > 1 #then #block

            #if substr(%v_Ini_Values(%i_Attr_Index), length(%v_Ini_Values(%i_Attr_Index)) - 1, 1) == "+" #then #block

               @t_Start_Line = substr(%v_Ini_Values(%i_Attr_Index), 1, length(%v_Ini_Values(%i_Attr_Index)) - 3)
               @t_End_Line = substr(%v_Ini_Values(%i_Attr_Index + 1), 2, length(%v_Ini_Values(%i_Attr_Index + 1)) - 1)
               #return evaluate(%t_Start_Line + %t_End_Line)

            #block_end

         #block_end

         #if %b_Return_as_Text #then #return %v_Ini_Values(%i_Attr_Index)
         #else #block
            #if %b_List #then #return list(STATUS = 0, 't_Attr_Name' = evaluate(%v_Ini_Values(%i_Attr_Index)))
               #else #return evaluate(%v_Ini_Values(%i_Attr_Index))
         #block_end

      #block_end

   #block_end

#block_end

; Method: CreateObject(t_Create_Type, i_Create_Number, l_Create_Attrs_and_Values, [i_Create_Net_Nr])
; Version: 1.0
; Description: Updates contents of passed data in the configuration file.
; --------------------------------------------------------------------------------------------------

@t_Create_Type = argument(1)
@i_Create_Number = argument(2)
@l_Create_Attrs_and_Values = argument(3)
@i_Create_Net_Nr = 0
#if argument_count > 3 #then @i_Create_Net_Nr = argument(4)

@i_Status = status
#error ignore
   @b_Open = ROOT\mdl_Attr_Def._open
#error stop
#if status <> 0 #then .load ROOT\mdl_Attr_Def = vs_main_dialog("sys_tool/Attr_Def.vso", "MAIN")

@b_Online = FALSE

#case upper_case(%t_Create_Type)

   #when "NET_STATION" #block

      #if length(select(upper_case(list_attr(%l_Create_Attrs_and_Values)), "==""COMMUNICATION_CHANNEL""")) == 0 #then -
         #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_OBJECT_COMMUNICATION_CHANNEL_PARAMETER_NOT_FOUND_ERROR")
      #if edit(l_Create_Attrs_and_Values:vCOMMUNICATION_CHANNEL, "TRIM") == "" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_OBJECT_COMMUNICATION_CHANNEL_EMPTY_STRING_ERROR")
      @l_Station_Type = do (%Gv_SCT_Mgr__, "GetObjectAttribute", "BASE_SYSTEM_STATION", %i_Create_Number, "ST")
      #if data_type(%l_Station_Type) <> "LIST" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_OBJECT_READ_ATTRIBUTE_ERROR")
      @v_Create_All_Attrs = ROOT\mdl_Attr_Def.Return_Attributes("NET_STATION", l_Station_Type:vST)
      @l_Create_Put_Attrs_and_Values = list()

      #loop_with i_Create_Object = 1 .. length(%v_Create_All_Attrs)

         @t_Create_Attr = %v_Create_All_Attrs(%i_Create_Object)
         #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = "#"
         @l_Attribute_Data = ROOT\mdl_Attr_Def.Return_Attribute_Definition("NET_STATION", %t_Create_Attr, l_Station_Type:vST)
         #if length(select(list_attr(%l_Attribute_Data), "==""DEFAULT_VALUE""")) > 0 #then #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = l_Attribute_Data:vDEFAULT_VALUE

      #loop_end

      @v_Create_Attrs = list_attr(%l_Create_Attrs_and_Values)
      #modify l_Create_Put_Attrs_and_Values:v = list(AL = 1, IU = 1, MI = 1000 + %i_Create_Number)
      @v_Station_Specific_Attributes = vector()
      @v_Station_Specific_Values = vector()

      #loop_with i_Create_Object = 1 .. length(%v_Create_Attrs)

         @t_Create_Attr = %v_Create_Attrs(%i_Create_Object)
         #if upper_case(%t_Create_Attr) == "COMMUNICATION_CHANNEL" #then #block

            @l_Link_Number_Status = do (%Gv_SCT_Mgr__, "GetObjectNumbers", "BASE_SYSTEM_LINK")
            #if l_Link_Number_Status:vSTATUS <> 0 #then #return %l_Link_Number_Status
            #if l_Link_Number_Status:vDATA(1) == 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_OBJECT_NO_BASE_SYSTEM_LINK_FOUND")
            @l_Line_Number_Status = do (%Gv_SCT_Mgr__, "GetObjectNumbers", "NET_LINK", l_Link_Number_Status:vDATA(1))
            #if l_Line_Number_Status:vSTATUS <> 0 #then #return %l_Line_Number_Status

            #loop_with i_Line_Count = 1 .. length(l_Line_Number_Status:vDATA)

               @l_SD_Attribute_Value = do (%Gv_SCT_Mgr__, "GetObjectAttribute", "NODE_LINKS", l_Line_Number_Status:vDATA(%i_Line_Count), "SD", l_Link_Number_Status:vDATA(1))
               #if l_SD_Attribute_Value:vSTATUS <> 0 #then #return %l_SD_Attribute_Value
               #else_if upper_case(l_SD_Attribute_Value:vSD) == upper_case(l_Create_Attrs_and_Values:vCOMMUNICATION_CHANNEL) #then #block

                  @i_Link_Number = l_Link_Number_Status:vDATA(1)

                  #set l_Create_Put_Attrs_and_Values:vLI = l_Line_Number_Status:vDATA(%i_Line_Count)
                  #if data_type(%i_Create_Net_Nr) == "TEXT" #then #if upper_case(%i_Create_Net_Nr) == "ACONLINE" #then #block

                     #if l_Station_Type:vST == "REX" #then @t_Two_Char = "RX"
                        #else_if l_Station_Type:vST == "SPA" #then @t_Two_Char = "SP"
                           #else_if l_Station_Type:vST == "LMK" #then @t_Two_Char = "LM"
                              #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_CREATE_OBJECT_NOT_SUPPORT_STATION_TYPE_ERROR")

                     @i_Status = status
                     #error ignore
                        #set net'i_Link_Number':s't_Two_Char''i_Create_Number' = l_Line_Number_Status:vDATA(%i_Line_Count)
                     #error stop
                     @i_Status = status

                     #if %i_Status == 0 #then @b_Online = TRUE

                  #block_end
                  #loop_exit

               #block_end

            #loop_end

         #block_end
         #else #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = l_Create_Attrs_and_Values:v't_Create_Attr'

      #loop_end

      #case upper_case(l_Station_Type:vST)

         #when "REX" #block

            @v_Station_Specific_Attributes = ("SC", "SS", "SI", "SR", "RM", "NN", "SN", "UN", "EF", "HI", "SK")
            @v_Station_Specific_Values = (500, 500, 5000, 2000, 7, %i_Create_Number, 1, %i_Create_Number, 2, 0, 60000)
            @v_Station_Exclude_Attributes = ("AS", "MS", "OS", "SM", "LI", "SH", "HS", "IU")

         #block_end

         #when "SPA" #block

            @v_Station_Specific_Attributes = vector("SA", "UT", "EP")
            @v_Station_Specific_Values = vector(%i_Create_Number, 0, 1)
            @v_Station_Exclude_Attributes = ("AS", "MS", "OS", "LI", "RL", "SM", "ST", "UP", "IU")

         #block_end

         #when "LMK" #block

            @v_Station_Specific_Attributes = vector("UT", "CT", "DI", "NN", "SN")
            @v_Station_Specific_Values = vector(3, 20, 10, %i_Create_Number, 1)
            @v_Station_Exclude_Attributes = ("AS", "MS", "OS", "LI", "LM", "IU")

         #block_end

      #case_end

      #loop_with i_Station_Specific_Count = 1 .. length(%v_Station_Specific_Attributes)

         @t_Station_Specific_Attribute = %v_Station_Specific_Attributes(%i_Station_Specific_Count)
         #if length(select(list_attr(%l_Create_Attrs_and_Values), "==%t_Station_Specific_Attribute")) == 0 #then #set l_Create_Put_Attrs_and_Values:v't_Station_Specific_Attribute' = %v_Station_Specific_Values(%i_Station_Specific_Count)

      #loop_end

      #if length(select(list_attr(%l_Create_Put_Attrs_and_Values), "==""HS""")) > 0 #then #delete l_Create_Put_Attrs_and_Values:vHS
      #if length(select(list_attr(%l_Create_Put_Attrs_and_Values), "==""MS""")) > 0 #then #delete l_Create_Put_Attrs_and_Values:vMS

      #if data_type(%i_Create_Net_Nr) <> "TEXT" #then @l_Create_Status = do (%Gv_SCT_Mgr__, "PutObjectAttributes", "NET_STATION", %i_Create_Number, %l_Create_Put_Attrs_and_Values)
         #else @l_Create_Status = do (%Gv_SCT_Mgr__, "PutObjectAttributes", "NET_STATION", %i_Create_Number, %l_Create_Put_Attrs_and_Values, "acOnline", "acFirstCreate")

      @l_System_Configuration_Data = SYS:BSV2
      @t_System_Conf_File = l_System_Configuration_Data:vt_System_Configuration_File
      @l_Status = write_parameter(%t_System_Conf_File, "STATIONS", "Station_N_'i_Create_Number'_MS_Vector", dec(APL:BAN, 0))
      #if l_Status:vSTATUS <> 0 #then #set l_Create_Status:vSTATUS = l_Status:vSTATUS
      #else_if upper_case(l_Station_Type:vST) == "REX" #then #block

         @l_Status = write_parameter(%t_System_Conf_File, "STATIONS", "Station_N_'i_Create_Number'_HS_Vector", "567993600,0")
         #if l_Status:vSTATUS <> 0 #then #set l_Create_Status:vSTATUS = l_Status:vSTATUS

      #block_end

      ; Online flag is set for the system configuration
      #if data_type(%i_Create_Net_Nr) == "TEXT" #then #if upper_case(%i_Create_Net_Nr) == "ACONLINE" #then #block

         @v_All_Station_N_Attributes = list_attr(%l_Create_Put_Attrs_and_Values)

         #loop_with i_Station_Specific_Count = 1 .. length(%l_Create_Put_Attrs_and_Values)

            @t_Attribute_Name = %v_All_Station_N_Attributes(%i_Station_Specific_Count)

            #if length(select(%v_Station_Exclude_Attributes, "==%t_Attribute_Name")) == 0 #then #block

               @i_Status = status
               #error ignore
                  #set sta'i_Create_Number':s't_Attribute_Name' = l_Create_Put_Attrs_and_Values:v't_Attribute_Name'
               #error stop
               @i_Status = status

               #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

            #block_end

         #loop_end

         @i_Status = status
         #error ignore
            #set sta'i_Create_Number':sIU = l_Create_Put_Attrs_and_Values:vIU
         #error stop
         @i_Status = status

         #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         #set l_Create_Status:vONLINE = %b_Online

      #block_end

      #return %l_Create_Status

   #block_end

   #when "BASE_SYSTEM_STATION" #block

      @v_Create_All_Attrs = ROOT\mdl_Attr_Def.Return_Attributes("BASE_SYSTEM_STATION")
      @l_Create_Put_Attrs_and_Values = list()

      #loop_with i_Create_Object = 1 .. length(%v_Create_All_Attrs)

         @t_Create_Attr = %v_Create_All_Attrs(%i_Create_Object)
         #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = "#"
         @l_Attribute_Data = ROOT\mdl_Attr_Def.Return_Attribute_Definition("BASE_SYSTEM_STATION", %t_Create_Attr)
         #if length(select(list_attr(%l_Attribute_Data), "==""DEFAULT_VALUE""")) > 0 #then #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = l_Attribute_Data:vDEFAULT_VALUE

      #loop_end

      @v_Create_Attrs = list_attr(%l_Create_Attrs_and_Values)
      @l_Link_Number_Status = do (%Gv_SCT_Mgr__, "GetObjectNumbers", "BASE_SYSTEM_LINK")
      #if l_Link_Number_Status:vSTATUS <> 0 #then #return %l_Link_Number_Status
      #modify l_Create_Put_Attrs_and_Values:v = list(CX = "", TN = %i_Create_Number, ND = l_Link_Number_Status:vDATA(1))

      #loop_with i_Create_Object = 1 .. length(%v_Create_Attrs)

         @t_Create_Attr = %v_Create_Attrs(%i_Create_Object)
         #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = l_Create_Attrs_and_Values:v't_Create_Attr'

      #loop_end

      @l_Create_Status = do (%Gv_SCT_Mgr__, "PutObjectAttributes", "BASE_SYSTEM_STATION", %i_Create_Number, %l_Create_Put_Attrs_and_Values)
      #if l_Create_Status:vSTATUS <> 0 #then #return %l_Create_Status
      @l_Number_Status = do (%Gv_SCT_Mgr__, "PutObjectNumber", "BASE_SYSTEM_STATION", %i_Create_Number)

      #if l_Number_Status:vSTATUS == 0 and data_type(%i_Create_Net_Nr) == "TEXT" #then #block

         #if not l_Number_Status:vEXIST and upper_case(%i_Create_Net_Nr) == "ACONLINE" #then #block

            #if upper_case(sta'i_Create_Number':bST) == "NONE" #then #block

               @i_Status = status
               #error ignore
                  #create sta'i_Create_Number':b = %l_Create_Put_Attrs_and_Values
               #error stop
               @i_Status = status

               #set l_Number_Status:vONLINE = (%i_Status == 0)

            #block_end
            #else #block

               @v_Station_B_Attributes = list_attr(%l_Create_Put_Attrs_and_Values)

               #loop_with i_Station_B_Count = 1 .. length(%v_Station_B_Attributes)

                  @t_Attribute_Name = %v_Station_B_Attributes(%i_Station_B_Count)

                  @i_Status = status
                  #error ignore
                     #set sta'i_Create_Number':b't_Attribute_Name' = l_Create_Put_Attrs_and_Values:v't_Attribute_Name'
                  #error stop
                  @i_Status = status

                  #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

               #loop_end

            #block_end

         #block_end
         #else #set l_Number_Status:vONLINE = FALSE

      #block_end

      #return %l_Number_Status

   #block_end

   #when "NODE_LINK" #block

      @v_Create_All_Attrs = ROOT\mdl_Attr_Def.Return_Attributes("NET_LINK")
      @v_Create_All_Protocol_Attrs = ROOT\mdl_Attr_Def.Return_Attributes("NET_LINK", l_Create_Attrs_and_Values:vPO)
      #if length(select((14, 27), "==l_Create_Attrs_and_Values:vPO")) == 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_CREATE_OBJECT_NOT_SUPPORT_NODE_LINK_PROTOCOL_ERROR")

      @l_Create_Put_Attrs_and_Values = list()

      #loop_with i_Create_Object = 1 .. length(%v_Create_All_Attrs)

         @t_Create_Attr = upper_case(%v_Create_All_Attrs(%i_Create_Object))
         #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = "#"

         #if length(select(upper_case(%v_Create_All_Protocol_Attrs), "==%t_Create_Attr")) > 0 #then #block

            @l_Attribute_Data = ROOT\mdl_Attr_Def.Return_Attribute_Definition("NET_LINK", %t_Create_Attr, l_Create_Attrs_and_Values:vPO)
            #if length(select(list_attr(%l_Attribute_Data), "==""DEFAULT_VALUE""")) > 0 #then #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = l_Attribute_Data:vDEFAULT_VALUE

         #block_end

      #loop_end

      @v_Create_Attrs = list_attr(%l_Create_Attrs_and_Values)
      @l_Link_Number_Status = do (%Gv_SCT_Mgr__, "GetObjectNumbers", "BASE_SYSTEM_LINK")
      #if l_Link_Number_Status:vSTATUS <> 0 #then #return %l_Link_Number_Status
      #modify l_Create_Put_Attrs_and_Values:v = list(IU = 1, MI = 6000 + (100 * l_Link_Number_Status:vDATA(1)) + %i_Create_Number, MS = APL:BAN)

      #if data_type(%i_Create_Net_Nr) == "TEXT" #then #if upper_case(%i_Create_Net_Nr) == "ACONLINE" #then #block

         @i_Link_Number = l_Link_Number_Status:vDATA(1)

         @i_Status = status
         #error ignore
            #set net'i_Link_Number':sPO'i_Create_Number' = l_Create_Attrs_and_Values:vPO
         #error stop
         @i_Status = status

         #if %i_Status <> 0 #then @b_Online = FALSE
            #else @b_Online = TRUE

      #block_end

      #loop_with i_Create_Object = 1 .. length(%v_Create_Attrs)

         @t_Create_Attr = %v_Create_Attrs(%i_Create_Object)
         #set l_Create_Put_Attrs_and_Values:v't_Create_Attr' = l_Create_Attrs_and_Values:v't_Create_Attr'

      #loop_end

      @v_Line_Specific_Attributes = vector()
      @v_Line_Specific_Values = vector()

      #case l_Create_Attrs_and_Values:vPO

         #when 27 #block ; LON

            @v_Line_Specific_Attributes = vector("PS", "LK", "PD")
            @v_Line_Specific_Values = vector(200, 3, 7)
            @v_Line_Exclude_Attributes = vector("IU")

         #block_end

         #when 14 #block ; SPA

            @v_Line_Specific_Attributes = vector("BR", "DE", "SB", "PP", "PS", "PD")
            @v_Line_Specific_Values = vector(9600, 500, 1, 10, 50, 7)
            @v_Line_Exclude_Attributes = vector("TD", "IU")

         #block_end

      #case_end

      #loop_with i_Line_Specific_Count = 1 .. length(%v_Line_Specific_Attributes)

         @t_Line_Specific_Attribute = %v_Line_Specific_Attributes(%i_Line_Specific_Count)
         #if length(select(list_attr(%l_Create_Attrs_and_Values), "==%t_Line_Specific_Attribute")) == 0 #then #set l_Create_Put_Attrs_and_Values:v't_Line_Specific_Attribute' = %v_Line_Specific_Values(%i_Line_Specific_Count)

      #loop_end

      @l_Create_Status = do (%Gv_SCT_Mgr__, "PutObjectAttributes", "NODE_LINK", %i_Create_Number, %l_Create_Put_Attrs_and_Values, l_Link_Number_Status:vDATA(1))
      #if l_Create_Status:vSTATUS <> 0 #then #return %l_Create_Status
      @l_Number_Status = do (%Gv_SCT_Mgr__, "PutObjectNumber", "NODE_LINK", %i_Create_Number, l_Link_Number_Status:vDATA(1))

      #if l_Number_Status:vSTATUS == 0 and data_type(%i_Create_Net_Nr) == "TEXT" #then #block

         #if not l_Number_Status:vEXIST and upper_case(%i_Create_Net_Nr) == "ACONLINE" #then #block

            #delete l_Create_Put_Attrs_and_Values:vPO
            @v_All_Line_N_Attributes = list_attr(%l_Create_Put_Attrs_and_Values)
            @i_Link_Number = l_Link_Number_Status:vDATA(1)

            #loop_with i_Line_Specific_Count = 1 .. length(%l_Create_Put_Attrs_and_Values)

               @t_Attribute_Name = %v_All_Line_N_Attributes(%i_Line_Specific_Count)
               @v_Try = dump(l_Create_Put_Attrs_and_Values:v't_Attribute_Name')

               #if %v_Try(1) <> """#""" #then #block

                  #if length(select(%v_Line_Exclude_Attributes, "==%t_Attribute_Name")) == 0 #then #block

                     @i_Status = status
                     #error ignore
                        #set net'i_Link_Number':s't_Attribute_Name''i_Create_Number' = l_Create_Put_Attrs_and_Values:v't_Attribute_Name'
                     #error stop
                     @i_Status = status

                     #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

                  #block_end

               #block_end

            #loop_end

         #block_end

         @i_Status = status
         #error ignore
            #set net'i_Link_Number':sIU'i_Create_Number' = l_Create_Put_Attrs_and_Values:vIU
         #error stop
         @i_Status = status

         #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         #set l_Number_Status:vONLINE = %b_Online

      #block_end

      #return %l_Number_Status

   #block_end

#case_end

#return list(STATUS = 0)

; Method: PutObjectNumber(t_Put_Type, i_Put_Number, [x_Put_Addition], [t_Operation_Mode])
; Version: 1.0
; Description: Update object numbers to the configuration file
; ---------------------------------------------------------------------------------------

@t_Put_Type = argument(1)
@i_Put_Number = argument(2)
@x_Put_Addition = 0
#if argument_count > 2 #then @x_Put_Addition = argument(3)
@t_Operation_Mode = "acAdd"
#if argument_count > 3 #then @t_Operation_Mode = argument(4)

@v_Numbers_as_Text = vector()
@i_Signal_Count = 1
@b_Exist_Flag = FALSE
@l_System_Configuration_Data = SYS:BSV2
@t_System_Conf_File = l_System_Configuration_Data:vt_System_Configuration_File

#if %x_Put_Addition < 1 #then @l_Inside_SCM = do(%Gv_SCT_Mgr__, "GetObjectNumbers", %t_Put_Type)
   #else @l_Inside_SCM = do(%Gv_SCT_Mgr__, "GetObjectNumbers", %t_Put_Type, %x_Put_Addition)

#if l_Inside_SCM:vSTATUS <> 0 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_READ_OBJECT_NUMBERS_ERROR")

#case upper_case(%t_Operation_Mode)
   #when "ACADD" #if length(select(l_Inside_SCM:vDATA, "==%i_Put_Number")) > 0 #then #return list(STATUS = 0, EXIST = TRUE)
   #when "ACDELETE" #if length(select(l_Inside_SCM:vDATA, "==%i_Put_Number")) > 0 #then @b_Exist_Flag = TRUE
#case_end

#if upper_case(%t_Operation_Mode) == "ACADD" #then @v_Put_Numbers = append(l_Inside_SCM:vDATA, %i_Put_Number)
   #else_if upper_case(%t_Operation_Mode) == "ACDELETE" #then @v_Put_Numbers = delete_element(l_Inside_SCM:vDATA, select(l_Inside_SCM:vDATA, "==%i_Put_Number"))
@v_Put_Numbers = pick(%v_Put_Numbers, sort(%v_Put_Numbers))

;ID 7502/MF 1.6.2004
#if upper_case(%t_Operation_Mode) == "ACDELETE" and upper_case(%t_Put_Type) == "BASE_SYSTEM_STATION" #then -
   @v_Put_Numbers = remove_duplicates(%v_Put_Numbers)

#case upper_case(%t_Put_Type)

   #when "BASE_SYSTEM_STATION" @v_Put_Types = ("STATIONS", "Station_Numbers")
   #when "NODE_LINK" @v_Put_Types = ("NODE_'x_Put_Addition'_LINKS", "Node_Link_Numbers")

#case_end

#loop_with i_3 = 1 .. length(%v_Put_Numbers)

   @v_Previous_Numbers_as_Text = %v_Numbers_as_Text
   @v_Numbers_as_Text = append(%v_Numbers_as_Text, collect(dump(%v_Put_Numbers(%i_3)), ","))
   @i_Row_Width = length(collect(%v_Numbers_as_Text, ","))

   #if %i_Row_Width > 200 #then #block

      #if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Previous_Numbers_as_Text, ",") + ",-")
      #else @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Previous_Numbers_as_Text, ",") + ",-")

      @v_Numbers_as_Text = vector(%v_Numbers_as_Text(length(%v_Numbers_as_Text)))
      @i_Signal_Count = %i_Signal_Count + 1

   #block_end

#loop_end

#if %i_Signal_Count == 1 #then @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2), collect(%v_Numbers_as_Text, ","))
#else @i_Status = write_parameter(%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_Signal_Count'", collect(%v_Numbers_as_Text, ","))

;ID 7502/MF 1.6.2004
#if upper_case(%t_Operation_Mode) == "ACDELETE" and upper_case(%t_Put_Type) == "BASE_SYSTEM_STATION" #then #block
   @i_3 = %i_Signal_Count+1
   @i_Status = delete_parameter (%t_System_Conf_File, %v_Put_Types(1), %v_Put_Types(2) + "_'i_3'")
#block_end

#return list(STATUS = 0, EXIST = %b_Exist_Flag)

; Method: DeleteObjectNumber(t_Delete_Type, i_Delete_Number, [x_Put_Addition], [t_Operation_Mode])
; Version: 1.0
; Description: Update object numbers to the configuration file
; ------------------------------------------------------------

#case argument_count

   #when 2 @l_Delete_Status = do (%Gv_SCT_Mgr__, "PutObjectNumber", argument(1), argument(2), -1, "acDelete")
   #when 3 @l_Delete_Status = do (%Gv_SCT_Mgr__, "PutObjectNumber", argument(1), argument(2), argument(3), "acDelete")
   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_OBJECT_NUMBER_PARAMETER_ERROR")

#case_end

#return %l_Delete_Status

; Method: DeleteObject(t_Delete_Type, i_Delete_Number, [i_Delete_Net_Nr])
; Version: 1.0
; Description: Updates contents of passed data in the configuration file.
; --------------------------------------------------------------------------------------------------

@t_Delete_Type = argument(1)
@i_Delete_Number = argument(2)
@i_Delete_Net_Nr = 0
#if argument_count > 2 #then @i_Delete_Net_Nr = argument(3)
@t_Delete_Additional = ""
#if argument_count > 3 #then @t_Delete_Additional = argument(4)

@b_Online = TRUE
@l_System_Configuration_Data = SYS:BSV2
@t_System_Conf_File = l_System_Configuration_Data:vt_System_Configuration_File

#case upper_case(%t_Delete_Type)

   #when "BASE_SYSTEM_STATION", "NET_STATION" #block

      #if upper_case(%t_Delete_Type) == "BASE_SYSTEM_STATION" #then #block

         @l_Delete_Object_Status = do (%Gv_SCT_Mgr__, "PutObjectNumber", argument(1), argument(2), -1, "acDelete")
         #if l_Delete_Object_Status:vSTATUS <> 0 #then #return %l_Delete_Object_Status

      #block_end

      @t_Delete_Sign = substr(%t_Delete_Type, 1, 1)
      @v_Delete_Types = ("STATIONS", "Station_'t_Delete_Sign'_'i_Delete_Number'")

      #if upper_case(%t_Delete_Type) == "NET_STATION" #then #block

         @l_Line_Number = do (%Gv_SCT_Mgr__, "GetObjectAttribute", "NET_STATION", %i_Delete_Number, "LI")
         #if l_Line_Number:vSTATUS <> 0 #then #return %l_Line_Number

         @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_MS_Vector")
         @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_HS_Vector")

      #block_end

   #block_end

   #when "NODE_LINK" #block

      @l_Delete_Object_Status = do (%Gv_SCT_Mgr__, "PutObjectNumber", argument(1), argument(2), %i_Delete_Net_Nr, "acDelete")
      #if l_Delete_Object_Status:vSTATUS <> 0 #then #return %l_Delete_Object_Status

      @v_Delete_Types = ("NODE_'i_Delete_Net_Nr'_LINKS", "Node_Link_'i_Delete_Number'")

      #loop_with i_Signal_Count = 1 .. 10000

         #if %i_Signal_Count == 1 #then @l_Read_Status = read_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_NC_Vector")
            #else @l_Read_Status = read_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_NC_Vector_'i_Signal_Count'")

         #if l_Read_Status:vSTATUS == 0 #then #block

            #if %i_Signal_Count == 1 #then @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_NC_Vector")
               #else @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_NC_Vector_'i_Signal_Count'")

         #block_end
         #else #loop_exit

      #loop_end

      #loop_with i_Signal_Count = 1 .. 10000

         #if %i_Signal_Count == 1 #then @l_Read_Status = read_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_XA_Vector")
            #else @l_Read_Status = read_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_XA_Vector_'i_Signal_Count'")

         #if l_Read_Status:vSTATUS == 0 #then #block

            #if %i_Signal_Count == 1 #then @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_XA_Vector")
               #else @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_XA_Vector_'i_Signal_Count'")

         #block_end
         #else #loop_exit

      #loop_end

   #block_end

   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_OBJECT_PARAMETER_ERROR")

#case_end

#loop_with i_Signal_Count = 1 .. 10000

   #if %i_Signal_Count == 1 #then @l_Read_Status = read_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2))
      #else @l_Read_Status = read_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_'i_Signal_Count'")

   #if l_Read_Status:vSTATUS == 0 #then #block

      #if %i_Signal_Count == 1 #then @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2))
         #else @l_Status = delete_parameter(%t_System_Conf_File, %v_Delete_Types(1), %v_Delete_Types(2) + "_'i_Signal_Count'")

   #block_end
   #else #loop_exit

#loop_end

@l_Returned_Data = list(STATUS = 0)

#case upper_case(%t_Delete_Type)

   #when "BASE_SYSTEM_STATION" #block

      #if data_type(%i_Delete_Net_Nr) == "TEXT" #then #if upper_case(%i_Delete_Net_Nr) == "ACONLINE" #then #block

         @i_Status = status
         #error ignore
            #set sta'i_Delete_Number':bTT = "NONE"
         #error stop
         @i_Status = status

         #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         #set l_Returned_Data:vONLINE = %b_Online

      #block_end

   #block_end

   #when "NODE_LINK" #block

      #if upper_case(%t_Delete_Additional) == "ACONLINE" #then #block

         @i_Status = status
         #error ignore
            #set net'i_Delete_Net_Nr':sIU'i_Delete_Number' = 0
            #set net'i_Delete_Net_Nr':sPO'i_Delete_Number' = 0
         #error stop
         @i_Status = status

         #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         #set l_Returned_Data:vONLINE = %b_Online

      #block_end

   #block_end

   #when "NET_STATION" #block

      #if data_type(%i_Delete_Net_Nr) == "TEXT" #then #if upper_case(%i_Delete_Net_Nr) == "ACONLINE" #then #block

         @l_Station_Type = do (%Gv_SCT_Mgr__, "GetObjectAttribute", "BASE_SYSTEM_STATION", %i_Delete_Number, "ST")
         #if data_type(%l_Station_Type) <> "LIST" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_OBJECT_READ_ST_ATTRIBUTE_ERROR")

         #if l_Station_Type:vST == "REX" #then @i_Sty_Number = 17
            #else_if l_Station_Type:vST == "SPA" #then @i_Sty_Number = 21
               #else_if l_Station_Type:vST == "LMK" #then @i_Sty_Number = 23
                  #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_OBJECT_NOT_SUPPORTED_STATION_TYPE_ERROR")

         @l_Node_Number = do (%Gv_SCT_Mgr__, "GetObjectAttribute", "BASE_SYSTEM_STATION", %i_Delete_Number, "ND")
         #if data_type(%l_Station_Type) <> "LIST" #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_OBJECT_READ_ND_ATTRIBUTE_ERROR")

         @i_Node_Number = l_Node_Number:vND
         @i_Line_Number = l_Line_Number:vLI

         @i_Status = status
         #error ignore
            #set net'i_Node_Number':sIU'i_Line_Number' = 0
            #set sta'i_Delete_Number':sIU = 0
            #set net'i_Node_Number':sDV(%i_Sty_Number) = (%i_Delete_Number, "D")
         #error stop
         @i_Status = status

         #if %i_Status <> 0 and %b_Online #then @b_Online = FALSE

         @i_Status = status
         #error ignore
            #set net'i_Node_Number':sIU'i_Line_Number' = 1
         #error stop
         @i_Status = status

         #set l_Returned_Data:vONLINE = %b_Online

      #block_end

   #block_end

#case_end

#if l_Read_Status:vSTATUS == 0 and %i_Signal_Count == 1 #then #return %l_Returned_Data
#else_if l_Read_Status:vSTATUS > 0 and %i_Signal_Count == 1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_DELETE_OBJECT_DELETING_ERROR ['l_Read_Status:vSTATUS']")
#else #return %l_Returned_Data

; Method: GetFileName(t_Tool_Type)
; Version: 1.0
; Description: Returns the tool specific configuration file.
; ----------------------------------------------------------
@t_Tool_Type = argument(1)

#case upper_case(%t_Tool_Type)
   #when "TOOL_CONF" #return list(STATUS = 0, FILE_NAME = "sys_/ToolConf.ini")
   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FILE_NAME_TOOL_TYPE_NOT_FOUND_ERROR")
#case_end

; Method: MoveConfiguration(t_Destination_Folder)
; Version: 1.0
; Description: Moves active configuration files to the specified folder.
; ----------------------------------------------------------------------
@t_Destination_Folder = argument(1)

@b_Move_Successful = TRUE

#if file_manager("EXISTS", fm_file(parse_file_name("sys_", "SysConf.ini"))) #then #block
   @y_Source_File = fm_file(parse_file_name("sys_", "SysConf.ini"))
   @y_Target_File = fm_file(parse_file_name(%t_Destination_Folder, "SysConf.ini"))
   @i_Move_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
   #if %i_Move_Status <> 0 #then @b_Move_Successful = FALSE
#block_end

#if %b_Move_Successful #then #block

   #if file_manager("EXISTS", fm_file(parse_file_name("sys_", "Signals.ini"))) #then #block
      @y_Source_File = fm_file(parse_file_name("sys_", "Signals.ini"))
      @y_Target_File = fm_file(parse_file_name(%t_Destination_Folder, "Signals.ini"))
      @i_Move_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
      #if %i_Move_Status <> 0 #then @b_Move_Successful = FALSE
   #block_end

   #if %b_Move_Successful #then #block

      #if file_manager("EXISTS", fm_file(parse_file_name("sys_", "ToolConf.ini"))) #then #block
         @y_Source_File = fm_file(parse_file_name("sys_", "ToolConf.ini"))
         @y_Target_File = fm_file(parse_file_name(%t_Destination_Folder, "ToolConf.ini"))
         @i_Move_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
         #if %i_Move_Status <> 0 #then @b_Move_Successful = FALSE
      #block_end

   #block_end

#block_end

#if %b_Move_Successful #then #return list(STATUS = 0)
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_MOVE_CONFIGURATION_COPYING_ERROR ['i_Move_Status']")

; Method: RestoreConfiguration(t_Source_Folder)
; Version: 1.0
; Description: Restores active configuration files from the source folder.
; ------------------------------------------------------------------------
@t_Destination_Folder = argument(1)

@b_Restore_Successful = TRUE

#if file_manager("EXISTS", fm_file(parse_file_name(%t_Destination_Folder, "SysConf.ini"))) #then #block
   @y_Source_File = fm_file(parse_file_name(%t_Destination_Folder, "SysConf.ini"))
   @y_Target_File = fm_file(parse_file_name("sys_", "SysConf.ini"))
   @i_Restore_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
   #if %i_Restore_Status <> 0 #then @b_Restore_Successful = FALSE
#block_end

#if %b_Restore_Successful #then #block

   #if file_manager("EXISTS", fm_file(parse_file_name(%t_Destination_Folder, "Signals.ini"))) #then #block
      @y_Source_File = fm_file(parse_file_name(%t_Destination_Folder, "Signals.ini"))
      @y_Target_File = fm_file(parse_file_name("sys_", "Signals.ini"))
      @i_Restore_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
      #if %i_Restore_Status <> 0 #then @b_Restore_Successful = FALSE
   #block_end

   #if %b_Restore_Successful #then #block

      #if file_manager("EXISTS", fm_file(parse_file_name(%t_Destination_Folder, "ToolConf.ini"))) #then #block
         @y_Source_File = fm_file(parse_file_name(%t_Destination_Folder, "ToolConf.ini"))
         @y_Target_File = fm_file(parse_file_name("sys_", "ToolConf.ini"))
         @i_Restore_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
         #if %i_Restore_Status <> 0 #then @b_Restore_Successful = FALSE
      #block_end

   #block_end

#block_end

#if %b_Restore_Successful #then #return list(STATUS = 0)
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_RESTORE_CONFIGURATION_COPYING_ERROR ['i_Restore_Status']")

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

@v_Included_Stations = vector()
@l_Get_Station_Status = do (%Gv_SCT_Mgr__, "GetObjectNumbers", "BASE_SYSTEM_STATION")
#if l_Get_Station_Status:vSTATUS <> 0 #then #return %l_Get_Station_Status

#case upper_case(%t_Get_Station_Type)

   #when "NODE", "NODE_LINK" #block

      #loop_with i_Get_Station = 1 .. length(l_Get_Station_Status:vDATA)

         @l_Get_Station_Attribute_Status = do (%Gv_SCT_Mgr__, "GetObjectAttribute", "BASE_SYSTEM_STATION", l_Get_Station_Status:vDATA(%i_Get_Station), "ND")
         #if l_Get_Station_Attribute_Status:vSTATUS <> 0 #then #return %l_Get_Station_Attribute_Status
         #else #block

            #case upper_case(%t_Get_Station_Type)

               #when "NODE" #if l_Get_Station_Attribute_Status:vND == %i_Get_Node_Number #then @v_Included_Stations = append(%v_Included_Stations, l_Get_Station_Status:vDATA(%i_Get_Station))
               #when "NODE_LINK" #block
                  @l_Get_Station_Attribute_2_Status = do (%Gv_SCT_Mgr__, "GetObjectAttribute", "NET_STATION", l_Get_Station_Status:vDATA(%i_Get_Station), "LI")
                  #if data_type(%l_Get_Station_Attribute_2_Status) == "LIST" #then #block
                    #if l_Get_Station_Attribute_2_Status:vSTATUS <> 0 #then #return %l_Get_Station_Attribute_2_Status
                    #else_if l_Get_Station_Attribute_Status:vND == %i_Get_Node_Number and l_Get_Station_Attribute_2_Status:vLI == %i_Get_Node_Link_Number #then @v_Included_Stations = append(%v_Included_Stations, l_Get_Station_Status:vDATA(%i_Get_Station))
                  #block_end
               #block_end

            #case_end

         #block_end

      #loop_end

   #block_end

   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_STATION_NUMBERS_PARAMETER_TYPE_ERROR")

#case_end

#return list(STATUS = 0, DATA = %v_Included_Stations)

; Method: ActivateConfiguration()
; Version: 1.0
; Description: Activates configuration files in the default folder.
; -----------------------------------------------------------------

#loop_with i_Station_Count = 1 .. 2000

   #if upper_case(sta'i_Station_Count':bST) <> "NONE" #then #set sta'i_Station_Count':bTT = "NONE"

#loop_end

@l_System_Configuration = SYS:BSV2

#if data_type(%l_System_Configuration) == "LIST" #then #block

   #if length(select(list_attr(%l_System_Configuration), "==""T_SYSTEM_CONFIGURATION_FILE""")) > 0 #then #block

      @i_Status = do (%Gv_SCT_Mgr__, "StopCommunication")
      @i_Status = do (read_text("sys_tool/msglog.scl"), "INFO", "Configuring base system...")
      @v_Create_Block = vector()

      @i_Links_Status = do (read_text("sys_tool/Create_B.scl"), "BASE_SYSTEM_LINK")
      @i_Nodes_Status = do (read_text("sys_tool/Create_B.scl"), "BASE_SYSTEM_NODE", "acNoCreate")
      @i_Stations_Status = do (read_text("sys_tool/Create_B.scl"), "BASE_SYSTEM_STATION")
      @i_Station_Types_Status = do (read_text("sys_tool/Create_B.scl"), "BASE_SYSTEM_STATION_TYPE")
      @i_Write_Commands_Status = write_text("sys_/sys_base.scl", %v_Create_Block)
      #if length(%v_Create_Block) > 0 #then @i_Do_Commands_Status = do (read_text("sys_tool/docmd.scl"), %v_Create_Block)
      @i_Status = do (read_text("sys_tool/msglog.scl"), "INFO", "Base system configuration finished.")

      @i_Status = do (%Gv_SCT_Mgr__, "StartCommunication")

   #block_end

#block_end

#return list(STATUS = 0)

; Method: StopCommunication()
; Version: 1.0
; Description: Stops running PC-NET communication, if running.
; ------------------------------------------------------------

@l_PCNET_Data = do (read_text("sys_tool/GetINodeInfo.scl"))

#loop_with i_PCNET_Count = 1 .. length(l_PCNET_Data:vv_Link_Number)

   @i_Link_Number = l_PCNET_Data:vv_Link_Number(%i_PCNET_Count)

   #if lin'i_Link_Number':bLT == "INTEGRATED" #then #block

      @i_Status = do(read_text("sys_tool/msglog.scl"), "INFO", "Stopping PC_NET...")
      #set lin'i_Link_Number':bLT = "NONE"

   #block_end

#loop_end

#return list(STATUS = 0)

; Method: StartCommunication()
; Version: 1.0
; Description: Activates PC-NET according to configuration files in the default folder.
; -------------------------------------------------------------------------------------

@i_Start_PCNET_Status = do (read_text("sys_tool/StartPCNET.scl"))

#if %i_Start_PCNET_Status == 0 #then #return list(STATUS = 0)
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_START_COMMUNICATION_FAILED_TO_START_PC_NET")

; Method: GetFreeObjectNumber([t_Free_Object_Type])
; Version: 1.0
; Parameters: [t_Free_Object_Type], specifies the object type in question, which free number is queried
; Description: Returns the first free object number found from the permanent configuration files.
; ---------------------------------------------------------------------------------------------------

@t_Free_Object_Type = argument(1)
#if argument_count == 0 #then @t_Free_Object_Type = "BASE_SYSTEM_STATION"

#case upper_case(%t_Free_Object_Type)

   #when "BASE_SYSTEM_NODE", "BASE_SYSTEM_LINK", "BASE_SYSTEM_STATION" @v_Stations = do (%Gv_SCT_Mgr__, "GetObjNrs", upper_case(%t_Free_Object_Type))
   #otherwise #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FREE_OBJECT_NUMBER_UNKNOWN_OBJECT_TYPE_ERROR")

#case_end

#if length(%v_Stations) > 0 #then #if %v_Stations(1) > 0 #then #block

   @v_Max_Station_Number = high(%v_Stations)

   #if %v_Max_Station_Number(1) == length(%v_Stations) #then #block

      #case upper_case(%t_Free_Object_Type)

         #when "BASE_SYSTEM_NODE" @i_Max_Limit = 98
         #when "BASE_SYSTEM_LINK" @i_Max_Limit = 19
         #when "BASE_SYSTEM_STATION" @i_Max_Limit = 1999

      #case_end

      #if %v_Max_Station_Number(1) > %i_Max_Limit #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_GET_FREE_OBJECT_NUMBER_ALL_OBJECT_NUMBERS_RESERVED_ERROR")
         #else #return list(STATUS = 0, DATA = %v_Max_Station_Number(1) + 1)

   #block_end
   #else #block

      @v_Station_Number = low(select(dec(classify(%v_Stations, %v_Max_Station_Number(1), 1, %v_Max_Station_Number(1)), 0), "==""0"""))
      #return list(STATUS = 0, DATA = %v_Station_Number(1))

   #block_end

#block_end
#else_if %v_Stations(1) == 0 #then #return list(STATUS = 0, DATA = 1)

#return list(STATUS = -1)

; Method: NewConfiguration(t_Destination_Folder)
; Version: 1.0
; Description: Moves template configuration files to the specified folder.
; ------------------------------------------------------------------------
@t_Destination_Folder = argument(1)

#if argument_count < 1 #then #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_NEW_CONFIGURATION_PARAMETER_ERROR")

@b_New_Successful = TRUE

#if file_manager("EXISTS", fm_file(parse_file_name("sys_", "SysConf$ini"))) #then #block
   @y_Source_File = fm_file(parse_file_name("sys_", "SysConf$ini"))
   @y_Target_File = fm_file(parse_file_name(%t_Destination_Folder, "SysConf.ini"))
   @i_Move_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
   #if %i_Move_Status <> 0 #then @b_New_Successful = FALSE
#block_end

#if %b_New_Successful #then #block

   #if file_manager("EXISTS", fm_file(parse_file_name("sys_", "ToolConf$ini"))) #then #block
      @y_Source_File = fm_file(parse_file_name("sys_", "ToolConf$ini"))
      @y_Target_File = fm_file(parse_file_name(%t_Destination_Folder, "ToolConf.ini"))
      @i_Move_Status = file_manager("COPY", %y_Source_File, %y_Target_File, "OVERWRITE")
      #if %i_Move_Status <> 0 #then @b_New_Successful = FALSE
   #block_end

#block_end

#if %b_New_Successful #then #return list(STATUS = 0)
   #else #return list(STATUS = 1, DESCRIPTIVE_TEXT = "SCM_SERVICE_NEW_CONFIGURATION_COPYING_ERROR ['i_Move_Status']")

; Method: PassivateTimeChannels()
; Version: 1.0
; Description: Sets the IU = 0 of all active time channels in current application and writes
;              the names of time channels to pict/tmpPassTC.txt
; ---------------------------------------------------------------------------------------------------

@t_Passivated_File = "pict/tmpPassTC.txt"

@l_TC = application_object_list(0, "T", "A", "F", "", "IU == 1")
@v_TC_Names = l_TC:vLN
@v_TC_Passivated = vector()

@i2 = 0

#loop_with i = 1 .. length(%v_TC_Names)

   @t_TC = %v_TC_Names(%i)

   @i_Status = status

   #error ignore
      #set 't_TC':TIU = 0
   #error stop

   #if status == 0 #then #block

      @i2 = %i2 + 1
      @v_TC_Passivated(%i2) = %t_TC

   #block_end

#loop_end

@l_Result = list(v_TC = %v_TC_Names, v_Passivated_TC = %v_TC_Passivated)

@i_write_status = write_text(%t_Passivated_File, dump(%l_Result))

; Method: ActivateTimeChannels()
; Version: 1.0
; Description: Sets the IU = 0 of time channels listed in pict/tmpPassTC.txt
; ---------------------------------------------------------------------------------------------------

@t_Passivated_File = "pict/tmpPassTC.txt"

@i_status = status
#error ignore
@l_Result = evaluate(read_text(%t_Passivated_File))
#error stop

#if status == 0 #then #block

   @v_TC_Names = l_Result:vv_TC
   @v_Passivated_TC_Names = l_Result:vv_Passivated_TC

   #loop_with i = 1 .. length(%v_TC_Names)

      @t_TC = %v_TC_Names(%i)

      #error ignore
         #set 't_TC':TIU = 1
      #error stop

   #loop_end

   @l_del_stat = file_manager("DELETE", fm_scil_file(%t_Passivated_File))

#block_end
