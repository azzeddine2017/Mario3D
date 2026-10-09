#===================================================================#
# Mario 3D - Heads-Up Display (HUD) & UI Overlay
# Super Mario 64 / Galaxy Styled Retro 3D Platformer HUD
# Multi-Level Banners, Stage Transitions & Grand Victory Overlays
#===================================================================#

class MarioHUD
    scorePulse = 0.0
    coinPulse = 0.0
    starPulse = 0.0

    func init
        scorePulse = 0.0
        coinPulse = 0.0
        starPulse = 0.0
    end

    func update dt
        if scorePulse > 0 scorePulse -= dt * 3.0 ok
        if coinPulse > 0  coinPulse -= dt * 3.0 ok
        if starPulse > 0  starPulse -= dt * 2.0 ok
    end

    func drawPlayingHUD mario, worldTime, world
        # 1. TOP-LEFT: MARIO LIVES, HEALTH & POWER-UP BADGES
        drawPlayerCard(mario)

        # 2. TOP-CENTER: WORLD / LEVEL BANNER
        drawStageBanner(world)

        # 3. TOP-RIGHT: COIN COUNTER, STARS, & SCORE
        drawCollectibles(mario, worldTime)

        # 4. BOTTOM HINTS: ADVANCED CONTROLS GUIDE
        drawControlsBar()
    end

    func drawPlayerCard mario
        cardX = 25
        cardY = 20
        cardW = 230
        cardH = 74

        cBg1 = RAYLibColor(20, 25, 45, 220)
        cBg2 = RAYLibColor(10, 12, 25, 245)
        DrawRectangleGradientV(cardX, cardY, cardW, cardH, cBg1, cBg2)
        DrawRectangleLines(cardX, cardY, cardW, cardH, RAYLibColor(255, 215, 0, 200))

        # Mario Cap Icon
        iconX = cardX + 14
        iconY = cardY + 22
        DrawCircle(iconX + 14, iconY + 14, 16, MARIO_RED)
        DrawRectangle(iconX + 8, iconY + 16, 22, 7, MARIO_RED)
        DrawCircle(iconX + 14, iconY + 9, 6, MARIO_WHITE)
        DrawText("M", iconX + 10, iconY + 4, 12, MARIO_RED)

        # Mario Name, Lives & Power State
        nameLabel = "MARIO"
        if mario.isSuper nameLabel = "SUPER MARIO" ok
        DrawText(nameLabel, cardX + 54, cardY + 10, 15, MARIO_WHITE)
        livesText = "x " + "" + mario.lives
        DrawText(livesText, cardX + 165, cardY + 10, 16, MARIO_YELLOW)

        # Health Segments
        meterX = cardX + 54
        meterY = cardY + 36
        numSegs = mario.maxHealth
        segW = floor(160 / numSegs) - 4
        segH = 18

        for i = 1 to numSegs
            sx = meterX + (i - 1) * (segW + 4)
            if i <= mario.health
                if mario.health = 1
                    cSeg1 = RAYLibColor(235, 45, 45, 255)
                    cSeg2 = RAYLibColor(165, 20, 20, 255)
                else
                    cSeg1 = RAYLibColor(70, 215, 60, 255)
                    cSeg2 = RAYLibColor(35, 145, 30, 255)
                ok
                DrawRectangleGradientV(sx, meterY, segW, segH, cSeg1, cSeg2)
                DrawRectangleLines(sx, meterY, segW, segH, RAYLibColor(255, 255, 255, 200))
            else
                DrawRectangle(sx, meterY, segW, segH, RAYLibColor(50, 50, 60, 180))
                DrawRectangleLines(sx, meterY, segW, segH, RAYLibColor(100, 100, 120, 150))
            ok
        next

        # Starman Invincibility Active Banner
        if mario.starmanTimer > 0.0
            starW = 140
            starH = 26
            starX = cardX
            starY = cardY + cardH + 6
            DrawRectangle(starX, starY, starW, starH, RAYLibColor(255, 215, 0, 230))
            DrawRectangleLines(starX, starY, starW, starH, WHITE)
            sSecs = "" + floor(mario.starmanTimer) + "s"
            DrawText("STARMAN " + sSecs, starX + 10, starY + 6, 14, BLACK)
        ok
    end

    func drawStageBanner world
        bannerW = 380
        bannerH = 36
        bannerX = (SCREEN_WIDTH - bannerW) / 2
        bannerY = 16

        cBg1 = RAYLibColor(20, 30, 60, 210)
        cBg2 = RAYLibColor(10, 15, 35, 240)
        DrawRectangleGradientV(bannerX, bannerY, bannerW, bannerH, cBg1, cBg2)
        DrawRectangleLines(bannerX, bannerY, bannerW, bannerH, RAYLibColor(100, 190, 255, 190))

        titleText = "WORLD 1-1 : MUSHROOM MEADOW"
        if world != null and world.levelName != null
            titleText = world.levelName
        ok
        tw = MeasureText(titleText, 15)
        tx = bannerX + (bannerW - tw) / 2
        DrawText(titleText, tx, bannerY + 11, 15, RAYLibColor(235, 245, 255, 255))
    end

    func drawCollectibles mario, worldTime
        cardW = 250
        cardH = 74
        cardX = SCREEN_WIDTH - cardW - 25
        cardY = 20

        cBg1 = RAYLibColor(20, 25, 45, 220)
        cBg2 = RAYLibColor(10, 12, 25, 245)
        DrawRectangleGradientV(cardX, cardY, cardW, cardH, cBg1, cBg2)
        DrawRectangleLines(cardX, cardY, cardW, cardH, RAYLibColor(255, 215, 0, 200))

        # Coin Icon & Count
        coinIconX = cardX + 16
        coinIconY = cardY + 16
        DrawCircle(coinIconX + 10, coinIconY + 10, 11, MARIO_YELLOW)
        DrawCircle(coinIconX + 10, coinIconY + 10, 6, GOLD_SHINE)
        DrawText("$", coinIconX + 7, coinIconY + 3, 15, RAYLibColor(180, 110, 10, 255))

        coinStr = "x " + "" + mario.coins
        DrawText(coinStr, cardX + 44, cardY + 16, 18, MARIO_YELLOW)

        # Star Icon
        starIconX = cardX + 130
        starIconY = cardY + 16
        DrawCircle(starIconX + 8, starIconY + 10, 9, MARIO_YELLOW)
        DrawText("*", starIconX + 4, starIconY + 3, 16, GOLD_SHINE)

        starStr = "x " + "" + mario.stars
        DrawText(starStr, cardX + 155, cardY + 16, 18, GOLD_SHINE)

        # Score & Timer
        scoreStr = "SCORE " + "" + mario.score
        DrawText(scoreStr, cardX + 16, cardY + 45, 14, RAYLibColor(210, 230, 255, 255))

        mins = floor(worldTime / 60.0)
        secs = floor(worldTime % 60.0)
        secStr = "" + secs
        if secs < 10 secStr = "0" + secStr ok
        timeStr = "TIME " + "" + mins + ":" + secStr
        DrawText(timeStr, cardX + 135, cardY + 45, 14, RAYLibColor(255, 225, 130, 255))
    end

    func drawControlsBar
        barW = 840
        barH = 30
        barX = (SCREEN_WIDTH - barW) / 2
        barY = SCREEN_HEIGHT - barH - 12

        DrawRectangle(barX, barY, barW, barH, RAYLibColor(15, 20, 35, 200))
        DrawRectangleLines(barX, barY, barW, barH, RAYLibColor(90, 120, 180, 150))

        guideText = "WASD / ZQSD / Arrows: Move | SPACE: Jump (x3) | CTRL/C: Ground Pound | SHIFT: Dash | S: Pipe"
        tw = MeasureText(guideText, 13)
        tx = barX + (barW - tw) / 2
        DrawText(guideText, tx, barY + 9, 13, RAYLibColor(220, 235, 255, 230))
    end

    func drawCourseClearScreen mario, worldTime, nextLevel
        DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, RAYLibColor(10, 15, 30, 180))

        bW = 620
        bH = 360
        bX = (SCREEN_WIDTH - bW) / 2
        bY = (SCREEN_HEIGHT - bH) / 2

        DrawRectangleGradientV(bX, bY, bW, bH, RAYLibColor(25, 45, 95, 245), RAYLibColor(10, 20, 45, 255))
        DrawRectangleLines(bX, bY, bW, bH, RAYLibColor(255, 220, 50, 255))

        title = "COURSE CLEAR!"
        tw = MeasureText(title, 42)
        DrawText(title, bX + (bW - tw) / 2, bY + 30, 42, MARIO_YELLOW)

        sub = "YOU OBTAINED THE POWER STAR!"
        stw = MeasureText(sub, 19)
        DrawText(sub, bX + (bW - stw) / 2, bY + 85, 19, GOLD_SHINE)

        DrawText("Score : " + "" + mario.score, bX + 80, bY + 140, 22, WHITE)
        DrawText("Coins Collected : " + "" + mario.coins, bX + 80, bY + 175, 22, MARIO_YELLOW)
        DrawText("Lives Remaining : " + "" + mario.lives, bX + 80, bY + 210, 22, GRASS_LIGHT)

        promptText = "Press [ENTER] or [SPACE] to enter Next World!"
        if nextLevel > 3
            promptText = "Press [ENTER] or [SPACE] to view Grand Victory!"
        ok
        ptw = MeasureText(promptText, 18)
        DrawText(promptText, bX + (bW - ptw) / 2, bY + 290, 18, RAYLibColor(255, 255, 255, 230))
    end

    func drawGrandVictoryScreen mario, worldTime
        DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, RAYLibColor(10, 5, 25, 210))

        bW = 680
        bH = 400
        bX = (SCREEN_WIDTH - bW) / 2
        bY = (SCREEN_HEIGHT - bH) / 2

        DrawRectangleGradientV(bX, bY, bW, bH, RAYLibColor(60, 20, 95, 250), RAYLibColor(20, 10, 45, 255))
        DrawRectangleLines(bX, bY, bW, bH, GOLD_SHINE)

        title = "CONGRATULATIONS!"
        tw = MeasureText(title, 44)
        DrawText(title, bX + (bW - tw) / 2, bY + 30, 44, GOLD_SHINE)

        sub = "YOU SAVED THE MUSHROOM KINGDOM!"
        stw = MeasureText(sub, 20)
        DrawText(sub, bX + (bW - stw) / 2, bY + 85, 20, WHITE)

        mins = floor(worldTime / 60.0)
        secs = floor(worldTime % 60.0)
        secStr = "" + secs
        if secs < 10 secStr = "0" + secStr ok

        DrawText("Total Final Score : " + "" + mario.score, bX + 90, bY + 150, 22, MARIO_YELLOW)
        DrawText("Total Coins : " + "" + mario.coins, bX + 90, bY + 190, 22, GOLD_SHINE)
        DrawText("Clear Time : " + "" + mins + ":" + secStr, bX + 90, bY + 230, 22, RAYLibColor(180, 230, 255, 255))
        DrawText("Power Stars Collected : 3 / 3 (100%)", bX + 90, bY + 270, 22, GRASS_LIGHT)

        pPrompt = "Press [ENTER] or [SPACE] to Play Again!"
        ptw = MeasureText(pPrompt, 18)
        DrawText(pPrompt, bX + (bW - ptw) / 2, bY + 340, 18, WHITE)
    end

    func drawGameOverScreen mario
        DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, RAYLibColor(15, 10, 10, 190))

        bW = 500
        bH = 260
        bX = (SCREEN_WIDTH - bW) / 2
        bY = (SCREEN_HEIGHT - bH) / 2

        DrawRectangleGradientV(bX, bY, bW, bH, RAYLibColor(60, 15, 15, 245), RAYLibColor(25, 5, 5, 255))
        DrawRectangleLines(bX, bY, bW, bH, MARIO_RED)

        title = "GAME OVER"
        tw = MeasureText(title, 44)
        DrawText(title, bX + (bW - tw) / 2, bY + 45, 44, MARIO_RED)

        pPrompt = "Press [ENTER] or [SPACE] to Retry"
        ptw = MeasureText(pPrompt, 18)
        DrawText(pPrompt, bX + (bW - ptw) / 2, bY + 180, 18, WHITE)
    end

    func drawPauseScreen
        DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, RAYLibColor(10, 15, 25, 160))

        bW = 420
        bH = 220
        bX = (SCREEN_WIDTH - bW) / 2
        bY = (SCREEN_HEIGHT - bH) / 2

        DrawRectangleGradientV(bX, bY, bW, bH, RAYLibColor(20, 30, 60, 240), RAYLibColor(10, 15, 30, 255))
        DrawRectangleLines(bX, bY, bW, bH, RAYLibColor(100, 190, 255, 200))

        title = "PAUSED"
        tw = MeasureText(title, 36)
        DrawText(title, bX + (bW - tw) / 2, bY + 35, 36, MARIO_WHITE)

        DrawText("[ESC] / [P] - Resume", bX + 90, bY + 105, 18, RAYLibColor(220, 235, 255, 255))
        DrawText("[R] - Restart Level", bX + 90, bY + 145, 18, MARIO_YELLOW)
    end
end
