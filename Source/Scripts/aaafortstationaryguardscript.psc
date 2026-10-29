;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortStationaryGuardScript.psc
Modified : 2017-12-29 05:41:41
Compiled : 2017-12-29 05:45:17
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortStationaryGuardScript Extends Actor

;-- Variables ---------------------------------------

; An actor has exactly one update timer, and three things here need a delay: the post-load
; settle that records the guard's post, the delayed corpse removal, and the normal 60 second
; reposition cycle. These flags tell OnUpdate which of them a tick belongs to. None of them now
; holds a script stack open while it waits.
Bool pendingLoadInit

; 0 none, 1 delete only, 2 salvage to the scavenger crate then delete.
Int pendingDelete

;-- Properties --------------------------------------
ActorBase Property AltmerVersion Auto
Message Property ChangeGuardDialog Auto
Message Property ChangeGuardRaceDialog Auto
ActorBase Property DunmerVersion Auto
Potion Property GuardPlan Auto
ActorBase Property ImpVersion Auto
Quest Property MainQuest Auto
ActorBase Property NordVersion Auto
ActorBase Property OrcVersion Auto
ActorBase Property PatrolVersion Auto
ActorBase Property PerimeterVersion Auto
Quest Property PlayerQuest Auto
ActorBase Property RedguardVersion Auto
Message Property StationaryDialog Auto
Potion Property StationaryVersion Auto
Bool Property canChangeRace = True Auto
Bool Property isReady = False Auto
Float Property posx = 0.0 Auto
Float Property posy = 0.0 Auto
Float Property posz = 0.0 Auto
Int Property updateDay = 0 Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If !Self.IsDead() && (akActivator == Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:31
    Int result = StationaryDialog.Show((Self.IsInFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) as Int) as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:32
    If result == 0 && isReady ; #DEBUG_LINE_NO:33
      If (MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:34
        Debug.Notification("Repositioning guard...") ; #DEBUG_LINE_NO:35
      EndIf
      Self.SetPosition(posx, posy, posz) ; #DEBUG_LINE_NO:37
    ElseIf result == 1 ; #DEBUG_LINE_NO:38
      If !Self.IsDead() ; #DEBUG_LINE_NO:39
        Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:40
        Self.Delete() ; #DEBUG_LINE_NO:41
        (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount - 1 ; #DEBUG_LINE_NO:42
        Game.GetPlayer().AddItem(GuardPlan as Form, 1, False) ; #DEBUG_LINE_NO:43
      EndIf
    ElseIf result == 2 ; #DEBUG_LINE_NO:45
      If Self.IsInFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:46
        Self.RemoveFromFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:47
      Else
        Self.AddToFaction((MainQuest as aaafortmainquestscript).FollowPlayerFaction) ; #DEBUG_LINE_NO:49
        Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:50
      EndIf
      Self.EvaluatePackage() ; #DEBUG_LINE_NO:52
    ElseIf result == 3 ; #DEBUG_LINE_NO:53
      Int choice = ChangeGuardDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:54
      If choice == 0 ; #DEBUG_LINE_NO:55
        ObjectReference moveMe = Self.PlaceAtMe(PerimeterVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:56
        moveMe.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:57
        Self.Kill(None) ; #DEBUG_LINE_NO:58
        (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount - 1 ; #DEBUG_LINE_NO:59
        Self.Delete() ; #DEBUG_LINE_NO:60
      ElseIf choice == 1 ; #DEBUG_LINE_NO:61
        ObjectReference moveme = Self.PlaceAtMe(PatrolVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:62
        moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:63
        Self.Kill(None) ; #DEBUG_LINE_NO:64
        (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount - 1 ; #DEBUG_LINE_NO:65
        Self.Delete() ; #DEBUG_LINE_NO:66
      ElseIf choice == 2 ; #DEBUG_LINE_NO:67
        Game.GetPlayer().AddItem(StationaryVersion as Form, 1, False) ; #DEBUG_LINE_NO:68
        Self.Kill(None) ; #DEBUG_LINE_NO:69
        Self.Delete() ; #DEBUG_LINE_NO:70
      ElseIf choice == 3 ; #DEBUG_LINE_NO:71
        If canChangeRace ; #DEBUG_LINE_NO:72
          Int guardrace = ChangeGuardRaceDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:73
          If guardrace == 0 ; #DEBUG_LINE_NO:74
            ObjectReference moveme = Self.PlaceAtMe(NordVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:75
            moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:76
            Self.Kill(None) ; #DEBUG_LINE_NO:77
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:78
            Self.Delete() ; #DEBUG_LINE_NO:79
          ElseIf guardrace == 1 ; #DEBUG_LINE_NO:80
            ObjectReference moveme = Self.PlaceAtMe(ImpVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:81
            moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:82
            Self.Kill(None) ; #DEBUG_LINE_NO:83
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:84
            Self.Delete() ; #DEBUG_LINE_NO:85
          ElseIf guardrace == 2 ; #DEBUG_LINE_NO:86
            ObjectReference moveme = Self.PlaceAtMe(OrcVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:87
            moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:88
            Self.Kill(None) ; #DEBUG_LINE_NO:89
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:90
            Self.Delete() ; #DEBUG_LINE_NO:91
          ElseIf guardrace == 3 ; #DEBUG_LINE_NO:92
            ObjectReference moveme = Self.PlaceAtMe(RedguardVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:93
            moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:94
            Self.Kill(None) ; #DEBUG_LINE_NO:95
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:96
            Self.Delete() ; #DEBUG_LINE_NO:97
          ElseIf guardrace == 4 ; #DEBUG_LINE_NO:98
            ObjectReference moveme = Self.PlaceAtMe(AltmerVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:99
            moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:100
            Self.Kill(None) ; #DEBUG_LINE_NO:101
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:102
            Self.Delete() ; #DEBUG_LINE_NO:103
          ElseIf guardrace == 5 ; #DEBUG_LINE_NO:104
            ObjectReference moveme = Self.PlaceAtMe(DunmerVersion as Form, 1, False, False) ; #DEBUG_LINE_NO:105
            moveme.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:106
            Self.Kill(None) ; #DEBUG_LINE_NO:107
            (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:108
            Self.Delete() ; #DEBUG_LINE_NO:109
          EndIf
        Else
          Debug.Notification("You can not change the race of this type of guard.") ; #DEBUG_LINE_NO:112
        EndIf
      EndIf
    ElseIf result == 4 ; #DEBUG_LINE_NO:115
      Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:116
      Self.OpenInventory(False) ; #DEBUG_LINE_NO:117
    EndIf
  EndIf
  If Self.IsDead() && (MainQuest as aaafortmainquestscript).ScavengerCount > 0 && (akActivator != Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:121
    If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:122
      Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:123
      ; Was Utility.Wait(5) then Delete(). The items have already moved.
      pendingLoadInit = False
      pendingDelete = 1
      Self.UnregisterForUpdate()
      Self.RegisterForSingleUpdate(5 as Float) ; #DEBUG_LINE_NO:124
    EndIf
  EndIf
EndEvent

; The second-long settle before the body ran used to be a Utility.Wait holding this script's
; stack. The delay is load-bearing here - the body records the guard's post from its position,
; so the actor has to have finished moving first. A timer gives the same delay without the held
; stack, and stationary guards come in numbers.
Event OnLoad()
  pendingLoadInit = True
  Self.UnregisterForUpdate()
  Self.RegisterForSingleUpdate(1 as Float) ; #DEBUG_LINE_NO:131
EndEvent

Function LoadInit()
  If !isReady ; #DEBUG_LINE_NO:132
    posx = Self.GetPositionX() ; #DEBUG_LINE_NO:133
    posy = Self.GetPositionY() ; #DEBUG_LINE_NO:134
    posz = Self.GetPositionZ() ; #DEBUG_LINE_NO:135
    If !Self.IsInCombat() && (MainQuest as aaafortmainquestscript).equipBoxEnabled && (updateDay != Utility.GetCurrentGameTime() as Int) ; #DEBUG_LINE_NO:136
      Self.UpdateGear() ; #DEBUG_LINE_NO:137
    EndIf
    If (MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:139
      Debug.Notification("Setting position...") ; #DEBUG_LINE_NO:140
    EndIf
    isReady = True ; #DEBUG_LINE_NO:142
    Self.RegisterForSingleUpdate(60 as Float) ; #DEBUG_LINE_NO:143
  Else
    Self.RegisterForSingleUpdate(60 as Float) ; #DEBUG_LINE_NO:145
  EndIf
EndFunction

Event OnUpdate()
  ; One timer, three users. A pending delete wins, then the post-load settle, then the normal
  ; 60 second cycle. Each branch leaves the timer armed the way the original code did.
  If pendingDelete != 0
    If pendingDelete == 2
      If (MainQuest as aaafortmainquestscript).ScavengerCount > 0 && !(MainQuest as aaafortmainquestscript).equipBoxEnabled ; #DEBUG_LINE_NO:193
        If (MainQuest as aaafortmainquestscript).ScavengerCrateRef != None ; #DEBUG_LINE_NO:194
          Self.RemoveAllItems((MainQuest as aaafortmainquestscript).ScavengerCrateRef, False, False) ; #DEBUG_LINE_NO:195
        EndIf
      EndIf
    EndIf
    pendingDelete = 0
    Self.Delete() ; #DEBUG_LINE_NO:198
    Return
  EndIf
  If pendingLoadInit
    pendingLoadInit = False
    Self.LoadInit()
    Return
  EndIf
  If (PlayerQuest as aaafortplayerquestscript).killStationary ; #DEBUG_LINE_NO:150
    (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount - 1 ; #DEBUG_LINE_NO:151
    Game.GetPlayer().AddItem(GuardPlan as Form, 1, False) ; #DEBUG_LINE_NO:152
    Self.Kill(None) ; #DEBUG_LINE_NO:153
    Self.Delete() ; #DEBUG_LINE_NO:154
    Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:155
  Else
    If !Self.IsInCombat() && (MainQuest as aaafortmainquestscript).hasMedic ; #DEBUG_LINE_NO:157
      If (MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:158
        Debug.Notification("Medic Tent: Healing Guard") ; #DEBUG_LINE_NO:159
      EndIf
      Self.RestoreActorValue("health", 30 as Float) ; #DEBUG_LINE_NO:161
    ElseIf !Self.IsInCombat() && (MainQuest as aaafortmainquestscript).equipBoxEnabled && (updateDay != Utility.GetCurrentGameTime() as Int) && (MainQuest as aaafortmainquestscript).disperseDaily ; #DEBUG_LINE_NO:162
      Self.UpdateGear() ; #DEBUG_LINE_NO:163
    EndIf
    If !Self.IsDead() && !Self.IsInCombat() && isReady ; #DEBUG_LINE_NO:165
      If (MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:166
        Debug.Notification("Repositioning guard...") ; #DEBUG_LINE_NO:167
      EndIf
      Self.SetPosition(posx, posy, posz) ; #DEBUG_LINE_NO:169
      Self.RegisterForSingleUpdate(60 as Float) ; #DEBUG_LINE_NO:170
    ElseIf !Self.IsDead() ; #DEBUG_LINE_NO:171
      Self.RegisterForSingleUpdate(60 as Float) ; #DEBUG_LINE_NO:172
    EndIf
  EndIf
EndEvent

Function UpdateGear()
  Self.SetPlayerTeammate(True, True) ; #DEBUG_LINE_NO:178
EndFunction

; The other two-minute Wait, alongside the one in aaafortraiderscript. Between them they were the
; two worst offenders: during a raid both sides take casualties, and every corpse on both sides
; held a suspended script stack for two full minutes. The salvage stays on the delayed side
; because the original read ScavengerCount, equipBoxEnabled and the crate AFTER the wait.
Event OnDeath(Actor akKiller)
  pendingLoadInit = False
  pendingDelete = 2
  Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:190
  (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount - 1 ; #DEBUG_LINE_NO:191
  Self.RegisterForSingleUpdate(120 as Float) ; #DEBUG_LINE_NO:192
EndEvent
