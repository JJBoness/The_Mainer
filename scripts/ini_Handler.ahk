#Requires AutoHotkey v2.0

class ini_Var{

    Value := ""

    __New(FileName, Section, Key, New_Value := "") {

        if (!FileExist("vars\")) {
            DirCreate("vars\")
        }
        
        if (New_Value) {
            this.Value := New_Value
        }
        this.FileName := FileName
        this.Section := Section
        this.Key := Key


        OnExit(ExitThing)

        return this.Read()

        ExitThing(*) {
            this.Write()
        }
    }

    Read() {
        return this.Value := IniRead(this.FileName, this.Section, this.Key, 0)
    }

    Write() {
        IniWrite(this.Value, this.FileName, this.Section, this.Key)
    }
    
    Delete() {
        IniDelete(this.FileName, this.Section, this.Key)
    }
}


