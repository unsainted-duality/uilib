-- FishhCheat rewrite 15th january 2025
-- if ur getting "vipsettings not found" error on swift (aka script not executing), that is a bug with swift. rejoin the game and execute again

repeat task.wait() until game:IsLoaded()
print("Script executed")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService('RunService')
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService('CoreGui')
local Lighting = game:GetService('Lighting')
local UIS = game:GetService('UserInputService')
local WatermarkVisible = true
local spin = 0
local AntiAngle = 0
local Ping 
local Target
local AimbotBind
local ProjPosition
local MouseLocation = UIS:GetMouseLocation()

local ScopeStorage = Instance.new("Folder")
ScopeStorage.Name = tostring(math.random(1000, 9999))
ScopeStorage.Parent = CoreGui

local PredictionSphere = Instance.new("Part")
PredictionSphere.Shape = Enum.PartType.Ball
PredictionSphere.Material = Enum.Material.SmoothPlastic
PredictionSphere.BrickColor = BrickColor.new("Lapis")
PredictionSphere.Transparency = 0.5
PredictionSphere.Parent = workspace
PredictionSphere.CanCollide = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = 750
FOVCircle.Color = Color3.new(255,255,255)
FOVCircle.Thickness = 1
FOVCircle.Filled = false

RepStorage.VIPSettings.NoTeamLimits.Value = true
RepStorage.VIPSettings.EnabledSpectator.Value = true
RepStorage.VIPSettings.NoVoiceCooldown.Value = true

if not Lighting:FindFirstChild('ColorCorrection') then
    Instance.new('ColorCorrectionEffect', Lighting)
end
Lighting.ColorCorrection.TintColor = Color3.fromRGB(153, 90, 198)
Lighting.ColorCorrection.Enabled = true

local ExpandableHitboxes = {
	"HeadHB",
	"RightUpperLeg",
	"Hitbox"
}

local Projectiles = { -- pasted from bibulus for convenience
    -- Trooper
    ["Rocket Launcher"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, -0.275),
        ["Speed"] = 68.75,
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
    ["Direct Hit"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 1.635),
        ["Speed"] = 123.75,
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.25, 0),
        ["Boost"] = 0
    },
	["Blackbox"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, -0.265),
        ["Speed"] = 68.75,
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
    ["Cow Mangler 5000"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.35),
        ["Speed"] = 68.75,
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
    ["G-Bomb"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.52),
        ["Speed"] = 44.6875,
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
    ["Original"] = {
        ["CFrameOffset"] = CFrame.new(0, -1, 1.191),
        ["Speed"] = 44.6875,
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
    ["Liberty Launcher"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1877, 1.3),
        ["Speed"] = 96.25,
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
    ["Maverick"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0),
        ["Speed"] = 68.75,
        ["Gravity"] = 15,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
    ["Airstrike"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1877, 1.3),
        ["Speed"] = (LocalPlayer.Character:FindFirstChild("RocketJumped") and 110 or 68.75),
        ["Gravity"] = 0,
		["Offset"] = Vector3.new(0, -2.5, 0),
        ["Boost"] = 0
    },
	-- Arsonist
	["Flare Gun"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.41),
        ["Speed"] = 125,
        ["Gravity"] = 10,
		["Offset"] = Vector3.new(0, 1, 0),
        ["Boost"] = 0
    },
    ["Detonator"] = {
        ["CFrameOffset"] = CFrame.new(0.75, -0.1875, 0.2),
        ["Speed"] = 125,
        ["Gravity"] = 10,
		["Offset"] = Vector3.new(0, 1, 0),
        ["Boost"] = 0
    },
	-- Doctor
    ["Syringe Crossbow"] = {
        ["CFrameOffset"] = CFrame.new(0.5, 0.1875, 0.5),
        ["Speed"] = 150,
        ["Gravity"] = 5, -- complete guess
		["Offset"] = Vector3.new(0, 1, 0),
        ["Boost"] = 0
    }
}

local Killsay = {
	"N00b down",
	"I've yet to meet one that can outsmart bullet.",
	'We call that "skill" around here boyo.',
	"EZ",
	"You must love that respawn timer.",
	"Hey, sometimes your opponent is just having a good day",
	"r u mobile player?",
	"The idiot store called, they're running out of YOU!",
	"Votekick by pressing M+9!",
	"Go to sleep.",
	"you are DED! not big surprise."
}

local Deathsay = {
	"That wasn't supposed to happen",
	"HACKER",
	"CHEATER CHEATER CHEATER",
	"reported to rolve developers",
	"Next time's the charm.",
	"This is rather embarrasing.",
	"YEEEEOUWCH",
	"It appears our team's doctor has quit."	
}


local ChatSpam = {
	"Not to worry team, I'm a garbage collector. I'm used to carrying trash.",
	"GET GOOD GET FISHHCHEAT",
	"I'm not hacking, i am just cheating.",
	"*JAMACIAN SMILE ACTIVATED* those who know...",
	"XATAWARE BEST HACK TC2 2023",
	"I bought a property in Egypt and what they do for you is they give you the property",
	"wait... why are we playing a chinese ripoff of TF2?",
	"FISH FOR PRESIDENT 2029",
	"--- SIGMAHACK EXECUTED ---",
	"game:GetService('Byfron'):Destroy() EZEZEZ BYPASS",
	"ain't no party like a bibulus party",
	"For every Fishhcheat purchase, we donate to Israel.",
	":3",
	"The FitnessGram Pacer test, ever heard of it?",
	"NONAMES RISE UP",
	"INJECTING ESTROGEN.DLL",
	":steamhappy:",
	":troll:",
	"give cool role pls",
	"hey chatgpt how do i install tc2 hack",
	"Sponsored by Omegatronic",
	"GOD TYCOON > TC2"			
}


local Tags = {
	[255] = "Holder (Game Owner)",
	[254] = "Game Developer",
	[253] = "Game Moderator",
	[252] = "Contributor",
	[251] = "Game Tester"
}

local MarkedPlayers = {
	[2747649884] = "YouTuber (Interstellis)",
	[120580188] = "YouTuber (Dr_Right2)",
	[160639365] = "YouTuber (c_asedy)",
	[90950464] = "YouTuber (7GM9)",
	[2857416922] = "YouTuber (Uncle Mike)",
	[3464520337] = "actually 14 yo"
}


local function RemoveShit(shit)
	if shit then
		print("Destroying unnecessary shit... " .. shit.Name)
		shit:Destroy()
	end
end

RemoveShit(LocalPlayer.PlayerGui.GUI.Indicators:FindFirstChild("SpawnHighlight"))
RemoveShit(LocalPlayer.PlayerGui.GUI.LocalEvents.DiceClient:FindFirstChild("EvilHighlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Agent:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Annihilator:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Arsonist:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Brute:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Doctor:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Flanker:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Marksman:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Mechanic:FindFirstChild("Highlight"))
RemoveShit(RepStorage.Other.ScaryMonsters.Trooper:FindFirstChild("Highlight")) -- Removing unecessary highlights

RemoveShit = nil

local repo = 'https://raw.githubusercontent.com/unsainted-duality/uilib/refs/heads/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = getgenv().Linoria.Options
local Toggles = getgenv().Linoria.Toggles

Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)
Library.ShowCustomCursor = true -- Toggles the Linoria cursor globaly (Default value = true)
Library.NotifySide = "Left" -- Changes the side of the notifications globaly (Left, Right) (Default value = Left)

local Window = Library:CreateWindow({
	Title = 'FishhCheat v2',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	Aim = Window:AddTab('Aim'),
	Visuals = Window:AddTab('Visuals'),
    Mods = Window:AddTab('Mods'),
	Automation = Window:AddTab('Automation'),
	Misc = Window:AddTab('Misc'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

local GB_Aimbot = Tabs.Aim:AddLeftGroupbox('Aimbot')
GB_Aimbot:AddToggle('AimbotToggle', { Text = 'Aimbot', Default = true, Tooltip = 'Aims at enemies'}):AddKeyPicker('AimbotBind', { Default = 'None', NoUI = false, Mode = 'Always', Text = 'Aimkey' })
GB_Aimbot:AddToggle('ProjAimbotToggle', { Text = 'Projectile Aimbot (BETA)', Default = true, Tooltip = '*Attempts* to predict player movement for projectile weapons\nUse hitbox expander for grenade launchers.'})
GB_Aimbot:AddToggle('SilentAimbot', { Text = 'Silent', Default = true, Tooltip = 'Aimbot flicks will not be visible, serverside or clientside.'})
GB_Aimbot:AddDropdown("TargetPart", {Values = {'Head', 'UpperTorso', 'HumanoidRootPart'}, Default = 1, Multi = false, Text = "Aimbot Part"})
GB_Aimbot:AddToggle('AimbotAutoShoot', { Text = 'Autoshoot', Default = false, Tooltip = 'Automatically shoots when aimbot finds a target'})
GB_Aimbot:AddDivider()
--GB_Aimbot:AddToggle('AimbotOnlyVis', { Text = 'Wallcheck', Default = true, Tooltip = 'Only aims at visible enemies (autodisabled when wallbang is turned on!)'})
GB_Aimbot:AddToggle('AimbotOnlyFOVVis', { Text = 'FOV Check', Default = false, Tooltip = 'Only aims at enemies within FOV'})
GB_Aimbot:AddSlider('AimbotFOV', {Text = 'FOV', Default = 60, Min = 1, Max = 90, Rounding = 2, Compact = true})
GB_Aimbot:AddToggle('AimbotShowFOV', { Text = 'Show FOV Circle', Default = false, Tooltip = 'Draw FOV Circle on screen'})
--GB_Aimbot:AddDivider() -- FINISH THIS!
--GB_Aimbot:AddToggle('AimbotLegitMelee', { Text = 'Legit Melee', Default = true, Tooltip = 'Enable distance check for melee'})

local GB_Hitbox = Tabs.Aim:AddRightGroupbox('Hitbox')
GB_Hitbox:AddToggle('HBEToggle', { Text = 'Hitbox Expander', Default = false, Tooltip = 'Toggle hitbox expanding'}):AddKeyPicker('HBEBind', { Default = 'None', NoUI = false, Mode = 'Always', Text = 'HBE Key' })
GB_Hitbox:AddDivider()
GB_Hitbox:AddToggle('HBEPlayerToggle', {Text = 'Player Hitbox Expander', Default = true, Tooltip = 'Toggle player hitbox expander'})
GB_Hitbox:AddSlider('HBEPlayerSize', {Text = 'Size', Default = 10, Min = 2, Max = 25, Rounding = 2, Compact = true})
GB_Hitbox:AddDropdown("HBEPlayerParts", {Values = ExpandableHitboxes, AllowNull = true, Default = {}, Multi = true, Text = "Expand Parts"})
GB_Hitbox:AddToggle('HBEBuildingToggle', {Text = 'Building Hitbox Expander', Default = true, Tooltip = 'Toggle building hitbox expander'})
GB_Hitbox:AddSlider('HBEBuildingSize', {Text = 'Size', Default = 10, Min = 2, Max = 25, Rounding = 2, Compact = true})
local GB_Ignore = Tabs.Aim:AddRightGroupbox('Ignore')
--GB_Ignore:AddToggle('AimIgnoreTeam', {Text = 'Ignore Teammates', Default = true, Tooltip = '(applies for both HBE and aimbot)'})
GB_Ignore:AddToggle('AimIgnoreInvis', {Text = 'Ignore Invisible', Default = true, Tooltip = '(applies for both HBE and aimbot)'})
GB_Ignore:AddToggle('AimIgnoreFriends', {Text = 'Ignore Friends/Ignored', Default = true, Tooltip = '(applies for both HBE and aimbot)'})


local GB_ESP = Tabs.Visuals:AddLeftGroupbox('ESP')
local GB_View = Tabs.Visuals:AddRightGroupbox('View')
local GB_World = Tabs.Visuals:AddRightGroupbox('World')
GB_ESP:AddToggle('BoundingBox', { Text = 'Box', Default = false, Tooltip = 'Draws boxes around players'}):AddColorPicker('BoundingBoxDefaultColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'Box Color'})
GB_ESP:AddToggle('BoxTeamCheck', { Text = 'Team Check', Default = false, Tooltip = 'Teamcheck for boxes'}):AddColorPicker('RedBoxColor', {Default = Color3.fromRGB(224, 64, 62), Transparency = nil, Title = 'Enemy Box Color'}):AddColorPicker('GreenBoxColor', {Default = Color3.fromRGB(74, 172, 40), Transparency = nil, Title = 'Friendly Box Color'})
GB_ESP:AddSlider('BoxFillTransparency', {Text = 'Transparency', Default = 0.2, Min = 0, Max = 1, Rounding = 2, Compact = true})
GB_ESP:AddDivider()
GB_ESP:AddToggle('Chams', { Text = 'Chams', Default = true, Tooltip = 'Toggles chams'}):AddColorPicker('ChamsFillColor', {Default = Color3.fromRGB(176, 141, 247), Title = 'Fill Color'}):AddColorPicker('ChamsOutlineColor', {Default = Color3.fromRGB(132, 84, 229), Title = 'Outline Color'})
GB_ESP:AddToggle('ChamsTeamCheck', { Text = 'Team Check', Default = true, Tooltip = 'Toggles chams team check'}):AddColorPicker('RedChamsColor', {Default = Color3.fromRGB(224, 64, 62), Transparency = nil, Title = 'RED Team Chams Color'}):AddColorPicker('GreenChamsColor', {Default = Color3.fromRGB(74, 172, 40), Transparency = nil, Title = 'Green Team Chams Color'})
GB_ESP:AddToggle('ChamsDepthMode', { Text = 'Always on top', Default = true, Tooltip = 'Toggles depth mode between always on top or occluded'})
GB_ESP:AddSlider('ChamsFillTransparency', {Text = 'Fill Transparency', Default = 0.4, Min = 0, Max = 1, Rounding = 2, Compact = true})
GB_ESP:AddSlider('ChamsOutlineTransparency', {Text = 'Outline Transparency', Default = 0.3, Min = 0, Max = 1, Rounding = 2, Compact = true})
GB_ESP:AddDivider()
GB_ESP:AddToggle('HealthBar', { Text = 'Health Bar', Default = true, Tooltip = 'Show healthbar by enemies'}):AddColorPicker('HealthBarColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'Health Bar Color'})
--GB_ESP:AddToggle('SnapLine', { Text = 'Tracer', Default = false, Tooltip = 'Toggles the tracer visual option'}):AddColorPicker('TracerColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'Tracer Color'})
GB_ESP:AddToggle('ViewTracer', { Text = 'View Tracer', Default = false, Tooltip = "Show players' view tracer"}):AddColorPicker('ViewTracerColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'View Tracer Color'})
--GB_ESP:AddToggle('HeadCircle', { Text = 'Head Circle', Default = false, Tooltip = 'Toggles the head circle visual option'}):AddColorPicker('HeadCircleColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'Head Circle Color'})
GB_ESP:AddToggle('Names', { Text = 'Name', Default = false, Tooltip = "Show players' name"}):AddColorPicker('NamesColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'Name Text Color'})
GB_ESP:AddToggle('Weapon', { Text = 'Weapon', Default = false, Tooltip = "Show what weapon a player is holding"}):AddColorPicker('WeaponsColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'Weapon Text Color'})
GB_ESP:AddToggle('Distance', { Text = 'Distance', Default = false, Tooltip = "Show players' distance"}):AddColorPicker('DistanceColor', {Default = Color3.fromRGB(255, 255, 255), Transparency = nil, Title = 'Distance Text Color'})
GB_ESP:AddDivider()
GB_ESP:AddToggle('ESPOutlines', { Text = 'Outlines', Default = false, Tooltip = 'Toggles outlines on ESP'})
GB_ESP:AddToggle('ESPTeammates', { Text = 'Teammates', Default = false, Tooltip = 'Toggles whether or not the ESP is visible on teammates too'})
--GB_ESP:AddDropdown("TracerOrigin", {Values = {'Bottom', 'Center', 'Top', 'Head', 'HumanoidRootPart'}, Default = 1, Multi = false, Text = 'Tracer Origin'})
--GB_ESP:AddDropdown("TracerTarget", {Values = {'HumanoidRootPart', 'Head', 'Legs', 'Feet', 'Penis'}, Default = 1, Multi = false, Text = 'Tracer Target'})
GB_ESP:AddSlider('ViewTracerDistance', {Text = 'View Tracer Distance', Default = 2, Min = 0, Max = 10, Rounding = 1, Suffix = ' studs', Compact = false})
GB_ESP:AddSlider('TextSize', {Text = 'Text Size', Default = 13, Min = 0, Max = 50, Rounding = 0, Suffix = '', Compact = false})
GB_ESP:AddSlider('TextFont', {Text = 'Text Font', Default = 1, Min = 0, Max = 3, Rounding = 0, Suffix = '', Compact = false})
GB_View:AddToggle('customfov', { Text = 'FOV Modifications', Default = true, Tooltip = 'Toggles FOV Modifications'})
GB_View:AddSlider('customfovamount', { Text = '', Default = 90, Min = 0, Max = 120, Rounding = 0, Suffix = '°/120°', Compact = true})
GB_World:AddToggle('ColorCorrectionToggle', { Text = 'Color Correction', Default = true, Tooltip = 'Overlay color on screen'}):AddColorPicker('ColorCorrection', {Default = Color3.fromRGB(153, 90, 198), Title = 'Color'})
GB_World:AddToggle('NightMode', { Text = 'Night Mode', Default = true, Tooltip = 'Night mode!'})
GB_World:AddDropdown("LightingTechnology", {Values = {'Voxel', 'ShadowMap', 'Legacy', 'Future', 'Compatibility'}, Default = 2, Multi = false, Text = "Lighting Technology"})
GB_World:AddDivider()
GB_World:AddToggle('ThirdPerson', { Text = 'Third Person', Default = true, Tooltip = 'Toggle on/off using F5 key'})

-- FOV
Toggles.customfov:OnChanged(function()
    Camera.FieldOfView = Options.customfovamount.Value
end)
Options.customfovamount:OnChanged(function()
    if Toggles.customfov.Value then
        Camera.FieldOfView = Options.customfovamount.Value
    end
end)
Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
	if Toggles.customfov.Value then
		Camera.FieldOfView = Options.customfovamount.Value
	end
end)

Toggles.ThirdPerson:OnChanged(function()
    RepStorage.VIPSettings.AThirdPersonMode.Value = Toggles.ThirdPerson.Value
end)

local GB_PlayerMods = Tabs.Mods:AddLeftGroupbox('Player Mods')
GB_PlayerMods:AddToggle('BHop', { Text = 'Auto Bunny Hop', Default = true, Tooltip = 'Bunny hop by holding jump key'})
GB_PlayerMods:AddToggle('NoBHopCap', { Text = 'No Bunny Hop Cap', Default = false, Tooltip = 'Unlock speed cap while bunnyhopping'})
GB_PlayerMods:AddToggle('NoSlowdown', { Text = 'No slowdown', Default = false, Tooltip = 'No slowdown when revving, scoping etc.'})
GB_PlayerMods:AddDivider()
GB_PlayerMods:AddToggle('SpeedMod', { Text = 'Speed modifier', Default = false, Tooltip = 'Modify player speed'})
GB_PlayerMods:AddSlider('SpeedAmount', {Text = 'Speed', Default = 500, Min = 100, Max = 2000, Rounding = 2, Compact = true})
GB_PlayerMods:AddToggle('JumpMod', { Text = 'Jump modifier', Default = false, Tooltip = 'Modify player jump height'})
GB_PlayerMods:AddSlider('JumpAmount', {Text = 'Power', Default = 100, Min = 50, Max = 200, Rounding = 2, Compact = true})

Toggles.BHop:OnChanged(function()
    RepStorage.VIPSettings.SpeedDemon.Value = Toggles.BHop.Value
end)
Toggles.JumpMod:OnChanged(function()
    LocalPlayer.Character.Humanoid.UseJumpPower = Toggles.JumpMod.Value
end)
Options.JumpAmount:OnChanged(function()
    LocalPlayer.Character.Humanoid.JumpPower = Options.JumpAmount.Value
end)

local GB_WeaponMods = Tabs.Mods:AddLeftGroupbox('Weapon Mods')
GB_WeaponMods:AddToggle('AlwaysBackstab', { Text = 'Always Backstab', Default = false, Tooltip = 'Always backstab as Agent'})
GB_WeaponMods:AddToggle('Wallbang', { Text = 'Wallbang', Default = false, Tooltip = 'Shoot through walls'})
GB_WeaponMods:AddToggle('NoSpread', { Text = 'No Spread', Default = false, Tooltip = 'No spread for most weapons'})
--GB_WeaponMods:AddToggle('InfDamage', { Text = 'Infinite Damage', Default = false, Tooltip = 'All weapons insta-kill'})
GB_WeaponMods:AddToggle('InfAmmo', { Text = 'Infinite Ammo', Default = false, Tooltip = 'Infinite ammo on all weapons'})
GB_WeaponMods:AddToggle('InfCloak', { Text = 'Infinite Cloak', Default = false, Tooltip = 'Infinite cloak for Agent'})
GB_WeaponMods:AddToggle('InfCharge', { Text = 'Infinite Shield Charge', Default = false, Tooltip = 'Infinite charge for Annihilator shields'})
GB_WeaponMods:AddToggle('MaxBuildings', { Text = 'Instant LVL 3 Buildings', Default = false, Tooltip = "Mechanic buildings will instantly be lvl 3 once deployed"})
GB_WeaponMods:AddToggle('FirerateChanger', { Text = 'Firerate Modifier', Default = false, Tooltip = 'Modify the firerate of most weapons'})
GB_WeaponMods:AddSlider('FirerateAmount', {Text = 'Firerate', Default = 0.2, Min = 0.1, Max = 1, Rounding = 2, Compact = true})

Toggles.AlwaysBackstab:OnChanged(function() -- Always Backstab
    if Toggles.AlwaysBackstab.Value then
        if RepStorage.Functions:FindFirstChild('UpdateSettings') then
            RepStorage.Functions.UpdateSettings:Destroy()
            LocalPlayer.PlayerConfig:SetAttribute('PowerEffects_AlwaysBackstab', true)
        end
    else
        if not RepStorage.Functions:FindFirstChild('UpdateSettings') then
            LocalPlayer.PlayerConfig:SetAttribute('PowerEffects_AlwaysBackstab', nil)
            local NewUpdateSettings = Instance.new('RemoteFunction')
            NewUpdateSettings.Name = 'UpdateSettings'
            NewUpdateSettings.Parent = RepStorage.Functions
        end
    end 
end)


local LegacyLocalVariables = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables

LegacyLocalVariables.currentspread:GetPropertyChangedSignal('Value'):Connect(function()
    if Toggles.NoSpread.Value then
        LegacyLocalVariables.currentspread.Value = 0
    end
end)
Toggles.NoSpread:OnChanged(function()
    if Toggles.NoSpread.Value then
        LegacyLocalVariables.currentspread.Value = 0
    end
end)

LegacyLocalVariables.ammocount:GetPropertyChangedSignal('Value'):Connect(function()
    if Toggles.InfAmmo.Value and LocalPlayer.Character:GetAttribute("EquippedWeapon") ~= '' then
        if RepStorage.Weapons:FindFirstChild(LocalPlayer.Character:GetAttribute("EquippedWeapon")):FindFirstChild('SniperThing') then
            -- This is checking to see if we are using a sniper rifle. InfAmmo on rifles causes it to shoot fast, and is detected by serverside anticheat.
            LegacyLocalVariables.ammocount.Value = 25
        else
            LegacyLocalVariables.ammocount.Value = RepStorage.Weapons:FindFirstChild(LocalPlayer.Character:GetAttribute("EquippedWeapon")).Ammo.Value
        end
    end
end)
LegacyLocalVariables.ammocount2:GetPropertyChangedSignal('Value'):Connect(function()
    if Toggles.InfAmmo.Value and LocalPlayer.Character:GetAttribute("EquippedWeapon") ~= '' then
        LegacyLocalVariables.ammocount2.Value = RepStorage.Weapons:FindFirstChild(LocalPlayer.Character:GetAttribute("EquippedWeapon")).Ammo.Value
    end
end)
LegacyLocalVariables.baseballs:GetPropertyChangedSignal('Value'):Connect(function()
    if Toggles.InfAmmo.Value then
        LegacyLocalVariables.baseballs.Value = 1
    end
end)
LegacyLocalVariables.cloakleft:GetPropertyChangedSignal('Value'):Connect(function()
    if Toggles.InfCloak.Value then
        LegacyLocalVariables.cloakleft.Value = 10
    end
end)
LegacyLocalVariables.chargeleft:GetPropertyChangedSignal('Value'):Connect(function()
    if Toggles.InfCharge.Value then
		if LegacyLocalVariables.Held2.Value then
			LegacyLocalVariables.chargeleft.Value = 30
		--else
		--	LegacyLocalVariables.chargeleft.Value = 100
		end
    end
end)

LegacyLocalVariables.Held2:GetPropertyChangedSignal("Value"):Connect(function() -- this code is so you can actually stop charging with infinite charge
	if not LegacyLocalVariables.Held2.Value and Toggles.InfCharge.Value then
		LegacyLocalVariables.chargeleft.Value = 0
		task.wait(0.1)
		LegacyLocalVariables.chargeleft.Value = 100
	end
end)

local GB_Auto = Tabs.Automation:AddLeftGroupbox('Automation') 
GB_Auto:AddToggle('AutoUber', { Text = 'Auto Uber', Default = false, Tooltip = 'Automatically uber when under health %'})
GB_Auto:AddSlider('AutoUberPerc', {Text = 'Percentage', Default = 40, Min = 5, Max = 95, Rounding = 2, Compact = true})
GB_Auto:AddDropdown("AutoUberCond", {Values = {"Only care about me", "Only care about players I heal", "Both"}, Default = 3, Multi = false, Text = "Condition"})
GB_Auto:AddDivider()
GB_Auto:AddToggle('AutoDetonate', { Text = 'Auto Detonate', Default = false, Tooltip = 'Automatically detonate stickies'})
GB_Auto:AddToggle('AutoDetonateBld', { Text = 'Include Buildings', Default = false, Tooltip = 'Auto Detonate will detonate for mechanic buildings'})
GB_Auto:AddSlider('AutoDetonateRange', {Text = 'Range', Default = 9.125, Min = 9, Max = 20, Rounding = 2, Compact = true})
GB_Auto:AddDivider()
GB_Auto:AddToggle('AutoAirblast', { Text = 'Auto Airblast', Default = false, Tooltip = 'Automatically airblast projectiles'})
GB_Auto:AddToggle('AutoAirblastExt', { Text = 'Extinguish teammates', Default = false, Tooltip = 'Auto Airblast will extinguish teammates'})

local GB_Spam = Tabs.Automation:AddRightGroupbox('Spam')
GB_Spam:AddToggle('ChatSpamToggle', { Text = 'Chat Spam', Default = false, Tooltip = 'Spam random shit in chat lol'})
GB_Spam:AddSlider('ChatSpamDelay', {Text = 'Delay (s)', Default = 5, Min = 2, Max = 15, Rounding = 2, Compact = true})
GB_Spam:AddToggle('Killsay', { Text = 'Killsay', Default = false, Tooltip = 'Send a chat message for each kill'})
GB_Spam:AddToggle('Deathsay', { Text = 'Deathsay', Default = false, Tooltip = 'Send a chat message for each death'})
GB_Spam:AddToggle('NoVoiceCooldown', { Text = 'No Voice Cooldown', Default = true, Tooltip = 'No cooldown for voicelines'})

local GB_Objective = Tabs.Automation:AddRightGroupbox('Objective')
GB_Objective:AddButton('Instant CTF Cap', function()
	if workspace.Map:FindFirstChild("Briefcases") and not (LegacyLocalVariables.died.Value or LocalPlayer.Status.Team.Value == "Spectator") then
		for i = 0, 3 do -- one more bonus time just in case
			if LocalPlayer.Status.Team.Value == "TRC" then
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.Green, 1) -- solara actually supports firetouchinterest! dats cool ig
				task.wait(0.025)
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.Green, 0)
				task.wait(0.025)
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.RedTrigger, 1)
				task.wait(0.025)
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.RedTrigger, 0)
				task.wait(0.025)
			else
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.Red, 1)
				task.wait(0.025)
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.Red, 0)
				task.wait(0.025)
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.GreenTrigger, 1)
				task.wait(0.025)
				firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Map.Briefcases.GreenTrigger, 0)
				task.wait(0.025)
			end
		end
	else
		Library:Notify("You must be spawned in and on a CTF map!", nil, 4590657391)
	end
end)

local GB_Multibox = Tabs.Automation:AddRightGroupbox('Multiboxing')
GB_Multibox:AddToggle('Followbot', { Text = 'Followbot', Default = false, Tooltip = 'Constantly teleports to chosen player'})
GB_Multibox:AddDropdown("FollowbotPlayer", {SpecialType = "Player", Text = "Player"})

LocalPlayer.ScoreFolder:GetAttributeChangedSignal("Kills"):Connect(function() -- Killsay
    if LocalPlayer.ScoreFolder:GetAttribute("Kills") == 0 or not Toggles.Killsay.Value then return end
	RepStorage.Events.ChatMessage:FireServer(Killsay[math.random(1, #Killsay)], false)
end)
Toggles.NoVoiceCooldown:OnChanged(function()
	RepStorage.VIPSettings.NoVoiceCooldown.Value = Toggles.NoVoiceCooldown.Value
end)

local GB_Removals = Tabs.Misc:AddLeftGroupbox('Removals')
GB_Removals:AddToggle('NoFallDamage', {Text = 'No Fall Damage', Default = true, Tooltip = 'Block the remote for Fall Damage'})
GB_Removals:AddToggle('NoSniperScope', {Text = 'No Rifle Scope', Default = false, Tooltip = "No scope when zooming in"})
GB_Removals:AddToggle('NoSniperBeam', {Text = 'No Rifle Beam', Default = false, Tooltip = "Block the remote for the rifle's beam (serversided)"})
GB_Removals:AddToggle('NoUndisguise', {Text = 'No Undisguising After Attack', Default = false, Tooltip = 'Block the remote for undisguising'})
GB_Removals:AddToggle('NoSelfDamage', {Text = 'No Self Melee Damage', Default = false, Tooltip = 'No more self damage for certain melees'})
GB_Removals:AddToggle('InstantRespawn', {Text = 'No Respawn Cooldown', Default = false, Tooltip = 'aka Instant Respawn'})

Toggles.NoSniperScope:OnChanged(function()
	if Toggles.NoSniperScope.Value then
		for i,v in pairs(LocalPlayer.PlayerGui.HUDGui.Crosshairs.Scope:GetChildren()) do
			if v.Name ~= 'ACTION_WEPFIRE' then
				v.Parent = ScopeStorage
			end
		end
	else
		for i,v in pairs(ScopeStorage:GetChildren()) do
			v.Parent = LocalPlayer.PlayerGui.HUDGui.Crosshairs.Scope
		end	
	end
end)

LegacyLocalVariables.died:GetPropertyChangedSignal('Value'):Connect(function() 
	if LegacyLocalVariables.died.Value then
		task.wait(0.1)
		if Toggles.InstantRespawn.Value then -- Instant Respawn
			RepStorage.Events.LoadCharacter:FireServer()
		end
		if Toggles.Deathsay.Value then -- Deathsay
			RepStorage.Events.ChatMessage:FireServer(Deathsay[math.random(1, #Deathsay)], false)
		end
	end
end)

local GB_Anticheat = Tabs.Misc:AddLeftGroupbox('Anticheat')
GB_Anticheat:AddToggle('AnticheatBypass', {Text = 'Bypass Clientside Anticheat', Default = true, Tooltip = 'Attempts to bypass clientside anticheat.'})
GB_Anticheat:AddToggle('NotifyBypass', {Text = 'Notify blocked remotes', Default = true, Tooltip = 'Give notification when the bypass successfully blocks a ban attempt'})

local GB_Fun = Tabs.Misc:AddLeftGroupbox('Fun')
GB_Fun:AddToggle('Spinbot', {Text = 'Spin Bot', Default = false, Tooltip = 'Spins your character around'})
GB_Fun:AddSlider('SpinbotSpeed', {Text = 'Speed', Default = 1, Min = 0.1, Max = 20, Rounding = 2, Compact = true})

Toggles.Spinbot:OnChanged(function() -- due to thirdperson camera breaking if u set autorotate true every frame
	if not Toggles.Spinbot.Value then
		LocalPlayer.Character.Humanoid.AutoRotate = true 
	end
end)

local GB_MarkingPlayers = Tabs.Misc:AddRightGroupbox('Marking Players')
GB_MarkingPlayers:AddDropdown("MarkedPlayer", {SpecialType = "Player", Text = "Player"})
GB_MarkingPlayers:AddButton('Mark player', function()
	if Players:GetUserIdFromNameAsync(Options.MarkedPlayer.Value) and Options.MarkedPlayer.Value ~= LocalPlayer.Name then
		MarkedPlayers[Players:GetUserIdFromNameAsync(Options.MarkedPlayer.Value)] = "Marked"
		Library:Notify("Marked player " .. Options.MarkedPlayer.Value)
	end	
end)
GB_MarkingPlayers:AddButton('Ignore player', function()
	if Players:GetUserIdFromNameAsync(Options.MarkedPlayer.Value) and Options.MarkedPlayer.Value ~= LocalPlayer.Name then
		MarkedPlayers[Players:GetUserIdFromNameAsync(Options.MarkedPlayer.Value)] = "Ignored"
		Library:Notify("Ignoring player " .. Options.MarkedPlayer.Value)
	end	
end)
GB_MarkingPlayers:AddButton('Unmark player', function()
	if Players:GetUserIdFromNameAsync(Options.MarkedPlayer.Value) and Options.MarkedPlayer.Value ~= LocalPlayer.Name then
		MarkedPlayers[Players:GetUserIdFromNameAsync(Options.MarkedPlayer.Value)] = nil
		Library:Notify("Unmarked player " .. Options.MarkedPlayer.Value)
	end	
end)
GB_MarkingPlayers:AddDivider()
GB_MarkingPlayers:AddToggle('NotifMarked', {Text = 'Notify join/leaving', Default = true, Tooltip = 'Notify marked players joining or leaving'})
GB_MarkingPlayers:AddToggle('NotifClass', {Text = 'Notify other changes', Default = true, Tooltip = 'Notify marked player changing class or team'})



task.spawn(function()
	while task.wait() do
		local state = Options.AimbotBind:GetState()
		if state then -- Idk why this is necessary, but it breaks without it.
			AimbotBind = true
		else
			AimbotBind = false
		end

		if Library.Unloaded then break end
	end
end)

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local Stats = game:GetService('Stats')

local WatermarkConnection = RunService.RenderStepped:Connect(function()
	FrameCounter = FrameCounter + 1; -- cuz of moonsec being retarded
	Ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;
	if WatermarkVisible then
		Library:SetWatermark(('FishhCheat v2 | %s fps | %s ms'):format(
			math.floor(FPS),
			math.floor(Ping)
		));
	end
end);

Library.KeybindFrame.Visible = true;

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Unloaded!')
	Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })
MenuGroup:AddToggle("ShowWatermark", {
	Text = "Show Cheat Watermark",
	Default = true, 
	Tooltip = "Shows the cheat watermark. Duh", 
	Callback = function(Value)
		WatermarkVisible = Value
		Library:SetWatermarkVisibility(Value)
	end
})
MenuGroup:AddToggle("ShowKeybinds", {
	Text = "Show Keybinds Menu",
	Default = true, 
	Tooltip = "Shows a menu with all keybinds", 
	Callback = function(Value)
		Library.KeybindFrame.Visible = Value
	end
})


Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('FishhCheat_v2')
SaveManager:SetFolder('FishhCheat_v2/TC2')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

-- CODE

function RightClick()
	LegacyLocalVariables.Held2.Value = true
	task.wait(0.05)
	LegacyLocalVariables.Held2.Value = false
end

-- Projectile BoxHandleAdornments
function AddBoxHandleAdorn(projectile)
	if projectile.Name:match("stickybomb") or (projectile.Parent.Name == "Ray_Ignore" and projectile:GetAttribute("ProjectileType")) then
		local adornment = Instance.new("BoxHandleAdornment", projectile)
		adornment.Adornee = projectile
		adornment.Name = "Box"
		adornment.ZIndex = 1
		adornment.Transparency = Options.ChamsFillTransparency.Value
		adornment.Size = projectile.Size
		adornment.AlwaysOnTop = Toggles.ChamsDepthMode.Value
		if projectile:GetAttribute("Team") == LocalPlayer.Status.Team.Value and not Toggles.ESPTeammates.Value then
			adornment.Visible = false
		end
		if Toggles.ChamsTeamCheck.Value then
			if projectile:GetAttribute("Team") == "TRC" then
				adornment.Color = BrickColor.new(Options.RedChamsColor.Value)
			else
				adornment.Color = BrickColor.new(Options.GreenChamsColor.Value)
			end
		else
			adornment.Color = BrickColor.new(Options.ChamsFillColor.Value)
		end
	end
end

for i, v in pairs(workspace.Ray_Ignore:GetChildren()) do
	AddBoxHandleAdorn(v)
end
for i, v in pairs(workspace.Destructable:GetChildren()) do
	AddBoxHandleAdorn(v)
end

workspace.Ray_Ignore.ChildAdded:connect(function(v)
	AddBoxHandleAdorn(v)
	pcall(function()
		v:GetPropertyChangedSignal("Transparency"):Connect(function() -- Due to tc2 shit code, rockets stick around after exploding, and so do chams we add. so we gotta remove them ourselves	
			if v.Name:match("Rocket") then
				v:Destroy()	
			end						
		end)			
	end)
end)

workspace.Destructable.ChildAdded:connect(function(v)
	AddBoxHandleAdorn(v)
end)

--[[ unused prob
function RemoveBoxHandleAdorn()
	for i, v in pairs(workspace.Ray_Ignore:GetChildren()) do
		if v:FindFirstChild("Box") then
			v:FindFirstChild("Box"):Destroy()
		end
	end
	for i, v in pairs(workspace.Destructable:GetChildren()) do
		if v:FindFirstChild("Box") then
			v:FindFirstChild("Box"):Destroy()
		end
	end
end
]]

local highlights = {}

function Visuals(Player)

    if (Player == LocalPlayer) then
        return
    end

    -- Bounding Boxes
    local fillBox = Drawing.new("Square")
    fillBox.Visible = false
    fillBox.Color = Color3.new(255,255,255)
    fillBox.Thickness = 0.1
    fillBox.Transparency = 0.5
    fillBox.Filled = true

    local outlineBox = Drawing.new("Square")
    outlineBox.Visible = false
    outlineBox.Color = Color3.new(0, 0, 0)
    outlineBox.Thickness = 1.4
    outlineBox.Transparency = 1
    outlineBox.Filled = false
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.new(255,255,255)
    box.Thickness = 0.7
    box.Transparency = 1
    box.Filled = false

    -- Healthbar Outline
    local healthOutlineBox = Drawing.new("Square")
    healthOutlineBox.Visible = false
    healthOutlineBox.Color = Color3.new(0, 0, 0)
    healthOutlineBox.Thickness = 3
    healthOutlineBox.Transparency = 1
    healthOutlineBox.Filled = true
    
    -- Healthbar
    local healthBarBox = Drawing.new("Square")
    healthBarBox.Visible = false
    healthBarBox.Color = Color3.new(255,255,255)
    healthBarBox.Thickness = 1
    healthBarBox.Transparency = 1
    healthBarBox.Filled = true

    -- View Tracer
    local viewTracer = Drawing.new("Line")
    viewTracer.Visible =  false
    viewTracer.Thickness = 1
    viewTracer.Color = Color3.new(255,255,255)
    
    -- Name ESP
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Center = true
    nameText.Outline = true
    nameText.Font = 0
    nameText.Size = 13
    nameText.Color = Color3.new(255,255,255)
        
    -- Distance ESP
    local distanceText = Drawing.new("Text")
    distanceText.Visible = false
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Font = 0
    distanceText.Size = 13
    distanceText.Color = Color3.new(255,255,255)

    -- Weapon ESP
    local weaponText = Drawing.new("Text")
    weaponText.Visible = false
    weaponText.Center = true
    weaponText.Outline = true
    weaponText.Font = 0
    weaponText.Size = 13
    weaponText.Color = Color3.new(255,255,255)
	
	Player:WaitForChild("Status", math.huge).Class:GetPropertyChangedSignal("Value"):Connect(function()
		if Toggles.NotifClass.Value and MarkedPlayers[Player.UserId] and Player.Status.Class.Value ~= "" then
			Library:Notify(Player.Name .. " has changed class to " .. Player.Status.Class.Value)
		end
	end)
	Player:WaitForChild("Status", math.huge).Team:GetPropertyChangedSignal("Value"):Connect(function()
		if Toggles.NotifClass.Value and MarkedPlayers[Player.UserId] and Player.Status.Team.Value ~= "" then
			if Player.Status.Team.Value == "TRC" then
				Library:Notify(Player.Name .. " has switched to RED team")
			elseif Player.Status.Team.Value == "TGC" then
				Library:Notify(Player.Name .. " has switched to GRN team")
			end								
		end
	end)

    RunService:BindToRenderStep(Player.Name .. 'Esp', 1, function()
        if Player ~= nil and Player.Character ~= nil and (Toggles.ESPTeammates.Value or Player.Team ~= LocalPlayer.Team) then
			local plrWeapon = Player.Character:GetAttribute("EquippedWeapon") or 'None'

            local base = Player.Character
            local Head = base:FindFirstChild('Head')
            local Humanoid = base:FindFirstChild('Humanoid')
            local Health = Humanoid.Health
            local MaxHealth = Humanoid.MaxHealth
            local Root = base:FindFirstChild('HumanoidRootPart')
            local Font = Options.TextFont.Value
                
            if Options.HealthBarColor.Value == Color3.fromRGB(255,255,255) then
                healthBarBox.Color = Color3.fromRGB(255 - 255 / (MaxHealth / Health), 255 / (MaxHealth / Health), 0)
            else
                healthBarBox.Color = Options.HealthBarColor.Value
            end

            viewTracer.Color = Options.ViewTracerColor.Value
            nameText.Outline = Toggles.ESPOutlines.Value
            distanceText.Outline = Toggles.ESPOutlines.Value
            weaponText.Outline = Toggles.ESPOutlines.Value
            nameText.Color = Options.NamesColor.Value
            distanceText.Color = Options.DistanceColor.Value
            weaponText.Color = Options.WeaponsColor.Value

            if (base and Head and Root and base:GetAttribute("isAlive") == true) then
			

                local Cam = Camera.CFrame
                local Torso = Root.CFrame
				
			
                local top, top_isrendered = Camera:worldToViewportPoint(Head.Position + (Torso.UpVector * 0.025) + Cam.UpVector)
                local bottom, bottom_isrendered = Camera:worldToViewportPoint(Torso.Position - (Torso.UpVector * 2.05) - Cam.UpVector)
				
			        
                local minY = math.abs(bottom.y - top.y)
                local sizeX = math.ceil(math.max(math.clamp(math.abs(bottom.x - top.x) * 2.7, 0, minY), minY / 2, 3))
                local sizeY = math.ceil(math.max(minY, sizeX * 0.5, 3))
				

                if Player.Team.Name == "RED" then
                    if Toggles.BoxTeamCheck.Value then
                        box.Color = Options.RedBoxColor.Value
                    else
                        box.Color = Options.BoundingBoxDefaultColor.Value
                    end
                else
                    if Toggles.BoxTeamCheck.Value then
                        box.Color = Options.GreenBoxColor.Value
                    else
                        box.Color = Options.BoundingBoxDefaultColor.Value
                    end
                end

				

                if Player.Team.Name == "RED" then
                    if Toggles.BoxTeamCheck.Value then
                        fillBox.Color = Options.RedBoxColor.Value
                    else
                        fillBox.Color = Options.BoundingBoxDefaultColor.Value
                    end
                else
                    if Toggles.BoxTeamCheck.Value then
                        fillBox.Color = Options.GreenBoxColor.Value
                    else
                        fillBox.Color = Options.BoundingBoxDefaultColor.Value
                    end
                end
				

                
                if top_isrendered or bottom_isrendered then
        
                    local boxtop = Vector2.new(
                        math.floor(top.x * 0.5 + bottom.x * 0.5 - sizeX * 0.5),
                        math.floor(math.min(top.y, bottom.y))
                    )
    
                    local boxsize = { w = sizeX, h = sizeY }
    
                    -- Boxes
                    fillBox.Position = Vector2.new(boxtop.x, boxtop.y)
                    fillBox.Size = Vector2.new(boxsize.w, boxsize.h)
                    fillBox.Transparency = Options.BoxFillTransparency.Value
                    fillBox.Thickness = 0.1

                    outlineBox.Position = Vector2.new(boxtop.x, boxtop.y)
                    outlineBox.Size = Vector2.new(boxsize.w, boxsize.h)
                    outlineBox.Thickness = 1.4
    
                    box.Position = Vector2.new(boxtop.x, boxtop.y)
                    box.Size = Vector2.new(boxsize.w, boxsize.h)
                    box.Thickness = 0.7
    
                    -- Boxes
                    if Toggles.BoundingBox.Value then
                        box.Visible = true
                        if Toggles.ESPOutlines.Value then
                            outlineBox.Visible = true
                        else
                            outlineBox.Visible = false
                        end
                    else
                        box.Visible = false
                        outlineBox.Visible = false
                    end

                    if Toggles.BoundingBox.Value then
                        fillBox.Visible = true
                    else
                        fillBox.Visible = false
                    end

                    -- Health Bar
                    if Toggles.HealthBar.Value then
                        local ySizeBar = -math.floor(boxsize.h * Health / MaxHealth)
                        
                        healthOutlineBox.Position = Vector2.new(boxtop.x - 8, boxtop.y - 1)
                        healthOutlineBox.Size = Vector2.new(3, boxsize.h + 3)
                        if Toggles.ESPOutlines.Value then
                            healthOutlineBox.Visible = true
                        else
                            healthOutlineBox.Visible = false
                        end
                        
                        healthBarBox.Position = Vector2.new(boxtop.x - 7, boxtop.y + boxsize.h)
                        healthBarBox.Size = Vector2.new(2, math.min(-1, ySizeBar))
                        healthBarBox.Visible = true
                    else
                        healthBarBox.Visible = false
                        healthOutlineBox.Visible = false
                    end                    

                    -- View Tracers
                    if Toggles.ViewTracer.Value then
                        local PositionOrigin = Camera:worldToViewportPoint(Head.Position)
                        local PositionTarget = Camera:worldToViewportPoint(Head.Position + Head.CFrame.LookVector * Options.ViewTracerDistance.Value)
                        viewTracer.From = Vector2.new(PositionOrigin.x, PositionOrigin.y)
                        viewTracer.To = Vector2.new(PositionTarget.x, PositionTarget.y)
                        viewTracer.Visible = true
                    else
                        viewTracer.Visible = false
                    end

                    -- Distance
                    if Toggles.Distance.Value then
                        if Toggles.Weapon.Value then
                            distanceText.Position = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h + Options.TextSize.Value + 2)
                        else
                            distanceText.Position = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h + 3)
                        end
                        distanceText.Text = tostring(math.ceil((Root.Position - Camera.CFrame.Position).magnitude / 3.571428571428571) .. "m")
                        distanceText.Visible = true
                        distanceText.Font = Font
                        distanceText.Size = Options.TextSize.Value
                    else
                        distanceText.Visible = false
                    end

                    -- Name
                    if Toggles.Names.Value then
                        nameText.Text = tostring(Player.Name)
                        local ExtraDistanceThingamabob = 0 + (1.15 / Options.TextSize.Value * 0.999)
                        nameText.Position = (Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), math.floor(boxtop.y - Options.TextSize.Value + ExtraDistanceThingamabob)) or Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), math.floor(boxtop.y - 4)))
                        nameText.Visible = true
                        nameText.Font = Font
                        nameText.Size = Options.TextSize.Value
                    else
                        nameText.Visible = false
                    end

                    -- Weapon
                    if Toggles.Weapon.Value then
                        weaponText.Text = tostring(plrWeapon) or "None"
                        weaponText.Position = Vector2.new(math.floor(boxtop.x + boxsize.w * 0.5), boxtop.y + boxsize.h + 3)
                        weaponText.Visible = true
                        weaponText.Font = Font
                        weaponText.Size = Options.TextSize.Value
                    else
                        weaponText.Visible = false
                    end

                else
                    healthBarBox.Visible = false
                    healthOutlineBox.Visible = false
                    box.Visible = false
                    outlineBox.Visible = false
                    fillBox.Visible = false
                    distanceText.Visible = false
                    nameText.Visible = false
                    weaponText.Visible = false
                    viewTracer.Visible = false
                end
				

                -- Chams
                if not highlights[Player.Name] then
                    
                    local highlight = Instance.new("Highlight") -- , CoreGui or gethui()
                    highlight.Parent = CoreGui or gethui()
                    highlight.Adornee = base
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    if Toggles.Chams.Value then
                        highlight.Enabled = true
                    else
                        highlight.Enabled = false
                    end
                    if Toggles.ChamsDepthMode.Value then
                        highlight.DepthMode = 0
                    else
                        highlight.DepthMode = 1
                    end

                    highlight.FillTransparency = 0
                    highlight.OutlineTransparency = 0
                    highlights[Player.name] = highlight
                    --highlight.Adornee = Base
                end                

                if highlights[Player.Name] then
                    if not Toggles.ChamsTeamCheck.Value then
                        highlights[Player.Name].FillColor = Options.ChamsFillColor.Value
						if Target and Target.Parent == base then
							highlights[Player.Name].OutlineColor = Color3.fromRGB(255, 255, 255)
						else
							highlights[Player.Name].OutlineColor = Options.ChamsOutlineColor.Value
						end
                    else
                        if Player.Team.Name == "RED" then
                            highlights[Player.Name].FillColor = Options.RedChamsColor.Value
							if Target and Target.Parent == base then
								highlights[Player.Name].OutlineColor = Color3.fromRGB(255, 255, 255)
							else
								highlights[Player.Name].OutlineColor = Options.RedChamsColor.Value
							end
                        else
                            highlights[Player.Name].FillColor = Options.GreenChamsColor.Value
							if Target and Target.Parent == base then
								highlights[Player.Name].OutlineColor = Color3.fromRGB(255, 255, 255)
							else
								highlights[Player.Name].OutlineColor = Options.GreenChamsColor.Value
							end
                        end
                    end
                    highlights[Player.Name].FillTransparency = Options.ChamsFillTransparency.Value
                    highlights[Player.Name].OutlineTransparency = Options.ChamsOutlineTransparency.Value
                    highlights[Player.Name].Enabled = Toggles.Chams.Value
					if Toggles.Chams.Value and base:FindFirstChildWhichIsA("Highlight") then -- gets rid of effects like milk and jarate, which can break chams
						base:FindFirstChildWhichIsA("Highlight"):Destroy()					
					end
                    highlights[Player.Name].DepthMode = Toggles.ChamsDepthMode.Value and 0 or 1
                    highlights[Player.Name].Adornee = base
                end
				
            else
                healthBarBox.Visible = false
                healthOutlineBox.Visible = false
                box.Visible = false
                fillBox.Visible = false
                outlineBox.Visible = false
                distanceText.Visible = false
                nameText.Visible = false
                weaponText.Visible = false
                viewTracer.Visible = false
            end
        else
            healthBarBox.Visible = false
            healthOutlineBox.Visible = false
            box.Visible = false
            fillBox.Visible = false
            outlineBox.Visible = false
            distanceText.Visible = false
            nameText.Visible = false
            weaponText.Visible = false
            viewTracer.Visible = false

            if Player and Player.Character and highlights[Player.Name] then
                highlights[Player.Name]:Destroy()
                highlights[Player.Name] = nil
            end
            
        end
    end)

    Players.PlayerRemoving:Connect(function(Player)

        box.Visible = false
        outlineBox.Visible = false
        fillBox.Visible = false
        healthBarBox.Visible = false
        healthOutlineBox.Visible = false
        distanceText.Visible = false
        nameText.Visible = false
        weaponText.Visible = false
        viewTracer.Visible = false
		
		if highlights[Player.Name] then
			highlights[Player.Name]:Destroy()
            highlights[Player.Name] = nil
		end
		
		if MarkedPlayers[Player.UserId] and Toggles.NotifMarked.Value then
			Library:Notify(Player.Name .. " (" .. MarkedPlayers[Player.UserId] .. ") has left the game", nil, 4590657391)
		end
        
        RunService:UnbindFromRenderStep(Player.Name .. 'Esp')
    end)
end

for i,v in pairs(Players:GetPlayers()) do
	task.spawn(function()
		repeat task.wait() until v:GetAttribute("GroupRank")
		if Tags[v:GetAttribute("GroupRank")] then
			MarkedPlayers[v.UserId] = Tags[v:GetAttribute("GroupRank")]
		end	
		if MarkedPlayers[v.UserId] and Toggles.NotifMarked.Value then
			Library:Notify(v.Name .. " (" .. MarkedPlayers[v.UserId] .. ") has joined the game", nil, 4590657391)
		end
		Visuals(v)
	end)
end

Players.PlayerAdded:Connect(function(Player)
	repeat task.wait() until Player:GetAttribute("GroupRank")
	if Tags[Player:GetAttribute("GroupRank")] then
		MarkedPlayers[Player.UserId] = Tags[Player:GetAttribute("GroupRank")]
	end
	if MarkedPlayers[Player.UserId] and Toggles.NotifMarked.Value then
		Library:Notify(Player.Name .. " (" .. MarkedPlayers[Player.UserId] .. ") has joined the game", nil, 4590657391)
	end
    Visuals(Player)
end)


for i, v in pairs(workspace:GetChildren()) do
	if v.Name:match("Teleporter") or v.Name:match("Dispenser") or v.Name:match("Sentry") then
		local Highlight = Instance.new("Highlight")
		Highlight.Name = "Chams"
		Highlight.Enabled = false
		Highlight.Adornee = v
		Highlight.Parent = v
	end
end

workspace.ChildAdded:connect(function(v)
	if v.Name:match("Teleporter") or v.Name:match("Dispenser") or v.Name:match("Sentry") then
		task.wait(0.05) -- cuz idk
		local Highlight = Instance.new("Highlight")
		Highlight.Name = "Chams"
		Highlight.Enabled = false
		Highlight.Parent = v
		Highlight.Adornee = v
	end
end)


	
local BodyPartSizes = {}
BodyPartSizes["HeadHB"] = Vector3.new(2, 2, 2)
BodyPartSizes["RightUpperLeg"] = Vector3.new(1, 1.5, 1)
BodyPartSizes["Hitbox"] = Vector3.new(5.59, 5.175, 5.175)

function ExpandPart(part, size, transparency)
	if part then
		part.Massless = true
		part.CanCollide = false
		part.Transparency = transparency
		part.Size = size
	end
end

task.spawn(function() -- Hitbox Expander and building chams
	while not Library.Unloaded and task.wait(0.5) do 
		for i, v in Players:GetPlayers() do 
			local Character = v.Character
			if Character then
				if Toggles.HBEToggle.Value and Toggles.HBEPlayerToggle.Value and Options.HBEBind:GetState() and v.Team ~= LocalPlayer.Team and not (Toggles.AimIgnoreInvis.Value and Character["UpperTorso"].Transparency > .9) and not (Toggles.AimIgnoreFriends.Value and (LocalPlayer:IsFriendsWith(v.UserId) or MarkedPlayers[v.UserId] == "Ignored")) then
					for i,v in ExpandableHitboxes do							
						local Actual = Character:FindFirstChild(v)
						if Actual then
							if Options.HBEPlayerParts.Value[v] then
								ExpandPart(Actual, Vector3.one * Options.HBEPlayerSize.Value, 1) -- 1 is supposed to be hbetransparency
							else
								ExpandPart(Actual, BodyPartSizes[v], 1) -- 1 is supposed to be hbetransparency
							end
						end
					end
				else
					ExpandPart(Character:FindFirstChild("HeadHB"), Vector3.new(2, 2, 2), 1)
					ExpandPart(Character:FindFirstChild("RightUpperLeg"), Vector3.new(1, 1.5, 1), 0)
					ExpandPart(Character:FindFirstChild("Hitbox"), Vector3.new(5.59, 5.175, 5.175), 1)
				end
			end
		end
		
		for i, v in pairs(workspace:GetChildren()) do
			if v.Name:match("Sentry") or v.Name:match("Dispenser") or v.Name:match("Teleporter") then
				if v:FindFirstChild("Hitbox") and v:FindFirstChild("TeamColor3") then
					if Toggles.HBEToggle.Value and Toggles.HBEBuildingToggle.Value and LocalPlayer.TeamColor.Color.G ~= v.TeamColor3.Color.G and not LocalPlayer.Character:GetAttribute("EquippedWeapon"):match("Sapper") then 
						v.Hitbox.Size = Vector3.one * Options.HBEBuildingSize.Value
						v.Hitbox.CanCollide = false
					else
						v.Hitbox.Size = Vector3.one * 3
						v.Hitbox.CanCollide = true
					end
					
					local buildingcham = v:FindFirstChild("Chams")
					
					if buildingcham then
						if Toggles.ChamsTeamCheck.Value then
							if v.TeamColor3.BrickColor == BrickColor.new("Bright red") then
								buildingcham.FillColor = Options.RedChamsColor.Value
								if Target and Target.Parent == Player then
									buildingcham.OutlineColor = Color3.fromRGB(255, 255, 255)
								else
									buildingcham.OutlineColor = Options.RedChamsColor.Value
								end
							else
								buildingcham.FillColor = Options.GreenChamsColor.Value
								if Target and Target.Parent == Player then
									buildingcham.OutlineColor = Color3.fromRGB(255, 255, 255)
								else
									buildingcham.OutlineColor = Options.GreenChamsColor.Value
								end
							end
						else
							buildingcham.FillColor = Options.ChamsFillColor.Value
							if Target and Target.Parent == Player then
								buildingcham.OutlineColor = Color3.fromRGB(255, 255, 255)
							else
								buildingcham.OutlineColor = Options.ChamsOutlineColor.Value
							end
						end
						if Toggles.ChamsDepthMode.Value then
							buildingcham.DepthMode = "AlwaysOnTop"
						else
							buildingcham.DepthMode = "Occluded"
						end
						buildingcham.FillTransparency = Options.ChamsFillTransparency.Value
						buildingcham.OutlineTransparency = Options.ChamsOutlineTransparency.Value
						-- Normal teamcolor values are different for some reason so i had to use the green values
						if not Toggles.Chams.Value then
							buildingcham.Enabled = false
						elseif LocalPlayer.TeamColor.Color.G == v.TeamColor3.Color.G and not Toggles.ESPTeammates.Value then
							buildingcham.Enabled = false
						else
							buildingcham.Enabled = true
						end
					end
					
				end
			end
		end		
	end
end)

function getClosestPlrPart(part, includebuildings)
	local ClosestDist = math.huge
	local ClosestPlayer = nil
	for i,v in pairs(Players:GetPlayers()) do
		local HRP = v.Character and v.Team ~= LocalPlayer.Team and v.Character:FindFirstChild("HumanoidRootPart")
		if HRP then
			local distance = (part.Position - HRP.Position).Magnitude
			if distance < ClosestDist then
				ClosestDist = distance
				ClosestPlayer = HRP;
			end
		end
	end
	if includebuildings then
		for i, v in pairs(workspace:GetChildren()) do
			-- Asger: There's an Owner attribute on buildings, though I am not sure if the attribute is an instance or string
			if v:FindFirstChild("Hitbox") and v:FindFirstChild("TeamColor3") then
				if ( v.Name:match("Teleporter") or v.Name:match("Dispenser") or v.Name:match("Sentry")) and LocalPlayer.TeamColor.Color.G ~= v.TeamColor3.Color.G then
					local distance = (part.Position - v.Hitbox.Position).Magnitude
					if distance < ClosestDist then
						ClosestDist = distance
						ClosestPlayer = v["Hitbox"]
					end				
				end
			end
		end
	end
	return ClosestPlayer
end
	
local Vec, OnScr
task.spawn(function() while task.wait() do -- Automation stuff
	if LocalPlayer.Character then
		-- AutoUber
		if Toggles.AutoUber.Value and LocalPlayer.Status.Class.Value == "Doctor" then
			if LocalPlayer.Character:FindFirstChild("Doctor") and LocalPlayer.Character.Doctor:GetAttribute("UberReady") then
				if Options.AutoUberCond.Value == "Only care about me" or Options.AutoUberCond.Value == "Both" then
					if (LocalPlayer.Character.Humanoid.Health / LocalPlayer.Character.Humanoid.MaxHealth) * 100 <= Options.AutoUberPerc.Value then
						RightClick()
					end
				end
				if LocalPlayer.Character.Doctor:GetAttribute("Target") and Options.AutoUberCond.Value == "Only care about players I heal" or Options.AutoUberCond.Value == "Both" then
					local healingplayer = Players:FindFirstChild(LocalPlayer.Character.Doctor:GetAttribute("Target"))
					if healingplayer and (healingplayer.Character.Humanoid.Health / healingplayer.Character.Humanoid.MaxHealth) * 100 <= Options.AutoUberPerc.Value then
						RightClick()
					end
				end
			end
		--end
		-- Auto Airblast
		elseif Toggles.AutoAirblast.Value and LocalPlayer.Status.Class.Value == "Arsonist" then
			for i, v in workspace.Ray_Ignore:GetChildren() do				
				if v:GetAttribute("ProjectileType") and v:GetAttribute("Team") then
					if v:GetAttribute("Team") ~= LocalPlayer.Status.Team.Value then
						Vec, OnScr = Camera:WorldToViewportPoint(v.Position)
						if OnScr and ((v.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) <= 13 then 
							RightClick()
						end
					end
				end					
			end
			for i, v in workspace.Destructable:GetChildren() do				
				if v.Name:match("stickybomb") and v:GetAttribute("Team") then
					if v:GetAttribute("Team") ~= LocalPlayer.Status.Team.Value then
						Vec, OnScr = Camera:WorldToViewportPoint(v.Position)
						if OnScr and ((v.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) <= 13 then
							RightClick()
						end
					end
				end					
			end
			if Toggles.AutoAirblastExt.Value then
				for i, v in Players:GetPlayers() do
					if v.Character and v ~= LocalPlayer then
						if v.Team == LocalPlayer.Team and v.Character:FindFirstChild("Conditions") then
							if v.Character.Conditions:GetAttribute("Engulfed") and (v.Character.Head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 13 then
								RightClick()
							end
						end
					end
				end
			end																			
		--end
		-- Auto Detonate
		elseif Toggles.AutoDetonate.Value and LocalPlayer.Status.Class.Value == "Annihilator" then
			for i, v in pairs(workspace.Destructable:GetChildren()) do
				if v.Name:match(LocalPlayer.Name) and v.Name:match("stickybomb") then
					local closestpart = getClosestPlrPart(v, Toggles.AutoDetonateBld.Value)
					if closestpart ~= nil and (v.Position - closestpart.Position).Magnitude < Options.AutoDetonateRange.Value then -- 9.125
						RepStorage.Events.Detonate:FireServer(v, nil, closestpart.CFrame)
					end
				end
			end
		end
	end	
	if Library.Unloaded then break end
end
end)

local GetClosestToMouse = function(TargetPart)
    local MaxDistance = nil
	local Closest = 9e9
	local ToRet
	for i,v in next, Players:GetPlayers() do
		if v.Character and v.Character:GetAttribute("isAlive") == true and v.Team ~= LocalPlayer.Team and not (Toggles.AimIgnoreInvis.Value and v.Character["UpperTorso"].Transparency > .9) and not (Toggles.AimIgnoreFriends.Value and (LocalPlayer:IsFriendsWith(v.UserId) or MarkedPlayers[v.UserId] == "Ignored")) then -- or MarkedPlayers[v.UserId] == "Ignored"
			local ToTarget = TargetPart or "Head"
			local Selected = v.Character:FindFirstChild(ToTarget)
			if Selected then
				local SelectedToViewPort,IsVisible = Camera:WorldToViewportPoint(Selected.Position)
				local Magnitude = (MouseLocation - Vector2.new(SelectedToViewPort.X,SelectedToViewPort.Y)).Magnitude -- we get distance from screen
				local Map = workspace:FindFirstChild("Map")
				if Map and Map:FindFirstChild("Ignore") and Magnitude < Closest and not (Toggles.AimbotOnlyFOVVis.Value and (Magnitude > Options.AimbotFOV.Value * 12.5)) then                            
					local RaycastParams = RaycastParams.new()
					RaycastParams.FilterDescendantsInstances = {v.Character, LocalPlayer.Character, Camera, workspace.Ray_Ignore, Map.Ignore, Map.Items, Map.TGCSpawns, Map.TRCSpawns, workspace.Accoutrements}
					RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    local Origin = Camera.CFrame.Position
                    local Direction = Selected.Position

                    local Raycast = workspace:Raycast(Origin, Direction - Origin, RaycastParams)

                    if not Raycast or Toggles.Wallbang.Value then
                        Closest = Magnitude
                        ToRet = Selected
                    end
				end
			end
		end
	end
	for i, v in next, workspace:GetChildren() do
		local Selected = v:FindFirstChild("Hitbox")
		if Selected and ( v.Name:match("Sentry") or v.Name:match("Dispenser") or v.Name:match("Teleporter") ) and v:FindFirstChild("TeamColor3") and LocalPlayer.TeamColor.Color.G ~= v.TeamColor3.Color.G then -- and v ~= LocalPlayer
			local SelectedToViewPort,IsVisible = Camera:WorldToViewportPoint(Selected.Position)
			local Magnitude = (MouseLocation - Vector2.new(SelectedToViewPort.X,SelectedToViewPort.Y)).Magnitude -- we get distance from screen
			local Map = workspace:FindFirstChild("Map")
			if Map and Map:FindFirstChild("Ignore") and Magnitude < Closest and not (Toggles.AimbotOnlyFOVVis.Value and (Magnitude > Options.AimbotFOV.Value * 12.5)) then                            
				local RaycastParams = RaycastParams.new()
				RaycastParams.FilterDescendantsInstances = {v, LocalPlayer.Character, Camera, workspace.Ray_Ignore, Map.Ignore, Map.Items, Map.TGCSpawns, Map.TRCSpawns, workspace.Accoutrements}
				RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                local Origin = Camera.CFrame.Position
                local Direction = Selected.Position

                local Raycast = workspace:Raycast(Origin, Direction - Origin, RaycastParams)

                if not Raycast or Toggles.Wallbang.Value then
                    Closest = Magnitude
                    ToRet = Selected
                end
			end
		end	
	end
	return ToRet,Closest
end

function PredictProjectile(Part, EquippedWeapon) -- Super basic prediction formula, good enough
	if not Part then return end
	if Part.Name == "Hitbox" then -- Mechanic's buildings
		return Part.Position
	end	
	local PlayerChar = Part.Parent 
	if PlayerChar.Hitbox.AssemblyLinearVelocity == Vector3.new(0, 0, 0) then
		return PlayerChar.UpperTorso.Position
	end
	
	local ProjectileSpawnPosition = (Camera.CFrame * Projectiles[EquippedWeapon].CFrameOffset).Position
	local TravelTime = ((ProjectileSpawnPosition - PlayerChar.Hitbox.Position).Magnitude / Projectiles[EquippedWeapon].Speed) + Ping / 1000
	--local Gravity = (PlayerChar.Humanoid:GetState() == Enum.HumanoidStateType.Freefall) and Vector3.new(0, workspace.Gravity, 0) or Vector3.new(0, 0, 0)
	-- fix!!! add grav prediction

	local PredictedPos = PlayerChar.HumanoidRootPart.Position + PlayerChar.HumanoidRootPart.AssemblyLinearVelocity * TravelTime + Projectiles[EquippedWeapon].Offset
	local RaycastParams = RaycastParams.new()
	RaycastParams.FilterDescendantsInstances = {PlayerChar, LocalPlayer.Character, Camera, workspace.Ray_Ignore, workspace.Map.Ignore, workspace.Map.Items, workspace.Map.TGCSpawns, workspace.Map.TRCSpawns, workspace.Accoutrements}
	RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
	local Origin = ProjectileSpawnPosition
    local Direction = PredictedPos
    local Raycast = workspace:Raycast(Origin, Direction - Origin, RaycastParams)
	
	if not Raycast then
		return PredictedPos
	else
		PredictedPos = PlayerChar.UpperTorso.Position + PlayerChar.HumanoidRootPart.AssemblyLinearVelocity * TravelTime
		Origin = ProjectileSpawnPosition
		Direction = PredictedPos
		Raycast = workspace:Raycast(Origin, Direction - Origin, RaycastParams)
		
		if not Raycast then
			return PredictedPos
		else
			return
		end
	end
	--end
end

local function Rotate(cframe) 
    local x, y, z = cframe:ToOrientation() 
    return CFrame.new(cframe.Position) * CFrame.Angles(0,y,0) 
end 

RunService.RenderStepped:Connect(function()
	MouseLocation = UIS:GetMouseLocation()
	FOVCircle.Position = Vector2.new(MouseLocation.X, MouseLocation.Y)
	FOVCircle.Visible = Toggles.AimbotShowFOV.Value
	FOVCircle.Radius = Options.AimbotFOV.Value * 12.5
	if not (LegacyLocalVariables.died.Value or LocalPlayer.Status.Team.Value == "Spectator") then
		Projectiles.Airstrike.Speed = (LocalPlayer.Character:FindFirstChild("RocketJumped") and 110 or 68.75)
		if Toggles.AimbotToggle.Value and AimbotBind then	-- adsmodifier			
			Target = GetClosestToMouse(Options.TargetPart.Value)
			if Toggles.ProjAimbotToggle.Value and Projectiles[LocalPlayer.Character:GetAttribute("EquippedWeapon")] then
				ProjPosition = PredictProjectile(Target, LocalPlayer.Character:GetAttribute("EquippedWeapon"))
				if ProjPosition then
					PredictionSphere.Position = ProjPosition
				end
			else
				ProjPosition = nil
			end
			if Target and not Toggles.SilentAimbot.Value then
				if Toggles.ProjAimbotToggle.Value and ProjPosition then
					Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, ProjPosition)
				else
					Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.CFrame.Position) -- ok finish this up mate.
				end
			end
			if Toggles.AimbotAutoShoot.Value then
				if Target then
					LegacyLocalVariables.Held.Value = true
					--require(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet() -- doesn't seem to work. shoots but aimbot broken bru
				else
					LegacyLocalVariables.Held.Value = false
				end
			end
		else
			Target = nil
			ProjPosition = nil
		end
		
		if Toggles.Spinbot.Value then
			LocalPlayer.Character.Humanoid.AutoRotate = false 
			spin = math.clamp(spin + Options.SpinbotSpeed.Value, 0, 360)
			if spin == 360 then spin = 0 end
			AntiAngle = AntiAngle + math.rad(spin) 
			LocalPlayer.Character.HumanoidRootPart.CFrame = Rotate( CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, AntiAngle, 0) )
		end
		
		if Toggles.Followbot.Value and Options.FollowbotPlayer.Value then -- Followbot
			if Options.FollowbotPlayer.Value ~= LocalPlayer.Name and Players:FindFirstChild(Options.FollowbotPlayer.Value) and Players:FindFirstChild(Options.FollowbotPlayer.Value).Character then
				LocalPlayer.Character.HumanoidRootPart.CFrame = Players[Options.FollowbotPlayer.Value].Character.HumanoidRootPart.CFrame
			end
		end
		
	else
		Target = nil
		ProjPosition = nil
	end

	if Toggles.NoBHopCap.Value then
		LocalPlayer.Character:SetAttribute("SpeedCap", 9e9)
	end	
	if Toggles.SpeedMod.Value then
		LocalPlayer.Character:SetAttribute("Speed", Options.SpeedAmount.Value)
	elseif Toggles.NoSlowdown.Value and LocalPlayer.Status.Class.Value ~= "" then -- No slowdown
		if LocalPlayer.Character:GetAttribute("Speed") < RepStorage.ClassInfo[LocalPlayer.Status.Class.Value].WalkSpeed.Value then
			LocalPlayer.Character:SetAttribute("Speed", RepStorage.ClassInfo[LocalPlayer.Status.Class.Value].WalkSpeed.Value)
		end
	end
	
	if not Lighting:FindFirstChild('ColorCorrection') then
        Instance.new('ColorCorrectionEffect', Lighting)
    end	
    Lighting.ColorCorrection.TintColor = Options.ColorCorrection.Value
    Lighting.ColorCorrection.Enabled = Toggles.ColorCorrectionToggle.Value
	if Lighting.Technology ~= Enum.Technology[Options.LightingTechnology.Value] then
        Lighting.Technology = Enum.Technology[Options.LightingTechnology.Value]
    end
	if Toggles.NightMode.Value then
		Lighting.ClockTime = 0
	end
end)

--[[ swift exeshitter doesnt seem to support getsenv properly
local returndamagemod = getsenv(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).returndamagemod
getsenv(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).returndamagemod = function(...)
	if Toggles.InfDamage.Value then
		return math.huge
	end
	return returndamagemod(...)
end
]]

	
task.spawn(function() while task.wait(Options.ChatSpamDelay.Value) do
	if Toggles.ChatSpamToggle.Value then -- Chat Spam
		RepStorage.Events.ChatMessage:FireServer(ChatSpam[math.random(1, #ChatSpam)], false)
	end
	if Library.Unloaded then break end	
	end
end)


local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    local Script = getcallingscript()
    local Arguments = {...}

    if Method == "Raycast" and Toggles.AimbotToggle.Value and Toggles.SilentAimbot.Value and AimbotBind and not checkcaller() then -- Silent Aimbot
        if Target then
            if Arguments[3].IgnoreWater and Arguments[3].CollisionGroup == "Raycast" then
                Arguments[1] = Camera.CFrame.Position
                Arguments[2] = Target.CFrame.Position - Camera.CFrame.Position
                return namecall(self,unpack(Arguments))
            end
        end
    end

    if Method == "FireServer" then
		if self.Name == "CreateProjectile" and Toggles.AimbotToggle.Value and Toggles.SilentAimbot.Value and AimbotBind and ProjPosition then
			Arguments[select("#", ...)] = game
			Arguments[2] = ProjPosition

			return namecall(self, unpack(Arguments))

        elseif self.Name == "ReplicateProjectile" and Toggles.AimbotToggle.Value and Toggles.SilentAimbot.Value and AimbotBind and ProjPosition then
			local Table = Arguments[1]
			local WeaponArg = Table[1]

			Table[select("#", ...)] = game
			Table[2] = ProjPosition
			Table[1] = WeaponArg

			Arguments[1] = Table
			return namecall(self, unpack(Arguments))
        elseif self.Name == "FallDamage" and Toggles.NoFallDamage.Value then -- NoFallDamage
            return
        elseif self.Name == "ReplicateDot" and Toggles.NoSniperBeam.Value then
            return
		elseif self.Name == "UpdateMetal2" and Toggles.InfAmmo.Value then
            return
        elseif self.Name == "Undisguise" and Toggles.NoUndisguise.Value then
            return
        elseif self.Name == "IMISSED" and Toggles.NoSelfDamage.Value then
            return
		elseif self.Name == "DeployBuilding" and Toggles.MaxBuildings.Value then
			return namecall(self, Arguments[1], Arguments[2], true, 3, 216, 200, 200, 0, 0, Arguments[10])		
        elseif Toggles.AnticheatBypass.Value and self.Name == "BeanBoozled" or self.Name == "WEGA" or (string.find(string.lower(self.Name), "ban") and not self.Name == "UseBanner") then
			if Toggles.NotifyBypass.Value then Library:Notify("Successfully blocked ban from remote " .. self.Name) end
            return
        end
    end

    return namecall(self, ...)
end))

local index -- Firerate changer and Wallbang
index = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not Library.Unloaded then
		if key == "Value" and self:IsA("ValueBase") and not checkcaller() then
			if self.Name:lower():match("firerate") and Toggles.FirerateChanger.Value and not self.Parent:FindFirstChild("Projectile") then
				return Options.FirerateAmount.Value
			end
		end
        if Toggles.Wallbang.Value and key == "Clips" then
            return workspace.Map
        end
    end
    return index(self, key)
end))

print("Successfully loaded!")
Library:Notify("Welcome, " .. LocalPlayer.DisplayName)
