-- function as existing in original R* scripts
local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

RegisterNetEvent("desync-spawnmanager:SpawnCharacter")
AddEventHandler("desync-spawnmanager:SpawnCharacter", function(coords)
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    freezePlayer(PlayerId(), true)

    -- preload collisions for the spawnpoint
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    -- spawn the player
    local ped = PlayerPedId()

    -- V requires setting coords as well
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)

    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.w, true, true, false)

    -- gamelogic-style cleanup stuff
    ClearPedTasksImmediately(ped)
    --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
    RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
    ClearPlayerWantedLevel(PlayerId())

    -- why is this even a flag?
    --SetCharWillFlyThroughWindscreen(ped, false)

    -- set primary camera heading
    --SetGameCamHeading(spawn.heading)
    --CamRestoreJumpcut(GetGameCam())

    -- load the scene; streaming expects us to do it
    --ForceLoadingScreen(true)
    --loadScene(spawn.x, spawn.y, spawn.z)
    --ForceLoadingScreen(false)

    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    ShutdownLoadingScreenNui()

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)

        while not IsScreenFadedIn() do
            Citizen.Wait(0)
        end
    end

    -- and unfreeze the player
    freezePlayer(PlayerId(), false)
end)

