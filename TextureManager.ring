#===================================================================#
# Mario 3D - Complete Texture & Material Subsystem
# Supports Tiled Grass Grid 
# Textured Stone & Wood Cliff Edges ,
# Textured Level Flag ,
# and 100% Alpha-Transparent Billboards for Coins, Mushrooms & Star
#===================================================================#

class MarioTextureManager
    # Textures
    texGrass          = null
    texDirt           = null
    texStone          = null
    texWood           = null
    texQuestion       = null
    texBrick          = null
    texUsed           = null
    texCoin           = null
    texMushroom       = null
    texStar           = null
    texFlag           = null
    texPipe           = null
    texKoopa          = null
    texGoomba         = null

    # 3D Models
    modelGrassPlane   = null
    modelDirtWall     = null
    modelStonePlane   = null
    modelStoneWall    = null
    modelWoodPlane    = null
    modelWoodWall     = null
    modelQuestion     = null
    modelBrick        = null
    modelUsed         = null
    modelFlag         = null
    modelPipeBody     = null
    modelKoopaShell   = null
    modelGoombaFace   = null
    modelCoin         = null
    modelMushroom     = null
    modelStar         = null

    hasTextures       = false
    tileGridSize      = 5.5   # Grid cell dimension (meters) for high-performance crisp tiling
    wallGridSize      = 7.5   # Wall tile dimension (meters) for silky-smooth 60 FPS

    func init
        loadAllTextures()
        createModels()
        return self
    end

    func getAssetPath
        if fexists("Assets/textures/grass_top.png")
            return "Assets/textures/"
        ok
        cDir = currentdir() + "/"
        if fexists(cDir + "Assets/textures/grass_top.png")
            return cDir + "Assets/textures/"
        ok
        cExe = exefolder() + "/../tools/ringpm/packages/Mario3D/Assets/textures/"
        if fexists(cExe + "grass_top.png")
            return cExe
        ok
        return "Assets/textures/"
    end

    func loadAllTextures
        cPath = getAssetPath()

        if fexists(cPath + "grass_top.png")
            texGrass    = LoadTexture(cPath + "grass_top.png")
            texDirt     = LoadTexture(cPath + "dirt_side.png")
            texStone    = LoadTexture(cPath + "stone_tile.png")
            texWood     = LoadTexture(cPath + "wood_plank.png")
            if fexists(cPath + "question_block.png")
                imgQuestion = LoadImage(cPath + "question_block.png")
                ImageFlipVertical(imgQuestion)
                texQuestion = LoadTextureFromImage(imgQuestion)
                UnloadImage(imgQuestion)
            else
                texQuestion = LoadTexture(cPath + "question_block.png")
            ok
            texBrick    = LoadTexture(cPath + "brick_block.png")
            texUsed     = LoadTexture(cPath + "block_used.png")

            if fexists(cPath + "coin.png")
                imgCoin = LoadImage(cPath + "coin.png")
                ImageFlipVertical(imgCoin)
                texCoin = LoadTextureFromImage(imgCoin)
                UnloadImage(imgCoin)
            else
                texCoin = LoadTexture(cPath + "coin.png")
            ok

            if fexists(cPath + "super_mushroom.png")
                imgMush = LoadImage(cPath + "super_mushroom.png")
                ImageFlipVertical(imgMush)
                texMushroom = LoadTextureFromImage(imgMush)
                UnloadImage(imgMush)
            else
                texMushroom = LoadTexture(cPath + "super_mushroom.png")
            ok

            if fexists(cPath + "power_star.png")
                imgStar = LoadImage(cPath + "power_star.png")
                ImageFlipVertical(imgStar)
                texStar = LoadTextureFromImage(imgStar)
                UnloadImage(imgStar)
            else
                texStar = LoadTexture(cPath + "power_star.png")
            ok

            if fexists(cPath + "mario_flag.png")
                imgFlag = LoadImage(cPath + "mario_flag.png")
                ImageFlipVertical(imgFlag)
                texFlag = LoadTextureFromImage(imgFlag)
                UnloadImage(imgFlag)
            else
                texFlag = LoadTexture(cPath + "mario_flag.png")
            ok

            texPipe     = LoadTexture(cPath + "pipe_texture.png")
            texKoopa    = LoadTexture(cPath + "koopa_shell.png")

            if fexists(cPath + "pngaaa.com-1578918.png")
                imgGoomba = LoadImage(cPath + "pngaaa.com-1578918.png")
                ImageFlipVertical(imgGoomba)
                texGoomba = LoadTextureFromImage(imgGoomba)
                UnloadImage(imgGoomba)
            ok

            hasTextures = true
        ok
    end

    func createModels
        if !hasTextures return ok

        # 1. Horizontal Unit Planes for tiled surfaces (Grass top, Stone top, Wood plank)
        meshPlane = GenMeshPlane(1.0, 1.0, 1, 1)

        modelGrassPlane = LoadModelFromMesh(meshPlane)
        if texGrass != null
            SetMaterialTexture(modelGrassPlane.materials, 0, texGrass)
        ok

        modelStonePlane = LoadModelFromMesh(meshPlane)
        if texStone != null
            SetMaterialTexture(modelStonePlane.materials, 0, texStone)
        ok

        modelWoodPlane = LoadModelFromMesh(meshPlane)
        if texWood != null
            SetMaterialTexture(modelWoodPlane.materials, 0, texWood)
        ok

        # 2. Perimeter Wall Meshes for platform sides & cliffs
        meshWall = GenMeshCube(1.0, 1.0, 0.05)

        # Grass platform cliff wall (warm Mario earth brick blocks - avoids black shading)
        modelDirtWall = LoadModelFromMesh(meshWall)
        if texBrick != null
            SetMaterialTexture(modelDirtWall.materials, 0, texBrick)
        elseif texDirt != null
            SetMaterialTexture(modelDirtWall.materials, 0, texDirt)
        ok

        # Stone platform side wall (matching stone_tile.png)
        modelStoneWall = LoadModelFromMesh(meshWall)
        if texStone != null
            SetMaterialTexture(modelStoneWall.materials, 0, texStone)
        ok

        # Moving lift side wall (matching wood_plank.png)
        modelWoodWall = LoadModelFromMesh(meshWall)
        if texWood != null
            SetMaterialTexture(modelWoodWall.materials, 0, texWood)
        ok

        # 3. Interactive Block Cubes
        meshCube = GenMeshCube(1.0, 1.0, 1.0)

        modelQuestion = LoadModelFromMesh(meshCube)
        if texQuestion != null
            SetMaterialTexture(modelQuestion.materials, 0, texQuestion)
        ok

        modelBrick = LoadModelFromMesh(meshCube)
        if texBrick != null
            SetMaterialTexture(modelBrick.materials, 0, texBrick)
        ok

        modelUsed = LoadModelFromMesh(meshCube)
        if texUsed != null
            SetMaterialTexture(modelUsed.materials, 0, texUsed)
        ok

        # 4. Mario Emblem Level Flag
        meshFlag = GenMeshCube(1.9, 1.25, 0.04)
        modelFlag = LoadModelFromMesh(meshFlag)
        if texFlag != null
            SetMaterialTexture(modelFlag.materials, 0, texFlag)
        ok

        # 5. Warp Pipe Column
        meshPipe = GenMeshCylinder(1.0, 1.0, 24)
        modelPipeBody = LoadModelFromMesh(meshPipe)
        if texPipe != null
            SetMaterialTexture(modelPipeBody.materials, 0, texPipe)
        ok

        # 6. Koopa Troopa Shell
        meshKoopa = GenMeshSphere(1.0, 16, 16)
        modelKoopaShell = LoadModelFromMesh(meshKoopa)
        if texKoopa != null
            SetMaterialTexture(modelKoopaShell.materials, 0, texKoopa)
        ok

        # 7. Goomba Face Sticker
        meshGoomba = GenMeshCube(0.70, 0.60, 0.02)
        modelGoombaFace = LoadModelFromMesh(meshGoomba)
        if texGoomba != null
            SetMaterialTexture(modelGoombaFace.materials, 0, texGoomba)
        ok

        # 8. Collectible Item Models
        meshCoin = GenMeshCube(0.85, 0.85, 0.06)
        modelCoin = LoadModelFromMesh(meshCoin)
        if texCoin != null
            SetMaterialTexture(modelCoin.materials, 0, texCoin)
        ok

        meshMush = GenMeshCube(1.10, 1.10, 0.06)
        modelMushroom = LoadModelFromMesh(meshMush)
        if texMushroom != null
            SetMaterialTexture(modelMushroom.materials, 0, texMushroom)
        ok

        meshStar = GenMeshCube(1.25, 1.25, 0.06)
        modelStar = LoadModelFromMesh(meshStar)
        if texStar != null
            SetMaterialTexture(modelStar.materials, 0, texStar)
        ok
    end


    # ---------------------------------------------------------------
    # 1. Lush Tiled Grass Floor 
    # ---------------------------------------------------------------
    func drawPlatformGrass pos, sx, sy, sz
        topY = pos.y + sy / 2.0 + 0.005

        if hasTextures and modelGrassPlane != null
            tilesX = floor(sx / tileGridSize)
            if tilesX < 1 tilesX = 1 ok
            tilesZ = floor(sz / tileGridSize)
            if tilesZ < 1 tilesZ = 1 ok

            stepX = sx / tilesX
            stepZ = sz / tilesZ

            startX = pos.x - sx / 2.0 + stepX / 2.0
            startZ = pos.z - sz / 2.0 + stepZ / 2.0

            rotAxis   = Vector3(0, 1, 0)
            tileScale = Vector3(stepX, 1.0, stepZ)

            for ix = 0 to (tilesX - 1)
                for iz = 0 to (tilesZ - 1)
                    tx = startX + ix * stepX
                    tz = startZ + iz * stepZ
                    DrawModelEx(modelGrassPlane, Vector3(tx, topY, tz), rotAxis, 0.0, tileScale, WHITE)
                next
            next
        else
            DrawCube(Vector3(pos.x, topY, pos.z), sx, 0.02, sz, GRASS_GREEN)
        ok
    end

    # ---------------------------------------------------------------
    # 2. Platform Base with Textured Cliff Edges & Walls
    # ---------------------------------------------------------------
    func drawPlatformBase pos, sx, sy, sz, pt
        if pt = 1 # Grass Platform Earth Base with Brick/Soil Edges
            baseH = sy
            baseY = pos.y

            # Solid Warm Earth Core
            DrawCube(Vector3(pos.x, baseY, pos.z), sx - 0.02, baseH, sz - 0.02, DIRT_BROWN)

            if hasTextures and modelDirtWall != null and baseH >= 0.35
                tilesX = ceil(sx / wallGridSize)
                if tilesX < 1 tilesX = 1 ok
                stepX = sx / tilesX
                startX = pos.x - sx / 2.0 + stepX / 2.0
                edgeScaleX = Vector3(stepX, baseH, 1.0)
                edgeZFront = pos.z + sz / 2.0
                edgeZBack  = pos.z - sz / 2.0

                for ix = 0 to (tilesX - 1)
                    tx = startX + ix * stepX
                    DrawModelEx(modelDirtWall, Vector3(tx, baseY, edgeZFront), Vector3(0, 1, 0), 0.0, edgeScaleX, WHITE)
                    DrawModelEx(modelDirtWall, Vector3(tx, baseY, edgeZBack), Vector3(0, 1, 0), 180.0, edgeScaleX, WHITE)
                next

                tilesZ = ceil(sz / wallGridSize)
                if tilesZ < 1 tilesZ = 1 ok
                stepZ = sz / tilesZ
                startZ = pos.z - sz / 2.0 + stepZ / 2.0
                edgeScaleZ = Vector3(stepZ, baseH, 1.0)
                edgeXRight = pos.x + sx / 2.0
                edgeXLeft  = pos.x - sx / 2.0

                for iz = 0 to (tilesZ - 1)
                    tz = startZ + iz * stepZ
                    DrawModelEx(modelDirtWall, Vector3(edgeXRight, baseY, tz), Vector3(0, 1, 0), 90.0, edgeScaleZ, WHITE)
                    DrawModelEx(modelDirtWall, Vector3(edgeXLeft, baseY, tz), Vector3(0, 1, 0), -90.0, edgeScaleZ, WHITE)
                next
            ok

        elseif pt = 2 # Stone Paving Fortress Platform with Cobblestone Edges
            baseH = sy
            baseY = pos.y
            topY  = pos.y + sy / 2.0 + 0.005

            # 1. Top Pavement
            if hasTextures and modelStonePlane != null
                tilesX = ceil(sx / tileGridSize)
                if tilesX < 1 tilesX = 1 ok
                tilesZ = ceil(sz / tileGridSize)
                if tilesZ < 1 tilesZ = 1 ok
                stepX = sx / tilesX
                stepZ = sz / tilesZ
                startX = pos.x - sx / 2.0 + stepX / 2.0
                startZ = pos.z - sz / 2.0 + stepZ / 2.0

                rotAxis   = Vector3(0, 1, 0)
                tileScale = Vector3(stepX, 1.0, stepZ)

                for ix = 0 to (tilesX - 1)
                    for iz = 0 to (tilesZ - 1)
                        tx = startX + ix * stepX
                        tz = startZ + iz * stepZ
                        DrawModelEx(modelStonePlane, Vector3(tx, topY, tz), rotAxis, 0.0, tileScale, WHITE)
                    next
                next
            ok

            # 2. Solid Stone Core
            DrawCube(Vector3(pos.x, baseY, pos.z), sx - 0.02, baseH, sz - 0.02, STONE_BASE)

            # 3. Textured Stone Perimeter Walls
            if hasTextures and modelStoneWall != null and baseH >= 0.35
                tilesX = ceil(sx / wallGridSize)
                if tilesX < 1 tilesX = 1 ok
                stepX = sx / tilesX
                startX = pos.x - sx / 2.0 + stepX / 2.0
                edgeScaleX = Vector3(stepX, baseH, 1.0)
                edgeZFront = pos.z + sz / 2.0
                edgeZBack  = pos.z - sz / 2.0

                for ix = 0 to (tilesX - 1)
                    tx = startX + ix * stepX
                    DrawModelEx(modelStoneWall, Vector3(tx, baseY, edgeZFront), Vector3(0, 1, 0), 0.0, edgeScaleX, WHITE)
                    DrawModelEx(modelStoneWall, Vector3(tx, baseY, edgeZBack), Vector3(0, 1, 0), 180.0, edgeScaleX, WHITE)
                next

                tilesZ = ceil(sz / wallGridSize)
                if tilesZ < 1 tilesZ = 1 ok
                stepZ = sz / tilesZ
                startZ = pos.z - sz / 2.0 + stepZ / 2.0
                edgeScaleZ = Vector3(stepZ, baseH, 1.0)
                edgeXRight = pos.x + sx / 2.0
                edgeXLeft  = pos.x - sx / 2.0

                for iz = 0 to (tilesZ - 1)
                    tz = startZ + iz * stepZ
                    DrawModelEx(modelStoneWall, Vector3(edgeXRight, baseY, tz), Vector3(0, 1, 0), 90.0, edgeScaleZ, WHITE)
                    DrawModelEx(modelStoneWall, Vector3(edgeXLeft, baseY, tz), Vector3(0, 1, 0), -90.0, edgeScaleZ, WHITE)
                next
            ok

        elseif pt = 3 # Mushroom Platform
            stemR = sx * 0.22
            DrawCylinder(Vector3(pos.x, pos.y, pos.z), stemR, stemR * 1.15, sy, 16, CASTLE_WHITE)
            DrawSphere(Vector3(pos.x, pos.y + sy / 2.0, pos.z), sx * 0.48, MARIO_RED)

        elseif pt = 4 # Timber Wood Planks (Moving Lifts)
            baseH = sy
            baseY = pos.y
            topY  = pos.y + sy / 2.0 + 0.005

            # 1. Top Timber Surface
            if hasTextures and modelWoodPlane != null
                tilesX = ceil(sx / tileGridSize)
                if tilesX < 1 tilesX = 1 ok
                tilesZ = ceil(sz / tileGridSize)
                if tilesZ < 1 tilesZ = 1 ok
                stepX = sx / tilesX
                stepZ = sz / tilesZ
                startX = pos.x - sx / 2.0 + stepX / 2.0
                startZ = pos.z - sz / 2.0 + stepZ / 2.0

                tileScale = Vector3(stepX, 1.0, stepZ)
                for ix = 0 to (tilesX - 1)
                    for iz = 0 to (tilesZ - 1)
                        tx = startX + ix * stepX
                        tz = startZ + iz * stepZ
                        DrawModelEx(modelWoodPlane, Vector3(tx, topY, tz), Vector3(0, 1, 0), 0.0, tileScale, WHITE)
                    next
                next
            ok

            # 2. Solid Timber Core
            DrawCube(Vector3(pos.x, baseY, pos.z), sx - 0.02, baseH, sz - 0.02, RAYLibColor(165, 105, 55, 255))

            # 3. Textured Timber Perimeter Walls
            if hasTextures and modelWoodWall != null and baseH >= 0.20
                tilesX = ceil(sx / wallGridSize)
                if tilesX < 1 tilesX = 1 ok
                stepX = sx / tilesX
                startX = pos.x - sx / 2.0 + stepX / 2.0
                edgeScaleX = Vector3(stepX, baseH, 1.0)
                edgeZFront = pos.z + sz / 2.0
                edgeZBack  = pos.z - sz / 2.0

                for ix = 0 to (tilesX - 1)
                    tx = startX + ix * stepX
                    DrawModelEx(modelWoodWall, Vector3(tx, baseY, edgeZFront), Vector3(0, 1, 0), 0.0, edgeScaleX, WHITE)
                    DrawModelEx(modelWoodWall, Vector3(tx, baseY, edgeZBack), Vector3(0, 1, 0), 180.0, edgeScaleX, WHITE)
                next

                tilesZ = ceil(sz / wallGridSize)
                if tilesZ < 1 tilesZ = 1 ok
                stepZ = sz / tilesZ
                startZ = pos.z - sz / 2.0 + stepZ / 2.0
                edgeScaleZ = Vector3(stepZ, baseH, 1.0)
                edgeXRight = pos.x + sx / 2.0
                edgeXLeft  = pos.x - sx / 2.0

                for iz = 0 to (tilesZ - 1)
                    tz = startZ + iz * stepZ
                    DrawModelEx(modelWoodWall, Vector3(edgeXRight, baseY, tz), Vector3(0, 1, 0), 90.0, edgeScaleZ, WHITE)
                    DrawModelEx(modelWoodWall, Vector3(edgeXLeft, baseY, tz), Vector3(0, 1, 0), -90.0, edgeScaleZ, WHITE)
                next
            ok
        ok
    end

    # ---------------------------------------------------------------
    # 3. Interactive Blocks (Question, Brick, Used)
    # ---------------------------------------------------------------
    func drawQuestionBlock pos, sz
        if hasTextures and modelQuestion != null
            DrawModel(modelQuestion, pos, sz, WHITE)
        else
            DrawCube(pos, sz, sz, sz, BLOCK_QUESTION)
            DrawCubeWires(pos, sz, sz, sz, RAYLibColor(185, 125, 10, 255))
        ok
    end

    func drawBrickBlock pos, sz
        if hasTextures and modelBrick != null
            DrawModel(modelBrick, pos, sz, WHITE)
        else
            DrawCube(pos, sz, sz, sz, BLOCK_BRICK)
            DrawCubeWires(pos, sz, sz, sz, RAYLibColor(135, 45, 20, 255))
        ok
    end

    func drawUsedBlock pos, sz
        if hasTextures and modelUsed != null
            DrawModel(modelUsed, pos, sz, WHITE)
        else
            DrawCube(pos, sz, sz, sz, BLOCK_USED)
            DrawCubeWires(pos, sz, sz, sz, RAYLibColor(80, 70, 65, 255))
        ok
    end

    # ---------------------------------------------------------------
    # 4. True 3D Items (Super Mushroom, Power Star, Gold Coin)
    # Authentic 3D geometry - No flat quads, no transparency artifacts!
    # ---------------------------------------------------------------
    func drawItemMushroom p1, p2, p3
        pos = p1
        sz  = p2
        spinAngle = p3
        if !isNumber(p2) and isNumber(p3)
            pos = p2
            sz  = p3
            spinAngle = 0.0
        ok
        if spinAngle = null spinAngle = 0.0 ok

        if hasTextures and modelMushroom != null
            DrawModelEx(modelMushroom, Vector3(pos.x, pos.y + sz * 0.45, pos.z), Vector3(0, 1, 0), spinAngle, Vector3(sz, sz, sz), WHITE)
        else
            s = sz / 1.2
            baseY = pos.y
            stemH = 0.38 * s
            stemR = 0.28 * s
            DrawCylinder(Vector3(pos.x, baseY + stemH / 2.0, pos.z), stemR, stemR * 0.90, stemH, 16, CASTLE_WHITE)
            rad = spinAngle * DEG2RAD
            fwdX = sin(rad)
            fwdZ = cos(rad)
            rgtX = cos(rad)
            rgtZ = -sin(rad)
            eyeOff = 0.10 * s
            eyeDist = stemR * 0.95
            eyeY = baseY + stemH * 0.55
            DrawSphere(Vector3(pos.x + fwdX * eyeDist - rgtX * eyeOff, eyeY, pos.z + fwdZ * eyeDist - rgtZ * eyeOff), 0.055 * s, BLACK)
            DrawSphere(Vector3(pos.x + fwdX * eyeDist + rgtX * eyeOff, eyeY, pos.z + fwdZ * eyeDist + rgtZ * eyeOff), 0.055 * s, BLACK)
            capY = baseY + stemH + 0.14 * s
            capR = 0.54 * s
            DrawSphere(Vector3(pos.x, capY, pos.z), capR, MARIO_RED)
            DrawSphere(Vector3(pos.x, capY + capR * 0.82, pos.z), capR * 0.42, CASTLE_WHITE)
            spotDist = capR * 0.88
            DrawSphere(Vector3(pos.x + fwdX * spotDist, capY + 0.04 * s, pos.z + fwdZ * spotDist), capR * 0.36, CASTLE_WHITE)
            DrawSphere(Vector3(pos.x - fwdX * spotDist, capY + 0.04 * s, pos.z - fwdZ * spotDist), capR * 0.36, CASTLE_WHITE)
            DrawSphere(Vector3(pos.x + rgtX * spotDist, capY + 0.04 * s, pos.z + rgtZ * spotDist), capR * 0.36, CASTLE_WHITE)
            DrawSphere(Vector3(pos.x - rgtX * spotDist, capY + 0.04 * s, pos.z - rgtZ * spotDist), capR * 0.36, CASTLE_WHITE)
        ok
    end

    func drawItemStar p1, p2, p3
        pos = p1
        sz  = p2
        spinAngle = p3
        if !isNumber(p2) and isNumber(p3)
            pos = p2
            sz  = p3
            spinAngle = 0.0
        ok
        if spinAngle = null spinAngle = 0.0 ok

        if hasTextures and modelStar != null
            DrawModelEx(modelStar, Vector3(pos.x, pos.y + sz * 0.50, pos.z), Vector3(0, 1, 0), spinAngle, Vector3(sz, sz, sz), WHITE)
        else
            s = sz / 1.2
            DrawSphere(Vector3(pos.x, pos.y + 0.45 * s, pos.z), 0.50 * s, GOLD_SHINE)
            DrawSphere(Vector3(pos.x, pos.y + 0.45 * s, pos.z), 0.35 * s, MARIO_YELLOW)
            for sp = 0 to 4
                pAng = (spinAngle + sp * 72.0) * DEG2RAD
                ptX = pos.x + cos(pAng) * 0.68 * s
                ptZ = pos.z + sin(pAng) * 0.68 * s
                DrawSphere(Vector3(ptX, pos.y + 0.45 * s, ptZ), 0.28 * s, GOLD_SHINE)
                DrawSphere(Vector3(ptX, pos.y + 0.45 * s, ptZ), 0.18 * s, MARIO_YELLOW)
            next
            rad = spinAngle * DEG2RAD
            fwdX = sin(rad)
            fwdZ = cos(rad)
            rgtX = cos(rad)
            rgtZ = -sin(rad)
            eyeDist = 0.46 * s
            eyeOff = 0.10 * s
            eyeY = pos.y + 0.52 * s
            DrawSphere(Vector3(pos.x + fwdX * eyeDist - rgtX * eyeOff, eyeY, pos.z + fwdZ * eyeDist - rgtZ * eyeOff), 0.065 * s, BLACK)
            DrawSphere(Vector3(pos.x + fwdX * eyeDist + rgtX * eyeOff, eyeY, pos.z + fwdZ * eyeDist + rgtZ * eyeOff), 0.065 * s, BLACK)
        ok
    end

    func drawItemCoin p1, p2, p3
        pos = p1
        sz  = p2
        spinAngle = p3
        if !isNumber(p2) and isNumber(p3)
            pos = p2
            sz  = p3
            spinAngle = 0.0
        ok
        if spinAngle = null spinAngle = 0.0 ok

        if hasTextures and modelCoin != null
            DrawModelEx(modelCoin, pos, Vector3(0, 1, 0), spinAngle, Vector3(sz, sz, sz), WHITE)
        else
            cRadius = sz * 0.44
            cThick  = 0.10
            DrawCylinder(pos, cRadius, cRadius, cThick, 16, MARIO_YELLOW)
            DrawCylinderWires(pos, cRadius, cRadius, cThick, 16, RAYLibColor(200, 150, 15, 255))
            DrawCylinder(pos, cRadius * 0.70, cRadius * 0.70, cThick + 0.02, 12, GOLD_SHINE)
        ok
    end

    # ---------------------------------------------------------------
    # 5. Mario Emblem Level Flag 
    # ---------------------------------------------------------------
    func drawFlag pos, sx, sy, sz
        if hasTextures and modelFlag != null
            scaleX = sx / 1.9
            scaleY = sy / 1.25
            DrawModelEx(modelFlag, pos, Vector3(0, 1, 0), 0.0, Vector3(scaleX, scaleY, 1.0), WHITE)
            DrawSphere(Vector3(pos.x - sx / 2.0, pos.y + sy / 2.0, pos.z), 0.18, GOLD_SHINE)
        else
            DrawCube(pos, sx, sy, 0.04, MARIO_RED)
            DrawCubeWires(pos, sx, sy, 0.04, RAYLibColor(180, 20, 20, 255))
            emblemR = sy * 0.32
            DrawSphere(Vector3(pos.x, pos.y, pos.z + 0.02), emblemR, CASTLE_WHITE)
            DrawSphere(Vector3(pos.x, pos.y, pos.z - 0.02), emblemR, CASTLE_WHITE)
            DrawSphere(Vector3(pos.x - sx / 2.0, pos.y + sy / 2.0, pos.z), 0.18, GOLD_SHINE)
        ok
    end

    # ---------------------------------------------------------------
    # 6. Warp Pipe 
    # ---------------------------------------------------------------
    func drawPipe px, py, pz, pr, ph
        if hasTextures and modelPipeBody != null
            bodyH = ph * 0.90
            bodyY = py + bodyH / 2.0
            DrawModelEx(modelPipeBody, Vector3(px, bodyY, pz), Vector3(0, 1, 0), 0.0, Vector3(pr * 0.90, bodyH, pr * 0.90), WHITE)
            DrawCylinderWires(Vector3(px, bodyY, pz), pr * 0.90, pr * 0.90, bodyH, 24, PIPE_DARK)

            lipH = 0.52
            lipY = py + ph - lipH / 2.0
            DrawModelEx(modelPipeBody, Vector3(px, lipY, pz), Vector3(0, 1, 0), 0.0, Vector3(pr * 1.10, lipH, pr * 1.10), WHITE)
            DrawCylinderWires(Vector3(px, lipY, pz), pr * 1.10, pr * 1.10, lipH, 24, PIPE_DARK)

            DrawCylinder(Vector3(px, py + ph + 0.02, pz), pr * 0.75, pr * 0.75, 0.06, 24, BLACK)
        else
            DrawCylinder(Vector3(px, py + ph * 0.45, pz), pr * 0.90, pr * 0.90, ph * 0.90, 24, PIPE_GREEN)
            DrawCylinderWires(Vector3(px, py + ph * 0.45, pz), pr * 0.90, pr * 0.90, ph * 0.90, 24, PIPE_DARK)
            lipH = 0.52
            lipY = py + ph - lipH / 2.0
            DrawCylinder(Vector3(px, lipY, pz), pr * 1.10, pr * 1.10, lipH, 24, PIPE_GREEN)
            DrawCylinder(Vector3(px, py + ph + 0.02, pz), pr * 0.75, pr * 0.75, 0.06, 24, BLACK)
        ok
    end

    # ---------------------------------------------------------------
    # 7. Koopa Shell 
    # ---------------------------------------------------------------
    func drawKoopaShell pos, rad
        if hasTextures and modelKoopaShell != null
            DrawModelEx(modelKoopaShell, pos, Vector3(0, 1, 0), 0.0, Vector3(rad, rad, rad), WHITE)
        else
            DrawSphere(pos, rad, KOOPA_GREEN)
        ok
    end

    # ---------------------------------------------------------------
    # 8. Goomba Face Sticker 
    # ---------------------------------------------------------------
    func drawGoombaFace pos, rotY
        if hasTextures and modelGoombaFace != null
            DrawModelEx(modelGoombaFace, pos, Vector3(0, 1, 0), rotY, Vector3(1.0, 1.0, 1.0), WHITE)
        ok
    end

    # ---------------------------------------------------------------
    # 9. Resource Cleanup
    # ---------------------------------------------------------------
    func cleanup
        if !hasTextures return ok

        if texGrass != null UnloadTexture(texGrass) ok
        if texDirt != null UnloadTexture(texDirt) ok
        if texStone != null UnloadTexture(texStone) ok
        if texWood != null UnloadTexture(texWood) ok
        if texQuestion != null UnloadTexture(texQuestion) ok
        if texBrick != null UnloadTexture(texBrick) ok
        if texUsed != null UnloadTexture(texUsed) ok
        if texCoin != null UnloadTexture(texCoin) ok
        if texMushroom != null UnloadTexture(texMushroom) ok
        if texStar != null UnloadTexture(texStar) ok
        if texFlag != null UnloadTexture(texFlag) ok
        if texPipe != null UnloadTexture(texPipe) ok
        if texKoopa != null UnloadTexture(texKoopa) ok
        if texGoomba != null UnloadTexture(texGoomba) ok

        if modelGrassPlane != null UnloadModel(modelGrassPlane) ok
        if modelDirtWall != null UnloadModel(modelDirtWall) ok
        if modelStonePlane != null UnloadModel(modelStonePlane) ok
        if modelStoneWall != null UnloadModel(modelStoneWall) ok
        if modelWoodPlane != null UnloadModel(modelWoodPlane) ok
        if modelWoodWall != null UnloadModel(modelWoodWall) ok
        if modelQuestion != null UnloadModel(modelQuestion) ok
        if modelBrick != null UnloadModel(modelBrick) ok
        if modelUsed != null UnloadModel(modelUsed) ok
        if modelFlag != null UnloadModel(modelFlag) ok
        if modelPipeBody != null UnloadModel(modelPipeBody) ok
        if modelKoopaShell != null UnloadModel(modelKoopaShell) ok
        if modelGoombaFace != null UnloadModel(modelGoombaFace) ok
        if modelCoin != null UnloadModel(modelCoin) ok
        if modelMushroom != null UnloadModel(modelMushroom) ok
        if modelStar != null UnloadModel(modelStar) ok
    end
end
