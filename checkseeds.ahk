#NoEnv
#SingleInstance force

; World Settings
global version := "1.19.4"  ; default world gen screen type. selectable: 1.16, 1.19.4
global gamemode := 1  ; 0=survival, 1=creative, 2=hardcore
global difficulty := 2  ; 0=peaceful, 1=easy, 2=normal, 3=hard
global atum := 1  ; 0=not used, 1=bottom right/center, 2=replace s&q

; File Settings
global filepath := "D:\downloads\AutoHotKey\minecraft\checkseeds\seeds.txt"  ; default seeds text file path

; Delay Settings
global keydelay := 70
global worldgenkeydelay := 500
global seedinputdelay := 50
global worldquitkeydelay := 300

; Hotkey Settings
global Resethotkey := "*U"
global ResetinMainMenuhotkey := "*I"


; Do Not Edit
global seed := ""
global var := ""
SetKeyDelay, %keydelay%

Menu, Tray, Add
Menu, Tray, Add, SeedsFileSelect, SeedsFileSelect
Menu, Tray, Add
Menu, Tray, Add, 1.16 mode, 1_16_mode
Menu, Tray, Add, 1.19.4 mode, 1_19_4_mode

GetSeeds() {
  FileReadLine, seed, %filepath%, 1
}

WorldGen() {
  GetSeeds()
  ControlSend,, {Blind}{Space}{Tab 3}{Space}
  Sleep, %worldgenkeydelay%
  ControlSend,, {Blind}{Tab}

  if (gamemode == 1)
    ControlSend,, {Blind}{Space 2}
  if (gamemode == 2)
    ControlSend,, {Blind}{Space}

  ControlSend,, {Blind}{Tab}
  if (difficulty == 0 and gamemode <> 2)
    ControlSend,, {Blind}{Space 2}
  if (difficulty == 1 and gamemode <> 2)
    ControlSend,, {Blind}{Space 3}
  if (difficulty == 3 and gamemode <> 2)
    ControlSend,, {Blind}{Space}


  if (version == "1.16") {
    if (gamemode <> 2)
      ControlSend,, {Blind}{Tab 4}{Space}{Tab 3}
    else
      ControlSend,, {Blind}{Tab 3}{Space}{Tab 3}
  } else if (version == "1.19.4") {
    if (gamemode <> 2)
      ControlSend,, {Blind}{Tab 4}{Right}{Tab 2}
    else
      ControlSend,, {Blind}{Tab 2}{Right}{Tab 2}
  }

  SendInput, %seed%
  Sleep, %seedinputdelay%

  if (version == "1.16") {
    if (gamemode <> 2)
      ControlSend,, {Blind}{Tab 6}{Space}
    else
      ControlSend,, {Blind}{Tab 5}{Space}
  } else if (version == "1.19.4") {
    if (gamemode <> 2)
      ControlSend,, {Blind}{Tab 3}{Space}
    else
      ControlSend,, {Blind}{Tab 2}{Space}
  }
  
  DeleteLine()
}

WorldGenFromMainMenu() {
  ControlSend,, {Blind}{Tab}
  WorldGen()
}

WorldQuit() {
  SetKeyDelay, 0
  if (atum == 1)
    ControlSend,, {Blind}{ESC}{Tab 9}{Space}
  else
    ControlSend,, {Blind}{ESC}{Tab 8}{Space}
  SetKeyDelay, %keydelay%
}

ResetGen() {
  WorldQuit()
  Sleep, %worldquitkeydelay%
  if (version == "1.16")
    ControlSend,, {Blind}{Tab}
  WorldGen()
}

DeleteLine() {
  FileReadLine, seed, %filepath%, 1
  FileRead, var, %filepath%
  StringReplace, var, var, %seed%
  if !var
    MsgBox, All lines loaded!
  if !ErrorLevel {
    StringTrimLeft, var, var, 2
    FileDelete, %filepath%
    FileAppend, %var%, %filepath%
  }
}

SeedsFileSelect() {
  dummy := filepath
  FileSelectFile, filepath, 1,, Select Seeds File
  if !filepath
    filepath := dummy
}

1_16_mode() {
  version := "1.16"
}

1_19_4_mode() {
  version := "1.19.4"
}

#If WinActive("Minecraft") && (WinActive("ahk_exe javaw.exe") || WinActive("ahk_exe java.exe"))
  Hotkey, %Resethotkey%, ResetGen
  Hotkey, %ResetinMainMenuhotkey%, WorldGenFromMainMenu