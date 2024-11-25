local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local LocalPLR = game.Players.LocalPlayer

Username = getgenv().Username

local runScript = true
if LocalPLR.Name ~= Username then

    local logChat = getgenv().logChat
    webhook = getgenv().webhook

    Prefix = getgenv().Prefix

    local bots = getgenv().Bots

    local whitelist = {}
    local admins = {}

    local index
    function getIndex()

        for i, bot in ipairs(bots) do
            if LocalPLR.DisplayName == bot then
                index = i
                break
            end
        end

    end

    getIndex()

    function chat(msg)

        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        else
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end

    end

    chat("xnsWare v2 has been injected")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "xnsWare",
        Text = "Thank you for using xnsWare",
        Time = 6
    })

    function showDefaultGui(enabled, text)

        if enabled == true then
            for _, child in pairs(game:GetService("CoreGui"):GetChildren()) do
                if child.Name == "bruhIDK" then
                    child:Destroy()
                end
            end

            screenGui = Instance.new("ScreenGui")
            screenGui.Name = "bruhIDK"
            screenGui.IgnoreGuiInset = true
            screenGui.Parent = game:GetService("CoreGui")

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(0, 205, 216)
            frame.Parent = screenGui

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = text
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextSize = 40
            textLabel.TextScaled = true
            textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            textLabel.Parent = frame
        elseif enabled == false then
            if screenGui then
                screenGui:Destroy()
            end
        end

    end

    function sendToWebhook(msg, username)
        if index ~= 1 then
            return
        end

        local data = {
            content = msg,
            username = username
        }

        local requestData = {
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
            },
            Body = HttpService:JSONEncode(data)
        }

        request(requestData)
    end

    function specifyBots(sub, callback)

        local botArgs = getArgs(sub)

        if next(botArgs) ~= nil then
            for _, arg in ipairs(botArgs) do
                if index == tonumber(arg) then
                    callback()
                end
            end
        else
            callback()
        end

    end

    function specifyBots2(argTable, tableStartIndex, callback)

        local botArgs = {}

        for i = tableStartIndex, #argTable do
            table.insert(botArgs, argTable[i])
        end

        if #botArgs == 0 then
            callback()
        else
            for _, botArg in ipairs(botArgs) do
                if index == tonumber(botArg) then
                    callback()
                end
            end
        end

    end

    function getArgs(command)

        local args = {}

        for arg in command:match("^%s*(.-)%s*$"):gmatch("%S+") do
            table.insert(args, arg)
        end

        return args

    end

    function isR15(returnValTrue, returnValFalse)

        if LocalPLR.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
            if returnValTrue then
                return returnValTrue
            else
                return true
            end
        elseif LocalPLR.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            if returnValFalse then
                return returnValFalse
            else
                return false
            end
        end

    end

    function isWhitelisted(name)

        if name == Username then
            return true
        end

        for _, adminUser in pairs(admins) do
            if name == adminUser then
                return true
            end
        end

        for _, whitelistedUser in pairs(whitelist) do
            if name == whitelistedUser then
                return true
            end
        end

        return false
    end

    function isAdmin(name)

        for _, adminUser in pairs(admins) do
            if name == adminUser then
                return true
            end
        end

        return false
    end

    -- RANDOM VARS:
    local normalGravity = 196.2

    function commands(player, message)
        local msg = message:lower()

        if not isWhitelisted(player.Name) then
            return
        end

        function getFullPlayerName(typedName)

            if typedName == "me" then
                return player.Name
            end

            for _, plr in pairs(game.Players:GetPlayers()) do
                if string.find(plr.Name, typedName) then
                    return plr.Name
                end
            end

        end

        -- WHITELIST:
        if msg:sub(1, 11) == Prefix .. "addwhitelist" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local targetPLR = message:sub(13)

            if game.Players[targetPLR] then
                table.insert(whitelist, targetPLR)

                if index == 1 then
                    chat("Player(s) has been whitelisted to run commands")
                end
            elseif index == 1 then
                chat("The player(s) your trying to whitelist was not found")
            end
        end

        if msg:sub(1, 11) == Prefix .. "removewhitelist" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local targetPLR = message:sub(13)

            for i, whitelistedUser in pairs(whitelist) do
                if whitelistedUser == targetPLR then
                    table.remove(whitelist, i)

                    if index == 1 then
                        chat("Player(s) has been unwhitelisted to run commands")
                    end

                end
            end
        end

        if msg:sub(1, 7) == Prefix .. "addadmin" then

            if player.Name ~= Username then
                return
            end

            local targetPLR = message:sub(9)

            if game.Players[targetPLR] then
                table.insert(admins, targetPLR)

                if index == 1 then
                    chat("Player(s) has been added to admin")
                end
            elseif index == 1 then
                chat("The player(s) your trying to add to admin was not found")
            end
        end

        if msg:sub(1, 7) == Prefix .. "removeadmin" then

            if player.Name ~= Username then
                return
            end

            local targetPLR = message:sub(9)

            for i, adminUser in pairs(admins) do
                if adminUser == targetPLR then
                    table.remove(admins, i)

                    if index == 1 then
                        chat("Player(s) has been removed from admin")
                    end

                end
            end
        end

        -- BOTREMOVE:
        if msg:sub(1, 10) == Prefix .. "removebot" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local targetIndex = tonumber(msg:sub(12))
            if not targetIndex then
                if index == 1 then
                    chat("Please enter the bot username that you want to remove")
                end

                return
            end

            table.remove(bots, targetIndex)
            if index == targetIndex then
                Username = ""
                whitelist = {}
                admins = {}

                script:Destroy()
            end

            getIndex()
            if index == 1 then
                chat("Bot " .. targetIndex .. " has been removed")
            end
        end

        -- PRINTCMDS:
        if msg:sub(1, 10) == Prefix .. "cmds" then

            print("\n---------- xnsWare Commands ----------\n" .. request({ Url = "https://raw.githubusercontent.com/unknowngamer123-a/xnsWare/refs/heads/main/commands.txt", Method = "GET" }).Body)
            if index == 1 then
                chat("The commands has been printed to the console, press F9 or /console to see them")
            end
        end

        -- REJOIN:
        if msg:sub(1, 7) == Prefix .. 'rejoin' then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            function runCode()
                LocalPLR:Kick("Rejoining the server")
                wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPLR)
            end

            specifyBots(msg:sub(9), runCode)

        end

        -- RESET:
        if msg:sub(1, 6) == Prefix .. "reset" then

            function runCode()
                LocalPLR.Character.Humanoid.Health = 0
            end

            specifyBots(msg:sub(8), runCode)

        end

        -- JUMP:
        if msg:sub(1, 5) == Prefix .. "jump" then

            function runCode()
                LocalPLR.Character.Humanoid.Jump = true
            end

            specifyBots(msg:sub(7), runCode)

        end

        -- BRING:
        if msg:sub(1, 6) == Prefix .. "bring" then

            function runCode()
                LocalPLR.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Players[player.Name].Character:FindFirstChild("HumanoidRootPart").CFrame
            end

            specifyBots(msg:sub(8), runCode)

        end

        -- CHAT:
        if msg:sub(1, 5) == Prefix .. "chat" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            chat(message:sub(7))

        end

        -- SIT:
        if msg:sub(1, 4) == Prefix .. "sit" then

            function runCode()
                LocalPLR.Character.Humanoid.Sit = true
            end

            specifyBots(msg:sub(6), runCode)

        end

        -- SPEED:
        if msg:sub(1, 6) == Prefix .. "speed" then
            local args = getArgs(msg:sub(8))

            function runCode()
                LocalPLR.Character.Humanoid.WalkSpeed = args[1]
            end

            specifyBots2(args, 2, runCode)

        end

        -- LINEUP:
        if msg:sub(1, 7) == Prefix .. "sts" then

            local direction = msg:sub(9)
            local spacing = 3

            local targetHumanoidRootPart = game.Players[player.Name].Character.HumanoidRootPart

            local directionVector
            if direction == "front" then
                spacing = 3
                directionVector = targetHumanoidRootPart.CFrame.LookVector
            elseif direction == "back" then
                spacing = 3
                directionVector = -targetHumanoidRootPart.CFrame.LookVector
            elseif direction == "left" then
                spacing = 5
                directionVector = -targetHumanoidRootPart.CFrame.RightVector
            elseif direction == "right" then
                spacing = 5
                directionVector = targetHumanoidRootPart.CFrame.RightVector
            end

            local offset = directionVector * (spacing * index)
            LocalPLR.Character.HumanoidRootPart.CFrame = targetHumanoidRootPart.CFrame + offset

        end

        -- SHUTDOWN:
        if msg:sub(1, 9) == Prefix .. "leave" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            function runCode()
                game:Shutdown()
            end

            specifyBots(msg:sub(11), runCode)

        end

        -- SURROUND:
        if msg:sub(1, 9) == Prefix .. "surround" then -- LITERALY COPY PASTE OF ORBIT COMMAND(too lazy srry)

            local args = getArgs(message:sub(11))
            local targetPLR = getFullPlayerName(args[1])

            local player = game.Players[targetPLR].Character.HumanoidRootPart
            local lpr = LocalPLR.Character.HumanoidRootPart

            local speed = 8
            local radius = 8
            local spacing = tonumber(args[2]) or 1
            local eclipse = 1

            local sin, cos = math.sin, math.cos
            local rotspeed = math.pi*2/speed
            eclipse = eclipse * radius

            local rot = 0

            rot = rot + rotspeed

            local offsetAngle = rot - (index * spacing)
            local offset = Vector3.new(sin(offsetAngle) * eclipse, 0, cos(offsetAngle) * radius)
            local newPosition = player.Position + offset

            lpr.CFrame = CFrame.new(newPosition, player.Position)

        end

        -- JORK(yep under 4k):
        if msg:sub(1, 5) == Prefix .. "sus" then
            local args = getArgs(msg:sub(7))
            local speed = tonumber(args[1]) or 1

            function runCode()
                jorkAnim = Instance.new("Animation")
                jorkAnim.AnimationId = "rbxassetid://99198989"

                animTrack = LocalPLR.Character.Humanoid:LoadAnimation(jorkAnim)
                animTrack.Looped = true
                animTrack:Play()
                animTrack:AdjustSpeed(speed)

                jorkAnim2 = Instance.new("Animation")
                jorkAnim2.AnimationId = "rbxassetid://168086975"

                animTrack2 = LocalPLR.Character.Humanoid:LoadAnimation(jorkAnim2)
                animTrack2.Looped = true
                animTrack2:Play()
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 7) == Prefix .. "stopsus" then

            function runCode()
                if jorkAnim then
                    jorkAnim:Destroy()
                    animTrack:Stop()
                end

                if jorkAnim2 then
                    jorkAnim2:Destroy()
                    animTrack2:Stop()
                end
            end

            specifyBots(msg:sub(9), runCode)

        end

        -- SCM:
        if msg:sub(1, 4) == Prefix .. "robux" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local scamLines = {
                "🤑 WANT FREE BOBUX? GO TO SCAM.COM TO GET FREE BOBUX 🤑",
                "🤑 FREE ROBUX NO CAP! JUST SEND YOUR ROBLOX USERNAME AND PASSWORD TO TRUSTWORTHYBOBUXPROVIDER.GOV 🤑",
                "🤑 WANT FREE BOBUX? JUST ENTER YOUR PASSWORD AT FREEBOBUX4U.COM 🤑",
                "🔥 FREE BOBUX? JUST PUT YOUR USERNAME AND PASSWORD AT FREEBOBUX.HACK 🔥",
                "💸 GET 100,000 ROBUX FAST! GO TO LEGITROBUXGENERATOR.NET 💸",
                "😎 WANT UNLIMITED BOBUX? CLICK THE LINK AND ENTER YOUR DETAILS! REALROBUXGEN.BIZ 😎"
            }

            function runCode()
                chat(loadstring(game:HttpGet("https://raw.githubusercontent.com/sixpennyfox4/rbx/refs/heads/main/xploitModule.lua"))().BypassText(scamLines[math.random(1, #scamLines)], 1))
            end

            specifyBots(msg:sub(6), runCode)
        end

        -- ORBIT:
        if msg:sub(1, 6) == Prefix .. "orbit" then

            local args = getArgs(message:sub(8))
            local targetPLR = getFullPlayerName(args[1])

            local player = game.Players[targetPLR].Character.HumanoidRootPart
            local lpr = LocalPLR.Character.HumanoidRootPart

            local speed = tonumber(args[2]) or 8
            local radius = 8
            local spacing = 1
            local eclipse = 1

            local sin, cos = math.sin, math.cos
            local rotspeed = math.pi*2/speed
            eclipse = eclipse * radius

            local rot = 0

            function runCode()
                workspace.Gravity = 0

                orbit1 = game:GetService('RunService').Stepped:connect(function(t, dt)
                    rot = rot + dt * rotspeed

                    local offsetAngle = rot - (index * spacing)
                    local offset = Vector3.new(sin(offsetAngle) * eclipse, 0, cos(offsetAngle) * radius)
                    local newPosition = player.Position + offset

                    lpr.CFrame = CFrame.new(newPosition, player.Position)
                end)
            end

            specifyBots2(args, 3, runCode)
        end

        if msg:sub(1, 8) == Prefix .. "unorbit" then

            function runCode()
                if orbit1 then
                    orbit1:Disconnect()
                    workspace.Gravity = normalGravity
                end

                if orbit2 then
                    orbit2:Disconnect()
                    workspace.Gravity = normalGravity
                end

                if lineorbitF then
                    lineorbitF:Disconnect()
                    workspace.Gravity = normalGravity
                end
            end

            specifyBots(msg:sub(10), runCode)

        end

        -- GOTO:
        if msg:sub(1, 5) == Prefix .. "goto" then
            local args = getArgs(message:sub(7))

            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                if game.Players[targetPLR] then
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame
                end
            end

            specifyBots2(args, 2, runCode)

        end

        -- FOLLOW:
        if msg:sub(1, 7) == Prefix .. "follow" then
            local args = getArgs(message:sub(9))

            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                followF = RunService.Heartbeat:Connect(function()
                    LocalPLR.Character:FindFirstChild("Humanoid"):MoveTo(game.Players[targetPLR].Character:FindFirstChild("HumanoidRootPart").Position)
                end)
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 9) == Prefix .. "unfollow" then

            function runCode()
                followF:Disconnect()
            end

            specifyBots(msg:sub(11), runCode)

        end

        -- LINEFOLLOW:
        if msg:sub(1, 11) == Prefix .. "linefollow" then
            local args = getArgs(message:sub(13))

            local spacing = 3
            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                linefollowF = RunService.Heartbeat:Connect(function()
                    LocalPLR.Character:FindFirstChild("Humanoid"):MoveTo(game.Players[targetPLR].Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, spacing * index).Position)

                    LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPLR.Character.HumanoidRootPart.Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
                end)
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 13) == Prefix .. "unlinefollow" then

            function runCode()
                linefollowF:Disconnect()
            end

            specifyBots(msg:sub(15), runCode)

        end

        -- ANTI-BANG:
        if msg:sub(1, 9) == Prefix .. "antibang" then

                function runCode()

                    local root = LocalPLR.Character:WaitForChild("HumanoidRootPart")

                    workspace.FallenPartsDestroyHeight = -1000
                    local originalPosition = root.CFrame
                    root.CFrame = CFrame.new(Vector3.new(0, -500, 0))

                    wait(1)

                    root.CFrame = originalPosition
                    workspace.FallenPartsDestroyHeight = -500

                end

                specifyBots(msg:sub(11), runCode)

        end

        -- FREEZE
        if msg:sub(1, 7) == Prefix .. "freeze" then

            function runCode()
                for _, child in pairs(LocalPLR.Character:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Anchored = true
                    end
                end
            end

            specifyBots(msg:sub(9), runCode)

        end

        if msg:sub(1, 9) == Prefix .. "unfreeze" then

            function runCode()
                for _, child in pairs(LocalPLR.Character:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Anchored = false
                    end
                end
            end

            specifyBots(msg:sub(11), runCode)

        end

        -- BACKFLIP (credits to a random script i found):
        if msg:sub(1, 9) == Prefix .. "backflip" then

            function runCode()
                LocalPLR.Character.Humanoid:ChangeState("Jumping")
                wait()
                LocalPLR.Character.Humanoid.Sit = true
                for i = 1,360 do
                    delay(i/720,function()
                        LocalPLR.Character.Humanoid.Sit = true
                        LocalPLR.Character.HumanoidRootPart.CFrame = LocalPLR.Character.HumanoidRootPart.CFrame * CFrame.Angles(0.0174533, 0, 0)
                    end)
                end
                wait(0.55)
                LocalPLR.Character.Humanoid.Sit = false
            end

            specifyBots(msg:sub(11), runCode)

        end

        if msg:sub(1, 10) == Prefix .. "frontflip" then

            function runCode()
                LocalPLR.Character.Humanoid:ChangeState("Jumping")
                wait()
                LocalPLR.Character.Humanoid.Sit = true
                for i = 1,360 do
                    delay(i/720,function()
                        LocalPLR.Character.Humanoid.Sit = true
                        LocalPLR.Character.HumanoidRootPart.CFrame = LocalPLR.Character.HumanoidRootPart.CFrame * CFrame.Angles(-0.0174533, 0, 0)
                    end)
                end
                wait(0.55)
                LocalPLR.Character.Humanoid.Sit = false
            end

            specifyBots(msg:sub(12), runCode)

        end

        -- STACK:
        if msg:sub(1, 6) == Prefix .. "stack" then
            local args = getArgs(message:sub(8))

            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                if game.Players[targetPLR].Character:FindFirstChild("HumanoidRootPart") then
                    workspace.Gravity = 0

                    local stackHeight = 3
                    local offset = (index - 1) * stackHeight

                    stackF = RunService.Heartbeat:Connect(function()

                        if LocalPLR.Character.Humanoid.Sit == false then
                            LocalPLR.Character.Humanoid.Sit = true
                        end

                        LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.Head.CFrame * CFrame.new(0, offset, 0)

                    end)
                end
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 8) == Prefix .. "unstack" then

            function runCode()
                if stackF then
                    stackF:Disconnect()
                end

                if stackF2 then
                    stackF2:Disconnect()
                end

                LocalPLR.Character.Humanoid.Sit = false

                workspace.Gravity = normalGravity
            end

            specifyBots(msg:sub(10), runCode)

        end

        -- FLING:
        if msg:sub(1, 6) == Prefix .. "fling" then
            local args = getArgs(message:sub(8))

            lastCFRAME = LocalPLR.Character.HumanoidRootPart.CFrame

            local targetPLR = args[1]
            if targetPLR == "all" then
                loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))() -- credits to the creator
                return
            else
                targetPLR = getFullPlayerName(args[1])
            end

            local flingSpeed = 1000

            function runCode()
                Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Flinging"
                Spin.Parent = LocalPLR.Character.HumanoidRootPart
                Spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                Spin.AngularVelocity = Vector3.new(0, flingSpeed, 0)

                FlingVelocity = Instance.new("BodyVelocity")
                FlingVelocity.Name = "FlingVelocity"
                FlingVelocity.Parent = LocalPLR.Character.HumanoidRootPart
                FlingVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                FlingVelocity.Velocity = Vector3.new(flingSpeed, flingSpeed, flingSpeed)

                followF = RunService.Heartbeat:Connect(function()
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame
                end)
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 8) == Prefix .. "unfling" then

            function runCode()
                Spin:Destroy()
                followF:Disconnect()
                FlingVelocity:Destroy()

                LocalPLR.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                LocalPLR.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)

                LocalPLR.Character.HumanoidRootPart.CFrame = lastCFRAME
            end

            specifyBots(msg:sub(10), runCode)

        end

        -- BANG:
        if msg:sub(1, 5) == Prefix .. "bang" then

            local args = getArgs(message:sub(7))
            local targetPLR = getFullPlayerName(args[1])

            local bangSpeed = tonumber(args[2]) or 10

            function runCode()
                if game.Players[targetPLR] then

                    bangAnim = Instance.new('Animation')
                    bangAnim.AnimationId = "rbxassetid://" .. isR15(5918726674, 148840371)
                    plrHum = LocalPLR.Character.Humanoid

                    anim = plrHum:LoadAnimation(bangAnim)
                    anim:Play()
                    anim:AdjustSpeed(bangSpeed)

                    bangLoop = RunService.Stepped:Connect(function()
                        wait()
                        LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1)
                    end)
                end

            end

            specifyBots2(args, 3, runCode)

        end

        -- FACEBANG:
        if msg:sub(1, 9) == Prefix .. "facebang" then

            local args = getArgs(message:sub(11))
            local targetPLR = getFullPlayerName(args[1])

            local bangSpeed = tonumber(args[2]) or 10
            local bangOffet = CFrame.new(0, 2.3, -1.1)

            function runCode()
                if game.Players[targetPLR] then

                    bangAnim2 = Instance.new('Animation')
                    bangAnim2.AnimationId = "rbxassetid://" .. isR15(5918726674, 148840371)
                    plrHum = LocalPLR.Character.Humanoid

                    anim2 = plrHum:LoadAnimation(bangAnim2)
                    anim2:Play(0.1, 1, 1)
                    anim2:AdjustSpeed(bangSpeed)

                    facebangLoop = RunService.Stepped:Connect(function()
                        wait()

                        local targetRoot = LocalPLR.Character:FindFirstChild("HumanoidRootPart")
                        targetRoot.CFrame = game.Players[targetPLR].Character:FindFirstChild("HumanoidRootPart").CFrame * bangOffet * CFrame.Angles(0,3.15,0)
                        targetRoot.Velocity = Vector3.new(0,0,0)
                    end)

                end
            end

            specifyBots2(args, 3, runCode)

        end

        if msg:sub(1, 7) == Prefix .. "unbang" then

            function runCode()
                if anim then
                    anim:Stop()
                    bangAnim:Destroy()
                end
                if bangLoop then
                    bangLoop:Disconnect()
                end
            end

            specifyBots(msg:sub(9), runCode)

        end

        if msg:sub(1, 8) == Prefix .. "unfacebang" then

            function runCode()
                if anim2 then
                    anim2:Stop()
                    bangAnim2:Destroy()
                end
                if facebangLoop then
                    facebangLoop:Disconnect()
                end
            end

            specifyBots(msg:sub(10), runCode)

        end

        -- CLEARCHAT (CREDITS TO @thereal_asu):
        if msg == Prefix .. "clearchat" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            if index == 1 then
                if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
                    chat("Welp, this didn't work")
                    return
                end

                blob = "\u{000D}"
                chat("." .. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. " ".. blob .. "----Chat Cleared----")
            end

        end

        -- ANNOUNCE:
        if msg:sub(1, 9) == Prefix .. "announce" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            if index == 1 then
                if TextChatService.ChatVersion ~= Enum.ChatVersion.TextChatService then
                    chat("Welp, this didn't work")
                    return
                end

                blob = "\u{000D}"
                chat("." .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. "🚨 Important Announcement: " .. msg:sub(11) ..  " 🚨" .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. " " .. blob .. ".")
            end
        end

        -- RIZZ:
        if msg:sub(1, 4) == Prefix .. "rizz" then

            local rizzlines = {
                "Can I be your snowflake? I promise to never melt away from your heart.",
                "Are you a Wi-Fi signal? Because I’m feeling a strong connection.",
                "Are you a heart? Because I'd never stop beating for you.",
                "I believe in following my dreams, so you lead the way.",
                "If being beautiful was a crime, you’d be on the most wanted list.",
                "Are you iron? Because I don’t get enough of you.",
                "You should be Jasmine without the 'Jas'.",
                "Are you a Disney ride? Because I'd wait forever for you.",
                "Hey, I’m sorry to bother you, but my phone must be broken because it doesn’t seem to have your number in it.",
                "Are you good at math? Me neither, the only number I care about is yours.",
                "Is your name Elsa? Because I can't let you go.",
                "Do you know the difference between history and you? History is the past and you are my future.",
                "Do you work for NASA? Because your beauty is out of this world.",
                "Math is so confusing. It's always talking about x and y and never you and I.",
                "Are you Christmas morning? Because I’ve been waiting all year for you to arrive.",
                "Are you from Tennessee? Because you're the only ten I see.",
                "Are you Nemo? Because I've been trying to find you.",
                "Are you a bank loan? Because you have my interest.",
                "I hope you know CPR, because you just took my breath away.",
                "Are you the sun? Because I could stare at you all day, and it’d be worth the risk.",
                "Are you a keyboard? Because you're just my type.",
                "My mom said sharing is caring but, no...you're all mine!",
                "It's time to pay up. It's the first of the month, and you've been living in my mind rent-free.",
                "Are you a light? Because you always make me feel bright.",
                "Do you have a bandaid? My knees hurt from falling for you.",
                "We may not be pants, but we'd make a great pair.",
                "You know what's beautiful? Repeat the first word.",
                "Your eyes remind me of Ikea: easy to get lost in.",
                "If you were a Transformer, you'd be Optimus Fine.",
                "I must be a time traveler, because I can't imagine my future without you.",
                "Are you a light switch? Because you turn me on.",
                "Are you a doctor? Because you instantly make me feel better.",
                "You must be a masterpiece, because I can't take my eyes off of you.",
                "Are you my favorite song? Because I can't get you out of my head.",
                "I'm no photographer, but I can picture us together."
            }

            local targetPLR = getFullPlayerName(message:sub(6))
            local randomrizzline = math.random(1, #rizzlines)
            local originalCFrame = LocalPLR.Character.HumanoidRootPart.CFrame

            if not game.Players[targetPLR] then
                return
            end

            wait(5 * (index - 1))

            rizzFollow = RunService.Heartbeat:Connect(function()
                LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
            end)
            chat(rizzlines[randomrizzline])

            wait(5)

            rizzFollow:Disconnect()
            LocalPLR.Character.HumanoidRootPart.CFrame = originalCFrame

        end

        -- HUG:
        if msg:sub(1, 4) == Prefix .. "hug" then
            local args = getArgs(message:sub(6))
            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                if not isR15() then
                    if game.Players[targetPLR] then

                        anim1 = Instance.new("Animation")
                        anim1.AnimationId = "rbxassetid://283545583"

                        anim1p = LocalPLR.Character.Humanoid:LoadAnimation(anim1)
                        anim1p:Play()

                        anim2 = Instance.new("Animation")
                        anim2.AnimationId = "rbxassetid://225975820"

                        anim2p = LocalPLR.Character.Humanoid:LoadAnimation(anim2)
                        anim2p:Play()

                        hugF = RunService.Heartbeat:Connect(function()
                            LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
                        end)

                    end
                else
                    chat("Bot needs to be r6!")
                end
            end

            specifyBots2(args, 2, runCode)
        end

        if msg == Prefix .. "unhug" then

            function runCode()
                if anim1 and anim2 then
                    anim1:Destroy()
                    anim2:Destroy()
                end

                if anim1p and anim2p then
                    anim1p:Stop()
                    anim2p:Stop()
                end

                if hugF then
                    hugF:Disconnect()
                end
            end

            specifyBots(msg:sub(7), runCode)

        end

        -- SETTING COMMANDS --

        if msg:sub(1, 7) == Prefix .. "capfps" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end
            local args = getArgs(msg:sub(9))

            if not tonumber(args[1]) then
                if index == 1 then
                    chat("Please specify number.")
                end

                return
            end

            function runCode()
                setfpscap(tonumber(args[1]))

                chat("Fps cap has been set to " .. args[1] .. " on bot " .. index .. "!")
            end

            specifyBots2(args, 2, runCode)
        end

        -- ANTIAFK:
        if msg:sub(1, 8) == Prefix .. "antiafk" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local args = getArgs(message:sub(10))
            local switch = args[1]

            function runCode()
                if switch == "enable" then
                    antiafkF = LocalPLR.Idled:Connect(function()
                        VU:CaptureController()
                        VU:ClickButton2(Vector2.new())
                    end)
                    chat("Anti-afk has been enabled on bot " .. index .. "!")
                elseif switch == "disable" then
                    if antiafkF then
                        antiafkF:Disconnect()
                        chat("Anti-afk has been disabled on bot " .. index .. "!")
                    end
                end
            end

            specifyBots2(args, 2, runCode)
        end

    for _, player in pairs(game.Players:GetPlayers()) do
        player.Chatted:Connect(function(message)
            if not runScript then
                return
            end

            commands(player, message)

            if logChat then
                sendToWebhook("```" .. message .. "```", player.Name)
            end
        end)
    end

    game.Players.PlayerAdded:Connect(function(player)
        player.Chatted:Connect(function(message)
            if not runScript then
                return
            end

            commands(player, message)

            if logChat then
                sendToWebhook("```" .. message .. "```", player.Name)
            end
        end)
    end)

    game.Players.PlayerRemoving:Connect(function(player)
        if not runScript then
            return
        end

        for i, bot in pairs(bots) do
            if player.Name == bot then
                table.remove(bots, i)
                getIndex()

                if index == 1 then
                    chat("Bot " .. i .. " left the game!")
                end
            end
        end
    end)
end
