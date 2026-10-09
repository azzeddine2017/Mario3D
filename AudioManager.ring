#===================================================================#
# Mario 3D - Audio Subsystem (Music & Sound Effects)
# Integrated Nintendo Sound Effects & Background Music
#===================================================================#

class MarioAudioManager
    hasAudio        = false
    hasMusic        = false

    # Sound Handles
    sndJump         = null
    sndDoubleJump   = null
    sndTripleJump   = null
    sndYahoo        = null
    sndYahoo3       = null
    sndGroundPound  = null
    sndQuake        = null
    sndStomp        = null
    sndCoin         = null
    sndBump         = null
    sndBreak        = null
    sndDamage       = null
    sndClear        = null
    sndSkid         = null
    sndPause        = null
    sndPowerUp      = null
    sndPowerDown    = null
    sndPipe         = null
    sndKick         = null
    sndCheckpoint   = null
    sndItemAppear   = null
    sndStarGet      = null

    # Music Stream Handle
    bgmMusic        = null

    func init
        if !IsAudioDeviceReady()
            InitAudioDevice()
        ok
        hasAudio = IsAudioDeviceReady()

        loadSounds()
        loadMusic()
    end

    func loadSounds
        if !hasAudio return ok

        # Jump Sounds
        if fexists("Assets/sounds/WU_SE_PLY_JUMP_HIGH_.wav")
            sndJump = LoadSound("Assets/sounds/WU_SE_PLY_JUMP_HIGH_.wav")
            SetSoundVolume(sndJump, 0.7)
        ok
        if fexists("Assets/sounds/WU_SE_PLY_2NDJUMP_.wav")
            sndDoubleJump = LoadSound("Assets/sounds/WU_SE_PLY_2NDJUMP_.wav")
            SetSoundVolume(sndDoubleJump, 0.75)
        ok
        if fexists("Assets/sounds/WU_SE_PLY_3RDJUMP.wav")
            sndTripleJump = LoadSound("Assets/sounds/WU_SE_PLY_3RDJUMP.wav")
            SetSoundVolume(sndTripleJump, 0.85)
        ok
        if fexists("Assets/sounds/WU_SE_VOC_MA_JUMP_2ND.wav")
            sndYahoo = LoadSound("Assets/sounds/WU_SE_VOC_MA_JUMP_2ND.wav")
            SetSoundVolume(sndYahoo, 0.85)
        ok
        if fexists("Assets/sounds/WU_SE_VOC_MA_JUMP_3RD2.wav")
            sndYahoo3 = LoadSound("Assets/sounds/WU_SE_VOC_MA_JUMP_3RD2.wav")
            SetSoundVolume(sndYahoo3, 0.95)
        ok

        # Ground Pound / Hip Attack
        if fexists("Assets/sounds/WU_SE_PLY_HIP_ATTACK.wav")
            sndGroundPound = LoadSound("Assets/sounds/WU_SE_PLY_HIP_ATTACK.wav")
            SetSoundVolume(sndGroundPound, 0.85)
        ok
        if fexists("Assets/sounds/WU_SE_VOC_MA_QUAKE.wav")
            sndQuake = LoadSound("Assets/sounds/WU_SE_VOC_MA_QUAKE.wav")
            SetSoundVolume(sndQuake, 0.9)
        ok

        # Stomp Enemy Sound
        if fexists("Assets/sounds/WU_SE_EMY_FUMU_1.wav")
            sndStomp = LoadSound("Assets/sounds/WU_SE_EMY_FUMU_1.wav")
            SetSoundVolume(sndStomp, 0.85)
        elseif fexists("Assets/sounds/SE_BOSS_CMN_STOMPED.wav")
            sndStomp = LoadSound("Assets/sounds/SE_BOSS_CMN_STOMPED.wav")
            SetSoundVolume(sndStomp, 0.85)
        ok

        # Shell Kick
        if fexists("Assets/sounds/WU_SE_EMY_KAME_KERU.wav")
            sndKick = LoadSound("Assets/sounds/WU_SE_EMY_KAME_KERU.wav")
            SetSoundVolume(sndKick, 0.9)
        ok

        # Warp Pipe
        if fexists("Assets/sounds/WU_SE_PLY_DOKAN_IN_OUT.wav")
            sndPipe = LoadSound("Assets/sounds/WU_SE_PLY_DOKAN_IN_OUT.wav")
            SetSoundVolume(sndPipe, 0.85)
        ok

        # Power Up / Power Down
        if fexists("Assets/sounds/WU_SE_PLY_CHANGE_BIG.wav")
            sndPowerUp = LoadSound("Assets/sounds/WU_SE_PLY_CHANGE_BIG.wav")
            SetSoundVolume(sndPowerUp, 0.9)
        ok
        if fexists("Assets/sounds/WU_SE_PLY_CHANGE_SMALL.wav")
            sndPowerDown = LoadSound("Assets/sounds/WU_SE_PLY_CHANGE_SMALL.wav")
            SetSoundVolume(sndPowerDown, 0.9)
        ok
        if fexists("Assets/sounds/WU_SE_OBJ_ITEM_APPEAR.wav")
            sndItemAppear = LoadSound("Assets/sounds/WU_SE_OBJ_ITEM_APPEAR.wav")
            SetSoundVolume(sndItemAppear, 0.85)
        ok

        # Checkpoint Flag
        if fexists("Assets/sounds/SE_VOC_MA_TYUKAN.wav")
            sndCheckpoint = LoadSound("Assets/sounds/SE_VOC_MA_TYUKAN.wav")
            SetSoundVolume(sndCheckpoint, 0.95)
        ok

        # Coin Collection Sound
        if fexists("Assets/sounds/WU_SE_OBJ_GET_COIN.wav")
            sndCoin = LoadSound("Assets/sounds/WU_SE_OBJ_GET_COIN.wav")
            SetSoundVolume(sndCoin, 0.8)
        ok

        # Block Hit & Brick Break
        if fexists("Assets/sounds/WU_SE_PLY_HIT_BLOCK_BOUND.wav")
            sndBump = LoadSound("Assets/sounds/WU_SE_PLY_HIT_BLOCK_BOUND.wav")
            SetSoundVolume(sndBump, 0.75)
        ok
        if fexists("Assets/sounds/WU_SE_OBJ_BLOCK_BREAK.wav")
            sndBreak = LoadSound("Assets/sounds/WU_SE_OBJ_BLOCK_BREAK.wav")
            SetSoundVolume(sndBreak, 0.8)
        ok

        # Mario Hurt / Voice Damage
        if fexists("Assets/sounds/WU_SE_VOC_MA_DAMAGE_LAST.wav")
            sndDamage = LoadSound("Assets/sounds/WU_SE_VOC_MA_DAMAGE_LAST.wav")
            SetSoundVolume(sndDamage, 0.9)
        ok

        # Level Complete Celebration
        if fexists("Assets/sounds/course_clear.fs.32.wav")
            sndClear = LoadSound("Assets/sounds/course_clear.fs.32.wav")
            SetSoundVolume(sndClear, 0.95)
        elseif fexists("Assets/sounds/WU_SE_SYS_GOAL_FLAG.wav")
            sndClear = LoadSound("Assets/sounds/WU_SE_SYS_GOAL_FLAG.wav")
            SetSoundVolume(sndClear, 0.95)
        ok
        if fexists("Assets/sounds/WU_SE_VOC_MA_GET_STAR0.wav")
            sndStarGet = LoadSound("Assets/sounds/WU_SE_VOC_MA_GET_STAR0.wav")
            SetSoundVolume(sndStarGet, 0.95)
        ok

        # Skidding & Sliding
        if fexists("Assets/sounds/WU_SE_PLY_SLIP.wav")
            sndSkid = LoadSound("Assets/sounds/WU_SE_PLY_SLIP.wav")
            SetSoundVolume(sndSkid, 0.55)
        ok

        # Pause
        if fexists("Assets/sounds/WU_SE_SYS_PAUSE_.wav")
            sndPause = LoadSound("Assets/sounds/WU_SE_SYS_PAUSE_.wav")
            SetSoundVolume(sndPause, 0.7)
        ok
    end

    func loadMusic
        if !hasAudio return ok

        # Try World theme first, then Title theme
        musicPath = ""
        if fexists("Assets/music/World2.mp3")
            musicPath = "Assets/music/World2.mp3"
        elseif fexists("Assets/music/Title_Theme.mp3")
            musicPath = "Assets/music/Title_Theme.mp3"
        ok

        if musicPath != ""
            try
                bgmMusic = LoadMusicStream(musicPath)
                SetMusicVolume(bgmMusic, 0.55)
                PlayMusicStream(bgmMusic)
                hasMusic = true
            catch
                hasMusic = false
            done
        ok
    end

    func update
        if hasMusic and bgmMusic != null
            UpdateMusicStream(bgmMusic)
        ok
    end

    func playJump
        if sndJump != null PlaySound(sndJump) ok
    end

    func playDoubleJump
        if sndDoubleJump != null PlaySound(sndDoubleJump) ok
        if sndYahoo != null PlaySound(sndYahoo) ok
    end

    func playTripleJump
        if sndTripleJump != null PlaySound(sndTripleJump) ok
        if sndYahoo3 != null PlaySound(sndYahoo3) ok
    end

    func playGroundPound
        if sndGroundPound != null PlaySound(sndGroundPound) ok
    end

    func playQuake
        if sndQuake != null PlaySound(sndQuake) ok
    end

    func playStomp
        if sndStomp != null PlaySound(sndStomp) ok
    end

    func playKick
        if sndKick != null PlaySound(sndKick) ok
    end

    func playPipe
        if sndPipe != null PlaySound(sndPipe) ok
    end

    func playPowerUp
        if sndPowerUp != null PlaySound(sndPowerUp) ok
    end

    func playPowerDown
        if sndPowerDown != null PlaySound(sndPowerDown) ok
    end

    func playItemAppear
        if sndItemAppear != null PlaySound(sndItemAppear) ok
    end

    func playCheckpoint
        if sndCheckpoint != null PlaySound(sndCheckpoint) ok
    end

    func playCoin
        if sndCoin != null PlaySound(sndCoin) ok
    end

    func playBump
        if sndBump != null PlaySound(sndBump) ok
    end

    func playBreak
        if sndBreak != null PlaySound(sndBreak) ok
    end

    func playDamage
        if sndDamage != null PlaySound(sndDamage) ok
    end

    func playClear
        if sndClear != null PlaySound(sndClear) ok
        if sndStarGet != null PlaySound(sndStarGet) ok
    end

    func playSkid
        if sndSkid != null and !IsSoundPlaying(sndSkid)
            PlaySound(sndSkid)
        ok
    end

    func playPause
        if sndPause != null PlaySound(sndPause) ok
    end

    func resumeMusic
        if hasMusic and bgmMusic != null
            PlayMusicStream(bgmMusic)
        ok
    end

    func cleanup
        if !hasAudio return ok
        if sndJump != null UnloadSound(sndJump) ok
        if sndDoubleJump != null UnloadSound(sndDoubleJump) ok
        if sndTripleJump != null UnloadSound(sndTripleJump) ok
        if sndYahoo != null UnloadSound(sndYahoo) ok
        if sndYahoo3 != null UnloadSound(sndYahoo3) ok
        if sndGroundPound != null UnloadSound(sndGroundPound) ok
        if sndQuake != null UnloadSound(sndQuake) ok
        if sndStomp != null UnloadSound(sndStomp) ok
        if sndKick != null UnloadSound(sndKick) ok
        if sndPipe != null UnloadSound(sndPipe) ok
        if sndPowerUp != null UnloadSound(sndPowerUp) ok
        if sndPowerDown != null UnloadSound(sndPowerDown) ok
        if sndItemAppear != null UnloadSound(sndItemAppear) ok
        if sndCheckpoint != null UnloadSound(sndCheckpoint) ok
        if sndCoin != null UnloadSound(sndCoin) ok
        if sndBump != null UnloadSound(sndBump) ok
        if sndBreak != null UnloadSound(sndBreak) ok
        if sndDamage != null UnloadSound(sndDamage) ok
        if sndClear != null UnloadSound(sndClear) ok
        if sndStarGet != null UnloadSound(sndStarGet) ok
        if sndSkid != null UnloadSound(sndSkid) ok
        if sndPause != null UnloadSound(sndPause) ok

        if bgmMusic != null
            StopMusicStream(bgmMusic)
            UnloadMusicStream(bgmMusic)
        ok

        CloseAudioDevice()
    end
end
