class MovingTarget extends Target {
    PVector startPoint;
    PVector endPoint;
    float speed = 2;
    boolean movingForward = true;

    // Constructor with a specified pathway
    MovingTarget(float x, float y, float z, float size, PVector endPoint, float speed) {
        super(x, y, z, size);
        this.startPoint = new PVector(x, y, z);
        this.endPoint = endPoint;
        this.speed = speed;
    }

    // Constructor without a pathway (defaults to oscillate along X-axis)
    MovingTarget(float x, float y, float z, float size, float speed) {
        super(x, y, z, size); // Call the base Target constructor
        this.startPoint = new PVector(x, y, z);
        this.endPoint = new PVector(x + 100, y, z); // Default to moving 100 units along the X-axis
        this.speed = speed;
    }

    // Method to update the target's position along its pathway
    void update() {
        if (!isActive) return;

        // Calculate the direction of movement
        PVector direction = movingForward ? PVector.sub(endPoint, startPoint) : PVector.sub(startPoint, endPoint);
        direction.normalize().mult(speed); // Normalize and scale by speed

        // Move the position
        position.add(direction);

        // Check if it has reached the end of the pathway
        if (movingForward && position.dist(endPoint) < speed) {
            movingForward = false; // Reverse direction
        } else if (!movingForward && position.dist(startPoint) < speed) {
            movingForward = true;
        }
    }

    // Override display to include update for movement
    @Override
    void display() {
        update();
        super.display();
    }
}
