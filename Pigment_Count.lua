-- Author: TheGenomeWhisperer

SLASH_MASSMILL1 = '/milling';

-- 2D table of all the data
-- This is our saved Variable of all collected data.
resultsTable_Save = {};

-- LEGION HERBS
local allLegionHerbIDs = {"124101","124102","124104","124103","124105","124106","136926"};
local allLegionHerbNames = {"|cffffffff|Hitem:124101::::::::110:253::::::|h[Aethril]|h|r","|cffffffff|Hitem:124102::::::::110:253::::::|h[Dreamleaf]|h|r","|cffffffff|Hitem:124104::::::::110:253::::::|h[Fjarnskaggl]|h|r",
                            "|cffffffff|Hitem:124103::::::::110:253::::::|h[Foxflower]|h|r","|cffffffff|Hitem:124105::::::::110:253::::::|h[Starlight Rose]|h|r","|cff1eff00|Hitem:124106::::::::110:253::::::|h[Felwort]|h|r",
                            "|cffffffff|Hitem:136926::::::::110:253::::::|h[Nightmare Pod]|h|r"};

-- Milling Byproducts
local allByproductIDs = {"129032","129034","128304","129100","136926"};
local allByproductNames = {"|cffffffff|Hitem:129032::::::::110:253::::::|h[Roseate Pigment]|h|r","|cffffffff|Hitem:129034::::::::110:253::::::|h[Sallow Pigment]|h|r",
                           "|cffffffff|Hitem:128304::::::::110:253::::::|h[Yseralline Seed]|h|r","|cffffffff|Hitem:129100::::::::110:253::::::|h[Gem Chip]|h|r","|cffffffff|Hitem:136926::::::::110:253::::::|h[Nightmare Pod]|h|r"};

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
local felwortMilled = false;
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
    felwortMilled = false;
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
    -- SetLegionHerbNames(allLegionHerbIDs);
    -- SetLegionMillingProductNames(allByproductIDs);
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

-- Adds the loot data to the resultsTable_Save.
function CountMilledPigments()
    if pigmentCountEnabled == true then
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
                elseif felwortMilled then
                    resultsTable_Save[7][3] = resultsTable_Save[7][3] + (newCount - roseateLoot);
                elseif nightmarePodUsed then
                    resultsTable_Save[8][3] = resultsTable_Save[8][3] + (newCount - roseateLoot);
                end
                roseLooted = false;
                roseateLoot = GetItemCount(129032, false);
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
                elseif felwortMilled then
                    resultsTable_Save[7][4] = resultsTable_Save[7][4] + (newCount2 - sallowLoot);
                elseif nightmarePodUsed then
                    resultsTable_Save[8][4] = resultsTable_Save[8][4] + (newCount2 - sallowLoot);
                end
                sallowLooted = false;
                sallowLoot = GetItemCount(129034, false);
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
                elseif felwortMilled then
                    resultsTable_Save[7][5] = resultsTable_Save[7][5] + (newCount3 - YseedLoot);
                elseif nightmarePodUsed then
                    resultsTable_Save[8][5] = resultsTable_Save[8][5] + (newCount3 - YseedLoot);
                end
                seedLooted = false;
                YseedLoot = GetItemCount(128304, false);
            end
            -- Gem Chip loot tracking
            if chipLooted then -- Only Aethril can produce gemChips, so no need to check all.
                resultsTable_Save[2][6] = resultsTable_Save[2][6] + (GetItemCount(129100, false) - gemChipLoot);
                chipLooted = false;
                gemChipLoot = GetItemCount(129100, false);
            end
            -- Nightmare pod loot tracking
            if podLooted then -- only Dreamleaf and other Nightmare pods can produce pods.
                local newCount4 = GetItemCount(136926, false)
                if dreamMilled then
                    resultsTable_Save[3][7] = resultsTable_Save[3][7] + (newCount4 - nightmarePodLoot);
                elseif nightmarePodUsed then
                    resultsTable_Save[8][7] = resultsTable_Save[8][7] + ((newCount4 - nightmarePodLoot) + 1);
                end
                podLooted = false;
                nightmarePodLoot = GetItemCount(136926, false);
            end
        else
            pigmentCountEnabled = false; -- Keeps checks minimalist
        end
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
                    pigmentCountEnabled = true;
                end
            end
        else
            IsEnabled = false; -- Keeps checks minimalist
        end
    end
end

-- Function:        "millHerb(self, event, _, success,_,_,sourceName,_,_,_,_,_,_, spellID)
-- What it does:    Registers a milling event for Legion Herbs and then activates item collection shortly after.
function millHerbToCount(self, event, unitID, spell, rank, lineID, spellID)
    -- legion herb filtering
    if spellID == 209658 or spellID == 209659 or spellID == 209660 or spellID == 209661 or spellID == 209662 or spellID == 210766 or spellID == 209664 then
        -- Build the table if it is not yet stored.
        if resultsTable_Save[1] == nil then
            setCollectedDataFromMilling();
        end
        -- Reset loot Boolean
        milledReset();
        -- Setting time window to track looting to .25 seconds
        time = GetTime() + 10.00;
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
        elseif spellID == 209661 then
            fjarnMilled = true;
            resultsTable_Save[4][2] = resultsTable_Save[4][2] + 20;
        elseif spellID == 209660 then
            foxMilled = true;
            resultsTable_Save[5][2] = resultsTable_Save[5][2] + 20;
        elseif spellID == 209662 then
            starlightMilled = true;
            resultsTable_Save[6][2] = resultsTable_Save[6][2] + 20;
        elseif spellID == 209664 then
            felwortMilled = true;
            resultsTable_Save[7][2] = resultsTable_Save[7][2] + 20;
        elseif spellID == 210766 then
            nightmarePodUsed = true;
            resultsTable_Save[8][2] = resultsTable_Save[8][2] + 1;
        end
        -- Regulation and tracking of loot. No need to do it unnecessarily at other times.
        IsEnabled = true;
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
    professionTracking:RegisterEvent("CHAT_MSG_LOOT");
    professionTracking:SetScript("OnEvent",detectLootingFromMilling);
    itemCountTracking:RegisterEvent("BAG_UPDATE_DELAYED");
    itemCountTracking:SetScript("OnEvent",CountMilledPigments);
end

-- Defualt on when player logs in or user reloads UI
setTrackingMilling();

SlashCmdList["MASSMILL"] = function(input)
    local herbsMilled = false; -- To Track report if no data has been collected yet.
    if input == nil or input:trim() == "" then
        print("\n------------------------------------------\n---          LEGION MILLING          ---\n----                 TOTALS               ----\n------------------------------------------");
        if resultsTable_Save[1] ~= nil and resultsTable_Save[2][2] > 0 then -- Aethril
            herbsMilled = true;
            print("-------  " .. resultsTable_Save[2][1] .. "  -------");
            print("Milled:  " .. resultsTable_Save[2][2]);
            for i = 3,6 do
                print(resultsTable_Save[1][i] .. ":  " .. resultsTable_Save[2][i]);
            end
            print("---------------------------");
        end
        if resultsTable_Save[1] ~= nil and resultsTable_Save[3][2] > 0 then -- Dreamleaf
            herbsMilled = true;
            print("-----  " .. resultsTable_Save[3][1] .. "  -----");
            print("Milled:  " .. resultsTable_Save[3][2]);
            for i = 3,7 do
                if i ~= 6 then
                    print(resultsTable_Save[1][i] .. ":  " .. resultsTable_Save[3][i]);
                end
            end
            print("---------------------------");
        end
        if resultsTable_Save[1] ~= nil and resultsTable_Save[4][2] > 0 then -- Fjarnskaggl
            herbsMilled = true;
            print("----  " .. resultsTable_Save[4][1] .. "  ----");
            print("Milled:  " .. resultsTable_Save[4][2]);
            for i = 3,5 do
                print(resultsTable_Save[1][i] .. ":  " .. resultsTable_Save[4][i]);
            end
            print("---------------------------");
        end
        if resultsTable_Save[1] ~= nil and resultsTable_Save[5][2] > 0 then -- Foxflower
            herbsMilled = true;
            print("-----  " .. resultsTable_Save[5][1] .. "  ------");
            print("Milled:  " .. resultsTable_Save[5][2]);
            for i = 3,5 do
                print(resultsTable_Save[1][i] .. ":  " .. resultsTable_Save[5][i]);
            end
            print("---------------------------");
        end
        if resultsTable_Save[1] ~= nil and resultsTable_Save[6][2] > 0 then -- Starlight Rose
            herbsMilled = true;
            print("--  " .. resultsTable_Save[6][1] .. "  ---");
            print("Milled:  " .. resultsTable_Save[6][2]);
            for i = 3,5 do
                print(resultsTable_Save[1][i] .. ":  " .. resultsTable_Save[6][i]);
            end
            print("---------------------------");
        end
        if resultsTable_Save[1] ~= nil and resultsTable_Save[7][2] > 0 then -- Felwort
            herbsMilled = true;
            print("-------  " .. resultsTable_Save[7][1] .. "  ------");
            print("Milled:  " .. resultsTable_Save[7][2]);
            for i = 3,5 do
                print(resultsTable_Save[1][i] .. ":  " .. resultsTable_Save[7][i]);
            end
            print("---------------------------");
        end
        if resultsTable_Save[1] ~= nil and resultsTable_Save[8][2] > 0 then -- Nightmare Pod
            herbsMilled = true;
            print("--  " .. resultsTable_Save[8][1] .. "  --");
            print("Used:  " .. resultsTable_Save[8][2]);
            for i = 3,7 do
                if i ~= 6 then
                    print(resultsTable_Save[1][i] .. ":  " .. resultsTable_Save[8][i]);
                end
            end
            print("---------------------------");
        end
        if herbsMilled == false then
            print("No Milling Data Collected Yet!");
        end
    elseif input == "reset" then
        print("Saved data has been reset to zero.");
        resetMilledSavedData();
    else
        print("ERROR! Input not recognized.");
        print("Please type /milling help for info.");
    end
end


-- /script for i=1,#resultsTable_Save do for j=1,#resultsTable_Save[1] do print(resultsTable_Save[i][j]) end end 