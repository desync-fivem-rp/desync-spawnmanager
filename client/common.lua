local isSpawning = false

RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
AddEventHandler("desync-spawnmanager:SpawnCharacter", function(coords)
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
end)


