;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortBarracksScript.psc
Modified : 2017-12-31 06:03:18
Compiled : 2017-12-31 06:03:20
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortBarracksScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Message Property AlreadyBought Auto
Potion Property ArcaneTower Auto
Int Property ArcaneTowerCost = 3000 Auto
Int Property ArmoryCost = 1500 Auto
Message Property BarracksDialog Auto
Potion Property DragonPerch Auto
Potion Property EquipmentBox Auto
Int Property EquipmentBoxCost = 5000 Auto
MiscObject Property Gold Auto
ActorBase Property IntPatrolGuard Auto
Int Property IntPatrolGuardCost = 500 Auto
Quest Property MainQuest Auto
Potion Property MedicTent Auto
Int Property MedicTentCost = 2000 Auto
Message Property NotEnoughGold Auto
ActorBase Property PatrolGuard Auto
Int Property PatrolGuardCost = 500 Auto
Potion Property PatrolMarkerA Auto
Potion Property PatrolMarkerB Auto
Potion Property PatrolMarkerC Auto
Potion Property PatrolMarkerD Auto
Potion Property PatrolMarkerE Auto
Potion Property PatrolMarkerF Auto
Potion Property PatrolMarkerG Auto
Potion Property PatrolMarkerH Auto
Int Property PerchCost = 5000 Auto
ObjectReference Property SpawnPoint Auto
Potion Property StationaryGuard Auto
Int Property StationaryGuardCost = 500 Auto
Message Property UpgradesDialog Auto
Message Property UpgradesDialogB Auto
Bool Property hasArcane = False Auto
Bool Property hasArmory = False Auto
Bool Property hasEquipmentBox = False Auto
Bool Property hasIntPatrol = False Auto
Bool Property hasMedic = False Auto
Bool Property hasPerch = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivatingObject)
  Self.BarracksMenu() ; #DEBUG_LINE_NO:46
EndEvent

Function BarracksMenu()
  Int result = BarracksDialog.Show(PatrolGuardCost as Float, StationaryGuardCost as Float, IntPatrolGuardCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:50
  If result == 0 ; #DEBUG_LINE_NO:51
    If Game.GetPlayer().GetItemCount(Gold as Form) >= PatrolGuardCost ; #DEBUG_LINE_NO:53
      Game.GetPlayer().RemoveItem(Gold as Form, PatrolGuardCost, False, None) ; #DEBUG_LINE_NO:54
      SpawnPoint.PlaceAtMe(PatrolGuard as Form, 1, False, False) ; #DEBUG_LINE_NO:55
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:56
      Self.BarracksMenu() ; #DEBUG_LINE_NO:57
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:59
    EndIf
  ElseIf result == 1 ; #DEBUG_LINE_NO:61
    If Game.GetPlayer().GetItemCount(Gold as Form) >= StationaryGuardCost ; #DEBUG_LINE_NO:63
      Game.GetPlayer().RemoveItem(Gold as Form, StationaryGuardCost, False, None) ; #DEBUG_LINE_NO:64
      Game.GetPlayer().AddItem(StationaryGuard as Form, 1, False) ; #DEBUG_LINE_NO:65
      Self.BarracksMenu() ; #DEBUG_LINE_NO:66
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:68
    EndIf
  ElseIf result == 2 ; #DEBUG_LINE_NO:70
    If !hasIntPatrol ; #DEBUG_LINE_NO:71
      Game.GetPlayer().AddItem(PatrolMarkerA as Form, 1, False) ; #DEBUG_LINE_NO:72
      Game.GetPlayer().AddItem(PatrolMarkerB as Form, 1, False) ; #DEBUG_LINE_NO:73
      Game.GetPlayer().AddItem(PatrolMarkerC as Form, 1, False) ; #DEBUG_LINE_NO:74
      Game.GetPlayer().AddItem(PatrolMarkerD as Form, 1, False) ; #DEBUG_LINE_NO:75
      Game.GetPlayer().AddItem(PatrolMarkerE as Form, 1, False) ; #DEBUG_LINE_NO:76
      Game.GetPlayer().AddItem(PatrolMarkerF as Form, 1, False) ; #DEBUG_LINE_NO:77
      Game.GetPlayer().AddItem(PatrolMarkerG as Form, 1, False) ; #DEBUG_LINE_NO:78
      Game.GetPlayer().AddItem(PatrolMarkerH as Form, 1, False) ; #DEBUG_LINE_NO:79
      hasIntPatrol = True ; #DEBUG_LINE_NO:80
    EndIf
    If Game.GetPlayer().GetItemCount(Gold as Form) >= IntPatrolGuardCost ; #DEBUG_LINE_NO:83
      Game.GetPlayer().RemoveItem(Gold as Form, IntPatrolGuardCost, False, None) ; #DEBUG_LINE_NO:84
      SpawnPoint.PlaceAtMe(IntPatrolGuard as Form, 1, False, False) ; #DEBUG_LINE_NO:85
      (MainQuest as aaafortmainquestscript).GuardCount = (MainQuest as aaafortmainquestscript).GuardCount + 1 ; #DEBUG_LINE_NO:86
      Self.BarracksMenu() ; #DEBUG_LINE_NO:87
    Else
      NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:89
    EndIf
  ElseIf result == 3 ; #DEBUG_LINE_NO:91
    Self.ShowUpgrades() ; #DEBUG_LINE_NO:92
  EndIf
EndFunction

Function ShowUpgrades()
  Int result = UpgradesDialog.Show(ArmoryCost as Float, MedicTentCost as Float, ArcaneTowerCost as Float, PerchCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:97
  If result == 0 ; #DEBUG_LINE_NO:98
    If !hasArmory ; #DEBUG_LINE_NO:99
      If Game.GetPlayer().GetItemCount(Gold as Form) >= ArmoryCost ; #DEBUG_LINE_NO:100
        Game.GetPlayer().RemoveItem(Gold as Form, ArmoryCost, False, None) ; #DEBUG_LINE_NO:101
        hasArmory = True ; #DEBUG_LINE_NO:102
        (MainQuest as aaafortmainquestscript).hasArmory = True ; #DEBUG_LINE_NO:103
        Self.BarracksMenu() ; #DEBUG_LINE_NO:104
      Else
        NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:106
      EndIf
    Else
      AlreadyBought.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:109
      hasArmory = True ; #DEBUG_LINE_NO:110
      (MainQuest as aaafortmainquestscript).hasArmory = True ; #DEBUG_LINE_NO:111
    EndIf
  ElseIf result == 1 ; #DEBUG_LINE_NO:113
    If !hasMedic ; #DEBUG_LINE_NO:114
      If Game.GetPlayer().GetItemCount(Gold as Form) >= MedicTentCost ; #DEBUG_LINE_NO:115
        Game.GetPlayer().RemoveItem(Gold as Form, MedicTentCost, False, None) ; #DEBUG_LINE_NO:116
        hasMedic = True ; #DEBUG_LINE_NO:117
        (MainQuest as aaafortmainquestscript).hasMedic = True ; #DEBUG_LINE_NO:118
        Game.GetPlayer().AddItem(MedicTent as Form, 1, False) ; #DEBUG_LINE_NO:119
        Self.BarracksMenu() ; #DEBUG_LINE_NO:120
      Else
        NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:122
      EndIf
    Else
      AlreadyBought.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:125
      If !(MainQuest as aaafortmainquestscript).hasMedic && Game.GetPlayer().GetItemCount(MedicTent as Form) == 0 ; #DEBUG_LINE_NO:126
        Game.GetPlayer().AddItem(MedicTent as Form, 1, False) ; #DEBUG_LINE_NO:127
      EndIf
      hasMedic = True ; #DEBUG_LINE_NO:129
    EndIf
  ElseIf result == 2 ; #DEBUG_LINE_NO:131
    If !hasArcane ; #DEBUG_LINE_NO:132
      If Game.GetPlayer().GetItemCount(Gold as Form) >= ArcaneTowerCost ; #DEBUG_LINE_NO:133
        Game.GetPlayer().RemoveItem(Gold as Form, ArcaneTowerCost, False, None) ; #DEBUG_LINE_NO:134
        hasArcane = True ; #DEBUG_LINE_NO:135
        (MainQuest as aaafortmainquestscript).hasArcane = True ; #DEBUG_LINE_NO:136
        Game.GetPlayer().AddItem(ArcaneTower as Form, 1, False) ; #DEBUG_LINE_NO:137
        Self.BarracksMenu() ; #DEBUG_LINE_NO:138
      Else
        NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:140
      EndIf
    Else
      AlreadyBought.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:143
      If !(MainQuest as aaafortmainquestscript).hasArcane && Game.GetPlayer().GetItemCount(ArcaneTower as Form) == 0 ; #DEBUG_LINE_NO:144
        Game.GetPlayer().AddItem(ArcaneTower as Form, 1, False) ; #DEBUG_LINE_NO:145
      EndIf
      hasArcane = True ; #DEBUG_LINE_NO:147
    EndIf
  ElseIf result == 3 ; #DEBUG_LINE_NO:149
    Self.ShowUpgradesB() ; #DEBUG_LINE_NO:150
  Else
    Self.BarracksMenu() ; #DEBUG_LINE_NO:152
  EndIf
EndFunction

Function ShowUpgradesB()
  Int result = UpgradesDialogB.Show(PerchCost as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:157
  If result == 0 ; #DEBUG_LINE_NO:158
    If !hasPerch ; #DEBUG_LINE_NO:159
      If Game.GetPlayer().GetItemCount(Gold as Form) >= PerchCost ; #DEBUG_LINE_NO:160
        Game.GetPlayer().RemoveItem(Gold as Form, PerchCost, False, None) ; #DEBUG_LINE_NO:161
        hasPerch = True ; #DEBUG_LINE_NO:162
        (MainQuest as aaafortmainquestscript).hasPerch = True ; #DEBUG_LINE_NO:163
        Game.GetPlayer().AddItem(DragonPerch as Form, 1, False) ; #DEBUG_LINE_NO:164
        Self.BarracksMenu() ; #DEBUG_LINE_NO:165
      Else
        NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:167
      EndIf
    Else
      AlreadyBought.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:170
      If !(MainQuest as aaafortmainquestscript).hasPerch && Game.GetPlayer().GetItemCount(DragonPerch as Form) == 0 ; #DEBUG_LINE_NO:171
        Game.GetPlayer().AddItem(DragonPerch as Form, 1, False) ; #DEBUG_LINE_NO:172
      EndIf
      hasArcane = True ; #DEBUG_LINE_NO:174
    EndIf
  Else
    Self.ShowUpgrades() ; #DEBUG_LINE_NO:195
  EndIf
EndFunction
