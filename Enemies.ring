#===================================================================#
# Mario 3D - Advanced Enemy Subsystem (Goombas, Koopas, Piranhas, Thwomps)
# 360° Orientation, Animated Locomotion, Stomping, Shell Kicking & Thwomp Slams
#===================================================================#

# -------------------------------------------------------------------
# 1. Classic Goomba Enemy (True 3D Locomotion & Rotation)
# -------------------------------------------------------------------
class GoombaEnemy
    pos            = null
    vel            = null
    startPos       = null
    patrolDistance = 0.0
    patrolSpeed    = 0.0
    moveDir        = 1.0        # 1 or -1 along patrolAxis
    patrolAxis     = "x"        # "x" or "z"
    facingAngle    = 0.0        # Orientation in degrees

    radius         = 0.65
    height         = 1.1

    isAlive        = true
    isSquashed     = false
    squashTimer    = 0.0
    squashDuration = 0.65

    walkTimer      = 0.0

    func init x, y, z, axis, dist, spd
        pos            = Vector3(x, y, z)
        vel            = Vector3(0, 0, 0)
        startPos       = Vector3(x, y, z)
        patrolAxis     = axis
        patrolDistance = dist
        patrolSpeed    = spd
        walkTimer      = (x * 3.7 + z * 2.1) % 6.28
        return self
    end

    func update dt, mario
        if !isAlive return ok

        if isSquashed
            squashTimer += dt
            if squashTimer >= squashDuration
                isAlive = false
            ok
            return
        ok

        # Walk animation phase
        walkTimer += dt * 10.0

        # Mario Detection & Smooth Chase AI
        chasingMario = false
        if mario != null and !mario.isDead
            dx = mario.pos.x - pos.x
            dz = mario.pos.z - pos.z
            dy = fabs(mario.pos.y - pos.y)
            dist = sqrt(dx * dx + dz * dz)

            if dist < 8.5 and dy < 2.5 and dist > 0.4
                chasingMario = true
                facingAngle = atan2(dx, dz) * RAD2DEG
                chaseSpeed = patrolSpeed * 1.35
                pos.x += sin(facingAngle * DEG2RAD) * chaseSpeed * dt
                pos.z += cos(facingAngle * DEG2RAD) * chaseSpeed * dt
            ok
        ok

        if !chasingMario
            # Standard Linear Patrol
            if patrolAxis = "x"
                pos.x += moveDir * patrolSpeed * dt
                if moveDir > 0.0
                    facingAngle = 90.0
                else
                    facingAngle = 270.0
                ok

                if pos.x >= (startPos.x + patrolDistance)
                    pos.x = startPos.x + patrolDistance
                    moveDir = -1.0
                elseif pos.x <= (startPos.x - patrolDistance)
                    pos.x = startPos.x - patrolDistance
                    moveDir = 1.0
                ok
            else
                pos.z += moveDir * patrolSpeed * dt
                if moveDir > 0.0
                    facingAngle = 0.0
                else
                    facingAngle = 180.0
                ok

                if pos.z >= (startPos.z + patrolDistance)
                    pos.z = startPos.z + patrolDistance
                    moveDir = -1.0
                elseif pos.z <= (startPos.z - patrolDistance)
                    pos.z = startPos.z - patrolDistance
                    moveDir = 1.0
                ok
            ok
        ok
    end

    func squash
        if isSquashed return ok
        isSquashed = true
        squashTimer = 0.0
    end

    func drawDropShadow world
        if !isAlive return ok
        groundY = world.getGroundHeightUnder(pos.x, pos.z, pos.y)
        hDiff = pos.y - groundY
        if hDiff < 0.0 or hDiff > 10.0 return ok
        sFactor = clampVal(1.0 - (hDiff / 8.0), 0.3, 1.0)
        cShadow = RAYLibColor(15, 25, 15, floor(130 * sFactor))
        DrawCylinder(Vector3(pos.x, groundY + 0.05, pos.z), radius * sFactor, radius * sFactor, 0.03, 12, cShadow)
    end

    func draw
        if !isAlive return ok
        baseY = pos.y

        if isSquashed
            sScale = 1.0 - (squashTimer / squashDuration) * 0.5
            DrawCylinder(Vector3(pos.x, baseY + 0.12, pos.z), radius * 1.3, radius * 1.3, 0.18 * sScale, 14, GOOMBA_BROWN)
            DrawSphere(Vector3(pos.x, baseY + 0.22, pos.z), radius * 0.9, GOOMBA_BROWN)
            return
        ok

        # 3D Directional Vectors
        rad = facingAngle * DEG2RAD
        fwdX = sin(rad)
        fwdZ = cos(rad)
        rgtX = cos(rad)
        rgtZ = -sin(rad)

        # 1. Animated Waddling Feet (Swinging in direction of walk)
        stepOffset = sin(walkTimer) * 0.20
        fLx = pos.x - rgtX * 0.28 + fwdX * stepOffset
        fLz = pos.z - rgtZ * 0.28 + fwdZ * stepOffset
        fRx = pos.x + rgtX * 0.28 - fwdX * stepOffset
        fRz = pos.z + rgtZ * 0.28 - fwdZ * stepOffset
        DrawSphere(Vector3(fLx, baseY + 0.12, fLz), 0.18, GOOMBA_DARK)
        DrawSphere(Vector3(fRx, baseY + 0.12, fRz), 0.18, GOOMBA_DARK)

        # 2. Body / Stem (Light Skin Tone)
        DrawCylinder(Vector3(pos.x, baseY + 0.28, pos.z), 0.32, 0.42, 0.32, 12, MARIO_SKIN)

        # 3. Mushroom Cap Head (Chestnut Brown)
        headY = baseY + 0.65
        DrawSphere(Vector3(pos.x, headY, pos.z), 0.58, GOOMBA_BROWN)
        DrawSphere(Vector3(pos.x, headY + 0.18, pos.z), 0.42, GOOMBA_BROWN)

        # 4. Expressive Eyes & Angry Brows Facing Direction
        eLx = pos.x + fwdX * 0.46 - rgtX * 0.16
        eLz = pos.z + fwdZ * 0.46 - rgtZ * 0.16
        eRx = pos.x + fwdX * 0.46 + rgtX * 0.16
        eRz = pos.z + fwdZ * 0.46 + rgtZ * 0.16
        DrawSphere(Vector3(eLx, headY + 0.08, eLz), 0.10, WHITE)
        DrawSphere(Vector3(eRx, headY + 0.08, eRz), 0.10, WHITE)
        DrawSphere(Vector3(eLx + fwdX * 0.03, headY + 0.08, eLz + fwdZ * 0.03), 0.05, BLACK)
        DrawSphere(Vector3(eRx + fwdX * 0.03, headY + 0.08, eRz + fwdZ * 0.03), 0.05, BLACK)

        # Eyebrows
        DrawCube(Vector3(eLx, headY + 0.20, eLz), 0.20, 0.05, 0.08, BLACK)
        DrawCube(Vector3(eRx, headY + 0.20, eRz), 0.20, 0.05, 0.08, BLACK)

        # Fangs
        DrawSphere(Vector3(pos.x + fwdX * 0.46 - rgtX * 0.12, headY - 0.15, pos.z + fwdZ * 0.46 - rgtZ * 0.12), 0.05, WHITE)
        DrawSphere(Vector3(pos.x + fwdX * 0.46 + rgtX * 0.12, headY - 0.15, pos.z + fwdZ * 0.46 + rgtZ * 0.12), 0.05, WHITE)
    end
end

# -------------------------------------------------------------------
# 2. Green Koopa Troopa (Retractable Shell & Kick Physics)
# -------------------------------------------------------------------
class KoopaEnemy
    pos            = null
    vel            = null
    startPos       = null
    patrolDistance = 0.0
    patrolSpeed    = 0.0
    moveDir        = 1.0
    patrolAxis     = "x"
    facingAngle    = 0.0

    radius         = 0.68
    height         = 1.35

    isAlive        = true
    isShell        = false
    shellSpeed     = 0.0
    shellDirX      = 0.0
    shellDirZ      = 0.0
    shellSpin      = 0.0

    walkTimer      = 0.0

    func init x, y, z, axis, dist, spd
        pos            = Vector3(x, y, z)
        vel            = Vector3(0, 0, 0)
        startPos       = Vector3(x, y, z)
        patrolAxis     = axis
        patrolDistance = dist
        patrolSpeed    = spd
        return self
    end

    func update dt, world
        if !isAlive return ok

        if isShell
            if shellSpeed > 0.5
                pos.x += shellDirX * shellSpeed * dt
                pos.z += shellDirZ * shellSpeed * dt
                shellSpin += shellSpeed * 90.0 * dt
                shellSpeed = max(0.0, shellSpeed - dt * 1.8)

                if pos.x < -35.0 or pos.x > 35.0
                    shellDirX *= -1.0
                ok
                if pos.z < -30.0 or pos.z > 80.0
                    shellDirZ *= -1.0
                ok
            ok
            return
        ok

        walkTimer += dt * 8.0

        if patrolAxis = "x"
            pos.x += moveDir * patrolSpeed * dt
            if moveDir > 0.0
                facingAngle = 90.0
            else
                facingAngle = 270.0
            ok

            if pos.x >= (startPos.x + patrolDistance)
                pos.x = startPos.x + patrolDistance
                moveDir = -1.0
            elseif pos.x <= (startPos.x - patrolDistance)
                pos.x = startPos.x - patrolDistance
                moveDir = 1.0
            ok
        else
            pos.z += moveDir * patrolSpeed * dt
            if moveDir > 0.0
                facingAngle = 0.0
            else
                facingAngle = 180.0
            ok

            if pos.z >= (startPos.z + patrolDistance)
                pos.z = startPos.z + patrolDistance
                moveDir = -1.0
            elseif pos.z <= (startPos.z - patrolDistance)
                pos.z = startPos.z - patrolDistance
                moveDir = 1.0
            ok
        ok
    end

    func squash
        if !isShell
            isShell = true
            shellSpeed = 0.0
            height = 0.8
        else
            isAlive = false
        ok
    end

    func kick dirX, dirZ
        isShell = true
        shellSpeed = 16.5
        shellDirX = dirX
        shellDirZ = dirZ
    end

    func drawDropShadow world
        if !isAlive return ok
        groundY = world.getGroundHeightUnder(pos.x, pos.z, pos.y)
        hDiff = pos.y - groundY
        if hDiff < 0.0 or hDiff > 10.0 return ok
        sFactor = clampVal(1.0 - (hDiff / 8.0), 0.3, 1.0)
        cShadow = RAYLibColor(15, 25, 15, floor(130 * sFactor))
        DrawCylinder(Vector3(pos.x, groundY + 0.05, pos.z), radius * sFactor, radius * sFactor, 0.03, 12, cShadow)
    end

    func draw texMgr
        if !isAlive return ok
        baseY = pos.y

        if isShell
            sRad = 0.58
            DrawSphere(Vector3(pos.x, baseY + 0.45, pos.z), sRad, KOOPA_GREEN)
            DrawSphere(Vector3(pos.x, baseY + 0.52, pos.z), sRad * 0.85, KOOPA_SHELL_DARK)
            DrawCylinder(Vector3(pos.x, baseY + 0.18, pos.z), sRad * 1.05, sRad * 1.05, 0.15, 16, CASTLE_WHITE)
            return
        ok

        rad = facingAngle * DEG2RAD
        fwdX = sin(rad)
        fwdZ = cos(rad)
        rgtX = cos(rad)
        rgtZ = -sin(rad)

        # 1. Koopa Feet (Swinging in direction of walk)
        stepOffset = sin(walkTimer) * 0.22
        fLx = pos.x - rgtX * 0.28 + fwdX * stepOffset
        fLz = pos.z - rgtZ * 0.28 + fwdZ * stepOffset
        fRx = pos.x + rgtX * 0.28 - fwdX * stepOffset
        fRz = pos.z + rgtZ * 0.28 - fwdZ * stepOffset
        DrawSphere(Vector3(fLx, baseY + 0.14, fLz), 0.20, KOOPA_YELLOW)
        DrawSphere(Vector3(fRx, baseY + 0.14, fRz), 0.20, KOOPA_YELLOW)

        # 2. Green Shell Body
        DrawSphere(Vector3(pos.x, baseY + 0.65, pos.z), 0.56, KOOPA_GREEN)
        DrawSphere(Vector3(pos.x - fwdX * 0.12, baseY + 0.70, pos.z - fwdZ * 0.12), 0.48, KOOPA_SHELL_DARK)
        DrawCylinder(Vector3(pos.x, baseY + 0.38, pos.z), 0.62, 0.62, 0.16, 16, CASTLE_WHITE)

        # 3. Yellow Head & Big Snout Facing Movement Direction
        headX = pos.x + fwdX * 0.42
        headZ = pos.z + fwdZ * 0.42
        headY = baseY + 0.95
        DrawSphere(Vector3(headX, headY, headZ), 0.34, KOOPA_YELLOW)
        # Snout / Beak
        DrawSphere(Vector3(headX + fwdX * 0.22, headY - 0.08, headZ + fwdZ * 0.22), 0.22, KOOPA_YELLOW)

        # Eyes
        eLx = headX - rgtX * 0.12 + fwdX * 0.15
        eLz = headZ - rgtZ * 0.12 + fwdZ * 0.15
        eRx = headX + rgtX * 0.12 + fwdX * 0.15
        eRz = headZ + rgtZ * 0.12 + fwdZ * 0.15
        DrawSphere(Vector3(eLx, headY + 0.12, eLz), 0.10, WHITE)
        DrawSphere(Vector3(eRx, headY + 0.12, eRz), 0.10, WHITE)
        DrawSphere(Vector3(eLx + fwdX * 0.05, headY + 0.12, eLz + fwdZ * 0.05), 0.05, BLACK)
        DrawSphere(Vector3(eRx + fwdX * 0.05, headY + 0.12, eRz + fwdZ * 0.05), 0.05, BLACK)
    end
end

# -------------------------------------------------------------------
# 3. Piranha Plant (Warp Pipe Ambush Enemy)
# -------------------------------------------------------------------
class PiranhaPlant
    pos          = null
    baseY        = 0.0
    pipeHeight   = 0.0
    heightOffset = 0.0
    jawAngle     = 0.0
    timer        = 0.0
    isAlive      = true
    isEmerged    = false
    radius       = 0.8
    height       = 1.5

    func init x, y, z, pHeight
        pos        = Vector3(x, y, z)
        baseY      = y
        pipeHeight = pHeight
        return self
    end

    func update dt, mario
        if !isAlive return ok
        timer += dt * 2.2

        marioNear = false
        if mario != null and !mario.isDead
            dx = mario.pos.x - pos.x
            dz = mario.pos.z - pos.z
            dist = sqrt(dx*dx + dz*dz)
            if dist < 2.4 and fabs(mario.pos.y - (baseY + pipeHeight)) < 2.5
                marioNear = true
            ok
        ok

        if marioNear
            heightOffset = lerpVal(heightOffset, 0.0, 6.0 * dt)
            isEmerged = false
        else
            cycle = sin(timer)
            if cycle > 0.1
                heightOffset = lerpVal(heightOffset, 1.6, 5.0 * dt)
                isEmerged = (heightOffset > 0.8)
                jawAngle = fabs(sin(timer * 4.0)) * 24.0
            else
                heightOffset = lerpVal(heightOffset, 0.0, 5.0 * dt)
                isEmerged = false
                jawAngle = 0.0
            ok
        ok

        pos.y = baseY + pipeHeight + heightOffset - 0.4
    end

    func squash
        isAlive = false
    end

    func draw
        if !isAlive or heightOffset < 0.2 return ok

        pY = pos.y

        # 1. Green Stem & Leaves
        DrawCylinder(Vector3(pos.x, pY - 0.5, pos.z), 0.22, 0.22, 0.9, 12, PIPE_GREEN)
        DrawSphere(Vector3(pos.x - 0.35, pY - 0.3, pos.z), 0.28, GRASS_GREEN)
        DrawSphere(Vector3(pos.x + 0.35, pY - 0.3, pos.z), 0.28, GRASS_GREEN)

        # 2. Red Bulbous Head with White Spots
        headR = 0.55
        DrawSphere(Vector3(pos.x, pY + 0.35, pos.z), headR, MARIO_RED)
        DrawSphere(Vector3(pos.x + 0.35, pY + 0.45, pos.z), 0.14, WHITE)
        DrawSphere(Vector3(pos.x - 0.35, pY + 0.45, pos.z), 0.14, WHITE)
        DrawSphere(Vector3(pos.x, pY + 0.70, pos.z), 0.16, WHITE)
        DrawSphere(Vector3(pos.x, pY + 0.45, pos.z - 0.35), 0.14, WHITE)

        # 3. White Snapping Jaws Lips & Teeth
        jawY = pY + 0.35
        DrawCylinder(Vector3(pos.x, jawY, pos.z + 0.42), 0.38, 0.38, 0.12, 12, WHITE)
        DrawSphere(Vector3(pos.x, jawY, pos.z + 0.45), 0.22, BLACK)
        DrawSphere(Vector3(pos.x - 0.14, jawY + 0.12, pos.z + 0.48), 0.07, WHITE)
        DrawSphere(Vector3(pos.x + 0.14, jawY + 0.12, pos.z + 0.48), 0.07, WHITE)
        DrawSphere(Vector3(pos.x - 0.14, jawY - 0.12, pos.z + 0.48), 0.07, WHITE)
        DrawSphere(Vector3(pos.x + 0.14, jawY - 0.12, pos.z + 0.48), 0.07, WHITE)
    end
end

# -------------------------------------------------------------------
# 4. Thwomp Enemy (Slamming Trap Stone)
# -------------------------------------------------------------------
class ThwompEnemy
    pos           = null
    startY        = 0.0
    targetGroundY = 0.0
    state         = 0
    restTimer     = 0.0
    radius        = 1.5
    height        = 2.2

    func init x, y, z, groundY
        pos           = Vector3(x, y, z)
        startY        = y
        targetGroundY = groundY
        return self
    end

    func update dt, mario, particles, audio
        if state = 0
            pos.y = startY + sin(GetTime() * 2.0) * 0.15
            if mario != null and !mario.isDead
                dx = mario.pos.x - pos.x
                dz = mario.pos.z - pos.z
                dist = sqrt(dx*dx + dz*dz)
                if dist < 3.2 and mario.pos.y <= pos.y
                    state = 1
                ok
            ok
        elseif state = 1
            pos.y -= 26.0 * dt
            if pos.y <= targetGroundY + height / 2.0
                pos.y = targetGroundY + height / 2.0
                state = 2
                restTimer = 1.25
                if audio != null audio.playQuake() ok
                if particles != null
                    particles.spawnShockwave(pos.x, targetGroundY + 0.1, pos.z, 5.0)
                    particles.spawnDust(pos.x, targetGroundY + 0.1, pos.z, 25)
                ok
            ok
        elseif state = 2
            restTimer -= dt
            if restTimer <= 0.0
                state = 3
            ok
        elseif state = 3
            pos.y += 3.8 * dt
            if pos.y >= startY
                pos.y = startY
                state = 0
            ok
        ok
    end

    func drawDropShadow world
        hDiff = pos.y - targetGroundY
        sFactor = clampVal(1.0 - (hDiff / 12.0), 0.25, 1.0)
        cShadow = RAYLibColor(20, 20, 25, floor(160 * sFactor))
        DrawCube(Vector3(pos.x, targetGroundY + 0.05, pos.z), 2.8 * sFactor, 0.04, 2.8 * sFactor, cShadow)
    end

    func draw
        thwompCol = RAYLibColor(70, 95, 125, 255)
        thwompDark = RAYLibColor(45, 60, 85, 255)
        DrawCube(pos, 2.4, height, 2.4, thwompCol)
        DrawCubeWires(pos, 2.4, height, 2.4, thwompDark)

        for sp = -1 to 1 step 2
            DrawCylinder(Vector3(pos.x + sp * 1.35, pos.y, pos.z), 0.05, 0.35, 0.6, 6, CASTLE_WHITE)
            DrawCylinder(Vector3(pos.x, pos.y, pos.z + sp * 1.35), 0.05, 0.35, 0.6, 6, CASTLE_WHITE)
        next

        fwdZ = 1.25
        eyeCol = MARIO_RED
        if state = 0 eyeCol = MARIO_YELLOW ok
        DrawCube(Vector3(pos.x - 0.45, pos.y + 0.25, pos.z + fwdZ), 0.35, 0.35, 0.08, WHITE)
        DrawCube(Vector3(pos.x + 0.45, pos.y + 0.25, pos.z + fwdZ), 0.35, 0.35, 0.08, WHITE)
        DrawCube(Vector3(pos.x - 0.45, pos.y + 0.25, pos.z + fwdZ + 0.02), 0.18, 0.18, 0.08, eyeCol)
        DrawCube(Vector3(pos.x + 0.45, pos.y + 0.25, pos.z + fwdZ + 0.02), 0.18, 0.18, 0.08, eyeCol)

        DrawCube(Vector3(pos.x - 0.45, pos.y + 0.55, pos.z + fwdZ + 0.02), 0.55, 0.14, 0.12, thwompDark)
        DrawCube(Vector3(pos.x + 0.45, pos.y + 0.55, pos.z + fwdZ + 0.02), 0.55, 0.14, 0.12, thwompDark)

        DrawCube(Vector3(pos.x, pos.y - 0.45, pos.z + fwdZ), 1.2, 0.35, 0.06, BLACK)
        DrawCube(Vector3(pos.x - 0.3, pos.y - 0.40, pos.z + fwdZ + 0.02), 0.18, 0.18, 0.08, WHITE)
        DrawCube(Vector3(pos.x + 0.3, pos.y - 0.40, pos.z + fwdZ + 0.02), 0.18, 0.18, 0.08, WHITE)
    end
end

# -------------------------------------------------------------------
# 5. Master Enemy Manager (Multi-Level Spawning)
# -------------------------------------------------------------------
class EnemyManager
    goombas     = []
    koopas      = []
    piranhas    = []
    thwomps     = []
    stompCombo  = 0
    comboTimer  = 0.0
    currentLevel = 1

    func init
        reset(1)
    end

    func reset levelNum
        goombas     = []
        koopas      = []
        piranhas    = []
        thwomps     = []
        stompCombo  = 0
        comboTimer  = 0.0
        currentLevel = levelNum
        spawnLevelEnemies(levelNum)
    end

    func spawnLevelEnemies levelNum
        if levelNum = 1
            # Level 1: Mushroom Meadow
            addGoomba(6.0, 0.0, 4.0, "x", 6.0, 3.5)
            addGoomba(-5.0, 0.0, -8.0, "z", 6.0, 3.2)
            addKoopa(8.0, 0.0, -18.0, "x", 7.0, 3.4)

            addGoomba(0.0, 1.0, 28.0, "x", 5.5, 3.2)
            addKoopa(-4.0, 1.0, 44.0, "z", 5.0, 3.0)

            addGoomba(-10.0, 8.0, 58.0, "x", 3.0, 2.8)
            addGoomba(-6.0, 10.5, 68.0, "x", 4.0, 3.4)
            addKoopa(6.0, 10.5, 68.0, "x", 4.0, 3.2)

            addPiranha(6.0, 3.0, 42.0, 2.6)

        elseif levelNum = 2
            # Level 2: Bowser's Lava Keep
            addGoomba(-6.0, 0.0, 6.0, "x", 3.5, 3.2)
            addGoomba(6.0, 0.0, 6.0, "x", 3.5, 3.2)
            addKoopa(0.0, 0.0, 18.0, "x", 4.0, 3.2)

            addThwomp(0.0, 7.5, 26.0, 0.0)
            addThwomp(-6.0, 8.5, 42.0, 1.5)
            addThwomp(6.0, 8.5, 42.0, 1.5)

            addGoomba(0.0, 5.0, 52.0, "x", 4.5, 3.5)
            addKoopa(-5.0, 5.0, 60.0, "z", 4.0, 3.2)
            addKoopa(5.0, 5.0, 60.0, "z", 4.0, 3.2)

            addThwomp(0.0, 11.0, 70.0, 4.0)

        elseif levelNum = 3
            # Level 3: Sky Cloud Summit
            addGoomba(0.0, 0.0, 8.0, "x", 5.0, 3.5)
            addKoopa(-6.0, 0.0, 12.0, "z", 4.0, 3.2)

            addPiranha(0.0, 3.0, 24.0, 2.5)
            addGoomba(-8.0, 5.0, 38.0, "x", 3.5, 3.5)
            addGoomba(8.0, 5.0, 38.0, "x", 3.5, 3.5)

            addThwomp(0.0, 11.5, 48.0, 5.5)

            addKoopa(0.0, 9.0, 60.0, "x", 4.0, 3.2)
            addGoomba(-4.0, 12.0, 72.0, "x", 4.0, 3.5)
            addGoomba(4.0, 12.0, 72.0, "x", 4.0, 3.5)
        ok
    end

    func addGoomba x, y, z, axis, dist, spd
        g = new GoombaEnemy(x, y, z, axis, dist, spd)
        goombas + g
    end

    func addKoopa x, y, z, axis, dist, spd
        k = new KoopaEnemy(x, y, z, axis, dist, spd)
        koopas + k
    end

    func addPiranha x, y, z, pHeight
        p = new PiranhaPlant(x, y, z, pHeight)
        piranhas + p
    end

    func addThwomp x, y, z, groundY
        t = new ThwompEnemy(x, y, z, groundY)
        thwomps + t
    end

    func update dt, mario, particles, audio, world
        if comboTimer > 0
            comboTimer -= dt
            if comboTimer <= 0
                stompCombo = 0
            ok
        ok

        # 1. Update Goombas Directly in List
        for i = 1 to len(goombas)
            if !goombas[i].isAlive loop ok
            goombas[i].update(dt, mario)

            if !goombas[i].isSquashed
                checkGoombaInteraction(i, mario, particles, audio)
            ok
        next

        # 2. Update Koopas Directly in List
        for i = 1 to len(koopas)
            if !koopas[i].isAlive loop ok
            koopas[i].update(dt, world)

            checkKoopaInteraction(i, mario, particles, audio)
        next

        # 3. Update Piranha Plants Directly in List
        for i = 1 to len(piranhas)
            if !piranhas[i].isAlive loop ok
            piranhas[i].update(dt, mario)

            if piranhas[i].isEmerged
                checkPiranhaInteraction(i, mario, particles, audio)
            ok
        next

        # 4. Update Thwomps Directly in List
        for i = 1 to len(thwomps)
            thwomps[i].update(dt, mario, particles, audio)
            checkThwompInteraction(i, mario, particles, audio)
        next

        # 5. Rolling Shell vs Enemies
        for ki = 1 to len(koopas)
            if koopas[ki].isAlive and koopas[ki].isShell and koopas[ki].shellSpeed > 2.0
                for gi = 1 to len(goombas)
                    if goombas[gi].isAlive and !goombas[gi].isSquashed
                        d = getDistance3D(koopas[ki].pos, goombas[gi].pos)
                        if d < (koopas[ki].radius + goombas[gi].radius)
                            goombas[gi].squash()
                            if audio != NULL audio.playStomp() ok
                            if particles != NULL particles.spawnCoinSparkles(goombas[gi].pos.x, goombas[gi].pos.y + 0.5, goombas[gi].pos.z, 10) ok
                        ok
                    ok
                next
                for pi = 1 to len(piranhas)
                    if piranhas[pi].isAlive and piranhas[pi].isEmerged
                        d = getDistance3D(koopas[ki].pos, piranhas[pi].pos)
                        if d < (koopas[ki].radius + piranhas[pi].radius)
                            piranhas[pi].squash()
                            if audio != NULL audio.playStomp() ok
                            if particles != NULL particles.spawnCoinSparkles(piranhas[pi].pos.x, piranhas[pi].pos.y + 0.5, piranhas[pi].pos.z, 12) ok
                        ok
                    ok
                next
            ok
        next
    end

    func checkGoombaInteraction gi, mario, particles, audio
        if mario.isDead return ok
        g = goombas[gi]
        dx = mario.pos.x - g.pos.x
        dz = mario.pos.z - g.pos.z
        distXZ = sqrt(dx*dx + dz*dz)

        if distXZ < (mario.radius + g.radius)
            if mario.starmanTimer > 0.0
                goombas[gi].squash()
                if audio != NULL audio.playStomp() ok
                if particles != NULL particles.spawnCoinSparkles(g.pos.x, g.pos.y + 0.6, g.pos.z, 14) ok
                mario.score += 500
                return
            ok

            marioBottom = mario.pos.y

            if (mario.vel.y < 0 or mario.isGroundPounding = 2) and (marioBottom >= g.pos.y + 0.30)
                goombas[gi].squash()
                if audio != NULL audio.playStomp() ok

                mario.vel.y = MARIO_JUMP_FORCE * 1.05
                mario.isOnGround = false
                mario.isGrounded = false
                mario.jumpCount = 2
                mario.doubleJumpGrace = 0.40

                stompCombo++
                comboTimer = 2.0
                mario.score += (100 * stompCombo)
                mario.coins += 1

                if particles != NULL
                    particles.spawnCoinSparkles(g.pos.x, g.pos.y + 0.6, g.pos.z, 14)
                    particles.spawnDust(g.pos.x, g.pos.y, g.pos.z, 10)
                ok
                return
            ok

            if fabs(marioBottom - g.pos.y) < g.height
                if mario.invulnTimer <= 0
                    mario.takeDamage(1)
                    if particles != NULL particles.spawnDust(mario.pos.x, mario.pos.y + 0.8, mario.pos.z, 8) ok
                ok
            ok
        ok
    end

    func checkKoopaInteraction ki, mario, particles, audio
        if mario.isDead return ok
        k = koopas[ki]
        dx = mario.pos.x - k.pos.x
        dz = mario.pos.z - k.pos.z
        distXZ = sqrt(dx*dx + dz*dz)

        if distXZ < (mario.radius + k.radius)
            if mario.starmanTimer > 0.0
                koopas[ki].squash()
                if audio != NULL audio.playStomp() ok
                return
            ok

            if k.isShell and k.shellSpeed < 0.5
                kDirX = 1.0
                kDirZ = 0.0
                if distXZ > 0.01
                    kDirX = -dx / distXZ
                    kDirZ = -dz / distXZ
                ok
                koopas[ki].kick(kDirX, kDirZ)
                if audio != NULL audio.playKick() ok
                if particles != NULL particles.spawnDust(k.pos.x, k.pos.y, k.pos.z, 8) ok
                mario.score += 400
                return
            ok

            if !k.isShell
                marioBottom = mario.pos.y
                if (mario.vel.y < 0 or mario.isGroundPounding = 2) and (marioBottom >= k.pos.y + 0.30)
                    koopas[ki].squash()
                    if audio != NULL audio.playStomp() ok

                    mario.vel.y = MARIO_JUMP_FORCE * 1.05
                    mario.isOnGround = false
                    mario.isGrounded = false
                    mario.jumpCount = 2
                    mario.doubleJumpGrace = 0.40

                    stompCombo++
                    comboTimer = 2.0
                    mario.score += (100 * stompCombo)
                    mario.coins += 1

                    if particles != NULL
                        particles.spawnCoinSparkles(k.pos.x, k.pos.y + 0.6, k.pos.z, 14)
                        particles.spawnDust(k.pos.x, k.pos.y, k.pos.z, 10)
                    ok
                    return
                ok

                if fabs(marioBottom - k.pos.y) < k.height
                    if mario.invulnTimer <= 0
                        mario.takeDamage(1)
                        if particles != NULL particles.spawnDust(mario.pos.x, mario.pos.y + 0.8, mario.pos.z, 8) ok
                    ok
                ok
            elseif k.shellSpeed > 1.0 and mario.invulnTimer <= 0
                mario.takeDamage(1)
            ok
        ok
    end

    func checkPiranhaInteraction pi, mario, particles, audio
        if mario.isDead or !piranhas[pi].isAlive return ok
        p = piranhas[pi]
        dx = mario.pos.x - p.pos.x
        dz = mario.pos.z - p.pos.z
        dy = fabs(mario.pos.y - p.pos.y)
        dist = sqrt(dx*dx + dz*dz)

        if dist < (mario.radius + p.radius) and dy < 1.4
            if mario.starmanTimer > 0.0
                piranhas[pi].squash()
                if audio != NULL audio.playStomp() ok
                if particles != NULL particles.spawnCoinSparkles(p.pos.x, p.pos.y + 0.6, p.pos.z, 14) ok
                mario.score += 600
                return
            ok
            if mario.invulnTimer <= 0
                mario.takeDamage(1)
            ok
        ok
    end

    func checkThwompInteraction ti, mario, particles, audio
        if mario.isDead return ok
        t = thwomps[ti]
        dx = mario.pos.x - t.pos.x
        dz = mario.pos.z - t.pos.z
        dy = fabs(mario.pos.y - t.pos.y)
        distXZ = sqrt(dx*dx + dz*dz)

        if distXZ < (mario.radius + t.radius) and dy < (t.height / 2.0 + 0.6)
            if t.state = 1
                if mario.invulnTimer <= 0
                    mario.takeDamage(2)
                ok
            elseif mario.pos.y > t.pos.y + t.height / 2.0 - 0.2
                mario.pos.y = t.pos.y + t.height / 2.0
                mario.vel.y = 0.0
                mario.isOnGround = true
                mario.isGrounded = true
            elseif mario.invulnTimer <= 0
                mario.takeDamage(1)
            ok
        ok
    end

    func triggerGroundPound marioPos, mario, particles, audio
        for i = 1 to len(goombas)
            if goombas[i].isAlive and !goombas[i].isSquashed
                d = getDistance3D(marioPos, goombas[i].pos)
                if d < 4.2
                    goombas[i].squash()
                    if audio != NULL audio.playStomp() ok
                    if particles != NULL particles.spawnCoinSparkles(goombas[i].pos.x, goombas[i].pos.y + 0.6, goombas[i].pos.z, 12) ok
                    mario.score += 300
                ok
            ok
        next

        for i = 1 to len(koopas)
            if koopas[i].isAlive
                d = getDistance3D(marioPos, koopas[i].pos)
                if d < 4.2
                    koopas[i].squash()
                    if audio != NULL audio.playStomp() ok
                    if particles != NULL particles.spawnDust(koopas[i].pos.x, koopas[i].pos.y, koopas[i].pos.z, 10) ok
                ok
            ok
        next

        for i = 1 to len(piranhas)
            if piranhas[i].isAlive and piranhas[i].isEmerged
                d = getDistance3D(marioPos, piranhas[i].pos)
                if d < 4.5
                    piranhas[i].squash()
                    if audio != NULL audio.playStomp() ok
                    if particles != NULL particles.spawnCoinSparkles(piranhas[i].pos.x, piranhas[i].pos.y + 0.6, piranhas[i].pos.z, 14) ok
                    mario.score += 400
                ok
            ok
        next
    end

    func drawDropShadows world
        for i = 1 to len(goombas) goombas[i].drawDropShadow(world) next
        for i = 1 to len(koopas) koopas[i].drawDropShadow(world) next
        for i = 1 to len(thwomps) thwomps[i].drawDropShadow(world) next
    end

    func draw texMgr
        for i = 1 to len(goombas) goombas[i].draw() next
        for i = 1 to len(koopas) koopas[i].draw(texMgr) next
        for i = 1 to len(piranhas) piranhas[i].draw() next
        for i = 1 to len(thwomps) thwomps[i].draw() next
    end
end
