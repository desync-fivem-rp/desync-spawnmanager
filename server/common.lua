-- Triggered when a character should spawn
RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
AddEventHandler("desync-spawnmanager:SpawnCharacter", function(netId, coords, character)
    SpawnCharacter(netId, coords, character)
    TriggerEvent("desync-core-rp:CharacterSelected2", netId, 'char1') -- temporary
end)

function SpawnCharacter(netId, coords, character)
    local finalCoords = nil

    -- If coords are not provided, then spawn the player at the last position they were at from the database
    if coords == nil then
        local identifier = string.match(GetPlayerIdentifier(netId), ":(.*)")

        -- If providing a character slot (used in multi-char select)
        if character ~= nil then
            local characterIdentifier = character.slot .. ":" .. identifier
            identifier = characterIdentifier
        end

        local response = MySQL.query.await("SELECT LastPosition FROM Users WHERE Identifier = ?", { identifier })

        if response then
            if #response == 0 then
                print("ERROR: Player with identifier: " .. identifier .. " not found in Users table")

                -- If we failed to get the player's last position, spawn them at the safe spawn location set in the config
                local safeSpawnCoords = vector3(Config.SafeSpawnCoords.x, Config.SafeSpawnCoords.y, Config.SafeSpawnCoords.z)
                local safeSpawnHeading = Config.SafeSpawnCoords.w

                finalCoords = vector4(safeSpawnCoords.x, safeSpawnCoords.y, safeSpawnCoords.z, safeSpawnHeading)
                return
            end

            for i = 1, #response, 1 do
                local row = response[i]

                lastPosition = row.LastPosition
            end

            local lastPosition = json.decode(lastPosition)
            finalCoords = lastPosition
        else
            print("ERROR: Failed to get a response from MySQL database")
            
            -- If we failed to get the player's last position, spawn them at the safe spawn location set in the config
            local safeSpawnCoords = vector3(Config.SafeSpawnCoords.x, Config.SafeSpawnCoords.y, Config.SafeSpawnCoords.z)
            local safeSpawnHeading = Config.SafeSpawnCoords.w

            finalCoords = vector4(safeSpawnCoords.x, safeSpawnCoords.y, safeSpawnCoords.z, safeSpawnHeading)
        end
    else
        -- If coords are provided, then spawn the player at the coords provided
        finalCoords = coords
    end

    TriggerClientEvent("desync-spawnmanager:SpawnCharacter", netId, finalCoords)
end