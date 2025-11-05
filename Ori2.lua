-- OrionLib v2.0

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local OrionLib = {
	Elements = {},
	ThemeObjects = {},
	Connections = {},
	Flags = {},
	Themes = {
		Default = {
			Main = Color3.fromRGB(18, 18, 22),
			Second = Color3.fromRGB(28, 28, 34),
			Accent = Color3.fromRGB(0, 170, 255),
			Stroke = Color3.fromRGB(50, 50, 60),
			Divider = Color3.fromRGB(45, 45, 55),
			Text = Color3.fromRGB(240, 240, 240),
			TextDark = Color3.fromRGB(160, 160, 170)
		}
	},
	SelectedTheme = "Default",
	Folder = "OrionConfig",
	SaveCfg = true,
	ScreenGui = nil,
	Scale = 1
}


local Icons = {
	diamond = "◆", star = "★", check = "✓", x = "✖", settings = "⚙", home = "🏠",
	user = "👤", search = "🔍", bell = "🔔", lock = "🔒", unlock = "🔓", trash = "🗑",
	plus = "➕", minus = "➖", arrow = "➤", down = "▼", up = "▲", left = "◄", right = "►"
}

local function GetIcon(name) return Icons[name] or "" end


local function CreateGUI()
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "OrionLib"
	ScreenGui.ResetOnSpawn = false
	if syn then syn.protect_gui(ScreenGui) end
	ScreenGui.Parent = game.CoreGui


	local function UpdateScale()
		local screenSize = workspace.CurrentCamera.ViewportSize
		OrionLib.Scale = math.clamp(screenSize.X / 1920, 0.7, 1.2)
		ScreenGui.DisplayOrder = 999
	end
	UpdateScale()
	RunService.Heartbeat:Connect(UpdateScale)

	OrionLib.ScreenGui = ScreenGui
	return ScreenGui
end

local Orion = CreateGUI()


for _, gui in ipairs(game.CoreGui:GetChildren()) do
	if gui.Name == "OrionLib" and gui ~= Orion then
		gui:Destroy()
	end
end


local function AddConnection(signal, func)
	local conn = signal:Connect(func)
	table.insert(OrionLib.Connections, conn)
	return conn
end

task.spawn(function()
	while Orion.Parent do task.wait() end
	for _, conn in ipairs(OrionLib.Connections) do
		conn:Disconnect()
	end
end)


local function Create(name, props, children)
	local obj = Instance.new(name)
	for k, v in pairs(props or {}) do obj[k] = v end
	for _, child in ipairs(children or {}) do child.Parent = obj end
	return obj
end

local function Round(num, step)
	return math.floor(num / step + 0.5) * step
end


local function AddThemeObject(obj, type)
	if not OrionLib.ThemeObjects[type] then OrionLib.ThemeObjects[type] = {} end
	table.insert(OrionLib.ThemeObjects[type], obj)
	obj[obj:IsA("Frame") and "BackgroundColor3" or obj:IsA("TextLabel") and "TextColor3" or "ImageColor3"] = OrionLib.Themes[OrionLib.SelectedTheme][type]
	return obj
end

local function UpdateTheme()
	for type, objs in pairs(OrionLib.ThemeObjects) do
		for _, obj in ipairs(objs) do
			local prop = obj:IsA("Frame") and "BackgroundColor3" or obj:IsA("TextLabel") and "TextColor3" or "ImageColor3"
			if obj[prop] then
				obj[prop] = OrionLib.Themes[OrionLib.SelectedTheme][type]
			end
		end
	end
end


local Elements = {}

function Elements:Corner(radius) return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8)}) end
function Elements:Stroke(color, thick) return Create("UIStroke", {Color = color or OrionLib.Themes[OrionLib.SelectedTheme].Stroke, Thickness = thick or 1.2}) end
function Elements:Padding(...) return Create("UIPadding", {PaddingLeft = UDim.new(0, ...), PaddingRight = UDim.new(0, ...), PaddingTop = UDim.new(0, ...), PaddingBottom = UDim.new(0, ...)}) end
function Elements:List(pad) return Create("UIListLayout", {Padding = UDim.new(0, pad or 6), SortOrder = Enum.SortOrder.LayoutOrder}) end

function Elements:Frame(color)
	return AddThemeObject(Create("Frame", {BackgroundColor3 = color or OrionLib.Themes[OrionLib.SelectedTheme].Second, BorderSizePixel = 0}, {
		Elements:Corner(), Elements:Stroke()
	}), "Second")
end

function Elements:Button()
	return Create("TextButton", {BackgroundTransparency = 1, Text = "", AutoButtonColor = false})
end

function Elements:Label(text, size)
	return AddThemeObject(Create("TextLabel", {
		Text = text or "", Font = Enum.Font.GothamBold, TextSize = size or 14,
		TextColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Text, BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left
	}), "Text")
end

function Elements:Image(id)
	local img = Create("ImageLabel", {BackgroundTransparency = 1, Image = id or ""})
	if GetIcon(id) then img.Image = GetIcon(id) end
	return img
end


local NotifyHolder = Create("Frame", {Size = UDim2.new(0, 320, 1, -40), Position = UDim2.new(1, -20, 1, -20), AnchorPoint = Vector2.new(1,1), BackgroundTransparency = 1, Parent = Orion}, {
	Elements:List(8), Create("UIPadding", {PaddingBottom = UDim.new(0, 10)})
})

function OrionLib:MakeNotification(cfg)
	cfg.Name = cfg.Name or "Notification"
	cfg.Content = cfg.Content or "No content"
	cfg.Time = cfg.Time or 4
	cfg.Image = cfg.Image or "diamond"

	spawn(function()
		local frame = Create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = NotifyHolder}, {
			Elements:Frame(OrionLib.Themes[OrionLib.SelectedTheme].Main),
			Elements:Corner(10), Elements:Stroke(),
			Elements:Padding(14),
			Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1}, {
				Elements:Image(cfg.Image), Elements:Label(cfg.Name, 15),
				Elements:Label(cfg.Content, 13):WaitForChild("TextLabel").TextWrapped = true
			})
		})

		frame:FindFirstChild("ImageLabel").Position = UDim2.new(0, 0, 0, 0)
		frame:FindFirstChild("TextLabel").Position = UDim2.new(0, 36, 0, 0)
		frame:FindFirstChild("TextLabel").Size = UDim2.new(1, -40, 0, 20)
		frame:FindFirstChild("TextLabel").Font = Enum.Font.GothamBold

		local content = frame:FindFirstChild("TextLabel", true)
		content.Position = UDim2.new(0, 0, 0, 28)
		content.Size = UDim2.new(1, 0, 0, 0)
		content.AutomaticSize = Enum.AutomaticSize.Y

		TweenServiceFrame.Position = UDim2.new(0, 10, 0, 0)
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()

		wait(cfg.Time)
		TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, 0, 0), BackgroundTransparency = 1}):Play()
		wait(0.7); frame:Destroy()
	end)
end

function OrionLib:MakeWindow(cfg)
	cfg = cfg or {}
	cfg.Name = cfg.Name or "Orion"
	cfg.Icon = cfg.Icon or "diamond"
	cfg.IntroText = cfg.IntroText or cfg.Name
	cfg.SaveConfig = cfg.SaveConfig ~= false

	if not isfolder(OrionLib.Folder) then makefolder(OrionLib.Folder) end

	local Window = Create("Frame", {Size = UDim2.new(0, 680, 0, 500), Position = UDim2.new(0.5, -340, 0.5, -250), BackgroundTransparency = 1, Parent = Orion}, {
		Elements:Frame(OrionLib.Themes[OrionLib.SelectedTheme].Main),
		Elements:Corner(14), Elements:Stroke(OrionLib.Themes[OrionLib.SelectedTheme].Accent, 2),
		Create("Frame", {Size = UDim2.new(1, 0, 0, 50), Name = "TopBar"}, {
			Elements:Frame(OrionLib.Themes[OrionLib.SelectedTheme].Second),
			Elements:Label(cfg.Name, 18), Elements:Image(cfg.Icon),
			Create("TextButton", {Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -40, 0. 0.5, 0), AnchorPoint = Vector2.new(1,0.5), BackgroundTransparency = 1}, {
				Elements:Image("x")
			})
		})
	})

	AddConnection(RunService.Heartbeat, function()
		local scale = OrionLib.Scale
		Window.Size = UDim2.new(0, 680 * scale, 0, 500 * scale)
		Window.Position = UDim2.new(0.5, -340 * scale, 0.5, -250 * scale)
	end)


	if cfg.IntroEnabled ~= false then
		local intro = Create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Parent = Orion}, {
			Elements:Image(cfg.Icon), Elements:Label(cfg.IntroText, 24)
		})
		intro.ImageLabel.Position = UDim2.new(0.5, 0, 0.4, 0); intro.ImageLabel.Size = UDim2.new(0, 40, 0, 40); intro.ImageLabel.ImageTransparency = 1
		intro.TextLabel.Position = UDim2.new(0.5, 0, 0.55, 0); intro.TextLabel.TextTransparency = 1

		TweenService:Create(intro.ImageLabel, TweenInfo.new(0.6), {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		wait(0.5)
		TweenService:Create(intro.TextLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
		wait(1.5)
		intro:Destroy()
	end

	OrionLib:MakeNotification({Name = "Loaded", Content = cfg.Name .. " UI Ready!", Image = "check", Time = 3})

	local Tabs = {}
	function Tabs:AddTab(name, icon)

		return {
			AddButton = function() end,
			AddToggle = function() end,
			AddSlider = function() end
		}
	end

	return {Tabs = Tabs, Destroy = function() Orion:Destroy() end}
end


function OrionLib:Init()
	if OrionLib.SaveCfg and isfile(OrionLib.Folder .. "/" .. game.PlaceId .. ".json") then
		local data = HttpService:JSONDecode(readfile(OrionLib.Folder .. "/" .. game.PlaceId .. ".json"))

	end
end

OrionLib:Init()

return OrionLib
