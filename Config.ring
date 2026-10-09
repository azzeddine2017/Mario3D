#===================================================================#
# Mario 3D - Global Configuration & Constants
# Physics, Camera Settings, Controls, Colors & Game State Defines
#===================================================================#

# Screen Dimensions
SCREEN_WIDTH  = 1280
SCREEN_HEIGHT = 720
FPS_TARGET    = 60

# Game States
STATE_PLAYING     = 1
STATE_LEVEL_CLEAR = 2
STATE_GAMEOVER    = 3
STATE_PAUSED      = 4
STATE_VICTORY     = 5

# Physics Constants
GRAVITY_ACCEL     = 28.0    # Gravity acceleration (m/s^2)
TERMINAL_VELOCITY = 32.0    # Max fall speed
MARIO_WALK_SPEED  = 7.0     # Normal movement speed
MARIO_RUN_SPEED   = 11.8    # Speed when holding Run / Shift
MARIO_ACCEL       = 24.0    # Acceleration responsiveness
MARIO_FRICTION    = 18.0    # Ground friction deceleration
MARIO_AIR_CONTROL = 0.65    # Air maneuverability multiplier
MARIO_JUMP_FORCE  = 12.8    # Initial jump impulse
MARIO_DOUBLE_JUMP = 15.2    # Second leap impulse if timed right
MARIO_TRIPLE_JUMP = 18.0    # Acrobatic third somersault jump impulse
MARIO_GROUND_POUND_SPD = 28.0 # High-speed slam velocity

# Camera Constants
CAM_DEFAULT_DIST  = 12.0    # Camera distance behind Mario
CAM_MIN_DIST      = 6.0     # Min camera zoom
CAM_MAX_DIST      = 22.0    # Max camera zoom
CAM_PITCH_MIN     = -10.0   # Min pitch angle (degrees)
CAM_PITCH_MAX     = 65.0    # Max pitch angle (degrees)
CAM_SMOOTH_SPEED  = 8.5     # Camera target tracking lerp

# World Constants
WORLD_DEATH_Y     = -25.0   # Falling below this Y respawns/hurts Mario

# RayLib Custom Color Palette
MARIO_RED         = RAYLibColor(235, 38, 38, 255)
MARIO_BLUE        = RAYLibColor(22, 70, 205, 255)
MARIO_YELLOW      = RAYLibColor(255, 220, 15, 255)
MARIO_SKIN        = RAYLibColor(255, 205, 160, 255)
MARIO_BROWN       = RAYLibColor(115, 58, 24, 255)
MARIO_SOLE        = RAYLibColor(55, 28, 12, 255)
MARIO_EYE_BLUE    = RAYLibColor(30, 115, 230, 255)
MARIO_WHITE       = RAYLibColor(248, 248, 252, 255)

# Environment & Sky Colors
SKY_BLUE          = RAYLibColor(115, 190, 255, 255)
SKY_BLUE_TOP      = RAYLibColor(70, 150, 255, 255)
SKY_BLUE_BOTTOM   = RAYLibColor(200, 235, 255, 255)
GRASS_GREEN       = RAYLibColor(72, 188, 42, 255)
GRASS_LIGHT       = RAYLibColor(105, 218, 65, 255)
GRASS_DARK        = RAYLibColor(52, 160, 32, 255)
DIRT_BROWN        = RAYLibColor(135, 80, 42, 255)
DIRT_DARK         = RAYLibColor(95, 50, 24, 255)
STONE_LIGHT       = RAYLibColor(210, 215, 225, 255)
STONE_DARK        = RAYLibColor(140, 145, 158, 255)
PIPE_GREEN        = RAYLibColor(32, 168, 35, 255)
PIPE_DARK         = RAYLibColor(16, 105, 20, 255)
PIPE_HIGHLIGHT    = RAYLibColor(70, 215, 75, 255)
BLOCK_QUESTION    = RAYLibColor(248, 180, 20, 255)
BLOCK_BRICK       = RAYLibColor(188, 78, 42, 255)
BLOCK_USED        = RAYLibColor(135, 120, 110, 255)
GOOMBA_BROWN      = RAYLibColor(145, 60, 30, 255)
GOOMBA_DARK       = RAYLibColor(85, 35, 18, 255)
KOOPA_GREEN       = RAYLibColor(38, 195, 60, 255)
KOOPA_SHELL_DARK  = RAYLibColor(22, 130, 38, 255)
KOOPA_YELLOW      = RAYLibColor(255, 215, 30, 255)
CASTLE_WHITE      = RAYLibColor(242, 240, 235, 255)
CASTLE_BRICK      = RAYLibColor(205, 202, 195, 255)
CASTLE_RED        = RAYLibColor(215, 42, 42, 255)
GOLD_SHINE        = RAYLibColor(255, 235, 80, 255)
SHADOW_COLOR      = RAYLibColor(15, 25, 15, 130)

# Angular Conversion Constants
DEG2RAD           = 3.1415926535 / 180.0
RAD2DEG           = 180.0 / 3.1415926535

# Math Helper Functions
func clampVal val, minV, maxV
    if val < minV return minV ok
    if val > maxV return maxV ok
    return val
end

func lerpVal a, b, t
    return a + (b - a) * t
end

func getDistance3D p1, p2
    dx = p2.x - p1.x
    dy = p2.y - p1.y
    dz = p2.z - p1.z
    return sqrt(dx*dx + dy*dy + dz*dz)
end
