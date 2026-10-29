;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortPlayerQuestScript.psc
Modified : 2017-12-31 06:41:12
Compiled : 2017-12-31 06:41:14
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortPlayerQuestScript Extends Quest conditional

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ObjectReference Property BoundaryMarkerA Auto
ObjectReference Property BoundaryMarkerB Auto
ObjectReference Property BoundaryMarkerC Auto
ObjectReference Property BoundaryMarkerD Auto
Int Property CurrentRaiders = 0 Auto
Message Property EnemiesSightedDialog Auto
Faction Property FortFaction Auto
Quest Property MainQuest Auto
Potion[] Property PlanInventory Auto
Message Property PlayerMenu Auto
Bool Property PlayerRaids = False Auto
Message Property RaidDifficultyMenu Auto
Message Property RaidEnded Auto
Message Property RaidFrequencyHighDialog Auto
Message Property RaidFrequencyLowDialog Auto
Message Property RaidFrequencyMediumDialog Auto
Message Property RaidFrequencyMenu Auto
Message Property RaidInProgressDialog Auto
Message Property RaidMenu Auto
Message Property RaidMenuB Auto
Message Property RaidMenuC Auto
Sound Property RaidSound Auto
ActorBase Property RaiderBanditBoss Auto
ActorBase Property RaiderBanditMelee Auto
ActorBase Property RaiderBanditRanged Auto
ActorBase Property RaiderBanditWizard Auto
ActorBase Property RaiderDragon Auto
ActorBase Property RaiderDraugrBoss Auto
ActorBase Property RaiderDraugrMeleeF Auto
ActorBase Property RaiderDraugrMeleeM Auto
ActorBase Property RaiderDraugrRanged Auto
ActorBase Property RaiderDraugrWizard Auto
Faction Property RaiderFaction Auto
ActorBase Property RaiderFalmerBoss Auto
ActorBase Property RaiderFalmerMelee Auto
ActorBase Property RaiderFalmerRanged Auto
ActorBase Property RaiderFalmerShaman Auto
ActorBase Property RaiderGiantA Auto
ActorBase Property RaiderGiantB Auto
ActorBase Property RaiderGiantLeader Auto
ActorBase Property RaiderMammoth Auto
ActorBase Property RaiderNatureBear Auto
ActorBase Property RaiderNatureChaurus Auto
ActorBase Property RaiderNatureChaurusReaper Auto
ActorBase Property RaiderNatureIceWraith Auto
ActorBase Property RaiderNatureSabre Auto
ActorBase Property RaiderNatureSkeever Auto
ActorBase Property RaiderNatureSpider Auto
ActorBase Property RaiderNatureTroll Auto
ActorBase Property RaiderNatureWolf Auto
ActorBase Property RaiderNecromancer Auto
ActorBase Property RaiderNecromancerBoss Auto
ActorBase Property RaiderVampire Auto
ActorBase Property RaiderVampireBoss Auto
ActorBase Property RaiderWerewolf Auto
ActorBase Property RaiderWerewolfBoss Auto
Quest Property RandomQuest Auto
Message Property RebindMenu Auto
Potion Property Rebinder Auto
Message Property SettingsBMenu Auto
Message Property SettingsCMenu Auto
Message Property SettingsDMenu Auto
Message Property SettingsMenu Auto
Message Property StationaryGuardPurgeEndDialog Auto
Message Property StationaryGuardPurgeStartDialog Auto
Quest Property TutorialQuest Auto
ObjectReference Property WaterWellRef Auto
Int Property hasGrandEstate = 0 Auto conditional
Bool Property hasRebinder = False Auto
Int Property hasWoodenCabin = 0 Auto conditional
Bool Property isRaid = False Auto
Int Property keyMenu = 40 Auto
Bool Property killStationary = False Auto
Int Property raidHandicap = 0 Auto

;-- Functions ---------------------------------------

Function BindKey(Int BindKey)
  ; Empty function
EndFunction

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Function RebindDialog()
  ; Empty function
EndFunction

Event OnInit()
  ; Only watch while a raid is actually running. Originally this armed a 1 second poll here and
  ; re-armed it unconditionally at the end of OnUpdate, so it ran for the whole game even though
  ; both checks below need isRaid. Covers the odd case of starting up with a raid already set.
  If isRaid
    Self.RegisterForSingleUpdate(1 as Float)
  EndIf
EndEvent

; Sets the raid flag and starts the watch. Every raid function calls this instead of assigning
; isRaid directly, so the poll can never be left running with no raid, or missing during one.
; Re-registering while an update is already pending simply replaces it, so repeat calls are safe.
Function BeginRaid()
  isRaid = True
  Self.RegisterForSingleUpdate(1 as Float)
EndFunction

Event OnUpdate()
  If isRaid && Game.GetPlayer().IsInFaction(RaiderFaction) && (MainQuest as aaafortmainquestscript).GuardCount <= 0 ; #DEBUG_LINE_NO:106
    Self.EndRaid() ; #DEBUG_LINE_NO:107
  EndIf
  If isRaid && CurrentRaiders <= 0 ; #DEBUG_LINE_NO:110
    Self.EndRaid() ; #DEBUG_LINE_NO:111
  EndIf
  ; EndRaid clears isRaid, so this stops the poll as soon as the raid is over.
  If isRaid
    Self.RegisterForSingleUpdate(1 as Float)
  EndIf
EndEvent

Int Function iGetKeyPressed(Int aiDXScanCode)
  Debug.Notification("Press and hold an unused key...") ; #DEBUG_LINE_NO:155
  Return aiDXScanCode ; #DEBUG_LINE_NO:157
EndFunction

Function ShowDialog()
  Int result = PlayerMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:161
  If result == 0 ; #DEBUG_LINE_NO:162
    If !isRaid ; #DEBUG_LINE_NO:163
      Self.Raid() ; #DEBUG_LINE_NO:164
    Else
      RaidInProgressDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:166
    EndIf
  ElseIf result == 1 ; #DEBUG_LINE_NO:168
    Self.RaidFrequency() ; #DEBUG_LINE_NO:169
  ElseIf result == 2 ; #DEBUG_LINE_NO:170
    Self.Settings() ; #DEBUG_LINE_NO:171
  EndIf
EndFunction

Function RaidFrequency()
  Int result = RaidFrequencyMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:176
  If result == 0 ; #DEBUG_LINE_NO:177
    (RandomQuest as aaafortrandomquestscript).randomFrequency = 50 ; #DEBUG_LINE_NO:178
    Self.ShowDialog() ; #DEBUG_LINE_NO:179
    RaidFrequencyHighDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:180
  ElseIf result == 1 ; #DEBUG_LINE_NO:181
    (RandomQuest as aaafortrandomquestscript).randomFrequency = 100 ; #DEBUG_LINE_NO:182
    Self.ShowDialog() ; #DEBUG_LINE_NO:183
    RaidFrequencyMediumDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:184
  ElseIf result == 2 ; #DEBUG_LINE_NO:185
    (RandomQuest as aaafortrandomquestscript).randomFrequency = 150 ; #DEBUG_LINE_NO:186
    Self.ShowDialog() ; #DEBUG_LINE_NO:187
    RaidFrequencyLowDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:188
  Else
    Self.ShowDialog() ; #DEBUG_LINE_NO:190
  EndIf
EndFunction

Function Settings()
  Int Settings = SettingsMenu.Show((MainQuest as aaafortmainquestscript).RotationSpeed as Float, (MainQuest as aaafortmainquestscript).DistanceSpeed as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:195
  If Settings == 0 ; #DEBUG_LINE_NO:196
    (MainQuest as aaafortmainquestscript).RotationSpeed = (MainQuest as aaafortmainquestscript).RotationSpeed + 5 ; #DEBUG_LINE_NO:197
    Self.Settings() ; #DEBUG_LINE_NO:198
  ElseIf Settings == 1 ; #DEBUG_LINE_NO:199
    If (MainQuest as aaafortmainquestscript).RotationSpeed >= 10 ; #DEBUG_LINE_NO:200
      (MainQuest as aaafortmainquestscript).RotationSpeed = (MainQuest as aaafortmainquestscript).RotationSpeed - 5 ; #DEBUG_LINE_NO:201
    EndIf
    Self.Settings() ; #DEBUG_LINE_NO:203
  ElseIf Settings == 2 ; #DEBUG_LINE_NO:204
    (MainQuest as aaafortmainquestscript).DistanceSpeed = (MainQuest as aaafortmainquestscript).DistanceSpeed + 5 ; #DEBUG_LINE_NO:205
    Self.Settings() ; #DEBUG_LINE_NO:206
  ElseIf Settings == 3 ; #DEBUG_LINE_NO:207
    If (MainQuest as aaafortmainquestscript).DistanceSpeed >= 10 ; #DEBUG_LINE_NO:208
      (MainQuest as aaafortmainquestscript).DistanceSpeed = (MainQuest as aaafortmainquestscript).DistanceSpeed - 5 ; #DEBUG_LINE_NO:209
    EndIf
    Self.Settings() ; #DEBUG_LINE_NO:211
  ElseIf Settings == 4 ; #DEBUG_LINE_NO:212
    Self.SettingsB() ; #DEBUG_LINE_NO:213
  EndIf
EndFunction

Function SettingsB()
  Int Settings = SettingsBMenu.Show(((RandomQuest as aaafortrandomquestscript).RandomRaidEnabled as Int) as Float, ((MainQuest as aaafortmainquestscript).DebugMode as Int) as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:218
  If Settings == 0 ; #DEBUG_LINE_NO:219
    (RandomQuest as aaafortrandomquestscript).RandomRaidEnabled = !(RandomQuest as aaafortrandomquestscript).RandomRaidEnabled ; #DEBUG_LINE_NO:220
    Self.SettingsB() ; #DEBUG_LINE_NO:221
  ElseIf Settings == 1 ; #DEBUG_LINE_NO:222
    (MainQuest as aaafortmainquestscript).DebugMode = !(MainQuest as aaafortmainquestscript).DebugMode ; #DEBUG_LINE_NO:223
    Self.SettingsB() ; #DEBUG_LINE_NO:224
  ElseIf Settings == 2 ; #DEBUG_LINE_NO:225
    killStationary = True ; #DEBUG_LINE_NO:226
    StationaryGuardPurgeStartDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:227
    Self.KillStationaryGuards() ; #DEBUG_LINE_NO:228
  ElseIf Settings == 3 ; #DEBUG_LINE_NO:229
    Self.SettingsC() ; #DEBUG_LINE_NO:230
  Else
    Self.Settings() ; #DEBUG_LINE_NO:232
  EndIf
EndFunction

Function SettingsC()
  Int Settings = SettingsCMenu.Show(((MainQuest as aaafortmainquestscript).AdvancedMode as Int) as Float, ((MainQuest as aaafortmainquestscript).hideIdleMarkers as Int) as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:237
  If Settings == 0 ; #DEBUG_LINE_NO:238
    (MainQuest as aaafortmainquestscript).AdvancedMode = !(MainQuest as aaafortmainquestscript).AdvancedMode ; #DEBUG_LINE_NO:239
    Self.SettingsC() ; #DEBUG_LINE_NO:240
  ElseIf Settings == 1 ; #DEBUG_LINE_NO:241
    (MainQuest as aaafortmainquestscript).hideIdleMarkers = !(MainQuest as aaafortmainquestscript).hideIdleMarkers ; #DEBUG_LINE_NO:242
    Self.SettingsC() ; #DEBUG_LINE_NO:243
  ElseIf Settings == 2 ; #DEBUG_LINE_NO:244
    Self.SettingsD() ; #DEBUG_LINE_NO:245
  Else
    Self.SettingsB() ; #DEBUG_LINE_NO:247
  EndIf
EndFunction

Function SettingsD()
  Int Settings = SettingsDMenu.Show((PlayerRaids as Int) as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:252
  If Settings == 0 ; #DEBUG_LINE_NO:253
    PlayerRaids = !PlayerRaids ; #DEBUG_LINE_NO:254
    Self.SettingsD() ; #DEBUG_LINE_NO:255
  Else
    Self.SettingsC() ; #DEBUG_LINE_NO:257
  EndIf
EndFunction

Function KillStationaryGuards()
  Utility.Wait(60 as Float) ; #DEBUG_LINE_NO:263
  killStationary = False ; #DEBUG_LINE_NO:264
  StationaryGuardPurgeEndDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:265
EndFunction

Function Raid()
  Int Raid = RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:269
  If Raid == 0 ; #DEBUG_LINE_NO:270
    Self.BanditRaid(-1) ; #DEBUG_LINE_NO:271
  ElseIf Raid == 1 ; #DEBUG_LINE_NO:272
    Self.DraugrRaid(-1) ; #DEBUG_LINE_NO:273
  ElseIf Raid == 2 ; #DEBUG_LINE_NO:274
    Self.DragonRaid(-1) ; #DEBUG_LINE_NO:275
  ElseIf Raid == 3 ; #DEBUG_LINE_NO:276
    Self.RaidB() ; #DEBUG_LINE_NO:277
  Else
    Self.ShowDialog() ; #DEBUG_LINE_NO:279
  EndIf
EndFunction

Function RaidB()
  Int Raid = RaidMenuB.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:284
  If Raid == 0 ; #DEBUG_LINE_NO:285
    Self.NecroRaid(-1) ; #DEBUG_LINE_NO:286
  ElseIf Raid == 1 ; #DEBUG_LINE_NO:287
    Self.NatureRaid(-1) ; #DEBUG_LINE_NO:288
  ElseIf Raid == 2 ; #DEBUG_LINE_NO:289
    Self.GiantRaid(-1) ; #DEBUG_LINE_NO:290
  ElseIf Raid == 3 ; #DEBUG_LINE_NO:291
    Self.RaidC() ; #DEBUG_LINE_NO:292
  ElseIf Raid == 4 ; #DEBUG_LINE_NO:293
    Self.Raid() ; #DEBUG_LINE_NO:294
  EndIf
EndFunction

Function RaidC()
  Int Raid = RaidMenuC.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:299
  If Raid == 0 ; #DEBUG_LINE_NO:300
    Self.VampireRaid(-1) ; #DEBUG_LINE_NO:301
  ElseIf Raid == 1 ; #DEBUG_LINE_NO:302
    Self.WerewolfRaid(-1) ; #DEBUG_LINE_NO:303
  ElseIf Raid == 2 ; #DEBUG_LINE_NO:304
    Self.FalmerRaid(-1) ; #DEBUG_LINE_NO:305
  ElseIf Raid == 3 ; #DEBUG_LINE_NO:306
    Self.RaidB() ; #DEBUG_LINE_NO:307
  EndIf
EndFunction

ActorBase Function RandomActor(ActorBase[] random)
  If random.Length > 0 ; #DEBUG_LINE_NO:312
    Return random[Utility.RandomInt(0, random.Length - 1)] ; #DEBUG_LINE_NO:313
  EndIf
  Return None ; #DEBUG_LINE_NO:315
EndFunction

Potion Function RandomPlan()
  If PlanInventory.Length > 0 ; #DEBUG_LINE_NO:319
    Return PlanInventory[Utility.RandomInt(0, PlanInventory.Length - 1)] ; #DEBUG_LINE_NO:320
  EndIf
  Return None ; #DEBUG_LINE_NO:322
EndFunction

ObjectReference Function RandomSpawnPoint()
  Int ran = Utility.RandomInt(0, 3) ; #DEBUG_LINE_NO:326
  If ran == 0 ; #DEBUG_LINE_NO:327
    Return BoundaryMarkerA ; #DEBUG_LINE_NO:328
  ElseIf ran == 1 ; #DEBUG_LINE_NO:329
    Return BoundaryMarkerB ; #DEBUG_LINE_NO:330
  ElseIf ran == 2 ; #DEBUG_LINE_NO:331
    Return BoundaryMarkerC ; #DEBUG_LINE_NO:332
  EndIf
  Return BoundaryMarkerD ; #DEBUG_LINE_NO:334
EndFunction

Function EndRaid()
  If TutorialQuest.GetStage() == 70 && (TutorialQuest as aaaforttutorialscript).firstRaid == True ; #DEBUG_LINE_NO:338
    (TutorialQuest as aaaforttutorialscript).firstRaid = False ; #DEBUG_LINE_NO:339
  EndIf
  isRaid = False ; #DEBUG_LINE_NO:341
  CurrentRaiders = 0 ; #DEBUG_LINE_NO:342
  If Game.GetPlayer().IsInFaction(RaiderFaction) ; #DEBUG_LINE_NO:343
    Game.GetPlayer().RemoveFromFaction(RaiderFaction) ; #DEBUG_LINE_NO:344
  EndIf
  If !Game.GetPlayer().IsInFaction(FortFaction) ; #DEBUG_LINE_NO:346
    Game.GetPlayer().AddToFaction(FortFaction) ; #DEBUG_LINE_NO:347
  EndIf
  RaidEnded.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:349
EndFunction

Function RandomRaid()
  Int type = Utility.RandomInt(1, 9) ; #DEBUG_LINE_NO:353
  If type == 1 ; #DEBUG_LINE_NO:354
    Self.BanditRaid(0) ; #DEBUG_LINE_NO:355
  ElseIf type == 2 ; #DEBUG_LINE_NO:356
    Self.DraugrRaid(0) ; #DEBUG_LINE_NO:357
  ElseIf type == 3 ; #DEBUG_LINE_NO:358
    Self.DragonRaid(0) ; #DEBUG_LINE_NO:359
  ElseIf type == 4 && Game.GetPlayer().GetLevel() >= 15 ; #DEBUG_LINE_NO:360
    Self.NatureRaid(0) ; #DEBUG_LINE_NO:361
  ElseIf type == 5 && Game.GetPlayer().GetLevel() >= 30 ; #DEBUG_LINE_NO:362
    Self.GiantRaid(0) ; #DEBUG_LINE_NO:363
  ElseIf type == 6 ; #DEBUG_LINE_NO:364
    Self.NecroRaid(0) ; #DEBUG_LINE_NO:365
  ElseIf type == 7 && Game.GetPlayer().GetLevel() >= 10 ; #DEBUG_LINE_NO:366
    Self.VampireRaid(0) ; #DEBUG_LINE_NO:367
  ElseIf type == 8 && Game.GetPlayer().GetLevel() >= 15 ; #DEBUG_LINE_NO:368
    Self.WerewolfRaid(0) ; #DEBUG_LINE_NO:369
  ElseIf type == 9 ; #DEBUG_LINE_NO:370
    Self.FalmerRaid(0) ; #DEBUG_LINE_NO:371
  EndIf
EndFunction

Function BanditRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:376
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:377
  EndIf
  ActorBase[] enemies = new ActorBase[3] ; #DEBUG_LINE_NO:379
  enemies[0] = RaiderBanditMelee ; #DEBUG_LINE_NO:380
  enemies[1] = RaiderBanditRanged ; #DEBUG_LINE_NO:381
  enemies[2] = RaiderBanditWizard ; #DEBUG_LINE_NO:382
  Int count = 0 ; #DEBUG_LINE_NO:384
  Int min = 0 ; #DEBUG_LINE_NO:385
  Int max = 0 ; #DEBUG_LINE_NO:386
  Int total = 0 ; #DEBUG_LINE_NO:387
  If difficulty == 0 ; #DEBUG_LINE_NO:389
    min = 2 + raidHandicap ; #DEBUG_LINE_NO:390
    max = 6 + raidHandicap ; #DEBUG_LINE_NO:391
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:392
    count = 0 ; #DEBUG_LINE_NO:393
    While count < total ; #DEBUG_LINE_NO:394
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:395
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:396
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:397
        If plan != None ; #DEBUG_LINE_NO:398
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:399
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:402
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:403
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderBanditBoss, 4, None) ; #DEBUG_LINE_NO:405
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:406
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:407
      If plan != None ; #DEBUG_LINE_NO:408
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:409
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:412
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:414
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:415
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:416
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:417
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:419
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:420
    min = 7 + raidHandicap ; #DEBUG_LINE_NO:421
    max = 13 + raidHandicap ; #DEBUG_LINE_NO:422
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:423
    count = 0 ; #DEBUG_LINE_NO:424
    While count < total ; #DEBUG_LINE_NO:425
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:426
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:427
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:428
        If plan != None ; #DEBUG_LINE_NO:429
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:430
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:433
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:434
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderBanditBoss, 4, None) ; #DEBUG_LINE_NO:436
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:437
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:438
      If plan != None ; #DEBUG_LINE_NO:439
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:440
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:443
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:445
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:446
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:447
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:448
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:450
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:451
    min = 14 + raidHandicap ; #DEBUG_LINE_NO:452
    max = 20 + raidHandicap ; #DEBUG_LINE_NO:453
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:454
    count = 0 ; #DEBUG_LINE_NO:455
    While count < total ; #DEBUG_LINE_NO:456
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:457
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:458
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:459
        If plan != None ; #DEBUG_LINE_NO:460
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:461
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:464
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:465
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderBanditBoss, 4, None) ; #DEBUG_LINE_NO:467
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:468
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:469
      If plan != None ; #DEBUG_LINE_NO:470
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:471
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:474
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:476
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:477
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:478
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:479
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:481
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:482
    raidHandicap += 1 ; #DEBUG_LINE_NO:483
    Self.BanditRaid(-1) ; #DEBUG_LINE_NO:484
    Return  ; #DEBUG_LINE_NO:485
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:486
    raidHandicap -= 1 ; #DEBUG_LINE_NO:487
    If raidHandicap < 0 ; #DEBUG_LINE_NO:488
      raidHandicap = 0 ; #DEBUG_LINE_NO:489
    EndIf
    Self.BanditRaid(-1) ; #DEBUG_LINE_NO:491
    Return  ; #DEBUG_LINE_NO:492
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:494
    Return  ; #DEBUG_LINE_NO:495
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:498
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:499
  EndIf
EndFunction

Function DraugrRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:504
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:505
  EndIf
  ActorBase[] enemies = new ActorBase[4] ; #DEBUG_LINE_NO:507
  enemies[0] = RaiderDraugrMeleeM ; #DEBUG_LINE_NO:508
  enemies[1] = RaiderDraugrMeleeF ; #DEBUG_LINE_NO:509
  enemies[2] = RaiderDraugrRanged ; #DEBUG_LINE_NO:510
  enemies[3] = RaiderDraugrWizard ; #DEBUG_LINE_NO:511
  Int count = 0 ; #DEBUG_LINE_NO:513
  Int min = 0 ; #DEBUG_LINE_NO:514
  Int max = 0 ; #DEBUG_LINE_NO:515
  Int total = 0 ; #DEBUG_LINE_NO:516
  If difficulty == 0 ; #DEBUG_LINE_NO:518
    min = 2 + raidHandicap ; #DEBUG_LINE_NO:519
    max = 6 + raidHandicap ; #DEBUG_LINE_NO:520
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:521
    count = 0 ; #DEBUG_LINE_NO:522
    While count < total ; #DEBUG_LINE_NO:523
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:524
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:525
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:526
        If plan != None ; #DEBUG_LINE_NO:527
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:528
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:531
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:532
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderDraugrBoss, 4, None) ; #DEBUG_LINE_NO:534
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:535
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:536
      If plan != None ; #DEBUG_LINE_NO:537
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:538
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:541
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:543
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:544
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:545
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:546
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:548
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:549
    min = 7 + raidHandicap ; #DEBUG_LINE_NO:550
    max = 13 + raidHandicap ; #DEBUG_LINE_NO:551
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:552
    count = 0 ; #DEBUG_LINE_NO:553
    While count < total ; #DEBUG_LINE_NO:554
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:555
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:556
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:557
        If plan != None ; #DEBUG_LINE_NO:558
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:559
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:562
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:563
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderDraugrBoss, 4, None) ; #DEBUG_LINE_NO:565
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:566
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:567
      If plan != None ; #DEBUG_LINE_NO:568
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:569
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:572
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:574
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:575
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:576
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:577
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:579
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:580
    min = 14 + raidHandicap ; #DEBUG_LINE_NO:581
    max = 20 + raidHandicap ; #DEBUG_LINE_NO:582
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:583
    count = 0 ; #DEBUG_LINE_NO:584
    While count < total ; #DEBUG_LINE_NO:585
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:586
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:587
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:588
        If plan != None ; #DEBUG_LINE_NO:589
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:590
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:593
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:594
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderDraugrBoss, 4, None) ; #DEBUG_LINE_NO:596
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:597
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:598
      If plan != None ; #DEBUG_LINE_NO:599
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:600
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:603
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:605
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:606
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:607
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:608
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:610
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:611
    raidHandicap += 1 ; #DEBUG_LINE_NO:612
    Self.DraugrRaid(-1) ; #DEBUG_LINE_NO:613
    Return  ; #DEBUG_LINE_NO:614
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:615
    raidHandicap -= 1 ; #DEBUG_LINE_NO:616
    If raidHandicap < 0 ; #DEBUG_LINE_NO:617
      raidHandicap = 0 ; #DEBUG_LINE_NO:618
    EndIf
    Self.DraugrRaid(-1) ; #DEBUG_LINE_NO:620
    Return  ; #DEBUG_LINE_NO:621
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:623
    Return  ; #DEBUG_LINE_NO:624
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:627
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:628
  EndIf
EndFunction

Function DragonRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:633
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:634
  EndIf
  Int count = 0 ; #DEBUG_LINE_NO:636
  Int min = 0 ; #DEBUG_LINE_NO:637
  Int max = 0 ; #DEBUG_LINE_NO:638
  Int total = 0 ; #DEBUG_LINE_NO:639
  If difficulty == 0 ; #DEBUG_LINE_NO:641
    min = 1 + raidHandicap ; #DEBUG_LINE_NO:642
    max = 2 + raidHandicap ; #DEBUG_LINE_NO:643
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:644
    count = 0 ; #DEBUG_LINE_NO:645
    While count < total ; #DEBUG_LINE_NO:646
      Self.RandomSpawnPoint().PlaceActorAtMe(RaiderDragon, 4, None) ; #DEBUG_LINE_NO:647
      count += 1 ; #DEBUG_LINE_NO:648
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:649
    EndWhile
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:652
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:653
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:654
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:655
    EndIf
    If count == 1 ; #DEBUG_LINE_NO:657
      EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:658
    Else
      EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:660
    EndIf
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:662
    min = 2 + raidHandicap ; #DEBUG_LINE_NO:663
    max = 3 + raidHandicap ; #DEBUG_LINE_NO:664
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:665
    count = 0 ; #DEBUG_LINE_NO:666
    While count < total ; #DEBUG_LINE_NO:667
      Self.RandomSpawnPoint().PlaceActorAtMe(RaiderDragon, 4, None) ; #DEBUG_LINE_NO:668
      count += 1 ; #DEBUG_LINE_NO:669
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:670
    EndWhile
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:673
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:674
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:675
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:676
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:678
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:679
    min = 3 + raidHandicap ; #DEBUG_LINE_NO:680
    max = 5 + raidHandicap ; #DEBUG_LINE_NO:681
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:682
    count = 0 ; #DEBUG_LINE_NO:683
    While count < total ; #DEBUG_LINE_NO:684
      Self.RandomSpawnPoint().PlaceActorAtMe(RaiderDragon, 4, None) ; #DEBUG_LINE_NO:685
      count += 1 ; #DEBUG_LINE_NO:686
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:687
    EndWhile
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:690
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:691
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:692
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:693
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:695
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:696
    raidHandicap += 1 ; #DEBUG_LINE_NO:697
    Self.DragonRaid(-1) ; #DEBUG_LINE_NO:698
    Return  ; #DEBUG_LINE_NO:699
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:700
    raidHandicap -= 1 ; #DEBUG_LINE_NO:701
    If raidHandicap < 0 ; #DEBUG_LINE_NO:702
      raidHandicap = 0 ; #DEBUG_LINE_NO:703
    EndIf
    Self.DragonRaid(-1) ; #DEBUG_LINE_NO:705
    Return  ; #DEBUG_LINE_NO:706
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:708
    Return  ; #DEBUG_LINE_NO:709
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:712
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:713
  EndIf
EndFunction

Function NatureRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:718
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:719
  EndIf
  ActorBase[] enemies = new ActorBase[10] ; #DEBUG_LINE_NO:721
  enemies[0] = RaiderNatureSkeever ; #DEBUG_LINE_NO:722
  enemies[1] = RaiderNatureBear ; #DEBUG_LINE_NO:723
  enemies[2] = RaiderNatureChaurus ; #DEBUG_LINE_NO:724
  enemies[3] = RaiderNatureChaurusReaper ; #DEBUG_LINE_NO:725
  enemies[4] = RaiderNatureIceWraith ; #DEBUG_LINE_NO:726
  enemies[5] = RaiderNatureSabre ; #DEBUG_LINE_NO:727
  enemies[6] = RaiderNatureSkeever ; #DEBUG_LINE_NO:728
  enemies[7] = RaiderNatureSpider ; #DEBUG_LINE_NO:729
  enemies[8] = RaiderNatureTroll ; #DEBUG_LINE_NO:730
  enemies[9] = RaiderNatureWolf ; #DEBUG_LINE_NO:731
  Int count = 0 ; #DEBUG_LINE_NO:733
  Int min = 0 ; #DEBUG_LINE_NO:734
  Int max = 0 ; #DEBUG_LINE_NO:735
  Int total = 0 ; #DEBUG_LINE_NO:736
  If difficulty == 0 ; #DEBUG_LINE_NO:738
    min = 2 + raidHandicap ; #DEBUG_LINE_NO:739
    max = 5 + raidHandicap ; #DEBUG_LINE_NO:740
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:741
    count = 0 ; #DEBUG_LINE_NO:742
    While count < total ; #DEBUG_LINE_NO:743
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:744
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:745
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:746
        If plan != None ; #DEBUG_LINE_NO:747
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:748
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:751
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:752
    EndWhile
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:755
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:756
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:757
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:758
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:760
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:761
    min = 6 + raidHandicap ; #DEBUG_LINE_NO:762
    max = 9 + raidHandicap ; #DEBUG_LINE_NO:763
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:764
    count = 0 ; #DEBUG_LINE_NO:765
    While count < total ; #DEBUG_LINE_NO:766
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:767
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:768
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:769
        If plan != None ; #DEBUG_LINE_NO:770
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:771
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:774
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:775
    EndWhile
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:778
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:779
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:780
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:781
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:783
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:784
    min = 10 + raidHandicap ; #DEBUG_LINE_NO:785
    max = 15 + raidHandicap ; #DEBUG_LINE_NO:786
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:787
    count = 0 ; #DEBUG_LINE_NO:788
    While count < total ; #DEBUG_LINE_NO:789
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:790
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:791
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:792
        If plan != None ; #DEBUG_LINE_NO:793
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:794
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:797
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:798
    EndWhile
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:801
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:802
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:803
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:804
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:806
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:807
    raidHandicap += 1 ; #DEBUG_LINE_NO:808
    Self.NatureRaid(-1) ; #DEBUG_LINE_NO:809
    Return  ; #DEBUG_LINE_NO:810
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:811
    raidHandicap -= 1 ; #DEBUG_LINE_NO:812
    If raidHandicap < 0 ; #DEBUG_LINE_NO:813
      raidHandicap = 0 ; #DEBUG_LINE_NO:814
    EndIf
    Self.NatureRaid(-1) ; #DEBUG_LINE_NO:816
    Return  ; #DEBUG_LINE_NO:817
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:819
    Return  ; #DEBUG_LINE_NO:820
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:823
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:824
  EndIf
EndFunction

Function GiantRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:829
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:830
  EndIf
  ActorBase[] enemies = new ActorBase[3] ; #DEBUG_LINE_NO:832
  enemies[0] = RaiderGiantA ; #DEBUG_LINE_NO:833
  enemies[1] = RaiderGiantB ; #DEBUG_LINE_NO:834
  enemies[2] = RaiderMammoth ; #DEBUG_LINE_NO:835
  Int count = 0 ; #DEBUG_LINE_NO:837
  Int min = 0 ; #DEBUG_LINE_NO:838
  Int max = 0 ; #DEBUG_LINE_NO:839
  Int total = 0 ; #DEBUG_LINE_NO:840
  If difficulty == 0 ; #DEBUG_LINE_NO:842
    min = 1 + raidHandicap ; #DEBUG_LINE_NO:843
    max = 2 + raidHandicap ; #DEBUG_LINE_NO:844
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:845
    count = 0 ; #DEBUG_LINE_NO:846
    While count < total ; #DEBUG_LINE_NO:847
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:848
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:849
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:850
        If plan != None ; #DEBUG_LINE_NO:851
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:852
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:855
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:856
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderGiantLeader, 4, None) ; #DEBUG_LINE_NO:858
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:859
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:860
      If plan != None ; #DEBUG_LINE_NO:861
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:862
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:865
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:867
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:868
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:869
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:870
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:872
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:873
    min = 3 + raidHandicap ; #DEBUG_LINE_NO:874
    max = 5 + raidHandicap ; #DEBUG_LINE_NO:875
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:876
    count = 0 ; #DEBUG_LINE_NO:877
    While count < total ; #DEBUG_LINE_NO:878
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:879
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:880
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:881
        If plan != None ; #DEBUG_LINE_NO:882
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:883
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:886
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:887
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderGiantLeader, 4, None) ; #DEBUG_LINE_NO:889
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:890
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:891
      If plan != None ; #DEBUG_LINE_NO:892
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:893
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:896
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:898
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:899
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:900
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:901
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:903
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:904
    min = 6 + raidHandicap ; #DEBUG_LINE_NO:905
    max = 9 + raidHandicap ; #DEBUG_LINE_NO:906
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:907
    count = 0 ; #DEBUG_LINE_NO:908
    While count < total ; #DEBUG_LINE_NO:909
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:910
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:911
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:912
        If plan != None ; #DEBUG_LINE_NO:913
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:914
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:917
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:918
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderGiantLeader, 4, None) ; #DEBUG_LINE_NO:920
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:921
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:922
      If plan != None ; #DEBUG_LINE_NO:923
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:924
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:927
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:929
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:930
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:931
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:932
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:934
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:935
    raidHandicap += 1 ; #DEBUG_LINE_NO:936
    Self.GiantRaid(-1) ; #DEBUG_LINE_NO:937
    Return  ; #DEBUG_LINE_NO:938
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:939
    raidHandicap -= 1 ; #DEBUG_LINE_NO:940
    If raidHandicap < 0 ; #DEBUG_LINE_NO:941
      raidHandicap = 0 ; #DEBUG_LINE_NO:942
    EndIf
    Self.GiantRaid(-1) ; #DEBUG_LINE_NO:944
    Return  ; #DEBUG_LINE_NO:945
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:947
    Return  ; #DEBUG_LINE_NO:948
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:951
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:952
  EndIf
EndFunction

Function NecroRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:957
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:958
  EndIf
  Int count = 0 ; #DEBUG_LINE_NO:961
  Int min = 0 ; #DEBUG_LINE_NO:962
  Int max = 0 ; #DEBUG_LINE_NO:963
  Int total = 0 ; #DEBUG_LINE_NO:964
  If difficulty == 0 ; #DEBUG_LINE_NO:966
    min = 2 + raidHandicap ; #DEBUG_LINE_NO:967
    max = 6 + raidHandicap ; #DEBUG_LINE_NO:968
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:969
    count = 0 ; #DEBUG_LINE_NO:970
    While count < total ; #DEBUG_LINE_NO:971
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderNecromancer, 4, None) ; #DEBUG_LINE_NO:972
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:973
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:974
        If plan != None ; #DEBUG_LINE_NO:975
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:976
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:979
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:980
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderNecromancerBoss, 4, None) ; #DEBUG_LINE_NO:982
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:983
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:984
      If plan != None ; #DEBUG_LINE_NO:985
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:986
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:989
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:991
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:992
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:993
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:994
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:996
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:997
    min = 7 + raidHandicap ; #DEBUG_LINE_NO:998
    max = 13 + raidHandicap ; #DEBUG_LINE_NO:999
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1000
    count = 0 ; #DEBUG_LINE_NO:1001
    While count < total ; #DEBUG_LINE_NO:1002
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderNecromancer, 4, None) ; #DEBUG_LINE_NO:1003
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1004
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1005
        If plan != None ; #DEBUG_LINE_NO:1006
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1007
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1010
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1011
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderNecromancerBoss, 4, None) ; #DEBUG_LINE_NO:1013
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1014
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1015
      If plan != None ; #DEBUG_LINE_NO:1016
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1017
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1020
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1022
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1023
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1024
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1025
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1027
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:1028
    min = 14 + raidHandicap ; #DEBUG_LINE_NO:1029
    max = 20 + raidHandicap ; #DEBUG_LINE_NO:1030
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1031
    count = 0 ; #DEBUG_LINE_NO:1032
    While count < total ; #DEBUG_LINE_NO:1033
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderNecromancer, 4, None) ; #DEBUG_LINE_NO:1034
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1035
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1036
        If plan != None ; #DEBUG_LINE_NO:1037
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1038
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1041
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1042
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderNecromancerBoss, 4, None) ; #DEBUG_LINE_NO:1044
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1045
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1046
      If plan != None ; #DEBUG_LINE_NO:1047
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1048
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1051
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1053
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1054
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1055
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1056
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1058
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:1059
    raidHandicap += 1 ; #DEBUG_LINE_NO:1060
    Self.NecroRaid(-1) ; #DEBUG_LINE_NO:1061
    Return  ; #DEBUG_LINE_NO:1062
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:1063
    raidHandicap -= 1 ; #DEBUG_LINE_NO:1064
    If raidHandicap < 0 ; #DEBUG_LINE_NO:1065
      raidHandicap = 0 ; #DEBUG_LINE_NO:1066
    EndIf
    Self.NecroRaid(-1) ; #DEBUG_LINE_NO:1068
    Return  ; #DEBUG_LINE_NO:1069
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1071
    Return  ; #DEBUG_LINE_NO:1072
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:1075
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:1076
  EndIf
EndFunction

Function VampireRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:1081
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1082
  EndIf
  Int count = 0 ; #DEBUG_LINE_NO:1085
  Int min = 0 ; #DEBUG_LINE_NO:1086
  Int max = 0 ; #DEBUG_LINE_NO:1087
  Int total = 0 ; #DEBUG_LINE_NO:1088
  If difficulty == 0 ; #DEBUG_LINE_NO:1090
    min = 2 + raidHandicap ; #DEBUG_LINE_NO:1091
    max = 6 + raidHandicap ; #DEBUG_LINE_NO:1092
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1093
    count = 0 ; #DEBUG_LINE_NO:1094
    While count < total ; #DEBUG_LINE_NO:1095
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderVampire, 4, None) ; #DEBUG_LINE_NO:1096
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1097
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1098
        If plan != None ; #DEBUG_LINE_NO:1099
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1100
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1103
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1104
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderVampireBoss, 4, None) ; #DEBUG_LINE_NO:1106
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1107
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1108
      If plan != None ; #DEBUG_LINE_NO:1109
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1110
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1113
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1115
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1116
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1117
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1118
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1120
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:1121
    min = 7 + raidHandicap ; #DEBUG_LINE_NO:1122
    max = 13 + raidHandicap ; #DEBUG_LINE_NO:1123
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1124
    count = 0 ; #DEBUG_LINE_NO:1125
    While count < total ; #DEBUG_LINE_NO:1126
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderVampire, 4, None) ; #DEBUG_LINE_NO:1127
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1128
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1129
        If plan != None ; #DEBUG_LINE_NO:1130
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1131
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1134
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1135
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderVampireBoss, 4, None) ; #DEBUG_LINE_NO:1137
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1138
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1139
      If plan != None ; #DEBUG_LINE_NO:1140
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1141
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1144
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1146
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1147
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1148
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1149
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1151
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:1152
    min = 14 + raidHandicap ; #DEBUG_LINE_NO:1153
    max = 20 + raidHandicap ; #DEBUG_LINE_NO:1154
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1155
    count = 0 ; #DEBUG_LINE_NO:1156
    While count < total ; #DEBUG_LINE_NO:1157
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderVampire, 4, None) ; #DEBUG_LINE_NO:1158
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1159
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1160
        If plan != None ; #DEBUG_LINE_NO:1161
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1162
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1165
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1166
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderVampireBoss, 4, None) ; #DEBUG_LINE_NO:1168
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1169
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1170
      If plan != None ; #DEBUG_LINE_NO:1171
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1172
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1175
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1177
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1178
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1179
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1180
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1182
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:1183
    raidHandicap += 1 ; #DEBUG_LINE_NO:1184
    Self.VampireRaid(-1) ; #DEBUG_LINE_NO:1185
    Return  ; #DEBUG_LINE_NO:1186
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:1187
    raidHandicap -= 1 ; #DEBUG_LINE_NO:1188
    If raidHandicap < 0 ; #DEBUG_LINE_NO:1189
      raidHandicap = 0 ; #DEBUG_LINE_NO:1190
    EndIf
    Self.VampireRaid(-1) ; #DEBUG_LINE_NO:1192
    Return  ; #DEBUG_LINE_NO:1193
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1195
    Return  ; #DEBUG_LINE_NO:1196
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:1199
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:1200
  EndIf
EndFunction

Function WerewolfRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:1205
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1206
  EndIf
  Int count = 0 ; #DEBUG_LINE_NO:1209
  Int min = 0 ; #DEBUG_LINE_NO:1210
  Int max = 0 ; #DEBUG_LINE_NO:1211
  Int total = 0 ; #DEBUG_LINE_NO:1212
  If difficulty == 0 ; #DEBUG_LINE_NO:1214
    min = 1 + raidHandicap ; #DEBUG_LINE_NO:1215
    max = 3 + raidHandicap ; #DEBUG_LINE_NO:1216
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1217
    count = 0 ; #DEBUG_LINE_NO:1218
    While count < total ; #DEBUG_LINE_NO:1219
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderWerewolf, 4, None) ; #DEBUG_LINE_NO:1220
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1221
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1222
        If plan != None ; #DEBUG_LINE_NO:1223
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1224
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1227
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1228
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderWerewolfBoss, 4, None) ; #DEBUG_LINE_NO:1230
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1231
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1232
      If plan != None ; #DEBUG_LINE_NO:1233
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1234
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1237
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1239
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1240
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1241
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1242
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1244
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:1245
    min = 4 + raidHandicap ; #DEBUG_LINE_NO:1246
    max = 8 + raidHandicap ; #DEBUG_LINE_NO:1247
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1248
    count = 0 ; #DEBUG_LINE_NO:1249
    While count < total ; #DEBUG_LINE_NO:1250
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderWerewolf, 4, None) ; #DEBUG_LINE_NO:1251
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1252
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1253
        If plan != None ; #DEBUG_LINE_NO:1254
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1255
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1258
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1259
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderWerewolfBoss, 4, None) ; #DEBUG_LINE_NO:1261
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1262
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1263
      If plan != None ; #DEBUG_LINE_NO:1264
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1265
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1268
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1270
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1271
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1272
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1273
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1275
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:1276
    min = 9 + raidHandicap ; #DEBUG_LINE_NO:1277
    max = 15 + raidHandicap ; #DEBUG_LINE_NO:1278
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1279
    count = 0 ; #DEBUG_LINE_NO:1280
    While count < total ; #DEBUG_LINE_NO:1281
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderWerewolf, 4, None) ; #DEBUG_LINE_NO:1282
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1283
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1284
        If plan != None ; #DEBUG_LINE_NO:1285
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1286
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1289
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1290
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderWerewolfBoss, 4, None) ; #DEBUG_LINE_NO:1292
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1293
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1294
      If plan != None ; #DEBUG_LINE_NO:1295
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1296
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1299
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1301
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1302
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1303
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1304
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1306
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:1307
    raidHandicap += 1 ; #DEBUG_LINE_NO:1308
    Self.WerewolfRaid(-1) ; #DEBUG_LINE_NO:1309
    Return  ; #DEBUG_LINE_NO:1310
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:1311
    raidHandicap -= 1 ; #DEBUG_LINE_NO:1312
    If raidHandicap < 0 ; #DEBUG_LINE_NO:1313
      raidHandicap = 0 ; #DEBUG_LINE_NO:1314
    EndIf
    Self.WerewolfRaid(-1) ; #DEBUG_LINE_NO:1316
    Return  ; #DEBUG_LINE_NO:1317
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1319
    Return  ; #DEBUG_LINE_NO:1320
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:1323
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:1324
  EndIf
EndFunction

Function FalmerRaid(Int difficulty)
  If difficulty == -1 ; #DEBUG_LINE_NO:1329
    difficulty = RaidDifficultyMenu.Show(raidHandicap as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1330
  EndIf
  ActorBase[] enemies = new ActorBase[3] ; #DEBUG_LINE_NO:1332
  enemies[0] = RaiderFalmerMelee ; #DEBUG_LINE_NO:1333
  enemies[1] = RaiderFalmerRanged ; #DEBUG_LINE_NO:1334
  enemies[2] = RaiderFalmerShaman ; #DEBUG_LINE_NO:1335
  Int count = 0 ; #DEBUG_LINE_NO:1337
  Int min = 0 ; #DEBUG_LINE_NO:1338
  Int max = 0 ; #DEBUG_LINE_NO:1339
  Int total = 0 ; #DEBUG_LINE_NO:1340
  If difficulty == 0 ; #DEBUG_LINE_NO:1342
    min = 2 + raidHandicap ; #DEBUG_LINE_NO:1343
    max = 6 + raidHandicap ; #DEBUG_LINE_NO:1344
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1345
    count = 0 ; #DEBUG_LINE_NO:1346
    While count < total ; #DEBUG_LINE_NO:1347
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:1348
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1349
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1350
        If plan != None ; #DEBUG_LINE_NO:1351
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1352
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1355
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1356
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderFalmerBoss, 4, None) ; #DEBUG_LINE_NO:1358
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1359
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1360
      If plan != None ; #DEBUG_LINE_NO:1361
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1362
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1365
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1367
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1368
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1369
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1370
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1372
  ElseIf difficulty == 1 ; #DEBUG_LINE_NO:1373
    min = 7 + raidHandicap ; #DEBUG_LINE_NO:1374
    max = 13 + raidHandicap ; #DEBUG_LINE_NO:1375
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1376
    count = 0 ; #DEBUG_LINE_NO:1377
    While count < total ; #DEBUG_LINE_NO:1378
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:1379
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1380
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1381
        If plan != None ; #DEBUG_LINE_NO:1382
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1383
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1386
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1387
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderFalmerBoss, 4, None) ; #DEBUG_LINE_NO:1389
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1390
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1391
      If plan != None ; #DEBUG_LINE_NO:1392
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1393
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1396
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1398
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1399
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1400
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1401
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1403
  ElseIf difficulty == 2 ; #DEBUG_LINE_NO:1404
    min = 14 + raidHandicap ; #DEBUG_LINE_NO:1405
    max = 20 + raidHandicap ; #DEBUG_LINE_NO:1406
    total = Utility.RandomInt(min, max) ; #DEBUG_LINE_NO:1407
    count = 0 ; #DEBUG_LINE_NO:1408
    While count < total ; #DEBUG_LINE_NO:1409
      Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(Self.RandomActor(enemies), 4, None) ; #DEBUG_LINE_NO:1410
      If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1411
        Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1412
        If plan != None ; #DEBUG_LINE_NO:1413
          ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1414
        EndIf
      EndIf
      count += 1 ; #DEBUG_LINE_NO:1417
      CurrentRaiders += 1 ; #DEBUG_LINE_NO:1418
    EndWhile
    Actor ref = Self.RandomSpawnPoint().PlaceActorAtMe(RaiderFalmerBoss, 4, None) ; #DEBUG_LINE_NO:1420
    If Utility.RandomInt(1, 2) == 1 ; #DEBUG_LINE_NO:1421
      Potion plan = Self.RandomPlan() ; #DEBUG_LINE_NO:1422
      If plan != None ; #DEBUG_LINE_NO:1423
        ref.AddItem(plan as Form, 1, False) ; #DEBUG_LINE_NO:1424
      EndIf
    EndIf
    CurrentRaiders += 1 ; #DEBUG_LINE_NO:1427
    Self.BeginRaid()
    If PlayerRaids ; #DEBUG_LINE_NO:1429
      Game.GetPlayer().RemoveFromFaction(FortFaction) ; #DEBUG_LINE_NO:1430
      Game.GetPlayer().AddToFaction(RaiderFaction) ; #DEBUG_LINE_NO:1431
      Game.GetPlayer().MoveTo(Self.RandomSpawnPoint(), 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:1432
    EndIf
    EnemiesSightedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1434
  ElseIf difficulty == 3 ; #DEBUG_LINE_NO:1435
    raidHandicap += 1 ; #DEBUG_LINE_NO:1436
    Self.FalmerRaid(-1) ; #DEBUG_LINE_NO:1437
    Return  ; #DEBUG_LINE_NO:1438
  ElseIf difficulty == 4 ; #DEBUG_LINE_NO:1439
    raidHandicap -= 1 ; #DEBUG_LINE_NO:1440
    If raidHandicap < 0 ; #DEBUG_LINE_NO:1441
      raidHandicap = 0 ; #DEBUG_LINE_NO:1442
    EndIf
    Self.FalmerRaid(-1) ; #DEBUG_LINE_NO:1444
    Return  ; #DEBUG_LINE_NO:1445
  Else
    RaidMenu.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:1447
    Return  ; #DEBUG_LINE_NO:1448
  EndIf
  If Game.GetPlayer().GetParentCell() == (MainQuest as aaafortmainquestscript).marker.GetParentCell() ; #DEBUG_LINE_NO:1451
    RaidSound.Play(Game.GetPlayer() as ObjectReference) ; #DEBUG_LINE_NO:1452
  EndIf
EndFunction
