local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuckScannerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 300)
Frame.Position = UDim2.new(0.5, -210, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "Server Luck Scanner"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1, -10, 1, -70)
Scrolling.Position = UDim2.new(0, 5, 0, 35)
Scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
Scrolling.ScrollBarThickness = 8
Scrolling.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Scrolling.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.MultiLine = true
TextBox.ClearTextOnFocus = false
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.Size = UDim2.new(1, -10, 1, -10)
TextBox.Position = UDim2.new(0, 5, 0, 5)
TextBox.BackgroundTransparency = 1
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(200, 255, 200)
TextBox.TextSize = 14
TextBox.Font = Enum.Font.Code
TextBox.Parent = Scrolling

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, -10, 0, 30)
CopyButton.Position = UDim2.new(0, 5, 1, -35)
CopyButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
CopyButton.Text = "📋 Copy All"
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.TextSize = 16
CopyButton.Parent = Frame

local function printDescendants(obj, indent)
	local prefix = string.rep("  ", indent or 0)
	for _, v in ipairs(obj:GetChildren()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			local txt = v.Text or ""
			if txt and txt:lower():find("luck") then
				TextBox.Text = TextBox.Text .. prefix .. v:GetFullName() .. " = " .. txt .. "\n"
				Scrolling.CanvasSize = UDim2.new(0, 0, 0, TextBox.TextBounds.Y + 20)
			end
		end
		printDescendants(v, (indent or 0) + 1)
	end
end

task.spawn(function()
	TextBox.Text = "=== Searching for 'Luck' labels in GUI ===\n"
	for _, gui in ipairs(player:WaitForChild("PlayerGui"):GetChildren()) do
		printDescendants(gui, 0)
	end
	TextBox.Text = TextBox.Text .. "=== Done ==="
	Scrolling.CanvasSize = UDim2.new(0, 0, 0, TextBox.TextBounds.Y + 20)
end)

CopyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(TextBox.Text)
	elseif toclipboard then
		toclipboard(TextBox.Text)
	end
	CopyButton.Text = "✅ Copied!"
	task.delay(1.5, function()
		CopyButton.Text = "📋 Copy All"
	end)
end)
