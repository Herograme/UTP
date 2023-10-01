--local SizeInit = script.Parent.Parent.Parent.Size



return {
	["Frame1"] = {
		Rotation = {
			InitialValue = 0,
			Keyframes = {
				{
					Value = -90,
					EasingStyle = Enum.EasingStyle.Linear,
					Time = 0.5,
					EasingDirection = Enum.EasingDirection.Out,
				},
			},
		},
		Size = {
			InitialValue = UDim2.new(0.15855197608470917, 0, 0.09642698615789413, 0),
			Keyframes = {
				{
					Value = UDim2.new(0.23800000548362732, 0, 0.14499999582767487, 0),
					EasingStyle = Enum.EasingStyle.Linear,
					Time = 0.5,
					EasingDirection = Enum.EasingDirection.Out,
				},
			},
		},
		Position = {
			InitialValue = UDim2.new(0.03687666356563568, 0, 0.9028764367103577, 0),
			Keyframes = {
				{
					Value = UDim2.new(0.20600000023841858, 0, 0.4659999907016754, 0),
					EasingStyle = Enum.EasingStyle.Linear,
					Time = 0.5,
					EasingDirection = Enum.EasingDirection.Out,
				},
			},
		},
	},
}
