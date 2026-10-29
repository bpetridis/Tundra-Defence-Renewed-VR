;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortObjectCloningScript.psc
Modified : 2017-12-29 05:46:45
Compiled : 2017-12-29 05:46:47
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortObjectCloningScript Extends ReferenceAlias

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Keyword Property aaaFortObjectCloningKey Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

; Removed: an OnHit handler whose only live statement was a debug notification reading
; "<base object>I was hit!" - development scaffolding that shipped to users. The inner If, which
; checked the hit source for the cloner keyword, had an empty body, so the handler did nothing
; else. This script sits on the five ClosestObject aliases, so it was registering an OnHit
; handler on whatever happened to be nearest the player and printing to screen on every hit.
;
; See aaafortobjectcloningresetterscript for why the whole cloning feature is inert. The keyword
; property is kept so the ESP's script binding still resolves.
