--[[
    Addon Information for Ashita v4.
]]
addon.name      = 'junkTrade'
addon.author    = 'Thunders'
addon.version   = '1.0'
addon.desc      = 'Trades items from a list one by one with a fixed delay.'
addon.link      = ''

--[[
    Dependencies and Configuration
]]
require('common')
local chat = require('chat')

-- Delay in seconds between each trade.
local TRADE_DELAY = 3.0

--[[
    State and Item Loading
]]
local isTrading         = false
local tradeQueue        = {}
local activeDelay       = 0


-- Load and prepare the item list from the external file.
local itemSet = {}
local success, itemList = pcall(require, 'junk_list')
if success and type(itemList) == 'table' then
    for _, itemName in ipairs(itemList) do
        itemSet[string.lower(tostring(itemName))] = true
    end
else
    print(chat.header('junkTrade') .. chat.error('Error: Could not load junk_list.lua or it is empty.'))
end

--[[
    Function to populate the trade queue with individual items
]]
local function populate_trade_queue()
    tradeQueue = {} -- Clear queue before populating
    local inv = AshitaCore:GetMemoryManager():GetInventory()
    if inv == nil then
        print(chat.header('junkTrade') .. chat.error('Error: Could not access inventory.'))
        return
    end

    -- Scan inventory and add each item individually to the queue.
    for i = 0, 79 do
        local item = inv:GetContainerItem(0, i)
        if item ~= nil and item.Id > 0 then
            local res = AshitaCore:GetResourceManager():GetItemById(item.Id)
            if res ~= nil and itemSet[string.lower(res.Name[1])] then
                for _ = 1, item.Count do
                    table.insert(tradeQueue, res.Name[1])
                end
            end
        end
    end
    
    if #tradeQueue > 0 then
        print(chat.header('junkTrade') .. chat.message(string.format('Found %d items to trade one by one.', #tradeQueue)))
    end
end

--[[
    Function to execute the trade command
]]
local function execute_trade_command()
    -- If the queue is empty, finish the process.
    if #tradeQueue == 0 then
        print(chat.header('junkTrade') .. chat.message('All items have been traded. Process finished.'))
        isTrading = false
        return
    end

    -- Get the next item from the queue.
    local itemName = table.remove(tradeQueue, 1)

    -- Build the command to execute.
    local command_string = string.format('/item "%s" <t>', itemName)

    -- Print the command for debugging and notify the user.
    print(chat.header('junkTrade') .. chat.message(string.format('Executing: %s (%d remaining)', command_string, #tradeQueue)))
    
    -- Use QueueCommand for more direct execution.
    AshitaCore:GetChatManager():QueueCommand(-1, command_string)

    -- Set the delay for the next trade.
    activeDelay = os.clock() + TRADE_DELAY
    
end



--[[
    Command Handler
]]
ashita.events.register('command', 'junktrade_command_cb', function(e)
    local args = e.command:split(' ')
    local command = string.lower(args[1])

    if command == '/junktrade' or command == '/jt' then
        e.blocked = true
        print(chat.header('junkTrade') .. chat.message('Command recognized. Processing...'))

        if isTrading then
            isTrading = false
            tradeQueue = {}
            print(chat.header('junkTrade') .. chat.error('Trade process STOPPED by user.'))
        else
            populate_trade_queue()
            if #tradeQueue > 0 then
                isTrading = true
                activeDelay = 0 -- Allows the first trade to happen immediately.
                print(chat.header('junkTrade') .. chat.message('Trade process STARTED. Make sure you have an NPC targeted (<t>).'))
            else
                print(chat.header('junkTrade') .. chat.message('No items from the list were found in your inventory.'))
            end
        end
        return
    end
end)







--[[
    Main Loop (executed via packet_in event)
]]
ashita.events.register('packet_in', 'junktrade_packet_in_cb', function(e)
    if not isTrading then
        return
    end

    -- If the delay has not passed, do nothing.
    if os.clock() < activeDelay then
        return
    end

    execute_trade_command() -- Execute the next trade if conditions are met
end)

print(chat.header('junkTrade') .. chat.message('Addon loaded and events registered.'))