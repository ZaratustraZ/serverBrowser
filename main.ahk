

svFile := A_ScriptDir "\servers.txt"

svBrowser := Gui()
svBrowser.Title := "Server Browser"

LV      := svBrowser.add("ListView", "w480 h450", ["IP", "Name"])
New     := svBrowser.add("Button", "x10 y463 w240 h30", "New")
Del     := svBrowser.add("Button", "x260 y463 w230 h30", "Delete")

New.OnEvent("Click", OpenNewGui)
LV.OnEvent("DoubleClick", ConnectToServer)
svBrowser.OnEvent("Close", SaveAndExit)

LoadServers()

svBrowser.Show("w500 h500")

OpenNewGui(*)
{
    newGui := Gui()
    newGui.Title := "Add New Server"
    
    newGui.Add("Text", "x10 y10", "IP:")
    ipInput := newGui.Add("Edit", "x10 y30 w200")
    
    newGui.Add("Text", "x10 y60", "Name:")
    nameInput := newGui.Add("Edit", "x10 y80 w200")
    
    addButton := newGui.Add("Button", "x10 y110 w100", "Add")
    addButton.OnEvent("Click", AddServer)
    
    newGui.Show()

    AddServer(*)
    {
        ip := ipInput.Value
        name := nameInput.Value
        if (ip != "" and name != "") {
            LV.Add(, ip, name)
            FileAppend(ip "," name "`n", svFile)
            newGui.Destroy()
        } else {
            MsgBox("Please enter both IP and Name.")
        }
    }
}
 ConnectToServer(*)
 {
     if (selectedRow := LV.GetNext(0, "F")) {
        ip := LV.GetText(selectedRow, 1)
        link := "steam://connect/" ip
        Run(link) 

    }
 }
 LoadServers(*)
{
    if FileExist(svFile) {
        Loop Read, svFile
        {
            if A_LoopReadLine {
                fields := StrSplit(A_LoopReadLine, ",")
                if fields.Length = 2
                    LV.Add(, fields[1], fields[2])
            }
        }
    }
}
SaveAndExit(senders, info*)
{
    SaveServers()
    ExitApp
}

SaveServers()
{
    FileDelete(svFile)
    Loop LV.GetCount()
    {
        ip := LV.GetText(A_Index, 1)
        name := LV.GetText(A_Index, 2)
        FileAppend(ip "," name "`n", svFile)
    }
}

Return
