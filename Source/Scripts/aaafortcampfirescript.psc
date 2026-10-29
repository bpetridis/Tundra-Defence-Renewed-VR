;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortCampfireScript.psc
Modified : 2012-09-27 12:35:13
Compiled : 2017-12-29 05:44:36
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortCampfireScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property CampfireDialog Auto
Light Property CampfireLight Auto
Potion Property CampfirePlan Auto
Quest Property MainQuest Auto
ObjectReference Property ThisLight Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:10
EndEvent

Event OnActivate(ObjectReference akActivator)
  Int result = CampfireDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:14
  If result == 0 ; #DEBUG_LINE_NO:15
    If ThisLight == None ; #DEBUG_LINE_NO:16
      ThisLight = Self.PlaceAtMe(CampfireLight as Form, 1, False, False) ; #DEBUG_LINE_NO:17
    ElseIf ThisLight.isDisabled() ; #DEBUG_LINE_NO:19
      ThisLight.Enable(False) ; #DEBUG_LINE_NO:20
    Else
      ThisLight.Disable(False) ; #DEBUG_LINE_NO:22
    EndIf
  ElseIf result == 1 ; #DEBUG_LINE_NO:25
    Game.GetPlayer().AddItem(CampfirePlan as Form, 1, False) ; #DEBUG_LINE_NO:26
    If ThisLight != None ; #DEBUG_LINE_NO:27
      ThisLight.Delete() ; #DEBUG_LINE_NO:28
    EndIf
    Self.Delete() ; #DEBUG_LINE_NO:30
  EndIf
EndEvent

Event OnUpdate()
  If (MainQuest as aaafortmainquestscript).stage == 0 && (MainQuest as aaafortmainquestscript).status == "placed" ; #DEBUG_LINE_NO:35
    If ThisLight == None ; #DEBUG_LINE_NO:36
      ThisLight = Self.PlaceAtMe(CampfireLight as Form, 1, False, False) ; #DEBUG_LINE_NO:37
    EndIf
  Else
    Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:40
  EndIf
EndEvent
