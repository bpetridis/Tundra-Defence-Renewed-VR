;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortFarmPlotScript.psc
Modified : 2012-11-16 17:53:09
Compiled : 2017-12-29 05:44:46
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortFarmPlotScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property BreakdownDialog Auto
FormList Property FarmItems Auto
Potion Property FarmPlan Auto
Message Property FarmPlotDialog Auto
ObjectReference Property FarmingMarker Auto
Quest Property MainQuest Auto
ObjectReference Property ThisIdleMarker Auto
Bool Property isActivated = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:14
EndEvent

Event OnUpdate()
  If ThisIdleMarker == None ; #DEBUG_LINE_NO:18
    If (MainQuest as aaafortmainquestscript).stage == 0 && (MainQuest as aaafortmainquestscript).status == "placed" ; #DEBUG_LINE_NO:19
      If ThisIdleMarker == None ; #DEBUG_LINE_NO:20
        ThisIdleMarker = Self.PlaceAtMe(FarmingMarker.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:21
      EndIf
      Self.RegisterForSingleUpdate(60 as Float) ; #DEBUG_LINE_NO:23
    Else
      Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:25
    EndIf
  ElseIf isActivated
    Int farm = Utility.RandomInt(0, 3) ; #DEBUG_LINE_NO:28
    If farm == 1 && ThisIdleMarker != None ; #DEBUG_LINE_NO:29
      ThisIdleMarker.PlaceAtMe(FarmItems.GetAt(Utility.RandomInt(0, FarmItems.GetSize() - 1)), 1, False, False) ; #DEBUG_LINE_NO:30
    EndIf
  EndIf
EndEvent

Event OnActivate(ObjectReference akActivator)
  If (akActivator == Game.GetPlayer() as ObjectReference) && !Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:36
    Int result = FarmPlotDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:37
    If result == 0 ; #DEBUG_LINE_NO:38
      isActivated = True ; #DEBUG_LINE_NO:39
      Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:40
      Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:41
    ElseIf result == 1 ; #DEBUG_LINE_NO:42
      isActivated = False ; #DEBUG_LINE_NO:43
      Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:44
    EndIf
  ElseIf (akActivator == Game.GetPlayer() as ObjectReference) && Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:46
    Int result = BreakdownDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:47
    If result == 0 ; #DEBUG_LINE_NO:48
      If ThisIdleMarker != None ; #DEBUG_LINE_NO:49
        Game.GetPlayer().AddItem(FarmPlan as Form, 1, False) ; #DEBUG_LINE_NO:50
        ThisIdleMarker.Delete() ; #DEBUG_LINE_NO:51
        Self.Delete() ; #DEBUG_LINE_NO:52
      EndIf
    EndIf
  EndIf
EndEvent
