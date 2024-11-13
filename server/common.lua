-- Handle incoming spawn requests
RegisterNetEvent("desync-spawnmanager:handleSpawnRequest")
AddEventHandler("desync-spawnmanager:handleSpawnRequest", function(characterId, coords)
    local source = source
    
    -- Here you can add any additional server-side validation if needed
    -- For example, verify the character belongs to the player
    
    -- Pass both characterId and coords to the spawn event
    TriggerEvent("desync-spawnmanager:SpawnCharacter", source, characterId, coords)
end)

-- Existing spawn event remains the same
RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
AddEventHandler("desync-spawnmanager:SpawnCharacter", function(netId, characterId, coords)
    -- Store the spawn coordinates server-side to prevent overrides
    local spawnCoords = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        heading = coords.heading
    }
    
    -- Pass characterId to client for any post-spawn character setup
    TriggerClientEvent("desync-spawnmanager:SpawnCharacter", netId, spawnCoords, characterId)
end)