repeat task.wait() until game:IsLoaded()
print('exec')

local Repository = 'https://raw.githubusercontent.com/unsainted-duality/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(Repository .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(Repository .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(Repository .. 'addons/SaveManager.lua'))()

-- Variables

local LocalPlayer = game.Players.LocalPlayer

local Ping = 0
local AimPosition = nil
local ChargeTick = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.chargetick;
local RSEquipped = nil
local WeaponType = nil

local Projectiles = {
    -- Soldier
    ["Rocket Launcher"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, -0.275),
        ["Speed"] = 68.75,
        ["Gravity"] = 0,
        ["Boost"] = 0
    },
    ["Direct Hit"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 1.635),
        ["Speed"] = 123.75,
        ["Gravity"] = 0,
        ["Boost"] = 0
    },
    ["Blackbox"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, -0.265),
        ["Speed"] = 68.75,
        ["Gravity"] = 0,
        ["Boost"] = 0
    },
    ["Cow Mangler 5000"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.35),
        ["Speed"] = 68.75,
        ["Gravity"] = 0,
        ["Boost"] = 0
    },
    ["G-Bomb"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.52),
        ["Speed"] = 44.6875,
        ["Gravity"] = 0,
        ["Boost"] = 0
    },
    ["Original"] = {
        ["CFrameOffset"] = CFrame.new(0, -1, 1.191),
        ["Speed"] = 44.6875,
        ["Gravity"] = 0,
        ["Boost"] = 0
    },
    ["Liberty Launcher"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1877, 1.3),
        ["Speed"] = 96.25,
        ["Gravity"] = 0,
        ["Boost"] = 0
    },
    ["Maverick"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0),
        ["Speed"] = 68.75,
        ["Gravity"] = 15,
        ["Boost"] = 0
    },
    ["Airstrike"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1877, 1.3),
        ["Speed"] = (game.Players.LocalPlayer.Character:FindFirstChild("RocketJumped") and 110 or 68.75),
        ["Gravity"] = 0,
        ["Boost"] = 0
    },

    -- Pyro
    ["Flare Gun"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.41),
        ["Speed"] = 125,
        ["Gravity"] = 10,
        ["Boost"] = 0
    },
    ["Detonator"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.2),
        ["Speed"] = 125,
        ["Gravity"] = 10,
        ["Boost"] = 0
    },

    -- Demoman
    ["Grenade Launcher"] = {
        ["CFrameOffset"] = CFrame.new(0.5, -0.375, 0),
        ["Speed"] = 76,
        ["Gravity"] = workspace.Gravity,
        ["Boost"] = 10.5
    },
    ["Loch-n-Load"] = {
        ["CFrameOffset"] = CFrame.new(0.5, -0.375, 0),
        ["Speed"] = 76,
        ["Gravity"] = workspace.Gravity,
        ["Boost"] = 10.5
    },
    ["Loose Cannon"] = {
        ["CFrameOffset"] = CFrame.new(0.5, -0.375, 0),
        ["Speed"] = 76,
        ["Gravity"] = workspace.Gravity,
        ["Boost"] = 10.5
    },
    ["Iron Bomber"] = {
        ["CFrameOffset"] = CFrame.new(0.5, -0.375, 0),
        ["Speed"] = 76,
        ["Gravity"] = workspace.Gravity,
        ["Boost"] = 10.5
    },
    ["Ultimatum"] = {
        ["CFrameOffset"] = CFrame.new(0.5, -0.375, 0),
        ["Speed"] = 76,
        ["Gravity"] = workspace.Gravity,
        ["Boost"] = 10.5
    },

    -- Engineer
    ["Rescue Ranger"] = {
        ["CFrameOffset"] = CFrame.new(0.5, 0.2, 0.5),
        ["Speed"] = 150,
        ["Gravity"] = 5, -- complete guess
        ["Boost"] = 0
    },

    -- Medic
    ["Milk Pistol"] = {
        ["CFrameOffset"] = CFrame.new(0.5, 0.1875, 0.5),
        ["Speed"] = 150,
        ["Gravity"] = 5, -- complete guess
        ["Boost"] = 0
    },
    ["Syringe Crossbow"] = {
        ["CFrameOffset"] = CFrame.new(0.5, 0.1875, 0.5),
        ["Speed"] = 150,
        ["Gravity"] = 5, -- complete guess
        ["Boost"] = 0
    },

    -- Sniper
    ["Huntsman"] = { -- yea...
        ["CFrameOffset"] = CFrame.new(0.5, -0.1875, -2),
        ["Speed"] = 113.25 + ((tick() - ChargeTick.Value) < 1000 and (math.clamp(tick() - ChargeTick.Value, 0, 1) * 49.25) or 0),
        ["Gravity"] = 24.8 - ((tick() - ChargeTick.Value) < 1000 and (math.clamp(tick() - ChargeTick.Value, 0, 1) * 19.8) or 0),
        ["Boost"] = 0,
    }
}
task.spawn(function()
    while task.wait() and not Library.Unloaded do
        Projectiles.Airstrike.Speed = (LocalPlayer.Character:FindFirstChild("RocketJumped") and 110 or 68.75)

        Projectiles.Huntsman.Speed = 113.25 + ((tick() - ChargeTick.Value) < 1000 and (math.clamp(tick() - ChargeTick.Value, 0, 1) * 49.25) or 0)
        Projectiles.Huntsman.Gravity = 24.8 - ((tick() - ChargeTick.Value) < 1000 and (math.clamp(tick() - ChargeTick.Value, 0, 1) * 19.8) or 0)
    end
end)

makefolder("bibulus.club")

if not isfile("bibulus.club/Interlude.mp3") then
    print("[ Bibulus ] 'Interlude.mp3' not found, downloading..")

    local Time = tick()
    local Interlude = request({Url = "https://github.com/geoduude/bibulus-dependencies/raw/main/Interlude.mp3"}).Body

    if Interlude then
        print("[ Bibulus ] 'Interlude.mp3' Downloaded in "..string.format("%.2f", tick() - Time).."s.")
        writefile("bibulus.club/Interlude.mp3", Interlude)
    else
        warn("[ Bibulus ] 'Interlude.mp3' failed to load.")
    end
end

if not isfile("bibulus.club/More Gun Reversed.mp3") then
    print("[ Bibulus ] 'More Gun Reversed.mp3' not found, downloading..")

    local Time = tick()
    local Interlude = request({Url = "https://github.com/geoduude/bibulus-dependencies/raw/main/More%20Gun%20Reversed.mp3"}).Body

    if Interlude then
        print("[ Bibulus ] 'More Gun Reversed.mp3' Downloaded in "..string.format("%.2f", tick() - Time).."s.")
        writefile("bibulus.club/More Gun Reversed.mp3", Interlude)
    else
        warn("[ Bibulus ] 'More Gun Reversed.mp3' failed to load.")
    end
end

local InterludeID = getcustomasset("bibulus.club/Interlude.mp3")
local MoreGunReversedID = getcustomasset("bibulus.club/More Gun Reversed.mp3")

local Tags = {
    [255] = "Holder (Game Owner)",
    [254] = "Game Developer",
    [253] = "Game Moderator",
    [252] = "Contributor",
    [251] = "Game Tester"
}

for _,Player in game.Players:GetPlayers() do
    task.spawn(function()
        repeat task.wait() until Player:GetAttribute("GroupRank")
        for i,v in Tags do
            if i == Player:GetAttribute("GroupRank") then
                Library:Notify("[ Bibulus ] ⚠ '".. Player.DisplayName .. " (@".. Player.Name ..")' is ranked '".. v .."' in the Dorcus Digital Group.", 15)
                local Sound = Instance.new("Sound")
                Sound.Parent = game:GetService("SoundService")
                Sound.SoundId = "rbxassetid://8784885431"
                Sound.Volume = 5
                Sound.PlayOnRemove = true
                Sound:Destroy()
            end
        end
    end)
end

local PlayerAdded = game.Players.PlayerAdded:Connect(function(Player)
    repeat task.wait() until Player:GetAttribute("GroupRank")
    for i,v in Tags do
        if i == Player:GetAttribute("GroupRank") then
            Library:Notify("[ Bibulus ] ⚠ '".. Player.DisplayName .. " (@".. Player.Name ..")' is ranked '".. v .."' in the Dorcus Digital Group.", 15)
            local Sound = Instance.new("Sound")
            Sound.Parent = game:GetService("SoundService")
            Sound.SoundId = "rbxassetid://8784885431"
            Sound.Volume = 5
            Sound.PlayOnRemove = true
            Sound:Destroy()
        end
    end
end)

-- UI

local Window = Library:CreateWindow({
    Title = ' bibulus.club', 
    Center = true,  
    AutoShow = true, 
    TabPadding = 3, 
    MenuFadeTime = 0.2 
})
local Tabs = { 
    Aimbot = Window:AddTab('Aimbot'), 
    Visuals = Window:AddTab('Visuals'), 
    Misc = Window:AddTab('Miscellaneous'), 
    Config = Window:AddTab('Config') 
}

local AimbotGeneral = Tabs.Aimbot:AddLeftGroupbox('General')
AimbotGeneral:AddToggle('AG_aimtoggle', { Text = 'Enable', Default = false, }):AddKeyPicker('AG_aimtogglekey', { Default = 'E', SyncToggleState = false, Mode = 'Hold', Text = 'Aimkey', NoUI = false })
--AimbotGeneral:AddToggle('AG_shootteammates', { Text = 'Aim At Teammates', Default = false })
AimbotGeneral:AddDivider()
AimbotGeneral:AddToggle('AG_aimsilent', { Text = 'Silent', Default = false })
AimbotGeneral:AddDropdown('AG_aimhitbox', { Values = { 'Head', 'UpperTorso', 'LowerTorso' }, Default = 1, Multi = false, Text = 'Aimbot Hitbox' })
AimbotGeneral:AddSlider('AG_aimfov', { Text = 'Maximum FOV', Default = 1, Min = 1, Max = 90, Rounding = 0, Compact = false })

local AimbotProjectile = Tabs.Aimbot:AddRightGroupbox('Projectiles')
AimbotProjectile:AddSlider('AP_projectileaccuracy', { Text = 'Projectile Calculation Intensity', Default = 10, Min = 2, Max = 100, Rounding = 0, Compact = false })

local VisualsESP = Tabs.Visuals:AddLeftGroupbox('Player ESP')
VisualsESP:AddToggle('VV_espenabled', { Text = 'Enabled', Default = false })
VisualsESP:AddToggle('VV_pchams', { Text = 'Player Chams', Default = false }):AddColorPicker('pchams_f', {Default = Color3.fromRGB(66, 135, 245), Title = "Player Chams Fill", Transparency = 0.5}):AddColorPicker('pchams_o', {Default = Color3.fromRGB(66, 245, 176), Title = "Player Chams Outline", Transparency = 0.5})
VisualsESP:AddToggle('VV_pbchams', { Text = 'Building Chams', Default = false }):AddColorPicker('pbchams_f', {Default = Color3.fromRGB(66, 135, 245), Title = "Building Chams Fill", Transparency = 0.5}):AddColorPicker('pbchams_o', {Default = Color3.fromRGB(66, 245, 176), Title = "Building Chams Outline", Transparency = 0.5})
VisualsESP:AddToggle('VV_boxesp', { Text = 'Box', Default = false }):AddColorPicker('boxespc', {Default = Color3.fromRGB(255,255,255), Title = "Box Color"}):AddColorPicker('boxespf', {Default = Color3.fromRGB(255,255,255), Title = "Box Fill", Transparency = 0.8})
VisualsESP:AddToggle('VV_names', { Text = 'Names', Default = false }):AddColorPicker('namesc', {Default = Color3.fromRGB(255,255,255), Title = "Name Color"})
VisualsESP:AddToggle('VV_wep', { Text = 'Weapons', Default = false }):AddColorPicker('wepc', {Default = Color3.fromRGB(255,255,255), Title = "Weapon Text Color"})
VisualsESP:AddToggle('VV_dist', { Text = 'Distance', Default = false }):AddColorPicker('distc', {Default = Color3.fromRGB(255,255,255), Title = "Distance Text Color"})
VisualsESP:AddToggle('VV_hb', { Text = 'Health Bar', Default = false }):AddColorPicker('hbc', {Default = Color3.fromRGB(0,255,0), Title = "Health Bar Color"})
VisualsESP:AddToggle('VV_hn', { Text = 'Health Number', Default = false }):AddColorPicker('hnc', {Default = Color3.fromRGB(255,255,255), Title = "Health Number Text Color"})
VisualsESP:AddToggle('VV_tracers', { Text = 'Tracers', Default = false }):AddColorPicker('tracersc', {Default = Color3.fromRGB(255,255,255), Title = "Tracer Line Color"})
VisualsESP:AddToggle('VV_oovarrows', { Text = 'Out Of View Arrows', Default = false }):AddColorPicker('oovarrowsc', {Default = Color3.fromRGB(255,255,255), Title = "Out Of View Arrows Color"})
VisualsESP:AddSlider('VV_oovsize', { Text = 'OOV Arrows Size', Default = 10, Min = 1, Max = 25, Rounding = 0, Compact = false })
VisualsESP:AddSlider('VV_oovdist', { Text = 'OOV Arrows Distance', Default = 300, Min = 50, Max = 800, Rounding = 0, Compact = false })
VisualsESP:AddDivider("Settings")
VisualsESP:AddToggle('VV_outline', { Text = 'Outlines', Default = true })
VisualsESP:AddToggle('VV_bold', { Text = 'Bold Text', Default = false })
VisualsESP:AddToggle('VV_teammates', { Text = 'Include Teammates', Default = false })
VisualsESP:AddDropdown('VV_textfont', { Values = { 'Plex', 'UI', 'System', 'Monospace' }, Default = 1, Text = 'Text Font' })
VisualsESP:AddDropdown('VV_textmode', { Values = { 'Normal', 'lowercase', 'UPPERCASE' }, Default = 1, Text = 'Text Mode' })
VisualsESP:AddSlider('VV_espsize', { Text = 'ESP Size', Default = 13, Min = 1, Max = 50, Rounding = 0, Compact = false })

local VisualsView = Tabs.Visuals:AddRightGroupbox('View')
VisualsView:AddSlider('VV_fieldofview', { Text = 'Field Of View', Default = 90, Min = 10, Max = 120, Rounding = 0, Compact = false })
VisualsView:AddSlider('VV_scopedfov', { Text = 'Scoped Field Of View', Default = 20, Min = 10, Max = 120, Rounding = 0, Compact = false })
VisualsView:AddToggle('VV_remscope', { Text = 'Remove Scope', Default = false })
VisualsView:AddDivider()
VisualsView:AddToggle('VV_avatarviewmodel', { Text = 'Avatar Viewmodel', Default = false })
VisualsView:AddInput('VV_avatarvminput', { Default = string.lower(LocalPlayer.Name), Numeric = false, Finished = true, Text = 'Player Name', Placeholder = string.lower(LocalPlayer.Name), })

local MiscGeneral = Tabs.Misc:AddLeftGroupbox('General')
MiscGeneral:AddToggle('MG_ogbossthemes', { Text = 'Original VSB Themes', Default = false })

local MiscMovement = Tabs.Misc:AddLeftGroupbox('Movement')
MiscMovement:AddToggle('MM_speedmod', { Text = 'Speed Modifier', Default = false, }):AddKeyPicker('MM_speedmodkey', { Default = 'LeftShift', SyncToggleState = false, Mode = 'Hold', Text = 'Speed Mod', NoUI = false })
MiscMovement:AddSlider('MM_speedmodval', { Text = 'Speed Amount', Default = 400, Min = 100, Max = 5000, Rounding = 0, Compact = false })
MiscMovement:AddDivider()
MiscMovement:AddToggle('MM_autobhop', { Text = 'Auto BunnyHop', Default = false })
MiscMovement:AddToggle('MM_nobhopcap', { Text = 'No BunnyHop Cap', Default = false })

local MiscExploits = Tabs.Misc:AddLeftGroupbox('Exploits')
MiscExploits:AddToggle('ME_nofalldamage', { Text = 'No Fall Damage', Default = false })
MiscExploits:AddToggle('ME_instantrespawn', { Text = 'Instant Respawn', Default = false })

local MiscGunmods = Tabs.Misc:AddRightGroupbox('Gun Modification')
MiscGunmods:AddToggle('MG_infiniteammo', { Text = 'Infinite Ammo', Default = false })
MiscGunmods:AddToggle('MG_infinitereserveammo', { Text = 'Infinite Reserve Ammo', Default = false })
MiscGunmods:AddToggle('MG_ignorewalls', { Text = 'Wallbang', Default = false })
MiscGunmods:AddToggle('MG_infhypejumps', { Text = 'Infinite Hype Jumps', Default = false })
MiscGunmods:AddDivider()
MiscGunmods:AddSlider('MG_spreadreduction', { Text = 'Spread Reduction', Default = 1, Min = 1, Max = 100, Rounding = 0, Compact = true, Suffix = "%" })
MiscGunmods:AddSlider('MG_dmgmultiplier', { Text = 'Damage Multiplier', Default = 1, Min = 1, Max = 25, Rounding = 1, Compact = true, Suffix = "x"  })
MiscGunmods:AddSlider('MG_fireratemultiplier', { Text = 'FireRate Multiplier', Default = 1, Min = 1, Max = 25, Rounding = 1, Compact = true, Suffix = "x" })

local MiscDebug = Tabs.Misc:AddRightGroupbox('Debug')
MiscDebug:AddToggle('MD_notifyblacklistedremotes', { Text = 'Notify Blacklisted Remotes', Default = false })
MiscDebug:AddDropdown('MD_blacklistedremotes', { Values = { 'BeanBoozled', 'WEGA', 'Ban' }, Default = 0, Multi = true, Text = 'Notify for..' })
MiscDebug:AddButton('Teleport To Bibulus Testing Server', function()
    game.ReplicatedStorage.Functions.TeleportTo:InvokeServer("bibulus.tc", "bibulusstaging")
end)

-- Functions
local Players = game:GetService("Players")
local PLRDS = {}
local Ut = {}
Ut.Settings = {
	Line = {
		Thickness = 1,
		Color = Color3.fromRGB(0, 255, 0)
	},
	Text = {
		Size = 13,
		Center = true,
		Outline = true,
		Font = 2,
		Color = Color3.fromRGB(255, 255, 255)
	},
	Square = {
		Thickness = 1,
		Color = Color3.fromRGB(255, 255, 255),
		Filled = false,
	},
	Circle = {
		Filled = false,
		NumSides = 30,
		Thickness = 0,
	},
	Triangle = {
		Color = Color3.fromRGB(255, 255, 255),
		Filled = true,
		Visible = false,
		Thickness = 1,
	}
}

function Ut.New(data)
	local drawing = Drawing.new(data.type)
	for i, v in pairs(Ut.Settings[data.type]) do
		drawing[i] = v
	end
	if data.type == "Square" then
		if not data.filled then
			drawing.Filled = false
		elseif data.filled then
			drawing.Filled = true
		end
	end
	if data.out then
		drawing.Color = Color3.new(0,0,0)
		drawing.Thickness = 3
	end
	return drawing
end

function Ut.Add(Player)
	if not PLRDS[Player] then
		PLRDS[Player] = {
			Offscreen = Ut.New({type = "Triangle"}),
			Name = Ut.New({type = "Text"}),
			NameB = Ut.New({type = "Text"}),
			Distance = Ut.New({type = "Text"}),
			DistanceB = Ut.New({type = "Text"}),
			BoxOutline = Ut.New({type = "Square", out = true}),
			Box = Ut.New({type = "Square"}),
			HealthNumber = Ut.New({type = "Text"}),
			HealthNumberB = Ut.New({type = "Text"}),
			BoxFill = Ut.New({type = "Square"}),
			HealthOutline = Ut.New({type = "Line", out = true}),
			HealthOutline2 = Ut.New({type = "Line"}),
			Health = Ut.New({type = "Line"}),
			Health2 = Ut.New({type = "Line"}),
			HeadDot = Ut.New({type = "Circle"}),
			Tracers = Ut.New({type = "Line"}),
			Exit = Ut.New({type = "Text"}),
			ExitB = Ut.New({type = "Text"}),
			FovTracers = Ut.New({type = "Line"}),
			Tool = Ut.New({type = "Text"}),
			ToolB = Ut.New({type = "Text"}),
		}
	end
end
for _,Player in pairs(Players:GetPlayers()) do
	Ut.Add(Player)
end
Players.PlayerAdded:Connect(Ut.Add)
Players.PlayerRemoving:Connect(function(Player)
	if PLRDS[Player] then
		for i,v in pairs(PLRDS[Player]) do
			if v then
				v:Remove()
			end
		end

		PLRDS[Player] = nil
	end
end)

function isAlive(player)
	local alive = false
	if player ~= nil and player.Parent == game.Players and player.Character ~= nil then
		if player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") ~= nil and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("Head") then
			alive = true
		end
	end
	return alive
end

function isTarget(plr, teammates)
	if isAlive(plr) then
		if not plr.Neutral and not LocalPlayer.Neutral then
			if teammates == false then
				return plr.Team ~= LocalPlayer.Team
			elseif teammates == true then
				return plr ~= LocalPlayer
			end
		else
			return plr ~= LocalPlayer
		end
	end
end

function Visuals()
    for i,v in pairs(workspace:GetChildren()) do
        if Toggles.VV_pbchams.Value and (v.Name:match("'s Sentry") or v.Name:match("'s Dispenser") or v.Name:match("'s Teleporter")) then
            local Player = game.Players:FindFirstChild(v:GetAttribute("Owner"))
            if Toggles.VV_pbchams.Value and Player ~= nil and isTarget(Player, Toggles.VV_teammates.Value) then
                if v:FindFirstChildWhichIsA("Highlight") == nil then
                    local highlight = Instance.new("Highlight", v)
                end
                v.Highlight.FillColor = Options.pbchams_f.Value
                v.Highlight.OutlineTransparency = Options.pbchams_o.Transparency
                v.Highlight.FillTransparency = Options.pbchams_f.Transparency
                v.Highlight.OutlineColor = Options.pbchams_o.Value
            else
                if v:FindFirstChildWhichIsA("Highlight") then
                    v:FindFirstChildWhichIsA("Highlight"):Destroy()
                end
            end
        end
    end
    for _,Player in pairs (Players:GetPlayers()) do
        if Toggles.VV_espenabled.Value and PLRDS[Player] and isTarget(Player, Toggles.VV_teammates.Value) then
            local PLRD = PLRDS[Player]
            for _,v in pairs (PLRD) do
                v.Visible = false
            end
            local Character = Player.Character
            local RootPart, Humanoid = Character and Character:FindFirstChild("HumanoidRootPart"), Character and Character:FindFirstChildOfClass("Humanoid")
            if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
                if Humanoid then
                    if Humanoid.Health <= 0 then
                        continue
                    end
                end
            end

            local Head = Player.Character:FindFirstChild("Head")
            local poser = workspace.CurrentCamera:WorldToViewportPoint(Head.Position)
            local mousePos = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().x, game:GetService("UserInputService"):GetMouseLocation().y, 0)
            local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
            local DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
            local alivecheck = true
            
            if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
                if Humanoid then
                    if game.PlaceId == 4991214437 then
                        if alivecheck and Humanoid.Health <= 1 then
                            continue
                        end
                    else
                        if alivecheck and Humanoid.Health <= 0 then
                            continue
                        end
                    end
                end
            end
            if Options.VV_textmode.Value == "Normal" then
                DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. "m"
            elseif Options.VV_textmode.Value == "lowercase" then
                DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.lower("m")
            elseif Options.VV_textmode.Value == "UPPERCASE" then
                DistanceFromCharacter = tostring(math.ceil(LocalPlayer:DistanceFromCharacter(RootPart.Position) / 5)).. string.upper("m")
            end
            local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
            
            if Toggles.VV_pchams.Value and isTarget(Player, Toggles.VV_teammates.Value) then
                if Player.Character:FindFirstChildWhichIsA("Highlight") == nil then
                    local highlight = Instance.new("Highlight", Player.Character)
                end
                Player.Character.Highlight.FillColor = Options.pchams_f.Value
                Player.Character.Highlight.OutlineTransparency = Options.pchams_o.Transparency
                Player.Character.Highlight.FillTransparency = Options.pchams_f.Transparency
                Player.Character.Highlight.OutlineColor = Options.pchams_o.Value
            else
                if Player.Character:FindFirstChildWhichIsA("Highlight") then
                    Player.Character:FindFirstChildWhichIsA("Highlight"):Destroy()
                end
            end
            if not OnScreen then
                local niggars = Character.PrimaryPart
                local proj = workspace.CurrentCamera.CFrame:PointToObjectSpace(RootPart.Position)
                local ang = math.atan2(proj.Z, proj.X)
                local dir = Vector2.new(math.cos(ang), math.sin(ang))
                local pos = (dir * Options.VV_oovdist.Value * .5) + workspace.CurrentCamera.ViewportSize / 2
                local Drawing = PLRD.Offscreen
                local function rotateVector2(v2, r)
                    local c = math.cos(r);
                    local s = math.sin(r);
                    return Vector2.new(c * v2.X - s*v2.Y, s*v2.X + c*v2.Y)
                end
                
                if Toggles.VV_oovarrows.Value then
                    Drawing.PointA = pos
                    Drawing.PointB = pos - rotateVector2(dir, math.rad(35)) * Options.VV_oovsize.Value
                    Drawing.PointC = pos - rotateVector2(dir, -math.rad(35)) * Options.VV_oovsize.Value
                    Drawing.Color = Options.oovarrowsc.Value
                    Drawing.Filled = true
                    Drawing.Transparency = 1
                    Drawing.Visible = true
                end
            else    
                local IhateMyLifeSize = (workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0)).Y - workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                local BoxSize = Vector2.new(math.floor(IhateMyLifeSize * 1.2), math.floor(IhateMyLifeSize * 2))
                local BoxPos = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2))
                local HeadPos = Head.Position
                local HeadPosA = workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(HeadPos.x, HeadPos.y + 0.1, HeadPos.z))
                local HeadPosAB = workspace.CurrentCamera:WorldToViewportPoint(Vector3.new(HeadPos.x, HeadPos.y - 0.2, HeadPos.z))
                local Dif = HeadPosAB.y - HeadPosA.y
                local Name = PLRD.Name
                local Distance = PLRD.Distance
                local Box = PLRD.Box
                local Tracers = PLRD.Tracers
                local HeadDot = PLRD.HeadDot
                local BoxOutline = PLRD.BoxOutline
                local Health = PLRD.Health
                local HealthOutline = PLRD.HealthOutline
                local HealthNumber = PLRD.HealthNumber
                local HealthNumberB = PLRD.HealthNumberB
                local BoxFill = PLRD.BoxFill   
                --local FovTracer = PLRD.FovTracers 
                local Tool = PLRD.Tool 
                local DistanceB = PLRD.DistanceB
                local NameB = PLRD.NameB
                local ToolB = PLRD.ToolB
                local Health2 = PLRD.Health2
                local HealthOutline2 = PLRD.HealthOutline2
                local Y_off = BoxSize.Y + BoxPos.Y + 1
                
                local ptool = Player.Character:GetAttribute("EquippedWeapon")

                if Toggles.VV_wep.Value then
                    if ptool ~= nil then
                        if Options.VV_textmode.Value == "Normal" then
                            Tool.Text = ptool
                        elseif Options.VV_textmode.Value == "lowercase" then
                            Tool.Text = string.lower(ptool)
                        elseif Options.VV_textmode.Value == "UPPERCASE" then
                            Tool.Text = string.upper(ptool)
                        end
                        Tool.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, Y_off)
                        Tool.Color = Options.wepc.Value
                        Tool.Font = Drawing.Fonts[Options.VV_textfont.Value]
                        Tool.Size = Options.VV_espsize.Value
                        Tool.Visible = true
                        Tool.Outline = Toggles.VV_outline.Value
                        if Toggles.VV_bold.Value then
                            if Options.VV_textmode.Value == "Normal" then
                                ToolB.Text = ptool
                            elseif Options.VV_textmode.Value == "lowercase" then
                                ToolB.Text = string.lower(ptool)
                            elseif Options.VV_textmode.Value == "UPPERCASE" then
                                ToolB.Text = string.upper(ptool)
                            end
                            ToolB.Position = Vector2.new(BoxSize.X/2 + BoxPos.X + 1, Y_off)
                            ToolB.Color = Options.wepc.Value
                            ToolB.Font = Drawing.Fonts[Options.VV_textfont.Value]
                            ToolB.Size = Options.VV_espsize.Value
                            ToolB.Visible = true
                            ToolB.Outline = false
                        end
                        Y_off += 15
                    end
                end

                if Toggles.VV_boxesp.Value then
                    Box.Size = BoxSize
                    Box.Position = BoxPos
                    Box.Visible = true
                    --[[if library.flags.tt and tname == "["..Player.DisplayName.."]" then
                        Box.Color = library.flags.tcol
                    else]]
                        Box.Color = Options.boxespc.Value
                    --end

                    if Toggles.VV_outline.Value then
                        BoxOutline.Size = BoxSize
                        BoxOutline.Position = BoxPos
                        BoxOutline.Visible = true
                    end
                    
                    BoxFill.Filled = true
                    BoxFill.Visible = true
                    BoxFill.Size = Vector2.new(math.floor(IhateMyLifeSize * 1.2 - 2), math.floor(IhateMyLifeSize * 2 - 2))
                    BoxFill.Position = Vector2.new(math.floor(Pos.X - IhateMyLifeSize * 1 / 2 + 1), math.floor(Pos.Y - IhateMyLifeSize * 1.6 / 2 + 1))
                    BoxFill.Color = Options.boxespf.Value
                    BoxFill.Transparency = Options.boxespf.Transparency
                end

                if Toggles.VV_names.Value then
                    if Options.VV_textmode.Value == "Normal" then
                        Name.Text = Player.DisplayName
                    elseif Options.VV_textmode.Value == "lowercase" then
                        Name.Text = string.lower(Player.DisplayName)
                    elseif Options.VV_textmode.Value == "UPPERCASE" then
                        Name.Text = string.upper(Player.DisplayName)
                    end
                    Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 5 - Name.TextBounds.Y)
                    Name.Color = Options.namesc.Value
                    Name.Font = Drawing.Fonts[Options.VV_textfont.Value]
                    Name.Size = Options.VV_espsize.Value
                    Name.Visible = true
                    Name.Outline = Toggles.VV_outline.Value
                    if Toggles.VV_bold.Value then
                        if Options.VV_textmode.Value == "Normal" then
                            NameB.Text = Player.DisplayName
                        elseif Options.VV_textmode.Value == "lowercase" then
                            NameB.Text = string.lower(Player.DisplayName)
                        elseif Options.VV_textmode.Value == "UPPERCASE" then
                            NameB.Text = string.upper(Player.DisplayName)
                        end
                        NameB.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X + 1, BoxPos.Y - 5 - Name.TextBounds.Y)
                        NameB.Color = Options.namesc.Value
                        NameB.Font = Drawing.Fonts[Options.VV_textfont.Value]
                        NameB.Size = Options.VV_espsize.Value
                        NameB.Visible = true
                        NameB.Outline = false
                    end
                end

                if Toggles.VV_hb.Value then  
                    Health.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
                    Health.To = Vector2.new((BoxPos.X - 5), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
                    Health.Color = Options.hbc.Value 
                    Health.Visible = true

                    Health2.From = Vector2.new((BoxPos.X - 6), BoxPos.Y + BoxSize.Y)
                    Health2.To = Vector2.new((BoxPos.X - 6), Health.From.Y - (Humanoid.Health / Humanoid.MaxHealth) * BoxSize.Y)
                    Health2.Color = Options.hbc.Value
                    Health2.Visible = true

                    if Toggles.VV_outline.Value then
                        HealthOutline.From = Vector2.new(Health.From.X, BoxPos.Y + BoxSize.Y + 1)
                        HealthOutline.To = Vector2.new(Health.From.X, (Health.From.Y - 1 * BoxSize.Y) -1)
                        HealthOutline.Visible = true

                        HealthOutline2.From = Vector2.new(Health.From.X - 2, BoxPos.Y + BoxSize.Y + 1)
                        HealthOutline2.To = Vector2.new(Health.From.X - 2, (Health.From.Y - 1 * BoxSize.Y) -1)
                        HealthOutline2.Visible = true
                        HealthOutline2.Thickness = 1
                        HealthOutline2.Color = Color3.new(0, 0, 0)
                    end
                end

                if Toggles.VV_hn.Value then
                    HealthNumber.Text = tostring(math.round(Humanoid.Health))
                    if Toggles.VV_hb.Value then
                        HealthNumber.Position = Vector2.new(BoxPos.X - 3 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
                    else
                        HealthNumber.Position = Vector2.new(BoxPos.X - 3 - (HealthNumber.TextBounds.X / 2) - 4, BoxPos.Y - 2)
                    end
                    HealthNumber.Color = Options.hnc.Value
                    HealthNumber.Font = Drawing.Fonts[Options.VV_textfont.Value]
                    HealthNumber.Size = Options.VV_espsize.Value
                    HealthNumber.Visible = true
                    HealthNumber.Outline = Toggles.VV_outline.Value
                    if Toggles.VV_bold.Value then
                        HealthNumberB.Text = tostring(math.round(Humanoid.Health))
                        if Toggles.VV_hb.Value then
                            HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - HealthNumber.TextBounds.X, BoxPos.Y - 2)
                        else
                            HealthNumberB.Position = Vector2.new(BoxPos.X - 2 - (HealthNumber.TextBounds.X / 2) - 3, BoxPos.Y - 2)
                        end
                        HealthNumberB.Color = Options.hnc.Value
                        HealthNumberB.Font = Drawing.Fonts[Options.VV_textfont.Value]
                        HealthNumberB.Size = Options.VV_espsize.Value
                        HealthNumberB.Visible = true
                        HealthNumberB.Outline = false
                    end
                end

                if Toggles.VV_dist.Value then
                    Distance.Text = DistanceFromCharacter
                    Distance.Position = Vector2.new(BoxSize.X/2 + BoxPos.X, Y_off)
                    Distance.Color = Options.distc.Value
                    Distance.Font = Drawing.Fonts[Options.VV_textfont.Value]
                    Distance.Size = Options.VV_espsize.Value
                    Distance.Visible = true
                    Distance.Outline = Toggles.VV_outline.Value
                    if Toggles.VV_bold.Value then
                        DistanceB.Text = DistanceFromCharacter
                        DistanceB.Position = Vector2.new(BoxSize.X/2 + BoxPos.X + 1, Y_off)
                        DistanceB.Color = Options.distc.Value
                        DistanceB.Font = Drawing.Fonts[Options.VV_textfont.Value]
                        DistanceB.Size = Options.VV_espsize.Value
                        DistanceB.Visible = true
                        DistanceB.Outline = false
                    end
                    Y_off += 15
                end

                if Toggles.VV_tracers.Value then
                    Tracers.From = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y + BoxSize.Y)
                    Tracers.To = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                    Tracers.Color = Options.tracersc.Value
                    Tracers.Visible = true
                end
            end
        else
            if isAlive(Player) and Player.Character:FindFirstChildOfClass("Highlight") then
                Player.Character:FindFirstChildOfClass("Highlight"):Destroy()
            end
            if PLRDS[Player] then
                for i, v in pairs(PLRDS[Player]) do
                    if v.Visible ~= false then
                        v.Visible = false
                    end
                end
            end
        end
    end
end

function PlayerProjFOV(CurrentWeapon)
    local Position, Character
    local Mouse = LocalPlayer:GetMouse()
    local MinimumDistance = Options.AG_aimfov.Value * 12.5

    for _, Player in game.Players:GetPlayers() do
        if Player ~= LocalPlayer and Player:FindFirstChild("Status") and Player.Status.Team.Value ~= LocalPlayer.Status.Team.Value and Player.Character and Player.Character:FindFirstChild("Hitbox") then
            local ScreenPoint, OnScreen = workspace.CurrentCamera:WorldToScreenPoint(Player.Character.Hitbox.Position)

            if OnScreen then
                local List = {workspace.CurrentCamera, workspace.Ray_Ignore, workspace.Map.Ignore, workspace.Map.Items, workspace.Map.TGCSpawns, workspace.Map.TRCSpawns}

                for _,v in game.Players:GetPlayers() do
                    if v.Character then
                        table.insert(List, v.Character)
                    end
                end
                for _,v in workspace:GetChildren() do
                    if string.find(v.Name, "'s ") then
                        table.insert(List, v)
                    end
                end

                local RaycastParams = RaycastParams.new()
                RaycastParams.FilterDescendantsInstances = List
                RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                RaycastParams.IgnoreWater = true

                local ProjectileSpawnPosition = (workspace.CurrentCamera.CFrame * Projectiles[CurrentWeapon].CFrameOffset).Position

                local Distance = (ProjectileSpawnPosition - Player.Character.Hitbox.Position).Magnitude
                local Speed = Distance / Projectiles[CurrentWeapon].Speed + (Ping * 2)

                for _=1,(Options.AP_projectileaccuracy.Value) do
                    local Temp = Player.Character.Hitbox.Position + (Player.Character.Hitbox.AssemblyLinearVelocity - Vector3.new(0,workspace.Gravity * (Speed/2),0)) * Speed

                    local Raycast = workspace:Raycast(Player.Character.Hitbox.Position + (Vector3.new(Player.Character.Hitbox.AssemblyLinearVelocity.X,0,Player.Character.Hitbox.AssemblyLinearVelocity.Z) * Speed), Vector3.new(0,-1000,0), RaycastParams)
                    if Raycast and (Raycast.Position.Y + 3) > Temp.Y then
                        Temp = Vector3.new(Temp.X,Raycast.Position.Y + 3,Temp.Z)
                    end

                    Distance = (ProjectileSpawnPosition - Temp).Magnitude
                    Speed = Distance / Projectiles[CurrentWeapon].Speed + (Ping * 2)
                end

                if Speed > 5 then continue end

                local PredctionPosition = Player.Character.Hitbox.Position + (Player.Character.Hitbox.AssemblyLinearVelocity - Vector3.new(0,workspace.Gravity * (Speed/2),0)) * Speed

                local Raycast = workspace:Raycast(Player.Character.Hitbox.Position + (Vector3.new(Player.Character.Hitbox.AssemblyLinearVelocity.X,0,Player.Character.Hitbox.AssemblyLinearVelocity.Z) * Speed), Vector3.new(0,-1000,0), RaycastParams)
                if Raycast and (Raycast.Position.Y + 3) > PredctionPosition.Y then
                    PredctionPosition = Vector3.new(PredctionPosition.X, Raycast.Position.Y + 3, PredctionPosition.Z)
                end

                if Player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                    local Raycast = workspace:Raycast(ProjectileSpawnPosition, PredctionPosition - ProjectileSpawnPosition, RaycastParams)

                    if not Raycast then
                        local Magnitude = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                        if Magnitude < MinimumDistance then
                            Character = Player.Character
                            Position = PredctionPosition
                            MinimumDistance = Magnitude
                        end
                    end
                else
                    local Offset = -2.5

                    for _=1,3 do
                        local Raycast = workspace:Raycast(ProjectileSpawnPosition, (PredctionPosition + Vector3.new(0,Offset,0)) - ProjectileSpawnPosition, RaycastParams)

                        if not Raycast then
                            local Magnitude = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                            if Magnitude < MinimumDistance then
                                Character = Player.Character
                                Position = PredctionPosition + Vector3.new(0,Offset,0)
                                MinimumDistance = Magnitude
                            end

                            break
                        else
                            Offset += 2
                        end
                    end
                end
            end
        end
    end

    return Position, Character
end

function PlayerFOV(Part)
    local Position, Character
    local Mouse = LocalPlayer:GetMouse()
    local MinimumDistance = Options.AG_aimfov.Value * 12.5

    for _, Player in game.Players:GetPlayers() do
        if Player ~= LocalPlayer and Player:FindFirstChild("Status") and Player.Status.Team.Value ~= LocalPlayer.Status.Team.Value and Player.Character and Player.Character:FindFirstChild(Part) then
            local Target = Player.Character[Part].Position
            local ScreenPoint, OnScreen = workspace.CurrentCamera:WorldToScreenPoint(Target)

            if OnScreen and (workspace.CurrentCamera.CFrame.Position - Target).Magnitude < RSEquipped.Range.Value then
                local List = {workspace.CurrentCamera, workspace.Ray_Ignore, workspace.Map.Ignore, workspace.Map.Items, workspace.Map.TGCSpawns, workspace.Map.TRCSpawns}

                for _,v in game.Players:GetPlayers() do
                    if v.Character then
                        table.insert(List, v.Character)
                    end
                end
                for _,v in workspace:GetChildren() do
                    if string.find(v.Name, "'s ") then
                        table.insert(List, v)
                    end
                end

                local RaycastParams = RaycastParams.new()
                RaycastParams.FilterDescendantsInstances = List
                RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                RaycastParams.IgnoreWater = true

                local Raycast = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, Target - workspace.CurrentCamera.CFrame.Position, RaycastParams)

                if Toggles.MG_ignorewalls.Value or not Raycast then
                    local Magnitude = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                    if Magnitude < MinimumDistance then
                        Character = Player.Character
                        Position = Target
                        MinimumDistance = Magnitude
                    end
                end
            end
        end
    end

    return Position, Character
end

function PlayerClosest()
    local Position, Character

    for _, Player in game.Players:GetPlayers() do
        if Player ~= LocalPlayer and Player:FindFirstChild("Status") and Player.Status.Team.Value ~= LocalPlayer.Status.Team.Value and Player.Character and Player.Character:FindFirstChild("Hitbox") then

            local List = {workspace.CurrentCamera, workspace.Ray_Ignore, workspace.Map.Ignore, workspace.Map.Items, workspace.Map.TGCSpawns, workspace.Map.TRCSpawns}

            for _,v in game.Players:GetPlayers() do
                if v.Character then
                    table.insert(List, v.Character)
                end
            end
            for _,v in workspace:GetChildren() do
                if string.find(v.Name, "'s ") then
                    table.insert(List, v)
                end
            end

            local RaycastParams = RaycastParams.new()
            RaycastParams.FilterDescendantsInstances = List
            RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
            RaycastParams.IgnoreWater = true

            local Raycast = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, Player.Character.Hitbox.Position - workspace.CurrentCamera.CFrame.Position, RaycastParams)

            if Toggles.MG_ignorewalls.Value or not Raycast then
                if Position then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - Player.Character.Hitbox.Position).Magnitude < (Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude then
                        Character = Player.Character
                        Position = Character.Hitbox.Position
                    end
                else
                    Character = Player.Character
                    Position = Character.Hitbox.Position
                end
            end
        end
    end

    return Position, Character
end

function CalculateArc(OriginPositon, TargetPosition, ProjectileVelocity, ProjectileGravity, YBoost)
    local Angle = (TargetPosition - OriginPositon).unit - Vector3.new(0, YBoost / ProjectileVelocity, 0)
    local Time = (TargetPosition - OriginPositon).Magnitude / ProjectileVelocity

    local ExpectedPositionY = OriginPositon.Y + (Angle.Y * ProjectileVelocity) * Time - -0.5 * ProjectileGravity * Time^2

    return Vector3.new(0, (ProjectileGravity == 0 and 0 or ExpectedPositionY), 0)
end

-- Code

local RenderStepped = game:GetService("RunService").RenderStepped:Connect(function()
    do Visuals() end
    if LocalPlayer.Character:GetAttribute("EquippedWeapon") ~= "" then
        RSEquipped = game.ReplicatedStorage.Weapons[LocalPlayer.Character:GetAttribute("EquippedWeapon")]
    end
    if RSEquipped then
        WeaponType = (RSEquipped:FindFirstChild("Projectile") and 2 or (RSEquipped:FindFirstChild("Melee") and 3 or 1))
    end

    if Toggles.MM_speedmod.Value and Options.MM_speedmodkey:GetState() then
        LocalPlayer.Character:SetAttribute("Speed", Options.MM_speedmodval.Value)
    end

    if Toggles.MM_nobhopcap.Value then
        LocalPlayer.Character:SetAttribute("SpeedCap", 9e9)
    end

    if Toggles.AG_aimtoggle.Value and Options.AG_aimtogglekey:GetState() and LocalPlayer.Character:GetAttribute("EquippedWeapon") then

        local AllowedShoot = false

        --[[
            1 = Normal hitscan
            2 = Projectile
            3 = Melee
        ]]

        local Position, Player
        if WeaponType == 1 then
            if not RSEquipped:FindFirstChild("FM") then
                Position, Player = PlayerFOV(Options.AG_aimhitbox.Value)
            end
        elseif WeaponType == 2 then
            Position, Player = PlayerProjFOV(RSEquipped.Name)
        else
            Position, Player = PlayerClosest()
        end

        if LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.equipping.Value then
            return
        end

        if RSEquipped.Name == "Poachers Pride" and (tick() - LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.shoottick.Value) < 1 then
            return
        end

        if Position then
            if WeaponType == 1 then
                if RSEquipped:FindFirstChild("LMG") then
                    if LocalPlayer.Character:GetAttribute("FullySpunUp") then
                        AllowedShoot = true
                    end
                else
                    AllowedShoot = true
                end
            elseif WeaponType == 2 and Projectiles[RSEquipped.Name] then
                -- temporary

                --[[
                local ProjectileSpawnPosition = (workspace.CurrentCamera.CFrame * Projectiles[RSEquipped.Name].CFrameOffset).Position

                local List = {workspace.CurrentCamera, workspace.Ray_Ignore, workspace.Map.Ignore, workspace.Map.Items, workspace.Map.TGCSpawns, workspace.Map.TRCSpawns}
                for _,v in game.Players:GetPlayers() do
                    if v.Character then
                        table.insert(List, v.Character)
                    end
                end

                local RaycastParams = RaycastParams.new()
                RaycastParams.FilterDescendantsInstances = List
                RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                RaycastParams.IgnoreWater = true

                local Distance = (ProjectileSpawnPosition - Player.Position).Magnitude
                local Speed = Distance / Projectiles[RSEquipped.Name].Speed + (Ping * 2)

                for _=1,(Options.AP_projectileaccuracy.Value) do
                    local Temp = Player.Character.Hitbox.Position + (Player.Character.HumanoidRootPart.AssemblyLinearVelocity - Vector3.new(0,workspace.Gravity * (Speed/2),0)) * Speed

                    local Raycast = workspace:Raycast(Player.Character.HumanoidRootPart.Position + (Vector3.new(Player.Character.HumanoidRootPart.AssemblyLinearVelocity.X,0,Player.Character.HumanoidRootPart.AssemblyLinearVelocity.Z) * Speed), Vector3.new(0,-1000,0), RaycastParams)
                    if Raycast and (Raycast.Position.Y + 3) > Temp.Y then
                        Temp = Vector3.new(Temp.X,Raycast.Position.Y + 1,Temp.Z)
                    end

                    Distance = (ProjectileSpawnPosition - Temp).Magnitude
                    Speed = Distance / Projectiles[RSEquipped.Name].Speed + (Ping * 2)
                end

                local Temp = Player.Character.Hitbox.Position + (Player.Character.HumanoidRootPart.AssemblyLinearVelocity - Vector3.new(0,workspace.Gravity * (Speed/2),0)) * Speed

                local PredctionPosition
                local Raycast = workspace:Raycast(Player.Character.HumanoidRootPart.Position + (Vector3.new(Player.Character.HumanoidRootPart.AssemblyLinearVelocity.X,0,Player.Character.HumanoidRootPart.AssemblyLinearVelocity.Z) * Speed), Vector3.new(0,-1000,0), RaycastParams)
                if Raycast and (Raycast.Position.Y + 3) > Temp.Y then
                    PredctionPosition = Vector3.new(Temp.X,Raycast.Position.Y + 1,Temp.Z)
                else
                    PredctionPosition = Temp
                end]]

                AllowedShoot = true
                --TempAimPosition = PredctionPosition -- + CalculateArc(ProjectileSpawnPosition, PredctionPosition, Projectiles[RSEquipped.Name].Speed, Projectiles[RSEquipped.Name].Gravity, Projectiles[RSEquipped.Name].Boost)
            elseif WeaponType == 3 then
                if RSEquipped:FindFirstChild("Backstab") then
                    local BackstabY = { 3, 1.5, 0, -1.5, -3 } -- ideal for above and below backstab damage

                    for _,v in BackstabY do
                        if (LocalPlayer.Character.Hitbox.Position - (Player.Hitbox.CFrame * CFrame.new(0, 0, 5)).Position + Vector3.new(0, v, 0)).Magnitude <= 4.75 then
                            AllowedShoot = true
                        end
                    end
                else
                    if (LocalPlayer.Character.Hitbox.Position - Position).Magnitude <= 10 then
                        AllowedShoot = true
                    end
                end
            end

            if AllowedShoot then
                AimPosition = Position
                if not Toggles.AG_aimsilent.Value then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, AimPosition)
                end

                require(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
            else
                AimPosition = nil
            end
        else
            AimPosition = nil
        end
    else
        AimPosition = nil
    end

    workspace.CurrentCamera.FieldOfView = (LocalPlayer.Character.Variables.ADS.Value and Options.VV_scopedfov.Value or Options.VV_fieldofview.Value)
end)

local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Script = getcallingscript()
    local Arguments = {...}

    if not Library.Unloaded then
        if Method == "Raycast" and AimPosition and not Script then
            local LookPosition = workspace.CurrentCamera.CFrame.LookVector
            local Spread = ((Arguments[2] / RSEquipped.Range.Value) - LookPosition)

            Arguments[2] = ((AimPosition - Arguments[1]).Unit + (WeaponType == 1 and Spread or Vector3.zero)) * RSEquipped.Range.Value

            return namecall(self, unpack(Arguments))

        elseif Method == "FireServer" then
            if self.Name == "UpdatePing" then
                Ping = Arguments[1]

            elseif self.Name == "CreateProjectile" and AimPosition then
                Arguments[select("#", ...)] = game
                Arguments[2] = AimPosition

                return namecall(self, unpack(Arguments))

            elseif self.Name == "ReplicateProjectile" and AimPosition then
                local Table = Arguments[1]
                local WeaponArg = Table[1]

                Table[select("#", ...)] = game
                Table[2] = AimPosition
                Table[1] = WeaponArg -- faggalicious hack fix

                Arguments[1] = Table
                return namecall(self, unpack(Arguments))

            elseif self.Name == "BeanBoozled" or self.Name == "WEGA" or (string.find(string.lower(self.Name), "ban") and not self.Name == "UseBanner") then

                if Toggles.MD_notifyblacklistedremotes.Value then
                    for i,v in Options.MD_blacklistedremotes.Value do
                        if i == self.Name then
                            warn("[ Bibulus ] Blacklisted remote blocked: ".. self.Name)
                            game.StarterGui:SetCore("SendNotification", { Title = "[ Bibulus ]", Text = "Blacklisted remote blocked: ".. self.Name, Duration = 5 })
                        elseif (string.find(string.lower(self.Name), "ban") and not self.Name == "UseBanner") and i == "Ban" then
                            warn("[ Bibulus ] Blacklisted remote blocked: ".. self.Name)
                            game.StarterGui:SetCore("SendNotification", { Title = "[ Bibulus ]", Text = "Blacklisted remote blocked: ".. self.Name, Duration = 5 })
                        end
                    end
                end

                return
            elseif self.Name == "FallDamage" and Toggles.ME_nofalldamage.Value then
                return
            end
        end
    end

    return namecall(self, ...)
end))

local index
index = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not Library.Unloaded then
        if Toggles.MG_ignorewalls.Value and key == "Clips" then
            return workspace.Map
        end
    end
    return index(self, key)
end))

for _,v in game.ReplicatedStorage.Weapons:GetChildren() do
    for _,x in v:GetChildren() do
        if x.Name == "Spread" or x.Name == "MaxSpread" or x.Name == "SpreadRecovery" or x.Name == "FireRate" then
            local Clone = x:Clone()
            Clone.Name = "_"
            Clone.Parent = x
        end
    end
end

local PrimaryAmmoChanged = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.ammocount:GetPropertyChangedSignal("Value"):Connect(function()
    if Toggles.MG_infiniteammo.Value then
        LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.ammocount.Value = game.ReplicatedStorage.Weapons[LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.primary.Value].Ammo.Value
    end
end)
local SecondaryAmmoChanged = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.ammocount2:GetPropertyChangedSignal("Value"):Connect(function()
    if Toggles.MG_infiniteammo.Value then
        LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.ammocount2.Value = game.ReplicatedStorage.Weapons[LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.secondary.Value].Ammo.Value
    end
end)
local PrimaryReserveAmmoChanged = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.primarystored:GetPropertyChangedSignal("Value"):Connect(function()
    if Toggles.MG_infinitereserveammo.Value then
        LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.primarystored.Value = game.ReplicatedStorage.Weapons[LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.primary.Value].StoredAmmo.Value
    end
end)
local SecondaryReserveAmmoChanged = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.secondarystored:GetPropertyChangedSignal("Value"):Connect(function()
    if Toggles.MG_infinitereserveammo.Value then
        LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.secondarystored.Value = game.ReplicatedStorage.Weapons[LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.secondary.Value].StoredAmmo.Value
    end
end)

Options.MG_fireratemultiplier:OnChanged(function()
    for _,v in game.ReplicatedStorage.Weapons:GetChildren() do
        for _,x in v:GetChildren() do
            if x.Name == "FireRate" then
                if v:FindFirstChild("Projectile") then
                    x.Value = math.clamp(x._.Value / Options.MG_fireratemultiplier.Value, 0.1, 9e9)
                else
                    x.Value = x._.Value / Options.MG_fireratemultiplier.Value
                end
            end
        end
    end
end)
Options.MG_dmgmultiplier:OnChanged(function()
    getsenv(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).returndamagemod = function()
        return Options.MG_dmgmultiplier.Value
    end
end)
Options.MG_spreadreduction:OnChanged(function()
    for _,v in game.ReplicatedStorage.Weapons:GetChildren() do
        for _,x in v:GetChildren() do
            if x.Name == "Spread" or x.Name == "MaxSpread" or x.Name == "SpreadRecovery" then
                x.Value = x._.Value * (1 - (Options.MG_spreadreduction.Value / 100))
            end
        end
    end
end)

local ID = game.Players:GetUserIdFromNameAsync(Options.VV_avatarvminput.Value)
local Character = game.Players:CreateHumanoidModelFromUserId(ID)

Options.VV_avatarvminput:OnChanged(function()
    ID = game.Players:GetUserIdFromNameAsync(Options.VV_avatarvminput.Value)
    Character = game.Players:CreateHumanoidModelFromUserId(ID)
end)

local DiedChanged = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.died:GetPropertyChangedSignal("Value"):Connect(function()
    task.wait(0.1)

    if Toggles.ME_instantrespawn.Value and LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.died.Value == true then
        game.ReplicatedStorage.Events.LoadCharacter:FireServer()
    end
end)

local InputBegan = game:GetService("UserInputService").InputBegan:Connect(function(inputObject, gameProcessed)
    if gameProcessed then return end

    if inputObject.KeyCode == Enum.KeyCode.Space and Toggles.MM_autobhop.Value then
        local Heartbeat = game:GetService("RunService").Heartbeat:connect(function()
            if LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables.spinuptick.Value < 1 and LocalPlayer.Character:GetAttribute("Speed") > 0 then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end)

        while game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) and Toggles.MM_autobhop.Value do task.wait() end
        Heartbeat:Disconnect()
    end
end)

local MusicAdded = workspace.Sounds.Music.ChildAdded:Connect(function(v)
    if Toggles.MG_ogbossthemes.Value then
        if v.Name == "Mad MechanicPlaying" then
            v.SoundId = MoreGunReversedID
            v.TimePosition = 30
            v.Volume = 0.33
        elseif v.Name == "Mad Mechanic IntroPlaying" then
            v.SoundId = MoreGunReversedID
        elseif v.Name == "Bloxy BoyPlaying" then
            v.SoundId = InterludeID
            v.Volume = 0.154
        end
    end
end)

local ArmsAdded = workspace.CurrentCamera.ChildAdded:Connect(function(z)
    if Toggles.VV_avatarviewmodel.Value and z.Name == "Arms" and z:IsA("Model") then
        local Arms = task.wait() and z
        
        local AvatarVM = Instance.new("Model", Arms)
        AvatarVM.Name = "AvatarVM"

        Instance.new("Humanoid", AvatarVM)

        if Character:FindFirstChild("Shirt") then
            local Clone = Character.Shirt:Clone()
            Clone.Parent = AvatarVM
        end

        for _,v in z.CSSArms:GetChildren() do
            if v.Name:match(" Arm") then
                for _,x in v:GetDescendants() do
                    if x:IsA("BasePart") then
                        x.Transparency = 1
                    end
                end

                local Clone = v:Clone()
                Clone.Parent = AvatarVM
                Clone.Material = "Plastic"
                Clone.MaterialVariant = ""
                Clone:ClearAllChildren()

                if v.Name == "LeftArm" then
                    local Arm = Character:FindFirstChild("LeftHand") or Character["Left Arm"]
                    Clone.Color = Arm.Color
                else
                    local Arm = Character:FindFirstChild("RightHand") or Character["Right Arm"]
                    Clone.Color = Arm.Color
                end

                Clone.Size = Vector3.new(0.29, 1.21, 0.29)
            end
        end

        for _,v in AvatarVM:GetChildren() do
            if v:IsA("BasePart") then
                local IsRight = (v.Name == "Right Arm")

                local Weld = Instance.new("Weld", z.CSSArms[v.Name])

                Weld.Part0 = z.CSSArms[v.Name]
                Weld.Part1 = v

                Weld.C1 = CFrame.Angles(math.rad(IsRight and 180 or 0), 0, math.rad(IsRight and -90 or 90))
            end
        end
    end
end)

-- Everything else

local MenuProperties = Tabs.Config:AddLeftGroupbox('Menu')

-- Bad idea to unload if beanboozled is getting spammed.

--[[
MenuProperties:AddButton('Unload', function()
    Library:Unload()
    Library.Unloaded = true

    RenderStepped:Disconnect()
    InputBegan:Disconnect()
    PrimaryAmmoChanged:Disconnect()
    SecondaryAmmoChanged:Disconnect()
    PrimaryReserveAmmoChanged:Disconnect()
    SecondaryReserveAmmoChanged:Disconnect()
    DiedChanged:Disconnect()
    PlayerAdded:Disconnect()
    MusicAdded:Disconnect()
    ArmsAdded:Disconnect()
end)
]]

MenuProperties:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', { Default = 'Delete', NoUI = true, Text = 'Menu keybind' }) 
MenuProperties:AddToggle("keybindmenu",{ Text = "Show Keybinds", Default = false, })
MenuProperties:AddDivider()
MenuProperties:AddToggle('Watermark', { Text = 'Show Watermark', Default = true }):OnChanged(function() Library:SetWatermarkVisibility(Toggles.Watermark.Value) end)
MenuProperties:AddDropdown("waterMarkSettingsDrop", {Values = {"Config Name", "Nickname", "Latency", "Current Time", "Framerate", "Week Day"}, Default = 0, Multi = true, Text = "Watermark Settings"})

Toggles.keybindmenu:OnChanged(function()
    Library.KeybindFrame.Visible = Toggles.keybindmenu.Value
end)

game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
	local Main = "bibulus.club"
	local NetworkPing = string.format("%0.0f", LocalPlayer:GetNetworkPing() * 1000)
	local DateTime = os.date('%I:%M:%S %p')

	local Split = " | "
	
	for k, _ in Options.waterMarkSettingsDrop.Value do
		if k == "Default" then
			Main = "bibulus.club" .. Main
		elseif k == "Default" then
			k = "Default"; value = true;
		end

		if k == "Config Name" then
			Main = Main .. Split .. "ConfigName"
		end

		if k == "Nickname" then
			Main = Main .. Split .. tostring(LocalPlayer.DisplayName)
		end

		if k == "Latency" then
			Main = Main .. Split .. NetworkPing .. " ms"
		end

		if k == "Current Time" then
			Main = Main .. Split .. DateTime
		end

		if k == "Framerate" then
			Main = Main .. Split .. math.floor(1 / deltaTime) .. " fps"
		end

		if k == "Week Day" then
			Main = Main .. Split .. os.date("%A")
		end
	end

	Library:SetWatermark(Main)
end)

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('bibulus.club')
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:SetLibrary(Library)
SaveManager:SetFolder('bibulus.club/TypicalColors2')
SaveManager:BuildConfigSection(Tabs.Config) 
SaveManager:IgnoreThemeSettings()
SaveManager:LoadAutoloadConfig()
