;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortCitizenScript.psc
Modified : 2012-10-06 17:04:05
Compiled : 2017-12-29 05:44:37
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortCitizenScript Extends Actor

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property CitizenDialog Auto
ObjectReference Property House Auto
Quest Property MainQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(180 as Float) ; #DEBUG_LINE_NO:8
EndEvent

Event OnActivate(ObjectReference akActivator)
  If Game.GetPlayer() as ObjectReference == akActivator ; #DEBUG_LINE_NO:12
    Int result = CitizenDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:13
    If result == 0 ; #DEBUG_LINE_NO:14
      If House != None && House.IsEnabled() ; #DEBUG_LINE_NO:15
        Self.MoveTo(House, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:16
      EndIf
    ElseIf result == 1 ; #DEBUG_LINE_NO:18
      If House != None && House.IsEnabled() ; #DEBUG_LINE_NO:19
        (House as aaaforthousescript).indoorCitizens = (House as aaaforthousescript).indoorCitizens + 1 ; #DEBUG_LINE_NO:20
      EndIf
      Self.Delete() ; #DEBUG_LINE_NO:22
    ElseIf result == 2 && (MainQuest as aaafortmainquestscript).InnMarker != None ; #DEBUG_LINE_NO:23
      Self.MoveTo((MainQuest as aaafortmainquestscript).InnMarker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:24
    ElseIf result == 3 && (MainQuest as aaafortmainquestscript).marker != None ; #DEBUG_LINE_NO:25
      Self.MoveTo((MainQuest as aaafortmainquestscript).marker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:26
    EndIf
  EndIf
  If Self.IsDead() && (MainQuest as aaafortmainquestscript).ScavengerCount > 0 && (akActivator != Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:30
    If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:31
      Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:32
      Utility.Wait(5 as Float) ; #DEBUG_LINE_NO:33
      Self.Delete() ; #DEBUG_LINE_NO:34
    EndIf
  EndIf
EndEvent

Event OnDeath(Actor akKiller)
  (MainQuest as aaafortmainquestscript).CitizenCount = (MainQuest as aaafortmainquestscript).CitizenCount - 1 ; #DEBUG_LINE_NO:40
  If House != None && House.IsEnabled() ; #DEBUG_LINE_NO:41
    (House as aaaforthousescript).currentCitizens = (House as aaaforthousescript).currentCitizens - 1 ; #DEBUG_LINE_NO:42
  EndIf
  Utility.Wait(30 as Float) ; #DEBUG_LINE_NO:44
  Self.Delete() ; #DEBUG_LINE_NO:45
EndEvent

Event OnUpdate()
  If (MainQuest as aaafortmainquestscript).InnFromMarker != None && Self.IsInInterior() && Self.GetParentCell() == (MainQuest as aaafortmainquestscript).InnMarker.GetParentCell() ; #DEBUG_LINE_NO:49
    Int random = Utility.RandomInt(1, 2) ; #DEBUG_LINE_NO:50
    If random == 1 ; #DEBUG_LINE_NO:51
      Self.MoveTo((MainQuest as aaafortmainquestscript).InnFromMarker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:52
    EndIf
  ElseIf (MainQuest as aaafortmainquestscript).InnFromMarker != None && Self.GetParentCell() == (MainQuest as aaafortmainquestscript).InnFromMarker.GetParentCell() ; #DEBUG_LINE_NO:54
    Int random = Utility.RandomInt(1, 2) ; #DEBUG_LINE_NO:55
    If random == 1 ; #DEBUG_LINE_NO:56
      Self.MoveTo((MainQuest as aaafortmainquestscript).InnMarker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:57
    EndIf
  EndIf
  Self.RegisterForSingleUpdate(180 as Float) ; #DEBUG_LINE_NO:60
EndEvent
