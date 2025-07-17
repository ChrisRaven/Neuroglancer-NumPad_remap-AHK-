#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode 2

autoClickerRunning := false
clickerEnabled := false
lastClickX := 0
lastClickY := 0
minDistance := 10  ; pixels

IsNeuroglancerActive() {
  return WinActive("neuroglancer")
}

DoClick() {
  global lastClickX, lastClickY, minDistance, clickerEnabled

  if !IsNeuroglancerActive() || !clickerEnabled {
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

NumpadHome::Send "m"
NumpadUp::Send "c"
NumpadEnter::Send "{Space}"
NumpadDiv::Send "l"
NumpadMult::Send "{Enter}"
NumpadDown::Send "2"
NumpadIns::Send "f"

lastPgDnTime := 0
NumpadPgDn Up:: {
  static doubleTapThreshold := 400
  global lastPgDnTime

  currentTime := A_TickCount
  if (currentTime - lastPgDnTime <= doubleTapThreshold) {
    Send "x"
    lastPgDnTime := 0
  } else {
    lastPgDnTime := currentTime
  }
}

SwitchColorAndStartAutoClicker(color) {
  global clickerEnabled
  color1 := PixelGetColor(275, 1055, "RGB")
  if (color1 = color) {
    Send "g"
  }
  else {
    color2 := PixelGetColor(275, 1035, "RGB")
    if (color2 = color) {
      Send "g"
    }
  }
  clickerEnabled := true
  StartAutoClicker()
}

NumpadPgUp:: SwitchColorAndStartAutoClicker(0x0000FF)
NumPadSub:: SwitchColorAndStartAutoClicker(0xFF0000)

NumPadPgUp Up::
NumpadSub Up:: {
  global clickerEnabled
  clickerEnabled := false
  StopAutoClicker()
}

NumpadEnd:: {
  SendEvent "{Shift down}"
  Click
  Sleep 50
  Click
  SendEvent "{Shift up}"
}

NumpadRight:: SendEvent "{Ctrl down}"
NumpadRight Up:: SendEvent "{Ctrl up}"
NumpadClear:: SendEvent "{Shift down}"
NumpadClear Up:: SendEvent "{Shift up}"

NumpadLeft:: {
  SendEvent "{Ctrl down}"
  SendEvent "{Alt down}"
  Click "Right"
  Sleep 200
  Click "Right"
  SendEvent "{Alt up}"
  SendEvent "{Ctrl up}"
}

#HotIf
