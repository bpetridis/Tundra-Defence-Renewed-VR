;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMoveObjectScript.psc
Modified : 2017-12-29 10:41:23
Compiled : 2017-12-29 10:41:25
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMoveObjectScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Quest Property MainQuest Auto
Message Property MoveDialog Auto
ObjectReference Property collisionRef Auto
Bool Property isBoundary = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivatedObject)
  If Game.GetPlayer().IsSneaking() && (akActivatedObject == Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:10
    Int result = MoveDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:11
    If result == 0 ; #DEBUG_LINE_NO:12
      If collisionRef != None ; #DEBUG_LINE_NO:13
        (MainQuest as aaafortmainquestscript).collisionRef = collisionRef ; #DEBUG_LINE_NO:14
      Else
        (MainQuest as aaafortmainquestscript).collisionRef = None ; #DEBUG_LINE_NO:16
      EndIf
      If isBoundary ; #DEBUG_LINE_NO:18
        If ((MainQuest as aaafortmainquestscript).marker.GetDistance(Self as ObjectReference) as Int >= (MainQuest as aaafortmainquestscript).maxDistance - 500) && Self.CountLinkedRefChain(None, 8) == 3 ; #DEBUG_LINE_NO:20
          If (MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:22
            Debug.Notification("Moving boundary marker...") ; #DEBUG_LINE_NO:23
          EndIf
          (MainQuest as aaafortmainquestscript).setBoundaries = True ; #DEBUG_LINE_NO:25
          (MainQuest as aaafortmainquestscript).StartPositioning(Self as ObjectReference, None, False, False) ; #DEBUG_LINE_NO:26
        Else
          If (MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:29
            Debug.Notification("Moving patrol marker...") ; #DEBUG_LINE_NO:30
          EndIf
          (MainQuest as aaafortmainquestscript).setBoundaries = False ; #DEBUG_LINE_NO:32
          (MainQuest as aaafortmainquestscript).StartPositioning(Self as ObjectReference, None, False, False) ; #DEBUG_LINE_NO:33
        EndIf
      Else
        (MainQuest as aaafortmainquestscript).StartPositioning(Self as ObjectReference, None, False, False) ; #DEBUG_LINE_NO:36
      EndIf
    EndIf
  ElseIf akActivatedObject == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:39
    If collisionRef != None ; #DEBUG_LINE_NO:40
      collisionRef.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:41
    EndIf
  EndIf
EndEvent
