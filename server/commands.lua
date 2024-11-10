RegisterCommand("respawn", function(source, args, rawCommand)
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local coords = vector4(coords.x, coords.y, coords.z, heading)

    TriggerClientEvent("desync-spawnmanager:SpawnCharacter", source, coords)
end, true)