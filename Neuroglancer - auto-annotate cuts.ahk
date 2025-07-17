#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode 2  ; Partial title match

isClicking := false
autoClickerRunning := false

lastClickX := 0
lastClickY := 0
minDistance := 10  ; pixels

IsNeuroglancerActive() {
  return WinActive("neuroglancer")
}

DoClick() {
  global lastClickX, lastClickY, minDistance

  if !IsNeuroglancerActive() || !GetKeyState("NumpadSub", "P") {
    StopAutoClicker()
    return
  }

  MouseGetPos &x, &y
  dx := x - lastClickX
  dy := y - lastClickY
  distance := Sqrt(dx**2 + dy**2)

  if distance >= minDistance {
    SendEvent '{Ctrl down}'
    Click
    SendEvent '{Ctrl up}'
    lastClickX := x
    lastClickY := y
  }
}

StartAutoClicker() {
  global autoClickerRunning
  if !autoClickerRunning {
    SetTimer DoClick, 50
    autoClickerRunning := true
  }
}

StopAutoClicker() {
  global autoClickerRunning
  SetTimer DoClick, 0
  autoClickerRunning := false
}

#HotIf IsNeuroglancerActive()

NumpadHome::Send "m"      ; NumLock off: Numpad7
NumpadUp::Send "c"        ; NumLock off: Numpad8
NumpadPgUp::Send "g"      ; NumLock off: Numpad9
NumpadEnter::Send "{Space}"
NumpadDiv::Send "l"       
NumpadMult::Send "{Enter}" 
NumpadDown::Send "2"

lastPgDnTime := 0

NumpadPgDn Up::{
  static doubleTapThreshold := 400
  global lastPgDnTime

  currentTime := A_TickCount
  if (currentTime - lastPgDnTime <= doubleTapThreshold) {
    Send("x")
    lastPgDnTime := 0
  } else {
    lastPgDnTime := currentTime
  }
}

NumpadEnd::{
  SendEvent "{Shift down}"
  Click
  Sleep(50)
  Click
  SendEvent "{Shift up}"
}

NumpadIns:: Send "f"

NumpadSub:: StartAutoClicker()
NumpadSub Up:: StopAutoClicker()

NumpadRight:: SendEvent "{Ctrl down}"
NumpadRight Up:: SendEvent "{Ctrl up}"

NumpadClear:: SendEvent "{Shift down}"
NumpadClear Up:: SendEvent "{Shift up}"

NumpadLeft::{
  SendEvent "{Ctrl down}"
  SendEvent "{Alt down}"
  Click "Right"
  Sleep(200)
  Click "Right"
  SendEvent "{Alt up}"
  SendEvent "{Ctrl up}"
}

#HotIf
