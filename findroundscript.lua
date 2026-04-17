local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local roundEnd = playerGui:WaitForChild("RoundEnd")
local voteRemote = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Voting"):WaitForChild("Vote")

-- ฟังก์ชันสำหรับส่งคำสั่ง Retry
local function sendRetry()
    print("Round Ended! Sending Retry signal...")
    local args = {"Next"}
    voteRemote:FireServer(unpack(args))
end

-- ดักจับการเปลี่ยนแปลงของค่า Enabled ใน RoundEnd UI
roundEnd:GetPropertyChangedSignal("Enabled"):Connect(function()
    if roundEnd.Enabled == true then
        -- แนะนำให้รอสัก 1-2 วินาทีเพื่อให้แน่ใจว่าระบบบันทึก Reward เรียบร้อย
        task.wait(1.5) 
        sendRetry()
    end
end)
