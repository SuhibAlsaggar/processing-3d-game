# Processing 3D Game (Last updated Nov. 26th 2024)

Processing 3D Game (P3G) is a simple 3D game engine developed from scratch to demonstrate core 3D rendering and motion capture capabilities. Built using [Processing 4.3](https://processing.org/download), P3G provides a foundation for learning and experimenting with 3D rendering, animation, and model integration.

## Overview

This project was created as part of the **Mixed Reality** course at the **University of Ostfalia** in Germany. It serves as an educational tool, offering insights into the basics of 3D graphics, including rendering, animation, physics, collision and the use of motion capture (moCap) to bring models to life.

Key features include:

- **Basic 3D Rendering**: Demonstrates the core principles of rendering 3D models.
- **Physics and Collision Detection**: Implements basic physics for movement and object interactions, with simple colliders to detect and manage collisions between objects.
- **Model and Animation**: Integrated with assets from **Sketchfab** (3D models) and animated using **Xsens Motion Capture** (moCap).

## Tools & Libraries Used

- **Processing 4.3**: Main framework for Java-based rendering and input handling.
- **Xsens**: For high-quality motion capture animation data.
- **Sketchfab**: For 3D model assets.
- **Blender**: Used for rigging and bone structure creation, making models compatible with the animation system.

## Getting Started

### Prerequisites

- [Processing 4.3](https://processing.org/download) installed on your machine.
- Basic understanding of Java and Processing framework.
- **Minim Library**: Import Minim to play audio files.
  - Navigate to **Sketch > import Library > Manage Libraries** and import **Minim**
- **Memory Configuration**: Increase the maximum memory allocation for Processing to at least **6000 MB**.
  - Navigate to **File > Preferences** in Processing.
  - Scroll to the **"Running"** section and set the maximum available memory to `6000` or more.
  - Save the preferences and restart Processing.

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/SuhibAlsaggar/processing-3d-game.git
   ```
2. Open the project in **Processing 4.3**.
3. Run the main `P3G.pde` file to start the engine and see the 3D rendering in action.

### Usage

P3G includes sample models and animations to showcase its capabilities. Once you’ve loaded the project, you can experiment by adjusting camera angles, changing models, or integrating your own animations and Sketchfab models.

### Sample Models and Animations

Included with this project are basic sample assets:

- **Character Models** from Sketchfab
- **Animations** made by Xsens MoCap

These assets provide a baseline for testing and experimentation. Feel free to replace or augment these with your own assets to explore further.

## Demo Video

[Watch the Demo](https://www.youtube.com/watch?v=zJr_Ks_e4Q8)

## Acknowledgments

- **University of Ostfalia** and **Professor Dr.-Ing. Reinhard Gerndt** for the opportunity to explore and build P3G.
- **Sketchfab** for offering high-quality 3D models.
- **Blender** for its powerful rigging tools and skeletal animation support.

---

This project is a stepping stone for anyone interested in 3D rendering and fundamental game physics. Enjoy experimenting!
