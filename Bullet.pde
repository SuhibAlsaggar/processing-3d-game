class Bullet extends Collider {
    PVector direction;
    float speed;
    float maxRange;
    float distanceTraveled;
    boolean isPendingRemoval = false;
    float size = 2;

    Bullet(PVector position, PVector direction, float speed, float maxRange, AudioSample fireSoundSample, float size) {
        super(position.x, position.y, position.z, size, size, size);
        this.direction = direction.copy().normalize();
        this.speed = speed;
        this.maxRange = maxRange;
        this.distanceTraveled = 0;
        this.size = size;

        // Play the firing sound for this bullet
        if (fireSoundSample != null) {
            fireSoundSample.setGain(-20);
            fireSoundSample.trigger();
        }
    }

    void update() {
        // Move the bullet forward in its direction
        PVector velocity = PVector.mult(direction, speed);
        position.add(velocity);

        // Update the distance traveled
        distanceTraveled += speed;
    }

    // Check if the bullet has collided with any other collider, excluding the player
    boolean hasHit(Collider other) {
        // Ignore collision if `other` is a player
        if (other instanceof Player) {
            return false;
        }
        if (other != this && isCollidingWith(other)) {
            return true;
        }
        return false;
    }

    // Check if the bullet has traveled beyond its range
    boolean isOutOfRange() {
        return distanceTraveled >= maxRange;
    }

    void display() {
        pushMatrix();
        translate(position.x, position.y, position.z);
        fill(200, 200, 0); // Color of the bullet
        sphere(size); // Draw bullet as a small sphere
        popMatrix();
    }

    @Override
    void onColliderEnter(Collider other) {}

    @Override
    void onColliderExit(Collider other) {}

    @Override
    void onCollision(Collider other, PVector collisionNormal) {
        isPendingRemoval = hasHit(other);
    }
}
