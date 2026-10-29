;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortObjectCloningResetterScript.psc
Modified : 2012-09-11 16:48:09
Compiled : 2017-12-29 05:45:07
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortObjectCloningResetterScript Extends Quest

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Weapon Property aaaFortObjectCloner Auto
Quest Property aaaFortObjectCloningQuest Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

; Removed: OnInit armed a 5 second poll and OnUpdate re-armed it unconditionally, so this ran
; every 5 seconds for the whole game. When it found the object cloner equipped it called Stop()
; then Start() on aaaFortObjectCloningQuest - every 5 seconds, continuously, which refills that
; quest's five ClosestObject reference aliases each time. An alias fill searches for the nearest
; matching references, so this was the most expensive thing in the mod outside a raid.
;
; It feeds nothing. The whole object-cloning feature is unfinished scaffolding:
;
;   - nothing anywhere reads ClosestObject1-5. They are declared as properties on
;     aaafortobjectcloningquestscript and never referenced again.
;   - aaafortobjectcloningscript, the alias script that would have acted on them, has an OnHit
;     handler whose only live statement was a leftover debug notification; the If body that
;     checked for the cloner keyword is empty.
;   - aaafortobjectcloningquestscript's own 5 second poll was already removed in 3a1b4b9 for the
;     same reason - its OnUpdate did nothing but re-register itself.
;
; So three scripts and a perpetual poll existed to keep a feature warm that has no effect. The
; properties are kept so the ESP's script bindings still resolve.
;
; If the feature is ever finished, do not bring this poll back. Gate the refill on an equip
; event from a player reference alias instead.
