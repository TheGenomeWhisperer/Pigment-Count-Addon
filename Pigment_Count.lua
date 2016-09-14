-- Author: TheGenomeWhisperer


SLASH_MASSMILL1 = '/milling';

-- LEGION HERBS
local Aethril = 0;
local Dreamleaf = 0;
local Fjarnskaggl = 0;
local Foxflower = 0;
local StarlightRose = 0;
local Yseralline = 0;
local allLegionHerbs = {"Aethril","Dreamleaf","Fjarnskaggl","Foxflower","Starlight Rose","Yseralline Seed"};

-- Milling Byproducts
local roseate = 0;
local sallow = 0;
local GemChip = 0;
local nightmarePod = 0;
local Yseed = 0;
local allByproducts = {"roseate", "sallow", "Gem Chip", "Nightmare Pod", "Yseralline Seed"};
local allByproductIDs = {"129032","129034","129100","136926","128304"};

-- Tracking enabled.
local IsEnabled = false;
local time = GetTime();

-- Frames
local millEvent = CreateFrame("Frame");
local professionTracking = CreateFrame("Frame");



function countPigments(self, event, msg)
    if IsEnabled and GetTime() < time then
        for x,loot in ipairs(allByproductIDs) do
            if (string.match(msg,loot)) then
                print("Looted");
                print(x);
            end
        end
    end
end

-- Function:        "millHerb(self, event, _, success,_,_,sourceName,_,_,_,_,_,_, spellID)
-- What it does:    Registers a milling event for Legion Herbs and then activates item collection shortly after.
function millHerb(self, event, timestamp, result, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID,...)
    -- legion herb filtering
    if (spellID == 209658 or spellID == 209659 or spellID == 209660 or spellID == 209661 or spellID == 209662) and  result == "SPELL_CAST_SUCCESS" then
        -- Setting time window to track looting to .25 seconds
        time = GetTime() + 0.250;
        IsEnabled = true;
        print("SUCCESS!");
    end
end

-- Tracking Frame for events
function setTrackingMilling()
    millEvent:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    millEvent:SetScript("OnEvent", millHerb);
    professionTracking:RegisterEvent("CHAT_MSG_LOOT");
    professionTracking:SetScript("OnEvent",countPigments);
end

-- Defualt on when player logs in or user reloads UI
setTrackingMilling();


-- , _, _, sourceName ,_,_,_,_,_,_, spellID, ...
-- print("TESTING MILLING ADDON");
-- -- Results of all -- Establishing grid.\
-- -- function setCollectedData()
-- --     local count1 = 1;
-- --     local count2 = 1;
-- --     local totalTally = {};
-- --     for i = 1, 6 do
-- --         totalTally[i] = {};
-- --         for j = 1, 4 do
-- --             if j == 1 and i ~= 1 then
-- --                 totalTally[i][j] = allLegionHerbs[count1];
-- --                 count1 = count1 + 1;
-- --             elseif i == 1 and j ~= 1 then
-- --                 totalTally[i][j] = allByproducts[count2];
-- --                 count2 = count2 + 1;
-- --             else
-- --                 totalTally[i][j] = 0;
-- --             end
-- --         end
-- --     end
-- --     totalTally[0][0] = "_"; -- To keep it clean looking.
-- -- end


SlashCmdList["MASSMILL"] = function(input)
    print("test");



end