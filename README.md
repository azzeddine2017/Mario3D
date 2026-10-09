# Super Mario 3D - Mushroom Kingdom Adventure 🍄⭐

A rich, nostalgic **3D Third-Person Platformer** built from scratch using the **Ring Programming Language** and **RingRayLib 1.0.49**.

Inspired by classic 3D platformers (*Super Mario 64*, *Super Mario Galaxy*, and *Super Mario 3D Land*), this game brings the Mushroom Kingdom to life with smooth 360° kinematics, responsive acrobatic jumping physics, Ground Pound mechanics, dynamic drop shadows, checkered terrains, moving lifts, functional Warp Pipes, patrolling Goombas & Koopas, Super Mushroom / Starman power-ups, and vibrant retro aesthetics.

---

# Screen Shots
![Mario 3D ](Assets\Capture.PNG).

## 🌟 Upgraded Features & Mechanics

- **Fluid 360° Mario Kinematics**:
  - Camera-relative directional movement (`W/A/S/D`).
  - Sprint / Dash mechanic (`Shift` / `X`) with speed rush feel.
  - Smooth rotational slerp facing direction with sharp turn skidding and dust puff effects.
  - **Dynamic Drop Shadows**: Real-time ground shadow projection beneath Mario, Goombas, Koopas, and coins for authentic depth perception.
  - **Squash & Stretch**: Elastic body deformation upon jump liftoff and ground impacts.

- **Acrobatic Jump Combo & Ground Pound**:
  - **Triple Jump**: Jump 1 (Standard) ➔ Jump 2 (High Leap) ➔ Jump 3 (Acrobatic Somersault with high-apex flip & voice cheer).
  - **Ground Pound (Hip Attack)**: Press `Ctrl` or `C` while in mid-air to halt, flip 360°, and slam downward with explosive shockwaves, defeating nearby enemies and activating blocks!

- **Power-Ups & Collectibles**:
  - **Super Mushroom 🍄**: Question blocks spawn sliding Super Mushrooms that scale Mario to 1.45x size, increase max health to 4, and allow shattering brick blocks!
  - **Starman (Invincibility Star) ⭐**: Rainbow shimmering aura, increased dash speed, and instant enemy stomping.
  - **Midway Checkpoint Flag 🚩**: Automatically saves progress when passed, respawning Mario midway if a life is lost.

- **Dynamic Mushroom Kingdom World**:
  - **Checkered Mario Grass & Stone Tiles**: Iconic Mario 3D Land alternating grid patterns on platforms.
  - **Moving Lifts**: Dynamic horizontal ferries and vertical elevator platforms.
  - **Functional Warp Pipes**: Stand on top and press `S` / `Down` to warp between the main meadow and secret treasure islands.
  - Floating sky clouds with smiling Mario eyes, swaying trees, and flower patches.
  - Distant mountain ridges, glowing sun disk, and smooth vertical sky gradient.

- **Classic Enemies & Shell Kicking**:
  - **Procedural 3D Goombas**: Patrolling AI, angry eyebrows, squash animations, and combo stomping.
  - **Green Koopa Troopas 🐢**: Patrolling Koopas that retract into shells when stomped. Run into stationary shells to kick them at high speed, ricocheting off boundaries and defeating Goombas in their path!

- **Retro Super Mario HUD & Audio**:
  - Mario Lives, dynamic 3/4-segment Power Meter, Starman countdown badge.
  - Coin counter, Power Star counter, score, and level timer.
  - Complete authentic audio suite: Triple jump shouts, ground pound quakes, shell kicks, pipe warps, and power-up fanfares.

---

## 🎮 Controls

| Action | Key / Input |
|---|---|
| **Move Mario** | `W` / `A` / `S` / `D` (Camera-Relative) |
| **Jump / Triple Jump** | `Space` / `Z` / `J` (Time consecutive jumps for Double & Triple Jump) |
| **Ground Pound (Hip Attack)** | `Left Ctrl` / `Right Ctrl` / `C` (while in mid-air) |
| **Warp Down Pipe** | `S` or `Down Arrow` (standing on top of a Warp Pipe) |
| **Sprint / Dash Fast** | Hold `Left Shift` / `Right Shift` / `X` |
| **Kick Koopa Shell** | Walk / Run into a stationary Koopa shell |
| **Camera Orbit** | Mouse Right-Click Drag OR Arrow Keys |
| **Camera Zoom** | Mouse Scroll Wheel |
| **Center Camera** | `C` or `R` |
| **Pause Game** | `ESC` or `P` |
| **Restart / Retry** | `Enter` or `Space` (on Clear/GameOver) / `R` (in Pause) |

---

## 🚀 How to install and run the project

```bash
ringpm install Mario3D from Azzeddine2017
ringpm run Mario3D
```

---

## 📁 Project Architecture

- **`Mario3D.ring`**: Application entry point, main game loop, sky gradient renderer, shockwave/particle engine, and 3D rendering pipeline.
- **`Config.ring`**: Global physics parameters, triple jump constants, ground pound kinematics, RayLib color palette, and vector math helpers.
- **`Camera.ring`**: Third-person spherical orbit camera with forward/right vectors and target interpolation.
- **`Player.ring`**: Mario controller, Triple Jump, Ground Pound, Squash & Stretch, Super Mushroom scaling, Starman invincibility, drop shadow, and procedural rig.
- **`World.ring`**: Checkered grass terrain builder, moving lifts, functional Warp Pipes, bouncing Question blocks, Super Mushroom item spawners, checkpoint flag, and Power Star.
- **`Enemies.ring`**: Goomba & Koopa Troopa AI, shell kicking & ricochet physics, squash animations, ground pound impacts, and drop shadows.
- **`HUD.ring`**: Retro 2D heads-up display, player health card, Starman timer, coin counter, course clear banner, and pause overlay.
- **`AudioManager.ring`**: Complete sound effects manager (Triple jump, Ground pound, Shell kick, Pipe warp, Power-ups, and BGM).
- **`package.ring`**: RingPM package definition for official package distribution.

---

## 📜 License & Credits

- Developed by **Azzeddine Remmal** (`Azzeddine2017`).
- Distributed under the **MIT License**.
