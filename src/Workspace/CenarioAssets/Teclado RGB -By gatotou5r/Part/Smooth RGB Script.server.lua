function funktio()
	for h=0,1,0.003 do
		wait()
		local rgb = Color3.fromHSV(h,1,1)
		script.Parent.Color = rgb
	end funktio()
end

funktio()