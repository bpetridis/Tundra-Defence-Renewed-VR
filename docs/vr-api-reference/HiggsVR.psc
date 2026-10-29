ScriptName HiggsVR hidden

;-- Functions ---------------------------------------

Bool Function CanGrabObject(Bool isLeft) Global Native

Function DisableHand(Bool isLeft) Global Native

Function DisableWeaponCollision(Bool isLeft) Global Native

Function EnableHand(Bool isLeft) Global Native

Function EnableWeaponCollision(Bool isLeft) Global Native

String Function GetGrabbedNodeName(Bool isLeft) Global Native

ObjectReference Function GetGrabbedObject(Bool isLeft) Global Native

Float Function GetSetting(String settingName) Global Native

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Function GrabObject(ObjectReference object, Bool isLeft) Global Native

Bool Function IsDisabled(Bool isLeft) Global Native

Bool Function IsTwoHanding() Global Native

Bool Function IsWeaponCollisionDisabled(Bool isLeft) Global Native

Function OnObjectConsumed(Form baseForm, Bool isLeft)
  ; Empty function
EndFunction

Function OnObjectDropped(ObjectReference refr, Bool isLeft)
  ; Empty function
EndFunction

Function OnObjectGrabbed(ObjectReference refr, Bool isLeft)
  ; Empty function
EndFunction

Function OnObjectPulled(ObjectReference refr, Bool isLeft)
  ; Empty function
EndFunction

Function OnObjectStashed(Form baseForm, Bool isLeft)
  ; Empty function
EndFunction

Function OnStartTwoHanding()
  ; Empty function
EndFunction

Function OnStopTwoHanding()
  ; Empty function
EndFunction

Function RegisterForConsumeEvent(Form form) Global Native

Function RegisterForDropEvent(Form form) Global Native

Function RegisterForGrabEvent(Form form) Global Native

Function RegisterForPullEvent(Form form) Global Native

Function RegisterForStartTwoHandingEvent(Form form) Global Native

Function RegisterForStashEvent(Form form) Global Native

Function RegisterForStopTwoHandingEvent(Form form) Global Native

Bool Function SetSetting(String settingName, Float value) Global Native

Function UnregisterForConsumeEvent(Form form) Global Native

Function UnregisterForDropEvent(Form form) Global Native

Function UnregisterForGrabEvent(Form form) Global Native

Function UnregisterForPullEvent(Form form) Global Native

Function UnregisterForStartTwoHandingEvent(Form form) Global Native

Function UnregisterForStashEvent(Form form) Global Native

Function UnregisterForStopTwoHandingEvent(Form form) Global Native

Event onBeginState()
{ Event received when this state is switched to }
  ; Empty function
EndEvent

Event onEndState()
{ Event received when this state is switched away from }
  ; Empty function
EndEvent
