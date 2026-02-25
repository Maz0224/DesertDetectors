
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flyEnabled = false
local noclipEnabled = false
local infJumpEnabled = false
local sprintEnabled = false

local flySpeed = 50
local sprintSpeed = 32

local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

local Window = Luna:CreateWindow({
    Name = "Desert Detectors • Maz24",
    Subtitle = "OP GUI",
    LogoID = nil,

    LoadingEnabled = true,
    LoadingTitle = "Desert Detectors • Maz24",
    LoadingSubtitle = "Loading Interface...",

    ConfigSettings = {
        RootFolder = "DesertDetectors",
        ConfigFolder = "MainConfig"
    },

    KeySystem = false,

    KeySettings = {
        Title = "Access Key",
        Subtitle = "Enter Key",
        Note = "Private build.",
        SaveInRoot = false,
        SaveKey = false,
        Key = {"maz24-access"},
        SecondAction = {
            Enabled = false,
            Type = "Link",
            Parameter = ""
        }
    }
})

local Tab = Window:CreateTab({
    Name = "Player",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true -- This will determine whether the big header text in the tab will show
})

-- WalkSpeed
Tab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Value
        end
    end
}, "WalkSpeed")

-- JumpPower
Tab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
}, "JumpPower")

-- Infinite Jump
Tab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        infJumpEnabled = Value
    end
})

UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip
Tab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        noclipEnabled = Value
    end
})

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Tab:CreateDivider()

-- Fly
Tab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        flyEnabled = Value
    end
})

Tab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        flySpeed = Value
    end
}, "FlySpeed")

RunService.RenderStepped:Connect(function(delta)
    if flyEnabled and player.Character then
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local moveDir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += workspace.CurrentCamera.CFrame.RightVector end
            hrp.CFrame += moveDir * (flySpeed * delta)
        end
    end
end)

Tab:CreateDivider()

-- FOV
Tab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = workspace.CurrentCamera.FieldOfView,
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
}, "FOV")

Tab:CreateDivider()

-- Sprint
Tab:CreateToggle({
    Name = "Sprint",
    CurrentValue = false,
    Callback = function(Value)
        sprintEnabled = Value
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Value and sprintSpeed or 16
        end
    end
})


Tab:CreateSlider({
    Name = "Sprint Speed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 32,
    Callback = function(Value)
        sprintSpeed = Value
        if sprintEnabled then
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = sprintSpeed
            end
        end
    end
}, "SprintSpeed")


Tab:CreateDivider()

-- Reset Button
Tab:CreateButton({
    Name = "Reset Player Settings",
    Callback = function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
        workspace.Gravity = 196.2
        workspace.CurrentCamera.FieldOfView = 70
    end
})

local opTab = Window:CreateTab({
    Name = "Overpowered",
    Icon = "view_in_ar",
    ImageSource = "Material",
    ShowTitle = true -- This will determine whether the big header text in the tab will show
})

local infiniteMoneyLoop -- forward-declare the loop task

local infiniteMoneyEnabled = false

-- Function that runs the money loop
local function InfiniteMoney()
    while infiniteMoneyEnabled do
        local args = {
            [1] = {
                [1] = "Getting Settled";
                [2] = {
                    [1] = {0, 0};
                    [2] = "Any";
                };
                [3] = {[1] = math.random(10000000, 1000000000000)};
                [4] = "Return to the cotton fields";
            };
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Give_Quest", 9e9):FireServer(unpack(args))

        local argsWin = {[1] = "Getting Settled"}
        game:GetService("ReplicatedStorage"):WaitForChild("Win_Quest", 9e9):FireServer(unpack(argsWin))

        task.wait(0)
    end
end

local Toggle = opTab:CreateToggle({
    Name = "Infinite Money + Levels",
    Description = nil,
    CurrentValue = false,
    Callback = function(Value)
        infiniteMoneyEnabled = Value

        if Value then
            task.spawn(InfiniteMoney)
        end
    end
}, "InfiniteMoneyToggle")

local Button = opTab:CreateButton({
    Name = "Buy All Shovels",
    Callback = function()

        for _, shovel in pairs(game:GetService("ReplicatedStorage"):WaitForChild("Shovels"):GetChildren()) do
            
            local args = {shovel.Name}

            local remote = game:GetService("Players")
                :WaitForChild(player.Name)
                :WaitForChild("PlayerGui")
                :WaitForChild("Display_Frame")
                :WaitForChild("Shop_Purchase")
                :WaitForChild("Lower_Frame")
                :GetChildren()[1]
                :WaitForChild("Interior")
                :WaitForChild("RemoteEvent")

            remote:FireServer(unpack(args))

            task.wait(0.1) -- small delay so it doesn’t spam instantly
        end

    end
}, "BuyAllShovelsButton")

local Button = opTab:CreateButton({
    Name = "Buy All Detectors",
    Callback = function()

        for _, shovel in pairs(game:GetService("ReplicatedStorage"):WaitForChild("Metal_Detectors"):GetChildren()) do
            
            local args = {shovel.Name}

            local remote = game:GetService("Players")
                :WaitForChild(player.Name)
                :WaitForChild("PlayerGui")
                :WaitForChild("Display_Frame")
                :WaitForChild("Shop_Purchase")
                :WaitForChild("Lower_Frame")
                :GetChildren()[1]
                :WaitForChild("Interior")
                :WaitForChild("RemoteEvent")

            remote:FireServer(unpack(args))

            task.wait(0.1) -- small delay so it doesn’t spam instantly
        end

    end
}, "BuyAllDectButton")
