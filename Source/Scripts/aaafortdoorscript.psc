;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortDoorScript.psc
Modified : 2017-12-31 09:50:29
Compiled : 2017-12-31 09:50:31
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortDoorScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property LockedDialog Auto
Potion Property Plan Auto
Message Property UnlockedDialog Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.SetOpen(False) ; #DEBUG_LINE_NO:8
EndEvent

Event OnActivate(ObjectReference akActivator)
  If (Game.GetPlayer() as ObjectReference == akActivator) && Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:12
    If Self.IsLocked() ; #DEBUG_LINE_NO:13
      Int result = LockedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:14
      If result == 0 ; #DEBUG_LINE_NO:15
        Self.Lock(False, False) ; #DEBUG_LINE_NO:17
        Self.SetOpen(True) ; #DEBUG_LINE_NO:18
        Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:19
        Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:20
      ElseIf result == 1 ; #DEBUG_LINE_NO:21
        Self.Delete() ; #DEBUG_LINE_NO:23
        Game.GetPlayer().AddItem(Plan as Form, 1, False) ; #DEBUG_LINE_NO:24
      EndIf
    Else
      Int result = UnlockedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:27
      If result == 0 ; #DEBUG_LINE_NO:28
        Self.SetOpen(False) ; #DEBUG_LINE_NO:30
        Self.Lock(True, False) ; #DEBUG_LINE_NO:31
        Self.SetLockLevel(225) ; #DEBUG_LINE_NO:32
        Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:33
      ElseIf result == 1 ; #DEBUG_LINE_NO:34
        Self.Delete() ; #DEBUG_LINE_NO:36
        Game.GetPlayer().AddItem(Plan as Form, 1, False) ; #DEBUG_LINE_NO:37
      EndIf
    EndIf
  ElseIf !Self.IsLocked() ; #DEBUG_LINE_NO:41
    Self.SetOpen(True) ; #DEBUG_LINE_NO:42
    Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:43
    Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:44
  EndIf
EndEvent

Event OnUpdate()
  Self.SetOpen(False) ; #DEBUG_LINE_NO:50
EndEvent
