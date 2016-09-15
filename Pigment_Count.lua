-- Author: TheGenomeWhisperer

SLASH_MASSMILL1 = '/milling';

-- LEGION HERBS
local Aethril = 0;
local Dreamleaf = 0;
local Fjarnskaggl = 0;
local Foxflower = 0;
local StarlightRose = 0;
local Yseralline = 0;
local allLegionHerbIDs = {"124101","124102","124104","124103","124105"};
local allLegionHerbLinks = {};

-- Milling Byproducts
local allRoseate = 0;
local allSallow = 0;
local allGemChip = 0;
local allNightmarePod = 0;
local allYseed = 0;
local allByproductIDs = {"129032","129034","129100","136926","128304"};
local allByproductLinks = {};

-- 2D table of all the data
local resultsTable = {};

-- Get Item Link by ID to use in a table
function SetLegionHerbLinks(array)
    for x,ID in ipairs(array) do
        local _,link = GetItemInfo(ID);
        allLegionHerbLinks[x] = link;
    end
end

-- Get Item Link by ID to use in a table
function SetLegionMillingProductLinks(array)
    for x,ID in ipairs(array) do
        local _,link = GetItemInfo(ID);
        allByproductLinks[x] = link;
    end
end

-- Localizing the names of the Herbs
SetLegionHerbLinks(allLegionHerbIDs);
SetLegionMillingProductLinks(allByproductIDs);

-- Creates 2D array of all the data to easily be added to.
function setCollectedData()
    local count1 = 1;
    local count2 = 1;
    for row = 1, 6 do
        resultsTable[row] = {};
        for col = 1, 6 do
            if col == 1 and row ~= 1 then
                resultsTable[row][col] = allLegionHerbLinks[count1];
                count1 = count1 + 1;
            elseif row == 1 and col ~= 1 then
                resultsTable[row][col] = allByproductLinks[count2];
                count2 = count2 + 1;
            else
                resultsTable[row][col] = 0;
            end
        end
    end
    resultsTable[1][1] = "_"; -- To keep it clean looking.
end

-- -- Initializing the table
setCollectedData();

-- Byprodcut sub-groups
-- Aethril
local aethrilRoseate = 0;
local aethrilSallow = 0;
local aethrilYSeed = 0;
-- Dreamleaf
local dreamleafRoseate = 0;
local dreamSallow = 0;
local dreamYSeed = 0;
--Fjarnskaggl
local FjarnRoseate = 0;
local FjarnSallow = 0;
local FjarnYSeed = 0;
--Foxflower
local foxRoseate = 0;
local foxSallow = 0;
local foxYSeed = 0;
--Starlight Rose
local starRoseate = 0;
local starSallow = 0;
local starYSeed = 0;

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

-- Frames
local millEvent = CreateFrame("Frame");
local professionTracking = CreateFrame("Frame");
local itemCountTracking = CreateFrame("Frame")

function countPigments()
    if GetTime() < time then
        -- Roseate Loot
        if roseLooted then
            local newCount = GetItemCount(129032, false)
            if aethrilMilled then
                aethrilRoseate = aethrilRoseate + (newCount - roseateLoot);
                aethrilMilled = false; 
            elseif dreamMilled then
                dreamleafRoseate = dreamleafRoseate + (newCount - roseateLoot);
                dreamMilled = false;
            elseif fjarnMilled then
                FjarnRoseate = FjarnRoseate + (newCount - roseateLoot);
                fjarnMilled = false;
            elseif foxMilled then
                foxRoseate = foxRoseate + (newCount - roseateLoot);
                foxMilled = false;
            elseif starlightMilled then
                starRoseate = starRoseate + (newCount - roseateLoot);
                starlightMilled = false;
            end
            roseLooted = false;
            print(dreamleafRoseate); -- To Be Deleted
            -- Sallow pigment Loot tracking
        elseif sallowLooted then
            local newCount2 = GetItemCount(129034, false)
            if aethrilMilled then
                aethrilSallow = aethrilSallow + (newCount2 - sallowLoot);
                aethrilMilled = false; 
            elseif dreamMilled then
                dreamSallow = dreamSallow + (newCount2 - sallowLoot);
                dreamMilled = false;
            elseif fjarnMilled then
                FjarnSallow = FjarnSallow + (newCount2 - sallowLoot);
                fjarnMilled = false;
            elseif foxMilled then
                foxSallow = foxSallow + (newCount2 - sallowLoot);
                foxMilled = false;
            elseif starlightMilled then
                starSallow = starSallow + (newCount2 - sallowLoot);
                starlightMilled = false;
            end
            sallowLooted = false;
        -- Yseralline Seed Loot tracking
        elseif seedLooted then
            local newCount3 = GetItemCount(128304, false)
            if aethrilMilled then
                aethrilYSeed = aethrilYSeed + (newCount3 - YseedLoot);
                aethrilMilled = false; 
            elseif dreamMilled then
                dreamYSeed = dreamYSeed + (newCount3 - YseedLoot);
                dreamMilled = false;
            elseif fjarnMilled then
                FjarnYSeed = FjarnYSeed + (newCount3 - YseedLoot);
                fjarnMilled = false;
            elseif foxMilled then
                foxYSeed = foxYSeed + (newCount3 - YseedLoot);
                foxMilled = false;
            elseif starlightMilled then
                starYSeed = starYSeed + (newCount3 - YseedLoot);
                starlightMilled = false;
            end
            seedLooted = false;
        -- Gem Chip loot tracking
        elseif chipLooted then -- Only Aethril can produce gemChips, so no need to check all.
            allGemChip = allGemChip + (GetItemCount(129100, false) - gemChipLoot);
            chipLooted = false;
            aethrilMilled = false;
            print(allGemChip);
        -- Nightmare pod loot tracking
        elseif podLooted then -- only Dreamleaf can produce pods.
            allNightmarePod = allNightmarePod + (GetItemCount(136926, false) - nightmarePodLoot);
            podLooted = false;
            dreamMilled = false;
            print(allNightmarePod);
        end
    else
        pigmentCountEnabled = false;
        itemCountTracking:UnregisterEvent("BAG_UPDATE");
    end
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
        if spellID == 209658 then
            aethrilMilled = true;
            Aethril = Aethril + 20;
        elseif spellID == 209659 then
            dreamMilled = true;
            Dreamleaf = Dreamleaf + 20;
        elseif spellID == 209660 then
            fjarnMilled = true;
            Fjarnskaggl = Fjarnskaggl + 20;
        elseif spellID == 209661 then
            foxMilled = true;
            Foxflower = Foxflower + 20;
        elseif spellID == 209662 then
            starlightMilled = true;
            StarlightRose = StarlightRose + 20;
        end
        -- Regulation and tracking of loot. No need to do it unnecessarily at other times.
        IsEnabled = true;
        professionTracking:RegisterEvent("CHAT_MSG_LOOT");
        professionTracking:SetScript("OnEvent",detectLooting);
    end
end

-- Tracking Frame for milling
function setTrackingMilling()
    millEvent:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    millEvent:SetScript("OnEvent", millHerb);
end

-- Defualt on when player logs in or user reloads UI
setTrackingMilling();


-- print("TESTING MILLING ADDON");
-- -- Results of all -- Establishing grid.\



SlashCmdList["MASSMILL"] = function(input)
    print("\n------------------------------------------\n---          LEGION MILLING          ---\n----                 TOTALS               ----\n------------------------------------------");
    print("\nAETHRIL: " .. Aethril);
    -- result = result + "\nDREAMLEAF: " .. Dreamleaf .. "";
    -- result = result + "\nFJARNSKAGGL: " .. Fjarnskaggl .. "";
    -- result = result + "\nFOXFLOWER: " .. Foxflower .. "";
    -- result = result + "\nSTARLIGHT ROSE: " .. StarlightRose .. "";
    for i = 1,#resultsTable do
        for j = 1,#resultsTable[1] do
            print(resultsTable[i][j] .. " , ");
        end
    end


end

-- Still need to include Nightmare Pod tracking.