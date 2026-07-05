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
-- UE4SS
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

    Exec("r.Streaming.PoolSize 768")
    Exec("r.Streaming.MipBias 2")
    Exec("r.MaxAnisotropy 2")
    Exec("sg.TextureQuality 1")

    --------------------------------------------------
    --2.阴影
    --------------------------------------------------

    Exec("sg.ShadowQuality 1")
    Exec("r.ShadowQuality 1")
    Exec("r.Shadow.DistanceScale 0.7")
    Exec("r.Shadow.MaxResolution 512")
    Exec("r.Shadow.CSM.MaxCascades 2")

    --------------------------------------------------
    --3.Lumen
    --------------------------------------------------

    --Exec("sg.GlobalIlluminationQuality 0") --默认是1 （有问题的东西
    Exec("sg.ReflectionQuality 0")    --默认是1

    --------------------------------------------------
    --4.后处理
    --------------------------------------------------

    Exec("sg.PostProcessQuality 1")

    Exec("r.MotionBlurQuality 0")
    Exec("r.DepthOfFieldQuality 0")
    Exec("r.BloomQuality 1")
    Exec("r.LensFlareQuality 0")
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

    Exec("sg.FoliageQuality 1")  --默认1不用改

    Exec("foliage.DensityScale 0.4")
    Exec("grass.DensityScale 0.4")

    --------------------------------------------------
    --7.视距
    --------------------------------------------------

    Exec("sg.ViewDistanceQuality 1")
    Exec("r.ViewDistanceScale 0.75")

    --------------------------------------------------
    --8.抗锯齿
    --------------------------------------------------

    Exec("sg.AntiAliasingQuality 1")

    --------------------------------------------------
    --9.烟雾
    --------------------------------------------------

    Exec("r.VolumetricFog 0")
    Exec("r.Fog 1")

    --------------------------------------------------
    --10.AO
    --------------------------------------------------

    Exec("r.AmbientOcclusionLevels 1")    --默认为1
    Exec("r.AmbientOcclusionRadiusScale 0.5")

    --------------------------------------------------
    --11.SSR
    --------------------------------------------------

    Exec("r.SSR.Quality 1")    --默认是1  -------
    Exec("r.SSR.MaxRoughness 0.4")

    --------------------------------------------------
    --12.分辨率
    --------------------------------------------------

    Exec("r.ScreenPercentage 85")   --默认就85

    --------------------------------------------------
    --13.Nanite
    --------------------------------------------------

    Exec("r.Nanite.MaxPixelsPerEdge 4")
    Exec("r.Nanite.Streaming.NumInitialRootPages 1024")

    --------------------------------------------------
    --14.VirtualTexture
    --------------------------------------------------

    Exec("r.VirtualTextures 1")  --默认是1不用改

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

    Exec("r.DefaultFeature.AutoExposure 0")  --默认为0
    Exec("r.EyeAdaptationQuality 1")    --默认是0, 一定用1 

    Exec("r.ExposureOffset 0")    --默认为0不用改

    Exec("r.Tonemapper.Quality 0") --默认0

    Exec("r.DefaultFeature.Bloom 0")  --默认0

    

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
    Exec("r.ParticleLODBias 2")
    ---cpu LOD瞬间切换
    Exec("r.LODFadeTime 0")
    ---利用 GPU 遮挡剔除。 一般都会提高一点 FPS。
    Exec("r.HZBOcclusion 1")

    -- 1.纹理（显存优化）
    Exec("r.Streaming.PoolSize 640")          -- 512容易一直爆Mip，768更稳定 (显卡弱就调低)
    Exec("r.Streaming.MipBias 4")           -- 不建议4，2~3已经能省很多显存       越大越省显存 不过贴图越模糊
    Exec("r.MaxAnisotropy 2")                 -- 1画质下降明显，2几乎看不出来
    Exec("sg.TextureQuality 0")   --0

    --2.阴影
    Exec("sg.ShadowQuality 0")
    Exec("r.Shadow.DistanceScale 0.5") --0.5
    Exec("r.Shadow.MaxResolution 256") --256
    Exec("r.Shadow.CSM.MaxCascades 1")
    
    --3.Lumen流明

    --4.后处理
    Exec("sg.PostProcessQuality 1")           -- 千万不要0

    Exec("r.MotionBlurQuality 0")
    Exec("r.DepthOfFieldQuality 0")
    Exec("r.BloomQuality 0")                  -- 保留一点Bloom，不然画面很死 2
    Exec("r.LensFlareQuality 0")
    Exec("r.SceneColorFringeQuality 0")
    Exec("r.Tonemapper.GrainQuantization 0")

    --5.粒子
    Exec("sg.EffectsQuality 0")

    Exec("fx.Niagara.QualityLevel 0")
    Exec("fx.Niagara.GlobalBudgetScale 0.15")

    --6.植被 草
    Exec("sg.FoliageQuality 0")
    Exec("foliage.DensityScale 0.5")
    Exec("grass.DensityScale 0.5")

    --7.视距
    Exec("sg.ViewDistanceQuality 0") --0
    Exec("r.ViewDistanceScale 0.5") --0.65

    --8.抗锯齿
    Exec("sg.AntiAliasingQuality 1")

    --9.烟雾
    Exec("r.VolumetricFog 0")
    Exec("r.Fog 1")                           -- 保留普通雾，不然地图很奇怪

    --12.AO(Ambient Occlusion)    （环境光遮蔽）
    Exec("r.AmbientOcclusionLevels 1")        -- 保留最低AO
    Exec("r.AmbientOcclusionRadiusScale 0.6")

    --13.渲染分辨率（最能提升 FPS）
    Exec("r.ScreenPercentage 50")
    -----不建议默认设成 25%。
    -------25% 更适合作为测试值，实际玩游戏画面会非常模糊。70%～80% 通常是更实用的默认值。

    --14.Nanite
    Exec("r.Nanite.MaxPixelsPerEdge 12") --4 或者8
    Exec("r.Nanite.Streaming.NumInitialRootPages 1024") --1024

    --15.虚拟纹理
    Exec("r.VirtualTextures 1")

    --16.渲染线程
    Exec("r.OneFrameThreadLag 1")

    --17.LOD
    Exec("r.StaticMeshLODDistanceScale 4") 
    Exec("r.SkeletalMeshLODBias 4")
    --高精度模型（High LOD / LOD 0）：角色或物体在近距离
    --中精度模型（Medium LOD / LOD 1）：玩家走远后触发，模型面数减少，省略微小细节。
    --低精度模型（Low LOD / LOD 2）：距离非常远时触发，面数大幅缩减，仅保留大致轮廓。
    --公告板（Billboards / LOD 3）：最极端的距离，直接用一张 2D 贴图代替复杂的 3D 模型（如远处的树木和建筑）。

    --静态反射
    Exec("r.ReflectionEnvironment 0")
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