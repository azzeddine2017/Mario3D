#===================================================================#
# Mario 3D - Texture & 3D Material Manager Subsystem
# Hardware-Accelerated 3D Models & Billboard Renderers
#===================================================================#

class MarioTextureManager
    hasTextures

    # Texture2D Handles
    texGrassTop
    texDirtSide
    texStoneTile
    texWoodPlank
    texQuestion
    texBrick
    texUsed
    texPipe
    texCoin
    texMushroom
    texStar
    texFlag
    texKoopaShell

    # 3D Mesh Models
    modelQuestion
    modelBrick
    modelUsed
    modelGrass
    modelDirt
    modelStone
    modelWood
    modelFlag

    func init
        hasTextures     = false
        texGrassTop     = null
        texDirtSide     = null
        texStoneTile    = null
        texWoodPlank    = null
        texQuestion     = null
        texBrick        = null
        texUsed         = null
        texPipe         = null
        texCoin         = null
        texMushroom     = null
        texStar         = null
        texFlag         = null
        texKoopaShell   = null

        modelQuestion   = null
        modelBrick      = null
        modelUsed       = null
        modelGrass      = null
        modelDirt       = null
        modelStone      = null
        modelWood       = null
        modelFlag       = null

        loadTexturesAndModels()
        return self
    end

    func loadTexturesAndModels
        # 1. Load 2D Textures with Bilinear Filtering
        if fexists("Assets/textures/grass_top.png")
            texGrassTop = LoadTexture("Assets/textures/grass_top.png")
            SetTextureFilter(texGrassTop, 1)
        ok
        if fexists("Assets/textures/dirt_side.png")
            texDirtSide = LoadTexture("Assets/textures/dirt_side.png")
            SetTextureFilter(texDirtSide, 1)
        ok
        if fexists("Assets/textures/stone_tile.png")
            texStoneTile = LoadTexture("Assets/textures/stone_tile.png")
            SetTextureFilter(texStoneTile, 1)
        ok
        if fexists("Assets/textures/wood_plank.png")
            texWoodPlank = LoadTexture("Assets/textures/wood_plank.png")
            SetTextureFilter(texWoodPlank, 1)
        ok

        if fexists("Assets/textures/question_block.png")
            try
                imgQ = LoadImage("Assets/textures/question_block.png")
                ImageFlipVertical(imgQ)
                texQuestion = LoadTextureFromImage(imgQ)
                UnloadImage(imgQ)
            catch
                texQuestion = LoadTexture("Assets/textures/question_block.png")
            done
            SetTextureFilter(texQuestion, 1)
        ok
        if fexists("Assets/textures/brick_block.png")
            texBrick = LoadTexture("Assets/textures/brick_block.png")
            SetTextureFilter(texBrick, 1)
        ok
        if fexists("Assets/textures/block_used.png")
            try
                imgU = LoadImage("Assets/textures/block_used.png")
                ImageFlipVertical(imgU)
                texUsed = LoadTextureFromImage(imgU)
                UnloadImage(imgU)
            catch
                texUsed = LoadTexture("Assets/textures/block_used.png")
            done
            SetTextureFilter(texUsed, 1)
        ok

        if fexists("Assets/textures/pipe_texture.png")
            texPipe = LoadTexture("Assets/textures/pipe_texture.png")
            SetTextureFilter(texPipe, 1)
        ok
        if fexists("Assets/textures/coin.png")
            texCoin = LoadTexture("Assets/textures/coin.png")
            SetTextureFilter(texCoin, 1)
        ok
        if fexists("Assets/textures/super_mushroom.png")
            texMushroom = LoadTexture("Assets/textures/super_mushroom.png")
            SetTextureFilter(texMushroom, 1)
        ok
        if fexists("Assets/textures/power_star.png")
            texStar = LoadTexture("Assets/textures/power_star.png")
            SetTextureFilter(texStar, 1)
        ok
        if fexists("Assets/textures/mario_flag.png")
            texFlag = LoadTexture("Assets/textures/mario_flag.png")
            SetTextureFilter(texFlag, 1)
        ok
        if fexists("Assets/textures/koopa_shell.png")
            texKoopaShell = LoadTexture("Assets/textures/koopa_shell.png")
            SetTextureFilter(texKoopaShell, 1)
        ok

        # 2. Build 3D Models with Texture Materials
        try
            if texQuestion != null
                modelQuestion = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelQuestion, 0, MAP_DIFFUSE, texQuestion)
            ok
            if texBrick != null
                modelBrick = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelBrick, 0, MAP_DIFFUSE, texBrick)
            ok
            if texUsed != null
                modelUsed = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelUsed, 0, MAP_DIFFUSE, texUsed)
            ok
            if texGrassTop != null
                modelGrass = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelGrass, 0, MAP_DIFFUSE, texGrassTop)
            ok
            if texDirtSide != null
                modelDirt = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelDirt, 0, MAP_DIFFUSE, texDirtSide)
            ok
            if texStoneTile != null
                modelStone = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelStone, 0, MAP_DIFFUSE, texStoneTile)
            ok
            if texWoodPlank != null
                modelWood = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelWood, 0, MAP_DIFFUSE, texWoodPlank)
            ok
            if texFlag != null
                modelFlag = LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0))
                setmodelmaterialtexture(modelFlag, 0, MAP_DIFFUSE, texFlag)
            ok
        catch
            # Fallback to standard procedural shaders if GPU model allocation fails
        done

        hasTextures = true
    end

    # ---------------------------------------------------------------
    # High-Performance 3D Drawing Methods
    # ---------------------------------------------------------------
    func drawQuestionBlock pos, sz
        if modelQuestion != null
            DrawModelEx(modelQuestion, pos, Vector3(0, 1, 0), 0.0, Vector3(sz, sz, sz), WHITE)
        else
            DrawCube(pos, sz, sz, sz, BLOCK_QUESTION)
            DrawCubeWires(pos, sz, sz, sz, BLACK)
        ok
    end

    func drawBrickBlock pos, sz
        if modelBrick != null
            DrawModelEx(modelBrick, pos, Vector3(0, 1, 0), 0.0, Vector3(sz, sz, sz), WHITE)
        else
            DrawCube(pos, sz, sz, sz, BLOCK_BRICK)
            DrawCubeWires(pos, sz, sz, sz, BLACK)
        ok
    end

    func drawUsedBlock pos, sz
        if modelUsed != null
            DrawModelEx(modelUsed, pos, Vector3(0, 1, 0), 0.0, Vector3(sz, sz, sz), WHITE)
        else
            DrawCube(pos, sz, sz, sz, BLOCK_USED)
            DrawCubeWires(pos, sz, sz, sz, BLACK)
        ok
    end

    func drawPlatformBase pos, sx, sy, sz, pt
        if pt = 1 and modelDirt != null
            DrawModelEx(modelDirt, pos, Vector3(0, 1, 0), 0.0, Vector3(sx, sy, sz), WHITE)
        elseif pt = 2 and modelStone != null
            DrawModelEx(modelStone, pos, Vector3(0, 1, 0), 0.0, Vector3(sx, sy, sz), WHITE)
        elseif pt = 4 and modelWood != null
            DrawModelEx(modelWood, pos, Vector3(0, 1, 0), 0.0, Vector3(sx, sy, sz), WHITE)
        else
            col = DIRT_BROWN
            if pt = 2 col = STONE_DARK ok
            if pt = 4 col = DIRT_BROWN ok
            DrawCube(pos, sx, sy, sz, col)
            DrawCubeWires(pos, sx, sy, sz, DIRT_DARK)
        ok
    end

    func drawPlatformGrass pos, sx, sy, sz
        if modelGrass != null
            DrawModelEx(modelGrass, pos, Vector3(0, 1, 0), 0.0, Vector3(sx, sy, sz), WHITE)
        else
            DrawCube(pos, sx, sy, sz, GRASS_GREEN)
            DrawCubeWires(pos, sx, sy, sz, RAYLibColor(35, 115, 20, 180))
        ok
    end

    func drawFlag pos, sx, sy, sz
        if modelFlag != null
            DrawModelEx(modelFlag, pos, Vector3(0, 1, 0), 0.0, Vector3(sx, sy, sz), WHITE)
        else
            DrawCube(pos, sx, sy, sz, GRASS_GREEN)
        ok
    end

    func drawBillboardSafe camObj, texture, pos, bSize, tintCol
        if texture = null or camObj = null return ok
        try
            cData = camObj.data()
            origTag = cData[2]
            cData[2] = "Camera"
            DrawBillboard_2(cData, GPData(texture), GPData(pos), bSize, tintCol)
            cData[2] = origTag
        catch
            # Fallback if billboard drawing is unsupported
        done
    end

    func cleanup
        if modelQuestion != null UnloadModel(modelQuestion) ok
        if modelBrick != null    UnloadModel(modelBrick) ok
        if modelUsed != null     UnloadModel(modelUsed) ok
        if modelGrass != null    UnloadModel(modelGrass) ok
        if modelDirt != null     UnloadModel(modelDirt) ok
        if modelStone != null    UnloadModel(modelStone) ok
        if modelWood != null     UnloadModel(modelWood) ok
        if modelFlag != null     UnloadModel(modelFlag) ok

        if texGrassTop != null   UnloadTexture(texGrassTop) ok
        if texDirtSide != null   UnloadTexture(texDirtSide) ok
        if texStoneTile != null  UnloadTexture(texStoneTile) ok
        if texWoodPlank != null  UnloadTexture(texWoodPlank) ok
        if texQuestion != null   UnloadTexture(texQuestion) ok
        if texBrick != null      UnloadTexture(texBrick) ok
        if texUsed != null       UnloadTexture(texUsed) ok
        if texPipe != null       UnloadTexture(texPipe) ok
        if texCoin != null       UnloadTexture(texCoin) ok
        if texMushroom != null   UnloadTexture(texMushroom) ok
        if texStar != null       UnloadTexture(texStar) ok
        if texFlag != null       UnloadTexture(texFlag) ok
        if texKoopaShell != null UnloadTexture(texKoopaShell) ok
    end
end
