#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf Sci_Char_State == true
{
    !u::
    {
        Send("μ")
    }

    !o::
    {
        Send("Ω")
    }

    !8::
    {
        Send("∞")
    }

    !e::
    {
        Send("ε")
    }

    !,::
    {
        Send("≤")
    }

    !.::
    {
        Send("≥")
    }

    !p::
    {
        Send("π")
    }

    !r::
    {
        Send("√")
    }

    !NumpadMult::
    {
        Send("°")
    }

    !d::
    {
        Send("Δ")
    }
}
#Hotif

Tooltip_Timer(Text, Time) {
    ToolTip(Text)
    SetTimer(Tooltip_Timer_Set, 1000)
}

Tooltip_Timer_Set() {
    Tooltip()
    SetTimer(Tooltip_Timer_Set, 0)
}