abstract class Collider {
    PVector position;
    float width, height, depth;
    boolean isColliding = false;

    Collider(float x, float y, float z, float width, float height, float depth) {
        position = new PVector(x, y, z);
        this.width = width;
        this.height = height;
        this.depth = depth;
    }

    // Method to check if there is a collision
    boolean isCollidingWith(Collider other) {
        // Uniform calculation of overlap bounds for all axes
        boolean xOverlap = abs(this.position.x - other.position.x) < (this.width + other.width) * 0.5;
        boolean yOverlap = abs(this.position.y - other.position.y) < (this.height + other.height) * 0.5;
        boolean zOverlap = abs(this.position.z - other.position.z) < (this.depth + other.depth) * 0.5;

        return xOverlap && yOverlap && zOverlap;
    }

    // Method to get the collision direction as a PVector
    PVector getCollisionNormal(Collider other) {
        float xOverlap = (this.width + other.width) * 0.5 - abs(this.position.x - other.position.x);
        float yOverlap = (this.height + other.height) * 0.5 - abs(this.position.y - other.position.y);
        float zOverlap = (this.depth + other.depth) * 0.5 - abs(this.position.z - other.position.z);

        // Initialize a normal vector
        PVector normal = new PVector(0, 0, 0);

        // Determine the primary collision axis based on smallest overlap
        if (xOverlap < yOverlap && xOverlap < zOverlap) {
            normal.x = this.position.x > other.position.x ? 1 : -1;
        } else if (yOverlap < xOverlap && yOverlap < zOverlap) {
            normal.y = this.position.y > other.position.y ? -1 : 1;
        } else {
            normal.z = this.position.z > other.position.z ? 1 : -1;
        }

        return normal;
    }

    abstract void onColliderEnter(Collider other);
    abstract void onColliderExit(Collider other);
    abstract void onCollision(Collider other, PVector collisionNormal);
}
