class PlayerBox extends Player {
    float width;
    float height;
    float depth;
    ArrayList < Animation > animations;
    int animationIndex = 0;

    PlayerBox(float x, float y, float z, float width, float height, float depth) {
        super(x, y, z, width, height, depth, 2); // Initialize Player with Collider size and speed
        this.width = width;
        this.height = height;
        this.depth = depth;

        // Add animations
        Animation idle = new Animation(160, "idle", 3);
        Animation walk = new Animation(86, "walk", 2);
        Animation jumping = new Animation(1, "jumping", 1);
        Animation falling = new Animation(1, "falling", 1);
        Animation shooting = new Animation(31, "shooting", 2);
        Animation crouching = new Animation(86, "crouching", 2);
        Animation crouched = new Animation(1, "crouched", 1);
        Animation standingUp = new Animation(86, "standingUp", 2);
        Animation crouchedShoot = new Animation(61, "crouchedShoot", 3);

        animations = new ArrayList < Animation > ();
        animations.add(idle);
        animations.add(walk);
        animations.add(jumping);
        animations.add(falling);
        animations.add(shooting);
        animations.add(crouching);
        animations.add(crouched);
        animations.add(standingUp);
        animations.add(crouchedShoot);
    }

    float fixAngleX = 0;
    float fixAngleY = 0;
    float fixAngleZ = 0;
    float fixOffsetX = 0;
    float fixOffsetY = 0;
    float fixOffsetZ = 0;

    // Display the player
    void display() {
        //groundCheck.display();
        PVector direction = getDirection();
        float angle = atan2(direction.x, direction.z);

        handleAnimationTransitions();

        pushMatrix();
        translate(position.x, position.y, position.z);
        rotateY(angle);
        translate(fixOffsetX, height / 2 - 1 + fixOffsetY, fixOffsetZ);
        rotateX(radians(fixAngleX));
        rotateY(radians(fixAngleY));
        rotateZ(radians(fixAngleZ));
        scale(15);
        animations.get(animationIndex).display();
        popMatrix();
    }

    @Override
    void update() {
        super.update();
        if (!player.isGrounded()) {
         isStandingUp = false;
         isCrouching = false;
         isCrouched = false;
        }
        if (!isStandingUp && !isCrouching && !isCrouched) {
            updatePosition(); // Calls Player's updatePosition method to manage movement
        }
    }

    void handleAnimationTransitions() {
        if (isIdle() && isGrounded() && !isCrouching && !isCrouched && !isStandingUp) {
            fixIdleAnimation();
            idleAnimation();
        }

        if (isMoving() && !isIdle() && isGrounded() && !isCrouching && !isCrouched && !isStandingUp) {
            fixWalkAnimation();
            walkAnimation();
        }

        if (isJumping()) {
            fixAirborneAnimation();
            jumpAnimation();
        }

        if (isFalling()) {
            fixAirborneAnimation();
            fallAnimation();
        }

        if (isShooting && isGrounded()) {
            if (isCrouched) {
                fixCrouchedAnimation();
                crouchedShootingAnimation();
            } else {
                fixStandingShootingAnimation();
                shootingAnimation();
            }
        }

        if (isCrouching && isGrounded() && !isShooting) {
            fixCrouchingAnimation();
            crouchingAnimation();
            if (animations.get(animationIndex).currentFrame == animations.get(animationIndex).frameCount - 1) {
                isCrouching = false;
                isCrouched = true;
            }
        }

        if (isCrouched && !isStandingUp && isGrounded() && !isShooting) {
            fixCrouchedAnimation();
            crouchedAnimation();
        }

        if (isStandingUp && isGrounded()) {
            fixStandingUpAnimation();
            standingUpAnimation();
            if (animations.get(animationIndex).currentFrame == animations.get(animationIndex).frameCount - 1) {
                isStandingUp = false;
                isCrouched = false;
            }
        }
    }

    // Handle key press for crouching
    @Override
    void handleKeyPressed() {
        super.handleKeyPressed();

        if (key == CODED && keyCode == CONTROL) {
            if (!isCrouching && !isCrouched && isGrounded()) {
                animations.get(5).currentFrame = 0; // Reset crouching animation
                isCrouching = true;
                isCrouched = false;
                isStandingUp = false;
            }
        }
    }

    // Handle key release for standing up
    @Override
    void handleKeyReleased() {
        super.handleKeyReleased();

        if (key == CODED && keyCode == CONTROL) {
            if (isCrouched) {
                animations.get(7).currentFrame = 0; // Reset standing up animation
                isStandingUp = true;
                isCrouching = false;
                isCrouched = false;
            }
        }
    }

    void idleAnimation() {
        animationIndex = 0;
    }

    void walkAnimation() {
        animationIndex = 1;
    }

    void jumpAnimation() {
        animationIndex = 2;
    }

    void fallAnimation() {
        animationIndex = 3;
    }

    void shootingAnimation() {
        animationIndex = 4;
    }

    void crouchedShootingAnimation() {
        animationIndex = 8;
    }

    void crouchingAnimation() {
        animationIndex = 5;
    }

    void crouchedAnimation() {
        animationIndex = 6;
    }

    void standingUpAnimation() {
        animationIndex = 7;
    }

    void fixIdleAnimation() {
        fixAngleX = -80;
        fixAngleY = 0;
        fixAngleZ = 180;

        fixOffsetX = 0;
        fixOffsetY = height / -2;
        fixOffsetZ = depth / -3;
    }

    void fixWalkAnimation() {
        fixAngleX = -90;
        fixAngleY = 180;
        fixAngleZ = 0;

        fixOffsetX = 0;
        fixOffsetY = height / -1.5;
        fixOffsetZ = depth / -5;
    }

    void fixAirborneAnimation() {
        fixAngleX = 180;
        fixAngleY = 180;
        fixAngleZ = 0;

        fixOffsetX = width / 3;
        fixOffsetY = height / 3;
        fixOffsetZ = 0;
    }

    void fixStandingShootingAnimation() {
        fixAngleX = 90;
        fixAngleY = 0;
        fixAngleZ = 180;

        fixOffsetX = 0;
        fixOffsetY = height / -1.5;
        fixOffsetZ = 0;
    }

    void fixCrouchedAnimation() {
        fixAngleX = 90;
        fixAngleY = 0;
        fixAngleZ = 180;

        fixOffsetX = 0;
        fixOffsetY = height / -2.5;
        fixOffsetZ = depth / -4;
    }

    void fixCrouchingAnimation() {
        Animation animation = animations.get(5); // Crouching animation
        float progress = (float) animation.currentFrame / animation.frameCount; // Interpolation progress (0.0 to 1.0)

        fixAngleX = 90;
        fixAngleY = 0;
        fixAngleZ = 180;

        fixOffsetX = 0;
        fixOffsetY = lerp(height / -1.5f, height / -2.5f, progress); // Interpolate between crouching and crouched offsets
        fixOffsetZ = depth / -4;
    }

    void fixStandingUpAnimation() {
        Animation animation = animations.get(7); // Standing up animation
        float progress = (float) animation.currentFrame / animation.frameCount; // Interpolation progress (0.0 to 1.0)

        fixAngleX = 90;
        fixAngleY = 0;
        fixAngleZ = 180;

        fixOffsetX = 0;
        fixOffsetY = lerp(height / -2.5f, height / -1.5f, progress); // Interpolate back to standing position
        fixOffsetZ = depth / -4;
    }

    // Linear interpolation helper
    float lerp(float start, float end, float t) {
        return start + t * (end - start);
    }
}
