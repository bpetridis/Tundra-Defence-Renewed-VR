;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortObjectCloningQuestScript.psc
Modified : 2012-09-11 17:12:36
Compiled : 2017-12-29 05:45:06
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortObjectCloningQuestScript Extends Quest

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ReferenceAlias Property ClosestObject1 Auto
ReferenceAlias Property ClosestObject2 Auto
ReferenceAlias Property ClosestObject3 Auto
ReferenceAlias Property ClosestObject4 Auto
ReferenceAlias Property ClosestObject5 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

; Removed: OnInit armed a 5 second poll and OnUpdate did nothing except arm it again, so this
; quest woke up every 5 seconds for the whole game to do absolutely nothing. The quest exists to
; hold the ClosestObject aliases above, which the quest system fills - no script tick is involved.
; Nothing else called into this script, so removing both events changes no behaviour.
