;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortGuardArmoryScript.psc
Modified : 2012-10-14 20:13:13
Compiled : 2017-12-29 05:44:47
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortGuardArmoryScript Extends Actor

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ActorBase Property CaptainA Auto
ActorBase Property CaptainB Auto
ActorBase Property CaptainC Auto
Message Property ChangeGuardCaptain Auto
MiscObject Property Gold001 Auto
Message Property GuardCaptainDialog Auto
Quest Property MainQuest Auto
ObjectReference Property MapMarker Auto
Message Property NotEnoughGold Auto
Int Property changeCost = 3000 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If (MainQuest as aaafortmainquestscript).hasArmory && (akActivator == Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:19
    Int result = GuardCaptainDialog.Show((Self.IsInFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) as Int) as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:20
    If result == 0 ; #DEBUG_LINE_NO:21
      Int captain = ChangeGuardCaptain.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:22
      If captain == 0 ; #DEBUG_LINE_NO:23
        If Game.GetPlayer().GetItemCount(Gold001 as Form) >= changeCost ; #DEBUG_LINE_NO:24
          Game.GetPlayer().RemoveItem(Gold001 as Form, changeCost, False, None) ; #DEBUG_LINE_NO:25
          MapMarker.PlaceActorAtMe(CaptainA, 4, None) ; #DEBUG_LINE_NO:26
          Self.Delete() ; #DEBUG_LINE_NO:27
        Else
          NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:29
        EndIf
      ElseIf captain == 1 ; #DEBUG_LINE_NO:31
        If Game.GetPlayer().GetItemCount(Gold001 as Form) >= changeCost ; #DEBUG_LINE_NO:32
          Game.GetPlayer().RemoveItem(Gold001 as Form, changeCost, False, None) ; #DEBUG_LINE_NO:33
          MapMarker.PlaceActorAtMe(CaptainB, 4, None) ; #DEBUG_LINE_NO:34
          Self.Delete() ; #DEBUG_LINE_NO:35
        Else
          NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:37
        EndIf
      ElseIf captain == 2 ; #DEBUG_LINE_NO:39
        If Game.GetPlayer().GetItemCount(Gold001 as Form) >= changeCost ; #DEBUG_LINE_NO:40
          Game.GetPlayer().RemoveItem(Gold001 as Form, changeCost, False, None) ; #DEBUG_LINE_NO:41
          MapMarker.PlaceActorAtMe(CaptainC, 4, None) ; #DEBUG_LINE_NO:42
          Self.Delete() ; #DEBUG_LINE_NO:43
        Else
          NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:45
        EndIf
      EndIf
    ElseIf result == 1 ; #DEBUG_LINE_NO:48
      If Self.IsInFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:49
        Self.RemoveFromFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:50
      Else
        Self.AddToFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:52
        Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:53
      EndIf
      Self.EvaluatePackage() ; #DEBUG_LINE_NO:55
    ElseIf result == 2 ; #DEBUG_LINE_NO:56
      Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:57
      Self.OpenInventory(False) ; #DEBUG_LINE_NO:58
    EndIf
  EndIf
EndEvent
