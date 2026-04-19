local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local roundEnd = playerGui:WaitForChild("RoundEnd")
local voteRemote = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Voting"):WaitForChild("Vote")
local isAutoRetryEnabled = false 
local lastRetryTick = tick()
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AutoRetryToggle"

local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 150, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
toggleBtn.Text = "Auto Retry: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)


toggleBtn.MouseButton1Click:Connect(function()
    isAutoRetryEnabled = not isAutoRetryEnabled
    
    if isAutoRetryEnabled then
        toggleBtn.Text = "Auto Retry: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50) 
        print("Auto Retry: Activated")
    else
        toggleBtn.Text = "Auto Retry: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("Auto Retry: Deactivated")
    end
end)


local function sendRetry()
    if not isAutoRetryEnabled then return end 
    
    local args = {"Retry"}
    voteRemote:FireServer(unpack(args))
    lastRetryTick = tick()
    print("Sent Retry at: " .. os.date("%X"))
end


roundEnd:GetPropertyChangedSignal("Enabled"):Connect(function()
    if roundEnd.Enabled == true and isAutoRetryEnabled then
        task.wait(1) 
        while roundEnd.Enabled == true and isAutoRetryEnabled do
            sendRetry()
            task.wait(1)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1) 

        if isAutoRetryEnabled and (tick() - lastRetryTick >= 60) then
            warn("Retrying due to timeout...")
            sendRetry()
        end
    end
end)
