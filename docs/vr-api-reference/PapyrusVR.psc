ScriptName PapyrusVR hidden

;-- Properties --------------------------------------
Int Property EDeviceTypeHMD = 0 AutoReadOnly
Int Property EDeviceTypeLeftController = 2 AutoReadOnly
Int Property EDeviceTypeNone = -1 AutoReadOnly
Int Property EDeviceTypeRightController = 1 AutoReadOnly
Int Property Entered = 1 AutoReadOnly
Int Property Exited = 2 AutoReadOnly
Int Property Pressed = 2 AutoReadOnly
Int Property Released = 3 AutoReadOnly
Int Property Touched = 0 AutoReadOnly
Int Property Untouched = 1 AutoReadOnly
Int Property k_EButton_A = 7 AutoReadOnly
Int Property k_EButton_ApplicationMenu = 1 AutoReadOnly
Int Property k_EButton_Axis0 = 32 AutoReadOnly
Int Property k_EButton_Axis1 = 33 AutoReadOnly
Int Property k_EButton_Axis2 = 34 AutoReadOnly
Int Property k_EButton_Axis3 = 35 AutoReadOnly
Int Property k_EButton_Axis4 = 36 AutoReadOnly
Int Property k_EButton_DPad_Down = 6 AutoReadOnly
Int Property k_EButton_DPad_Left = 3 AutoReadOnly
Int Property k_EButton_DPad_Right = 5 AutoReadOnly
Int Property k_EButton_DPad_Up = 4 AutoReadOnly
Int Property k_EButton_Dashboard_Back = 2 AutoReadOnly
Int Property k_EButton_Grip = 2 AutoReadOnly
Int Property k_EButton_Max = 64 AutoReadOnly
Int Property k_EButton_ProximitySensor = 31 AutoReadOnly
Int Property k_EButton_SteamVR_Touchpad = 32 AutoReadOnly
Int Property k_EButton_SteamVR_Trigger = 33 AutoReadOnly
Int Property k_EButton_System = 0 AutoReadOnly

;-- Functions ---------------------------------------

Function DestroyLocalOverlapObject(Int objectHandle) Global Native

Function GetSkyrimDevicePosition_Native(Int DeviceType, Float[] returnValues) Global Native

Function GetSkyrimDeviceQRotation_Native(Int DeviceType, Float[] returnValues) Global Native

Function GetSkyrimDeviceRotation_Native(Int DeviceType, Float[] returnValues) Global Native

; Skipped compiler generated GetState

Function GetSteamVRDevicePosition_Native(Int DeviceType, Float[] returnValues) Global Native

Function GetSteamVRDeviceQRotation_Native(Int DeviceType, Float[] returnValues) Global Native

Function GetSteamVRDeviceRotation_Native(Int DeviceType, Float[] returnValues) Global Native

; Skipped compiler generated GotoState

Function OnVRButtonEvent(Int eventType, Int buttonId, Int deviceId)
  ; Empty function
EndFunction

Function OnVROverlapEvent(Int overlapEventType, Int objectHandle, Int deviceId)
  ; Empty function
EndFunction

Function RegisterForPoseUpdates(Form form) Global Native

Function RegisterForVRButtonEvents(Form form) Global Native

Function RegisterForVROverlapEvents(Form form) Global Native

Int Function RegisterLocalOverlapSphere(Float radius, Float[] position, Float[] rotation, Int DeviceType) Global Native

Function TimeSinceLastCall() Global Native

Function UnregisterForPoseUpdates(Form form) Global Native

Function UnregisterForVRButtonEvents(Form form) Global Native

Function UnregisterForVROverlapEvents(Form form) Global Native

Event onBeginState()
{ Event received when this state is switched to }
  ; Empty function
EndEvent

Event onEndState()
{ Event received when this state is switched away from }
  ; Empty function
EndEvent

Float[] Function GetSteamVRDeviceRotation(Int DeviceType) Global
  Float[] returnValues = new Float[3] ; #DEBUG_LINE_NO:83
  PapyrusVR.GetSteamVRDeviceRotation_Native(DeviceType, returnValues) ; #DEBUG_LINE_NO:84
  Return returnValues ; #DEBUG_LINE_NO:85
EndFunction

Float[] Function GetSteamVRDeviceQRotation(Int DeviceType) Global
  Float[] returnValues = new Float[4] ; #DEBUG_LINE_NO:89
  PapyrusVR.GetSteamVRDeviceQRotation_Native(DeviceType, returnValues) ; #DEBUG_LINE_NO:90
  Return returnValues ; #DEBUG_LINE_NO:91
EndFunction

Float[] Function GetSteamVRDevicePosition(Int DeviceType) Global
  Float[] returnValues = new Float[3] ; #DEBUG_LINE_NO:95
  PapyrusVR.GetSteamVRDevicePosition_Native(DeviceType, returnValues) ; #DEBUG_LINE_NO:96
  Return returnValues ; #DEBUG_LINE_NO:97
EndFunction

Float[] Function GetSkyrimDeviceRotation(Int DeviceType) Global
  Float[] returnValues = new Float[3] ; #DEBUG_LINE_NO:101
  PapyrusVR.GetSkyrimDeviceRotation_Native(DeviceType, returnValues) ; #DEBUG_LINE_NO:102
  Return returnValues ; #DEBUG_LINE_NO:103
EndFunction

Float[] Function GetSkyrimDeviceQRotation(Int DeviceType) Global
  Float[] returnValues = new Float[4] ; #DEBUG_LINE_NO:107
  PapyrusVR.GetSkyrimDeviceQRotation_Native(DeviceType, returnValues) ; #DEBUG_LINE_NO:108
  Return returnValues ; #DEBUG_LINE_NO:109
EndFunction

Float[] Function GetSkyrimDevicePosition(Int DeviceType) Global
  Float[] returnValues = new Float[3] ; #DEBUG_LINE_NO:113
  PapyrusVR.GetSkyrimDevicePosition_Native(DeviceType, returnValues) ; #DEBUG_LINE_NO:114
  Return returnValues ; #DEBUG_LINE_NO:115
EndFunction

Float[] Function Vector3(Float X, Float Y, Float Z) Global
  Float[] vector = new Float[3] ; #DEBUG_LINE_NO:120
  vector[0] = X ; #DEBUG_LINE_NO:121
  vector[1] = Y ; #DEBUG_LINE_NO:122
  vector[2] = Z ; #DEBUG_LINE_NO:123
  Return vector ; #DEBUG_LINE_NO:124
EndFunction

Float[] Function Vector3_Zero() Global
  Return PapyrusVR.Vector3(0 as Float, 0 as Float, 0 as Float) ; #DEBUG_LINE_NO:128
EndFunction

Float[] Function Quaternion(Float X, Float Y, Float Z, Float W) Global
  Float[] vector = new Float[4] ; #DEBUG_LINE_NO:132
  vector[0] = X ; #DEBUG_LINE_NO:133
  vector[1] = Y ; #DEBUG_LINE_NO:134
  vector[2] = Z ; #DEBUG_LINE_NO:135
  vector[3] = W ; #DEBUG_LINE_NO:136
  Return vector ; #DEBUG_LINE_NO:137
EndFunction

Float[] Function Quaternion_Zero() Global
  Return PapyrusVR.Quaternion(0 as Float, 0 as Float, 0 as Float, 0 as Float) ; #DEBUG_LINE_NO:141
EndFunction
