#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode 2

autoClickerRunning := false
clickerEnabled := false
lastClickX := 0
lastClickY := 0
minDistance := 10  ; pixels

minX := 1
maxX := 1600
minY := 200
maxY := 1030

IsNeuroglancerActive() {
  return WinActive("neuroglancer")
}

DoClick() {
  global lastClickX, lastClickY, minDistance, clickerEnabled
  global minX, maxX, minY, maxY

  if !IsNeuroglancerActive() || !clickerEnabled {
    StopAutoClicker()
    return
  }

  MouseGetPos &x, &y
  
  if (x < minX || x > maxX || y < minY || y > maxY)
  return
  
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

SwitchColorAndStartAutoClicker(incorrectColor) {
  global clickerEnabled
  statusColor := PixelGetColor(1580, 110, "RGB")

  if (statusColor = 0xA9A9A9) {
    return
  }
  if (statusColor = incorrectColor) {
    Send "g"
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



/*
// ==UserScript==
// @name         Multicut State Watcher
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Indicates the state of the multicut
// @match        https://spelunker.cave-explorer.org/*
// @grant        none
// ==/UserScript==

(function() {
  'use strict'

  const observer = new MutationObserver(() => {
    const indicator = document.querySelector('.activeGroupIndicator')
    const button = document.querySelector('.neuroglancer-tool-palette-button')

    if (!button) return

    if (!indicator) {
      button.style.backgroundColor = 'darkgray'
    } else if (indicator.classList.contains('blueGroup')) {
      button.style.backgroundColor = '#0000ff'
    } else {
      button.style.backgroundColor = '#ff0000'
    }
  })

  observer.observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['class']
  })
})()
*/
