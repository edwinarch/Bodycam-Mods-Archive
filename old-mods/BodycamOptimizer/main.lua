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
local function ApplyVanilla()

    ExecCmd("r.ShadowQuality", 3)
    
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
local function ApplyBalanced()

    ----------------------------------------------------------
    -- Shadows
    ----------------------------------------------------------    
    ExecCmd("r.ShadowQuality",3)    -- Overall shadow quality
    ExecCmd("r.Shadow.DistanceScale",0.64)  -- Shadow render distance

    ----------------------------------------------------------
    -- Nanite
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Foliage
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Lumen
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Reflections
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- View Distance
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Post Processing
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Effects
    ----------------------------------------------------------

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
local function ApplyPerformance()

    ----------------------------------------------------------
    -- Shadows
    ----------------------------------------------------------    
    ExecCmd("r.ShadowQuality",2)    -- Overall shadow quality
    ExecCmd("r.Shadow.DistanceScale",0.3) -- Shadow render distance

    ----------------------------------------------------------
    -- Nanite
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Foliage
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Lumen
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Reflections
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- View Distance
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Post Processing
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Effects
    ----------------------------------------------------------

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
local function ApplyUltraPerformance()

    ----------------------------------------------------------
    -- Shadows
    ----------------------------------------------------------    
    ExecCmd("r.ShadowQuality",0)    -- Overall shadow quality
    ExecCmd("r.Shadow.DistanceScale",0) -- Shadow render distance
    ExecCmd("r.Shadow.CSM.MaxCascades", 1)  -- Cascaded shadow levels

    ----------------------------------------------------------
    -- Nanite
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Foliage
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Lumen
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Reflections
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- View Distance
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Post Processing
    ----------------------------------------------------------

    ----------------------------------------------------------
    -- Effects
    ----------------------------------------------------------

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

}

----------------------------------------------------------
-- CQB
----------------------------------------------------------
MapOverrides["Level /Game/Map/CQB/CQB.CQB:PersistentLevel"] = {

}

----------------------------------------------------------
-- Village
----------------------------------------------------------
MapOverrides["Level /Game/Map/Village/Village.Village:PersistentLevel"] = {

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