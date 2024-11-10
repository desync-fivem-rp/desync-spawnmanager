-- Triggered when a character should spawn
RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
AddEventHandler("desync-spawnmanager:SpawnCharacter", function(netId, coords)
    SpawnCharacter(netId, coords)
    -- TriggerEvent("desync-core-rp:CharacterSelected2", netId, 'char1') -- temporary
end)

function SpawnCharacter(netId, coords)
    print("Spawning character at: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z)
    -- print("Triggering client event SpawnCharacter")

    TriggerClientEvent("desync-spawnmanager:SpawnCharacter", netId, coords)
end