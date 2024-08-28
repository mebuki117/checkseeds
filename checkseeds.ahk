#NoEnv
#SingleInstance force

; File Settings
global filepath := "D:\AutoHotKey\minecraft\checkseeds\seeds.txt"  ; default seeds text file path
global maxgb := 1  ; max gigabyte to read

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
maxgb = floor(maxgb*1024)
SetKeyDelay, %keydelay%

Menu, Tray, Add
Menu, Tray, Add, SeedsFileSelect, SeedsFileSelect

GetSeeds() {
  FileReadLine, seed, %filepath%, 1
}

WorldGen() {
  GetSeeds()
  ControlSend,, {Blind}{Space}{Tab 3}{Space}
  Sleep, %worldgenkeydelay%
  ControlSend,, {Blind}{Tab}{Space 2}{Tab 5}{Right}{Tab 2}
  SendInput, %seed%
  Sleep, %seedinputdelay%
  ControlSend,, {Blind}{Tab 3}{Space}
  DeleteLine()
}

WorldGenFromMainMenu() {
  ControlSend,, {Blind}{Tab}
  WorldGen()
}

WorldQuit() {
  SetKeyDelay, 0
  ControlSend,, {Blind}{ESC}{Tab 9}{Space}
  SetKeyDelay, %keydelay%
}

ResetGen() {
  WorldQuit()
  Sleep, %worldquitkeydelay%
  WorldGen()
}

DeleteLine() {
  FileReadLine, seed, %filepath%, 1
  FileRead, var, *Mmaxbyte %filepath%
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

#If WinActive("Minecraft") && (WinActive("ahk_exe javaw.exe") || WinActive("ahk_exe java.exe"))
  Hotkey, %Resethotkey%, ResetGen
  Hotkey, %ResetinMainMenuhotkey%, WorldGenFromMainMenu