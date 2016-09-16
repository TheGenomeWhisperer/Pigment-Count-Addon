-- Author: TheGenomeWhisperer

SLASH_MASSMILL1 = '/milling';

-- 2D table of all the data
-- This is our saved Variable of all collected data.
resultsTable_Save = {};

-- LEGION HERBS
local Aethril = 0;
local Dreamleaf = 0;
local Fjarnskaggl = 0;
local Foxflower = 0;
local StarlightRose = 0;
local Yseralline = 0;
local allLegionHerbIDs = {"124101","124102","124104","124103","124105","136926"};
local allLegionHerbNames = {};

-- Milling Byproducts
local allRoseate = 0;
local allSallow = 0;
local allGemChip = 0;
local allNightmarePod = 0;
local allYseed = 0;
local allByproductIDs = {"129032","129034","128304","129100","136926"};
local allByproductNames = {};

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
local aethrilMilled = false;
local dreamMilled = false;
local fjarnMilled = false;
local foxMilled = false;
local starlightMilled = false;
local nightmarePodUsed = false;

-- Frames (separated for easy organization since this is a fairly lightweight addon)
local millEvent = CreateFrame("Frame");
local professionTracking = CreateFrame("Frame");
local itemCountTracking = CreateFrame("Frame");
local savedVariablesTracking = CreateFrame("Frame");

-- For when addon restarts
-- savedVariablesTracking:RegisterEvent("ADDON_LOADED");
-- savedVariablesTracking:RegisterEvent("PLAYER_LOGOUT");

-- Resets milling boolean for all herbs.
function milledReset()
    aethrilMilled = false;
    dreamMilled = false;
    fjarnMilled = false;
    foxMilled = false;
    starlightMilled = false;
    nightmarePodUsed = false;
end

-- Get Item name by ID to use in a table
function SetLegionHerbNames(array)
    for x,ID in ipairs(array) do
        local _,name = GetItemInfo(ID);
        allLegionHerbNames[x] = name;
    end
end

-- Get Item name by ID to use in a table
function SetLegionMillingProductNames(array)
    for x,ID in ipairs(array) do
        local _,name = GetItemInfo(ID);
        allByproductNames[x] = name;
    end
end

-- Creates 2D array of all the data to easily be added to.
function setCollectedDataFromMilling()
    -- Localizing the names of the Herbs
    SetLegionHerbNames(allLegionHerbIDs);
    SetLegionMillingProductNames(allByproductIDs);
    local count1 = 1;
    local count2 = 1;
    for row = 1, #allLegionHerbIDs + 1 do
        resultsTable_Save[row] = {};
        for col = 1, #allByproductIDs + 2 do
            if col == 1 and row ~= 1 then
                resultsTable_Save[row][col] = allLegionHerbNames[count1];
                count1 = count1 + 1;
            elseif row == 1 and col ~= 1 and col ~= 2 then
                resultsTable_Save[row][col] = allByproductNames[count2];
                count2 = count2 + 1;
            else
                resultsTable_Save[row][col] = 0;
            end
        end
    end
    resultsTable_Save[1][2] = "Milled/Used";
    resultsTable_Save[1][1] = "_"; -- To keep it clean looking.
end

--  storing saved variables
-- savedVariablesTracking:SetScript("OnEvent", function(self,event)
    
-- end)

-- Adds the loot data to the resultsTable_Save.
function CountMilledPigments()
    if GetTime() < time then
        -- Roseate Loot
        if roseLooted then
            local newCount = GetItemCount(129032, false)
            if aethrilMilled then
                resultsTable_Save[2][3] = resultsTable_Save[2][3] + (newCount - roseateLoot);
            elseif dreamMilled then
                resultsTable_Save[3][3] = resultsTable_Save[3][3] + (newCount - roseateLoot);
            elseif fjarnMilled then
                resultsTable_Save[4][3] = resultsTable_Save[4][3] + (newCount - roseateLoot);
            elseif foxMilled then
                resultsTable_Save[5][3] = resultsTable_Save[5][3] + (newCount - roseateLoot);
            elseif starlightMilled then
                resultsTable_Save[6][3] = resultsTable_Save[6][3] + (newCount - roseateLoot);
            elseif nightmarePodUsed then
                resultsTable_Save[7][3] = resultsTable_Save[7][3] + (newCount - roseateLoot);
            end
            roseLooted = false;
            -- Sallow pigment Loot tracking
        end
        if sallowLooted then
            local newCount2 = GetItemCount(129034, false)
            if aethrilMilled then
                resultsTable_Save[2][4] = resultsTable_Save[2][4] + (newCount2 - sallowLoot);
            elseif dreamMilled then
                resultsTable_Save[3][4] = resultsTable_Save[3][4] + (newCount2 - sallowLoot);
            elseif fjarnMilled then
                resultsTable_Save[4][4] = resultsTable_Save[4][4] + (newCount2 - sallowLoot);
            elseif foxMilled then
                resultsTable_Save[5][4] = resultsTable_Save[5][4] + (newCount2 - sallowLoot);
            elseif starlightMilled then
                resultsTable_Save[6][4] = resultsTable_Save[6][4] + (newCount2 - sallowLoot);
            elseif nightmarePodUsed then
                resultsTable_Save[7][4] = resultsTable_Save[7][4] + (newCount2 - sallowLoot);
            end
            sallowLooted = false;
        end
        -- Yseralline Seed Loot tracking
        if seedLooted then
            local newCount3 = GetItemCount(128304, false)
            if aethrilMilled then
                resultsTable_Save[2][5] = resultsTable_Save[2][5] + (newCount3 - YseedLoot);
            elseif dreamMilled then
                resultsTable_Save[3][5] = resultsTable_Save[3][5] + (newCount3 - YseedLoot);
            elseif fjarnMilled then
                resultsTable_Save[4][5] = resultsTable_Save[4][5] + (newCount3 - YseedLoot);
            elseif foxMilled then
                resultsTable_Save[5][5] = resultsTable_Save[5][5] + (newCount3 - YseedLoot);
            elseif starlightMilled then
                resultsTable_Save[6][5] = resultsTable_Save[6][5] + (newCount3 - YseedLoot);
            elseif nightmarePodUsed then
                resultsTable_Save[7][5] = resultsTable_Save[7][5] + (newCount3 - YseedLoot);
            end
            seedLooted = false;
        end
        -- Gem Chip loot tracking
        if chipLooted then -- Only Aethril can produce gemChips, so no need to check all.
            resultsTable_Save[2][6] = resultsTable_Save[2][6] + (GetItemCount(129100, false) - gemChipLoot);
            chipLooted = false;
        end
        -- Nightmare pod loot tracking
        if podLooted then -- only Dreamleaf can produce pods.
            local newCount4 = GetItemCount(136926, false)
            if dreamMilled then
                resultsTable_Save[3][7] = resultsTable_Save[3][7] + 1;
            elseif nightmarePodUsed then
                resultsTable_Save[7][7] = resultsTable_Save[7][7] + ((newCount4 - nightmarePodLoot) + 1);
            end
            podLooted = false;
        end
    else
        pigmentCountEnabled = false;
        itemCountTracking:UnregisterEvent("BAG_UPDATE_DELAYED");
    end
end

-- function used for loot detection event.
function detectLootingFromMilling(self, event, msg)
    if IsEnabled == true then
        if GetTime() < time then
            for x,loot in ipairs(allByproductIDs) do
                if (string.match(msg,loot)) then
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
                    -- Set Counting
                    if pigmentCountEnabled == false then  
                        pigmentCountEnabled = true;
                        itemCountTracking:RegisterEvent("BAG_UPDATE_DELAYED");
                        itemCountTracking:SetScript("OnEvent",CountMilledPigments);
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
function millHerbToCount(self, event, unitID, spell, rank, lineID, spellID)
    -- legion herb filtering
    if spellID == 209658 or spellID == 209659 or spellID == 209660 or spellID == 209661 or spellID == 209662 or spellID == 210766 then
        -- Build the table if it is not yet stored.
        if resultsTable_Save[1] == nil then
            setCollectedDataFromMilling();
        end
        -- Reset loot Boolean
        milledReset();
        -- Setting time window to track looting to .25 seconds
        time = GetTime() + 0.900;
        -- Sets current loot amount to be substracted from the new loot amount
        roseateLoot = GetItemCount(129032, false);
        sallowLoot = GetItemCount(129034, false);
        YseedLoot = GetItemCount(128304, false);
        gemChipLoot = GetItemCount(129100, false);
        nightmarePodLoot = GetItemCount(136926, false);
        if spellID == 209658 then
            aethrilMilled = true;
            resultsTable_Save[2][2] = resultsTable_Save[2][2] + 20;
        elseif spellID == 209659 then
            dreamMilled = true;
            resultsTable_Save[3][2] = resultsTable_Save[3][2] + 20;
        elseif spellID == 209660 then
            fjarnMilled = true;
            resultsTable_Save[4][2] = resultsTable_Save[4][2] + 20;
        elseif spellID == 209661 then
            foxMilled = true;
            resultsTable_Save[5][2] = resultsTable_Save[5][2] + 20;
        elseif spellID == 209662 then
            starlightMilled = true;
            resultsTable_Save[6][2] = resultsTable_Save[6][2] + 20;
        elseif spellID == 210766 then
            nightmarePodUsed = true;
            resultsTable_Save[7][2] = resultsTable_Save[7][2] + 1;
        end
        -- Regulation and tracking of loot. No need to do it unnecessarily at other times.
        IsEnabled = true;
        professionTracking:RegisterEvent("CHAT_MSG_LOOT");
        professionTracking:SetScript("OnEvent",detectLootingFromMilling);
    end
end

--Resets all saved data
function resetMilledSavedData()
    setCollectedDataFromMilling();
end

-- Tracking Frame for milling
function setTrackingMilling()
    millEvent:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    millEvent:SetScript("OnEvent", millHerbToCount);
end

-- Defualt on when player logs in or user reloads UI
setTrackingMilling();

SlashCmdList["MASSMILL"] = function(input)
    print("\n------------------------------------------\n---          LEGION MILLING          ---\n----                 TOTALS               ----\n------------------------------------------");
    print("\nAETHRIL: " .. Aethril);
    -- result = result + "\nDREAMLEAF: " .. Dreamleaf .. "";
    -- result = result + "\nFJARNSKAGGL: " .. Fjarnskaggl .. "";
    -- result = result + "\nFOXFLOWER: " .. Foxflower .. "";
    -- result = result + "\nSTARLIGHT ROSE: " .. StarlightRose .. "";
    for i = 1,#resultsTable_Save do
        for j = 1,#resultsTable_Save[1] do
            print(resultsTable_Save[i][j]);
        end
    end
    

end

-- Still need to include Nightmare Pod tracking.