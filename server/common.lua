-- Handle incoming spawn requests
-- RegisterNetEvent("desync-spawnmanager:handleSpawnRequest")
-- AddEventHandler("desync-spawnmanager:handleSpawnRequest", function(characterId, coords)
--     local source = source
    
--     -- Here you can add any additional server-side validation if needed
--     -- For example, verify the character belongs to the player
    
--     -- Pass both characterId and coords to the spawn event
--     TriggerEvent("desync-spawnmanager:SpawnCharacter", source, characterId, coords)
-- end)

-- Existing spawn event remains the same
-- RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
-- AddEventHandler("desync-spawnmanager:SpawnCharacter", function(netId, characterId, coords)
--     SpawnCharacter(netId, characterId, coords)
-- end)

function SpawnCharacter(netId, characterId, coords)   
    -- Pass characterId to client for any post-spawn character setup
    TriggerClientEvent("desync-spawnmanager:SpawnCharacter", netId, coords, characterId)
end

RegisterNetEvent("desync-spawnmanager:RequestSpawn")
AddEventHandler("desync-spawnmanager:RequestSpawn", function(data)
    local netId = source

    if not data.coords then
        print("no coords?")
        return
    end

    -- if not data.characterId then
    --     print("no character id?")
    --     return
    -- end

    -- Handle any additional server-side validation

    SpawnCharacter(netId, data.characterId, data.coords)

end)