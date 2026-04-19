local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local roundEnd = playerGui:WaitForChild("RoundEnd")
local voteRemote = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Voting"):WaitForChild("Vote")
local function sendRetry()
    local args = {"Retry"}

    voteRemote:FireServer(unpack(args))
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
---ไม่มีเปิดปิด
