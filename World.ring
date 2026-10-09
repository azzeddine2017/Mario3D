#===================================================================#
# Mario 3D - Multi-Level Mushroom Kingdom World Subsystem
# Level 1: Meadow, Level 2: Lava Keep, Level 3: Sky Summit
# Textured Materials, Moving Platforms, Firebars, Lava Hazards, Warp Pipes
#===================================================================#

class MarioWorld
    currentLevel        # 1 = Meadow, 2 = Lava Keep, 3 = Sky Summit
    levelName           # String title of the stage
    platforms           # List of 3D AABB solid platforms
    movingPlatforms     # List of dynamic moving platforms
    blocks              # List of Question & Brick blocks
    coins               # List of floating 3D rotating gold coins
    pipes               # List of Warp Pipes
    trees               # List of Mushroom Kingdom trees
    clouds              # List of animated sky clouds
    mushrooms           # Giant decorative Toadstool mushrooms
    flowers             # 3D meadow flower patches
    fireBars            # Rotating fire chains (Level 2)
    hasLava             # Whether stage has molten lava lake
    lavaY               # Lava surface height
    powerUps            # Spawning Super Mushrooms / Stars
    bouncingCoins       # Bonus coins shooting out of bumped blocks
    starPos             # Position of the goal Power Star
    flagpolePos         # Position of classic Flagpole
    checkpointPos       # Position of midway checkpoint
    isCheckpointActive  # Whether checkpoint has been triggered
    audioRef            # Sound manager reference
    coinSpinAngle       # Coin rotation angle

    func init
        currentLevel        = 1
        levelName           = "WORLD 1-1: Mushroom Meadow"
        coinSpinAngle       = 0.0
        audioRef            = null
        platforms           = []
        movingPlatforms     = []
        blocks              = []
        coins               = []
        pipes               = []
        trees               = []
        clouds              = []
        mushrooms           = []
        flowers             = []
        fireBars            = []
        hasLava             = false
        lavaY               = -2.0
        powerUps            = []
        bouncingCoins       = []
        isCheckpointActive  = false

        buildLevel(1)
        return self
    end

    func loadLevel levelNum
        currentLevel = levelNum
        buildLevel(levelNum)
    end

    func buildLevel levelNum
        platforms           = []
        movingPlatforms     = []
        blocks              = []
        coins               = []
        pipes               = []
        trees               = []
        clouds              = []
        mushrooms           = []
        flowers             = []
        fireBars            = []
        powerUps            = []
        bouncingCoins       = []
        isCheckpointActive  = false

        if levelNum = 1
            # =======================================================
            # WORLD 1-1: MUSHROOM MEADOW (المروج الخضراء)
            # =======================================================
            levelName = "WORLD 1-1: Mushroom Meadow"
            hasLava   = false

            # 1. Solid Static Platforms (x, y, z, sx, sy, sz, type)
            # 1=Grass/Dirt, 2=Stone, 3=Mushroom Cap
            platforms + [ 0.0, -1.0, 0.0, 36.0, 2.0, 36.0, 1 ]
            platforms + [ -15.0, 3.2, 16.0, 4.8, 1.2, 4.8, 3 ]
            platforms + [  17.0, 3.2,  2.0, 4.8, 1.2, 4.8, 3 ]
            platforms + [ 0.0, -0.5, 26.0, 14.0, 3.0, 18.0, 1 ]
            platforms + [ 0.0,  1.0, 42.0, 18.0, 4.0, 16.0, 1 ]
            platforms + [ 14.0, 5.2, 38.0, 4.4, 1.0, 4.4, 3 ]
            platforms + [ -12.0, 3.2, 38.0, 6.0, 1.0, 6.0, 2 ]
            platforms + [ -10.0, 8.0, 58.0, 8.0, 1.0, 8.0, 2 ]
            platforms + [ 0.0, 10.5, 70.0, 22.0, 6.0, 22.0, 1 ]
            platforms + [ 28.0, 3.0, 18.0, 12.0, 2.0, 12.0, 1 ]

            # 2. Dynamic Moving Platforms
            # [x, y, z, sx, sy, sz, type, axis, range, speed, phase, baseX, baseY, baseZ]
            movingPlatforms + [ -18.0, 5.5, 48.0, 5.0, 0.8, 5.0, 4, "z", 6.0, 1.8, 0.0, -18.0, 5.5, 48.0 ]
            movingPlatforms + [  10.0, 6.0, 56.0, 4.5, 0.8, 4.5, 4, "y", 4.5, 1.4, 1.5,  10.0, 6.0, 56.0 ]

            # 3. Giant Toadstool Mushrooms
            mushrooms + [ -15.0, 0.0, 16.0, 1, 2.4, 3.2 ]
            mushrooms + [  17.0, 0.0,  2.0, 2, 2.4, 3.2 ]
            mushrooms + [  14.0, 1.0, 38.0, 1, 2.3, 4.2 ]

            # 4. Meadow Flowers
            flowers + [ -6.0, 0.0, -5.0, 1 ]
            flowers + [ -8.5, 0.0, -3.0, 2 ]
            flowers + [  6.0, 0.0, -4.0, 4 ]
            flowers + [  8.5, 0.0, -6.0, 1 ]
            flowers + [ -3.5, 0.0,  9.0, 2 ]
            flowers + [  4.5, 0.0, 11.0, 3 ]
            flowers + [ 26.0, 4.0, 15.0, 2 ]
            flowers + [ 30.0, 4.0, 21.0, 3 ]

            # 5. Interactive Blocks [x, y, z, type, isUsed, bounceTimer, bounceY, itemType]
            blocks + [ -3.0, 3.8, 6.0, 1, false, 0.0, 0.0, 2 ]  # Super Mushroom!
            blocks + [ -1.0, 3.8, 6.0, 2, false, 0.0, 0.0, 1 ]  # Brick Block
            blocks + [  1.0, 3.8, 6.0, 1, false, 0.0, 0.0, 1 ]  # Coin [?]
            blocks + [  3.0, 3.8, 6.0, 2, false, 0.0, 0.0, 1 ]  # Brick Block
            blocks + [ 0.0, 6.2, 6.0, 1, false, 0.0, 0.0, 3 ]   # High Starman Block!
            blocks + [ 0.0, 4.5, 26.0, 1, false, 0.0, 0.0, 1 ]
            blocks + [ 2.0, 4.5, 26.0, 2, false, 0.0, 0.0, 1 ]
            blocks + [ -4.0, 14.5, 64.0, 1, false, 0.0, 0.0, 2 ]
            blocks + [  4.0, 14.5, 64.0, 1, false, 0.0, 0.0, 1 ]

            # 6. Spinning Coins
            for c = -4 to 4 step 2
                coins + [ c * 2.0, 1.2, -6.0, false, c * 0.4 ]
            next
            for c = 1 to 5
                coins + [ 0.0, 2.0 + c * 0.4, 20.0 + c * 3.5, false, c * 0.5 ]
            next
            coins + [ -12.0, 4.5, 38.0, false, 0.2 ]
            coins + [ -18.0, 6.8, 48.0, false, 0.6 ]
            coins + [ -10.0, 9.3, 58.0, false, 0.9 ]

            # 7. Warp Pipes
            pipes + [  12.0, 0.0, -8.0, 1.4, 2.8, 28.0, 5.2, 18.0, true ]
            pipes + [  28.0, 4.0, 12.0, 1.4, 2.4, 12.0, 4.0, -8.0, true ]
            pipes + [   6.0, 3.0, 42.0, 1.4, 2.6, 0.0, 0.0, 0.0, false ]

            # 8. Trees & Clouds
            trees + [ -14.0, 0.0, -12.0, 3.5, 2.2 ]
            trees + [  14.0, 0.0,  12.0, 4.0, 2.5 ]
            trees + [ -14.0, 0.0,   2.0, 3.0, 2.0 ]
            trees + [   8.0, 0.0, -14.0, 3.8, 2.4 ]
            clouds + [ -25.0, 18.0,  10.0, 4.5, 1.2 ]
            clouds + [  18.0, 22.0,  35.0, 6.0, 0.8 ]

            checkpointPos = Vector3(0.0, 3.0, 36.0)
            flagpolePos   = Vector3(0.0, 13.5, 76.0)
            starPos       = Vector3(0.0, 16.5, 76.0)

        elseif levelNum = 2
            # =======================================================
            # WORLD 1-2: BOWSER'S LAVA KEEP (قلعة الصهارة)
            # =======================================================
            levelName = "WORLD 1-2: Bowser's Lava Keep"
            hasLava   = true
            lavaY     = -1.2

            # 1. Volcanic Stone Platforms (Type 2 = Stone Tiles)
            # Starting Bastion
            platforms + [ 0.0, 0.0, 0.0, 20.0, 2.0, 20.0, 2 ]
            # Bridge Over Boiling Lava
            platforms + [ 0.0, 0.0, 18.0, 8.0, 2.0, 14.0, 2 ]
            # First Island with Firebar
            platforms + [ 0.0, 0.0, 32.0, 10.0, 2.0, 10.0, 2 ]
            # Split Paths
            platforms + [ -8.0, 1.5, 46.0, 6.0, 2.0, 12.0, 2 ]
            platforms + [  8.0, 1.5, 46.0, 6.0, 2.0, 12.0, 2 ]
            # Central Fortress Bridge
            platforms + [ 0.0, 3.5, 58.0, 12.0, 3.0, 10.0, 2 ]
            # Bowser Throne Peak
            platforms + [ 0.0, 6.0, 74.0, 24.0, 5.0, 18.0, 2 ]

            # 2. Sinking & Rising Magma Lifts
            movingPlatforms + [ 0.0, 2.0, 46.0, 4.5, 0.8, 4.5, 4, "y", 3.2, 1.8, 0.0, 0.0, 2.0, 46.0 ]
            movingPlatforms + [ -12.0, 4.0, 64.0, 4.5, 0.8, 4.5, 4, "z", 5.0, 2.0, 1.2, -12.0, 4.0, 64.0 ]
            movingPlatforms + [  12.0, 4.0, 64.0, 4.5, 0.8, 4.5, 4, "z", 5.0, 2.0, 2.4,  12.0, 4.0, 64.0 ]

            # 3. Rotating Fire Bars [centerX, centerY, centerZ, length, speed, currentAngle]
            fireBars + [ 0.0, 1.5, 32.0, 4.2, 1.8, 0.0 ]
            fireBars + [ 0.0, 5.0, 58.0, 5.0, -2.2, 1.5 ]

            # 4. Interactive Blocks (Iron & Power-Ups)
            blocks + [ -3.0, 4.5, 0.0, 1, false, 0.0, 0.0, 2 ]  # Super Mushroom
            blocks + [  3.0, 4.5, 0.0, 1, false, 0.0, 0.0, 3 ]  # Starman
            blocks + [ -2.0, 4.0, 18.0, 2, false, 0.0, 0.0, 1 ]
            blocks + [  2.0, 4.0, 18.0, 2, false, 0.0, 0.0, 1 ]
            blocks + [ 0.0, 7.5, 58.0, 1, false, 0.0, 0.0, 2 ]

            # 5. Coins
            for c = 1 to 6
                coins + [ 0.0, 2.0, 12.0 + c * 3.0, false, c * 0.4 ]
            next
            coins + [ -8.0, 3.5, 46.0, false, 0.2 ]
            coins + [  8.0, 3.5, 46.0, false, 0.5 ]
            for a = 0 to 5
                ang = a * 60.0 * DEG2RAD
                coins + [ cos(ang) * 5.5, 9.5, 74.0 + sin(ang) * 5.5, false, a * 0.3 ]
            next

            checkpointPos = Vector3(0.0, 2.0, 32.0)
            flagpolePos   = Vector3(0.0, 9.0, 78.0)
            starPos       = Vector3(0.0, 12.0, 78.0)

        elseif levelNum = 3
            # =======================================================
            # WORLD 1-3: SKY CLOUD SUMMIT (قمة السحاب السماوية)
            # =======================================================
            levelName = "WORLD 1-3: Sky Cloud Summit"
            hasLava   = false

            # High Elevation Floating Island Steps
            platforms + [ 0.0, 0.0, 0.0, 16.0, 1.5, 16.0, 1 ]
            platforms + [ -10.0, 2.5, 16.0, 7.0, 1.2, 7.0, 3 ] # Bouncy Mushroom Cap
            platforms + [  10.0, 2.5, 16.0, 7.0, 1.2, 7.0, 3 ]
            platforms + [ 0.0, 4.5, 28.0, 12.0, 1.5, 12.0, 1 ]
            platforms + [ -8.0, 7.0, 42.0, 6.0, 1.0, 6.0, 2 ]
            platforms + [  8.0, 9.5, 54.0, 6.0, 1.0, 6.0, 2 ]
            platforms + [ 0.0, 12.0, 68.0, 18.0, 2.0, 18.0, 1 ] # Final Sky Sanctuary

            # Fast Sky Cloud Moving Platforms
            movingPlatforms + [ 0.0, 5.5, 38.0, 5.5, 0.8, 5.5, 4, "z", 6.5, 2.4, 0.0, 0.0, 5.5, 38.0 ]
            movingPlatforms + [ 0.0, 8.5, 52.0, 5.0, 0.8, 5.0, 4, "x", 6.0, 2.2, 1.5, 0.0, 8.5, 52.0 ]
            movingPlatforms + [ 0.0, 10.5, 60.0, 4.5, 0.8, 4.5, 4, "y", 3.5, 1.8, 3.0, 0.0, 10.5, 60.0 ]

            # Clouds & High Sky Decor
            clouds + [ -18.0, -1.0, 10.0, 5.5, 1.5 ]
            clouds + [  18.0, 1.0, 30.0, 6.0, 1.8 ]
            clouds + [ -12.0, 5.0, 50.0, 7.0, 2.0 ]
            clouds + [  15.0, 8.0, 65.0, 6.5, 1.6 ]

            # Pipe Piranha
            pipes + [ 0.0, 4.5, 28.0, 1.3, 2.5, 0.0, 0.0, 0.0, false ]

            # Blocks & Starman
            blocks + [ 0.0, 3.5, 0.0, 1, false, 0.0, 0.0, 2 ]   # Super Mushroom
            blocks + [ 0.0, 8.0, 28.0, 1, false, 0.0, 0.0, 3 ]  # Starman!
            blocks + [ -3.0, 16.0, 68.0, 1, false, 0.0, 0.0, 1 ]
            blocks + [  3.0, 16.0, 68.0, 1, false, 0.0, 0.0, 1 ]

            # Golden Rings of Coins
            for a = 0 to 7
                ang = a * 45.0 * DEG2RAD
                coins + [ cos(ang) * 4.5, 6.0, 28.0 + sin(ang) * 4.5, false, a * 0.4 ]
            next
            for a = 0 to 7
                ang = a * 45.0 * DEG2RAD
                coins + [ cos(ang) * 6.0, 14.5, 68.0 + sin(ang) * 6.0, false, a * 0.3 ]
            next

            checkpointPos = Vector3(0.0, 5.5, 28.0)
            flagpolePos   = Vector3(0.0, 13.5, 74.0)
            starPos       = Vector3(0.0, 17.0, 74.0)
        ok
    end

    func update dt, mario, audio
        if audio != NULL audioRef = audio ok
        coinSpinAngle += 150.0 * dt

        # 1. Update Moving Platforms & Carry Player
        for mp = 1 to len(movingPlatforms)
            plat = movingPlatforms[mp]
            oldX = plat[1]
            oldY = plat[2]
            oldZ = plat[3]

            plat[11] += dt * plat[10]
            offset = sin(plat[11]) * plat[9]

            if plat[8] = "x"
                plat[1] = plat[12] + offset
            elseif plat[8] = "y"
                plat[2] = plat[13] + offset
            elseif plat[8] = "z"
                plat[3] = plat[14] + offset
            ok

            deltaX = plat[1] - oldX
            deltaY = plat[2] - oldY
            deltaZ = plat[3] - oldZ

            # Carry Mario if standing on this moving platform
            if mario != null and mario.isOnGround
                minX = oldX - plat[4] / 2.0 - 0.25
                maxX = oldX + plat[4] / 2.0 + 0.25
                minZ = oldZ - plat[6] / 2.0 - 0.25
                maxZ = oldZ + plat[6] / 2.0 + 0.25
                topY = oldY + plat[5] / 2.0

                if mario.pos.x >= minX and mario.pos.x <= maxX and
                   mario.pos.z >= minZ and mario.pos.z <= maxZ and
                   fabs(mario.pos.y - topY) < 0.45
                    mario.pos.x += deltaX
                    mario.pos.y += deltaY
                    mario.pos.z += deltaZ
                ok
            ok

            movingPlatforms[mp] = plat
        next

        # 2. Update Rotating Fire Bars (Level 2)
        for fb = 1 to len(fireBars)
            fireBars[fb][6] += fireBars[fb][5] * dt
            # Check collision with Mario
            if mario != null and !mario.isDead and mario.invulnTimer <= 0
                cx = fireBars[fb][1]
                cy = fireBars[fb][2]
                cz = fireBars[fb][3]
                fLen = fireBars[fb][4]
                ang = fireBars[fb][6]

                for seg = 1 to 4
                    distSeg = (seg / 4.0) * fLen
                    orbX = cx + cos(ang) * distSeg
                    orbZ = cz + sin(ang) * distSeg
                    orbY = cy

                    dx = mario.pos.x - orbX
                    dy = mario.pos.y - orbY
                    dz = mario.pos.z - orbZ
                    if sqrt(dx*dx + dy*dy + dz*dz) < (mario.radius + 0.45)
                        mario.takeDamage(1)
                        mario.vel.y = 12.0
                        if audioRef != null audioRef.playDamage() ok
                    ok
                next
            ok
        next

        # 3. Check Molten Lava Abyss Hazard
        if hasLava and mario != null and !mario.isDead
            if mario.pos.y <= lavaY + 0.45
                mario.pos.y = lavaY + 0.45
                mario.vel.y = 17.5 # Lava burn launch!
                mario.takeDamage(1)
                if audioRef != null audioRef.playDamage() ok
            ok
        ok

        # 4. Update Animated Bouncing Blocks
        for b = 1 to len(blocks)
            if blocks[b][6] > 0.0
                blocks[b][6] -= dt * 6.0
                if blocks[b][6] <= 0.0
                    blocks[b][6] = 0.0
                    blocks[b][7] = 0.0
                else
                    blocks[b][7] = sin(blocks[b][6] * 3.14159) * 0.45
                ok
            ok
        next

        # 5. Update Bouncing Coins from Blocks
        bcIdx = 1
        while bcIdx <= len(bouncingCoins)
            bc = bouncingCoins[bcIdx]
            bc[2] += bc[4] * dt
            bc[4] -= GRAVITY_ACCEL * dt
            bc[5] -= dt
            if bc[5] <= 0.0
                del(bouncingCoins, bcIdx)
            else
                bouncingCoins[bcIdx] = bc
                bcIdx++
            ok
        end

        # 6. Update Spawning Power-Up Items
        puIdx = 1
        while puIdx <= len(powerUps)
            pu = powerUps[puIdx]
            if pu[6] < 1.0
                # Emerging upwards from block
                pu[6] += dt * 2.2
                pu[2] = pu[5] + pu[6] * 1.35
            else
                # Physics movement horizontally on top of platform
                pu[1] += pu[4] * dt
                # Ground check
                groundH = getGroundHeightUnder(pu[1], pu[3], pu[2])
                if pu[2] > groundH
                    pu[2] = max(groundH, pu[2] - 5.0 * dt)
                elseif pu[2] < groundH
                    pu[2] = groundH
                ok
                # Mario Pickup Check
                if mario != null and !mario.isDead
                    dx = mario.pos.x - pu[1]
                    dz = mario.pos.z - pu[3]
                    distXZ = sqrt(dx*dx + dz*dz)
                    dy = fabs((mario.pos.y + 0.5) - pu[2])

                    if distXZ < (mario.radius + 0.95) and dy < 1.6
                        if pu[7] = 2
                            mario.powerUpSuper()
                        elseif pu[7] = 3
                            mario.powerUpStarman()
                        ok
                        del(powerUps, puIdx)
                        loop
                    ok
                ok
            ok
            powerUps[puIdx] = pu
            puIdx++
        end

        # 7. Check Coin Collisions
        if mario != null and !mario.isDead
            for c = 1 to len(coins)
                if not coins[c][4]
                    dx = mario.pos.x - coins[c][1]
                    dz = mario.pos.z - coins[c][3]
                    distXZ = sqrt(dx*dx + dz*dz)
                    dy = fabs((mario.pos.y + 0.6) - coins[c][2])

                    if distXZ < (mario.radius + 0.95) and dy < 1.6
                        coins[c][4] = true
                        mario.addCoins(1)
                        mario.score += 200
                        if audioRef != null audioRef.playCoin() ok
                    ok
                ok
            next

            # Check Checkpoint activation
            dx = mario.pos.x - checkpointPos.x
            dz = mario.pos.z - checkpointPos.z
            if sqrt(dx*dx + dz*dz) < 2.5 and !isCheckpointActive
                isCheckpointActive = true
                mario.checkpointPos = checkpointPos
                mario.score += 1000
                if audioRef != null audioRef.playPowerUp() ok
            ok
        ok
    end

    func getGroundHeightUnder x, z, startY
        highestY = -100.0

        for p = 1 to len(platforms)
            plat = platforms[p]
            minX = plat[1] - plat[4] / 2.0
            maxX = plat[1] + plat[4] / 2.0
            minZ = plat[3] - plat[6] / 2.0
            maxZ = plat[3] + plat[6] / 2.0
            topY = plat[2] + plat[5] / 2.0

            if x >= minX and x <= maxX and z >= minZ and z <= maxZ
                if topY <= startY + 0.5 and topY > highestY
                    highestY = topY
                ok
            ok
        next

        for mp = 1 to len(movingPlatforms)
            plat = movingPlatforms[mp]
            minX = plat[1] - plat[4] / 2.0
            maxX = plat[1] + plat[4] / 2.0
            minZ = plat[3] - plat[6] / 2.0
            maxZ = plat[3] + plat[6] / 2.0
            topY = plat[2] + plat[5] / 2.0

            if x >= minX and x <= maxX and z >= minZ and z <= maxZ
                if topY <= startY + 0.75 and topY > highestY
                    highestY = topY
                ok
            ok
        next

        return highestY
    end

    func triggerGroundPound marioPos
        for b = 1 to len(blocks)
            bx = blocks[b][1]
            by = blocks[b][2]
            bz = blocks[b][3]
            dist = sqrt((marioPos.x - bx)*(marioPos.x - bx) + (marioPos.z - bz)*(marioPos.z - bz))
            if dist < 2.2 and fabs(marioPos.y - by) < 2.0
                bumpBlock(b, true)
            ok
        next
    end

    func bumpBlock bIdx, isSuper
        if blocks[bIdx][5] and blocks[bIdx][4] = 1 return ok

        blocks[bIdx][6] = 1.0
        itemT = blocks[bIdx][8]

        if blocks[bIdx][4] = 1 # Question Block
            blocks[bIdx][5] = true # Becomes Used Block
            if itemT = 1
                # Bouncing Gold Coin
                bouncingCoins + [ blocks[bIdx][1], blocks[bIdx][2] + 1.2, blocks[bIdx][3], 9.5, 0.75 ]
                if audioRef != null audioRef.playCoin() ok
            elseif itemT = 2 or itemT = 3
                # Super Mushroom (2) or Starman (3)
                powerUps + [ blocks[bIdx][1], blocks[bIdx][2] + 0.5, blocks[bIdx][3], 2.2, blocks[bIdx][2] + 0.5, 0.0, itemT ]
                if audioRef != null audioRef.playPowerUp() ok
            ok
        elseif blocks[bIdx][4] = 2 # Brick Block
            if isSuper
                # Smash brick into rubble pieces
                blocks[bIdx][5] = true
                if audioRef != null audioRef.playBreak() ok
            else
                if audioRef != null audioRef.playBump() ok
            ok
        ok
    end

    func checkPipeWarp pos
        for pi = 1 to len(pipes)
            pip = pipes[pi]
            if pip[9] # isFunctional
                dx = pos.x - pip[1]
                dz = pos.z - pip[3]
                if sqrt(dx*dx + dz*dz) < (pip[4] * 0.85) and fabs(pos.y - (pip[2] + pip[5])) < 0.6
                    return [ true, pip[6], pip[7], pip[8] ]
                ok
            ok
        next
        return [ false, 0.0, 0.0, 0.0 ]
    end

    func checkGoalReached mario
        if mario = null or mario.isDead return false ok
        dx = mario.pos.x - starPos.x
        dy = mario.pos.y - starPos.y
        dz = mario.pos.z - starPos.z
        if sqrt(dx*dx + dz*dz) < 3.2 and fabs(dy) < 4.0
            return true
        ok
        return false
    end

    func resolveMarioCollision oldPos, newX, newY, newZ, vel, currentScale, isSuper
        marioRadius = 0.55 * currentScale
        marioHeight = 1.35 * currentScale

        resX = newX
        resY = newY
        resZ = newZ
        resVx = vel.x
        resVy = vel.y
        resVz = vel.z
        isGrounded = false

        # 1. Static Platforms (AABB)
        for p = 1 to len(platforms)
            plat = platforms[p]
            minX = plat[1] - plat[4] / 2.0
            maxX = plat[1] + plat[4] / 2.0
            minY = plat[2] - plat[5] / 2.0
            maxY = plat[2] + plat[5] / 2.0
            minZ = plat[3] - plat[6] / 2.0
            maxZ = plat[3] + plat[6] / 2.0

            if resX + marioRadius > minX and resX - marioRadius < maxX and
               resZ + marioRadius > minZ and resZ - marioRadius < maxZ
                if oldPos.y >= (maxY - 0.35) and resY <= (maxY + 0.15)
                    resY = maxY
                    resVy = 0.0
                    isGrounded = true
                ok
            ok
        next

        # 2. Dynamic Moving Platforms (AABB)
        for mp = 1 to len(movingPlatforms)
            plat = movingPlatforms[mp]
            minX = plat[1] - plat[4] / 2.0
            maxX = plat[1] + plat[4] / 2.0
            minY = plat[2] - plat[5] / 2.0
            maxY = plat[2] + plat[5] / 2.0
            minZ = plat[3] - plat[6] / 2.0
            maxZ = plat[3] + plat[6] / 2.0

            if resX + marioRadius > minX and resX - marioRadius < maxX and
               resZ + marioRadius > minZ and resZ - marioRadius < maxZ
                if oldPos.y >= (maxY - 0.45) and resY <= (maxY + 0.35)
                    resY = maxY
                    resVy = 0.0
                    isGrounded = true
                ok
            ok
        next

        # 3. Interactive Blocks
        blockSz = 1.3
        for b = 1 to len(blocks)
            if blocks[b][5] and blocks[b][4] = 2 loop ok # Smashed brick has no collision

            bx = blocks[b][1]
            by = blocks[b][2] + blocks[b][7]
            bz = blocks[b][3]

            minX = bx - blockSz / 2.0
            maxX = bx + blockSz / 2.0
            minY = by - blockSz / 2.0
            maxY = by + blockSz / 2.0
            minZ = bz - blockSz / 2.0
            maxZ = bz + blockSz / 2.0

            if resX + marioRadius > minX and resX - marioRadius < maxX and
               resZ + marioRadius > minZ and resZ - marioRadius < maxZ
                if oldPos.y >= maxY - 0.22 and resY <= maxY
                    resY = maxY
                    resVy = 0.0
                    isGrounded = true
                elseif (oldPos.y + marioHeight) <= minY + 0.35 and (resY + marioHeight) >= minY
                    resY = minY - marioHeight
                    resVy = -2.0
                    bumpBlock(b, isSuper)
                ok
            ok
        next

        # 4. Warp Pipes
        for pi = 1 to len(pipes)
            pipeX = pipes[pi][1]
            pipeY = pipes[pi][2]
            pipeZ = pipes[pi][3]
            pipeR = pipes[pi][4]
            pipeH = pipes[pi][5]

            dx = resX - pipeX
            dz = resZ - pipeZ
            distXZ = sqrt(dx*dx + dz*dz)

            if distXZ < (pipeR + marioRadius)
                if oldPos.y >= (pipeY + pipeH - 0.25) and resY <= (pipeY + pipeH)
                    resY = pipeY + pipeH
                    resVy = 0.0
                    isGrounded = true
                elseif resY < (pipeY + pipeH) and distXZ > 0.001
                    overlap = (pipeR + marioRadius) - distXZ
                    resX += (dx / distXZ) * overlap
                    resZ += (dz / distXZ) * overlap
                ok
            ok
        next

        return [ resX, resY, resZ, resVx, resVy, resVz, isGrounded ]
    end

    # ---------------------------------------------------------------
    # 3D World Rendering
    # ---------------------------------------------------------------
    func draw texMgr, cam
        curTime = GetTime()

        # 0. Molten Lava Surface (Level 2)
        if hasLava
            lavaGlow = sin(curTime * 2.5) * 20
            lavaCol = RAYLibColor(235 + floor(lavaGlow), 60 + floor(lavaGlow * 0.5), 10, 245)
            DrawCube(Vector3(0.0, lavaY, 35.0), 90.0, 1.0, 120.0, lavaCol)
            DrawCube(Vector3(0.0, lavaY - 0.5, 35.0), 92.0, 1.0, 122.0, RAYLibColor(180, 30, 0, 255))
        ok

        # 1. Floating Sky Clouds
        for c = 1 to len(clouds)
            cld = clouds[c]
            cx = cld[1]
            cy = cld[2]
            cz = cld[3]
            cs = cld[4]

            DrawSphere(Vector3(cx, cy, cz), cs, RAYLibColor(255, 255, 255, 240))
            DrawSphere(Vector3(cx - cs * 0.48, cy - 0.2, cz), cs * 0.75, RAYLibColor(255, 255, 255, 240))
            DrawSphere(Vector3(cx + cs * 0.48, cy - 0.2, cz), cs * 0.75, RAYLibColor(255, 255, 255, 240))
        next

        # 2. Checkered / Textured Platforms (Static)
        for p = 1 to len(platforms)
            plat = platforms[p]
            drawPlatformModel(plat[1], plat[2], plat[3], plat[4], plat[5], plat[6], plat[7], texMgr)
        next

        # 3. Dynamic Moving Platforms (Textured Wood Lifts)
        for mp = 1 to len(movingPlatforms)
            plat = movingPlatforms[mp]
            drawPlatformModel(plat[1], plat[2], plat[3], plat[4], plat[5], plat[6], plat[7], texMgr)
        next

        # 4. Rotating Fire Bars (Level 2)
        for fb = 1 to len(fireBars)
            cx = fireBars[fb][1]
            cy = fireBars[fb][2]
            cz = fireBars[fb][3]
            fLen = fireBars[fb][4]
            ang = fireBars[fb][6]

            # Central Stone Pivot
            DrawCylinder(Vector3(cx, cy, cz), 0.45, 0.45, 0.5, 12, STONE_DARK)

            # Fire Orbs
            for seg = 1 to 4
                distSeg = (seg / 4.0) * fLen
                orbX = cx + cos(ang) * distSeg
                orbZ = cz + sin(ang) * distSeg
                DrawSphere(Vector3(orbX, cy, orbZ), 0.38, MARIO_YELLOW)
                DrawSphere(Vector3(orbX, cy, orbZ), 0.22, MARIO_RED)
            next
        next

        # 5. Giant Toadstool Mushrooms (Level 1)
        for m = 1 to len(mushrooms)
            msh = mushrooms[m]
            mx  = msh[1]
            my  = msh[2]
            mz  = msh[3]
            mt  = msh[4]
            mR  = msh[5]
            mH  = msh[6]

            mCapCol = MARIO_RED
            if mt = 2 mCapCol = PIPE_GREEN ok

            stemH = mH * 0.85
            DrawCylinder(Vector3(mx, my + stemH / 2.0, mz), 0.95, 1.25, stemH, 16, CASTLE_WHITE)
            capY = my + stemH + 0.35
            DrawSphere(Vector3(mx, capY, mz), mR, mCapCol)
            DrawSphere(Vector3(mx, capY + mR * 0.85, mz), 0.55, WHITE)
            DrawSphere(Vector3(mx + mR * 0.75, capY + 0.2, mz), 0.45, WHITE)
            DrawSphere(Vector3(mx - mR * 0.75, capY + 0.2, mz), 0.45, WHITE)
        next

        # 6. Vibrant 3D Meadow Flowers
        for f = 1 to len(flowers)
            fl = flowers[f]
            fx = fl[1]
            fy = fl[2]
            fz = fl[3]
            ft = fl[4]
            petalCol = MARIO_YELLOW
            if ft = 2 petalCol = MARIO_RED ok
            if ft = 3 petalCol = RAYLibColor(70, 160, 255, 255) ok
            if ft = 4 petalCol = CASTLE_WHITE ok
            DrawCylinder(Vector3(fx, fy + 0.18, fz), 0.05, 0.05, 0.36, 6, PIPE_GREEN)
            DrawSphere(Vector3(fx, fy + 0.40, fz), 0.20, petalCol)
            DrawSphere(Vector3(fx, fy + 0.40, fz), 0.10, MARIO_YELLOW)
        next

        # 7. Interactive Blocks: [?] Question & Brick Blocks
        blockSz = 1.3
        for b = 1 to len(blocks)
            blk = blocks[b]
            if blk[5] and blk[4] = 2 loop ok # Destroyed brick

            bx = blk[1]
            by = blk[2] + blk[7]
            bz = blk[3]
            bt = blk[4]
            bUsed = blk[5]
            bPos = Vector3(bx, by, bz)

            if bt = 1 # Question Block
                if bUsed
                    if texMgr != null texMgr.drawUsedBlock(bPos, blockSz)
                    else DrawCube(bPos, blockSz, blockSz, blockSz, BLOCK_USED) ok
                else
                    if texMgr != null texMgr.drawQuestionBlock(bPos, blockSz)
                    else DrawCube(bPos, blockSz, blockSz, blockSz, BLOCK_QUESTION) ok
                ok
            elseif bt = 2 # Brick Block
                if texMgr != null texMgr.drawBrickBlock(bPos, blockSz)
                else DrawCube(bPos, blockSz, blockSz, blockSz, BLOCK_BRICK) ok
            ok
        next

        # 8. Bouncing Bonus Coins
        for bc = 1 to len(bouncingCoins)
            bcoin = bouncingCoins[bc]
            bcy = bcoin[2]
            if texMgr != null and texMgr.texCoin != null and cam != null
                texMgr.drawBillboardSafe(cam.camera, texMgr.texCoin, Vector3(bcoin[1], bcy, bcoin[3]), 1.1, WHITE)
            else
                DrawCylinder(Vector3(bcoin[1], bcy, bcoin[3]), 0.42, 0.42, 0.12, 16, GOLD_SHINE)
            ok
        next

        # 9. Spawning Power-Up Items
        for pi = 1 to len(powerUps)
            pu = powerUps[pi]
            pux = pu[1]
            puy = pu[2]
            puz = pu[3]
            pute = pu[7]

            if pute = 2 # Super Mushroom
                if texMgr != null and texMgr.texMushroom != null and cam != null
                    texMgr.drawBillboardSafe(cam.camera, texMgr.texMushroom, Vector3(pux, puy + 0.35, puz), 1.25, WHITE)
                else
                    DrawSphere(Vector3(pux, puy + 0.28, puz), 0.45, MARIO_RED)
                ok
            elseif pute = 3 # Starman
                if texMgr != null and texMgr.texStar != null and cam != null
                    texMgr.drawBillboardSafe(cam.camera, texMgr.texStar, Vector3(pux, puy + 0.35, puz), 1.35, WHITE)
                else
                    DrawSphere(Vector3(pux, puy + 0.25, puz), 0.40, MARIO_YELLOW)
                ok
            ok
        next

        # 10. Spinning 3D Gold Coins
        for c = 1 to len(coins)
            coin = coins[c]
            if not coin[4]
                coinBob = sin(curTime * 3.5 + coin[5]) * 0.12
                cy = coin[2] + coinBob

                if texMgr != null and texMgr.texCoin != null and cam != null
                    texMgr.drawBillboardSafe(cam.camera, texMgr.texCoin, Vector3(coin[1], cy, coin[3]), 0.95, WHITE)
                else
                    cThickness = 0.12
                    cRadius    = 0.38
                    DrawCylinder(Vector3(coin[1], cy, coin[3]), cRadius, cRadius, cThickness, 16, MARIO_YELLOW)
                ok

                groundY = getGroundHeightUnder(coin[1], coin[3], coin[2])
                DrawCylinder(Vector3(coin[1], groundY + 0.05, coin[3]), 0.35, 0.35, 0.02, 12, RAYLibColor(20, 30, 20, 110))
            ok
        next

        # 11. Warp Pipes
        for pi = 1 to len(pipes)
            pip = pipes[pi]
            px = pip[1]
            py = pip[2]
            pz = pip[3]
            pr = pip[4]
            ph = pip[5]

            DrawCylinder(Vector3(px, py + ph * 0.45, pz), pr * 0.90, pr * 0.90, ph * 0.90, 24, PIPE_GREEN)
            DrawCylinderWires(Vector3(px, py + ph * 0.45, pz), pr * 0.90, pr * 0.90, ph * 0.90, 24, PIPE_DARK)
            lipH = 0.52
            lipY = py + ph - lipH / 2.0
            DrawCylinder(Vector3(px, lipY, pz), pr * 1.10, pr * 1.10, lipH, 24, PIPE_GREEN)
            DrawCylinder(Vector3(px, py + ph + 0.02, pz), pr * 0.75, pr * 0.75, 0.06, 24, BLACK)
        next

        # 12. Mushroom Kingdom Trees
        for t = 1 to len(trees)
            tr = trees[t]
            tx = tr[1]
            ty = tr[2]
            tz = tr[3]
            th = tr[4]
            tc = tr[5]

            DrawCylinder(Vector3(tx, ty + th / 2.0, tz), 0.55, 0.65, th, 14, MARIO_BROWN)
            canopyY = ty + th + tc * 0.7
            DrawSphere(Vector3(tx, canopyY, tz), tc, RAYLibColor(55, 175, 45, 255))
            DrawSphere(Vector3(tx, canopyY + tc * 0.35, tz), tc * 0.65, GRASS_LIGHT)
        next

        # 13. Midway Checkpoint Flag
        cpPoleH = 4.5
        cpPoleY = checkpointPos.y + cpPoleH / 2.0
        DrawCylinder(Vector3(checkpointPos.x, cpPoleY, checkpointPos.z), 0.08, 0.08, cpPoleH, 12, CASTLE_WHITE)
        DrawSphere(Vector3(checkpointPos.x, checkpointPos.y + cpPoleH, checkpointPos.z), 0.22, GOLD_SHINE)

        flagCol = RAYLibColor(60, 60, 70, 255)
        if isCheckpointActive flagCol = MARIO_RED ok
        flagW = 1.2
        flagH = 0.8
        flagY = checkpointPos.y + cpPoleH - 0.6

        if texMgr != null and isCheckpointActive
            texMgr.drawFlag(Vector3(checkpointPos.x + flagW / 2.0, flagY, checkpointPos.z), flagW, flagH, 0.06)
        else
            DrawCube(Vector3(checkpointPos.x + flagW / 2.0, flagY, checkpointPos.z), flagW, flagH, 0.06, flagCol)
        ok

        # 14. Goal Flagpole & Golden Power Star
        fBaseY = flagpolePos.y - 4.0
        DrawCube(Vector3(flagpolePos.x, fBaseY, flagpolePos.z), 2.6, 1.2, 2.6, CASTLE_WHITE)
        poleH = 9.0
        poleY = flagpolePos.y + poleH / 2.0 - 3.2
        DrawCylinder(Vector3(flagpolePos.x, poleY, flagpolePos.z), 0.12, 0.12, poleH, 12, GOLD_SHINE)
        DrawSphere(Vector3(flagpolePos.x, poleY + poleH / 2.0, flagpolePos.z), 0.48, GOLD_SHINE)

        flagY = poleY + poleH / 2.0 - 1.2
        flagW = 1.9
        flagH = 1.25
        if texMgr != null
            texMgr.drawFlag(Vector3(flagpolePos.x + flagW / 2.0 + 0.1, flagY, flagpolePos.z), flagW, flagH, 0.08)
        else
            DrawCube(Vector3(flagpolePos.x + flagW / 2.0 + 0.1, flagY, flagpolePos.z), flagW, flagH, 0.08, GRASS_GREEN)
        ok

        # Spinning 3D Golden Power Star
        starBob = sin(curTime * 3.0) * 0.35
        sy = starPos.y + starBob

        if texMgr != null and texMgr.texStar != null and cam != null
            texMgr.drawBillboardSafe(cam.camera, texMgr.texStar, Vector3(starPos.x, sy, starPos.z), 2.5, WHITE)
            DrawSphere(Vector3(starPos.x, sy, starPos.z), 0.45, RAYLibColor(255, 235, 80, 150))
        else
            starAngle = curTime * 120.0
            starRad = starAngle * DEG2RAD
            DrawSphere(Vector3(starPos.x, sy, starPos.z), 0.75, MARIO_YELLOW)
            DrawSphere(Vector3(starPos.x, sy, starPos.z), 0.45, GOLD_SHINE)
            for sp = 0 to 4
                pAng = starRad + (sp * 72.0) * DEG2RAD
                ptX = starPos.x + cos(pAng) * 0.85
                ptZ = starPos.z + sin(pAng) * 0.85
                DrawSphere(Vector3(ptX, sy, ptZ), 0.32, MARIO_YELLOW)
            next
        ok
    end

    func drawPlatformModel px, py, pz, sx, sy, sz, pt, texMgr
        # 1. Base / Sides
        if pt = 4 and texMgr != null
            texMgr.drawPlatformBase(Vector3(px, py, pz), sx, sy, sz, pt)
            return
        elseif texMgr != null
            texMgr.drawPlatformBase(Vector3(px, py - 0.1, pz), sx, sy - 0.2, sz, pt)
        else
            sideCol = DIRT_BROWN
            if pt = 2 sideCol = STONE_DARK ok
            if pt = 3 sideCol = CASTLE_WHITE ok
            DrawCube(Vector3(px, py - 0.1, pz), sx, sy - 0.2, sz, sideCol)
        ok

        # 2. Top Surface
        grassH = 0.28
        grassY = py + sy / 2.0 - grassH / 2.0

        if pt = 1
            if texMgr != null
                texMgr.drawPlatformGrass(Vector3(px, grassY, pz), sx + 0.1, grassH, sz + 0.1)
            else
                DrawCube(Vector3(px, grassY, pz), sx + 0.1, grassH, sz + 0.1, GRASS_GREEN)
            ok
        elseif pt = 2
            if texMgr != null
                texMgr.drawPlatformBase(Vector3(px, grassY, pz), sx + 0.12, grassH, sz + 0.12, 2)
            else
                DrawCube(Vector3(px, grassY, pz), sx + 0.12, grassH, sz + 0.12, STONE_LIGHT)
            ok
        elseif pt = 3
            DrawCube(Vector3(px, grassY, pz), sx + 0.15, grassH, sz + 0.15, MARIO_RED)
            DrawSphere(Vector3(px, grassY + 0.1, pz), 0.65, WHITE)
        ok
    end
end
