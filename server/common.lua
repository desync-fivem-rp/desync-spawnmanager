-- Triggered when a character should spawn
RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
AddEventHandler("desync-spawnmanager:SpawnCharacter", function(netId, coords)
    -- Store the spawn coordinates server-side to prevent overrides
    local spawnCoords = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        heading = coords.heading
    }
    
    TriggerClientEvent("desync-spawnmanager:SpawnCharacter", netId, spawnCoords)
end)