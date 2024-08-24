#NoEnv
#SingleInstance force

; Settings
global filepath := "C:\Users\PC_User\Downloads\test\message.txt"

global keydelay := 60
global worldgenkeydelay := 500
global seedinputdelay := 50
global worldquitkeydelay := 300


; Don't Change
global seed := ""
SetKeyDelay, %keydelay%

GetSeeds() {
  FileReadLine, seed, %filepath%, 1
}

WorldGen() {
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
  GetSeeds()
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
  GetSeeds()
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

; Hotkeys
#If WinActive("Minecraft") && (WinActive("ahk_exe javaw.exe") || WinActive("ahk_exe java.exe"))
  *U:: ResetGen()
  *I:: WorldGenFromMainMenu()