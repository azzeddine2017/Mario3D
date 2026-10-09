#===================================================================#
# Mario 3D - Third-Person Orbit Camera Subsystem
# Smooth 360° Orbit, Target Tracking, Center Snap & Camera Vectors
#===================================================================#

class ThirdPersonCamera
    camera
    yaw             # Horizontal orbit angle (degrees)
    pitch           # Vertical elevation angle (degrees)
    distance        # Current distance from target
    targetDist      # Desired zoom target distance
    targetPos       # Smoothed camera focus point
    prevMousePos

    func init startTargetPos
        yaw         = 180.0
        pitch       = 20.0
        distance    = CAM_DEFAULT_DIST
        targetDist  = CAM_DEFAULT_DIST
        targetPos   = Vector3(startTargetPos.x, startTargetPos.y + 1.6, startTargetPos.z)

        camera = Camera3D(
            0.0, 10.0, -12.0,   # Position
            0.0, 1.6, 0.0,      # Target
            0.0, 1.0, 0.0,      # Up
            52.0, CAMERA_PERSPECTIVE
        )

        prevMousePos = GetMousePosition()
        updatePosition()
        return self
    

    func update dt, marioPos, marioFacingAngle
        # 1. Smoothly interpolate focus point towards Mario's head/torso
        desiredY = marioPos.y + 1.6
        targetPos.x = lerpVal(targetPos.x, marioPos.x, CAM_SMOOTH_SPEED * dt)
        targetPos.y = lerpVal(targetPos.y, desiredY, CAM_SMOOTH_SPEED * dt)
        targetPos.z = lerpVal(targetPos.z, marioPos.z, CAM_SMOOTH_SPEED * dt)

        # 2. Mouse Orbit Controls (Right Mouse Button Drag)
        curMouse = GetMousePosition()
        if IsMouseButtonDown(MOUSE_BUTTON_RIGHT)
            dx = curMouse.x - prevMousePos.x
            dy = curMouse.y - prevMousePos.y
            yaw   -= dx * 0.28
            pitch += dy * 0.22
        ok
        prevMousePos = curMouse

        # 3. Keyboard Camera Controls (Arrow Keys Orbit)
        if IsKeyDown(KEY_RIGHT) yaw   -= 90.0 * dt ok
        if IsKeyDown(KEY_LEFT)  yaw   += 90.0 * dt ok
        if IsKeyDown(KEY_UP)    pitch -= 50.0 * dt ok
        if IsKeyDown(KEY_DOWN)  pitch += 50.0 * dt ok

        # 4. Center Camera Behind Mario on [C] or [R] key
        if IsKeyPressed(KEY_C) or IsKeyPressed(KEY_R)
            yaw = marioFacingAngle + 180.0
            pitch = 20.0
        ok

        # 5. Zoom In/Out via Mouse Wheel
        wheel = GetMouseWheelMove()
        if wheel != 0.0
            targetDist -= wheel * 1.5
            targetDist = clampVal(targetDist, CAM_MIN_DIST, CAM_MAX_DIST)
        ok
        distance = lerpVal(distance, targetDist, 10.0 * dt)

        # 6. Clamp Pitch Limits
        pitch = clampVal(pitch, CAM_PITCH_MIN, CAM_PITCH_MAX)

        # 7. Compute Spherical Eye Position
        updatePosition()
    

    func updatePosition
        yawRad   = yaw * DEG2RAD
        pitchRad = pitch * DEG2RAD

        # Horizontal distance component
        hDist = distance * cos(pitchRad)

        camX = targetPos.x + hDist * sin(yawRad)
        camY = targetPos.y + distance * sin(pitchRad)
        camZ = targetPos.z + hDist * cos(yawRad)

        camera.position.x = camX
        camera.position.y = camY
        camera.position.z = camZ

        camera.target.x   = targetPos.x
        camera.target.y   = targetPos.y
        camera.target.z   = targetPos.z
    

    # Horizontal forward vector (camera facing direction projected onto XZ plane)
    func getForwardVector
        yawRad = yaw * DEG2RAD
        # Vector points FROM camera TO target
        fx = -sin(yawRad)
        fz = -cos(yawRad)
        return [fx, fz]
    

    # Horizontal right vector
    func getRightVector
        fwd = getForwardVector()
        # Perpendicular vector in 2D to the right: (fz, -fx)
        rx =  fwd[2]
        rz = -fwd[1]
        return [rx, rz]
    

