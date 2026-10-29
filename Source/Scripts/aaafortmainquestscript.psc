;/ Decompiled by Champollion v1.3.2
PEX format v3.2 GameID: 1
Source   : aaaFortMainQuestScript.psc
Modified : 2018-01-01 05:34:42
Compiled : 2018-01-01 05:34:57
User     : Danny
Computer : DANNY-PC
/;
ScriptName aaaFortMainQuestScript Extends Quest conditional

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Int Property AXIS_X = 2 AutoReadOnly
Int Property AXIS_Y = 1 AutoReadOnly
Int Property AXIS_Z = 0 AutoReadOnly
ActorBase Property ActorOnPlace Auto
Bool Property AdvancedMode = False Auto
Activator Property BoundaryMarker Auto
Message Property CanceledDialog Auto
Message Property CantCancelDialog Auto
Int Property CitizenCount = 0 Auto
Message Property ConstructedDialog Auto
Int Property CurrentDay = 0 Auto
ObjectReference Property CurrentObject Auto
Int Property DayCount = 1 Auto
Bool Property DebugMode = False Auto
Int Property DistanceSpeed = 30 Auto
Faction Property FollowPlayerFaction Auto
Faction Property FortFaction Auto
MiscObject Property Gold Auto
EffectShader Property GreenGlow Auto
Int Property GuardCount = 0 Auto
ObjectReference Property GuardEquipmentBox Auto
ObjectReference Property InnFromMarker Auto
ObjectReference Property InnMarker Auto
Int Property MODE_DISTANCE = 3 AutoReadOnly
Int Property MODE_RESET = 4 AutoReadOnly
Int Property MODE_ROTATE_X = 2 AutoReadOnly
Int Property MODE_ROTATE_Y = 1 AutoReadOnly
Int Property MODE_ROTATE_Z = 0 AutoReadOnly
Actor Property MarketVendor Auto
ObjectReference Property MinerContainer Auto
Int Property MinerCount = 0 Auto
Message Property ModeDistanceDialog Auto
Message Property ModeRotateXDialog Auto
Message Property ModeRotateYDialog Auto
Message Property ModeRotateZDialog Auto
MiscObject Property OreCorundum Auto
MiscObject Property OreEbony Auto
MiscObject Property OreGold Auto
MiscObject Property OreIron Auto
MiscObject Property OreMalachite Auto
MiscObject Property OreMoonstone Auto
MiscObject Property OreOrichalcum Auto
MiscObject Property OreQuicksilver Auto
MiscObject Property OreSilver Auto
Message Property PlacementMessage Auto
Message Property PlacementMessageB Auto
EffectShader Property RedGlow Auto
ObjectReference Property RefHolding Auto
Message Property ReusablePlanDialog Auto
Int Property RotationSpeed = 10 Auto
Int Property ScavengerCount = 0 Auto
ObjectReference Property ScavengerCrateRef Auto
Message Property TooCloseMessage Auto
Message Property TooFarMessage Auto
ObjectReference Property TraderPendingBox Auto
Int Property TraderPendingSale = 0 Auto
Quest Property TutorialQuest Auto
Cell Property aaaFortGrandEstateInterior Auto
Cell Property aaaFortWoodenCabinInterior Auto
Bool Property canPlace = False Auto
Potion Property cancelPotion Auto
Bool Property close = False Auto
ObjectReference Property collisionRef Auto
Int Property currentAxis = 0 Auto
Int Property currentMode = 0 Auto
Bool Property disperseDaily = False Auto
Int Property distance = 400 Auto
Bool Property dontDeleteOnCancel = False Auto
Bool Property equipBoxEnabled = False Auto
Bool Property hasArcane = False Auto
Bool Property hasArmory = False Auto conditional
Bool Property hasChangedMode = False Auto
Bool Property hasEquipBox = False Auto
Bool Property hasMedic = False Auto
Bool Property hasPerch = False Auto
Bool Property hideIdleMarkers = True Auto
Bool Property inputMinus = False Auto
Bool Property inputPlus = False Auto
ObjectReference Property marker Auto
Int Property maxDistance = 6000 Auto
Int Property placeDistance = 0 Auto
Bool Property rotate = True Auto
Int Property rotationx = 0 Auto
Int Property rotationy = 0 Auto
Int Property rotationz = 0 Auto
Bool Property setArcane = False Auto
Bool Property setBoundaries = False Auto
Bool Property setMarket = False Auto
Bool Property setMedic = False Auto
Bool Property setWaterWell = False Auto
Bool Property shouldReusePlan = False Auto
Int Property stage = 0 Auto
String Property status = "inactive" Auto
Bool Property tutorialDone = False Auto

;-- Functions ---------------------------------------

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Event OnInit()
  CurrentDay = Utility.GetCurrentGameTime() as Int ; #DEBUG_LINE_NO:111
  Game.GetPlayer().AddToFaction(FortFaction) ; #DEBUG_LINE_NO:112
EndEvent

Function ChangeRotationAxis()
  If currentAxis == Self.AXIS_X ; #DEBUG_LINE_NO:116
    ModeRotateYDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:117
    currentAxis = Self.AXIS_Y ; #DEBUG_LINE_NO:118
  ElseIf currentAxis == Self.AXIS_Y ; #DEBUG_LINE_NO:119
    ModeRotateZDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:120
    currentAxis = Self.AXIS_Z ; #DEBUG_LINE_NO:121
  ElseIf currentAxis == Self.AXIS_Z ; #DEBUG_LINE_NO:122
    ModeRotateXDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:123
    currentAxis = Self.AXIS_X ; #DEBUG_LINE_NO:124
  EndIf
EndFunction

Function ResetObjectPosition()
  rotationx = 0 ; #DEBUG_LINE_NO:129
  rotationy = 0 ; #DEBUG_LINE_NO:130
  rotationz = 0 ; #DEBUG_LINE_NO:131
  distance = 400 ; #DEBUG_LINE_NO:132
EndFunction

Function UpdateObjectPosition(ObjectReference object)
  Float playerY = Game.GetPlayer().GetPositionY() ; #DEBUG_LINE_NO:136
  Float playerX = Game.GetPlayer().GetPositionX() ; #DEBUG_LINE_NO:137
  Float playerZ = Game.GetPlayer().GetPositionZ() ; #DEBUG_LINE_NO:138
  Float playerRotationZ = Game.GetPlayer().GetAngleZ() ; #DEBUG_LINE_NO:139
  Float playerRotationX = Game.GetPlayer().GetAngleX() ; #DEBUG_LINE_NO:140
  Float objectZ = Math.sin(playerRotationX) * distance as Float ; #DEBUG_LINE_NO:141
  objectZ = playerZ - objectZ + 80 as Float ; #DEBUG_LINE_NO:142
  Float objectX = Math.sin(playerRotationZ) * distance as Float ; #DEBUG_LINE_NO:143
  Float objectY = Math.cos(playerRotationZ) * distance as Float ; #DEBUG_LINE_NO:144
  objectY = playerY + objectY ; #DEBUG_LINE_NO:145
  objectX = playerX + objectX ; #DEBUG_LINE_NO:146
  object.TranslateTo(objectX, objectY, objectZ, rotationx as Float, rotationy as Float, rotationz as Float, 8000 as Float, 8000 as Float) ; #DEBUG_LINE_NO:148
EndFunction

Function UpdateInput()
  If currentMode == Self.MODE_DISTANCE ; #DEBUG_LINE_NO:152
    If inputPlus && inputMinus && !hasChangedMode ; #DEBUG_LINE_NO:153
      currentMode = Self.MODE_ROTATE_Z ; #DEBUG_LINE_NO:154
      ModeRotateZDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:155
      hasChangedMode = True ; #DEBUG_LINE_NO:156
    ElseIf inputPlus && !inputMinus ; #DEBUG_LINE_NO:157
      distance += DistanceSpeed ; #DEBUG_LINE_NO:158
    ElseIf inputMinus && !inputPlus ; #DEBUG_LINE_NO:159
      distance -= DistanceSpeed ; #DEBUG_LINE_NO:160
    EndIf
  ElseIf currentMode == Self.MODE_ROTATE_Z ; #DEBUG_LINE_NO:162
    If inputPlus && inputMinus && !hasChangedMode ; #DEBUG_LINE_NO:163
      currentMode = Self.MODE_DISTANCE ; #DEBUG_LINE_NO:164
      ModeDistanceDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:165
      hasChangedMode = True ; #DEBUG_LINE_NO:166
    ElseIf inputPlus && !inputMinus ; #DEBUG_LINE_NO:167
      If currentAxis == Self.AXIS_X ; #DEBUG_LINE_NO:168
        rotationx += RotationSpeed ; #DEBUG_LINE_NO:169
      ElseIf currentAxis == Self.AXIS_Y ; #DEBUG_LINE_NO:170
        rotationy += RotationSpeed ; #DEBUG_LINE_NO:171
      ElseIf currentAxis == Self.AXIS_Z ; #DEBUG_LINE_NO:172
        rotationz += RotationSpeed ; #DEBUG_LINE_NO:173
      EndIf
    ElseIf inputMinus && !inputPlus ; #DEBUG_LINE_NO:175
      If currentAxis == Self.AXIS_X ; #DEBUG_LINE_NO:176
        rotationx -= RotationSpeed ; #DEBUG_LINE_NO:177
      ElseIf currentAxis == Self.AXIS_Y ; #DEBUG_LINE_NO:178
        rotationy -= RotationSpeed ; #DEBUG_LINE_NO:179
      ElseIf currentAxis == Self.AXIS_Z ; #DEBUG_LINE_NO:180
        rotationz -= RotationSpeed ; #DEBUG_LINE_NO:181
      EndIf
    EndIf
  EndIf
  If (!inputPlus || !inputMinus) && hasChangedMode ; #DEBUG_LINE_NO:186
    hasChangedMode = False ; #DEBUG_LINE_NO:187
  EndIf
EndFunction

Function StartPositioning(ObjectReference Ref, Potion Cancel, Bool reuse, Bool dontDelete)
  cancelPotion = Cancel ; #DEBUG_LINE_NO:192
  shouldReusePlan = reuse ; #DEBUG_LINE_NO:193
  dontDeleteOnCancel = dontDelete ; #DEBUG_LINE_NO:194
  CurrentObject = Ref ; #DEBUG_LINE_NO:195
  If (Ref.GetBaseObject() != BoundaryMarker as Form) || (Ref.GetBaseObject() == BoundaryMarker as Form) && Ref.CountLinkedRefChain(None, 8) == 7 ; #DEBUG_LINE_NO:197
    setBoundaries = False ; #DEBUG_LINE_NO:198
  EndIf
  CurrentObject.MoveTo(Game.GetPlayer() as ObjectReference, 0 as Float, 0 as Float, 1000 as Float, True) ; #DEBUG_LINE_NO:201
  Self.UpdateObjectPosition(CurrentObject) ; #DEBUG_LINE_NO:202
  stage = 1 ; #DEBUG_LINE_NO:204
  Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:206
  Self.RegisterForSingleUpdate(0.01) ; #DEBUG_LINE_NO:207
EndFunction

Function ConfirmPlacement()
  If canPlace ; #DEBUG_LINE_NO:211
    If setWaterWell ; #DEBUG_LINE_NO:212
      marker.MoveTo(Game.GetPlayer() as ObjectReference, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:213
      setWaterWell = False ; #DEBUG_LINE_NO:214
      TutorialQuest.SetStage(20) ; #DEBUG_LINE_NO:215
    EndIf
    ConstructedDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:218
    CurrentObject.StopTranslation() ; #DEBUG_LINE_NO:219
    CurrentObject.MoveTo(CurrentObject, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:220
    RedGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:221
    GreenGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:222
    If shouldReusePlan ; #DEBUG_LINE_NO:224
      CurrentObject = CurrentObject.PlaceAtMe(CurrentObject.GetBaseObject(), 1, False, False) ; #DEBUG_LINE_NO:225
      ReusablePlanDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:226
    Else
      status = "placed" ; #DEBUG_LINE_NO:228
      stage = 0 ; #DEBUG_LINE_NO:229
      Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:230
      RedGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:231
      GreenGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:232
    EndIf
    If collisionRef != None ; #DEBUG_LINE_NO:235
      collisionRef.MoveTo(CurrentObject, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:236
      collisionRef = None ; #DEBUG_LINE_NO:237
    EndIf
    If ActorOnPlace != None ; #DEBUG_LINE_NO:240
      Actor moveRef = CurrentObject.PlaceActorAtMe(ActorOnPlace, 4, None) ; #DEBUG_LINE_NO:242
      moveRef.MoveTo(CurrentObject, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:244
      moveRef.SetAngle(moveRef.GetAngleX(), moveRef.GetAngleY(), CurrentObject.GetAngleZ() + 180 as Float) ; #DEBUG_LINE_NO:245
      GuardCount += 1 ; #DEBUG_LINE_NO:247
      CurrentObject.Delete() ; #DEBUG_LINE_NO:248
      ActorOnPlace = None ; #DEBUG_LINE_NO:249
    EndIf
    If TutorialQuest.IsCompleted() && setBoundaries ; #DEBUG_LINE_NO:253
      setBoundaries = False ; #DEBUG_LINE_NO:254
    EndIf
    If setMarket ; #DEBUG_LINE_NO:257
      MarketVendor.MoveTo(marker, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:258
      MarketVendor.Enable(False) ; #DEBUG_LINE_NO:259
      setMarket = False ; #DEBUG_LINE_NO:260
    ElseIf setMedic
      setMedic = False ; #DEBUG_LINE_NO:262
      hasMedic = True ; #DEBUG_LINE_NO:263
    ElseIf setArcane
      setArcane = False ; #DEBUG_LINE_NO:265
      hasArcane = True ; #DEBUG_LINE_NO:266
    EndIf
  ElseIf placeDistance > 0 ; #DEBUG_LINE_NO:268
    If close && placeDistance > 0 ; #DEBUG_LINE_NO:269
      TooCloseMessage.Show(placeDistance as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:270
    Else
      TooFarMessage.Show(placeDistance as Float, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:272
    EndIf
  EndIf
EndFunction

Function CancelPlacement()
  If cancelPotion != None && !setWaterWell ; #DEBUG_LINE_NO:278
    CanceledDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:279
    If shouldReusePlan ; #DEBUG_LINE_NO:280
      If Game.GetPlayer().GetItemCount(cancelPotion as Form) < 1 ; #DEBUG_LINE_NO:281
        Game.GetPlayer().AddItem(cancelPotion as Form, 1, False) ; #DEBUG_LINE_NO:282
      EndIf
    Else
      Game.GetPlayer().AddItem(cancelPotion as Form, 1, False) ; #DEBUG_LINE_NO:285
    EndIf
    CurrentObject.StopTranslation() ; #DEBUG_LINE_NO:287
    If dontDeleteOnCancel ; #DEBUG_LINE_NO:288
      CurrentObject.MoveTo(RefHolding, 0.0, 0.0, 0.0, True) ; #DEBUG_LINE_NO:289
    Else
      CurrentObject.Delete() ; #DEBUG_LINE_NO:291
    EndIf
    CurrentObject = None ; #DEBUG_LINE_NO:293
    cancelPotion = None ; #DEBUG_LINE_NO:294
    ActorOnPlace = None ; #DEBUG_LINE_NO:295
    collisionRef = None ; #DEBUG_LINE_NO:296
    status = "canceled" ; #DEBUG_LINE_NO:297
    stage = 0 ; #DEBUG_LINE_NO:298
    Self.UnregisterForUpdate() ; #DEBUG_LINE_NO:299
  Else
    CantCancelDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:301
  EndIf
EndFunction

Event OnUpdate()
  If stage == 1 ; #DEBUG_LINE_NO:306
    If !tutorialDone ; #DEBUG_LINE_NO:307
      Int result = PlacementMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:308
      If result == 0 ; #DEBUG_LINE_NO:309
        PlacementMessageB.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:310
      EndIf
      tutorialDone = True ; #DEBUG_LINE_NO:312
    EndIf
    Self.UpdateInput() ; #DEBUG_LINE_NO:315
    Self.UpdateObjectPosition(CurrentObject) ; #DEBUG_LINE_NO:316
    If AdvancedMode || Game.GetPlayer().GetParentCell() == aaaFortWoodenCabinInterior || Game.GetPlayer().GetParentCell() == aaaFortGrandEstateInterior ; #DEBUG_LINE_NO:318
      canPlace = True ; #DEBUG_LINE_NO:319
      placeDistance = 0 ; #DEBUG_LINE_NO:320
    ElseIf !setWaterWell && !setBoundaries ; #DEBUG_LINE_NO:321
      If CurrentObject.GetDistance(marker) < maxDistance as Float ; #DEBUG_LINE_NO:322
        canPlace = True ; #DEBUG_LINE_NO:323
        placeDistance = 0 ; #DEBUG_LINE_NO:324
      Else
        canPlace = False ; #DEBUG_LINE_NO:326
        placeDistance = CurrentObject.GetDistance(marker) as Int - maxDistance ; #DEBUG_LINE_NO:327
        close = False ; #DEBUG_LINE_NO:329
      EndIf
    ElseIf setBoundaries
      If CurrentObject.GetDistance(marker) >= (maxDistance - 500) as Float ; #DEBUG_LINE_NO:332
        If CurrentObject.GetDistance(marker) <= maxDistance as Float ; #DEBUG_LINE_NO:333
          canPlace = True ; #DEBUG_LINE_NO:334
          placeDistance = 0 ; #DEBUG_LINE_NO:335
        Else
          canPlace = False ; #DEBUG_LINE_NO:337
          placeDistance = CurrentObject.GetDistance(marker) as Int - maxDistance - 500 ; #DEBUG_LINE_NO:338
          close = False ; #DEBUG_LINE_NO:340
        EndIf
      Else
        canPlace = False ; #DEBUG_LINE_NO:343
        placeDistance = maxDistance - 500 - CurrentObject.GetDistance(marker) as Int ; #DEBUG_LINE_NO:344
        close = True ; #DEBUG_LINE_NO:346
      EndIf
    ElseIf setWaterWell
      canPlace = True ; #DEBUG_LINE_NO:349
      placeDistance = 0 ; #DEBUG_LINE_NO:350
    EndIf
    If stage == 1 ; #DEBUG_LINE_NO:353
      If canPlace ; #DEBUG_LINE_NO:354
        RedGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:355
        GreenGlow.Play(CurrentObject, -1.0) ; #DEBUG_LINE_NO:356
      Else
        GreenGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:358
        RedGlow.Play(CurrentObject, -1.0) ; #DEBUG_LINE_NO:359
      EndIf
      Self.RegisterForSingleUpdate(0.01) ; #DEBUG_LINE_NO:362
    EndIf
  EndIf
EndEvent
