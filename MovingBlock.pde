class MovingBlock extends Block {
    PVector startPosition;
    PVector endPosition;
    float speed;
    boolean movingForward = true;
    PVector lastPosition;

    // Constructor with color
    MovingBlock(float x, float y, float z, float width, float height, float depth, color blockColor, PVector endPosition, float speed) {
        super(x, y, z, width, height, depth, blockColor); // Calls color-based Block constructor
        this.startPosition = new PVector(x, y, z);
        this.endPosition = endPosition;
        this.speed = speed;
        this.lastPosition = position.copy();
    }

    // Constructor with texture
    MovingBlock(float x, float y, float z, float width, float height, float depth, PImage textureImage, PVector endPosition, float speed) {
        super(x, y, z, width, height, depth, textureImage, 0, 0); // Calls texture-based Block constructor
        this.startPosition = new PVector(x, y, z);
        this.endPosition = endPosition;
        this.speed = speed;
        this.lastPosition = position.copy();
    }

    void update() {
        lastPosition = position.copy();

        PVector direction = (movingForward ? PVector.sub(endPosition, startPosition) : PVector.sub(startPosition, endPosition)).normalize().mult(speed);
        position.add(direction);

        if (movingForward && position.dist(endPosition) < speed) {
            movingForward = false;
        } else if (!movingForward && position.dist(startPosition) < speed) {
            movingForward = true;
        }
    }

    PVector getDisplacement() {
        return PVector.sub(position, lastPosition); // Calculate how much the platform moved
    }

    // Override the display method to update position before displaying
    @Override
    void display() {
        update();
        super.display();
    }
}
