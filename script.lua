-- LocalScript
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local activeBrainrots = workspace:WaitForChild("ActiveBrainrots")

-- ================= SCREEN GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotsUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- ================= DRAG FUNCTION =================
local function makeDraggable(obj)
	local dragging, dragStart, startPos
	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = obj.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			obj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ================= MAIN FRAME =================
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mainFrame.Active = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,14)
makeDraggable(mainFrame)

-- ================= OPEN BUTTON =================
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,110,0,34)
openBtn.Position = UDim2.new(0,20,0.5,-17)
openBtn.Text = "Open Menu"
openBtn.TextSize = 14
openBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Visible = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,12)
makeDraggable(openBtn)

-- ================= CLOSE BUTTON =================
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-34,0,6)
closeBtn.Text = "✕"
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

-- ================= SIDEBAR =================
local sideBar = Instance.new("ScrollingFrame", mainFrame)
sideBar.Size = UDim2.new(0,130,1,-12)
sideBar.Position = UDim2.new(0,6,0,6)
sideBar.CanvasSize = UDim2.new(0,0,0,0)
sideBar.ScrollBarImageTransparency = 0.4
sideBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", sideBar).CornerRadius = UDim.new(0,12)

local sideLayout = Instance.new("UIListLayout", sideBar)
sideLayout.Padding = UDim.new(0,6)

-- ================= CONTENT PANEL =================
local content = Instance.new("ScrollingFrame", mainFrame)
content.Size = UDim2.new(0,340,1,-24)
content.Position = UDim2.new(0,140,0,12)
content.CanvasSize = UDim2.new(0,0,0,0)
content.ScrollBarImageTransparency = 0.4
content.BackgroundColor3 = Color3.fromRGB(26,26,26)
content.Visible = false
Instance.new("UICorner", content).CornerRadius = UDim.new(0,12)

local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0,6)

-- ================= UTIL =================
local function clearContent()
	for _,v in ipairs(content:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

-- ================= SHOW MODELS =================
local function showModels(folder)
	clearContent()

	for _,model in ipairs(folder:GetChildren()) do
		if model:IsA("Model") then
			local btn = Instance.new("TextButton", content)
			btn.Size = UDim2.new(1,-12,0,32)
			btn.Text = model.Name
			btn.TextSize = 13
			btn.BackgroundColor3 = Color3.fromRGB(44,44,44)
			btn.TextColor3 = Color3.new(1,1,1)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
		end
	end

	task.wait()
	content.CanvasSize = UDim2.new(0,0,0,contentLayout.AbsoluteContentSize.Y+8)

	content.Visible = true
	content.Size = UDim2.new(0,0,1,-24)

	TweenService:Create(
		content,
		TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ Size = UDim2.new(0,340,1,-24) }
	):Play()
end

-- ================= CATEGORY BUTTONS =================
for _,folder in ipairs(activeBrainrots:GetChildren()) do
	if folder:IsA("Folder") then
		local btn = Instance.new("TextButton", sideBar)
		btn.Size = UDim2.new(1,-10,0,32)
		btn.Text = folder.Name
		btn.TextSize = 13
		btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
		btn.TextColor3 = Color3.new(1,1,1)
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

		btn.MouseButton1Click:Connect(function()
			showModels(folder)
		end)
	end
end

task.wait()
sideBar.CanvasSize = UDim2.new(0,0,0,sideLayout.AbsoluteContentSize.Y+10)

-- ================= OPEN / CLOSE ANIMATIONS =================
local openTween = TweenService:Create(
	mainFrame,
	TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
	{ Size = UDim2.new(0,500,0,300) }
)

local closeTween = TweenService:Create(
	mainFrame,
	TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
	{ Size = UDim2.new(0,0,0,0) }
)

closeBtn.MouseButton1Click:Connect(function()
	closeTween:Play()
	closeTween.Completed:Wait()
	mainFrame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	mainFrame.Size = UDim2.new(0,0,0,0)
	openTween:Play()
	openBtn.Visible = false
end)
