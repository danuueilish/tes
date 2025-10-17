-- ⚡ Luck Scanner GUI (Auto Visible Version for CloudEmulator / Mobile)
local player = game:GetService("Players").LocalPlayer
local coreGui = game:GetService("CoreGui")
local playerGui = player:FindFirstChildOfClass("PlayerGui")

-- fungsi aman pasang GUI
local function safeParent(gui)
    if playerGui then
        gui.Parent = playerGui
    else
        gui.Parent = coreGui
    end
end

-- hapus GUI lama kalau ada
for _, gui in pairs({coreGui:FindFirstChild("LuckScannerUI"), playerGui and playerGui:FindFirstChild("LuckScannerUI")}) do
    if gui then gui:Destroy() end
end

-- buat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuckScannerUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
safeParent(ScreenGui)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 240)
Frame.Position = UDim2.new(0.5, -160, 0.5, -120)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "🎯 Server Luck Scanner"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1, -10, 1, -70)
Scrolling.Position = UDim2.new(0, 5, 0, 32)
Scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
Scrolling.ScrollBarThickness = 6
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

-- fungsi scan GUI
local function printDescendants(obj, indent)
	local prefix = string.rep("  ", indent or 0)
	for _, v in ipairs(obj:GetChildren()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
			local txt = v.Text or ""
			if txt and txt:lower():find("luck") then
				TextBox.Text = TextBox.Text .. prefix .. v:GetFullName() .. " = " .. txt .. "\n"
				Scrolling.CanvasSize = UDim2.new(0, 0, 0, TextBox.TextBounds.Y + 20)
			end
		end
		printDescendants(v, (indent or 0) + 1)
	end
end

-- jalankan scanning
task.spawn(function()
	TextBox.Text = "🔎 Searching for 'Luck' texts...\n"
	task.wait(1)
	local all = playerGui and playerGui:GetChildren() or coreGui:GetChildren()
	for _, gui in ipairs(all) do
		printDescendants(gui, 0)
	end
	TextBox.Text = TextBox.Text .. "\n✅ Done."
	Scrolling.CanvasSize = UDim2.new(0, 0, 0, TextBox.TextBounds.Y + 20)
end)

-- tombol copy
CopyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(TextBox.Text)
	elseif toclipboard then
		toclipboard(TextBox.Text)
	else
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Clipboard not supported";
			Text = "Your executor doesn't support setclipboard.";
			Duration = 3
		})
		return
	end
	CopyButton.Text = "✅ Copied!"
	task.delay(1.5, function()
		CopyButton.Text = "📋 Copy All"
	end)
end)
