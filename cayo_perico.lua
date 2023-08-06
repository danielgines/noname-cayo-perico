-- Create a list of IPLs (Interior Prop Locations) to be requested.
local requestedIpl = {
    "h4_islandairstrip", "h4_islandairstrip_props", ... -- [and so on for all the IPLs]
}

-- Create a new thread to load all the requested IPLs.
CreateThread(function()
    for i = #requestedIpl, 1, -1 do
        RequestIpl(requestedIpl[i])
        requestedIpl[i] = nil
    end
    requestedIpl = nil
end)

-- Create a new thread to set radar details.
CreateThread(function()
    while true do
        -- Set the radar as exterior for the current frame.
        SetRadarAsExteriorThisFrame()
        -- Set the radar as interior for a fake island location for the current frame.
        SetRadarAsInteriorThisFrame(`h4_fake_islandx`, vec(4700.0, -5145.0), 0, 0)
        -- Wait for 0 milliseconds before continuing the loop, effectively making this run every frame.
        Wait(0)
    end
end)

-- Create a new thread to handle island related logic based on player's proximity.
CreateThread(function()
    -- Wait for 2.5 seconds before executing the rest of the thread.
    Wait(2500)
    -- Define a flag to check if the island is loaded.
    local islandLoaded = false
    -- Define the coordinates for the island.
    local islandCoords = vector3(4840.571, -5174.425, 2.0)
    -- Set the deep ocean scaler to 0, probably to adjust the water visuals.
    SetDeepOceanScaler(0.0)
    -- Start an infinite loop to constantly check player's proximity to the island.
    while true do
        -- Get the player's current coordinates.
        local pCoords = GetEntityCoords(PlayerPedId())
        local shouldLoadIsland = #(pCoords - islandCoords) < 2000.0

        if shouldLoadIsland ~= islandLoaded then
            islandLoaded = shouldLoadIsland
            local state = islandLoaded and 1 or 0
            Citizen.InvokeNative(0xF74B1FFA4A15FBEA, state)
        end
        -- Wait for 5 seconds before checking again.
        Wait(5000)
    end
end)