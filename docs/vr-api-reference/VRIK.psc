Scriptname VRIK Hidden

;	██ ███    ██ ██     ███████ ██ ██      ███████ ███████
;	██ ████   ██ ██     ██      ██ ██      ██      ██
;	██ ██ ██  ██ ██     █████   ██ ██      █████   ███████
;	██ ██  ██ ██ ██     ██      ██ ██      ██           ██
;	██ ██   ████ ██     ██      ██ ███████ ███████ ███████

; vrik.ini ------------------------------------------------------------------------------------------------------------------

; Set the value of a setting (does not save to disk yet)
Function VrikSetSetting(String name, Float value) native global

; Fetch the value of a setting
Float Function VrikGetSetting(String name) native global

; Writes all settings to vrik.ini
Function VrikSaveSettings() native global

; Restores settings to previous values written to disk
Function VrikRestoreSettings() native global

; Gets the default value of a setting
Float Function VrikGetSettingDefault(String name) native global

; Gets the minimum value of a setting
Float Function VrikGetSettingMin(String name) native global

; Gets the maximum value of a setting
Float Function VrikGetSettingMax(String name) native global

; Gets the slider interval of a setting
Float Function VrikGetSettingInterval(String name) native global

; vrikslots.ini -------------------------------------------------------------------------------------------------------------

; Set the value of a slot setting (does not save to disk yet)
Function VrikSetSlot(String name, Float value) native global

; Fetch the value of a slot setting
Float Function VrikGetSlot(String name) native global

; Sets the slot to its default position and rotation
Function VrikRevertSlotTransform(Int SlotNumber) native global

; Writes all slot settings to vrikslots.ini
Function VrikSaveSlots() native global

; Gets the default value of a slot setting
Float Function VrikGetSlotDefault(String name) native global

; Gets the minimum value of a slot setting
Float Function VrikGetSlotMin(String name) native global

; Gets the maximum value of a slot setting
Float Function VrikGetSlotMax(String name) native global

; Gets the slider interval of a slot setting
Float Function VrikGetSlotInterval(String name) native global

; vrikgestures.ini ----------------------------------------------------------------------------------------------------------

; Set the value of a gesture setting (does not save to disk yet)
Function VrikSetGesture(String name, Float value) native global
Function VrikSetGestureString(String name, String value) native global

; Fetch the value of a gesture setting
Float Function VrikGetGesture(String name) native global
String Function VrikGetGestureString(String name) native global

; Writes all slot settings to vrikgestures.ini
Function VrikSaveGestures() native global

; Gets the default value of a gesture setting
Float Function VrikGetGestureDefault(String name) native global

; Gets the minimum value of a gesture setting
Float Function VrikGetGestureMin(String name) native global

; Gets the maximum value of a gesture setting
Float Function VrikGetGestureMax(String name) native global

; Gets the slider interval of a gesture setting
Float Function VrikGetGestureInterval(String name) native global

; Handle lists of forms and numbers in vrikgestures.ini
Function VrikGestureListSetForm(String name, Form form) native global
Function VrikGestureListAppendForm(String name, Form form) native global
Function VrikGestureListAppendNumber(String name, Int value) native global
Function VrikGestureListRemoveElement(String name, Int removeIndex) native global
Int Function VrikGestureListGetCount(String name) native global
Form Function VrikGestureListGetForm(String name, Int formIndex) native global
Int Function VrikGestureListGetNumber(String name, Int numberIndex) native global

;	██   ██  ██████  ██      ███████ ████████ ███████ ██████  ███████
;	██   ██ ██    ██ ██      ██         ██    ██      ██   ██ ██
;	███████ ██    ██ ██      ███████    ██    █████   ██████  ███████
;	██   ██ ██    ██ ██           ██    ██    ██      ██   ██      ██
;	██   ██  ██████  ███████ ███████    ██    ███████ ██   ██ ███████

; Returns true if VRIK is displaying the slot
Bool Function VrikGetSlotDisplayed(Int SlotNumber) native global

; Sets slot weapon type for VRIK
Function VrikSetSlotWeaponType(Int SlotNumber, Form weapon) native global

; Sets slot as equipped to 0=None 1=Left 2=Right
Function VrikSetSlotEquipped(Int SlotNumber, Int Hand) native global

; Assigns an art object to a slot
Function VrikSetSlotForArt(Int slotNumber, Art ArtObject) native global

;	 ██████  ███████ ███████ ████████ ██    ██ ██████  ███████ ███████
;	██       ██      ██         ██    ██    ██ ██   ██ ██      ██
;	██   ███ █████   ███████    ██    ██    ██ ██████  █████   ███████
;	██    ██ ██           ██    ██    ██    ██ ██   ██ ██           ██
;	 ██████  ███████ ███████    ██     ██████  ██   ██ ███████ ███████

; VRIK Gestures can be tied to actions from other mods.  Use this function to tell VRIK which Mod Event to call.
; Set the mcmEntryName = "" for gesture actions which should not be shown in the MCM (only useful for Gesture Profiles)
; Example setup of a VRIK Gesture Action:
; Event OnInit()
;	RegisterForModEvent("myAction1", "OnMyAction")
;	VRIK.VrikAddGestureAction("myAction1", "Action Name to Show in MCM")
; EndEvent
; Event OnPlayerLoadGame()
;	RegisterForModEvent("myAction1", "OnMyAction")
;	VRIK.VrikAddGestureAction("myAction1", "Action Name to Show in MCM")
; EndEvent
; Event OnMyAction(string eventName, string strArg, float numArg, Form sender)
;	; Your code here is called when the gesture is used
; EndEvent
Function VrikAddGestureAction(String modEventName, String mcmEntryName) native global

; Mods can also switch to a custom gesture profile using the following settings (see vrikgestures.ini for numbering):
; All actions must first be registered with SKSE using RegisterForModEvent
;	VRIK.VrikBeginGestureProfile() ; Begin using a new profile --- it starts empty
;	VRIK.VrikSetProfileAction(1,  "myAction1") ; Use myAction1 on gesture #1:  Left Thumbstick Press
;	VRIK.VrikSetProfileAction(14, "myAction2") ; Use myAction2 on gesture #14: Right Thumbstick Press
;	; ... Mod profile is now in effect, left/right thumbsticks temporarily perform actions ...
;	VRIK.VrikEndGestureProfile() ; Revert gestures back to user settings
Function VrikBeginGestureProfile() native global
Function VrikSetProfileAction(Int gestureNumber, String modEventName) native global
Function VrikEndGestureProfile() native global

; Functions to fetch information about registered mod actions
Int Function VrikGetModActionCount() native global
;String Function VrikGetModActionEventName(Int index) native global
String Function VrikGetModActionMenuName(Int index) native global

; This function appends data to an array containing lists of inventory items / spells / powers
String[] Function AppendPlayerItems(String[] input, Form selectedForm, Bool addArmor, Bool addWeapons, Bool addSpells, Bool addPowers, Bool addShouts, Bool addConsumables) native global
Form Function GetPlayerItemForm(String name, Form selectedForm, Bool addArmor, Bool addWeapons, Bool addSpells, Bool addPowers, Bool addShouts, Bool addConsumables) native global
Int Function GetPlayerItemIndex(String[] input, String itemName, Int startIndex) native global


;	██   ██  █████  ███    ██ ██████  ███████
;	██   ██ ██   ██ ████   ██ ██   ██ ██
;	███████ ███████ ██ ██  ██ ██   ██ ███████
;	██   ██ ██   ██ ██  ██ ██ ██   ██      ██
;	██   ██ ██   ██ ██   ████ ██████  ███████


; Fetch VRIK finger position (0=closed to 1=open), and set min/max finger positions
; VRIK normally controls the range of fingers on its own.  Return control to VRIK with VrikRestoreFingers when done.
; Fingers are indexed as follows: 0=thumb, 1=index, 2=middle, 3=ring, 4=pinky
Float Function VrikGetFingerPos(Int fingerIndex) native global
Function VrikSetLeftFingerRange(Float min0, Float max0, Float min1, Float max1, Float min2, Float max2, Float min3, Float max3, Float min4, Float max4) native global
Function VrikSetRightFingerRange(Float min0, Float max0, Float min1, Float max1, Float min2, Float max2, Float min3, Float max3, Float min4, Float max4) native global
Function VrikRestoreFingers(Bool isLeft) native global


;	██   ██ ███████ ██      ██████  ███████ ██████  ███████
;	██   ██ ██      ██      ██   ██ ██      ██   ██ ██
;	███████ █████   ██      ██████  █████   ██████  ███████
;	██   ██ ██      ██      ██      ██      ██   ██      ██
;	██   ██ ███████ ███████ ██      ███████ ██   ██ ███████


; Returns the build number of the current VRIK release.  This number increases with each new build.
Int Function VrikGetBuildNumber() native global

; Returns true if weapons are out or if they're swapping
Bool Function VrikIsWeaponDrawn() native global

; Forces the player to draw or sheathe weapons (ActorRef.SheatheWeapon() is broken in SKSEVR)
Function VrikPlayerDrawSheathe(Bool weaponDrawn) native global

; Returns the spell type: 0=Spell, 1=Disease, 2=Power, 3=LesserPower, 4=Ability, 5=Poison, 6=Addition, 7=Voice
Int Function VrikGetSpellType(Spell spell) native global

; Detects the spell casting type: 1=Fire and Forget, 2=Concentration
Int Function VrikGetSpellCastType(Spell spell) native global

; Determines if a spell auto-calculates its magicka costs
Bool Function VrikGetSpellAutoCalc(Spell spell) native global

; Get the number of shouts an actor has
Int Function VrikGetShoutCount(Actor actor) native global
Shout Function VrikGetNthShout(Actor actor, Int index) native global

; Determine the type of controller in use (Rift=0, Vive=1, WindowsMR=2, Index=3)
Int Function VrikGetControllerType()  native global

; Get X and Y position of thumbsticks (or Vive trackpads)
Float Function VrikGetAxisX(Bool onLeft) native global
Float Function VrikGetAxisY(Bool onLeft) native global

; Determine if any input is being touched
Bool Function VrikIsGripTouched(Bool onLeft) native global
Bool Function VrikIsTriggerTouched(Bool onLeft) native global
Bool Function VrikIsThumbstickTouched(Bool onLeft) native global ; Also Vive's trackpad
Bool Function VrikIsButtonATouched(Bool onLeft) native global    ; Also Vive's Menu button
Bool Function VrikIsButtonBTouched(Bool onLeft) native global
Bool Function VrikIsTouchpadTouched(Bool onLeft) native global
Bool Function VrikIsAnyButtonTouched(Bool onLeft) native global

; Determine how many times an input has been touched in a row (double touch / triple touch, etc)
Int Function VrikGripTouchCount(Bool onLeft) native global
Int Function VrikTriggerTouchCount(Bool onLeft) native global
Int Function VrikThumbstickTouchCount(Bool onLeft) native global ; Also Vive's trackpad
Int Function VrikButtonATouchCount(Bool onLeft) native global    ; Also Vive's Menu button
Int Function VrikButtonBTouchCount(Bool onLeft) native global
Int Function VrikTouchpadTouchCount(Bool onLeft) native global

; Determine how long an input has been touched for in seconds
float Function VrikGripTouchDuration(Bool onLeft) native global
float Function VrikTriggerTouchDuration(Bool onLeft) native global
float Function VrikThumbstickTouchDuration(Bool onLeft) native global ; Also Vive's trackpad
float Function VrikButtonATouchDuration(Bool onLeft) native global    ; Also Vive's Menu button
float Function VrikButtonBTouchDuration(Bool onLeft) native global
float Function VrikTouchpadTouchDuration(Bool onLeft) native global

; Determine if any input is being pressed
Bool Function VrikIsGripPressed(Bool onLeft) native global
Bool Function VrikIsTriggerPressed(Bool onLeft) native global
Bool Function VrikIsThumbstickPressed(Bool onLeft) native global ; Also Vive's trackpad
Bool Function VrikIsButtonAPressed(Bool onLeft) native global    ; Also Vive's Menu button
Bool Function VrikIsButtonBPressed(Bool onLeft) native global
Bool Function VrikIsTouchpadPressed(Bool onLeft) native global

; Determine how many times an input has been pressed in a row (double press / triple press, etc)
Int Function VrikGripPressCount(Bool onLeft) native global
Int Function VrikTriggerPressCount(Bool onLeft) native global
Int Function VrikThumbstickPressCount(Bool onLeft) native global ; Also Vive's trackpad
Int Function VrikButtonAPressCount(Bool onLeft) native global    ; Also Vive's Menu button
Int Function VrikButtonBPressCount(Bool onLeft) native global
Int Function VrikTouchpadPressCount(Bool onLeft) native global

; Determine how long an input has been pressed for in seconds
float Function VrikGripPressDuration(Bool onLeft) native global
float Function VrikTriggerPressDuration(Bool onLeft) native global
float Function VrikThumbstickPressDuration(Bool onLeft) native global ; Also Vive's trackpad
float Function VrikButtonAPressDuration(Bool onLeft) native global    ; Also Vive's Menu button
float Function VrikButtonBPressDuration(Bool onLeft) native global
float Function VrikTouchpadPressDuration(Bool onLeft) native global

; Get world-space coordinates for hands and HMD
Float Function VrikGetHandX(Bool onLeft) native global
Float Function VrikGetHandY(Bool onLeft) native global
Float Function VrikGetHandZ(Bool onLeft) native global
Float Function VrikGetHmdX() native global
Float Function VrikGetHmdY() native global
Float Function VrikGetHmdZ() native global

; Creates haptic pulses on a controller
Function VrikHapticPulse(Bool onLeftHand, Int frames, Int microsec) native global

; Writes text to the vrik.log file
Function VrikLog(String text) native global

;	███    ███  ██████  ██████      ███████ ███████ ████████ ████████ ██ ███    ██  ██████  ███████
;	████  ████ ██    ██ ██   ██     ██      ██         ██       ██    ██ ████   ██ ██       ██
;	██ ████ ██ ██    ██ ██   ██     ███████ █████      ██       ██    ██ ██ ██  ██ ██   ███ ███████
;	██  ██  ██ ██    ██ ██   ██          ██ ██         ██       ██    ██ ██  ██ ██ ██    ██      ██
;	██      ██  ██████  ██████      ███████ ███████    ██       ██    ██ ██   ████  ██████  ███████

; ___________________________________________________________________________________________________________________________
;
;   VRIK includes several special settings that are not saved to its INI files.  Mods can change both the normal INI settings
; as well as these special settings to alter VRIK's behavior.  Use the following function to alter a setting:
;		VRIK.VrikSetSetting("settingName", valueToSet)
;
;	All changes will take immediate effect in-game.  Changes made to VRIK settings are not saved to the INI file unless a
; call to VRIK.VrikSaveSettings() is made **WITH THE EXCEPTION OF "recalibrateMode" (see below)**.  Once your mod has
; finished its task, undo all changes that were made to all settings as follows:
;		VRIK.VrikRestoreSettings()
; ___________________________________________________________________________________________________________________________
;
; The full list of mod-support settings is as follows:
;	nearClipDistance  (Defaults to Skyrim's INI setting)
;		VRIK controls Skyrim's own fNearDistance:Display INI setting, turning it down automatically when the player looks
;		down at their body.  If your mod also needs to asjust this, set this VRIK setting so that VRIK knows not to turn the
;		near clipping plane distance back above the value you wish to set.
;
;	enableLeftArm  (default 1)
;		Set to 1 to enable VRIK's control of the left arm AND hand.  Set to 0 to disable (both will follow animation).
;
;	enableRightArm  (default 1)
;		Set to 1 to enable VRIK's control of the right arm AND hand.  Set to 0 to disable (both will follow animation).
;
;	enableLeftHand  (default 1)
;		Set to 1 to enable VRIK's control of the left hand.  Set to 0 to disable (hand will follow animation).
;
;	enableRightHand  (default 1)
;		Set to 1 to enable VRIK's control of the right hand.  Set to 0 to disable (hand will follow animation).
;
;	enablePosture  (default 1)
;		Set to 1 to enable VRIK's body posture correction system.  Set to 0 to disable (posture follows animation).
;
;	enableBody  (default 1)
;		Set to 1 to enable VRIK's body bending/leaning/crouching system.  Set to 0 to disable (body follows animation).
;
;	enableHead  (default 1)
;		Set to 1 to enable VRIK's head positioning system.  Set to 0 to disable (head follows animation).
;
;	enableInteractiveHands  (default 0)
;		Set to 1,2,3,4, 5, or 6 to enable interactive hand mode.  Set to 0 to disable.
;		Hands and fingers will automatically move to the animation position when hovering or pressing triggers
;			0   Disable Interactive Hands
;			1   Interactive on Hover
;			2   Interactive on Hover / Trigger (Toggle)
;			3   Interactive on Hover / Trigger (Hold)
;			4   Interactive on Trigger (Toggle)
;			5   Interactive on Trigger (Hold)
;			6   Interactive Inverted Trigger (Hold)
;
;	enableJumping  (default 1)
;		Set to 1 to enable jumping.  Set to 0 to have VRIK disallow jumping, which can halt idle animations.
;
;	displayHolsters  (default 1)
;		Set to 1 to enable display of VRIK's holsters.  Set to 0 to hide them.
;		Note: There is also an enableHolsters setting in vrikslots.ini, but that fully disables the system and unequips them.
;
;	lockRotation  (default 0)
;		Set to 1 to lock the player's rotation to prevent the body from turning.
;		This setting works in conjunction with lockRotationAngle.  If the lockRotationAngle setting is at it's default value
;		of -1, then lockRotation will lock the body rotation to the current direction the player is facing.  Othewrise,
;		the body rotation will be locked to the 0-360 degree angle specified in lockRotationAngle.
;		Note: This does NOT prevent the body from twisting in-place (enableBody does that).
;
;	lockRotationAngle  (default -1)
;		This setting is only considered when lockRotation is 1.
;		Set it to -1 to lock rotation to the the body's current angle, or to a 0-360 degree body facing angle.
;
;	lockPosition  (default 0)
;		Set to 1 to lock the player body position to it's current location.  Set to 2 to lock the body position to a
;		coordinate given by the <lockPositionX, lockPositionY, lockPositionZ> settings.  Set to 0 to disable.  When the
;		headset is locked with lockHmdToBody, the headset will move toward the body located here.  When the headset is not
;		locked, the body will remain in place even if the player moves away from it.
;
;	lockPositionX, lockPositionY, lockPositionZ  (default 0)
;		These define a coordinate where the player body will be positioned when the lockPosition setting is set to 2.
;
;	lockHeightToBody  (default 0)
;		Set to 1 to lock the headset height to the player's shoulder height.  Set to 0 to allow it to move freely.
;
;	lockHmdToBody  (default 0)
;		Set to 1 to lock the headset position to the player's head, pushing the headset towards it as needed.  If needed,
;		set it to 2 afterwards to unlock the HMD while maintaining the positional change.  Set to 0 to disable.
;		Note: This setting works in conjunction with lockHmdMinThreshold, lockHmdMaxThreshold, and lockHmdSpeed.
;
; lockHmdMinThreshold  (default 10)
;		This setting is only considered when lockHmdToBody is 1.
;		Once the headset position begins to move, it will continue moving until within this distance to the body's head.
;
; lockHmdMaxThreshold  (default 10)
;		This setting is only considered when lockHmdToBody is 1.
;		After the headset exceeds this distance, it will begin to move towards the body's head when lockHmdToBody is set.
;
; lockHmdSpeed  (defautl 100)
;		This setting is only considered when lockHmdToBody is 1.
;		The headset position is moved at this many units of distance per second with lockHmdToBody
;
; rotateHmdToBodySeconds  (default 0)
;		Some static animations rotate the player's body away from the normal player facing direction.  This setting can be
;		set to a number of seconds to monitor for this types of rotation, and apply it automatically to the headset rotation.
;		For example, if this setting is set to 2 seconds and an animation rotates body's skeleton a second later, the headset
;		will automatically rotate along with it.  This uses the rotational difference between the NPC and NPC Com bones.
;		Always use VRIK.VrikRestoreSettings() to clear the rotation when the animation completes
;
; disableVrik  (default 0)
;		Set to 1 to disable all VRIK systems except for body visibility.  Set to 0 to behave normally.
;		This setting is primarily useful for debugging purposes, to understand how VRIK works, and what an input animation
;		that VRIK adjusts looks like normally.  It essentially turns VRIK off with only body still being visible.
;
; recalibrateMode  (default 0)
;		Set this setting to 1,2,3,4, or 5 to recalibrate the player.  It is set back to 0 automatically.
;		Note:  **ALL PENDING CHANGES ALE SAVED TO THE INI**  This is the setting used by VRIK's own calibration menu.
;			1	Calibrate player height
;			2	Return to default body size
;			3	Adjust body size shorter
;			4	Adjust body size taller
;			5	Calibrate VR Scale and player height
; ___________________________________________________________________________________________________________________________
;
; EXAMPLE:  Make sure that the player's head will be displayed for a limited time (users may configure it to remain hidden):
;
; 		VRIK.VrikSetSetting("hidePlayerHeadDistance", 1.0)   ; This is a normal INI setting
; 		Utility.Wait(10)                                     ; Head is definitely displayed for 10 seconds
; 		VRIK.VrikRestoreSettings()                           ; When done, revert VRIK back to the player's chosen settings
;
; ___________________________________________________________________________________________________________________________
