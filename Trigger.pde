import java.util.function.Consumer;

class Trigger extends Collider {
    private Consumer < Collider > onEnterCallback;
    private Consumer < Collider > onExitCallback;
    private TwoParameterCallback < Collider, PVector > onCollisionCallback;

    // Constructor with callbacks
    Trigger(float x, float y, float z, float width, float height, float depth,
        Consumer < Collider > onEnterCallback,
        Consumer < Collider > onExitCallback,
        TwoParameterCallback < Collider, PVector > onCollisionCallback) {
        super(x, y, z, width, height, depth);
        this.onEnterCallback = onEnterCallback;
        this.onExitCallback = onExitCallback;
        this.onCollisionCallback = onCollisionCallback;
    }

    // Display the block with either color or texture
    void display() {
        pushMatrix();
        translate(position.x, position.y, position.z);
        noFill();
        stroke(255);
        box(width, height, depth);
        noStroke();
        popMatrix();
    }

    @Override
    void onColliderEnter(Collider other) {
        if (other instanceof Player) return;
        if (onEnterCallback != null) {
            onEnterCallback.accept(other); // Trigger the callback
        }
    }

    @Override
    void onColliderExit(Collider other) {
        if (other instanceof Player) return;
        if (onExitCallback != null) {
            onExitCallback.accept(other); // Trigger the callback
        }
    }

    @Override
    void onCollision(Collider other, PVector collisionNormal) {
        if (other instanceof Player) return;
        if (onCollisionCallback != null) {
            onCollisionCallback.accept(other, collisionNormal); // Trigger the callback
        }
    }
}

@FunctionalInterface
interface TwoParameterCallback < T, U > {
    void accept(T t, U u);
}
