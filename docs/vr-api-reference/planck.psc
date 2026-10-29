ScriptName planck hidden

;-- Functions ---------------------------------------

Function AddAggressionIgnoredActor(Actor actor) Global Native

Function AddIgnoredActor(Actor actor) Global Native

Function AddRagdollCollisionIgnoredActor(Actor actor) Global Native

String Function GetLastHitNodeName() Global Native

Float Function GetSetting(String settingName) Global Native

; Skipped compiler generated GetState

; Skipped compiler generated GotoState

Function RemoveAggressionIgnoredActor(Actor actor) Global Native

Function RemoveIgnoredActor(Actor actor) Global Native

Function RemoveRagdollCollisionIgnoredActor(Actor actor) Global Native

Function SetAggressionHighTopic(Actor actor, Topic topic) Global Native

Function SetAggressionLowTopic(Actor actor, Topic topic) Global Native

Bool Function SetSetting(String settingName, Float value) Global Native

Event onBeginState()
{ Event received when this state is switched to }
  ; Empty function
EndEvent

Event onEndState()
{ Event received when this state is switched away from }
  ; Empty function
EndEvent
