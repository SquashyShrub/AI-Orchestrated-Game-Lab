# VibeShift
**Current Version:** `v0.0.1-alpha` | **Last Updated:** 2026-04-26
> A 2D/3D hybrid "Vertical Slice" prototype designed to test the orchestration of AI-native development tools within the Godot Engine.

<img width="922" height="614" alt="VibeShiftAlpha" src="https://github.com/user-attachments/assets/2b77e69d-2b42-4921-952f-8e2c3b7db7e9" />

---

### 🎖️ Overview
Developed as a **personal research project** into AI-Native Software Engineering. This project focuses on **Systems Orchestration** specifically the integration of AI-generated assets (Meshes, 2D Sprites, and code agents) into a functional game loop. 

### 💻 Tech Stack
- **Language**: GDScript (Python-like syntax for Godot)
- **Frameworks/Tools**: Godot 4.4, Cursor (LLM-based IDE), Meshy (3D Generation), Scenario (2D Generation), ElevenLabs (Dialogue)
- **Environment**: Git Version Control | Windows

### 🚀 Key Features
- **Hybrid Dimensions**: Implemeneted a "Billboard" system allowing a 2D character sprites to interact in a 3D Environment.
- **AI-Driven Asset Pipeline**: Architected a multi-tool workflow to generate, optimize and import game-ready assets in under 60 minutes.
- **Physics-Based Gravity**: Developed a custom CharacterBody3D controller using built-in functions and logic to handler real-time collisions and irregular trimesh geometry.

### 🧠 Engineering Challenge
**Problem**: During the integration of the Meshy-generated 3D floor, the engine initially treated the .glb file as a non-collidable spatial node, causing the player character to fall through the world.
**Solution**: I resolved this by accessing the underlying MeshInstance3D resources and programmatically generating a Trimesh Static Body collision layer. This ensured that the physics engine could perform precise vertex-based calculations against the irregular stone floor geometry.

**Problem**: Initial code generation via Cursor resulted in old syntax or improper use of signals/variables. 
**Solution**: I implemented a specialized `.cursorrules` configuration file to explicitly define rules and requirements. 

---

### 🛣️ Roadmap
- **Interactive Environment Expansion**: Scale the current world and implement an interaction system. Including 3D props (generated via Meshy) and trigger specific responses.
- **Reach a Portal (End Goal)**: With multiple agents, design a flow where the player must locate something specific to activate a portal. This will test cross- agent logic (GameDevAssistan and Cursor) to sychronize the state of the game, audio triggers, and effects.
- **AI Speech Optimization**: Determine which agent best captures the persona of the 2D sprite.

### 🛠️ Installation & Usage
1. Clone the repo: `git clone https://github.com/SquashyShrub/VibeShift.git`
2. Open in Godot 4.x (As long as it's version 4.0 or higher, it should work).
3. Press `F5` or `Run` to execute.



