local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local roundEnd = playerGui:WaitForChild("RoundEnd")
local voteRemote = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Voting"):WaitForChild("Vote")

local lastRetryTick = tick()

local function sendRetry()
    local args = {"Retry"}
    voteRemote:FireServer(unpack(args))
    lastRetryTick = tick()
    print("Sent Retry at: " .. os.date("%X"))
end

roundEnd:GetPropertyChangedSignal("Enabled"):Connect(function()
    if roundEnd.Enabled == true then
        task.wait(1) 
        while roundEnd.Enabled == true do
            sendRetry()
            task.wait(1)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1) 
        
        if tick() - lastRetryTick >= 60 then
            warn("Retrying...")
            sendRetry()
        end
    end
end)
