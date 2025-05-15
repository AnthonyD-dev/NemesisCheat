local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

local win = DiscordLib:Window("Nemesis Client")

local serv = win:Server("Home", "")

local btns = serv:Channel("Server")

btns:Button("Server-Hop", function()
DiscordLib:Notification("Notification", "Swtiching server...", "Okay!")
end)

btns:Button("Rejoin", function()
DiscordLib:Notification("Notification", "Rejoining...", "Okay!")
end)

btns:Button("Chat Bypass [FE]", function()
local CommandPrefix = "/s" -- You can set a custom prefix here.

---------------------------------------------------------------------------------------------------
local bc = {"اا"}
local r = function(size)
return math.random(1,size)
end
if _G.chatBypassScript == nil then
_G.chatBypassScript = 0
end
local currentVersion = _G.chatBypassScript + 1
_G.chatBypassScript = currentVersion
game.Players.LocalPlayer.Chatted:Connect(function(a)
  if currentVersion == _G.chatBypassScript then
      if a:sub(1,3) == CommandPrefix.." " then
          a = a:sub(4,#a)
          local b = ""..bc[r(#bc)]
          for i=1,#a do
              b = b..bc[r(#bc)]..a:sub(i,i)
          end         
          game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(b,"All")
      end
  end
end)
end)

local mods = serv:Channel("Modules")

mods:Toggle("Infinite Jump",false, function(jmp)

    _G.infinjump = jmp
     
    local Player = game:GetService("Players").LocalPlayer
    local Mouse = Player:GetMouse()
    Mouse.KeyDown:connect(function(k)
    if _G.infinjump then
    if k:byte() == 32 then
    Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    Humanoid:ChangeState("Jumping")
    wait(0.1)
    Humanoid:ChangeState("Seated")
    end
    end
    end)
    
    local Player = game:GetService("Players").LocalPlayer
    local Mouse = Player:GetMouse()
end)

mods:Toggle("Fly | E", false, function(enabled)
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local flying = false
    local speed = 50
    local velocity = Vector3.new(0, 0, 0)
    local bodyVelocity
    local connectionInput
    local connectionRender

    local moveVector = Vector3.new(0, 0, 0)

    local function startFly()
        if flying then return end
        flying = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = HumanoidRootPart

        connectionRender = RunService.RenderStepped:Connect(function()
            bodyVelocity.Velocity = (HumanoidRootPart.CFrame.LookVector * moveVector.Z + HumanoidRootPart.CFrame.RightVector * moveVector.X) * speed
            bodyVelocity.Velocity = Vector3.new(bodyVelocity.Velocity.X, (moveVector.Y * speed), bodyVelocity.Velocity.Z)
        end)
    end

    local function stopFly()
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if connectionRender then
            connectionRender:Disconnect()
            connectionRender = nil
        end
    end

    if enabled then
        startFly()
    else
        stopFly()
    end

    connectionInput = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.E then
            if flying then
                stopFly()
                mods:Set("Fly (Press E to toggle)", false)
            else
                startFly()
                mods:Set("Fly (Press E to toggle)", true)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        -- When key is released, reset the relevant moveVector part
        if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
            moveVector = Vector3.new(moveVector.X, moveVector.Y, 0)
        elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
            moveVector = Vector3.new(0, moveVector.Y, moveVector.Z)
        elseif input.KeyCode == Enum.KeyCode.Space then
            moveVector = Vector3.new(moveVector.X, 0, moveVector.Z)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            moveVector = Vector3.new(moveVector.X, 0, moveVector.Z)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.W then
            moveVector = Vector3.new(moveVector.X, moveVector.Y, 1)
        elseif input.KeyCode == Enum.KeyCode.S then
            moveVector = Vector3.new(moveVector.X, moveVector.Y, -1)
        elseif input.KeyCode == Enum.KeyCode.A then
            moveVector = Vector3.new(-1, moveVector.Y, moveVector.Z)
        elseif input.KeyCode == Enum.KeyCode.D then
            moveVector = Vector3.new(1, moveVector.Y, moveVector.Z)
        elseif input.KeyCode == Enum.KeyCode.Space then
            moveVector = Vector3.new(moveVector.X, 1, moveVector.Z)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            moveVector = Vector3.new(moveVector.X, -1, moveVector.Z)
        end
    end)
end)

mods:Seperator()

local cfov = mods:Slider("Custom FOV", 0, 120, 80, function(t)
game.Workspace.CurrentCamera.FieldOfView = t
end)

local walkspeed = mods:Slider("Walkspeed", 0, 300, 50, function(tz)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tz
end)

local jumpspeed = mods:Slider("Jumpspeed", 0, 300, 50, function(tzz)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = tzz
end)

local scrpt = serv:Channel("Script Hub")

scrpt:Button("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

scrpt:Button("Dark Dex Explorer", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
end)

scrpt:Button("Remote Spy (SimpleSpy)", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
end)

scrpt:Button("Unamed ESP", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
end)

scrpt:Button("Aimbot (Universal)", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/UniversalAimbot.lua"))()
end)

local drops = serv:Channel("Editor")



local clrs = serv:Channel("Colorpickers")

clrs:Colorpicker("ESP Color", Color3.fromRGB(255,1,1), function(t)
print(t)
end)

local textbs = serv:Channel("Textboxes")

textbs:Textbox("Gun power", "Type here!", true, function(t)
print(t)
end)

local lbls = serv:Channel("Labels")

lbls:Label("This is just a label.")

local bnds = serv:Channel("Binds")

bnds:Bind("Kill bind", Enum.KeyCode.RightShift, function()
print("Killed everyone!")
end)



local cmbt = win:Server("Combat", "")

local cmbthome = cmbt:Channel("Home")



local rndr = win:Server("Render", "")

local rndrhome = rndr:Channel("Home")

rndrhome:Button("Corner Box ESP", function()
-- Settings
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Box_Thickness = 2,
    Team_Check = false,
    Team_Color = false,
    Autothickness = true
}

--Locals
local Space = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Camera = Space.CurrentCamera

-- Locals
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function Vis(lib, state)
    for i, v in pairs(lib) do
        v.Visible = state
    end
end

local function Colorize(lib, color)
    for i, v in pairs(lib) do
        v.Color = color
    end
end

local Black = Color3.fromRGB(0, 0, 0)

local function Rainbow(lib, delay)
    for hue = 0, 1, 1/30 do
        local color = Color3.fromHSV(hue, 0.6, 1)
        Colorize(lib, color)
        wait(delay)
    end
    Rainbow(lib)
end
--Main Draw Function
local function Main(plr)
    repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil
    local R15
    if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
        R15 = true
    else 
        R15 = false
    end
    local Library = {
        TL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        TR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        TR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BL1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BL2 = NewLine(Settings.Box_Color, Settings.Box_Thickness),

        BR1 = NewLine(Settings.Box_Color, Settings.Box_Thickness),
        BR2 = NewLine(Settings.Box_Color, Settings.Box_Thickness)
    }
    coroutine.wrap(Rainbow)(Library, 0.15)
    local oripart = Instance.new("Part")
    oripart.Parent = Space
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)
    --Updater Loop
    local function Updater()
        local c 
        c = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Hum = plr.Character
                local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
                if vis then
                    oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y*1.5, Hum.HumanoidRootPart.Size.Z)
                    oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                    local SizeX = oripart.Size.X
                    local SizeY = oripart.Size.Y
                    local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                    local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                    local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                    local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                    if Settings.Team_Check then
                        if plr.TeamColor == Player.TeamColor then
                            Colorize(Library, Color3.fromRGB(0, 255, 0))
                        else 
                            Colorize(Library, Color3.fromRGB(255, 0, 0))
                        end
                    end

                    if Settings.Team_Color then
                        Colorize(Library, plr.TeamColor.Color)
                    end

                    local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).magnitude
                    local offset = math.clamp(1/ratio*750, 2, 300)

                    Library.TL1.From = Vector2.new(TL.X, TL.Y)
                    Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                    Library.TL2.From = Vector2.new(TL.X, TL.Y)
                    Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                    Library.TR1.From = Vector2.new(TR.X, TR.Y)
                    Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                    Library.TR2.From = Vector2.new(TR.X, TR.Y)
                    Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                    Library.BL1.From = Vector2.new(BL.X, BL.Y)
                    Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                    Library.BL2.From = Vector2.new(BL.X, BL.Y)
                    Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                    Library.BR1.From = Vector2.new(BR.X, BR.Y)
                    Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                    Library.BR2.From = Vector2.new(BR.X, BR.Y)
                    Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                    Vis(Library, true)

                    if Settings.Autothickness then
                        local distance = (Player.Character.HumanoidRootPart.Position - oripart.Position).magnitude
                        local value = math.clamp(1+distance*100, 1, 4) --0.1 is min thickness, 6 is max
                        for u, x in pairs(Library) do
                            x.Thickness = value
                        end
                    else 
                        for u, x in pairs(Library) do
                            x.Thickness = Settings.Box_Thickness
                        end
                    end
                else 
                    Vis(Library, false)
                end
            else 
                Vis(Library, false)
                if game:GetService("Players"):FindFirstChild(plr.Name) == nil then
                    for i, v in pairs(Library) do
                        v:Remove()
                        oripart:Destroy()
                    end
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Draw Boxes
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= Player.Name then
      coroutine.wrap(Main)(v)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(newplr)
    coroutine.wrap(Main)(newplr)
end)
end)

rndrhome:Button("3D Box ESP", function()
-- Services
local RunService = game:GetService("RunService");
local PlayersService = game:GetService("Players");

-- Variables
local Camera = workspace.CurrentCamera;
local LastPos;
local Lines = {};
local Quads = {};

-- Functions
local function HasCharacter(Player)
    return Player.Character and Player.Character:FindFirstChild("HumanoidRootPart");
end;

local function DrawQuad(PosA, PosB, PosC, PosD)
    local PosAScreen, PosAVisible = Camera:WorldToViewportPoint(PosA);
    local PosBScreen, PosBVisible = Camera:WorldToViewportPoint(PosB);
    local PosCScreen, PosCVisible = Camera:WorldToViewportPoint(PosC);
    local PosDScreen, PosDVisible = Camera:WorldToViewportPoint(PosD);

    if (not PosAVisible and not PosBVisible and not PosCVisible and not PosDVisible) then return; end;

    local PosAVec = Vector2.new(PosAScreen.X, PosAScreen.Y);
    local PosBVec = Vector2.new(PosBScreen.X, PosBScreen.Y);
    local PosCVec = Vector2.new(PosCScreen.X, PosCScreen.Y);
    local PosDVec = Vector2.new(PosDScreen.X, PosDScreen.Y);

    local Quad = Drawing.new("Quad");
        Quad.Thickness = .5;
        Quad.Color = Color3.fromRGB(255, 255, 255);
        Quad.Transparency = .25;
        Quad.ZIndex = 1;
        Quad.Filled = true
        Quad.Visible = true;

        Quad.PointA = PosAVec;
        Quad.PointB = PosBVec;
        Quad.PointC = PosCVec;
        Quad.PointD = PosDVec;

    table.insert(Quads, Quad)
end
rndrhome:Colorpicker("ESP Color", Color3.fromRGB(255,1,1), function(colorpick)
Quad.Color = colorpick
end)
local function DrawLine(From, To)
    local FromScreen, FromVisible = Camera:WorldToViewportPoint(From);
    local ToScreen, ToVisible = Camera:WorldToViewportPoint(To);

    if (not FromVisible and not ToVisible) then return; end;

    local FromPos = Vector2.new(FromScreen.X, FromScreen.Y);
    local ToPos = Vector2.new(ToScreen.X, ToScreen.Y);

    local Line = Drawing.new("Line");
        Line.Thickness = 1;
        Line.From = FromPos
        Line.To = ToPos
        Line.Color = Color3.fromRGB(255, 255, 255);
        Line.Transparency = 1;
        Line.ZIndex = 1;
        Line.Visible = true;

    table.insert(Lines, Line)
end

-- Thank you Nahida#5000 for this function (GetCorners = GetVertices)
local function GetCorners(Part)
    local CF, Size, Corners = Part.CFrame, Part.Size / 2, {};
    for X = -1, 1, 2 do for Y = -1, 1, 2 do for Z = -1, 1, 2 do
        Corners[#Corners+1] = (CF * CFrame.new(Size * Vector3.new(X, Y, Z))).Position;      
    end; end; end;
    return Corners;
end;

local function DrawEsp(Player)
    local HRP = Player.Character.HumanoidRootPart;

    -- Constructing the 3d box.
    local CubeVertices = GetCorners({CFrame = HRP.CFrame * CFrame.new(0, -0.5, 0), Size = Vector3.new(3, 5, 3)});

    -- Drawing the 3d box.
        -- Bottom face:
        DrawLine(CubeVertices[1], CubeVertices[2]);
        DrawLine(CubeVertices[2], CubeVertices[6]);
        DrawLine(CubeVertices[6], CubeVertices[5]);
        DrawLine(CubeVertices[5], CubeVertices[1]);

        DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[6], CubeVertices[5]);
       
        -- Side faces:
        DrawLine(CubeVertices[1], CubeVertices[3]);
        DrawLine(CubeVertices[2], CubeVertices[4]);
        DrawLine(CubeVertices[6], CubeVertices[8]);
        DrawLine(CubeVertices[5], CubeVertices[7]);

        DrawQuad(CubeVertices[2], CubeVertices[4], CubeVertices[8], CubeVertices[6]);
        DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[4], CubeVertices[3]);
        DrawQuad(CubeVertices[1], CubeVertices[5], CubeVertices[7], CubeVertices[3]);
        DrawQuad(CubeVertices[5], CubeVertices[7], CubeVertices[8], CubeVertices[6]);

        -- Top face:
        DrawLine(CubeVertices[3], CubeVertices[4]);
        DrawLine(CubeVertices[4], CubeVertices[8]);
        DrawLine(CubeVertices[8], CubeVertices[7]);
        DrawLine(CubeVertices[7], CubeVertices[3]);
       
        DrawQuad(CubeVertices[3], CubeVertices[4], CubeVertices[8], CubeVertices[7]);
end;

local function BoxEsp()
    local Players = PlayersService:GetPlayers();

    for i = 1, #Lines do
        local Line = rawget(Lines, i);
        if (Line) then Line:Remove(); end;
    end;

    Lines = {};

    for i = 1, #Quads do
        local Quad = rawget(Quads, i);
        if (Quad) then Quad:Remove(); end;
    end;

    Quads = {};

    for i = 1, #Players do
        local Player = rawget(Players, i);
        if HasCharacter(Player) then
            DrawEsp(Player);
        end;
    end;
end;

-- Main
RunService.RenderStepped:Connect(BoxEsp);

end)


local ai = win:Server("A.I Combat", "")

local aihome = ai:Channel("Home")

aihome:Toggle("AI Lock", false, function(state)
    _G.AimbotEnabled = state

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local function getClosestTarget()
        local closest = nil
        local shortestDistance = math.huge

        for _, npc in pairs(workspace:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and npc ~= LocalPlayer.Character then
                local pos, visible = Camera:WorldToViewportPoint(npc.HumanoidRootPart.Position)
                if visible then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closest = npc
                    end
                end
            end
        end

        return closest
    end

    local function aimAt(target)
        if target and target:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end

    if _G.AimbotConnection then
        _G.AimbotConnection:Disconnect()
    end

    if _G.AimbotEnabled then
        _G.AimbotConnection = RunService.RenderStepped:Connect(function()
            local target = getClosestTarget()
            if target then
                aimAt(target)
            end
        end)
    end
end)
local cfg = win:Server("Config", "http://www.roblox.com/asset/?id=6031075938")

local savecfg = cfg:Channel("Save")

local loadcfg = cfg:Channel("Load")

local menu1 = loadcfg:Dropdown("Dropdown",{"Option 1","Option 2","Option 3","Option 4","Option 5"}, function(bool)
print(bool)
end)

loadcfg:Button("Clear", function()
menu1:Clear()
end)

loadcfg:Button("Add option", function()
menu1:Add("New Option!")
end)

local searchcfg = cfg:Channel("Search")

searchcfg:Textbox("Search..", "search here", true, function(t)
print(t)
end)

local thme = win:Server("UI Theme", "http://www.roblox.com/asset/?id=6031075938")

local custom = thme:Channel("Custom")
