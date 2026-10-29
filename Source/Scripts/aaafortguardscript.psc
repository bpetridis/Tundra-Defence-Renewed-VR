;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortGuardScript.psc
Modified : 2017-12-29 15:57:46
Compiled : 2017-12-29 15:57:48
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortGuardScript Extends Actor

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ActorBase Property AltmerVersion Auto
Message Property ChangeGuardDialog Auto
Message Property ChangeGuardRaceDialog Auto
ActorBase Property DunmerVersion Auto
Message Property GuardDialog Auto
ActorBase Property ImpVersion Auto
Quest Property MainQuest Auto
ActorBase Property NordVersion Auto
ActorBase Property OrcVersion Auto
ActorBase Property PatrolVersion Auto
ActorBase Property PerimeterVersion Auto
ActorBase Property RedguardVersion Auto
Potion Property StationaryVersion Auto
Bool Property canChangeRace = False Auto
Int Property changeGuardCost = 100 Auto
Bool Property isReady = False Auto
Int Property updateDay = 0 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnLoad()
  Utility.Wait(1 as Float) ; #DEBUG_LINE_NO:24
  If Self.GetBaseObject() != Game.GetForm(318834472) ; #DEBUG_LINE_NO:25
    Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:26
    Self.RegisterForSingleUpdate(60 as Float) ; #DEBUG_LINE_NO:27
  EndIf
  If !isReady ; #DEBUG_LINE_NO:29
    If !Self.IsInCombat() && (MainQuest as aaafortmainquestscript).equipBoxEnabled && (updateDay != Utility.GetCurrentGameTime() as Int) ; #DEBUG_LINE_NO:30
      Self.UpdateGear() ; #DEBUG_LINE_NO:31
    EndIf
    isReady = True ; #DEBUG_LINE_NO:33
  EndIf
EndEvent

Event OnUpdate()
  If Self.GetBaseObject() != Game.GetForm(318834472) ; #DEBUG_LINE_NO:38
    If !Self.IsInCombat() && (MainQuest as aaafortmainquestscript).hasMedic ; #DEBUG_LINE_NO:39
      If (MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:40
        Debug.Notification("Medic Tent: Healing Guard") ; #DEBUG_LINE_NO:41
      EndIf
      Self.RestoreActorValue("health", 30 as Float) ; #DEBUG_LINE_NO:43
    ElseIf !Self.IsInCombat() && (MainQuest as aaafortmainquestscript).equipBoxEnabled && (updateDay != Utility.GetCurrentGameTime() as Int) && (MainQuest as aaafortmainquestscript).disperseDaily ; #DEBUG_LINE_NO:44
      Self.UpdateGear() ; #DEBUG_LINE_NO:45
    EndIf
    Self.RegisterForSingleUpdate(60 as Float) ; #DEBUG_LINE_NO:47
  EndIf
EndEvent

Function UpdateGear()
  Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:52
EndFunction

Event OnDeath(Actor akKiller)
  If Self.GetBaseObject() != Game.GetForm(318834472) ; #DEBUG_LINE_NO:64
    Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:65
    (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount - 1 ; #DEBUG_LINE_NO:66
    Utility.Wait(30 as Float) ; #DEBUG_LINE_NO:67
    If (MainQuest as aaafortmainquestscript).ScavengerCount > 0 ; #DEBUG_LINE_NO:68
      If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:69
        Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:70
      EndIf
    EndIf
    Self.Delete() ; #DEBUG_LINE_NO:73
  EndIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
  If Self.GetBaseObject() != Game.GetForm(318834472) ; #DEBUG_LINE_NO:78
    If (akActionRef == Game.GetPlayer() as ObjectReference) && !Self.IsDead() ; #DEBUG_LINE_NO:79
      If (MainQuest as aaafortmainquestscript).hasArmory ; #DEBUG_LINE_NO:80
        Int result = GuardDialog.Show((Self.IsInFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) as Int) as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:81
        If result == 0 ; #DEBUG_LINE_NO:82
          Int choice = ChangeGuardDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:83
          If choice == 0 ; #DEBUG_LINE_NO:84
            ObjectReference moveMe = Self.PlaceAtMe(PerimeterVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:85
            moveMe.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:86
            Self.Kill(None) ; #DEBUG_LINE_NO:87
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:88
            Self.Delete() ; #DEBUG_LINE_NO:89
          ElseIf choice == 1 ; #DEBUG_LINE_NO:90
            ObjectReference moveme = Self.PlaceAtMe(PatrolVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:91
            moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:92
            Self.Kill(None) ; #DEBUG_LINE_NO:93
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:94
            Self.Delete() ; #DEBUG_LINE_NO:95
          ElseIf choice == 2 ; #DEBUG_LINE_NO:96
            Self.Kill(None) ; #DEBUG_LINE_NO:97
            Game.GetPlayer().AddItem(StationaryVersion as Form, 1, False) ; #DEBUG_LINE_NO:98
            Self.Delete() ; #DEBUG_LINE_NO:99
          ElseIf choice == 3 ; #DEBUG_LINE_NO:100
            If canChangeRace && NordVersion != None ; #DEBUG_LINE_NO:101
              Int guardrace = ChangeGuardRaceDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:102
              If guardrace == 0 ; #DEBUG_LINE_NO:103
                ObjectReference moveme = Self.PlaceAtMe(NordVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:104
                moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:105
                Self.Kill(None) ; #DEBUG_LINE_NO:106
                (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:107
                Self.Delete() ; #DEBUG_LINE_NO:108
              ElseIf guardrace == 1 ; #DEBUG_LINE_NO:109
                ObjectReference moveme = Self.PlaceAtMe(ImpVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:110
                moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:111
                Self.Kill(None) ; #DEBUG_LINE_NO:112
                (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:113
                Self.Delete() ; #DEBUG_LINE_NO:114
              ElseIf guardrace == 2 ; #DEBUG_LINE_NO:115
                ObjectReference moveme = Self.PlaceAtMe(OrcVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:116
                moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:117
                Self.Kill(None) ; #DEBUG_LINE_NO:118
                (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:119
                Self.Delete() ; #DEBUG_LINE_NO:120
              ElseIf guardrace == 3 ; #DEBUG_LINE_NO:121
                ObjectReference moveme = Self.PlaceAtMe(RedguardVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:122
                moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:123
                Self.Kill(None) ; #DEBUG_LINE_NO:124
                (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:125
                Self.Delete() ; #DEBUG_LINE_NO:126
              ElseIf guardrace == 4 ; #DEBUG_LINE_NO:127
                ObjectReference moveme = Self.PlaceAtMe(AltmerVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:128
                moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:129
                Self.Kill(None) ; #DEBUG_LINE_NO:130
                (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:131
                Self.Delete() ; #DEBUG_LINE_NO:132
              ElseIf guardrace == 5 ; #DEBUG_LINE_NO:133
                ObjectReference moveme = Self.PlaceAtMe(DunmerVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:134
                moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:135
                Self.Kill(None) ; #DEBUG_LINE_NO:136
                (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:137
                Self.Delete() ; #DEBUG_LINE_NO:138
              EndIf
            Else
              Debug.Notification("You can not change the race of this type of guard.") ; #DEBUG_LINE_NO:141
            EndIf
          EndIf
        ElseIf result == 1 ; #DEBUG_LINE_NO:144
          If Self.IsInFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:145
            Self.RemoveFromFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:146
          Else
            Self.AddToFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:148
            Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:149
          EndIf
          Self.EvaluatePackage() ; #DEBUG_LINE_NO:151
        Else
          Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:153
          Self.OpenInventory(False) ; #DEBUG_LINE_NO:154
        EndIf
      EndIf
    EndIf
    If Self.IsDead() && (MainQuest as aaafortmainquestscript).ScavengerCount > 0 && !(MainQuest as aaafortmainquestscript).equipBoxEnabled && (akActionRef != Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:159
      If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:160
        Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:161
        Utility.Wait(5 as Float) ; #DEBUG_LINE_NO:162
        Self.Delete() ; #DEBUG_LINE_NO:163
      EndIf
    EndIf
  EndIf
EndEvent
