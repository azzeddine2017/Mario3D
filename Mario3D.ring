#===================================================================#
# Super Mario 3D - Multi-Level Mushroom Kingdom Adventure
# Built with Ring + RayLib 5.0 (3D Platformer Engine)
# Author: Azzeddine Remmal (Porting Classic Nostalgic Titles to Ring)
#===================================================================#

load "raylib.ring"
load "stdlibcore.ring"

# Load OOP Subsystems
load "Config.ring"
load "Camera.ring"
load "Player.ring"
load "World.ring"
load "Enemies.ring"
load "HUD.ring"
load "AudioManager.ring"
load "TextureManager.ring"

# -------------------------------------------------------------------
# Application Entry Point
# -------------------------------------------------------------------
func main
    game = new Mario3DGame()
    game.run()

# -------------------------------------------------------------------
# Advanced Particle & VFX Effect System
# -------------------------------------------------------------------
class ParticleSystem
    particles  = []
    shockwaves = []

    func init
        particles  = []
        shockwaves = []
    end

    func reset
        particles  = []
        shockwaves = []
    end

    func addParticle px, py, pz, vx, vy, vz, rad, lifeTime, pCol
        particles + [ px, py, pz, vx, vy, vz, rad, lifeTime, lifeTime, pCol ]
    end

    func spawnDust px, py, pz, count
        for i = 1 to count
            vx = (random(100) - 50.0) * 0.025
            vy = (random(50) + 15.0) * 0.03
            vz = (random(100) - 50.0) * 0.025
            c = RAYLibColor(230, 230, 230, 190)
            addParticle(px, py + 0.12, pz, vx, vy, vz, 0.22, 0.45, c)
        next
    end

    func spawnCoinSparkles px, py, pz, count
        for i = 1 to count
            vx = (random(100) - 50.0) * 0.04
            vy = (random(80) + 20.0) * 0.05
            vz = (random(100) - 50.0) * 0.04
            c = GOLD_SHINE
            addParticle(px, py + 0.5, pz, vx, vy, vz, 0.18, 0.60, c)
        next
    end

    func spawnShockwave px, py, pz, maxRadius
        shockwaves + [ px, py, pz, 0.2, maxRadius, 0.45, 0.45 ]
    end

    func update dt
        # 1. Update Standard Particles
        i = 1
        while i <= len(particles)
            p = particles[i]
            p[1] += p[4] * dt
            p[2] += p[5] * dt
            p[3] += p[6] * dt
            p[4] *= 0.94
            p[6] *= 0.94
            p[8] -= dt
            if p[8] <= 0.0
                del(particles, i)
            else
                particles[i] = p
                i++
            ok
        end

        # 2. Update Ground Pound Shockwaves
        swIdx = 1
        while swIdx <= len(shockwaves)
            sw = shockwaves[swIdx]
            sw[6] -= dt
            sw[4] = lerpVal(0.2, sw[5], 1.0 - (sw[6] / sw[7]))
            if sw[6] <= 0.0
                del(shockwaves, swIdx)
            else
                shockwaves[swIdx] = sw
                swIdx++
            ok
        end
    end

    func draw
        for i = 1 to len(particles)
            p = particles[i]
            aFactor = clampVal(p[8] / p[9], 0.0, 1.0)
            pCol = p[10]
            DrawSphere(Vector3(p[1], p[2], p[3]), p[7] * aFactor, pCol)
        next

        for swIdx = 1 to len(shockwaves)
            sw = shockwaves[swIdx]
            swR = sw[4]
            swAlpha = floor(220 * (sw[6] / sw[7]))
            cRing = RAYLibColor(255, 230, 120, swAlpha)
            DrawCylinder(Vector3(sw[1], sw[2], sw[3]), swR, swR + 0.35, 0.08, 24, cRing)
        next
    end
end

# -------------------------------------------------------------------
# Master Game Director & Multi-Level Engine
# -------------------------------------------------------------------
class Mario3DGame
    mario
    cam
    world
    enemies
    hud
    audio
    texMgr
    particles

    gameState
    gameTime
    currentLevel

    func init
        # 1. Initialize RayLib Window
        SetConfigFlags(FLAG_MSAA_4X_HINT)
        InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Super Mario 3D - Mushroom Kingdom (RingRayLib)")
        SetTargetFPS(FPS_TARGET)

        # Display splash title in console
        ? "================================================="
        ? " SUPER MARIO 3D - MUSHROOM KINGDOM EXPANSION"
        ? " Powered by Ring & RayLib 5.0 (C) Azzeddine Remmal"
        ? "================================================="

        BeginDrawing()
        ClearBackground(SKY_BLUE)
        DrawText("Loading Super Mario 3D World...", SCREEN_WIDTH/2 - 180, SCREEN_HEIGHT/2 - 20, 24, WHITE)
        EndDrawing()

        gameState    = STATE_PLAYING
        gameTime     = 0.0
        currentLevel = 1

        # 2. Initialize Subsystems
        audio     = new MarioAudioManager()
        texMgr    = new MarioTextureManager()
        mario     = new MarioPlayer(Vector3(0.0, 1.5, 0.0))
        cam       = new ThirdPersonCamera(mario.pos)
        world     = new MarioWorld()
        enemies   = new EnemyManager()
        hud       = new MarioHUD()
        particles = new ParticleSystem()

        loadLevel(1)
    end

    func loadLevel levelNum
        currentLevel = levelNum
        world.loadLevel(levelNum)
        enemies.reset(levelNum)
        particles.reset()

        mario.respawn(Vector3(0.0, 1.5, 0.0))
        mario.checkpointPos = Vector3(0.0, 1.5, 0.0)
        mario.hasStar = false

        cam.yaw = 180.0
        cam.pitch = 20.0
        cam.targetPos = Vector3(0.0, 3.1, 0.0)
        cam.updatePosition()
        gameState = STATE_PLAYING
    end

    func run
        while !WindowShouldClose()
            dt = GetFrameTime()
            if dt > 0.05 dt = 0.05 ok

            handleInput()
            update(dt)
            draw()
        end

        if texMgr != NULL texMgr.cleanup() ok
        if audio != NULL audio.cleanup() ok
        CloseWindow()
    end

    func handleInput
        # Pause Toggle
        if IsKeyPressed(KEY_ESCAPE) or IsKeyPressed(KEY_P)
            if audio != NULL audio.playPause() ok
            if gameState = STATE_PLAYING
                gameState = STATE_PAUSED
            elseif gameState = STATE_PAUSED
                gameState = STATE_PLAYING
            ok
        ok

        # State Specific Inputs
        if gameState = STATE_LEVEL_CLEAR
            if IsKeyPressed(KEY_ENTER) or IsKeyPressed(KEY_SPACE)
                if currentLevel < 3
                    loadLevel(currentLevel + 1)
                else
                    gameState = STATE_VICTORY
                ok
            ok
        elseif gameState = STATE_VICTORY or gameState = STATE_GAMEOVER
            if IsKeyPressed(KEY_ENTER) or IsKeyPressed(KEY_SPACE)
                restartGame()
            ok
        elseif gameState = STATE_PAUSED
            if IsKeyPressed(KEY_R)
                restartGame()
            ok
        ok
    end

    func update dt
        hud.update(dt)
        if audio != NULL audio.update() ok

        if gameState = STATE_PLAYING
            gameTime += dt

            # 1. Update Mario Controller
            mario.update(dt, cam, world, enemies, particles, audio)

            # 2. Update Orbit Camera Tracking
            cam.update(dt, mario.pos, mario.facingAngle)

            # 3. Update Level Environment, Blocks & Moving Lifts
            world.update(dt, mario, audio)

            # 4. Update Enemies (Goombas, Koopas, Piranhas, Thwomps)
            enemies.update(dt, mario, particles, audio, world)

            # 5. Update Particles & Shockwaves
            particles.update(dt)

            # 6. Check Level Goal Condition (Flagpole / Power Star)
            if world.checkGoalReached(mario)
                if gameState != STATE_LEVEL_CLEAR and audio != NULL
                    audio.playClear()
                ok
                gameState = STATE_LEVEL_CLEAR
                mario.hasStar = true
                mario.stars += 1
                mario.score += 5000
            ok

            # 7. Check Game Over Condition
            if mario.isDead
                gameState = STATE_GAMEOVER
            ok

            # 8. Single Life Respawn (At Checkpoint if activated!)
            if mario.deathTimer <= 0.0 and mario.health <= 0 and mario.lives > 0
                respawnTarget = mario.checkpointPos
                mario.respawn(Vector3(respawnTarget.x, respawnTarget.y + 1.5, respawnTarget.z))
                cam.targetPos = Vector3(respawnTarget.x, respawnTarget.y + 2.5, respawnTarget.z)
                cam.updatePosition()
            ok
        ok
    end

    func restartGame
        gameState    = STATE_PLAYING
        gameTime     = 0.0
        currentLevel = 1
        mario.respawn(Vector3(0.0, 1.5, 0.0))
        mario.lives = 3
        mario.coins = 0
        mario.score = 0
        mario.stars = 0
        mario.hasStar = false
        mario.isSuper = false
        mario.scaleMultiplier = 1.0
        mario.currentScale = 1.0
        mario.starmanTimer = 0.0
        mario.checkpointPos = Vector3(0.0, 1.5, 0.0)

        loadLevel(1)
        if audio != NULL audio.resumeMusic() ok
    end

    func draw
        BeginDrawing()

        # 1. Dynamic Atmosphere Sky Colors per World
        if currentLevel = 1
            ClearBackground(SKY_BLUE)
        elseif currentLevel = 2
            ClearBackground(RAYLibColor(35, 12, 18, 255)) # Dark Lava Dungeon
        elseif currentLevel = 3
            ClearBackground(RAYLibColor(115, 185, 245, 255)) # Sky Blue
        ok

        # 2. 3D Scene Rendering
        BeginMode3D(cam.camera)

            # Ambient Horizon Scenery
            drawHorizonScenery()

            # 1. World Platforms, Moving Lifts, Pipes, Blocks, Coins & Hazards
            world.draw(texMgr, cam)

            # 2. Dynamic Drop Shadows
            mario.drawDropShadow(world)
            enemies.drawDropShadows(world)

            # 3. Active Enemies (Goombas, Koopas, Piranhas, Thwomps)
            enemies.draw(texMgr)

            # 4. Mario 3D Procedural Rig
            mario.draw()

            # 5. Visual Particles & Ground Pound Shockwaves
            particles.draw()

        EndMode3D()

        # 3. 2D Heads-Up Display & Overlays
        if gameState = STATE_PLAYING
            hud.drawPlayingHUD(mario, gameTime, world)
        elseif gameState = STATE_LEVEL_CLEAR
            hud.drawPlayingHUD(mario, gameTime, world)
            hud.drawCourseClearScreen(mario, gameTime, currentLevel + 1)
        elseif gameState = STATE_VICTORY
            hud.drawGrandVictoryScreen(mario, gameTime)
        elseif gameState = STATE_GAMEOVER
            hud.drawPlayingHUD(mario, gameTime, world)
            hud.drawGameOverScreen(mario)
        elseif gameState = STATE_PAUSED
            hud.drawPlayingHUD(mario, gameTime, world)
            hud.drawPauseScreen()
        ok

        EndDrawing()
    end

    func drawHorizonScenery
        if currentLevel = 1
            # Sun
            DrawSphere(Vector3(60.0, 48.0, 140.0), 9.0, GOLD_SHINE)
            DrawSphere(Vector3(60.0, 48.0, 140.0), 12.0, RAYLibColor(255, 245, 160, 120))

            cHill1 = RAYLibColor(90, 175, 70, 255)
            cHill2 = RAYLibColor(68, 150, 55, 255)
            DrawSphere(Vector3(35.0, -12.0, 110.0), 38.0, cHill1)
            DrawSphere(Vector3(-45.0, -10.0, 120.0), 42.0, cHill2)
            DrawSphere(Vector3(75.0, -15.0, 25.0), 32.0, cHill1)
            DrawSphere(Vector3(-70.0, -14.0, 15.0), 34.0, cHill2)
        elseif currentLevel = 2
            # Dark Volcanic Lava Peaks
            cV1 = RAYLibColor(40, 20, 25, 255)
            cV2 = RAYLibColor(60, 25, 25, 255)
            DrawCylinder(Vector3(40.0, -10.0, 110.0), 0.5, 28.0, 45.0, 8, cV1)
            DrawCylinder(Vector3(-50.0, -8.0, 100.0), 0.5, 32.0, 50.0, 8, cV2)
            DrawCylinder(Vector3(0.0, -12.0, 130.0), 0.5, 38.0, 60.0, 8, cV1)
            # Distant Red Moon
            DrawSphere(Vector3(0.0, 45.0, 130.0), 10.0, RAYLibColor(235, 45, 30, 255))
        elseif currentLevel = 3
            # High Altitude Clouds & Golden Sun
            DrawSphere(Vector3(40.0, 55.0, 130.0), 11.0, GOLD_SHINE)
            DrawSphere(Vector3(-35.0, 15.0, 100.0), 22.0, RAYLibColor(255, 255, 255, 200))
            DrawSphere(Vector3(45.0, 10.0, 90.0), 25.0, RAYLibColor(255, 255, 255, 200))
        ok
    end
end
