#===================================================================#
# Mario 3D - Third-Person Orbit Camera Subsystem
# Smooth 360° Orbit, Target Tracking, Center Snap & Camera Vectors
# Clean Class Attributes & Conflict-Free Keyboard/Mouse Controls
#===================================================================#

class ThirdPersonCamera
    camera       = null
    yaw          = 180.0        # Horizontal orbit angle (degrees)
    pitch        = 20.0         # Vertical elevation angle (degrees)
    distance     = CAM_DEFAULT_DIST
    targetDist   = CAM_DEFAULT_DIST
    targetPos    = null
    prevMousePos = null

    func init startTargetPos
        targetPos = Vector3(startTargetPos.x, startTargetPos.y + 1.6, startTargetPos.z)
        camera = Camera3D(
            0.0, 10.0, -12.0,   # Position
            0.0, 1.6, 0.0,      # Target
            0.0, 1.0, 0.0,      # Up
            52.0, CAMERA_PERSPECTIVE
        )
        prevMousePos = GetMousePosition()
        updatePosition()
        return self
    end

    func update dt, marioPos, marioFacingAngle
        # 1. Smoothly interpolate focus point towards Mario's center
        desiredY = marioPos.y + 1.6
        targetPos.x = lerpVal(targetPos.x, marioPos.x, CAM_SMOOTH_SPEED * dt)
        targetPos.y = lerpVal(targetPos.y, desiredY, CAM_SMOOTH_SPEED * dt)
        targetPos.z = lerpVal(targetPos.z, marioPos.z, CAM_SMOOTH_SPEED * dt)

        # 2. Mouse Orbit Controls (Right Mouse Drag)
        curMouse = GetMousePosition()
        if IsMouseButtonDown(MOUSE_BUTTON_RIGHT)
            dx = curMouse.x - prevMousePos.x
            dy = curMouse.y - prevMousePos.y
            yaw   -= dx * 0.28
            pitch += dy * 0.22
        ok
        prevMousePos = curMouse

        # 3. Dedicated Camera Orbit Keys ([Q] / [E] or PageUp/PageDown)
        # (Preserves Arrow Keys for Mario Character Movement)
        if IsKeyDown(KEY_E) or IsKeyDown(KEY_PAGE_DOWN) yaw -= 90.0 * dt ok
        if IsKeyDown(KEY_Q) or IsKeyDown(KEY_PAGE_UP)   yaw += 90.0 * dt ok

        # 4. Center Camera Behind Mario exclusively on [R] key
        # (Removed [C] key to eliminate conflict with Ground Pound slam)
        if IsKeyPressed(KEY_R)
            yaw = marioFacingAngle + 180.0
            pitch = 20.0
        ok

        # 5. Angle Normalization (Eliminates infinite rotation / gimbal drift)
        while yaw >= 360.0 yaw -= 360.0 end
        while yaw < 0.0    yaw += 360.0 end
        pitch = clampVal(pitch, CAM_PITCH_MIN, CAM_PITCH_MAX)

        # 6. Smooth Zoom via Mouse Wheel
        wheel = GetMouseWheelMove()
        if wheel != 0.0
            targetDist -= wheel * 1.5
            targetDist = clampVal(targetDist, CAM_MIN_DIST, CAM_MAX_DIST)
        ok
        distance = lerpVal(distance, targetDist, 10.0 * dt)

        # 7. Compute Spherical Eye Position
        updatePosition()
    end

    func updatePosition
        yawRad   = yaw * DEG2RAD
        pitchRad = pitch * DEG2RAD

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
    end

    # Horizontal forward vector (camera facing direction projected onto XZ plane)
    func getForwardVector
        yawRad = yaw * DEG2RAD
        fx = -sin(yawRad)
        fz = -cos(yawRad)
        return [fx, fz]
    end

    # Horizontal right vector
    func getRightVector
        fwd = getForwardVector()
        rx =  fwd[2]
        rz = -fwd[1]
        return [rx, rz]
    end
end
