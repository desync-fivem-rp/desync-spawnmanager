local isSpawning = false

function Init()
    Citizen.CreateThread(function()
        
    end)
end

-- Handle spawn requests from other resources
-- RegisterNetEvent("desync-spawnmanager:requestSpawn")
-- AddEventHandler("desync-spawnmanager:requestSpawn", function(data)
--     if not data.coords or not data.characterId then return end
    
--     -- Forward to server to handle the spawn request
--     TriggerServerEvent("desync-spawnmanager:handleSpawnRequest", data.characterId, data.coords)
-- end)

function SpawnCharacter(coords)
    -- Prevent multiple spawns
    if isSpawning then return end
    isSpawning = true
    
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end
    
    local ped = PlayerPedId()
    
    -- Freeze player during spawn
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false)
    
    -- Request collision and wait for it to load
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    
    -- Set exact coordinates
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, coords.heading)
    
    -- Network resurrect to ensure proper spawn
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, true)
    
    -- Clear any existing tasks
    ClearPedTasksImmediately(ped)
    RemoveAllPedWeapons(ped)
    ClearPlayerWantedLevel(PlayerId())
    
    -- Wait for collision to load
    while not HasCollisionLoadedAroundEntity(ped) do
        Wait(0)
    end
    
    -- Unfreeze and show player
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true)
    
    -- Fade back in
    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do Wait(0) end
    
    -- Reset spawn lock
    Wait(1000) -- Wait a bit before allowing another spawn
    isSpawning = false
end

-- Actual spawn logic remains the same
RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
AddEventHandler("desync-spawnmanager:SpawnCharacter", function(coords)
    SpawnCharacter(coords)
end)

Init()
