--// iOS Ultra FPS Panel
--// Safe + Aggressive Optimization
--// LocalScript - StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

--// ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "iOS_FPS_PANEL"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Background dim
local dim = Instance.new("Frame")
dim.Size = UDim2.fromScale(1,1)
dim.BackgroundColor3 = Color3.new(0,0,0)
dim.BackgroundTransparency = 0.4
dim.Parent = gui

--// Main Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.fromScale(0.24, 0.56)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(20,20,20)
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0,32)

local stroke = Instance.new("UIStroke", panel)
stroke.Thickness = 1
stroke.Transparency = 0.8

--// Header (drag only here)
local header = Instance.new("Frame")
header.Size = UDim2.fromScale(1,0.13)
header.BackgroundTransparency = 1
header.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "FPS BOOST"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.Parent = header

--// Close
local close = Instance.new("TextButton")
close.Size = UDim2.fromScale(0.12,0.6)
close.Position = UDim2.fromScale(0.9,0.2)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.BackgroundColor3 = Color3.fromRGB(40,40,40)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = header
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

--// Buttons area
local body = Instance.new("Frame")
body.Size = UDim2.fromScale(1,0.82)
body.Position = UDim2.fromScale(0,0.16)
body.BackgroundTransparency = 1
body.Parent = panel

local layout = Instance.new("UIListLayout", body)
layout.Padding = UDim.new(0,14)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--// Button creator
local function button(text)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromScale(0.85,0.13)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(28,28,28)
	b.Parent = body
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,22)

	b.MouseButton1Down:Connect(function()
		TweenService:Create(
			b,
			TweenInfo.new(0.1),
			{Size = UDim2.fromScale(0.8,0.12)}
		):Play()
	end)

	b.MouseButton1Up:Connect(function()
		TweenService:Create(
			b,
			TweenInfo.new(0.1),
			{Size = UDim2.fromScale(0.85,0.13)}
		):Play()
	end)

	return b
end

local boost = button("ULTRA FPS BOOST")
local textures = button("REMOVE HEAVY TEXTURES")
local lighting = button("LIGHTING LOW")

--// Open animation
panel.Size = UDim2.fromScale(0,0)
TweenService:Create(
	panel,
	TweenInfo.new(0.5, Enum.EasingStyle.Quint),
	{Size = UDim2.fromScale(0.24,0.56)}
):Play()

--// Close destroy
close.MouseButton1Click:Connect(function()
	TweenService:Create(panel,TweenInfo.new(0.25),{Size=UDim2.fromScale(0,0)}):Play()
	task.wait(0.25)
	gui:Destroy()
end)

--// Drag header only
do
	local drag, start, pos
	header.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			start = i.Position
			pos = panel.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - start
			panel.Position = UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = false
		end
	end)
end

--// ULTRA FPS BOOST
boost.MouseButton1Click:Connect(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	Lighting.GlobalShadows = false
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = Enum.Material.Plastic
		end
	end
end)

--// REMOVE HEAVY TEXTURES
textures.MouseButton1Click:Connect(function()
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
			v:Destroy()
		end
	end
end)

--// LIGHTING LOW
lighting.MouseButton1Click:Connect(function()
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	for _,v in ipairs(Lighting:GetChildren()) do
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
	end
end)
