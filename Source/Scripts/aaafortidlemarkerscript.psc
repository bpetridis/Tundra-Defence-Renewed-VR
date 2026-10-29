;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortIdleMarkerScript.psc
Modified : 2012-10-14 20:29:55
Compiled : 2017-12-29 05:44:51
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortIdleMarkerScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property BreakdownDialog Auto
ObjectReference Property IdleBook Auto
ObjectReference Property IdleDrum Auto
ObjectReference Property IdleDrunk Auto
ObjectReference Property IdleFarm Auto
ObjectReference Property IdleFlute Auto
ObjectReference Property IdleLute Auto
Message Property IdleMenuA Auto
Message Property IdleMenuB Auto
Potion Property IdlePlan Auto
ObjectReference Property IdlePrayer Auto
ObjectReference Property IdleSweep Auto
ObjectReference Property IdleWarmHands Auto
Quest Property MainQuest Auto
ObjectReference Property marker Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If marker != None && (akActivator == Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:20
    Int result = BreakdownDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:21
    If result == 0 ; #DEBUG_LINE_NO:22
      If Game.GetPlayer().GetItemCount(IdlePlan as Form) < 1 ; #DEBUG_LINE_NO:23
        Game.GetPlayer().AddItem(IdlePlan as Form, 1, False) ; #DEBUG_LINE_NO:24
      EndIf
      marker.Delete() ; #DEBUG_LINE_NO:26
      Self.Delete() ; #DEBUG_LINE_NO:27
    EndIf
  ElseIf marker == None && (akActivator == Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:29
    Self.MarkersA() ; #DEBUG_LINE_NO:30
  EndIf
EndEvent

Function MarkersA()
  Int result = IdleMenuA.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:35
  If result == 0 ; #DEBUG_LINE_NO:36
    marker = Self.PlaceAtMe(IdleFarm.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:37
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:38
    Self.Disable(False) ; #DEBUG_LINE_NO:39
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:40
  ElseIf result == 1 ; #DEBUG_LINE_NO:41
    marker = Self.PlaceAtMe(IdleSweep.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:42
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:43
    Self.Disable(False) ; #DEBUG_LINE_NO:44
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:45
  ElseIf result == 2 ; #DEBUG_LINE_NO:46
    marker = Self.PlaceAtMe(IdlePrayer.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:47
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:48
    Self.Disable(False) ; #DEBUG_LINE_NO:49
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:50
  ElseIf result == 3 ; #DEBUG_LINE_NO:51
    marker = Self.PlaceAtMe(IdleWarmHands.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:52
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:53
    Self.Disable(False) ; #DEBUG_LINE_NO:54
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:55
  ElseIf result == 4 ; #DEBUG_LINE_NO:56
    marker = Self.PlaceAtMe(IdleBook.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:57
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:58
    Self.Disable(False) ; #DEBUG_LINE_NO:59
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:60
  ElseIf result == 5 ; #DEBUG_LINE_NO:61
    Self.MarkersB() ; #DEBUG_LINE_NO:62
  EndIf
EndFunction

Function MarkersB()
  Int result = IdleMenuB.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:67
  If result == 0 ; #DEBUG_LINE_NO:68
    marker = Self.PlaceAtMe(IdleLute.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:69
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:70
    Self.Disable(False) ; #DEBUG_LINE_NO:71
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:72
  ElseIf result == 1 ; #DEBUG_LINE_NO:73
    marker = Self.PlaceAtMe(IdleFlute.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:74
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:75
    Self.Disable(False) ; #DEBUG_LINE_NO:76
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:77
  ElseIf result == 2 ; #DEBUG_LINE_NO:78
    marker = Self.PlaceAtMe(IdleDrum.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:79
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:80
    Self.Disable(False) ; #DEBUG_LINE_NO:81
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:82
  ElseIf result == 3 ; #DEBUG_LINE_NO:83
    marker = Self.PlaceAtMe(IdleDrunk.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:84
    marker.SetAngle(marker.GetAngleX(), marker.GetAngleY(), Self.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:85
    Self.Disable(False) ; #DEBUG_LINE_NO:86
    Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:87
  ElseIf result == 4 ; #DEBUG_LINE_NO:88
    Self.MarkersA() ; #DEBUG_LINE_NO:89
  EndIf
EndFunction

Event OnUpdate()
  If (MainQuest as aaafortmainquestscript).hideIdleMarkers && marker != None ; #DEBUG_LINE_NO:94
    Self.Disable(False) ; #DEBUG_LINE_NO:95
  ElseIf !(MainQuest as aaafortmainquestscript).hideIdleMarkers && marker != None ; #DEBUG_LINE_NO:96
    Self.Enable(False) ; #DEBUG_LINE_NO:97
  EndIf
  Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:99
EndEvent
