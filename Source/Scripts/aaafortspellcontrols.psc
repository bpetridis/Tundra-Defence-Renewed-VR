;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortSpellControls.psc
Modified : 2017-12-29 09:55:59
Compiled : 2017-12-29 09:56:00
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortSpellControls Extends ActiveMagicEffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Bool Property inputMinus = False Auto
Bool Property inputPlus = False Auto
aaafortmainquestscript Property placementManager Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If placementManager.stage == 1 ; #DEBUG_LINE_NO:8
    If inputMinus ; #DEBUG_LINE_NO:9
      placementManager.inputMinus = True ; #DEBUG_LINE_NO:10
    ElseIf inputPlus
      placementManager.inputPlus = True ; #DEBUG_LINE_NO:12
    EndIf
  Else
    Debug.Notification("You are not building anything right now!") ; #DEBUG_LINE_NO:15
  EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
  If placementManager.stage == 1 ; #DEBUG_LINE_NO:20
    If inputMinus ; #DEBUG_LINE_NO:21
      placementManager.inputMinus = False ; #DEBUG_LINE_NO:22
    ElseIf inputPlus
      placementManager.inputPlus = False ; #DEBUG_LINE_NO:24
    EndIf
  EndIf
EndEvent
