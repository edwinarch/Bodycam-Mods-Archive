------------------------------------------------------------
-- Bodycam Optimizer v1.0.0
------------------------------------------------------------
--
-- Author : Carlos W
-- Engine : Unreal Engine 5.5
--
-- Mode:
--
-- UltraQuality
-- 提高画质
-- 基本不降低 FPS
--
-- Balanced
-- 默认模式
-- 平衡画质与性能
--
-- Performance
-- FPS 优先
-- 关闭部分特效
--
-- UltraPerformance
-- 极限性能模式
-- 推荐：
-- GTX 1650 4GB
-- RTX 3050 4GB
-- 或显存不足时使用
--
------------------------------------------------------------

Version = "1.0.0"

Mode = "Balanced"

------------------------------------------------------------
-- UE4SSp
------------------------------------------------------------

local UEHelpers = require("UEHelpers")

local ksl = UEHelpers.GetKismetSystemLibrary()
local engine = FindFirstOf("Engine")

local function Exec(cmd)

    if not ksl or not ksl:IsValid() then
        return
    end

    ExecuteInGameThread(function()

        ksl:ExecuteConsoleCommand(engine, cmd, nil)

    end)

end

------------------------------------------------------------
-- UltraQuality
------------------------------------------------------------

local function ApplyUltraQuality()

    -- TODO
    -- 后续添加所有 UltraQuality 参数

end

------------------------------------------------------------
-- Balanced
------------------------------------------------------------

local function ApplyBalanced()

    --0.CPU
    Exec("r.ParticleLODBias 1")
    Exec("r.LODFadeTime 0")
    Exec("r.HZBOcclusion 1")

    --------------------------------------------------
    --1.纹理
    --------------------------------------------------

    Exec("r.Streaming.PoolSize 4096")  --默认是768，6g显卡的就设置4096
    Exec("r.Streaming.MipBias 2")
    Exec("r.MaxAnisotropy 2")
    Exec("sg.TextureQuality 1")

    --------------------------------------------------
    --2.阴影
    --------------------------------------------------

    Exec("sg.ShadowQuality 1")
    Exec("r.ShadowQuality 1")
    Exec("r.Shadow.DistanceScale 0")  --默认是0.7
    Exec("r.Shadow.MaxResolution 512")
    Exec("r.Shadow.CSM.MaxCascades 2")

    --------------------------------------------------
    --3.Lumen
    --------------------------------------------------
    --Exec("sg.GlobalIlluminationQuality 1")   --（warning）
    Exec("sg.ReflectionQuality 1")

    --------------------------------------------------
    --4.后处理
    --------------------------------------------------

    Exec("sg.PostProcessQuality 1")

    Exec("r.MotionBlurQuality 0")
    Exec("r.DepthOfFieldQuality 0")
    Exec("r.BloomQuality 0")   --0不开光晕因为卡  默认是1的
    Exec("r.LensFlareQuality 0")  --（太阳眩光）  默认0
    Exec("r.SceneColorFringeQuality 0")
    Exec("r.Tonemapper.GrainQuantization 0")

    --------------------------------------------------
    --5.粒子
    --------------------------------------------------

    Exec("sg.EffectsQuality 1")

    Exec("fx.Niagara.QualityLevel 1")
    Exec("fx.Niagara.GlobalBudgetScale 0.4")

    --------------------------------------------------
    --6.植被
    --------------------------------------------------

    Exec("sg.FoliageQuality 1")

    Exec("foliage.DensityScale 0.4")
    Exec("grass.DensityScale 0.4")

    --------------------------------------------------
    --7.视距
    --------------------------------------------------

    Exec("sg.ViewDistanceQuality 1")
    Exec("r.ViewDistanceScale 0.75") --默认是0.75  远距离模式

    --------------------------------------------------
    --8.抗锯齿
    --------------------------------------------------

    --Exec("sg.AntiAliasingQuality 1")

    --------------------------------------------------
    --9.烟雾
    --------------------------------------------------

    Exec("r.VolumetricFog 0")
    Exec("r.Fog 1")

    --------------------------------------------------
    --10.AO
    --------------------------------------------------

    Exec("r.AmbientOcclusionLevels 1")
    Exec("r.AmbientOcclusionRadiusScale 0.5")

    --------------------------------------------------
    --11.SSR
    --------------------------------------------------

    Exec("r.SSR.Quality 1")
    Exec("r.SSR.MaxRoughness 0.4")

    --------------------------------------------------
    --12.分辨率
    --------------------------------------------------

    Exec("r.ScreenPercentage 80")

    --------------------------------------------------
    --13.Nanite
    --------------------------------------------------

    Exec("r.Nanite.MaxPixelsPerEdge 4")
    Exec("r.Nanite.Streaming.NumInitialRootPages 1024")

    --------------------------------------------------
    --14.VirtualTexture
    --------------------------------------------------

    Exec("r.VirtualTextures 1")   --默认是1

    --------------------------------------------------
    --15.Render
    --------------------------------------------------

    Exec("r.OneFrameThreadLag 1")

    --------------------------------------------------
    --16.LOD
    --------------------------------------------------

    Exec("r.StaticMeshLODDistanceScale 1.5")
    Exec("r.SkeletalMeshLODBias 1")

    --------------------------------------------------
    --17.夜视（这里以后你自己慢慢删）
    --------------------------------------------------

    Exec("r.DefaultFeature.AutoExposure 0")
    Exec("r.EyeAdaptationQuality 1") --默认是0的,但要一定开1不然啥也看不见

    Exec("r.ExposureOffset 0")

    Exec("r.Tonemapper.Quality 0")

    Exec("r.DefaultFeature.Bloom 0")

    --------------------------------------------------
    --18.未知不知道
    --------------------------------------------------
    --（天空散射）
    Exec("r.SkyAtmosphere.FastSkyLUT 0") 

end

------------------------------------------------------------
-- Performance
------------------------------------------------------------

local function ApplyPerformance()

    -- TODO
    -- 后续添加所有 Performance 参数

end

------------------------------------------------------------
-- UltraPerformance
------------------------------------------------------------

local function ApplyUltraPerformance()

    --0.cpu提升
    Exec("r.ParticleLODBias 4")
    Exec("r.LODFadeTime 0")
    Exec("r.HZBOcclusion 1")

    --1.纹理（重度省显存）
    Exec("r.Streaming.PoolSize 768")
    Exec("r.Streaming.MipBias 5")
    Exec("r.MaxAnisotropy 1")
    Exec("sg.TextureQuality 0")

    --2.阴影
    Exec("sg.ShadowQuality 0")
    Exec("r.Shadow.DistanceScale 0.35")
    Exec("r.Shadow.MaxResolution 128")    --128kb
    Exec("r.Shadow.CSM.MaxCascades 1")

    --3.Lumen流明
    -- 保持默认，不修改

    --4.后处理
    Exec("sg.PostProcessQuality 1")

    Exec("r.MotionBlurQuality 0")
    Exec("r.DepthOfFieldQuality 0")
    Exec("r.BloomQuality 0")
    Exec("r.LensFlareQuality 0")
    Exec("r.SceneColorFringeQuality 0")
    Exec("r.Tonemapper.GrainQuantization 0")

    --5.粒子
    Exec("sg.EffectsQuality 0")

    Exec("fx.Niagara.QualityLevel 0")
    Exec("fx.Niagara.GlobalBudgetScale 0.5")

    --6.植被
    Exec("sg.FoliageQuality 0")
    Exec("foliage.DensityScale 0.3")
    Exec("grass.DensityScale 0.3")

    --7.视距
    Exec("sg.ViewDistanceQuality 0")
    Exec("r.ViewDistanceScale 0.45")

    --8.抗锯齿
    Exec("sg.AntiAliasingQuality 1")

    --9.烟雾
    Exec("r.VolumetricFog 0")
    Exec("r.Fog 1")

    --10.AO
    Exec("r.AmbientOcclusionLevels 0")
    Exec("r.AmbientOcclusionRadiusScale 0")

    --11.SSR（水面反射）
    Exec("r.SSR.Quality 1")
    Exec("r.SSR.MaxRoughness 0.8")

    --12.渲染分辨率
    Exec("r.ScreenPercentage 45")

    --13.Nanite
    Exec("r.Nanite.MaxPixelsPerEdge 10")
    Exec("r.Nanite.Streaming.NumInitialRootPages 1024")

    --14.虚拟纹理
    Exec("r.VirtualTextures 1")

    --15.渲染线程
    Exec("r.OneFrameThreadLag 1")

    --16.LOD
    Exec("r.StaticMeshLODDistanceScale 5")
    Exec("r.SkeletalMeshLODBias 4")

    --17.镜头颗粒感
    Exec("r.FilmGrain 1")
    Exec("r.Tonemapper.Quality 0")

end

------------------------------------------------------------
-- Main
------------------------------------------------------------

local function ApplyCurrentMode()

    if Mode == "UltraQuality" then

        ApplyUltraQuality()

    elseif Mode == "Balanced" then

        ApplyBalanced()

    elseif Mode == "Performance" then

        ApplyPerformance()

    elseif Mode == "UltraPerformance" then

        ApplyUltraPerformance()

    else

        ApplyBalanced()

    end

end


------------------------------------------------------------
-- 游戏启动后
------------------------------------------------------------

ExecuteWithDelay(8000, function()

    print("[BodycamOptimizer] Auto Apply")

    ApplyCurrentMode()

end)


------------------------------------------------------------
-- 每8秒重新应用一次
------------------------------------------------------------

--LoopAsync(8000, function()

--    ApplyCurrentMode()

--end)


------------------------------------------------------------
-- F6 手动刷新
------------------------------------------------------------

RegisterKeyBind(Key.F6, function()

    print("[BodycamOptimizer] F6 Refresh")

    ApplyCurrentMode()

end)