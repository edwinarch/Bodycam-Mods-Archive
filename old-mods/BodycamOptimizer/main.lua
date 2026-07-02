----------------------------------------------------------
-- Configuration
----------------------------------------------------------
-- Default graphics preset
-- Available:
-- "Vanilla Graphics"
-- "Balanced"
-- "Performance"
-- "Ultra Performance"
local Mode = "Balanced"

-- Automatically apply the preset after entering the game
local AutoApply = true

-- Delay (seconds) before applying graphics settings
local AutoApplyDelay = 6


----------------------------------------------------------
-- Unreal Engine Helpers
----------------------------------------------------------
local UEHelpers = require("UEHelpers")

local GetWorld = UEHelpers.GetWorld  --GetKismetSystemLibrary()
local GetKismetSystemLibrary = UEHelpers.GetKismetSystemLibrary


----------------------------------------------------------
-- Console Command Wrapper
----------------------------------------------------------
local function ExecCmd(Command, Value)

    local FullCommand = Command .. " " .. tostring(Value)

    ExecuteInGameThread(function()

        local KismetSystemLibrary = GetKismetSystemLibrary()
        local Engine = FindFirstOf("Engine")

        if KismetSystemLibrary
        and KismetSystemLibrary:IsValid()
        and Engine
        and Engine:IsValid() then

            KismetSystemLibrary:ExecuteConsoleCommand(
                Engine,
                FullCommand,
                nil
            )

        end

    end)

end


----------------------------------------------------------
-- Runtime State
----------------------------------------------------------
-- Current loaded map
local CurrentMap = nil

-- Current map override
local CurrentMapOverride = nil

-- Current graphics preset
local CurrentPreset = nil

-- Initialization state
local IsInitialized = false

-- Delayed task queue
local TaskQueue = {}

-- Last level load timestamp
local LastLevelLoad = 0

-- Pending map reload
local PendingMapReload = false


----------------------------------------------------------
-- Graphics Presets
----------------------------------------------------------
------------- # PRESET 1 / 4 # -------------
--
-- Vainilla Graphics  (Original)
local function ApplyVanilla() -- point-1

    ----------------------------------------------------------
    -- Shadows
    ----------------------------------------------------------    
    ExecCmd("r.ShadowQuality", 3)                          -- Overall shadow quality
    ExecCmd("r.Shadow.DistanceScale", 0.16)               -- Shadow render distance
    ExecCmd("r.Shadow.CSM.MaxCascades", 3)                -- Cascaded shadow levels
    ExecCmd("r.Shadow.MaxCSMResolution", 1024)            -- Shadow map resolution
    ExecCmd("r.Shadow.RadiusThreshold", 0.05)             -- Shadow visibility threshold
    ExecCmd("r.Shadow.Denoiser", 2)                       -- Shadow denoiser
    ExecCmd("r.Shadow.Virtual.Enable", 1)                 -- Virtual Shadow Maps
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountLocal", 8)     -- Local shadow ray count
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountDirectional", 4) -- Directional shadow ray count
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstLevel", 6)     -- First virtual shadow clipmap level
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstCoarseLevel", 15) -- First coarse clipmap level
    ExecCmd("r.Shadow.NaniteLODBias", 1)                  -- Nanite shadow LOD bias    

    ----------------------------------------------------------
    -- Nanite
    ----------------------------------------------------------
    ExecCmd("r.Nanite", 1)                               -- Enable Nanite rendering
    ExecCmd("r.Nanite.ViewMeshLODBias.Offset", 0)        -- Nanite mesh LOD bias
    ExecCmd("r.Nanite.MinPixelsPerEdgeHW", 32)           -- Minimum pixels per edge
    ExecCmd("r.Nanite.ShadeBinningMode", 0)              -- Nanite shading mode

    ----------------------------------------------------------
    -- Foliage （植被）
    ----------------------------------------------------------
    ExecCmd("foliage.OnlyLOD", -1)                      -- Force a specific foliage LOD
    ExecCmd("foliage.DitheredLOD", 1)                   -- Enable smooth LOD transitions
    ExecCmd("foliage.LODDistanceScale", 1)              -- Foliage LOD distance scale
    ExecCmd("foliage.MinimumScreenSize", 0.000005)      -- Minimum foliage screen size

    ----------------------------------------------------------
    -- Lumen
    ----------------------------------------------------------
    ExecCmd("r.Lumen.Reflections.Allow", 1)                           -- Enable Lumen reflections
    ExecCmd("r.Lumen.ScreenProbeGather.DownsampleFactor", 32)         -- Screen probe downsample factor
    ExecCmd("r.Lumen.ScreenProbeGather.ShortRangeAO", 1)              -- Short-range ambient occlusion
    ExecCmd("r.Lumen.ScreenProbeGather.Temporal.MaxFramesAccumulated", 10) -- Temporal accumulation frames
    ExecCmd("r.Lumen.HardwareRayTracing", 1)                          -- Hardware ray tracing

    ----------------------------------------------------------
    -- Reflections
    ----------------------------------------------------------
    ExecCmd("r.SSR.Quality", 3)                     -- Screen Space Reflection quality

    ----------------------------------------------------------
    -- View Distance
    ----------------------------------------------------------
    ExecCmd("r.StaticMeshLODDistanceScale", 1)           -- Static mesh LOD distance scale

    ----------------------------------------------------------
    -- Post Processing
    ----------------------------------------------------------
    ExecCmd("r.DepthOfFieldQuality", 2)                 -- Depth of field quality
    ExecCmd("r.Tonemapper.Sharpen", 4)                  -- Image sharpening
    ExecCmd("r.PostProcessing.DisableMaterials", 0)     -- Disable post-process materials
    ExecCmd("r.EyeAdaptationQuality", 1)                -- Eye adaptation quality

    ----------------------------------------------------------
    -- Effects
    ----------------------------------------------------------
    ExecCmd("r.VolumetricCloud", 1)              -- Volumetric cloud rendering
    ExecCmd("r.LightShaftQuality", 1)            -- Light shaft quality
    ExecCmd("r.LightFunctionQuality", 2)         -- Light function quality

    ----------------------------------------------------------
    -- Anti-Aliasing
    ----------------------------------------------------------
    
    -- No anti-aliasing settings. 

    ----------------------------------------------------------
    -- Textures
    ----------------------------------------------------------
    
    -- No texture settings.

    ----------------------------------------------------------
    -- Misc
    ----------------------------------------------------------

    -- No miscellaneous settings.

end

------------- # PRESET 2 / 4 # -------------

-- Balanced

-- Best balance between image quality and performance.

-- Recommended:
-- RTX 2060+
-- GTX 1660
-- RTX 3050

-- Average FPS Gain:
-- +20~35%
local function ApplyBalanced() --2

    ----------------------------------------------------------
    -- Shadows
    ----------------------------------------------------------    
    ExecCmd("r.ShadowQuality",4)    -- Overall shadow quality
    ExecCmd("r.Shadow.DistanceScale",0.64)  -- Shadow render distance
    ExecCmd("r.Shadow.CSM.MaxCascades", 1)  -- Cascaded shadow levels
    ExecCmd("r.Shadow.MaxCSMResolution", 8192)             -- Shadow map resolution
    ExecCmd("r.Shadow.RadiusThreshold", 0.03)              -- Shadow visibility threshold
    ExecCmd("r.Shadow.Denoiser", 0)                        -- Shadow denoiser
    ExecCmd("r.Shadow.Virtual.Enable", 0)                  -- Virtual Shadow Maps
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountLocal", 0)      -- Local shadow ray count
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountDirectional", 0)-- Directional shadow ray count
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstLevel", 6)      -- First virtual shadow clipmap level
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstCoarseLevel", 32) -- First coarse clipmap level
    ExecCmd("r.Shadow.NaniteLODBias", 3)                   -- Nanite shadow LOD bias

    ----------------------------------------------------------
    -- Nanite
    ----------------------------------------------------------
    ExecCmd("r.Nanite", 0)                               -- Enable Nanite rendering
    ExecCmd("r.Nanite.ViewMeshLODBias.Offset", 2)        -- Nanite mesh LOD bias
    ExecCmd("r.Nanite.MinPixelsPerEdgeHW", 0)            -- Minimum pixels per edge
    ExecCmd("r.Nanite.ShadeBinningMode", 1)              -- Nanite shading mode

    ----------------------------------------------------------
    -- Foliage（植被）
    ----------------------------------------------------------
    ExecCmd("foliage.OnlyLOD", 0)                       -- Force a specific foliage LOD
    ExecCmd("foliage.DitheredLOD", 1)                   -- Enable smooth LOD transitions
    ExecCmd("foliage.LODDistanceScale", 2)              -- Foliage LOD distance scale
    ExecCmd("foliage.MinimumScreenSize", 0.000005)      -- Minimum foliage screen size

    ----------------------------------------------------------
    -- Lumen
    ----------------------------------------------------------
    ExecCmd("r.Lumen.Reflections.Allow", 0)                           -- Enable Lumen reflections
    ExecCmd("r.Lumen.ScreenProbeGather.DownsampleFactor", 32)         -- Screen probe downsample factor
    ExecCmd("r.Lumen.ScreenProbeGather.ShortRangeAO", 0)              -- Short-range ambient occlusion
    ExecCmd("r.Lumen.ScreenProbeGather.Temporal.MaxFramesAccumulated", 32) -- Temporal accumulation frames
    ExecCmd("r.Lumen.HardwareRayTracing", 0)                          -- Hardware ray tracing

    ----------------------------------------------------------
    -- Reflections
    ----------------------------------------------------------
    ExecCmd("r.SSR.Quality", 1)                     -- Screen Space Reflection quality

    ----------------------------------------------------------
    -- View Distance
    ----------------------------------------------------------
    ExecCmd("r.StaticMeshLODDistanceScale", 0.25)        -- Static mesh LOD distance scale

    ----------------------------------------------------------
    -- Post Processing
    ----------------------------------------------------------
    ExecCmd("r.DepthOfFieldQuality", 0)                 -- Depth of field quality
    ExecCmd("r.Tonemapper.Sharpen", 4)                  -- Image sharpening
    ExecCmd("r.PostProcessing.DisableMaterials", 0)     -- Disable post-process materials
    ExecCmd("r.EyeAdaptationQuality", 1)                -- Eye adaptation quality

    ----------------------------------------------------------
    -- Effects
    ----------------------------------------------------------
    ExecCmd("r.VolumetricCloud", 0)              -- Volumetric cloud rendering
    ExecCmd("r.LightShaftQuality", 0)            -- Light shaft quality
    ExecCmd("r.LightFunctionQuality", 2)         -- Light function quality

    ----------------------------------------------------------
    -- Anti-Aliasing
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Textures
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Misc
    ----------------------------------------------------------

end

------------- # PRESET 3 / 4 # -------------

-- Performance

-- Prioritizes frame rate over visual quality.

-- Recommended:
-- GTX 1060
-- GTX 1650

-- Average FPS Gain:
-- +35~50%
local function ApplyPerformance() --3

    ----------------------------------------------------------
    -- Shadows
    ----------------------------------------------------------    
    ExecCmd("r.ShadowQuality", 4)                          -- Overall shadow quality
    ExecCmd("r.Shadow.DistanceScale", 0.64)               -- Shadow render distance
    ExecCmd("r.Shadow.CSM.MaxCascades", 1)                -- Cascaded shadow levels
    ExecCmd("r.Shadow.MaxCSMResolution", 8192)            -- Shadow map resolution
    ExecCmd("r.Shadow.RadiusThreshold", 0.03)             -- Shadow visibility threshold
    ExecCmd("r.Shadow.Denoiser", 0)                       -- Shadow denoiser
    ExecCmd("r.Shadow.Virtual.Enable", 0)                 -- Virtual Shadow Maps
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountLocal", 0)     -- Local shadow ray count
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountDirectional", 0) -- Directional shadow ray count
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstLevel", 8)     -- First virtual shadow clipmap level
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstCoarseLevel", 32) -- First coarse clipmap level
    ExecCmd("r.Shadow.NaniteLODBias", 3)                  -- Nanite shadow LOD bias    

    ----------------------------------------------------------
    -- Nanite
    ----------------------------------------------------------
    ExecCmd("r.Nanite", 0)                               -- Enable Nanite rendering
    ExecCmd("r.Nanite.ViewMeshLODBias.Offset", 3)        -- Nanite mesh LOD bias
    ExecCmd("r.Nanite.MinPixelsPerEdgeHW", 0)            -- Minimum pixels per edge
    ExecCmd("r.Nanite.ShadeBinningMode", 1)              -- Nanite shading mode

    ----------------------------------------------------------
    -- Foliage（植被）
    ----------------------------------------------------------
    ExecCmd("foliage.OnlyLOD", 0)                       -- Force a specific foliage LOD
    ExecCmd("foliage.DitheredLOD", 1)                   -- Enable smooth LOD transitions
    ExecCmd("foliage.LODDistanceScale", 2)              -- Foliage LOD distance scale
    ExecCmd("foliage.MinimumScreenSize", 0.000005)      -- Minimum foliage screen size

    ----------------------------------------------------------
    -- Lumen
    ----------------------------------------------------------
    ExecCmd("r.Lumen.Reflections.Allow", 0)                           -- Enable Lumen reflections
    ExecCmd("r.Lumen.ScreenProbeGather.DownsampleFactor", 32)         -- Screen probe downsample factor
    ExecCmd("r.Lumen.ScreenProbeGather.ShortRangeAO", 0)              -- Short-range ambient occlusion
    ExecCmd("r.Lumen.ScreenProbeGather.Temporal.MaxFramesAccumulated", 32) -- Temporal accumulation frames
    ExecCmd("r.Lumen.HardwareRayTracing", 0)                          -- Hardware ray tracing

    ----------------------------------------------------------
    -- Reflections
    ----------------------------------------------------------
    ExecCmd("r.SSR.Quality", 1)                     -- Screen Space Reflection quality

    ----------------------------------------------------------
    -- View Distance
    ----------------------------------------------------------
    ExecCmd("r.StaticMeshLODDistanceScale", 0.25)           -- Static mesh LOD distance scale

    ----------------------------------------------------------
    -- Post Processing
    ----------------------------------------------------------
    ExecCmd("r.DepthOfFieldQuality", 0)                 -- Depth of field quality
    ExecCmd("r.Tonemapper.Sharpen", 4)                  -- Image sharpening
    ExecCmd("r.PostProcessing.DisableMaterials", 1)     -- Disable post-process materials
    ExecCmd("r.EyeAdaptationQuality", 1)                -- Eye adaptation quality

    ----------------------------------------------------------
    -- Effects
    ----------------------------------------------------------
    ExecCmd("r.VolumetricCloud", 0)              -- Volumetric cloud rendering
    ExecCmd("r.LightShaftQuality", 0)            -- Light shaft quality
    ExecCmd("r.LightFunctionQuality", 2)         -- Light function quality

    ----------------------------------------------------------
    -- Anti-Aliasing
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Textures
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Misc
    ----------------------------------------------------------

end

------------- # PRESET 4 / 4 # -------------

-- Ultra Performance

-- Maximum FPS for older hardware.

-- Recommended:
-- GTX 970
-- GTX 1050 Ti
-- GTX 1060 3GB
-- GTX 1650

-- Average FPS Gain:
-- +50~70%
local function ApplyUltraPerformance() --4

    ----------------------------------------------------------
    -- Shadows
    ----------------------------------------------------------    
    ExecCmd("r.ShadowQuality", 0)                          -- Overall shadow quality
    ExecCmd("r.Shadow.DistanceScale", 0)               -- Shadow render distance
    ExecCmd("r.Shadow.CSM.MaxCascades", 0)                -- Cascaded shadow levels
    ExecCmd("r.Shadow.MaxCSMResolution", 1024)            -- Shadow map resolution
    ExecCmd("r.Shadow.RadiusThreshold", 0)             -- Shadow visibility threshold
    ExecCmd("r.Shadow.Denoiser", 0)                       -- Shadow denoiser
    ExecCmd("r.Shadow.Virtual.Enable", 0)                 -- Virtual Shadow Maps
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountLocal", 0)     -- Local shadow ray count
    ExecCmd("r.Shadow.Virtual.SMRT.RayCountDirectional", 0) -- Directional shadow ray count
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstLevel", 10)     -- First virtual shadow clipmap level
    ExecCmd("r.Shadow.Virtual.Clipmap.FirstCoarseLevel", 32) -- First coarse clipmap level
    ExecCmd("r.Shadow.NaniteLODBias", 0)                  -- Nanite shadow LOD bias    
    ----------------------------------------------------------
    -- Nanite
    ----------------------------------------------------------
    ExecCmd("r.Nanite", 0)                               -- Enable Nanite rendering
    ExecCmd("r.Nanite.ViewMeshLODBias.Offset", 3)        -- Nanite mesh LOD bias
    ExecCmd("r.Nanite.MinPixelsPerEdgeHW", 0)            -- Minimum pixels per edge
    ExecCmd("r.Nanite.ShadeBinningMode", 1)              -- Nanite shading mode
        
    ----------------------------------------------------------
    -- Foliage
    ----------------------------------------------------------
    ExecCmd("foliage.OnlyLOD", 0)                       -- Force a specific foliage LOD
    ExecCmd("foliage.DitheredLOD", 1)                   -- Enable smooth LOD transitions
    ExecCmd("foliage.LODDistanceScale", 1)              -- Foliage LOD distance scale
    ExecCmd("foliage.MinimumScreenSize", 0.000005)      -- Minimum foliage screen size

    ----------------------------------------------------------
    -- Lumen
    ----------------------------------------------------------
    ExecCmd("r.Lumen.Reflections.Allow", 0)                           -- Enable Lumen reflections
    ExecCmd("r.Lumen.ScreenProbeGather.DownsampleFactor", 32)         -- Screen probe downsample factor
    ExecCmd("r.Lumen.ScreenProbeGather.ShortRangeAO", 0)              -- Short-range ambient occlusion
    ExecCmd("r.Lumen.ScreenProbeGather.Temporal.MaxFramesAccumulated", 32) -- Temporal accumulation frames
    ExecCmd("r.Lumen.HardwareRayTracing", 0)                          -- Hardware ray tracing

    ----------------------------------------------------------
    -- Reflections
    ----------------------------------------------------------
    ExecCmd("r.SSR.Quality", 1)                     -- Screen Space Reflection quality

    ----------------------------------------------------------
    -- View Distance
    ----------------------------------------------------------
    ExecCmd("r.StaticMeshLODDistanceScale", 1)           -- Static mesh LOD distance scale

    ----------------------------------------------------------
    -- Post Processing
    ----------------------------------------------------------
    ExecCmd("r.DepthOfFieldQuality", 0)                 -- Depth of field quality
    ExecCmd("r.Tonemapper.Sharpen", 4)                  -- Image sharpening
    ExecCmd("r.PostProcessing.DisableMaterials", 1)     -- Disable post-process materials
    ExecCmd("r.EyeAdaptationQuality", 1)                -- Eye adaptation quality

    ----------------------------------------------------------
    -- Effects
    ----------------------------------------------------------
    ExecCmd("r.VolumetricCloud", 0)              -- Volumetric cloud rendering
    ExecCmd("r.LightShaftQuality", 0)            -- Light shaft quality
    ExecCmd("r.LightFunctionQuality", 2)         -- Light function quality

    ----------------------------------------------------------
    -- Anti-Aliasing
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Textures
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Misc
    ----------------------------------------------------------

end

----------------------------------------------------------
-- Map Overrides
----------------------------------------------------------
local MapOverrides = {}

----------------------------------------------------------
-- Lobby
----------------------------------------------------------
MapOverrides["Level /Game/Map/Lobby/Lobby.Lobby:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["r.ShadowQuality"] = 3,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Shadow.MaxCSMResolution"] = 1024,
        ["r.Shadow.DistanceScale"] = 0.16,
        ["r.VolumetricCloud"] = 1,

    },

    ["Balanced"] = {

        ["r.ShadowQuality"] = 4,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Shadow.MaxCSMResolution"] = 4096,
        ["r.Shadow.DistanceScale"] = 1024,
        ["r.VolumetricCloud"] = 1,

    },

    ["Performance"] = {

        ["r.ShadowQuality"] = 4,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Shadow.MaxCSMResolution"] = 4096,
        ["r.Shadow.DistanceScale"] = 1024,
        ["r.VolumetricCloud"] = 1,

    },

    ["Ultra Performance"] = {

        ["r.ShadowQuality"] = 4,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Shadow.MaxCSMResolution"] = 4096,
        ["r.Shadow.DistanceScale"] = 0.16,
        ["r.VolumetricCloud"] = 0,

    },

}

----------------------------------------------------------
-- CQB
----------------------------------------------------------
MapOverrides["Level /Game/Map/CQB/CQB.CQB:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.VolumetricCloud"] = 1,

    },

    ["Balanced"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.VolumetricCloud"] = 1,

    },

    ["Performance"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.VolumetricCloud"] = 0,

    },

    ["Ultra Performance"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.VolumetricCloud"] = 0,

    },

}

----------------------------------------------------------
-- RussianBuilding
----------------------------------------------------------
MapOverrides["Level /Game/Map/RussianBuilding/RussianBuilding.RussianBuilding:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["r.Lumen.HardwareRayTracing"] = 1,  

    },

    ["Balanced"] = {

        ["r.Lumen.HardwareRayTracing"] = 1,

    },

    ["Performance"] = {

        ["r.Lumen.HardwareRayTracing"] = 0,

    },

    ["Ultra Performance"] = {

        ["r.Lumen.HardwareRayTracing"] = 0,

    },  --只改了颜色改善

}

----------------------------------------------------------
-- Tumblewood
----------------------------------------------------------
MapOverrides["Level /Game/Map/Tumblewood/Tumblewood.Tumblewood:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["foliage.OnlyLOD"] = -1,
        ["foliage.DitheredLOD"] = 1,
        ["foliage.LODDistanceScale"] = 1,
        ["foliage.MinimumScreenSize"] = 0.000005,
        ["r.Shadow.CSM.MaxCascades"] = 3,
        ["r.Lumen.HardwareRayTracing"] = 1,

    },

    ["Balanced"] = {

        ["foliage.OnlyLOD"] = -1,
        ["foliage.DitheredLOD"] = 0,
        ["foliage.LODDistanceScale"] = 2,
        ["foliage.MinimumScreenSize"] = 0.1,
        ["r.Shadow.CSM.MaxCascades"] = 0,
        ["r.Lumen.HardwareRayTracing"] = 1,

    },

    ["Performance"] = {

        ["foliage.OnlyLOD"] = -1,
        ["foliage.DitheredLOD"] = 0,
        ["foliage.LODDistanceScale"] = 2,
        ["foliage.MinimumScreenSize"] = 0.1,
        ["r.Shadow.CSM.MaxCascades"] = 0,
        ["r.Lumen.HardwareRayTracing"] = 0,

    },

    ["Ultra Performance"] = {

        ["foliage.OnlyLOD"] = 0,
        ["foliage.DitheredLOD"] = 0,
        ["foliage.LODDistanceScale"] = 1,
        ["foliage.MinimumScreenSize"] = 0.1,
        ["r.Shadow.CSM.MaxCascades"] = 0,
        ["r.Lumen.HardwareRayTracing"] = 0,

    },

}

----------------------------------------------------------
-- BombHouse
----------------------------------------------------------
MapOverrides["Level /Game/Map/BombHouse/BombHouse.BombHouse:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["r.EyeAdaptationQuality"] = 1,

    },

    ["Balanced"] = {

        ["r.EyeAdaptationQuality"] = 1,

    },

    ["Performance"] = {

        ["r.EyeAdaptationQuality"] = 1,

    },

    ["Ultra Performance"] = {

        ["r.EyeAdaptationQuality"] = 0,

    },

}

----------------------------------------------------------
-- Paintball
----------------------------------------------------------
MapOverrides["Level /Game/Map/Paintball/Paintball.Paintball:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["r.EyeAdaptationQuality"] = 1,

    },

    ["Balanced"] = {

        ["r.EyeAdaptationQuality"] = 1,

    },

    ["Performance"] = {

        ["r.EyeAdaptationQuality"] = 1,

    },

    ["Ultra Performance"] = {

        ["r.EyeAdaptationQuality"] = 0,

    },

}

----------------------------------------------------------
-- Village
----------------------------------------------------------
MapOverrides["Level /Game/Map/Village/Village.Village:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["foliage.OnlyLOD"] = -1,

    },

    ["Balanced"] = {

        ["foliage.OnlyLOD"] = -1,

    },

    ["Performance"] = {

        ["foliage.OnlyLOD"] = -1,

    },

    ["Ultra Performance"] = {

        ["foliage.OnlyLOD"] = -1,

    },

}

----------------------------------------------------------
-- TransitionMap
----------------------------------------------------------
MapOverrides["Level /Game/Map/TransitionMap/TransitionMap.TransitionMap:PersistentLevel"] = {

    ["Vanilla Graphics"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Lumen.HardwareRayTracing"] = 1,
        ["r.ShadowQuality"] = 3,
        ["r.Shadow.CSM.MaxCascades"] = 3,
        ["r.Shadow.DistanceScale"] = 0.16,
        ["r.Shadow.MaxCSMResolution"] = 1024,
        ["foliage.OnlyLOD"] = -1,
        ["r.VolumetricCloud"] = 1,
        ["foliage.DitheredLOD"] = 1,
        ["foliage.LODDistanceScale"] = 1,
        ["foliage.MinimumScreenSize"] = 0.000005,

    },

    ["Balanced"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Lumen.HardwareRayTracing"] = 0,
        ["r.ShadowQuality"] = 4,
        ["r.Shadow.CSM.MaxCascades"] = 1,
        ["r.Shadow.DistanceScale"] = 0.64,
        ["r.Shadow.MaxCSMResolution"] = 8192,
        ["foliage.OnlyLOD"] = 0,
        ["r.VolumetricCloud"] = 0,
        ["foliage.DitheredLOD"] = 1,
        ["foliage.LODDistanceScale"] = 2,
        ["foliage.MinimumScreenSize"] = 0.000005,

    },

    ["Performance"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Lumen.HardwareRayTracing"] = 0,
        ["r.ShadowQuality"] = 4,
        ["r.Shadow.CSM.MaxCascades"] = 1,
        ["r.Shadow.DistanceScale"] = 0.64,
        ["r.Shadow.MaxCSMResolution"] = 8192,
        ["foliage.OnlyLOD"] = 0,
        ["r.VolumetricCloud"] = 0,
        ["foliage.DitheredLOD"] = 1,
        ["foliage.LODDistanceScale"] = 2,
        ["foliage.MinimumScreenSize"] = 0.000005,

    },

    ["Ultra Performance"] = {

        ["r.LightFunctionQuality"] = 2,
        ["r.EyeAdaptationQuality"] = 1,
        ["r.Lumen.HardwareRayTracing"] = 0,
        ["r.ShadowQuality"] = 0,
        ["r.Shadow.CSM.MaxCascades"] = 0,
        ["r.Shadow.DistanceScale"] = 0,
        ["r.Shadow.MaxCSMResolution"] = 1024,
        ["foliage.OnlyLOD"] = 0,
        ["r.VolumetricCloud"] = 0,
        ["foliage.DitheredLOD"] = 1,
        ["foliage.LODDistanceScale"] = 1,
        ["foliage.MinimumScreenSize"] = 0.000005,

    },

}

----------------------------------------------------------
-- Map Detection
----------------------------------------------------------
NotifyOnNewObject("/Script/Engine.Level", function(ConstructedObject)

    LastLevelLoad = os.clock()

    local RecognizedLevel = ConstructedObject:GetFullName()

    CurrentMap = RecognizedLevel

    CurrentMapOverride = MapOverrides[RecognizedLevel]

end)


----------------------------------------------------------
-- Auto Apply
----------------------------------------------------------



----------------------------------------------------------
-- Apply Current Preset
--
-- Applies the graphics preset selected in Configuration.
----------------------------------------------------------
local function ApplyCurrentPreset()

    if Mode == "Vanilla Graphics" then

        ApplyVanilla()

    elseif Mode == "Balanced" then

        ApplyBalanced()

    elseif Mode == "Performance" then

        ApplyPerformance()

    elseif Mode == "Ultra Performance" then

        ApplyUltraPerformance()

    end

    -- Apply map-specific overrides
    ApplyMapOverrides()

    CurrentPreset = Mode

end


----------------------------------------------------------
-- Set Graphics Preset
----------------------------------------------------------
local function SetPreset(Preset)

    Mode = Preset

    ApplyCurrentPreset()

end


----------------------------------------------------------
-- Apply Map Overrides
--
-- Applies map-specific console commands after the preset.
----------------------------------------------------------
local function ApplyMapOverrides()

    if not CurrentMapOverride then
        return
    end

    for Command, Value in pairs(CurrentMapOverride) do
        ExecCmd(Command, Value)
    end

end


----------------------------------------------------------
-- Task Queue
--
-- Executes a task immediately if the world is ready,
-- otherwise queues it for later execution.
----------------------------------------------------------
local function SubmitTask(Task)

    local World = GetWorld()

    if World
    and World:IsValid()
    and World.PersistentLevel then

        return Task()

    end

    table.insert(TaskQueue, Task)

end


----------------------------------------------------------
-- Flush Task Queue
--
-- Executes all queued tasks once the world is ready.
----------------------------------------------------------
local function FlushTaskQueue()

    local World = GetWorld()

    if not (
        World
        and World:IsValid()
        and World.PersistentLevel
    ) then
        return
    end

    for _, Task in ipairs(TaskQueue) do
        Task()
    end

    TaskQueue = {}

end


----------------------------------------------------------
-- Auto Apply Timer
----------------------------------------------------------



----------------------------------------------------------
-- Start Auto Apply
--
-- Automatically applies the selected graphics preset
-- after the configured delay.
----------------------------------------------------------
local function StartAutoApply()

    if not AutoApply then
        return
    end

    ExecuteWithDelay(AutoApplyDelay * 1000, function()

        SubmitTask(function()

            ApplyCurrentPreset()

        end)

    end)

end


----------------------------------------------------------
-- Startup
----------------------------------------------------------
StartAutoApply()


----------------------------------------------------------
-- Keybinds
----------------------------------------------------------
RegisterKeyBind(Key.F1, function()
    SetPreset("Vanilla Graphics")
end)

RegisterKeyBind(Key.F2, function()
    SetPreset("Balanced")
end)

RegisterKeyBind(Key.F3, function()
    SetPreset("Performance")
end)

RegisterKeyBind(Key.F4, function()
    SetPreset("Ultra Performance")
end)