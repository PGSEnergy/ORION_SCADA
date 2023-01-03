Attribute VB_Name = "ScriptComment"
' Scripting File for Implementing Custom Rule Actions and Conditions

' A rule action must be a subroutine. A rule condition must be a
' function that returns a Boolean. Note that "Boolean" is not in
' the command completion list of function return options, so you
' must explicitly type it in.

' The rule action and condition names in the script appear in the
' Display Builder rules tab "Execute Function In Script" combobox.
' You can also enter a new action or condition in the combobox.
' This adds a new subroutine or function stub to the script file.

' To prevent an action or condition name from appearing in the combobox,
' precede the subroutine or function with '*** USER DEFINED CODE START ***
' and follow it with '*** USER DEFINED CODE END ***

' Any number of functions and/or subroutines can be entered between
' these lines. You can use this technique multiple times, and anywhere
' in your script.

' Following predefined globals are provided:
'Dim theView As DVView        'the view object from which the rule was invoked
'Dim theObject As DVObject    'the graphical object (if any) that invoked the rule

' If SYS 600 is updated, you must merge your changes to the new version
' of this file. To ease the merging, comment your changes in the existing
' subs/functions and write your additional subs/functions either right after
' this line or to the end of this file.


'===========================================================================
' Executes a program specified in public data variables of a subdrawing object.
' "Execute Button" uses this sub as an internal mouse click rule action.
'===========================================================================
Sub Execute()
    Dim dVar As DVMappedVar
    Dim exeFound As Boolean
    Dim argsFound As Boolean
    Dim executable As String
    Dim arguments As String
    
    'On Error GoTo ErrorHandler
    
    If theObject.view.IsInSubdrawing Then
        For Each dVar In theObject.view.Subdrawing.MappedVars
            If dVar.SubdrawingDataVar.Name = "Executable" Then
                exeFound = True
                executable = dVar.StringMapping
            ElseIf dVar.SubdrawingDataVar.Name = "Arguments" Then
                argsFound = True
                arguments = dVar.StringMapping
            End If
        Next dVar
    End If

    If exeFound And Not executable = "" Then
        If argsFound Then
            Shell (executable & " " & arguments)
        Else
            Shell (executable)
        End If
    End If

    Exit Sub

'ErrorHandler:
    '
End Sub  


'=====================================================================
' Executes a program specified in custom attributes of an object.
' Use this sub as a mouse click rule action for objects in a process display.
'===========================================================================
Sub ExecuteFromCustomAttribute()
    Dim ca As DVCustomAttribute
    Dim exeFound As Boolean
    Dim argsFound As Boolean
    Dim executable As String
    Dim arguments As String
    
    'On Error GoTo ErrorHandler
    
    For Each ca In theObject.CustomAttributes
        If ca.Name = "Executable" Then
             exeFound = True
             executable = ca.Value

        ElseIf ca.Name = "Arguments" Then
             argsFound = True
             arguments = ca.Value
        End If
    Next ca
    Set ca = Nothing

    If exeFound And Not executable = "" Then
        If argsFound Then
            Shell (executable & " " & arguments)
        Else
            Shell (executable)
        End If
    End If

    Exit Sub

'ErrorHandler:
    '
End Sub  


'===========================================================================
' This sub is used as a rule action for AfterAttach event.
' Display Builder adds the rule automatically when saving a process display
' containing a subdrawing that has "SAScriptAfterAttach" custom attribute
' key with value "OnAfterAttach".
'===========================================================================
Sub OnAfterAttach()
End Sub


'***************************************************************************
'***************************************************************************
'*** USER DEFINED CODE START ***
  
  
'*** USER DEFINED CODE END ***
'***************************************************************************
'***************************************************************************
  
  