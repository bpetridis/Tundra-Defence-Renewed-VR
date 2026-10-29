;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortSpellControlsConfirmScript.psc
Modified : 2017-12-29 10:11:33
Compiled : 2017-12-29 10:11:34
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortSpellControlsConfirmScript Extends ActiveMagicEffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Bool Property inputCancel = False Auto
Bool Property inputConfirm = False Auto
aaafortmainquestscript Property placementManager Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnEffectStart(Actor akTarget, Actor akCaster)
  If placementManager.stage == 1 ; #DEBUG_LINE_NO:8
    If inputConfirm && Game.GetPlayer().IsSneaking() ; #DEBUG_LINE_NO:9
      placementManager.CancelPlacement() ; #DEBUG_LINE_NO:10
    ElseIf inputConfirm
      placementManager.ConfirmPlacement() ; #DEBUG_LINE_NO:12
    ElseIf inputCancel
      placementManager.CancelPlacement() ; #DEBUG_LINE_NO:14
    EndIf
  Else
    Debug.Notification("You are not building anything right now!") ; #DEBUG_LINE_NO:17
  EndIf
EndEvent
