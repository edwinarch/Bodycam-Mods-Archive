local UEHelpers = require("UEHelpers")

local GetWorld = UEHelpers.GetWorld
local GetKismetSystemLibrary = UEHelpers.GetKismetSystemLibrary

--- @param cmd string

function ExecCmd(param, value)
    local cmd = param.." "..value

    ExecuteInGameThread(function()
        local ksl = GetKismetSystemLibrary()
        local engine = FindFirstOf("Engine")
        if (ksl and ksl:IsValid()) and (engine and engine:IsValid()) then
            ksl:ExecuteConsoleCommand(engine, cmd, nil)
        end
    end)
end

function ToggleFPS()
    ExecCmd("stat", "fps")
end

local cqbLighting = false
local globalTweaks = {
    ["r.Lumen.Reflections.Allow"] = {1,0,0,0},
    ["r.DepthOfFieldQuality"] = {2,0,0,0},
    ["r.Lumen.ScreenProbeGather.DownsampleFactor"] = {32,32,32,32},
    ["r.Shadow.NaniteLODBias"] = {1,3,3,3},
    ["r.Tonemapper.Sharpen"] = {4,4,4,4},
    ["r.Lumen.ScreenProbeGather.ShortRangeAO"] = {1,0,0,0},
    ["r.Lumen.ScreenProbeGather.Temporal.MaxFramesAccumulated"] = {10,32,32,32},
    ["r.StaticMeshLODDistanceScale"] = {1,0.25,0.25,1},
    ["r.VolumetricCloud"] = {1,0,0,0},
    ["r.LightShaftQuality"] = {1,0,0,0},
    ["r.Lumen.HardwareRayTracing"] = {1,0,0,0},
    ["r.Nanite.MinPixelsPerEdgeHW"] = {32,0,0,0},
    ["r.Nanite.ViewMeshLODBias.Offset"] = {0,2,3,3},
    ["r.Shadow.Virtual.Enable"] = {1,0,0,0},
    ["r.Shadow.Virtual.SMRT.RayCountLocal"] = {8,0,0,0},
    ["r.Shadow.Virtual.SMRT.RayCountDirectional"] = {4,0,0,0},
    ["r.Shadow.Virtual.Clipmap.FirstLevel"] = {6,6,8,10},
    ["r.Shadow.Virtual.Clipmap.FirstCoarseLevel"] = {15,32,32,32},
    ["r.Shadow.CSM.MaxCascades"] = {3,1,1,0},
    ["r.Shadow.Denoiser"] = {2,0,0,0},
    ["r.Shadow.RadiusThreshold"] = {0.05,0.03,0.03,0},
    ["r.SSR.Quality"] = {3,1,1,1},
    ["r.ShadowQuality"] = {3,4,4,0},
    ["r.PostProcessing.DisableMaterials"] = {0,0,1,1},
    ["r.LightFunctionQuality"] = {2,2,2,2},
    ["r.EyeAdaptationQuality"] = {1,1,1,1},
    ["r.Nanite.ShadeBinningMode"]= {0,1,1,1},
    ["foliage.OnlyLOD"] = {-1,0,0,0},
    ["r.Shadow.MaxCSMResolution"] = {1024,8192,8192,1024},
    ["r.Shadow.DistanceScale"] = {0.16,0.64,0.64,0},
    ["r.Nanite"] = {1,0,0,0},
    ["foliage.DitheredLOD"] = {1,1,1,1},
    ["foliage.LODDistanceScale"] = {1,2,2,1},
    ["foliage.MinimumScreenSize"] = {0.000005,0.000005,0.000005,0.000005}
}

local perMapTweaks = {
    ["Level /Game/Map/TransitionMap/TransitionMap.TransitionMap:PersistentLevel"] = {
        ["r.LightFunctionQuality"] = {2,2,2,2},
        ["r.EyeAdaptationQuality"] = {1,1,1,1},
        ["r.Lumen.HardwareRayTracing"] = {1,0,0,0},
        ["r.ShadowQuality"] = {3,4,4,0},
        ["r.Shadow.CSM.MaxCascades"] = {3,1,1,0},
        ["r.Shadow.DistanceScale"] = {0.16,0.64,0.64,0},
        ["r.Shadow.MaxCSMResolution"] = {1024,8192,8192,1024},
        ["foliage.OnlyLOD"] = {-1,0,0,0},
        ["r.VolumetricCloud"] = {1,0,0,0},
        ["foliage.DitheredLOD"] = {1,1,1,1},
        ["foliage.LODDistanceScale"] = {1,2,2,1},
        ["foliage.MinimumScreenSize"] = {0.000005,0.000005,0.000005,0.000005}
    },
    ["Level /Game/Map/Lobby/Lobby.Lobby:PersistentLevel"] = {
        ["r.ShadowQuality"] = {3,4,4,4},
        ["r.EyeAdaptationQuality"] = {1,1,1,1},
        ["r.Shadow.MaxCSMResolution"] = {1024,4096,4096,4096},
        ["r.Shadow.DistanceScale"] = {0.16,1024,1024,0.16},
        ["r.VolumetricCloud"] = {1,1,1,0},
    },
    ["Level /Game/Map/RussianBuilding/RussianBuilding.RussianBuilding:PersistentLevel"] = {
        ["r.Lumen.HardwareRayTracing"] = {1,1,0,0},
    },
    ["Level /Game/Map/Tumblewood/Tumblewood.Tumblewood:PersistentLevel"] = {
        ["foliage.OnlyLOD"] = {-1,-1,-1,0},
        ["foliage.DitheredLOD"] = {1,0,0,0},
        ["foliage.LODDistanceScale"] = {1,2,2,1},
        ["r.Shadow.CSM.MaxCascades"] = {3,0,0,0},
        ["foliage.MinimumScreenSize"] = {0.000005,0.1,0.1,0.1},
        ["r.Lumen.HardwareRayTracing"] = {1,1,0,0},
    },
    ["Level /Game/Map/CQB/CQB.CQB:PersistentLevel"] = {
        ["r.LightFunctionQuality"] = {2,2,2,2},
        ["r.VolumetricCloud"] = {1,1,0,0},
    },
    ["Level /Game/Map/BombHouse/BombHouse.BombHouse:PersistentLevel"] = {
        ["r.EyeAdaptationQuality"] = {1,1,1,0}
    },
    ["Level /Game/Map/Paintball/Paintball.Paintball:PersistentLevel"] = {
        ["r.EyeAdaptationQuality"] = {1,1,1,0}
    },
    ["Level /Game/Map/Village/Village.Village:PersistentLevel"] = {
        ["foliage.OnlyLOD"] = {-1,-1,-1,-1},
    }
}

function SetFishEyeEnabled(fisheye_enabled)
    local chars = FindAllOf("ALS_AnimMan_CharacterBP_C")
    if not chars then return end

    for _, char in ipairs(chars) do
        if char and char:IsValid() then
            local comp = char.FishEye
            if comp and comp:IsValid() then
                comp:SetVisibility(fisheye_enabled, true)
            end
        end
    end
end

local currentTweakLevel = 2
local blockedIndexes = {}
local loadedMapTweaks = {}
local loadedMapTweaksName = nil
function loadMapTweaks()
    SetFishEyeEnabled(currentTweakLevel < 3)
    print("[CQBTweaks] Loading map-specific tweaks at performance level "..currentTweakLevel)
    blockedIndexes = {}
    for i, v in pairs(loadedMapTweaks) do
        blockedIndexes[i] = true
        ExecCmd(i,v[currentTweakLevel])
    end
end
function SetTweakLevel(id)
    id=id+1
    if id ~= currentTweakLevel then
        print("[CQBTweaks] Set performance level to "..id)
    end
    currentTweakLevel = id

    loadMapTweaks()

    for i,v in pairs(globalTweaks) do
        if not blockedIndexes[i] then
            ExecCmd(i,v[id])
        end
    end
end

local taskQueue = {}
function TaskQueueSubmit(func)
    local world = GetWorld()
    if world and world:IsValid() and world.PersistentLevel then
        return func()
    end
    table.insert(taskQueue, func)
end
function FlushTaskQueue()
    local world = GetWorld()
    if not (world and world:IsValid() and world.PersistentLevel) then
        return
    end
    for _,task in pairs(taskQueue) do
        task()
    end
    taskQueue = {}
end

local lastLevelLoad = 0
local needsLoad = false
function LoadMapTweaksLate()
    if needsLoad and os.clock() - lastLevelLoad > 2 then
        needsLoad = false
        TaskQueueSubmit(function() loadMapTweaks() end)
    end
    FlushTaskQueue()
    ExecuteWithDelay(1000, LoadMapTweaksLate)
end

local hasDoneInit = false
NotifyOnNewObject("/Script/Engine.Level", function(ConstructedObject)
    lastLevelLoad = os.clock()
    local recognizedLevel = ConstructedObject:GetFullName()
    print("[CQBTweaks] Level loaded: "..recognizedLevel)
    local hasTweaks = perMapTweaks[recognizedLevel]
    if hasTweaks then
        print("[CQBTweaks] Swapped map-specific tweaks.")
        -- Load early to avoid lobby bug
        loadedMapTweaks = hasTweaks
        loadedMapTweaksName = recognizedLevel
        needsLoad = true
        TaskQueueSubmit(function() loadMapTweaks() end)
    end
    if not hasDoneInit and recognizedLevel == "Level /Game/Map/Lobby/Lobby.Lobby:PersistentLevel" then
        hasDoneInit = true
        LoadMapTweaksLate()
        SetTweakLevel(1)
        ToggleFPS()
    end
end)

RegisterConsoleCommandHandler("fpsb", function(OutputDevice)
    SetTweakLevel(1)
    return true
end)

RegisterKeyBind(Key.F5, {ModifierKey.SHIFT}, function()
    cqbLighting = not cqbLighting
    local inCQB = (loadedMapTweaksName == "Level /Game/Map/CQB/CQB.CQB:PersistentLevel")
    if cqbLighting then
        perMapTweaks["Level /Game/Map/CQB/CQB.CQB:PersistentLevel"]["r.LightFunctionQuality"] = {2,0,0,0}
        if inCQB then
            ExecCmd("r.LightFunctionQuality",currentTweakLevel==1 and 2 or 0)
        end
    else
        perMapTweaks["Level /Game/Map/CQB/CQB.CQB:PersistentLevel"]["r.LightFunctionQuality"] = {2,2,2,2}
        if inCQB then
            ExecCmd("r.LightFunctionQuality",2)
        end
    end
end)
RegisterKeyBind(Key.F5, ToggleFPS)
RegisterKeyBind(Key.F1, function() SetTweakLevel(0) end)
RegisterKeyBind(Key.F2, function() SetTweakLevel(1) end)
RegisterKeyBind(Key.F3, function() SetTweakLevel(2) end)
--RegisterKeyBind(Key.F4, function() SetTweakLevel(3) end)