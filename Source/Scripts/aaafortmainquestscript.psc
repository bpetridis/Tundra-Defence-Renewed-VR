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

; The player reference never changes, so positioning fetches it once instead of six times per
; tick inside the loop at the bottom of this script.
Actor PlayerRef

; Float mirrors of the Int distance and rotation properties. Scaling movement by elapsed time
; produces fractions, and rounding to Int every tick would throw them away and stall slow input.
Float distanceFloat
Float rotationxFloat
Float rotationyFloat
Float rotationzFloat

; Real time at the previous positioning tick, so movement is scaled by how long that tick
; actually took instead of assuming every tick is the same length.
Float lastTickTime

; What the glow shaders are showing: 0 none, 1 green, 2 red. The loop used to call Play and Stop
; on both shaders every single tick, re-starting a shader that was already running.
Int glowState

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

; How often the positioning loop runs, in seconds. The original asked for 0.01 - a hundred times
; a second - which Papyrus cannot deliver: a pending update is only picked up on a game update
; pass, so the real rate is the frame rate, up to that ceiling. Kept at 0.01 so nothing changes
; by default. Raising it now only affects how closely the preview tracks your view, not how fast
; the controls move, because the controls below are scaled by elapsed time.
Float Property UpdateInterval = 0.01 Auto

; The tick rate the original per-tick DistanceSpeed and RotationSpeed numbers were tuned against.
; Scaling by elapsed time times this reproduces the original feel exactly at 60 fps and makes
; every other frame rate match it, instead of the controls running half again as fast at 90 fps
; and at half speed at 30.
Float Property ReferenceRate = 60.0 Auto

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

; Puts the preview object a fixed distance out along the player's facing. Unchanged arithmetic;
; the five Game.GetPlayer() calls are now one cached reference, which matters in a loop this hot.
Function UpdateObjectPosition(ObjectReference object)
  If PlayerRef == None
    PlayerRef = Game.GetPlayer()
  EndIf
  Float playerY = PlayerRef.GetPositionY() ; #DEBUG_LINE_NO:136
  Float playerX = PlayerRef.GetPositionX() ; #DEBUG_LINE_NO:137
  Float playerZ = PlayerRef.GetPositionZ() ; #DEBUG_LINE_NO:138
  Float playerRotationZ = PlayerRef.GetAngleZ() ; #DEBUG_LINE_NO:139
  Float playerRotationX = PlayerRef.GetAngleX() ; #DEBUG_LINE_NO:140
  Float objectZ = Math.sin(playerRotationX) * distance as Float ; #DEBUG_LINE_NO:141
  objectZ = playerZ - objectZ + 80 as Float ; #DEBUG_LINE_NO:142
  Float objectX = Math.sin(playerRotationZ) * distance as Float ; #DEBUG_LINE_NO:143
  Float objectY = Math.cos(playerRotationZ) * distance as Float ; #DEBUG_LINE_NO:144
  objectY = playerY + objectY ; #DEBUG_LINE_NO:145
  objectX = playerX + objectX ; #DEBUG_LINE_NO:146
  object.TranslateTo(objectX, objectY, objectZ, rotationx as Float, rotationy as Float, rotationz as Float, 8000 as Float, 8000 as Float) ; #DEBUG_LINE_NO:148
EndFunction

; Pulls the Int properties into the float mirrors. Other scripts write distance and rotationz
; directly before positioning starts, so the mirrors have to be re-read, not trusted.
Function SyncInputFromProperties()
  distanceFloat = distance as Float
  rotationxFloat = rotationx as Float
  rotationyFloat = rotationy as Float
  rotationzFloat = rotationz as Float
EndFunction

; Applies the held input for one tick. scale is how much of a reference tick this one was worth,
; so a long tick moves the object further and a short one less: it travels the same distance per
; second whatever the frame rate. The original added the whole of DistanceSpeed every tick, which
; made the controls exactly as fast as the machine was, so the author's numbers only feel right
; on the author's machine.
Function UpdateInput(Float scale)
  If currentMode == Self.MODE_DISTANCE ; #DEBUG_LINE_NO:152
    If inputPlus && inputMinus && !hasChangedMode ; #DEBUG_LINE_NO:153
      currentMode = Self.MODE_ROTATE_Z ; #DEBUG_LINE_NO:154
      ModeRotateZDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:155
      hasChangedMode = True ; #DEBUG_LINE_NO:156
    ElseIf inputPlus && !inputMinus ; #DEBUG_LINE_NO:157
      distanceFloat += DistanceSpeed as Float * scale ; #DEBUG_LINE_NO:158
      distance = distanceFloat as Int
    ElseIf inputMinus && !inputPlus ; #DEBUG_LINE_NO:159
      distanceFloat -= DistanceSpeed as Float * scale ; #DEBUG_LINE_NO:160
      distance = distanceFloat as Int
    EndIf
  ElseIf currentMode == Self.MODE_ROTATE_Z ; #DEBUG_LINE_NO:162
    If inputPlus && inputMinus && !hasChangedMode ; #DEBUG_LINE_NO:163
      currentMode = Self.MODE_DISTANCE ; #DEBUG_LINE_NO:164
      ModeDistanceDialog.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:165
      hasChangedMode = True ; #DEBUG_LINE_NO:166
    ElseIf inputPlus && !inputMinus ; #DEBUG_LINE_NO:167
      If currentAxis == Self.AXIS_X ; #DEBUG_LINE_NO:168
        rotationxFloat += RotationSpeed as Float * scale ; #DEBUG_LINE_NO:169
        rotationx = rotationxFloat as Int
      ElseIf currentAxis == Self.AXIS_Y ; #DEBUG_LINE_NO:170
        rotationyFloat += RotationSpeed as Float * scale ; #DEBUG_LINE_NO:171
        rotationy = rotationyFloat as Int
      ElseIf currentAxis == Self.AXIS_Z ; #DEBUG_LINE_NO:172
        rotationzFloat += RotationSpeed as Float * scale ; #DEBUG_LINE_NO:173
        rotationz = rotationzFloat as Int
      EndIf
    ElseIf inputMinus && !inputPlus ; #DEBUG_LINE_NO:175
      If currentAxis == Self.AXIS_X ; #DEBUG_LINE_NO:176
        rotationxFloat -= RotationSpeed as Float * scale ; #DEBUG_LINE_NO:177
        rotationx = rotationxFloat as Int
      ElseIf currentAxis == Self.AXIS_Y ; #DEBUG_LINE_NO:178
        rotationyFloat -= RotationSpeed as Float * scale ; #DEBUG_LINE_NO:179
        rotationy = rotationyFloat as Int
      ElseIf currentAxis == Self.AXIS_Z ; #DEBUG_LINE_NO:180
        rotationzFloat -= RotationSpeed as Float * scale ; #DEBUG_LINE_NO:181
        rotationz = rotationzFloat as Int
      EndIf
    EndIf
  EndIf
  If (!inputPlus || !inputMinus) && hasChangedMode ; #DEBUG_LINE_NO:186
    hasChangedMode = False ; #DEBUG_LINE_NO:187
  EndIf
EndFunction

Function StartPositioning(ObjectReference Ref, Potion Cancel, Bool reuse, Bool dontDelete)
  PlayerRef = Game.GetPlayer()
  Self.SyncInputFromProperties()
  lastTickTime = Utility.GetCurrentRealTime()
  glowState = 0
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
  Self.RegisterForSingleUpdate(UpdateInterval) ; #DEBUG_LINE_NO:207
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
    ; Nothing is glowing now. The reuse branch below carries on positioning a brand new object,
    ; which has no shader on it, so the loop has to be told to apply one on its next tick.
    glowState = 0
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
    glowState = 0
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

; The build preview loop. It runs only while an object is being placed - stage 1 - and stops the
; moment placement is confirmed or cancelled. Four changes from the original, none of which alter
; what the player sees:
;
;   - the player reference is fetched once per tick instead of six times, and the distance from
;     the object to the fort marker once instead of up to three times
;   - the glow shaders are only touched when the red/green state actually changes, rather than
;     being re-started on every tick for as long as positioning lasts
;   - movement is scaled by how long the tick took, so the controls run at one speed on every
;     machine instead of tracking the frame rate
;   - the interval is a property, so the tick rate can be tested without editing this script
Event OnUpdate()
  If stage == 1 ; #DEBUG_LINE_NO:306
    If !tutorialDone ; #DEBUG_LINE_NO:307
      Int result = PlacementMessage.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:308
      If result == 0 ; #DEBUG_LINE_NO:309
        PlacementMessageB.Show(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0) ; #DEBUG_LINE_NO:310
      EndIf
      tutorialDone = True ; #DEBUG_LINE_NO:312
    EndIf
    ; How long since the previous tick, as a multiple of a reference tick. Clamped so that a
    ; stall, a loading screen or the message box above cannot make the object leap on one tick.
    Float now = Utility.GetCurrentRealTime()
    Float scale = (now - lastTickTime) * ReferenceRate
    If scale <= 0.0 || scale > 4.0
      scale = 1.0
    EndIf
    lastTickTime = now
    Self.UpdateInput(scale) ; #DEBUG_LINE_NO:315
    Self.UpdateObjectPosition(CurrentObject) ; #DEBUG_LINE_NO:316
    If PlayerRef == None
      PlayerRef = Game.GetPlayer()
    EndIf
    Cell playerCell = PlayerRef.GetParentCell()
    If AdvancedMode || playerCell == aaaFortWoodenCabinInterior || playerCell == aaaFortGrandEstateInterior ; #DEBUG_LINE_NO:318
      canPlace = True ; #DEBUG_LINE_NO:319
      placeDistance = 0 ; #DEBUG_LINE_NO:320
    Else
      Float markerDistance = CurrentObject.GetDistance(marker)
      If !setWaterWell && !setBoundaries ; #DEBUG_LINE_NO:321
        If markerDistance < maxDistance as Float ; #DEBUG_LINE_NO:322
          canPlace = True ; #DEBUG_LINE_NO:323
          placeDistance = 0 ; #DEBUG_LINE_NO:324
        Else
          canPlace = False ; #DEBUG_LINE_NO:326
          placeDistance = markerDistance as Int - maxDistance ; #DEBUG_LINE_NO:327
          close = False ; #DEBUG_LINE_NO:329
        EndIf
      ElseIf setBoundaries
        If markerDistance >= (maxDistance - 500) as Float ; #DEBUG_LINE_NO:332
          If markerDistance <= maxDistance as Float ; #DEBUG_LINE_NO:333
            canPlace = True ; #DEBUG_LINE_NO:334
            placeDistance = 0 ; #DEBUG_LINE_NO:335
          Else
            canPlace = False ; #DEBUG_LINE_NO:337
            placeDistance = markerDistance as Int - maxDistance - 500 ; #DEBUG_LINE_NO:338
            close = False ; #DEBUG_LINE_NO:340
          EndIf
        Else
          canPlace = False ; #DEBUG_LINE_NO:343
          placeDistance = maxDistance - 500 - markerDistance as Int ; #DEBUG_LINE_NO:344
          close = True ; #DEBUG_LINE_NO:346
        EndIf
      ElseIf setWaterWell
        canPlace = True ; #DEBUG_LINE_NO:349
        placeDistance = 0 ; #DEBUG_LINE_NO:350
      EndIf
    EndIf
    If stage == 1 ; #DEBUG_LINE_NO:353
      If canPlace && glowState != 1 ; #DEBUG_LINE_NO:354
        RedGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:355
        GreenGlow.Play(CurrentObject, -1.0) ; #DEBUG_LINE_NO:356
        glowState = 1
      ElseIf !canPlace && glowState != 2
        GreenGlow.Stop(CurrentObject) ; #DEBUG_LINE_NO:358
        RedGlow.Play(CurrentObject, -1.0) ; #DEBUG_LINE_NO:359
        glowState = 2
      EndIf
      Self.RegisterForSingleUpdate(UpdateInterval) ; #DEBUG_LINE_NO:362
    EndIf
  EndIf
EndEvent
