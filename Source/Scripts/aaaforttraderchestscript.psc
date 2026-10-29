;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortTraderChestScript.psc
Modified : 2012-09-13 16:59:07
Compiled : 2017-12-29 05:45:18
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortTraderChestScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property MainQuest Auto
Message Property TraderMessage Auto
Bool Property shownMessage = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If !shownMessage ; #DEBUG_LINE_NO:8
    TraderMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:9
    shownMessage = True ; #DEBUG_LINE_NO:10
  EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
  If akBaseItem.GetGoldValue() > 0 ; #DEBUG_LINE_NO:15
    While aiItemCount > 0 ; #DEBUG_LINE_NO:16
      (MainQuest as aaafortmainquestscript).TraderPendingSale = (MainQuest as aaafortmainquestscript).TraderPendingSale + akBaseItem.GetGoldValue() ; #DEBUG_LINE_NO:17
      aiItemCount -= 1 ; #DEBUG_LINE_NO:18
    EndWhile
  EndIf
EndEvent

Event OnItemRemoved(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
  If akBaseItem.GetGoldValue() > 0 ; #DEBUG_LINE_NO:24
    While aiItemCount > 0 ; #DEBUG_LINE_NO:25
      (MainQuest as aaafortmainquestscript).TraderPendingSale = (MainQuest as aaafortmainquestscript).TraderPendingSale - akBaseItem.GetGoldValue() ; #DEBUG_LINE_NO:26
      If (MainQuest as aaafortmainquestscript).TraderPendingSale < 0 ; #DEBUG_LINE_NO:27
        (MainQuest as aaafortmainquestscript).TraderPendingSale = 0 ; #DEBUG_LINE_NO:28
      EndIf
      aiItemCount -= 1 ; #DEBUG_LINE_NO:30
    EndWhile
  EndIf
EndEvent
