;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortDogmeatActivate.psc
Modified : 2012-08-30 10:41:59
Compiled : 2017-12-29 05:44:40
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortDogmeatActivate Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property DogDialog Auto
Book Property DogNote Auto
Bool Property isSet Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If !isSet ; #DEBUG_LINE_NO:9
    DogDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:10
    Game.GetPlayer().AddItem(DogNote as Form, 1, False) ; #DEBUG_LINE_NO:11
    isSet = True ; #DEBUG_LINE_NO:12
  EndIf
EndEvent
