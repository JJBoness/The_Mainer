#Requires AutoHotkey v2.0
#SingleInstance Force

#include scripts\Symbol Keys.ahk

if (!FileExist("vars\")) {
    DirCreate("vars\")
}
Var_ini_File := "vars\vars.ini"
ini_getVars()

Main_Gui := Construct_Main_Gui()

Sci_Char_State := 1

ini_getVars() {
    global Sci_Char_State := iniRead(Var_ini_File, "Vars", "Sci_Char_State", false)
}

Construct_Main_Gui() {
    myGui := Gui()
    myGui.Opt("+ToolWindow")

    myGui.Add("GroupBox", "x8 y0 w244 h112", "Hotkeys")

    global Char_Checkbox := myGui.Add("CheckBox", "x24 y24 w109 h33", "Special Chars")
    if (Sci_Char_State == true) {
        Char_Checkbox.value := true
    }
    Char_Checkbox.OnEvent("Click", Char_Checked)

    
    global Char_Hotkey := myGui.Add("Hotkey", "x136 y24 w113 h26")
    Char_Hotkey.Value := IniRead(Var_ini_File, "Hotkeys", "Sci_Char", "")
    Button_Apply()

    myGui.Add("Button", "x16 y80 w68 h23", "Ok").OnEvent("Click", Button_OK)
	myGui.Add("Button", "x96 y80 w68 h23", "Cancel")
	myGui.Add("Button", "x176 y80 w68 h23", "Apply").OnEvent("Click", Button_Apply)

    myGui.show("w260 h120 hide")

    return myGui
}

global Shutdown_State := 0
^!Esc::
{
    global Shutdown_State
    if (Shutdown_State == 0) {
        RunWait("cmd /c shutdown /sg /t 10")
        Shutdown_State := 1
    } else {
        RunWait("cmd /c shutdown /a")
        SetTimer(Power_Timer, 5000)
    }
}

Power_Timer() {
    global Shutdown_State
    Shutdown_State := 0
}

Tooltip_Timer(Text, Time := 1000) {
    ToolTip(Text)
    SetTimer(Tooltip_Timer_Set, Time)
}

Tooltip_Timer_Set() {
    Tooltip()
    SetTimer(Tooltip_Timer_Set, 0)
}

^Esc::
{
    if (WinActive(Main_Gui)) {
        Main_Gui.Hide()
    } else {
        Main_Gui.Show()
    }
}

Button_Apply(*) {
    Static Old_Key := 0
    Hotkey(Old_Key, Char_Checked, "Off")
    Hotkey(Char_Hotkey.value, Char_Checked, "On")

    IniWrite(Char_Hotkey.value, Var_ini_File, "Hotkeys", "Sci_Char")
    Old_Key := Char_Hotkey.value
}

Button_OK(*) {
    Button_Apply() 
    Main_Gui.Hide()
}

Char_Checked(*) {
    global Sci_Char_State := !Sci_Char_State
    IniWrite(Sci_Char_State, Var_ini_File, "Vars", "Sci_Char_State")
    Char_Checkbox.Value := Sci_Char_State

    Tooltip_Timer("Sci Chars: " Sci_Char_State)
}
