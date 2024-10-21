#Requires AutoHotkey v2.0
#SingleInstance Force

#include scripts\Symbol Keys.ahk

if (!FileExist("vars\")) {
    DirCreate("vars\")
}
Var_ini_File := "vars\vars.ini"
ini_getVars()

Main_Gui := Construct_Main_Gui()
Main_Gui.Show("w212 h57")

Sci_Char_State := 1

ini_getVars() {
    global Sci_Char_State := iniRead(Var_ini_File, "Vars", "Sci_Char_State", false)
}

Construct_Main_Gui() {
    myGui := Gui()
    myGui.Opt("+ToolWindow")

	Char_Checkbox := myGui.Add("CheckBox", "x104 y16 w88 h23", "Special Chars")
    if (Sci_Char_State == true) {
        Char_Checkbox.value := true
    }
    Char_Checkbox.OnEvent("Click", Char_Checked)

	CheckBox2 := myGui.Add("CheckBox", "x16 y16 w66 h21", "Capslock")
	myGui.Add("GroupBox", "x96 y0 w108 h49", "Hotkeys")
	myGui.Add("GroupBox", "x8 y0 w82 h46", "Capslock")
    
    return myGui
}

Char_Checked(asdsad, *) {
    global Sci_Char_State := asdsad.value
    IniWrite(Sci_Char_State, Var_ini_File, "Vars", "Sci_Char_State")
}

^!Esc::
{
    RunWait("cmd /c shutdown /sg /t 10")
    ;RunWait, cmd /c "shutdown /a"
}