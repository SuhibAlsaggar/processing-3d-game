class Target extends Collider {
    boolean isActive = true;
    AudioPlayer pointSound;
    PShape targetModel;

    // Constructor
    Target(float x, float y, float z, float size) {
        super(x, y, z, size, size, 15.5);
        pointSound = P3G.minim.loadFile("audio/point.mp3");
        targetModel = loadShape("objects/target/target.obj");
    }

    // Method to display the target if it is active
    void display() {
        if (!isActive) return;

        pushMatrix();
        translate(position.x, position.y, position.z);
        rotateY(radians(90));
        translate(0, height / 2, 0);
        scale(50 * (width / 50));
        shape(targetModel);
        popMatrix();
    }

    // Collision response when hit by another collider
    @Override
    void onCollision(Collider other, PVector collisionNormal) {
        // Check if the collider is a bullet
        if (other instanceof Bullet) {
            // Destroy the target
            destroy();
        }
    }

    // Method to "destroy" the target by setting it inactive
    void destroy() {
        isActive = false; // Set the target as inactive
        P3G.collisionManager.removeCollider(this); // Remove from collision manager
        P3G.score += 1;

        // Play the firing sound
        if (pointSound != null) {
            pointSound.setGain(-20);
            pointSound.play();
        }
    }

    @Override
    void onColliderEnter(Collider other) {}

    @Override
    void onColliderExit(Collider other) {}
}
