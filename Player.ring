#===================================================================#
# Mario 3D - Mario Player Character Controller & Procedural Rig
# 360° Kinematics, Triple Jump, Ground Pound, Power-ups & Drop Shadow
#===================================================================#

class MarioPlayer
    pos
    vel
    facingAngle         # Angle in degrees (0 = +Z, 90 = +X, etc.)
    targetAngle
    isOnGround
    isGrounded
    isJumping
    jumpHoldTimer
    jumpCount           # 1 = single jump, 2 = double leap, 3 = triple somersault
    doubleJumpGrace     # Window to trigger next jump combo
    runCycle            # Phase accumulator for limb swinging
    moveSpeed           # Current horizontal planar speed
    isSkidding
    isDead
    score

    # Gameplay Attributes & Power-ups
    health
    maxHealth
    coins
    lives
    stars
    hasStar
    isSuper             # Super Mushroom scale & toughness
    scaleMultiplier     # Target scale multiplier (1.0 or 1.45)
    currentScale        # Smoothed animated scale
    starmanTimer        # Invincibility Star timer
    invulnTimer
    deathTimer
    radius
    flipAngle           # Somersault spin accumulator for double/triple jumps
    blinkTimer          # Periodic eye blink accumulator
    audioRef

    # Advanced Kinematics (Ground Pound, Squash & Stretch, Pipe Warping)
    isGroundPounding    # 0 = none, 1 = air flip pause, 2 = downward slam
    groundPoundTimer
    squashY
    squashXZ
    checkpointPos       # Respawn location

    # Pipe Warping State
    isWarping           # 0 = none, 1 = entering down, 2 = exiting up
    warpTimer
    warpDestPos

    func init startPos
        pos             = Vector3(startPos.x, startPos.y, startPos.z)
        vel             = Vector3(0.0, 0.0, 0.0)
        facingAngle     = 0.0
        targetAngle     = 0.0
        isOnGround      = false
        isGrounded      = false
        isJumping       = false
        jumpHoldTimer   = 0.0
        jumpCount       = 1
        doubleJumpGrace = 0.0
        runCycle        = 0.0
        moveSpeed       = 0.0
        isSkidding      = false
        isDead          = false
        hasStar         = false
        score           = 0

        health          = 3
        maxHealth       = 3
        coins           = 0
        lives           = 3
        stars           = 0
        isSuper         = false
        scaleMultiplier = 1.0
        currentScale    = 1.0
        starmanTimer    = 0.0
        invulnTimer     = 0.0
        deathTimer      = 0.0
        radius          = 0.55

        flipAngle       = 0.0
        blinkTimer      = 0.0
        audioRef        = null

        isGroundPounding = 0
        groundPoundTimer = 0.0
        squashY         = 1.0
        squashXZ        = 1.0
        checkpointPos   = Vector3(startPos.x, startPos.y, startPos.z)

        isWarping       = 0
        warpTimer       = 0.0
        warpDestPos     = Vector3(0, 0, 0)

        return self
    end

    func update dt, cam, world, enemies, particles, audio
        if audio != NULL audioRef = audio ok

        # 0. Death Animation
        if deathTimer > 0.0
            deathTimer -= dt
            pos.y += vel.y * dt
            vel.y -= GRAVITY_ACCEL * dt
            return
        ok

        # Invulnerability & Starman Timers
        if invulnTimer > 0.0 invulnTimer -= dt ok
        if starmanTimer > 0.0
            starmanTimer -= dt
            if particles != NULL and random(10) > 4
                particles.spawnCoinSparkles(pos.x, pos.y + 0.8, pos.z, 3)
            ok
        ok

        # Smooth scale interpolation (Super Mushroom growth)
        currentScale = lerpVal(currentScale, scaleMultiplier, 8.0 * dt)
        radius = 0.55 * currentScale

        # Squash & Stretch recovery
        squashY  = lerpVal(squashY,  1.0, 9.0 * dt)
        squashXZ = lerpVal(squashXZ, 1.0, 9.0 * dt)

        # -----------------------------------------------------------
        # Pipe Warping Animation Handling
        # -----------------------------------------------------------
        if isWarping > 0
            warpTimer += dt
            if isWarping = 1 # Descending into pipe
                pos.y -= 2.0 * dt
                if warpTimer >= 0.75
                    isWarping = 2
                    warpTimer = 0.0
                    pos.x = warpDestPos.x
                    pos.y = warpDestPos.y - 1.5
                    pos.z = warpDestPos.z
                    vel.x = 0.0
                    vel.y = 0.0
                    vel.z = 0.0
                ok
            elseif isWarping = 2 # Ascending out of destination pipe
                pos.y += 2.0 * dt
                if warpTimer >= 0.75
                    isWarping = 0
                    warpTimer = 0.0
                    isOnGround = true
                ok
            ok
            return
        ok

        # -----------------------------------------------------------
        # 1. Ground Pound Handling
        # -----------------------------------------------------------
        gpPressed = (IsKeyPressed(KEY_LEFT_CONTROL) or IsKeyPressed(KEY_RIGHT_CONTROL) or IsKeyPressed(KEY_C)) and !isOnGround
        if gpPressed and isGroundPounding = 0 and !isOnGround
            isGroundPounding = 1
            groundPoundTimer = 0.22
            vel.x = 0.0
            vel.z = 0.0
            vel.y = 0.0
            if audioRef != NULL audioRef.playGroundPound() ok
        ok

        if isGroundPounding = 1 # Mid-air pause flip
            groundPoundTimer -= dt
            flipAngle += 1400.0 * dt
            if groundPoundTimer <= 0.0
                isGroundPounding = 2
                vel.y = -MARIO_GROUND_POUND_SPD
            ok
            return
        ok

        # -----------------------------------------------------------
        # 2. Camera-Relative Directional Input
        # -----------------------------------------------------------
        inputX = 0.0
        inputZ = 0.0

        if isGroundPounding = 0
            camFwd = cam.getForwardVector()
            camRgt = cam.getRightVector()

            # Forward (W on QWERTY, Z on AZERTY, Up Arrow)
            if IsKeyDown(KEY_W) or IsKeyDown(KEY_Z) //or IsKeyDown(KEY_UP)
                inputX += camFwd[1]
                inputZ += camFwd[2]
            ok
            # Backward (S, Down Arrow)
            if IsKeyDown(KEY_S) //or IsKeyDown(KEY_DOWN)
                inputX -= camFwd[1]
                inputZ -= camFwd[2]
            ok
            # Right (D, Right Arrow)
            if IsKeyDown(KEY_D) //or IsKeyDown(KEY_RIGHT)
                inputX -= camRgt[1]
                inputZ -= camRgt[2]
            ok
            # Left (Q on AZERTY, A on QWERTY, Left Arrow)
            if IsKeyDown(KEY_A) or IsKeyDown(KEY_Q) //or IsKeyDown(KEY_LEFT)
                inputX += camRgt[1]
                inputZ += camRgt[2]
            ok

            # Pipe warp entry check (press S or Down on top of pipe)
            if isOnGround and (IsKeyPressed(KEY_S) or IsKeyPressed(KEY_DOWN))
                pipeWarp = world.checkPipeWarp(pos)
                if pipeWarp[1]
                    isWarping = 1
                    warpTimer = 0.0
                    warpDestPos = Vector3(pipeWarp[2], pipeWarp[3], pipeWarp[4])
                    if audioRef != NULL audioRef.playPipe() ok
                    return
                ok
            ok
        ok

        inputLen = sqrt(inputX * inputX + inputZ * inputZ)
        hasInput = (inputLen > 0.1)
        if hasInput
            inputX /= inputLen
            inputZ /= inputLen
        ok

        # Sprint / Run speed check (Shift key or [X] key)
        isRunning = IsKeyDown(KEY_LEFT_SHIFT) or IsKeyDown(KEY_RIGHT_SHIFT) or IsKeyDown(KEY_X)
        targetMaxSpeed = MARIO_WALK_SPEED
        if isRunning targetMaxSpeed = MARIO_RUN_SPEED ok
        if starmanTimer > 0.0 targetMaxSpeed *= 1.35 ok

        # Horizontal Acceleration & Friction
        accelRate = MARIO_ACCEL
        if not isOnGround accelRate *= MARIO_AIR_CONTROL ok

        if hasInput and isGroundPounding = 0
            vel.x += inputX * accelRate * dt
            vel.z += inputZ * accelRate * dt

            # Target heading angle from movement vector
            targetAngle = atan2(inputX, inputZ) * RAD2DEG

            # Turn rate towards desired movement angle
            angDiff = targetAngle - facingAngle
            while angDiff > 180.0  angDiff -= 360.0 end
            while angDiff < -180.0 angDiff += 360.0 end
            facingAngle += angDiff * 14.0 * dt

            # Skidding check
            hSpeed = sqrt(vel.x * vel.x + vel.z * vel.z)
            if isOnGround and hSpeed > 6.0 and fabs(angDiff) > 110.0
                isSkidding = true
                if audioRef != NULL audioRef.playSkid() ok
            else
                isSkidding = false
            ok
        else
            isSkidding = false
            if isOnGround and isGroundPounding = 0
                frictionFactor = max(0.0, 1.0 - MARIO_FRICTION * dt)
                vel.x *= frictionFactor
                vel.z *= frictionFactor
            ok
        ok

        curHSpeed = sqrt(vel.x * vel.x + vel.z * vel.z)
        if curHSpeed > targetMaxSpeed
            scaleS = targetMaxSpeed / curHSpeed
            vel.x *= scaleS
            vel.z *= scaleS
        ok
        moveSpeed = curHSpeed

        # -----------------------------------------------------------
        # 3. Jump Physics & Acrobatic Triple Jump
        # -----------------------------------------------------------
        if doubleJumpGrace > 0.0 doubleJumpGrace -= dt ok

        jumpPressed = IsKeyPressed(KEY_SPACE) or IsKeyPressed(KEY_J) or IsKeyPressed(KEY_K)
        jumpHeld    = IsKeyDown(KEY_SPACE)    or IsKeyDown(KEY_J)    or IsKeyDown(KEY_K)

        if jumpPressed and isOnGround and isGroundPounding = 0
            isJumping     = true
            isOnGround    = false
            isGrounded    = false
            jumpHoldTimer = 0.0

            # Jump Stretch VFX
            squashY  = 1.30
            squashXZ = 0.82

            if doubleJumpGrace > 0.0 and jumpCount = 1 and moveSpeed > 3.0
                # Second Jump (Higher)
                jumpCount = 2
                vel.y = MARIO_DOUBLE_JUMP
                doubleJumpGrace = 0.40
                if audioRef != NULL audioRef.playDoubleJump() ok
            elseif doubleJumpGrace > 0.0 and jumpCount = 2 and moveSpeed > 4.5
                # Acrobatic Triple Jump! (Somersault + Max Height)
                jumpCount = 3
                vel.y = MARIO_TRIPLE_JUMP
                doubleJumpGrace = 0.0
                if audioRef != NULL audioRef.playTripleJump() ok
            else
                # Standard Jump
                jumpCount = 1
                vel.y = MARIO_JUMP_FORCE
                doubleJumpGrace = 0.38
                if audioRef != NULL audioRef.playJump() ok
            ok
        ok

        if isJumping and jumpHeld and jumpHoldTimer < 0.22 and isGroundPounding = 0
            jumpHoldTimer += dt
            vel.y += 12.0 * dt
        ok

        # -----------------------------------------------------------
        # 4. Gravity & Terminal Velocity
        # -----------------------------------------------------------
        if isGroundPounding != 2
            vel.y -= GRAVITY_ACCEL * dt
            if vel.y < -TERMINAL_VELOCITY vel.y = -TERMINAL_VELOCITY ok
        ok

        # -----------------------------------------------------------
        # 5. Tentative Position Step & World Collision
        # -----------------------------------------------------------
        newX = pos.x + vel.x * dt
        newY = pos.y + vel.y * dt
        newZ = pos.z + vel.z * dt

        collisionResult = world.resolveMarioCollision(pos, newX, newY, newZ, vel, currentScale, isSuper)
        pos.x      = collisionResult[1]
        pos.y      = collisionResult[2]
        pos.z      = collisionResult[3]
        vel.x      = collisionResult[4]
        vel.y      = collisionResult[5]
        vel.z      = collisionResult[6]
        wasGrounded = isOnGround
        isOnGround = collisionResult[7]
        isGrounded = isOnGround

        # Check Ground Pound Impact
        if isGroundPounding = 2 and isOnGround
            isGroundPounding = 0
            squashY  = 0.55
            squashXZ = 1.45
            if audioRef != NULL audioRef.playQuake() ok
            if particles != NULL
                particles.spawnDust(pos.x, pos.y + 0.1, pos.z, 22)
                particles.spawnShockwave(pos.x, pos.y + 0.08, pos.z, 4.5)
            ok
            # Smash nearby enemies & blocks
            world.triggerGroundPound(pos)
            enemies.triggerGroundPound(pos, self, particles, audioRef)
        elseif isOnGround
            isJumping = false
            if not wasGrounded and vel.y <= 0.0
                # Landing Squash
                squashY  = 0.78
                squashXZ = 1.22
                if particles != NULL particles.spawnDust(pos.x, pos.y + 0.1, pos.z, 6) ok
            ok
        ok

        # -----------------------------------------------------------
        # 6. Animation Accumulators
        # -----------------------------------------------------------
        if isOnGround
            runCycle += moveSpeed * 2.4 * dt
            flipAngle = 0.0
        else
            runCycle = lerpVal(runCycle, 0.0, 5.0 * dt)
            if jumpCount = 2
                flipAngle += 750.0 * dt
            elseif jumpCount = 3
                flipAngle += 1150.0 * dt
            else
                flipAngle = 0.0
            ok
        ok

        # Eye Blink Timer
        blinkTimer += dt
        if blinkTimer > 4.5 blinkTimer = 0.0 ok

        # Skid Dust Particles
        if isSkidding and particles != null
            particles.addParticle(pos.x, pos.y + 0.15, pos.z, (random(40) - 20) * 0.05, 0.9, (random(40) - 20) * 0.05, 0.35, 0.22, RAYLibColor(225, 215, 200, 180))
        ok

        # Fall into Abyss
        if pos.y < WORLD_DEATH_Y
            takeDamage(3)
        ok
    end

    func addCoins count
        coins += count
        if coins >= 100
            coins -= 100
            lives += 1
        ok
    end

    func powerUpSuper
        if !isSuper
            isSuper = true
            scaleMultiplier = 1.45
            maxHealth = 4
            health = 4
            squashY = 1.5
            if audioRef != NULL audioRef.playPowerUp() ok
        ok
    end

    func powerUpStar
        starmanTimer = 12.0
        invulnTimer  = 12.0
        if audioRef != NULL audioRef.playClear() ok
    end

    func powerUpStarman
        powerUpStar()
    end

    func setCheckpoint cpPos
        checkpointPos.x = cpPos.x
        checkpointPos.y = cpPos.y
        checkpointPos.z = cpPos.z
        if audioRef != NULL audioRef.playCheckpoint() ok
    end

    func takeDamage amount
        if invulnTimer > 0.0 or starmanTimer > 0.0 return ok

        # If Super, shrink back down instead of losing heavy health
        if isSuper
            isSuper = false
            scaleMultiplier = 1.0
            maxHealth = 3
            health = 3
            invulnTimer = 2.5
            squashY = 0.6
            if audioRef != NULL audioRef.playPowerDown() ok
            return
        ok

        health -= amount
        invulnTimer = 2.0
        if audioRef != NULL audioRef.playDamage() ok
        if health <= 0
            health = 0
            lives -= 1
            if lives <= 0 isDead = true ok
            deathTimer = 2.5
            vel.y = 14.0
            vel.x = 0.0
            vel.z = 0.0
        else
            vel.y = 8.5
            vel.x = -sin(facingAngle * DEG2RAD) * 5.0
            vel.z = -cos(facingAngle * DEG2RAD) * 5.0
        ok
    end

    func respawn spawnPos
        pos.x = spawnPos.x
        pos.y = spawnPos.y
        pos.z = spawnPos.z
        vel.x = 0.0
        vel.y = 0.0
        vel.z = 0.0
        health = maxHealth
        deathTimer = 0.0
        invulnTimer = 2.0
        isDead = false
        isGroundPounding = 0
        isWarping = 0
    end

    # ---------------------------------------------------------------
    # Dynamic Drop Shadow Rendering (Crucial for 3D platformers)
    # ---------------------------------------------------------------
    func drawDropShadow world
        if isDead or deathTimer > 0.0 return ok

        groundY = world.getGroundHeightUnder(pos.x, pos.z, pos.y)
        heightDiff = pos.y - groundY
        if heightDiff < 0.0 or heightDiff > 25.0 return ok

        # Shadow size & opacity scale with distance
        sFactor = clampVal(1.0 - (heightDiff / 16.0), 0.25, 1.0)
        sRad = 0.75 * currentScale * sFactor
        sAlpha = floor(140 * sFactor)
        cShadow = RAYLibColor(15, 25, 15, sAlpha)

        # Flat shadow disc on ground
        DrawCylinder(Vector3(pos.x, groundY + 0.05, pos.z), sRad, sRad, 0.03, 16, cShadow)
    end

    # ---------------------------------------------------------------
    # Master Procedural 3D Super Mario Character Rig
    # High-Fidelity Geometry, Squash & Stretch, Starman Glow & Somersaults
    # ---------------------------------------------------------------
    func draw
        if invulnTimer > 0.0 and starmanTimer <= 0.0
            if (floor(GetTime() * 18.0) % 2) = 0
                return
            ok
        ok

        s = 0.92 * currentScale
        yawRad = facingAngle * DEG2RAD
        sinY = sin(yawRad)
        cosY = cos(yawRad)

        fwdX = sinY
        fwdZ = cosY
        rgtX = cosY
        rgtZ = -sinY

        marioX = pos.x
        marioY = pos.y
        marioZ = pos.z

        # Starman Rainbow Shimmer Color Palette
        colShirt = MARIO_RED
        colOveralls = MARIO_BLUE
        if starmanTimer > 0.0
            rainbowStep = floor(GetTime() * 12.0) % 5
            if rainbowStep = 0
                colShirt = MARIO_YELLOW
                colOveralls = MARIO_RED
            elseif rainbowStep = 1
                colShirt = GRASS_LIGHT
                colOveralls = MARIO_YELLOW
            elseif rainbowStep = 2
                colShirt = SKY_BLUE
                colOveralls = GRASS_LIGHT
            elseif rainbowStep = 3
                colShirt = MARIO_WHITE
                colOveralls = MARIO_RED
            else
                colShirt = MARIO_RED
                colOveralls = MARIO_BLUE
            ok
        ok

        # Kinematic Walk Bob & Limb Oscillators
        swingL = sin(runCycle) * 38.0
        swingR = -swingL
        bobY   = fabs(sin(runCycle)) * 0.08 * s
        pitchX = (moveSpeed / MARIO_RUN_SPEED) * 12.0

        isFlipping = (jumpCount >= 2 and not isOnGround) or (isGroundPounding = 1)
        cosF = cos(flipAngle * DEG2RAD)
        sinF = sin(flipAngle * DEG2RAD)
        centerY = marioY + 1.0 * s
        mBaseY  = marioY

        # 1. Boots & Soles
        footOff = 0.26 * s * squashXZ
        bootW   = 0.34 * s * squashXZ
        bootH   = 0.22 * s * squashY
        bootL   = 0.46 * s * squashXZ

        # Left Boot
        fL_Fwd = sin(swingL * DEG2RAD) * 0.36 * s
        fLx = marioX - footOff * rgtX + fL_Fwd * fwdX
        fLz = marioZ - footOff * rgtZ + fL_Fwd * fwdZ
        fLy = mBaseY + 0.16 * s * squashY

        if isFlipping
            dy = fLy - centerY
            df = fL_Fwd
            fLy = centerY + (dy * cosF - df * sinF)
            rotF = dy * sinF + df * cosF
            fLx = marioX - footOff * rgtX + rotF * fwdX
            fLz = marioZ - footOff * rgtZ + rotF * fwdZ
        ok

        DrawCube(Vector3(fLx, fLy - 0.08 * s, fLz), bootW + 0.04 * s, 0.08 * s, bootL + 0.04 * s, MARIO_SOLE)
        DrawCube(Vector3(fLx, fLy, fLz), bootW, bootH, bootL, MARIO_BROWN)
        DrawSphere(Vector3(fLx + 0.18 * s * fwdX, fLy, fLz + 0.18 * s * fwdZ), 0.18 * s * squashXZ, MARIO_BROWN)
        DrawSphere(Vector3(fLx - 0.16 * s * fwdX, fLy, fLz - 0.16 * s * fwdZ), 0.15 * s * squashXZ, MARIO_BROWN)
        DrawCylinder(Vector3(fLx, fLy + 0.14 * s, fLz), 0.20 * s * squashXZ, 0.20 * s * squashXZ, 0.16 * s, 12, colOveralls)

        # Right Boot
        fR_Fwd = sin(swingR * DEG2RAD) * 0.36 * s
        fRx = marioX + footOff * rgtX + fR_Fwd * fwdX
        fRz = marioZ + footOff * rgtZ + fR_Fwd * fwdZ
        fRy = mBaseY + 0.16 * s * squashY

        if isFlipping
            dy = fRy - centerY
            df = fR_Fwd
            fRy = centerY + (dy * cosF - df * sinF)
            rotF = dy * sinF + df * cosF
            fRx = marioX + footOff * rgtX + rotF * fwdX
            fRz = marioZ + footOff * rgtZ + rotF * fwdZ
        ok

        DrawCube(Vector3(fRx, fRy - 0.08 * s, fRz), bootW + 0.04 * s, 0.08 * s, bootL + 0.04 * s, MARIO_SOLE)
        DrawCube(Vector3(fRx, fRy, fRz), bootW, bootH, bootL, MARIO_BROWN)
        DrawSphere(Vector3(fRx + 0.18 * s * fwdX, fRy, fRz + 0.18 * s * fwdZ), 0.18 * s * squashXZ, MARIO_BROWN)
        DrawSphere(Vector3(fRx - 0.16 * s * fwdX, fRy, fRz - 0.16 * s * fwdZ), 0.15 * s * squashXZ, MARIO_BROWN)
        DrawCylinder(Vector3(fRx, fRy + 0.14 * s, fRz), 0.20 * s * squashXZ, 0.20 * s * squashXZ, 0.16 * s, 12, colOveralls)

        # 2. Denim Overalls (Pelvis & Hips)
        pelvisY = mBaseY + 0.58 * s * squashY + bobY
        bodyFwd = sin(pitchX * DEG2RAD) * 0.15 * s
        bodyX   = marioX + bodyFwd * fwdX
        bodyZ   = marioZ + bodyFwd * fwdZ

        if isFlipping
            dy = pelvisY - centerY
            pelvisY = centerY + (dy * cosF - bodyFwd * sinF)
            rotF = dy * sinF + bodyFwd * cosF
            bodyX = marioX + rotF * fwdX
            bodyZ = marioZ + rotF * fwdZ
        ok

        DrawCube(Vector3(bodyX, pelvisY, bodyZ), 0.68 * s * squashXZ, 0.44 * s * squashY, 0.54 * s * squashXZ, colOveralls)
        DrawSphere(Vector3(bodyX - 0.26 * s * rgtX, pelvisY, bodyZ - 0.26 * s * rgtZ), 0.24 * s * squashXZ, colOveralls)
        DrawSphere(Vector3(bodyX + 0.26 * s * rgtX, pelvisY, bodyZ + 0.26 * s * rgtZ), 0.24 * s * squashXZ, colOveralls)

        # 3. Torso & Denim Bib
        torsoY = mBaseY + 0.98 * s * squashY + bobY
        torsoFwd = bodyFwd + 0.05 * s
        torsoX = marioX + torsoFwd * fwdX
        torsoZ = marioZ + torsoFwd * fwdZ

        if isFlipping
            dy = torsoY - centerY
            torsoY = centerY + (dy * cosF - torsoFwd * sinF)
            rotF = dy * sinF + torsoFwd * cosF
            torsoX = marioX + rotF * fwdX
            torsoZ = marioZ + rotF * fwdZ
        ok

        DrawCube(Vector3(torsoX, torsoY, torsoZ), 0.72 * s * squashXZ, 0.52 * s * squashY, 0.50 * s * squashXZ, colShirt)

        # Denim Bib & Yellow Buttons
        bibFwd = 0.26 * s * squashXZ
        DrawCube(Vector3(torsoX + bibFwd * fwdX, torsoY - 0.04 * s, torsoZ + bibFwd * fwdZ), 0.52 * s * squashXZ, 0.38 * s * squashY, 0.12 * s, colOveralls)
        DrawCube(Vector3(torsoX - bibFwd * fwdX, torsoY - 0.04 * s, torsoZ - bibFwd * fwdZ), 0.50 * s * squashXZ, 0.34 * s * squashY, 0.10 * s, colOveralls)

        strapOff = 0.18 * s * squashXZ
        sL_X = torsoX - strapOff * rgtX
        sL_Z = torsoZ - strapOff * rgtZ
        sR_X = torsoX + strapOff * rgtX
        sR_Z = torsoZ + strapOff * rgtZ
        DrawCube(Vector3(sL_X, torsoY + 0.18 * s, sL_Z), 0.14 * s, 0.14 * s, 0.50 * s, colOveralls)
        DrawCube(Vector3(sR_X, torsoY + 0.18 * s, sR_Z), 0.14 * s, 0.14 * s, 0.50 * s, colOveralls)

        btnFwd = bibFwd + 0.06 * s
        btnY   = torsoY + 0.10 * s
        btnL_X = sL_X + btnFwd * fwdX
        btnL_Z = sL_Z + btnFwd * fwdZ
        btnR_X = sR_X + btnFwd * fwdX
        btnR_Z = sR_Z + btnFwd * fwdZ
        DrawSphere(Vector3(btnL_X, btnY, btnL_Z), 0.08 * s, MARIO_YELLOW)
        DrawSphere(Vector3(btnR_X, btnY, btnR_Z), 0.08 * s, MARIO_YELLOW)

        # 4. Arms & White Gloves
        armOff = 0.48 * s * squashXZ
        armY   = torsoY + 0.12 * s

        # Left Arm
        aL_Swing = -swingL * 0.8
        aL_Fwd   = sin(aL_Swing * DEG2RAD) * 0.32 * s
        aLx      = torsoX - armOff * rgtX + aL_Fwd * fwdX
        aLz      = torsoZ - armOff * rgtZ + aL_Fwd * fwdZ
        aLy      = armY

        DrawCube(Vector3(aLx, aLy, aLz), 0.24 * s, 0.36 * s * squashY, 0.24 * s, colShirt)
        DrawSphere(Vector3(aLx, aLy - 0.18 * s, aLz), 0.18 * s * squashXZ, MARIO_WHITE)
        DrawSphere(Vector3(aLx, aLy - 0.28 * s, aLz), 0.20 * s * squashXZ, MARIO_WHITE)

        # Right Arm (Raised high during jump)
        if not isOnGround and jumpCount = 1 and isGroundPounding = 0
            aRx = torsoX + armOff * rgtX + 0.12 * s * fwdX
            aRz = torsoZ + armOff * rgtZ + 0.12 * s * fwdZ
            aRy = armY + 0.42 * s
            DrawCube(Vector3(aRx, aRy, aRz), 0.24 * s, 0.42 * s * squashY, 0.24 * s, colShirt)
            DrawSphere(Vector3(aRx, aRy + 0.22 * s, aRz), 0.19 * s * squashXZ, MARIO_WHITE)
            DrawSphere(Vector3(aRx, aRy + 0.34 * s, aRz), 0.22 * s * squashXZ, MARIO_WHITE)
        else
            aR_Swing = -swingR * 0.8
            aR_Fwd   = sin(aR_Swing * DEG2RAD) * 0.32 * s
            aRx      = torsoX + armOff * rgtX + aR_Fwd * fwdX
            aRz      = torsoZ + armOff * rgtZ + aR_Fwd * fwdZ
            aRy      = armY
            DrawCube(Vector3(aRx, aRy, aRz), 0.24 * s, 0.36 * s * squashY, 0.24 * s, colShirt)
            DrawSphere(Vector3(aRx, aRy - 0.18 * s, aRz), 0.18 * s * squashXZ, MARIO_WHITE)
            DrawSphere(Vector3(aRx, aRy - 0.28 * s, aRz), 0.20 * s * squashXZ, MARIO_WHITE)
        ok

        # 5. Head, Cap, Mustache, Nose & Eyes
        headY = mBaseY + 1.50 * s * squashY + bobY
        headFwd = torsoFwd + 0.04 * s
        headX = marioX + headFwd * fwdX
        headZ = marioZ + headFwd * fwdZ

        if isFlipping
            dy = headY - centerY
            headY = centerY + (dy * cosF - headFwd * sinF)
            rotF = dy * sinF + headFwd * cosF
            headX = marioX + rotF * fwdX
            headZ = marioZ + rotF * fwdZ
        ok

        # Peach Skin Head Core
        DrawSphere(Vector3(headX, headY, headZ), 0.42 * s * squashXZ, MARIO_SKIN)

        # Bulbous Nose
        noseFwd = 0.44 * s * squashXZ
        noseX   = headX + noseFwd * fwdX
        noseZ   = headZ + noseFwd * fwdZ
        noseY   = headY + 0.04 * s
        DrawSphere(Vector3(noseX, noseY, noseZ), 0.19 * s * squashXZ, MARIO_SKIN)

        # Iconic Scalloped Mustache
        stacheY   = headY - 0.08 * s
        stacheFwd = noseFwd - 0.02 * s
        stacheX   = headX + stacheFwd * fwdX
        stacheZ   = headZ + stacheFwd * fwdZ
        DrawSphere(Vector3(stacheX, stacheY, stacheZ), 0.15 * s * squashXZ, MARIO_BROWN)
        DrawSphere(Vector3(stacheX - 0.14 * s * rgtX, stacheY - 0.02 * s, stacheZ - 0.14 * s * rgtZ), 0.13 * s, MARIO_BROWN)
        DrawSphere(Vector3(stacheX + 0.14 * s * rgtX, stacheY - 0.02 * s, stacheZ + 0.14 * s * rgtZ), 0.13 * s, MARIO_BROWN)
        DrawSphere(Vector3(stacheX - 0.26 * s * rgtX, stacheY - 0.05 * s, stacheZ - 0.26 * s * rgtZ), 0.11 * s, MARIO_BROWN)
        DrawSphere(Vector3(stacheX + 0.26 * s * rgtX, stacheY - 0.05 * s, stacheZ + 0.26 * s * rgtZ), 0.11 * s, MARIO_BROWN)

        # Expressive Oval Blue Eyes
        if blinkTimer < 4.2
            eyeY   = headY + 0.14 * s
            eyeFwd = 0.38 * s * squashXZ
            eyeOff = 0.14 * s * squashXZ
            eLx = headX + eyeFwd * fwdX - eyeOff * rgtX
            eLz = headZ + eyeFwd * fwdZ - eyeOff * rgtZ
            eRx = headX + eyeFwd * fwdX + eyeOff * rgtX
            eRz = headZ + eyeFwd * fwdZ + eyeOff * rgtZ

            DrawSphere(Vector3(eLx, eyeY, eLz), 0.10 * s, MARIO_WHITE)
            DrawSphere(Vector3(eRx, eyeY, eRz), 0.10 * s, MARIO_WHITE)
            DrawSphere(Vector3(eLx + 0.04 * s * fwdX, eyeY, eLz + 0.04 * s * fwdZ), 0.06 * s, MARIO_EYE_BLUE)
            DrawSphere(Vector3(eRx + 0.04 * s * fwdX, eyeY, eRz + 0.04 * s * fwdZ), 0.06 * s, MARIO_EYE_BLUE)
            DrawSphere(Vector3(eLx + 0.06 * s * fwdX, eyeY + 0.02 * s, eLz + 0.06 * s * fwdZ), 0.025 * s, MARIO_WHITE)
            DrawSphere(Vector3(eRx + 0.06 * s * fwdX, eyeY + 0.02 * s, eRz + 0.06 * s * fwdZ), 0.025 * s, MARIO_WHITE)
        ok

        # Iconic Red Mario Cap with Visor & White 'M' Emblem
        capY = headY + 0.28 * s
        DrawSphere(Vector3(headX, capY, headZ), 0.44 * s * squashXZ, colShirt)
        DrawSphere(Vector3(headX - 0.08 * s * fwdX, capY + 0.06 * s, headZ - 0.08 * s * fwdZ), 0.42 * s * squashXZ, colShirt)

        # Cap Visor (Brim)
        visorFwd = 0.36 * s * squashXZ
        visorY   = headY + 0.20 * s
        DrawCube(Vector3(headX + visorFwd * fwdX, visorY, headZ + visorFwd * fwdZ), 0.52 * s * squashXZ, 0.08 * s, 0.26 * s, colShirt)

        # White 'M' Crest Badge
        badgeFwd = 0.42 * s * squashXZ
        badgeY   = capY + 0.10 * s
        badgeX   = headX + badgeFwd * fwdX
        badgeZ   = headZ + badgeFwd * fwdZ
        DrawSphere(Vector3(badgeX, badgeY, badgeZ), 0.14 * s * squashXZ, MARIO_WHITE)
        DrawCube(Vector3(badgeX + 0.02 * s * fwdX, badgeY, badgeZ + 0.02 * s * fwdZ), 0.12 * s, 0.12 * s, 0.04 * s, MARIO_RED)
    end
end
