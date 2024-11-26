class Player extends Collider {
    PVector velocity;
    PVector lastDirection = new PVector(0, 0, -1);
    float gravity = 0.5;
    float maxFallSpeed = 10;
    float jumpStrength = 10;

    Trigger groundCheck;

    float shootAnimationTimer = 0;
    boolean isShooting = false;

    // Crouching-related flags
    boolean isCrouching = false;
    boolean isCrouched = false;
    boolean isStandingUp = false;
    
    boolean isTransitioning() {
     return isCrouching || isCrouched || isStandingUp; 
    }

    // Movement flags
    float moveSpeed = 5;
    boolean moveForward = false;
    boolean moveBackward = false;
    boolean moveLeft = false;
    boolean moveRight = false;

    ArrayList < Collider > collidersBelow;


    Player(float x, float y, float z, float width, float height, float depth, float moveSpeed) {
        super(x, y, z, width, height, depth);
        this.moveSpeed = moveSpeed;
        this.groundCheck = new Trigger(x, y + 1, z, width, 1, depth, this::onGroundCheckEnter, this::onGroundCheckExit, this::onGroundCheckCollision);
        collidersBelow = new ArrayList < Collider > ();
        velocity = new PVector(0, 0, 0);
    }

    // Handle movement and apply gravity
    void handleInput() {
        PVector newDirection = new PVector();

        if (moveForward && !isTransitioning()) {
            velocity.z = -moveSpeed;
            newDirection.z = -1;
        } else if (moveBackward) {
            velocity.z = moveSpeed;
            newDirection.z = 1;
        } else {
            velocity.z = 0;
        }

        if (moveLeft && !isTransitioning()) {
            velocity.x = -moveSpeed;
            newDirection.x = -1;
        } else if (moveRight) {
            velocity.x = moveSpeed;
            newDirection.x = 1;
        } else {
            velocity.x = 0;
        }

        if (newDirection.mag() > 0) {
            lastDirection = newDirection.normalize();
        }
    }

    // Method to handle key press events
    void handleKeyPressed() {
        if (key == 'w' || key == 'W' || keyCode == UP) {
            moveForward = true;
        } else if (key == 's' || key == 'S' || keyCode == DOWN) {
            moveBackward = true;
        } else if (key == 'a' || key == 'A' || keyCode == LEFT) {
            moveLeft = true;
        } else if (key == 'd' || key == 'D' || keyCode == RIGHT) {
            moveRight = true;
        } else if (key == ' ') {
            jump();
        }
    }

    // Method to handle key release events
    void handleKeyReleased() {
        if (key == 'w' || key == 'W' || keyCode == UP) {
            moveForward = false;
        } else if (key == 's' || key == 'S' || keyCode == DOWN) {
            moveBackward = false;
        } else if (key == 'a' || key == 'A' || keyCode == LEFT) {
            moveLeft = false;
        } else if (key == 'd' || key == 'D' || keyCode == RIGHT) {
            moveRight = false;
        }
    }

    // Apply gravity if not on the ground
    void applyGravity() {
        if (!isGrounded() && velocity.y < maxFallSpeed) {
            velocity.y += gravity;
        }
    }

    // Jump if on the ground
    void jump() {
        if (isGrounded() && !isTransitioning()) {
            velocity.y = -jumpStrength;
        }
    }

    // Update position based on velocity
    void updatePosition() {
        applyGravity();
        handleInput();
        position.add(velocity);
        PVector checkPosition = new PVector(position.x, position.y + height / 2, position.z);
        groundCheck.position = checkPosition;
    }

    void update() {
        updateAnimation();
    }

    // Collision response - stop movement along the collision direction
    @Override
    void onCollision(Collider other, PVector collisionNormal) {

        // Ignore collision if `other` is a bullet
        if (other instanceof Bullet) {
            return;
        }

        boolean ignoreTypes = other instanceof Target || other instanceof Trigger;

        // Adjust position based on collision normal to prevent clipping
        if (collisionNormal.y > 0 && !(ignoreTypes)) { // Colliding from below (ground)
            position.y = other.position.y - height / 2 - other.height / 2;
            velocity.y = 0;
        } else if (collisionNormal.y < 0) { // Colliding from above
            position.y = other.position.y + height / 2 + other.height / 2;
            velocity.y = max(velocity.y, 0);
        }

        if (collisionNormal.x != 0) { // Colliding on the X-axis
            position.x = other.position.x + (collisionNormal.x > 0 ? (other.width / 2 + width / 2) : -(other.width / 2 + width / 2));
            velocity.x = 0;
        }

        if (collisionNormal.z != 0) { // Colliding on the Z-axis
            position.z = other.position.z + (collisionNormal.z > 0 ? (other.depth / 2 + depth / 2) : -(other.depth / 2 + depth / 2));
            velocity.z = 0;
        }
    }


    void onGroundCheckEnter(Collider other) {
        PVector normal = groundCheck.getCollisionNormal(other);
        if (normal.y != 0) { // Colliding with (ground)
            collidersBelow.add(other);
        }
    }

    void onGroundCheckExit(Collider other) {
        if (collidersBelow.contains(other))
            collidersBelow.remove(other);
    }

    void onGroundCheckCollision(Collider other, PVector collisionNormal) {
        // Check if the platform is moving and player is on top
        if (other instanceof MovingBlock && collidersBelow.size() > 0) {
            MovingBlock platform = (MovingBlock) other;
            PVector platformDisplacement = platform.getDisplacement();
            position.add(platformDisplacement); // Move the player along with the platform
        }

    }

    @Override
    void onColliderEnter(Collider other) {}

    @Override
    void onColliderExit(Collider other) {}

    // Update direction when there's movement
    void updateDirection() {
        PVector newDirection = new PVector();

        if (moveForward) {
            newDirection.z = -1;
        } else if (moveBackward) {
            newDirection.z = 1;
        }

        if (moveLeft) {
            newDirection.x = -1;
        } else if (moveRight) {
            newDirection.x = 1;
        }

        if (newDirection.mag() > 0) {
            lastDirection = newDirection.normalize();
        }
    }

    boolean isGrounded() {
        if (collidersBelow.size() > 0) {
            return true;
        }
        return false;
    }

    PVector getDirection() {
        return lastDirection.copy();
    }

    void updateAnimation() {
        if (shootAnimationTimer > 0) {
            shootAnimationTimer--;
        } else {
            isShooting = false;
        }
    }

    boolean isIdle() {
        return velocity.x == 0 && velocity.y == 0 && velocity.z == 0 || isCrouched;
    }

    boolean isMoving() {
        return velocity.x != 0 || velocity.z != 0;
    }

    boolean isJumping() {
        return velocity.y < 0;
    }

    boolean isFalling() {
        return velocity.y > 0;
    }

}
