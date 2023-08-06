-- Create a list of IPLs (Interior Prop Locations) to be requested.
local requestedIpl = {
    "h4_islandairstrip", "h4_islandairstrip_props", "h4_islandx_mansion", "h4_islandx_mansion_props", "h4_islandx_props", "h4_islandxdock", "h4_islandxdock_props", "h4_islandxdock_props_2", "h4_islandxtower", "h4_islandx_maindock", "h4_islandx_maindock_props", "h4_islandx_maindock_props_2", "h4_IslandX_Mansion_Vault", "h4_islandairstrip_propsb", "h4_beach", "h4_beach_props", "h4_beach_bar_props", "h4_islandx_barrack_props", "h4_islandx_checkpoint", "h4_islandx_checkpoint_props", "h4_islandx_Mansion_Office", "h4_islandx_Mansion_LockUp_01", "h4_islandx_Mansion_LockUp_02", "h4_islandx_Mansion_LockUp_03", "h4_islandairstrip_hangar_props", "h4_IslandX_Mansion_B", "h4_islandairstrip_doorsclosed", "h4_Underwater_Gate_Closed", "h4_mansion_gate_closed", "h4_aa_guns", "h4_IslandX_Mansion_GuardFence", "h4_IslandX_Mansion_Entrance_Fence", "h4_IslandX_Mansion_B_Side_Fence", "h4_IslandX_Mansion_Lights", "h4_islandxcanal_props", "h4_beach_props_party", "h4_islandX_Terrain_props_06_a", "h4_islandX_Terrain_props_06_b", "h4_islandX_Terrain_props_06_c", "h4_islandX_Terrain_props_05_a", "h4_islandX_Terrain_props_05_b", "h4_islandX_Terrain_props_05_c", "h4_islandX_Terrain_props_05_d", "h4_islandX_Terrain_props_05_e", "h4_islandX_Terrain_props_05_f", "H4_islandx_terrain_01", "H4_islandx_terrain_02", "H4_islandx_terrain_03", "H4_islandx_terrain_04", "H4_islandx_terrain_05", "H4_islandx_terrain_06", "h4_ne_ipl_00", "h4_ne_ipl_01", "h4_ne_ipl_02", "h4_ne_ipl_03", "h4_ne_ipl_04", "h4_ne_ipl_05", "h4_ne_ipl_06", "h4_ne_ipl_07", "h4_ne_ipl_08", "h4_ne_ipl_09", "h4_nw_ipl_00", "h4_nw_ipl_01", "h4_nw_ipl_02", "h4_nw_ipl_03", "h4_nw_ipl_04", "h4_nw_ipl_05", "h4_nw_ipl_06", "h4_nw_ipl_07", "h4_nw_ipl_08", "h4_nw_ipl_09", "h4_se_ipl_00", "h4_se_ipl_01", "h4_se_ipl_02", "h4_se_ipl_03", "h4_se_ipl_04", "h4_se_ipl_05", "h4_se_ipl_06", "h4_se_ipl_07", "h4_se_ipl_08", "h4_se_ipl_09", "h4_sw_ipl_00", "h4_sw_ipl_01", "h4_sw_ipl_02", "h4_sw_ipl_03", "h4_sw_ipl_04", "h4_sw_ipl_05", "h4_sw_ipl_06", "h4_sw_ipl_07", "h4_sw_ipl_08", "h4_sw_ipl_09", "h4_islandx_mansion", "h4_islandxtower_veg", "h4_islandx_sea_mines", "h4_islandx", "h4_islandx_barrack_hatch", "h4_islandxdock_water_hatch", "h4_beach_party"
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