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
local gemChip = 0;
local nightmarePod = 0;
local Yseed = 0;
local allByproducts = {"roseate", "sallow", "Gem Chip", "Nightmare Pod", "Yseralline Seed"};
local allByproductIDs = {"129032","129034","129100","136926","128304"};

-- itemLoot Tracking
local roseateLoot = 0;
local sallowLoot = 0;
local gemChipLoot = 0;
local nightmarePodLoot = 0;
local YseedLoot = 0;

-- Tracking enabled.
local IsEnabled = false;
local pigmentCountEnabled = false;
local time = GetTime();

-- Boolean check on looted or not
local roseLooted = false;
local sallowLooted = false;
local chipLooted = false;
local podLooted = false;
local seedLooted = false;

-- Frames
local millEvent = CreateFrame("Frame");
local professionTracking = CreateFrame("Frame");
local itemCountTracking = CreateFrame("Frame")

function countPigments()
        if roseLooted then
            roseate = roseate + (GetItemCount(129032, false) - roseateLoot);
            roseLooted = false;
            print(roseate);
        elseif sallowLooted then
            sallow = sallow + (GetItemCount(129034, false) - sallowLoot);
            sallowLooted = false;
            print(sallow);
        elseif chipLooted then
            gemChip = gemChip + (GetItemCount(129100, false) - gemChipLoot);
            chipLooted = false;
            print(gemChip);
        elseif podLooted then
            nightmarePod = nightmarePod + (GetItemCount(136926, false) - nightmarePodLoot);
            podLooted = false;
            print(nightmarePod);
        elseif seedLooted then
            Yseed = Yseed + (GetItemCount(128304, false) - YseedLoot);
            seedLooted = false;
            print(Yseed);
        end
        print("test");
end

function detectLooting(self, event, msg)
    if IsEnabled == true then
        if GetTime() < time then
            for x,loot in ipairs(allByproductIDs) do
                if (string.match(msg,loot)) then
                    -- Set Counting
                    if pigmentCountEnabled == false then
                        pigmentCountEnabled = true;
                        itemCountTracking:RegisterEvent("BAG_UPDATE");
                        itemCountTracking:SetScript("OnEvent",countPigments);
                    end
                    if loot == "129032" then 
                        roseLooted = true;
                    elseif loot == "129034" then
                        sallowLooted = true;
                    elseif loot == "129100" then
                        chipLooted = true;
                    elseif loot == "136926" then
                        podLooted = true;
                    elseif loot == "128304" then
                        seedLooted = true;
                    end
                end
            end
        else
            -- No need to keep enabling tracking when timer is up.
            IsEnabled = false;
            professionTracking:UnregisterEvent("CHAT_MSG_LOOT");
        end
    end
end

-- Function:        "millHerb(self, event, _, success,_,_,sourceName,_,_,_,_,_,_, spellID)
-- What it does:    Registers a milling event for Legion Herbs and then activates item collection shortly after.
function millHerb(self, event, unitID, spell, rank, lineID, spellID)
    -- legion herb filtering
    if spellID == 209658 or spellID == 209659 or spellID == 209660 or spellID == 209661 or spellID == 209662 then
        -- Setting time window to track looting to .25 seconds
        time = GetTime() + 0.250;
        -- Sets current loot amount to be substracted from the new loot amount
        roseateLoot = GetItemCount(129032, false);
        sallowLoot = GetItemCount(129034, false);
        gemChipLoot = GetItemCount(129100, false);
        nightmarePodLoot = GetItemCount(136926, false);
        YseedLoot = GetItemCount(128304, false);
        -- Regulation
        IsEnabled = true;
        professionTracking:RegisterEvent("CHAT_MSG_LOOT");
        professionTracking:SetScript("OnEvent",detectLooting);
    end
end

-- Tracking Frame for events
function setTrackingMilling()
    millEvent:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    millEvent:SetScript("OnEvent", millHerb);
    professionTracking:RegisterEvent("CHAT_MSG_LOOT");
    professionTracking:SetScript("OnEvent",detectLooting);
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