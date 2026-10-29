;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortVioletScript.psc
Modified : 2012-09-27 10:50:03
Compiled : 2017-12-29 05:45:22
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortVioletScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property BlacksmithAnvil Auto
Potion Property BlacksmithForge Auto
Potion Property BlacksmithSharpeningWheel Auto
Potion Property BlacksmithSmelter Auto
Potion Property BlacksmithWorkbench Auto
Quest Property MainQuest Auto
ObjectReference Property OutpostTravelMarker Auto
Quest Property RandomQuest Auto
Quest Property SpecialPlans Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:14
EndEvent

Event OnUpdate()
  If SpecialPlans.GetStage() == 10 && !(RandomQuest as aaafortrandomquestscript).violetGivePlans ; #DEBUG_LINE_NO:18
    Game.GetPlayer().AddItem(BlacksmithForge as Form, 1, False) ; #DEBUG_LINE_NO:19
    Game.GetPlayer().AddItem(BlacksmithSharpeningWheel as Form, 1, False) ; #DEBUG_LINE_NO:20
    Game.GetPlayer().AddItem(BlacksmithWorkbench as Form, 1, False) ; #DEBUG_LINE_NO:21
    Game.GetPlayer().AddItem(BlacksmithAnvil as Form, 1, False) ; #DEBUG_LINE_NO:22
    Game.GetPlayer().AddItem(BlacksmithSmelter as Form, 1, False) ; #DEBUG_LINE_NO:23
    (RandomQuest as aaafortrandomquestscript).violetGivePlans = True ; #DEBUG_LINE_NO:24
    Self.MoveTo(OutpostTravelMarker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:25
    (MainQuest as aaafortmainquestscript).CitizenCount = (MainQuest as aaafortmainquestscript).CitizenCount + 1 ; #DEBUG_LINE_NO:26
    Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:27
  Else
    Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:29
  EndIf
EndEvent

Event OnDeath(Actor akKiller)
  (MainQuest as aaafortmainquestscript).CitizenCount = (MainQuest as aaafortmainquestscript).CitizenCount - 1 ; #DEBUG_LINE_NO:34
EndEvent
