;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMultiPlaceOnSpawnScript.psc
Modified : 2012-09-27 12:34:31
Compiled : 2017-12-29 05:45:05
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMultiPlaceOnSpawnScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property BreakdownDialog Auto
Quest Property MainQuest Auto
ObjectReference Property OwnedRef Auto
Potion Property Plan Auto
Activator Property SpawnRef Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:10
EndEvent

Event OnActivate(ObjectReference akActivator)
  If (akActivator == Game.GetPlayer() as ObjectReference) && Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:14
    Int result = BreakdownDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:15
    If result == 0 ; #DEBUG_LINE_NO:16
      Game.GetPlayer().AddItem(Plan as Form, 1, False) ; #DEBUG_LINE_NO:17
      If OwnedRef != None ; #DEBUG_LINE_NO:18
        OwnedRef.Delete() ; #DEBUG_LINE_NO:19
      EndIf
      Self.Delete() ; #DEBUG_LINE_NO:21
    EndIf
  EndIf
EndEvent

Event OnUpdate()
  If (MainQuest as aaafortmainquestscript).stage == 0 && (MainQuest as aaafortmainquestscript).status == "placed" ; #DEBUG_LINE_NO:27
    If OwnedRef == None ; #DEBUG_LINE_NO:28
      OwnedRef = Self.PlaceAtMe(SpawnRef as Form, 1, False, False) ; #DEBUG_LINE_NO:29
      OwnedRef.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:30
    EndIf
  Else
    Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:33
  EndIf
EndEvent
