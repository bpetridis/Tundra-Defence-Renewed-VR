;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : TIF__0100ADBD.psc
Modified : 2012-08-23 14:45:25
Compiled : 2012-08-23 14:45:26
User     : Danny
Computer : DANNY-PC
/;
ScriptName TIF__0100ADBD Extends TopicInfo hidden

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Function Fragment_4(ObjectReference akSpeakerRef)
  Actor akSpeaker = akSpeakerRef as Actor ; #DEBUG_LINE_NO:7
  Self.GetOwningQuest().SetStage(10) ; #DEBUG_LINE_NO:9
EndFunction
