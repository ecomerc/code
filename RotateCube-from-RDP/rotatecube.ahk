; EcoMerc
; http://code.ecomerc.com
; 
; Version 2013-01-29
;
; License: GPL v2

#SingleInstance force
; Usage: Press CTRL+CapsLock, hold CTRL and use arrow keys to navigate desktops

RotatingCube := 0
^Capslock::
    SetKeyDelay -1 
	if (RotatingCube = 0) { 
		;Get MSTSC window (this may have to be ahk_class TSSHELLWND for some systems)
		;TODO: make multiple detection
		
		If WinActive("ahk_class TscShellContainerClass") {
			WinGet, active_id, ID, A
			WinGet, maxOrMin, MinMax, ahk_id %active_id%
			
			if (maxOrMin = 0) {
				WinGetPos, PosX, PosY, WinWidth, WinHeight, ahk_id %active_id%
				if (PosY = 0) {
					;Wait for focus to restore properly
					Sleep 50
					
					;Force the MSTSC windows to restore (unmaximize)
					PostMessage, 0x112, 0xF120,,, ahk_id %active_id%   ; 0x112 = WM_SYSCOMMAND, 0xF120 = SC_RESTORE
					Sleep 50
					
					;Move it so it fills the screen, but not 0,0 because then we would think it was maximized
					WinMove, ahk_id %active_id%,, 1, 1, WinWidth - 2, WinHeight-2
					tooltip SaveId %active_id%
					
				}
			}
			
		}
		; Launch the Cube
		send, {LCtrl Down}{LWin Down}{Up DownTemp}
		RotatingCube := 1
	}
    return
	
~LCtrl up::
	if (RotatingCube <> 0) {
		send, {LWin Up}
		Sleep 50
		DetectHiddenWindows, off
		WinWait, ahk_class TscShellContainerClass, , 1
		if ErrorLevel {
			;;Did not find MSTSC
			
			;;Set SecondaryTaskbar as Always OnTop
			Winset, AlwaysOnTop, off, SecondaryTaskbar
		} else {
			;;Maximizing MSTSC
			WinActivate 
			send !^{vk03sc146}
			
			;;Set SecondaryTaskbar as Not Always OnTop (it has a bug)
			Winset, AlwaysOnTop, off, SecondaryTaskbar
		}
	}
	RotatingCube := 0
    return	