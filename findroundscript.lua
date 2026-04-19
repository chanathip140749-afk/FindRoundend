local UserInputService = game:GetService("UserInputService") 
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local roundEnd = playerGui:WaitForChild("RoundEnd")
local voteRemote = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Voting"):WaitForChild("Vote")

local isAutoRetryEnabled = true
local lastRetryTick = tick()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end  
    if input.KeyCode == Enum.KeyCode.Z then
        isAutoRetryEnabled = not isAutoRetryEnabled
        if isAutoRetryEnabled then
            print("ENABLED")
        else
            warn("DISABLED")
        end
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
