# aMAZEing-Game
fooling around with gameMaker
I am continuing a game development project. We have been working to build a 2D, top-down maze game in **GameMaker** using modern GML. The project is in a fantastic state, with a fully functional core loop.

Here is a comprehensive summary of the project's current state, key architectural decisions, and our immediate goals:

**1. High-Level Game Concept:**

*   **Genre:** A roguelike/incremental game focused on maze traversal.
*   **Core Loop:** The player navigates a procedurally generated maze from a start point to an end point. Upon reaching the end, the maze regenerates, and the loop repeats.
*   **Gameplay Focus:** The game is about exploration, skillful movement, and using power-ups. There is currently no combat or timer.
*   **Progression:** The player will acquire temporary power-ups within the maze and potentially permanent skills/perks between runs.

**2. Current Project State & Key Systems (What's Done):**

*   **Maze Generation (`o_maze_generator`):**
    *   Generation is handled by a single controller object, `o_maze_generator`.
    *   It uses an **iterative Recursive Backtracker (Depth-First Search)** algorithm in its **Step Event**. This creates a satisfying visual effect of the maze being "drawn" live, which is a feature I want to keep.
    *   The `randomize()` function is called at the start to ensure a unique maze on every run.
    *   It successfully defines and visualizes a green start square and a red end square. The end point is determined by the last cell visited during generation.

*   **Collision System:**
    *   The maze walls are **physical objects**, not tilemaps. This is a key architectural decision.
    *   The generator creates instances of `o_wall_h` (horizontal) and `o_wall_v` (vertical) on a dedicated "Instances_Walls" layer. These objects are children of a parent object, `o_wall_parent`, for easy collision checking.
    *   The wall-building logic is efficient, creating only one instance per wall segment to avoid duplicates.

*   **Player Object (`o_player`):**
    *   **Physics-Based Movement:** The player uses a robust movement system with **acceleration, friction, and max speed**. It does not move at a constant speed. Momentum is tracked with `h_speed` and `v_speed`.
    *   **Collision:** The player's `Step` event contains precise, pixel-perfect collision code that checks against `o_wall_parent` using `place_meeting()`.
    *   **Spawning:** The player has a state machine (`has_spawned` flag). It starts invisible and waits for the generator's `generation_complete` flag to be true before snapping to its start position and becoming active. This correctly handles all timing issues.

*   **Data-Driven Power-Up System:** This is our most advanced system.
    *   All pickup items are children of a parent object, `o_pickup_parent`, which handles shared logic like a "breathing" scale animation.
    *   Each specific pickup object (e.g., `o_fist_pickup`, `o_speedup_pickup`) contains an `item_data` struct.
    *   This struct holds all the item's information, including a powerful `apply_effect` **function**. The player's collection code is generic and simply executes this function, passing in its own instance ID.
    *   We have successfully implemented two power-ups using this system:
        1.  **Fist:** Adds a charge to `wall_break_charges`. The player can press Spacebar to destroy a nearby wall instance.
        2.  **Speedup:** Sets a `speed_boost_duration` timer on the player and calls a `recalculate_stats()` function.

*   **Player Stats Architecture:**
    *   To support temporary buffs, the player's stats have been refactored into **`base_`** and **`current_`** versions (e.g., `base_max_speed` and `current_max_speed`).
    *   A function on the player, `recalculate_stats()`, is the single source of truth. It resets `current_` stats to `base_` stats and then applies any active effects (like the speed boost).

*   **Visuals:**
    *   The player has a `wielded_item_sprite` variable. When a power-up is collected, it can set this variable.
    *   The player's `Draw` event uses `draw_sprite_ext()` to draw this wielded sprite at a custom scale to make it look proportional.
    *   Room layers are correctly organized to ensure the generator's floor, the walls, and the player are drawn in the correct order.

**3. My Awesome List of Future Ideas (For Context):**

*   **Perks/Skills/Powerups:** `reverse` (start from end), `smokers`, `home field advantage`, `portal`, `cow`, `torch`, `NVG`, `drone`, `firework`, `skateboard`, `stopwatch`, various foods, `grease/lube`, `weed`, `glasses` (reveal map), `grippy shoes`, `journals`.
*   **Traps:** `hypno trap`, `heavy trap`, `trap trap`, `thirsty trap`, `shadow trap`, `puzzle trap`.
*   **Characters:** `Glasses`, `Backwards`, `Andy`.
