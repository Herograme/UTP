--[[
	TweenSequence Editor Animator
	Created by pa00

	Initialize by requiring this module:
		animator = require(instance.Animator)

	Play the tween named TrackName:
		animator.TrackName:Play()

	Stop the tween named TrackName:
		animator.TrackName:Stop()

	Loop the tween named TrackName twice:
		animator.TrackName:Loop(2)

	Loop the tween named TrackName indefinitely until stopped:
		animator.TrackName:Loop()
	
	Set the origin of a track named TrackName:
		animator.TrackName:SetOrigin(origin)

	Connect a function named doneFunc to the end of the tween named TrackName:
		animator.TrackName.Completed:Connect(doneFunc)
		
	Set the origin of all tracks:
		animator:SetOrigin(origin)

	Stop all tracks for this instance (either version):
		animator.StopAll()
		animator:StopAll()
]]

local CollectionService = game:GetService("CollectionService")
local TweenSequenceUtils = CollectionService:GetTagged("Instance(TweenSequenceUtils)")[1]
local Animator = require(TweenSequenceUtils.Animator)

local tweens = script:WaitForChild("Tweens")
local root = script.Parent
return Animator.new(tweens, root)
