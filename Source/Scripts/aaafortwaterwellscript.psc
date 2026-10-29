;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortWaterWellScript.psc
Modified : 2017-12-31 06:50:44
Compiled : 2017-12-31 06:50:49
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortWaterWellScript Extends ObjectReference

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Book Property AlchemyNote Auto
ObjectReference Property BanneredMareSpawn Auto
ActorBase Property CaptainA Auto
ActorBase Property CaptainB Auto
ActorBase Property CaptainC Auto
Book Property ForgeNote Auto
Potion Property GeneralDoorPlan Auto
Book Property GeneralNote Auto
Potion Property GeneralPlan Auto
MiscObject Property Gold001 Auto
Potion Property GrandEstate Auto
Potion Property GrandEstateDoor Auto
Message Property GuardCaptain Auto
Potion Property InnDoorPlan Auto
Book Property InnNote Auto
Potion Property InnPlan Auto
Message Property Mailbox Auto
ObjectReference Property MapMarker Auto
Potion Property MineDoorPlan Auto
Book Property MineNote Auto
Potion Property MinePlan Auto
Message Property NoMessagesDialog Auto
Message Property NotEnoughGold Auto
Quest Property PlayerQuest Auto
Quest Property RandomQuest Auto
Book Property ScavengerNote Auto
Message Property SpecialOrder Auto
ActorBase Property VioletBase Auto
ObjectReference Property VioletRef Auto
Potion Property WoodenCabin Auto
Potion Property WoodenCabinDoorA Auto
Potion Property WoodenCabinDoorB Auto
ObjectReference Property collisionRef Auto
Bool Property hasAlchemyNote = False Auto
Bool Property hasCaptain = False Auto
Bool Property hasForgeNote = False Auto
Bool Property hasGeneralStore = False Auto
Bool Property hasInn = False Auto
Bool Property hasMine = False Auto
Bool Property hasScavengerNote = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnActivate(ObjectReference akActivator)
  If akActivator == Game.GetPlayer() as ObjectReference ; #DEBUG_LINE_NO:54
    If collisionRef != None ; #DEBUG_LINE_NO:55
      collisionRef.MoveTo(Self as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:56
    EndIf
    Int result = Mailbox.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:58
    If result == 0 ; #DEBUG_LINE_NO:59
      If (RandomQuest as aaafortrandomquestscript).ScavengerNote && !hasScavengerNote && !(RandomQuest as aaafortrandomquestscript).readScavengerNote ; #DEBUG_LINE_NO:60
        Game.GetPlayer().AddItem(ScavengerNote as Form, 1, False) ; #DEBUG_LINE_NO:61
        hasScavengerNote = True ; #DEBUG_LINE_NO:62
        (RandomQuest as aaafortrandomquestscript).readScavengerNote = True ; #DEBUG_LINE_NO:63
      ElseIf (RandomQuest as aaafortrandomquestscript).ForgeNote && !hasForgeNote && !(RandomQuest as aaafortrandomquestscript).readForgeNote ; #DEBUG_LINE_NO:64
        Game.GetPlayer().AddItem(ForgeNote as Form, 1, False) ; #DEBUG_LINE_NO:65
        VioletRef = BanneredMareSpawn.PlaceActorAtMe(VioletBase, 4, None) as ObjectReference ; #DEBUG_LINE_NO:66
        hasForgeNote = True ; #DEBUG_LINE_NO:67
        (RandomQuest as aaafortrandomquestscript).readForgeNote = True ; #DEBUG_LINE_NO:68
      ElseIf (RandomQuest as aaafortrandomquestscript).AlchemyNote && !hasAlchemyNote && !(RandomQuest as aaafortrandomquestscript).readAlchemyNote ; #DEBUG_LINE_NO:69
        Game.GetPlayer().AddItem(AlchemyNote as Form, 1, False) ; #DEBUG_LINE_NO:70
        hasAlchemyNote = True ; #DEBUG_LINE_NO:71
        (RandomQuest as aaafortrandomquestscript).readAlchemyNote = True ; #DEBUG_LINE_NO:72
      ElseIf (RandomQuest as aaafortrandomquestscript).generalStore && !hasGeneralStore && !(RandomQuest as aaafortrandomquestscript).readGeneralStore ; #DEBUG_LINE_NO:73
        Game.GetPlayer().AddItem(GeneralNote as Form, 1, False) ; #DEBUG_LINE_NO:74
        Game.GetPlayer().AddItem(GeneralPlan as Form, 1, False) ; #DEBUG_LINE_NO:75
        Game.GetPlayer().AddItem(GeneralDoorPlan as Form, 1, False) ; #DEBUG_LINE_NO:76
        hasGeneralStore = True ; #DEBUG_LINE_NO:77
        (RandomQuest as aaafortrandomquestscript).readGeneralStore = True ; #DEBUG_LINE_NO:78
      ElseIf (RandomQuest as aaafortrandomquestscript).mine && !hasMine && !(RandomQuest as aaafortrandomquestscript).readMine ; #DEBUG_LINE_NO:79
        Game.GetPlayer().AddItem(MineNote as Form, 1, False) ; #DEBUG_LINE_NO:80
        Game.GetPlayer().AddItem(MinePlan as Form, 1, False) ; #DEBUG_LINE_NO:81
        Game.GetPlayer().AddItem(MineDoorPlan as Form, 1, False) ; #DEBUG_LINE_NO:82
        hasMine = True ; #DEBUG_LINE_NO:83
        (RandomQuest as aaafortrandomquestscript).readMine = True ; #DEBUG_LINE_NO:84
      ElseIf (RandomQuest as aaafortrandomquestscript).InnNote && !hasInn && !(RandomQuest as aaafortrandomquestscript).readInn ; #DEBUG_LINE_NO:85
        Game.GetPlayer().AddItem(InnNote as Form, 1, False) ; #DEBUG_LINE_NO:86
        Game.GetPlayer().AddItem(InnPlan as Form, 1, False) ; #DEBUG_LINE_NO:87
        Game.GetPlayer().AddItem(InnDoorPlan as Form, 1, False) ; #DEBUG_LINE_NO:88
        hasInn = True ; #DEBUG_LINE_NO:89
        (RandomQuest as aaafortrandomquestscript).readInn = True ; #DEBUG_LINE_NO:90
      ElseIf (RandomQuest as aaafortrandomquestscript).hasCaptain && !hasCaptain && !(RandomQuest as aaafortrandomquestscript).readCaptain ; #DEBUG_LINE_NO:91
        Int captain = GuardCaptain.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:92
        If captain == 0 ; #DEBUG_LINE_NO:93
          MapMarker.PlaceActorAtMe(CaptainA, 4, None) ; #DEBUG_LINE_NO:94
        ElseIf captain == 1 ; #DEBUG_LINE_NO:95
          MapMarker.PlaceActorAtMe(CaptainB, 4, None) ; #DEBUG_LINE_NO:96
        Else
          MapMarker.PlaceActorAtMe(CaptainC, 4, None) ; #DEBUG_LINE_NO:98
        EndIf
        hasCaptain = True ; #DEBUG_LINE_NO:100
        (RandomQuest as aaafortrandomquestscript).readCaptain = True ; #DEBUG_LINE_NO:101
      Else
        NoMessagesDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:103
      EndIf
    ElseIf result == 1 ; #DEBUG_LINE_NO:105
      Int order = SpecialOrder.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:106
      If order == 0 ; #DEBUG_LINE_NO:107
        If Game.GetPlayer().GetItemCount(Gold001 as Form) >= 5000 ; #DEBUG_LINE_NO:108
          Game.GetPlayer().RemoveItem(Gold001 as Form, 5000, False, None) ; #DEBUG_LINE_NO:109
          Game.GetPlayer().AddItem(WoodenCabin as Form, 1, False) ; #DEBUG_LINE_NO:110
          Game.GetPlayer().AddItem(WoodenCabinDoorA as Form, 1, False) ; #DEBUG_LINE_NO:111
          Game.GetPlayer().AddItem(WoodenCabinDoorB as Form, 1, False) ; #DEBUG_LINE_NO:112
          (PlayerQuest as aaafortplayerquestscript).hasWoodenCabin = 1 ; #DEBUG_LINE_NO:113
        Else
          NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:115
        EndIf
      ElseIf order == 1 ; #DEBUG_LINE_NO:117
        If Game.GetPlayer().GetItemCount(Gold001 as Form) >= 15000 ; #DEBUG_LINE_NO:118
          Game.GetPlayer().RemoveItem(Gold001 as Form, 15000, False, None) ; #DEBUG_LINE_NO:119
          Game.GetPlayer().AddItem(GrandEstate as Form, 1, False) ; #DEBUG_LINE_NO:120
          Game.GetPlayer().AddItem(GrandEstateDoor as Form, 1, False) ; #DEBUG_LINE_NO:121
          (PlayerQuest as aaafortplayerquestscript).hasGrandEstate = 1 ; #DEBUG_LINE_NO:122
        Else
          NotEnoughGold.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:124
        EndIf
      EndIf
    EndIf
  EndIf
EndEvent
