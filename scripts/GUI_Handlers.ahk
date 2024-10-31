#Requires AutoHotkey v2.0

class Dir_Tree {

    Parent_Path := ""

    __new(Gui_Obj, Options) {



        this.TV := Gui_Obj.Add("TreeView", Options)
        this.TV.onEvent("ItemCheck", Event_Check)

        return this.TV

        Event_Check(Obj, Item, Checked) {
            this.Item_Check(Item, Checked)
        }
    }

    Refresh(New_Path := "") {
        if (New_Path) {
            this.Parent_Path := New_Path
        }

        if (New_Path != "") {
            this.Parent_Path := New_Path
        }

        if (!FileExist(this.Parent_Path)) {
            return
        }

        this.Refresh_Loop(this.Parent_Path)
    }

    Refresh_Loop(TV_Path, Parent_ID := 0) {
        if (Parent_ID == 0) {
            this.TV.delete()
        }

        new_Name := SubStr(TV_Path, InStr(TV_Path, "\", , -1) + 1)
        new_ID := this.TV.Add(new_Name, Parent_ID)

        loop files TV_Path "\*", "D" {
            this.Refresh_Loop(A_LoopFileFullPath, new_ID)
        }
    }

    Item_Check(ItemID, Checked) {
        this.TV.Modify(ItemID, "Select")

        this.TV.opt("-redraw")

        if (Checked) {
            this.TV.Modify(ItemID, "Check")
            this.TV.Modify(ItemID, "Expand")
        } else {
            this.TV.Modify(ItemID, "-Check")
            this.TV.Modify(ItemID, "-Expand")
        }

        this.Check_Children(this.TV.getChild(ItemID), Checked)
        this.Check_Parents(ItemID, Checked)

        this.TV.Modify(ItemID, "Vis")
        this.TV.opt("redraw")
    }

    Check_Children(Start_ID, Checked) {
        if (Start_ID) {

            if (Checked) {
                this.TV.Modify(Start_ID, "Check")
                this.TV.Modify(Start_ID, "Expand")
            } else {
                this.TV.Modify(Start_ID, "-Check")
                this.TV.Modify(Start_ID, "-Expand")
            }

            New_ID := this.TV.getChild(Start_ID)
            this.Check_Children(New_ID, Checked)

            New_ID := this.TV.getNext(Start_ID)
            this.Check_Children(New_ID, Checked)
        }
    }

    Check_Parents(Start_ID, Checked) {
        if (Start_ID) {

            if (Checked) {

                Parent_ID := this.TV.getParent(Start_ID)
                Next_ID := this.TV.getChild(Parent_ID)

                Count := 0
                Total_Count := 0
                while (Next_ID) {
                    if (this.TV.get(Next_ID, "Checked")) {
                        Count++
                    }
                    Total_Count++

                    Next_ID := this.TV.getNext(Next_ID)
                }

                if (Count == Total_Count) {
                    this.TV.Modify(Parent_ID, "Check")
                }
            }
            else {
                this.TV.Modify(Start_ID, "-Check")
            }

            New_ID := this.TV.getParent(Start_ID)
            this.Check_Parents(New_ID, Checked)
        }
    }

    getItems(Callback, Short_Path := "", Item_ID := this.TV.GetNext(0)) {

        New_Short_Path := Short_Path "\" this.TV.GetText(Item_ID)

        Next_ID := this.TV.getNext(Item_ID)
        Child_ID := this.TV.getChild(Item_ID)
        Checked := this.TV.get(Item_ID, "Checked")

        new_Parent := SubStr(this.Parent_Path, 1,  InStr(this.Parent_Path, "\",, -1) - 1)

        New_Full_Path := new_Parent . New_Short_Path

        Callback(this.TV, Item_ID, New_Full_Path, (Child_ID ? 1 : 0), Checked)

        if (Child_ID) {
            this.getItems(Callback, New_Short_Path, Child_ID)
        }
        
        if (Next_ID) {
            this.getItems(Callback, Short_Path, Next_ID)
        }
    }
}

class Path_Changer {

    Path := ""

    __New(New_Path := "") {
        if (New_Path) {
            this.Path := New_Path
        }
    }

    Browse(Carrent_Path := "") {
        New_Path := DirSelect("*" . Carrent_Path, 3)

        if (New_Path == "" || New_Path == "ERROR") {
            return
        }

        this.Path := New_Path
    }
}

class Hootkey {
    __new(Gui_Obj, Options, Key, Callback) {

        this.Callback := Callback
        
        this.hKey := Gui_Obj.Add("Hotkey", Options, Key)
         this.old_key := this.hKey.Value
        return this.hKey
    }

    Apply() {
        
        if (this.old_key && this.old_key != this.hKey.Value) {
            Hotkey(this.old_key,, "Off")
        }

        if (this.hKey.Value) {
            Hotkey(this.hKey.Value, this.Callback, "On")
        }

        this.old_key := this.hKey.Value

        return this.hKey.Value
    }

    Cancel() {
        this.hKey.Value := this.old_key
    }
}
