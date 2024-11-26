import ddf.minim.*;

// Variables for the arena elements
static CollisionManager collisionManager;
static Minim minim;
static int score = 0;
static int ammoUsed = 0;

PlayerBox player;
Gun gun;
PlayerCamera playerCamera;

PImage skyTexture;
SkySphere skysphere;

Block floor;
PImage grassTexture;
PImage woodTexture;
PImage metalTexture;

ArrayList < Block > walls;
ArrayList < Block > platforms;
ArrayList < Block > obstacles;
ArrayList < Target > targets;

void setupPerspective() {
    float fov = PI / 3; // Field of view
    float aspect = float(width) / float(height); // Aspect ratio
    float zNear = 0.1; // Near clipping plane (make this very small to avoid close clipping)
    float zFar = 10000.0; // Far clipping plane

    perspective(fov, aspect, zNear, zFar); // Apply the custom perspective
}

void setup() {
    size(1280, 720, P3D);
    noStroke();
    lights();

    setupPerspective();
    InitializeHelpers();

    // Initialize player
    player = new PlayerBox(350, -100, 650, 25, 52, 25);
    gun = new Gun(player);
    PVector cameraOffset = new PVector(0, -50, 200);
    playerCamera = new PlayerCamera(player, cameraOffset);

    grassTexture = loadImage("texture/grass.jpg");
    woodTexture = loadImage("texture/wood.jpg");
    metalTexture = loadImage("texture/metal.jpg");

    skyTexture = loadImage("texture/sky.jpg");
    skysphere = new SkySphere(skyTexture, 3000);

    initializeArena();
}

void draw() {
    setupPerspective();
    background(0);
    lights();

    // Update player (includes input handling and gravity)
    player.update();
    playerCamera.update();

    gun.update();
    gun.display();
    player.display();

    //skybox.display();
    skysphere.display();

    // Display the arena elements
    drawArena();
    drawTargets();
    collisionManager.updateCollisions();
    drawScore();
}

// Global key press event
void keyPressed() {
    player.handleKeyPressed();
    if (key == 'x' || key == 'X')
        gun.fire();
}

// Global key release event
void keyReleased() {
    player.handleKeyReleased();
}

void drawScore() {
    // Switch to 2D mode for overlay text
    hint(DISABLE_DEPTH_TEST); // Disable depth testing so text isn't affected by 3D objects
    camera(); // Reset the camera to default, for 2D rendering

    // Display the score in 2D on the top-left corner
    fill(color(0, 255, 0));
    textSize(20);
    textAlign(LEFT, TOP);
    text("Score: " + score, 10, 10);
    fill(color(255, 0, 0));
    text("Ammo used: " + ammoUsed, 10, 30);
    fill(color(255, 255, 0));
    text("Controls", 10, 70);
    fill(color(0, 255, 255));
    text("Move: WASD or Arrows", 10, 95);
    text("Jump: Space", 10, 115);
    text("Shoot: X", 10, 135);
    text("Crouch: Ctrl", 10, 155);

    hint(ENABLE_DEPTH_TEST); // Re-enable depth testing for future 3D rendering
}

void drawArena() {
    floor.display();

    //for (Block wall : walls) {
    //    wall.display();
    //}

    for (Block obstacle: obstacles) {
        obstacle.display();
    }

    for (Block platform: platforms) {
        platform.display();
    }
}

void drawTargets() {
    for (Target target: targets) {
        target.display();
    }
}

void initializeArena() {
    // Initialize the targets list
    targets = new ArrayList < Target > ();

    // Stationary targets
    //Target target1 = new Target(100, -50, -150, 50);
    //Target target2 = new Target(-100, -50, -150, 50);
    //Target target3 = new Target(150, -50, 50, 50);
    //Target target4 = new Target(-150, -50, 50, 50);

    Target target5 = new Target(20, -150, -500, 50);
    Target target6 = new Target(180, -150, -500, 50);

    Target target7 = new Target(-200, -200, -500, 50);

    //targets.add(target1);
    //targets.add(target2);
    //targets.add(target3);
    //targets.add(target4);

    targets.add(target5);
    targets.add(target6);

    targets.add(target7);

    //// Moving targets with pathways
    MovingTarget mTarget1 = new MovingTarget(100, -50, -125, 50, 4);
    MovingTarget mTarget2 = new MovingTarget(850, -100, -375, 50, 1.5);

    MovingTarget mTarget3 = new MovingTarget(750, -50, -525, 50, 3);

    PVector dist4 = new PVector(600, -100, -525);
    MovingTarget mTarget4 = new MovingTarget(600, 0, -525, 50, dist4, 4);

    PVector dist5 = new PVector(700, -100, -525);
    MovingTarget mTarget5 = new MovingTarget(700, 0, -525, 50, dist5, 2);

    targets.add(mTarget1);
    targets.add(mTarget2);

    targets.add(mTarget3);
    targets.add(mTarget4);
    targets.add(mTarget5);


    float arenaSize = 2000;
    // Floor block
    floor = new Block(0, 0, 0, arenaSize * 5, 10, arenaSize * 5, grassTexture, 100, 100); // Large floor block

    // Initialize walls list and create walls
    walls = new ArrayList < Block > ();
    Block wallLeft = new Block(-arenaSize / 2 + 750, -50, 0, 10, arenaSize, arenaSize, color(50, 50, 0)); // Left wall
    Block wallRight = new Block(arenaSize / 2, -50, 0, 10, arenaSize, arenaSize, color(50, 50, 0)); // Right wall
    Block wallFront = new Block(0, -50, -arenaSize / 2, arenaSize, arenaSize, 10, color(50, 50, 0)); // Front wall
    Block wallBack = new Block(0, -50, arenaSize / 2, arenaSize, arenaSize, 10, color(50, 50, 0)); // Back wall

    walls.add(wallLeft);
    walls.add(wallRight);
    walls.add(wallFront);
    walls.add(wallBack);

    // Initialize obstacles list and add obstacles
    obstacles = new ArrayList < Block > ();
    //Block obstacle1 = new Block(0, -25 - 5, 0, 50, 50, 50, woodTexture, 0, 0); // Set Y to half height then -5 for the floor

    Block obstacle2 = new Block(100, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle3 = new Block(150, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle4 = new Block(100, -25 - 5 - 50, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle4_1 = new Block(250, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);

    Block obstacle5 = new Block(850, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle6 = new Block(900, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle7 = new Block(950, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);

    Block obstacle8 = new Block(850, -25 - 5, -350, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle9 = new Block(900, -25 - 5, -350, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle10 = new Block(950, -25 - 5, -350, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle11 = new Block(900, -25 - 5 - 50, -350, 50, 50, 50, woodTexture, 0, 0);


    Block obstacle12 = new Block(550, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle13 = new Block(600, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle14 = new Block(650, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle15 = new Block(700, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle16 = new Block(750, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle17 = new Block(850, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle18 = new Block(900, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle19 = new Block(950, -25 - 5, -500, 50, 50, 50, woodTexture, 0, 0);

    Block obstacle20 = new Block(400, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle21 = new Block(450, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle22 = new Block(500, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle23 = new Block(550, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle24 = new Block(600, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);
    Block obstacle25 = new Block(700, -25 - 5, -100, 50, 50, 50, woodTexture, 0, 0);

    //obstacles.add(obstacle1);

    obstacles.add(obstacle2);
    obstacles.add(obstacle3);
    obstacles.add(obstacle4);
    obstacles.add(obstacle4_1);

    obstacles.add(obstacle5);
    obstacles.add(obstacle6);
    obstacles.add(obstacle7);

    obstacles.add(obstacle8);
    obstacles.add(obstacle9);
    obstacles.add(obstacle10);
    obstacles.add(obstacle11);

    obstacles.add(obstacle12);
    obstacles.add(obstacle13);
    obstacles.add(obstacle14);
    obstacles.add(obstacle15);
    obstacles.add(obstacle16);
    obstacles.add(obstacle17);
    obstacles.add(obstacle18);
    obstacles.add(obstacle19);

    obstacles.add(obstacle20);
    obstacles.add(obstacle21);
    obstacles.add(obstacle22);
    obstacles.add(obstacle23);
    obstacles.add(obstacle24);
    obstacles.add(obstacle25);

    platforms = new ArrayList < Block > ();

    // Define a moving platform
    PVector endPosition1 = new PVector(200, -100, -300);
    MovingBlock movingPlatform1 = new MovingBlock(0, -100, -300, 60, 10, 60, metalTexture, endPosition1, 2.0);
    platforms.add(movingPlatform1);

    PVector endPosition2 = new PVector(-200, -200, -300);
    MovingBlock movingPlatform2 = new MovingBlock(-200, -20, -300, 50, 10, 50, metalTexture, endPosition2, 1.5);
    platforms.add(movingPlatform2);

    // Add colliders to the collision manager
    collisionManager.addCollider(player);
    collisionManager.addCollider(player.groundCheck);

    for (Target target: targets) {
        collisionManager.addCollider(target);
    }

    collisionManager.addCollider(floor);

    for (Block wall: walls) {
        collisionManager.addCollider(wall);
    }

    for (Block obstacle: obstacles) {
        collisionManager.addCollider(obstacle);
    }

    for (Block platform: platforms) {
        collisionManager.addCollider(platform);
    }
}

void InitializeHelpers() {
    minim = new Minim(this);
    // Initialize the collision manager
    collisionManager = new CollisionManager();
}
