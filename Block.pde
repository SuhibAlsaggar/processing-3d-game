class Block extends Collider {
    color blockColor;
    PImage textureImage;
    float repeatX;
    float repeatY;

    // Constructor with color parameter (no texture)
    Block(float x, float y, float z, float width, float height, float depth, color blockColor) {
        super(x, y, z, width, height, depth);
        this.blockColor = blockColor;
        this.textureImage = null;
        this.repeatX = 1;
        this.repeatY = 1;
    }

    // Constructor with texture image and optional repeat parameters
    Block(float x, float y, float z, float width, float height, float depth, PImage textureImage, float repeatX, float repeatY) {
        super(x, y, z, width, height, depth);
        this.textureImage = textureImage;
        this.blockColor = color(255); // Default to white if no color is provided
        this.repeatX = repeatX > 0 ? repeatX : 1; // Default to 1 if invalid value
        this.repeatY = repeatY > 0 ? repeatY : 1; // Default to 1 if invalid value
    }

    // Display the block with either color or texture
    void display() {
        pushMatrix();
        translate(position.x, position.y, position.z);

        if (textureImage != null) {
            // Enable texture repeating
            fill(255);
            textureWrap(REPEAT);
            beginShape(QUADS);
            texture(textureImage);

            // Front face
            vertex(-width / 2, -height / 2, depth / 2, 0, 0);
            vertex(width / 2, -height / 2, depth / 2, textureImage.width * repeatX, 0);
            vertex(width / 2, height / 2, depth / 2, textureImage.width * repeatX, textureImage.height * repeatY);
            vertex(-width / 2, height / 2, depth / 2, 0, textureImage.height * repeatY);

            // Back face
            vertex(width / 2, -height / 2, -depth / 2, 0, 0);
            vertex(-width / 2, -height / 2, -depth / 2, textureImage.width * repeatX, 0);
            vertex(-width / 2, height / 2, -depth / 2, textureImage.width * repeatX, textureImage.height * repeatY);
            vertex(width / 2, height / 2, -depth / 2, 0, textureImage.height * repeatY);

            // Right face
            vertex(width / 2, -height / 2, depth / 2, 0, 0);
            vertex(width / 2, -height / 2, -depth / 2, textureImage.width * repeatX, 0);
            vertex(width / 2, height / 2, -depth / 2, textureImage.width * repeatX, textureImage.height * repeatY);
            vertex(width / 2, height / 2, depth / 2, 0, textureImage.height * repeatY);

            // Left face
            vertex(-width / 2, -height / 2, -depth / 2, 0, 0);
            vertex(-width / 2, -height / 2, depth / 2, textureImage.width * repeatX, 0);
            vertex(-width / 2, height / 2, depth / 2, textureImage.width * repeatX, textureImage.height * repeatY);
            vertex(-width / 2, height / 2, -depth / 2, 0, textureImage.height * repeatY);

            // Top face
            vertex(-width / 2, -height / 2, -depth / 2, 0, 0);
            vertex(width / 2, -height / 2, -depth / 2, textureImage.width * repeatX, 0);
            vertex(width / 2, -height / 2, depth / 2, textureImage.width * repeatX, textureImage.height * repeatY);
            vertex(-width / 2, -height / 2, depth / 2, 0, textureImage.height * repeatY);

            // Bottom face
            vertex(-width / 2, height / 2, depth / 2, 0, 0);
            vertex(width / 2, height / 2, depth / 2, textureImage.width * repeatX, 0);
            vertex(width / 2, height / 2, -depth / 2, textureImage.width * repeatX, textureImage.height * repeatY);
            vertex(-width / 2, height / 2, -depth / 2, 0, textureImage.height * repeatY);

            endShape();
        } else {
            // If no texture, apply color and draw a simple box
            fill(blockColor);
            box(width, height, depth);
        }

        popMatrix();
    }

    @Override
    void onColliderEnter(Collider other) {}

    @Override
    void onColliderExit(Collider other) {}

    @Override
    void onCollision(Collider other, PVector collisionNormal) {}
}
