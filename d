-- Services
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- Discord Webhook URL
local webhookURL = "https://discord.com/api/webhooks/1292689794593198090/f4fLybNE0Gwy4mrIoI-PvJYqnfQp-rnU_1OPyf-YowwGE4bgPcejGnyIQTbkNiXvoVl1"

-- Function to send a message to the webhook
local function sendWebhookMessage(message)
    local data = {
        ["content"] = message,  -- Message content
        ["username"] = "Kraken Monitor",  -- Webhook display name
    }
    
    local jsonData = HttpService:JSONEncode(data)
    
    -- Prepare the request body for the webhook
    local requestBody = {
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    }
    
    -- Detect the executor and use the correct HTTP request method
    if syn and syn.request then
        syn.request(requestBody)  -- Synapse X
    elseif http_request then
        http_request(requestBody)  -- Krnl or similar
    elseif request then
        request(requestBody)  -- Script-Ware or other
    else
        warn("No HTTP request function found for sending webhook.")
    end
end

-- Function to monitor the Kraken's spawn and removal
local function monitorKraken()
    local enemiesFolder = Workspace:WaitForChild("Enemies")
    
    -- Check if the Kraken exists when the script starts
    local kraken = enemiesFolder:FindFirstChild("Kraken")
    if kraken then
        sendWebhookMessage("Kraken has spawned")
    end
    
    -- Listen for changes in the Enemies folder
    enemiesFolder.ChildAdded:Connect(function(child)
        if child.Name == "Kraken" then
            sendWebhookMessage("Kraken has spawned")
        end
    end)
    
    enemiesFolder.ChildRemoved:Connect(function(child)
        if child.Name == "Kraken" then
            sendWebhookMessage("Kraken has been killed")
        end
    end)
end

-- Start monitoring the Kraken
monitorKraken()

print("Kraken monitor script loaded.")
