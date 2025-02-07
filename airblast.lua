local Repository = "https://raw.githubusercontent.com/geoduude/LinoriaLib/main/"

local Library = loadstring(game:HttpGet(Repository .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))()

local ErrorMessageOut
ErrorMessageOut = game:GetService("LogService").MessageOut:Connect(function(Message, Type)

    if Type == Enum.MessageType.MessageError and not string.find(Message, "attempt to index nil with 'Value'") then
        ErrorMessageOut:Disconnect()

        setclipboard("Executor: " .. identifyexecutor() .. "\n\n" .. tostring(Message))
        Library:Notify(" Pathos has errored while loading and will now unload. The error has been copied to your clipboard, please report this to the script developers! ", 4.5)

        task.delay(4, function()
            Library:Unload()
        end)
    end

end)

-- UI vvv

local Window = Library:CreateWindow({ Title = " Pathos.cc", Center = true,  AutoShow = true, TabPadding = 3, MenuFadeTime = 0.2 })
local Tabs = { Aimbot = Window:AddTab("Aimbot"), ESP = Window:AddTab("ESP"), Visuals = Window:AddTab("Visuals"), Misc = Window:AddTab("Miscellaneous"), Config = Window:AddTab("Config") }

local AimbotGlobal = Tabs.Aimbot:AddLeftGroupbox("Global")
AimbotGlobal:AddToggle("AG_Aimbot", { Text = "Enabled", Default = false }):AddKeyPicker("AG_Aimbot_K", { Default = "T", SyncToggleState = false, Mode = "Hold", Text = "Aimbot Key", NoUI = false })
--AimbotGlobal:AddToggle("AG_Aimbot_Autoshoot", { Text = "Autoshoot", Default = false })

local AimbotHitscan = Tabs.Aimbot:AddRightGroupbox("Hitscan")
AimbotHitscan:AddToggle("AH_HitscanAimbot", { Text = "Enabled", Default = false })
AimbotHitscan:AddToggle("AH_HitscanAimbot_Silent", { Text = "Silent", Default = false })
AimbotHitscan:AddSlider("AH_HitscanAimbot_FoV", { Text = "Minimum Field of View", Default = 45, Min = 1, Max = 90, Rounding = 0, Compact = true })
AimbotHitscan:AddDivider()
AimbotHitscan:AddDropdown("AH_HitscanAimbot_PriorityPoint", { Values = { "Head", "Chest", "Stomach" }, Default = 1, Multi = false, Text = "Aimbot Hitbox Priority" })
AimbotHitscan:AddDropdown("AH_HitscanAimbot_AimPoints", { Values = { "Head", "Chest", "Stomach", "Arms", "Legs", "Feet" }, Default = 0, Multi = true, Text = "Aimbot Hitbox Points" })
AimbotHitscan:AddDivider()
AimbotHitscan:AddToggle("AH_HitscanAimbot_WaitForHeadshot", { Text = "Wait For Headshot", Default = false })

local AimbotProjectile = Tabs.Aimbot:AddRightGroupbox("Projectile")
AimbotProjectile:AddToggle("AP_ProjectileAimbot", { Text = "Enabled", Default = false })
AimbotProjectile:AddToggle("AP_ProjectileAimbot_Silent", { Text = "Silent", Default = false })
AimbotProjectile:AddSlider("AP_ProjectileAimbot_FoV", { Text = "Minimum Field of View", Default = 45, Min = 1, Max = 90, Rounding = 0, Compact = true })

local AimbotMelee = Tabs.Aimbot:AddRightGroupbox("Melee")
AimbotMelee:AddToggle("AM_MeleeAimbot", { Text = "Enabled", Default = false })
AimbotMelee:AddToggle("AM_MeleeAimbot_Silent", { Text = "Silent", Default = false })
AimbotMelee:AddSlider("AM_MeleeAimbot_Range", { Text = "Range Multiplier", Default = 1, Min = 0.5, Max = 2, Rounding = 1, Compact = true, Suffix = "x" })
AimbotMelee:AddDivider()
AimbotMelee:AddToggle("AM_MeleeAimbot_OnlyBackstab", { Text = "Only Backstab", Default = false })
AimbotMelee:AddToggle("AM_MeleeAimbot_OnlyBackstab_Minicrit", { Text = "Allow Mini-Crit Backstab", Default = false })

local MiscGeneral = Tabs.Misc:AddLeftGroupbox("General")
MiscGeneral:AddToggle("MG_OldBossThemes", { Text = "Original VSB Themes", Default = false })

local MiscClassExploits = Tabs.Misc:AddRightGroupbox("Class Exploits")
MiscClassExploits:AddToggle("MCE_AirblastFling", { Text = "Arsonist : Airblast Fling", Default = false }):AddKeyPicker("MCE_AirblastFling_K", { Default = "T", SyncToggleState = false, Mode = "Hold", Text = "Airblast Fling Key", NoUI = false })
MiscClassExploits:AddDropdown("MCE_AirblastFling", { Values = { "Up", "Away" }, Default = 1, Multi = false, Text = "Fling Direction" })
MiscClassExploits:AddSlider("MCE_AirblastFling_Range", { Text = "Airblast Fling Range", Default = 50, Min = 10, Max = 50, Rounding = 0, Compact = true })

-- Variables vvv

local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local YOffset = workspace.CurrentCamera.ViewportSize.Y / 1.43
local FPSCounter = 0
local Ping = 0

local EnableHook = true

local AimPosition

local DrawingTable = {}

local Debug_CheatName = Drawing.new("Text")
Debug_CheatName.Text = "Pathos.cc"
Debug_CheatName.Size = 17
Debug_CheatName.Color = Color3.new(1, 0.2, 0.2)
table.insert(DrawingTable, Debug_CheatName)

local Debug_Fps = Drawing.new("Text")
Debug_Fps.Text = "FPS : N/A"
Debug_Fps.Size = 15
table.insert(DrawingTable, Debug_Fps)

local Debug_Ping = Drawing.new("Text")
Debug_Ping.Text = "Latency : N/A"
Debug_Ping.Size = 15
table.insert(DrawingTable, Debug_Ping)

local Debug_LocalVelocity = Drawing.new("Text")
Debug_LocalVelocity.Text = "LocalPlayer Velocity : N/A"
Debug_LocalVelocity.Size = 15
table.insert(DrawingTable, Debug_LocalVelocity)

local Debug_LocalPosition = Drawing.new("Text")
Debug_LocalPosition.Text = "LocalPlayer Position : N/A"
Debug_LocalPosition.Size = 15
table.insert(DrawingTable, Debug_LocalPosition)

makefolder("bibulus.club") -- omg pasted

if not isfile("bibulus.club/Interlude.mp3") then
    print("[ Pathos ] 'Interlude.mp3' not found, downloading..")

    local Time = tick()
    local Interlude = request({Url = "https://github.com/geoduude/bibulus-dependencies/raw/main/Interlude.mp3"}).Body

    if Interlude then
        print("[ Pathos ] 'Interlude.mp3' Downloaded in "..string.format("%.2f", tick() - Time).."s.")
        writefile("bibulus.club/Interlude.mp3", Interlude)
    else
        Library:Notify("[ Pathos ] 'Interlude.mp3' failed to load.")
    end
end

if not isfile("bibulus.club/More Gun Reversed.mp3") then
    print("[ Pathos ] 'More Gun Reversed.mp3' not found, downloading..")

    local Time = tick()
    local Interlude = request({Url = "https://github.com/geoduude/bibulus-dependencies/raw/main/More%20Gun%20Reversed.mp3"}).Body

    if Interlude then
        print("[ Pathos ] 'More Gun Reversed.mp3' Downloaded in "..string.format("%.2f", tick() - Time).."s.")
        writefile("Pathos.club/More Gun Reversed.mp3", Interlude)
    else
        Library:Notify("[ Pathos ] 'More Gun Reversed.mp3' failed to load.")
    end
end

local InterludeID = getcustomasset("bibulus.club/Interlude.mp3")
local MoreGunReversedID = getcustomasset("bibulus.club/More Gun Reversed.mp3")

-- Table Variables vvv

local Tags = {
    [255] = "Holder (Game Owner)",
    [254] = "Game Programmer",
    [253] = "Game Developer",
    [252] = "Contributor",
    [251] = "Moderator",
    [250] = "Tester"
}
local BlacklistedRemoteNames = {
    "BeanBoozled",
    "WEGA",

    "PlayVoice",
    "PlayerChatted",
    "ProjectileCrap",
    "UpdateMetal",

    "ToggleJuke",
    "ModFunction",
    "Starman"
}
local MinimumCooldown = {
    ["CreateProjectile"] = {
        ["Time"] = 5 / 74, -- its 5 / 75 in the source, but like just to be safe make it less
        ["Tick"] = tick()
    }
}

local ProjectileOffsets = {
    ["Milk"] = CFrame.new(0.75, -0.1875, 0),
    ["Shuriken"] = CFrame.new(0.75, -0.1875, 0),

    ["Arrow"] = CFrame.new(0.5, -0.1875, 0),
    ["Arrow_Syringe"] = CFrame.new(0.5, -0.1875, 0),
    ["Syringe"] = CFrame.new(0.5, -0.1875, 0),
    ["Nail"] = CFrame.new(0.5, -0.1875, 0),
    ["Slingshot_Rock"] = CFrame.new(0.5, -0.1875, 0),

    ["Rocket"] = CFrame.new(CurrentWeapon == "Original" and 0 or 0.75, (CurrentWeapon == "Original" or CurrentWeapon == "Ranshao-ge Rocket") and -1 or -0.1875, 0),

    ["Grenade"] = CFrame.new(0.5, -0.375, 0),
    ["Stickybomb"] = CFrame.new(0.5, -0.375, -1),

    ["SmallBeam"] = CFrame.new(0.5, -0.1875, 0),
    ["Fart"] = CFrame.new(0.5, -0.1875, 0), -- ??????
    ["Plasma"] = CFrame.new(0.5, -0.1875, 0)
}

local HitboxPriorities = {
    ["HeadHB"] = 3,
    ["UpperTorso"] = 3,
    ["LowerTorso"] = 3,

    ["LeftLowerArm"] = 2,
    ["RightLowerArm"] = 2,

    ["LeftLowerLeg"] = 1,
    ["RightLowerLeg"] = 1,

    ["LeftFoot"] = 0,
    ["RightFoot"] = 0
}
local HitboxNameTables = {
    ["Head"] = {"HeadHB"},
    ["Chest"] = {"UpperTorso"},
    ["Stomach"] = {"LowerTorso"},

    ["Arms"] = {"LeftLowerArm", "RightLowerArm"},
    ["Legs"] = {"LeftLowerLeg", "RightLowerLeg"},

    ["Feet"] = {"LeftFoot", "RightFoot"}
}

-- Instance Variables vvv

local GameCamera = require(game.ReplicatedStorage.Modules.gameCamera) -- GameCamera.GetCameraAimCFrame()

local GunType = 0

local LegacyLocalVariables = LocalPlayer.PlayerGui.GUI.Client.LegacyLocalVariables
local CurrentGun = LegacyLocalVariables.gun

-- Functions vvv

function PointVisible(Origin, Position)
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterDescendantsInstances = {workspace.Map}
    RaycastParams.CollisionGroup = "Raycast"
    RaycastParams.FilterType = Enum.RaycastFilterType.Include

    return workspace:Raycast(Origin, Position - Origin, RaycastParams) == nil
end

function PlayerFOV()
    local Player, HitboxPosition

    local Mouse = LocalPlayer:GetMouse()
    local MinimumDistance = GunType == 1 and Options.AH_HitscanAimbot_FoV.Value * 12.5 or (GunType == 2 and Options.AP_ProjectileAimbot_FoV.Value * 12.5)

    if not MinimumDistance then return end

    local CameraCFrame = GameCamera.GetCameraAimCFrame()

    for _, Target in game.Players:GetPlayers() do
        if Target == LocalPlayer or Target.Team == LocalPlayer.Team or not (Target.Character and Target.Character:FindFirstChild("Hitbox")) then continue end

        local TargetPosition, PriorityPart
        for i in Options.AH_HitscanAimbot_AimPoints.Value do

			for _, Hitbox in HitboxNameTables[i] do
                local TargetPart = Target.Character:FindFirstChild(Hitbox)

                if TargetPart and PointVisible(CameraCFrame.Position, TargetPart.Position) then
                    
                    if Hitbox == Options.AH_HitscanAimbot_PriorityPoint.Value then
						PriorityPart = Hitbox
                        break
                    elseif PriorityPart then

						if HitboxPriorities[Hitbox] > HitboxPriorities[PriorityPart] then
							PriorityPart = Hitbox
                        end

                    else
						PriorityPart = Hitbox
					end

                end
				
			end

        end

        if PriorityPart then
            TargetPosition = Target.Character[PriorityPart].Position
        end
        if not TargetPosition then continue end

        local ScreenPoint, OnScreen = workspace.CurrentCamera:WorldToScreenPoint(TargetPosition)
        if OnScreen and (CameraCFrame.Position - TargetPosition).Magnitude < CurrentGun.Value.Range.Value then

            local Magnitude = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if Magnitude < MinimumDistance then
                Player = Target
                HitboxPosition = TargetPosition

                MinimumDistance = Magnitude
            end

        end
    end

    return Player, HitboxPosition
end

function PlayerClosest()
    local Player, Position

    for _, Target in game.Players:GetPlayers() do
        if Target == LocalPlayer or Target.Team == LocalPlayer.Team or not (Target.Character and Target.Character:FindFirstChild("Hitbox")) then continue end

        if Position then
            if (LocalPlayer.Character.HumanoidRootPart.Position - Target.Character.Hitbox.Position).Magnitude < (Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude then
                Player = Target
                Position = Player.Character.Hitbox.Position
            end
        else
            Player = Target
            Position = Player.Character.Hitbox.Position
        end

    end

    return Player
end

-- Code vvv

for _, v in DrawingTable do
	v.Outline = true
    v.OutlineColor = Color3.new(0, 0, 0)
    v.Font = 1
    v.Position = Vector2.new(20, YOffset)
    v.Visible = true

    YOffset += v.Size

    if v == Debug_CheatName then continue end
    v.Color = Color3.new(1, 1, 1)
end

local Connections = {
    RunService.RenderStepped:Connect(function()

        GunType = 0
        if CurrentGun.Value then
            if CurrentGun.Value:FindFirstChild("Projectile") then
                GunType = 2
            elseif CurrentGun.Value:FindFirstChild("Melee") then
                GunType = 3
            elseif not CurrentGun.Value:FindFirstChild("FM") then
                GunType = 1
            end
        end

        if GunType ~= 0 and Toggles.AG_Aimbot.Value and Options.AG_Aimbot_K:GetState() then
			if LegacyLocalVariables.equipping.Value then return end
            AimPosition = nil

            if GunType == 1 then
                if Toggles.AH_HitscanAimbot.Value then
                    if CurrentGun.Value.Name == "Poachers Pride" and (tick() - LegacyLocalVariables.shoottick.Value) < 1 then
                        return
                    elseif CurrentGun.Value:FindFirstChild("LMG") and not LocalPlayer.Character:GetAttribute("FullySpunUp") then
                        return
                    end

                    local Player, PlayerPosition = PlayerFOV()
                    if Player then
                        AimPosition = PlayerPosition

                        if not Toggles.AH_HitscanAimbot_Silent.Value then
                            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, AimPosition)
                        end

                        require(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
                    end
                end
            elseif GunType == 2 then
                -- 🤔
            elseif GunType == 3 then
                if Toggles.AM_MeleeAimbot.Value then
					
                    local Player = PlayerClosest()
                    if Player then
                        local CameraCFrame = GameCamera.GetCameraAimCFrame()

                        local Hitbox = Player.Character.Hitbox
                        local TargetPosition = Vector3.new(Hitbox.Position.X, math.clamp(CameraCFrame.Position.Y, Hitbox.Position.Y - (Hitbox.Size.X / 2.5), Hitbox.Position.Y + (Hitbox.Size.X / 2.5)), Hitbox.Position.Z)

                        local Angle = (TargetPosition - CameraCFrame.Position).Unit * ((CurrentGun.Value.Range.Value / (25 / 3)) * Options.AM_MeleeAimbot_Range.Value) -- yay krystal yess use weird ass numbers for your shit -_-

                        local RaycastParams = RaycastParams.new()
                        RaycastParams.FilterDescendantsInstances = {Hitbox, workspace.Map}
                        RaycastParams.CollisionGroup = "Raycast"
                        RaycastParams.FilterType = Enum.RaycastFilterType.Include

                        local Raycast = workspace:Raycast(CameraCFrame.Position, Angle, RaycastParams)

                        if Raycast and Raycast.Instance.Parent:FindFirstChildWhichIsA("Humanoid") then -- no vis check btw.. you can literally melee through walls  if their hitbox sticks through it
                            AimPosition = Hitbox.Position

                            if not Toggles.AM_MeleeAimbot_Silent.Value then
                                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, TargetPosition)
                            end

                            if CurrentGun.Value:FindFirstChild("Backstab") then
                                -- credit to asger for whatever the fuck this shit is
                                local Angle = (Vector3.new(LocalPlayer.Character.HumanoidRootPart.Position.X, 0, LocalPlayer.Character.HumanoidRootPart.Position.Z) - Vector3.new(Hitbox.Position.X, 0, Hitbox.Position.Z)).Unit:Dot(Hitbox.CFrame.LookVector.Unit)

                                if Toggles.AM_MeleeAimbot_OnlyBackstab.Value and Toggles.AM_MeleeAimbot_OnlyBackstab_Minicrit.Value then
                                    
                                    if math.deg(math.acos(Angle)) > 90 then
                                        require(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
                                    end

                                elseif Toggles.AM_MeleeAimbot_OnlyBackstab.Value then

                                    if math.deg(math.acos(Angle)) > 115 then
                                        require(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
                                    end

                                else
                                    require(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
                                end
                            else
                                require(LocalPlayer.PlayerGui.GUI.Client.Functions.Weapons).firebullet()
                            end
                        end
                    end

                end
            end
        elseif AimPosition ~= nil then
            AimPosition = nil
        end

        if Toggles.MCE_AirblastFling.Value and Options.MCE_AirblastFling_K:GetState() and LocalPlayer.Status.Class.Value == "Arsonist" and CurrentGun.Value:FindFirstChild("FM") then

            for _, Player in game.Players:GetPlayers() do
                if Player == LocalPlayer or Player.Team == LocalPlayer.Team or not (Player.Character and Player.Character:FindFirstChild("Hitbox")) then continue end
                if (Player.Character.Hitbox.Position - LocalPlayer.Character.Hitbox.Position).Magnitude > 50 then continue end

                game.ReplicatedStorage.Events.Airblast:FireServer(Player.Character.Hitbox, Options.MCE_AirblastFling.Value == "Away" and Vector3.new(1, 0.1, 1) * 9e9 or Player.Character.Hitbox.Position + Vector3.new(0, 9e9, 0), "Flamethrower")
            end

        end

        Debug_CheatName.Text = "Pathos.cc" -- awp is weird..
		do -- Debug Ping
            local FormattedPing = tonumber( string.format("%.1f", Ping * 1000) )

            Debug_Ping.Text = string.format("Latency : %sms", FormattedPing)

            if FormattedPing >= 450 then
                Debug_Ping.Color = Color3.new(0.7, 0.15, 0.15)
            elseif FormattedPing >= 300 then
                Debug_Ping.Color = Color3.new(0.8, 0.45, 0.45)
            elseif FormattedPing >= 180 then
                Debug_Ping.Color = Color3.new(1, 1, 0.6)
            else
                Debug_Ping.Color = Color3.new(1, 1, 1)
            end
        end

        do -- Debug FPS
            Debug_Fps.Text = string.format("FPS : %s", FPSCounter)

            if FPSCounter <= 10 then -- skill issue
                Debug_Fps.Color = Color3.new(0.8, 0.1, 0.1)
            elseif FPSCounter <= 20 then
                Debug_Fps.Color = Color3.new(1, 0.6, 0.2)
            elseif FPSCounter <= 28 then
                Debug_Fps.Color = Color3.new(1, 1, 0.2)
            else
                Debug_Fps.Color = Color3.new(1, 1, 1)
            end

            FPSCounter += 1
            task.delay(1, function()
                FPSCounter -= 1
            end)
        end

        do -- Debug Velocity / Position
            local Velocity = LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity
            local Position = LocalPlayer.Character.HumanoidRootPart.Position

            Debug_LocalVelocity.Text = string.format("Client Velocity : %i ( %i %i %i )", Velocity.Magnitude, Velocity.X, Velocity.Y, Velocity.Z)
            Debug_LocalPosition.Text = string.format("Client Position : ( %i %i %i )", Position.X, Position.Y, Position.Z)
        end
    end),

    game.Players.PlayerAdded:Connect(function(Player)
        repeat task.wait() until Player:GetAttribute("GroupRank")

        local Rank = Tags[Player:GetAttribute("GroupRank")]
        if Rank then
            Library:Notify("[ Pathos ] ⚠ '".. Player.DisplayName .. " (@".. Player.Name ..")' is ranked '".. Rank .."' in the Dorcus Digital Group.", 10)

            local Sound = Instance.new("Sound")
            Sound.Parent = game:GetService("SoundService")
            Sound.SoundId = "rbxassetid://8784885431"
            Sound.PlaybackSpeed = 1.05 -- Sounds cooler idk
            Sound.Volume = 4

            Sound.PlayOnRemove = true
            Sound:Destroy()
        end
    end),

    workspace.Sounds.Music.ChildAdded:Connect(function(v)
        if Toggles.MG_OldBossThemes.Value then
            if v.Name == "Mad MechanicPlaying" then
                v.SoundId = MoreGunReversedID
                v.Volume = 0.45
            elseif v.Name == "Bloxy BoyPlaying" then
                v.SoundId = InterludeID
                v.Volume = 0.2
            end
        end
    end)

    --[[game.Players.PlayerAdded:Connect(function(Player)
        local Name = Drawing.new("Text")
	end)]]
}

for _, Player in game.Players:GetPlayers() do
    task.spawn(function()
        repeat task.wait() until Player:GetAttribute("GroupRank")

        local Rank = Tags[Player:GetAttribute("GroupRank")]
        if Rank then
            Library:Notify("[ Pathos ] ⚠ '".. Player.DisplayName .. " (@".. Player.Name ..")' is ranked '".. Rank .."' in the Dorcus Digital Group.", 10)

            local Sound = Instance.new("Sound")
            Sound.Parent = game:GetService("SoundService")
            Sound.SoundId = "rbxassetid://8784885431"
            Sound.PlaybackSpeed = 1.05 -- Sounds cooler idk
            Sound.Volume = 4

            Sound.PlayOnRemove = true
            Sound:Destroy()
        end
    end)
end

local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(v, ...)
    local Method = getnamecallmethod()
    local Script = getcallingscript()
    local Arguments = {...}

    if EnableHook then
        if Method == "Raycast" and AimPosition then
			-- WONT WORK LOL THIS GAME IS SO SHIT
            --[[if tostring(Script) == "Client" then

                print()
                print(Arguments[1] == GameCamera.GetCameraAimCFrame().Position)
                print(Arguments[2] == CFrame.new(GameCamera.GetCameraAimCFrame().Position, GameCamera.GetCameraAimCFrame().Position + GameCamera.GetCameraAimCFrame().LookVector * 999).LookVector * ((LocalPlayer.Character.Hitbox.Size.X / 2) + (CurrentGun.Value.Range.Value / 16)))

                if Arguments[1] == GameCamera.GetCameraAimCFrame().Position and Arguments[2] == CFrame.new(GameCamera.GetCameraAimCFrame().Position, GameCamera.GetCameraAimCFrame().Position + GameCamera.GetCameraAimCFrame().LookVector * 999).LookVector * ((LocalPlayer.Character.Hitbox.Size.X / 2) + (CurrentGun.Value.Range.Value / 16)) then

                    Arguments[2] = AimPosition - Arguments[1]
                    return namecall(v, unpack(Arguments))

                end

            else]]
            if not Script then
				
                local LookPosition = workspace.CurrentCamera.CFrame.LookVector
                local Spread = ((Arguments[2] / CurrentGun.Value.Range.Value) - LookPosition)

                Arguments[2] = ((AimPosition - Arguments[1]).Unit + (GunType == 1 and Spread or Vector3.zero)) * CurrentGun.Value.Range.Value

                return namecall(v, unpack(Arguments))

            end

        end

        if Method == "FireServer" or Method == "InvokeServer" then
            if table.find(BlacklistedRemoteNames, v.Name) then

                Library:Notify("[ Pathos ] Blacklisted remote was attempted to be called! ( " .. v.Name .. " )")
                print("[ Pathos ] Blacklisted remote was attempted to be called! ( " .. v.Name .. " )")
                return

            end

            local Cooldown = MinimumCooldown[v.Name]
            if Cooldown then

                if (tick() - Cooldown.Tick) <= Cooldown.Time then
                    return
                else
                    Cooldown.Tick = tick()
                end

            end
		end

    end
    --return namecall(v, unpack(Arguments))

    return namecall(v, ...)
end))

task.spawn(function()
	while true do
        local Tick = tick()
        game.ReplicatedStorage.Functions.Ping:InvokeServer()

        Ping = tick() - Tick
	end
end)

-- Everything else vvv

task.spawn(function()

    local MenuProperties = Tabs.Config:AddLeftGroupbox("Menu")
    
    -- bad idea honestly..
    --[[
    MenuProperties:AddButton("Unload", function()
        Library:Unload()
        Library.Unloaded = true

        for _, Connection in Connections do
            Connection:Disconnect()
        end

        EnableHook = false
    end)
    ]]

    MenuProperties:AddLabel("Menu bind"):AddKeyPicker("MP_MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
    MenuProperties:AddDivider()
    MenuProperties:AddToggle("MP_ShowKeybinds", { Text = "Show Keybinds", Default = false })

    Toggles.MP_ShowKeybinds:OnChanged(function()
        Library.KeybindFrame.Visible = Toggles.MP_ShowKeybinds.Value
    end)

    Library.ToggleKeybind = Options.MP_MenuKeybind

    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder("Pathos/Themes")
    ThemeManager:ApplyToTab(Tabs.Config)

    SaveManager:SetLibrary(Library)
    SaveManager:SetFolder("Pathos/TypicalColors2")
    SaveManager:BuildConfigSection(Tabs.Config)
    SaveManager:IgnoreThemeSettings()
    SaveManager:LoadAutoloadConfig()

    ErrorMessageOut:Disconnect()

end)
