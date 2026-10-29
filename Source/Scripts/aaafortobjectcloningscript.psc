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

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
  Debug.Notification(Self.GetReference().GetBaseObject() as String + "I was hit!") ; #DEBUG_LINE_NO:6
  If akAggressor == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:7
    If akSource.HasKeyword(aaaFortObjectCloningKey) ; #DEBUG_LINE_NO:8
      
    EndIf
  EndIf
EndEvent
