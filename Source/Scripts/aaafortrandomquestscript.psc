;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortRandomQuestScript.psc
Modified : 2017-12-31 06:47:05
Compiled : 2017-12-31 06:47:06
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortRandomQuestScript Extends Quest conditional

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property DailyTaxDialog Auto
ObjectReference Property DogmeatRef Auto
Potion Property LookoutTower Auto
aaafortmainquestscript Property MainQuest Auto
ActorBase Property MerchantA Auto
ObjectReference Property MerchantContainer Auto
Weapon Property ObjectCloner Auto
Quest Property ObjectCloning Auto
Quest Property ObjectCloningReset Auto
Quest Property PlayerQuest Auto
Bool Property RandomRaidEnabled = False Auto
Potion Property SpikeBarrier Auto
Potion Property StoneShelter Auto
Message Property TraderSoldDialog Auto
Quest Property Tutorial Auto
Potion Property WatchPost Auto
Message Property WaterWellMessageDialog Auto
Bool Property alchemyNote = False Auto
Bool Property forgeNote = False Auto
Bool Property generalStore = False Auto
Bool Property hasCaptain = False Auto
Bool Property hasDogmeat = False Auto
Bool Property innNote = False Auto
Bool Property mine = False Auto
Int Property raidChance = 100 Auto
Int Property randomFrequency = 90 Auto
Bool Property readAlchemyNote = False Auto
Bool Property readCaptain = False Auto conditional
Bool Property readForgeNote = False Auto
Bool Property readGeneralStore = False Auto
Bool Property readInn = False Auto conditional
Bool Property readMine = False Auto
Bool Property readScavengerNote = False Auto
Bool Property scavengerNote = False Auto
Bool Property violetGivePlans = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  Self.RegisterForSingleUpdate(randomFrequency as Float) ; #DEBUG_LINE_NO:40
EndEvent

Event OnUpdate()
  Self.ProcessDay() ; #DEBUG_LINE_NO:44
  If RandomRaidEnabled && !(PlayerQuest as aaafortplayerquestscript).isRaid ; #DEBUG_LINE_NO:46
    Int randomchance = Utility.RandomInt(1, raidChance) ; #DEBUG_LINE_NO:47
    If randomchance > 95 && MainQuest.stage == 0 ; #DEBUG_LINE_NO:48
      (PlayerQuest as aaafortplayerquestscript).RandomRaid() ; #DEBUG_LINE_NO:49
    EndIf
  EndIf
  If Tutorial.IsCompleted() && !(PlayerQuest as aaafortplayerquestscript).isRaid ; #DEBUG_LINE_NO:53
    Int random = Utility.RandomInt(1, 100) ; #DEBUG_LINE_NO:54
    If random >= 99 ; #DEBUG_LINE_NO:55
      (PlayerQuest as aaafortplayerquestscript).RandomSpawnPoint().PlaceActorAtMe(MerchantA, 4, None) ; #DEBUG_LINE_NO:56
    EndIf
  EndIf
  If Tutorial.IsCompleted() && !(PlayerQuest as aaafortplayerquestscript).isRaid ; #DEBUG_LINE_NO:60
    Int random = Utility.RandomInt(1, 100) ; #DEBUG_LINE_NO:61
    If !scavengerNote && random < 50 ; #DEBUG_LINE_NO:62
      WaterWellMessageDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:63
      scavengerNote = True ; #DEBUG_LINE_NO:64
    ElseIf !forgeNote && random > 95 ; #DEBUG_LINE_NO:65
      WaterWellMessageDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:66
      forgeNote = True ; #DEBUG_LINE_NO:67
    ElseIf !alchemyNote && random < 4 ; #DEBUG_LINE_NO:68
      WaterWellMessageDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:69
      alchemyNote = True ; #DEBUG_LINE_NO:70
    ElseIf !hasDogmeat && random > 30 && random < 33 ; #DEBUG_LINE_NO:71
      DogmeatRef.MoveTo(MainQuest.marker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:72
      DogmeatRef.Enable(False) ; #DEBUG_LINE_NO:73
      hasDogmeat = True ; #DEBUG_LINE_NO:74
    ElseIf !generalStore && random > 50 && random < 55 ; #DEBUG_LINE_NO:75
      WaterWellMessageDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:76
      generalStore = True ; #DEBUG_LINE_NO:77
    ElseIf !mine && random > 70 && random < 74 ; #DEBUG_LINE_NO:78
      WaterWellMessageDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:79
      mine = True ; #DEBUG_LINE_NO:80
    ElseIf !hasCaptain && random > 81 && random < 85 ; #DEBUG_LINE_NO:81
      WaterWellMessageDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:82
      hasCaptain = True ; #DEBUG_LINE_NO:83
    ElseIf !innNote && random > 91 && random < 94 ; #DEBUG_LINE_NO:84
      WaterWellMessageDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:85
      innNote = True ; #DEBUG_LINE_NO:86
    EndIf
  EndIf
  Self.RegisterForSingleUpdate(randomFrequency as Float) ; #DEBUG_LINE_NO:89
EndEvent

Function ProcessDay()
  If Utility.GetCurrentGameTime() as Int != MainQuest.CurrentDay ; #DEBUG_LINE_NO:93
    MainQuest.CurrentDay = Utility.GetCurrentGameTime() as Int ; #DEBUG_LINE_NO:94
    MainQuest.DayCount = MainQuest.DayCount + 1 ; #DEBUG_LINE_NO:95
    If MainQuest.CitizenCount > 0 ; #DEBUG_LINE_NO:96
      Int tax = MainQuest.CitizenCount * 50 ; #DEBUG_LINE_NO:97
      tax += MainQuest.MinerCount * 10 ; #DEBUG_LINE_NO:98
      Game.GetPlayer().AddItem(MainQuest.Gold as Form, tax, False) ; #DEBUG_LINE_NO:99
      DailyTaxDialog.Show(tax as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:100
      If MainQuest.MinerCount > 0 ; #DEBUG_LINE_NO:102
        Int random = Utility.RandomInt(1, 2) ; #DEBUG_LINE_NO:103
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:104
          MainQuest.MinerContainer.AddItem(MainQuest.OreIron as Form, Utility.RandomInt(1, 3), False) ; #DEBUG_LINE_NO:105
        EndIf
        random = Utility.RandomInt(1, 5) ; #DEBUG_LINE_NO:107
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:108
          MainQuest.MinerContainer.AddItem(MainQuest.OreCorundum as Form, Utility.RandomInt(1, 3), False) ; #DEBUG_LINE_NO:109
        EndIf
        random = Utility.RandomInt(1, 10) ; #DEBUG_LINE_NO:111
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:112
          MainQuest.MinerContainer.AddItem(MainQuest.OreSilver as Form, Utility.RandomInt(1, 3), False) ; #DEBUG_LINE_NO:113
        EndIf
        random = Utility.RandomInt(1, 11) ; #DEBUG_LINE_NO:115
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:116
          MainQuest.MinerContainer.AddItem(MainQuest.OreMalachite as Form, Utility.RandomInt(1, 3), False) ; #DEBUG_LINE_NO:117
        EndIf
        random = Utility.RandomInt(1, 12) ; #DEBUG_LINE_NO:119
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:120
          MainQuest.MinerContainer.AddItem(MainQuest.OreOrichalcum as Form, Utility.RandomInt(1, 2), False) ; #DEBUG_LINE_NO:121
        EndIf
        random = Utility.RandomInt(1, 13) ; #DEBUG_LINE_NO:123
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:124
          MainQuest.MinerContainer.AddItem(MainQuest.OreGold as Form, Utility.RandomInt(1, 2), False) ; #DEBUG_LINE_NO:125
        EndIf
        random = Utility.RandomInt(1, 14) ; #DEBUG_LINE_NO:127
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:128
          MainQuest.MinerContainer.AddItem(MainQuest.OreMoonstone as Form, Utility.RandomInt(1, 2), False) ; #DEBUG_LINE_NO:129
        EndIf
        random = Utility.RandomInt(1, 15) ; #DEBUG_LINE_NO:131
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:132
          MainQuest.MinerContainer.AddItem(MainQuest.OreEbony as Form, Utility.RandomInt(1, 2), False) ; #DEBUG_LINE_NO:133
        EndIf
        random = Utility.RandomInt(1, 16) ; #DEBUG_LINE_NO:135
        If random <= MainQuest.MinerCount ; #DEBUG_LINE_NO:136
          MainQuest.MinerContainer.AddItem(MainQuest.OreQuicksilver as Form, 1, False) ; #DEBUG_LINE_NO:137
        EndIf
      EndIf
    EndIf
    If Utility.RandomInt(1, 3) == 1 ; #DEBUG_LINE_NO:142
      If MainQuest.TraderPendingSale > 0 ; #DEBUG_LINE_NO:143
        Int cut = Math.Ceiling(MainQuest.TraderPendingSale as Float / 2.5) ; #DEBUG_LINE_NO:144
        Game.GetPlayer().AddItem(MainQuest.Gold as Form, MainQuest.TraderPendingSale, False) ; #DEBUG_LINE_NO:145
        TraderSoldDialog.Show(cut as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:146
      EndIf
      MainQuest.TraderPendingBox.RemoveAllItems(None, False, False) ; #DEBUG_LINE_NO:149
      MainQuest.TraderPendingSale = 0 ; #DEBUG_LINE_NO:150
    EndIf
  EndIf
EndFunction
