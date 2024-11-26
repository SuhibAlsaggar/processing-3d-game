import java.util.ArrayList;
import java.util.HashMap;

class CollisionManager {
    ArrayList < Collider > colliders; // List of all colliders to manage
    HashMap < String, Boolean > collisionStates; // Tracks collision state for each pair of colliders

    CollisionManager() {
        colliders = new ArrayList < Collider > ();
        collisionStates = new HashMap < String, Boolean > ();
    }

    // Add a collider to the manager
    void addCollider(Collider collider) {
        colliders.add(collider);
    }

    // Remove a collider from the manager
    void removeCollider(Collider collider) {
        colliders.remove(collider);
    }

    // Unique key for each collider pair
    String getColliderPairKey(Collider a, Collider b) {
        return min(a.hashCode(), b.hashCode()) + "-" + max(a.hashCode(), b.hashCode());
    }

    // Detect all collisions and prepare collision states
    void detectCollisions() {
        for (int i = 0; i < colliders.size(); i++) {
            Collider colliderA = colliders.get(i);

            for (int j = i + 1; j < colliders.size(); j++) {
                Collider colliderB = colliders.get(j);
                String pairKey = getColliderPairKey(colliderA, colliderB);

                boolean currentlyColliding = colliderA.isCollidingWith(colliderB);
                boolean wasColliding = collisionStates.getOrDefault(pairKey, false);

                if (currentlyColliding) {
                    // If starting a new collision, call onColliderEnter for each
                    if (!wasColliding) {
                        colliderA.onColliderEnter(colliderB);
                        colliderB.onColliderEnter(colliderA);
                    }
                    // Mark this pair as currently colliding
                    collisionStates.put(pairKey, true);
                } else {
                    // If ending a collision, call onColliderExit for each
                    if (wasColliding) {
                        colliderA.onColliderExit(colliderB);
                        colliderB.onColliderExit(colliderA);
                    }
                    // Mark this pair as no longer colliding
                    collisionStates.put(pairKey, false);
                }
            }
        }
    }

    // Respond to all detected collisions
    void respondToCollisions() {
        for (int i = 0; i < colliders.size(); i++) {
            Collider colliderA = colliders.get(i);

            for (int j = i + 1; j < colliders.size(); j++) {
                Collider colliderB = colliders.get(j);
                String pairKey = getColliderPairKey(colliderA, colliderB);

                // Only respond if the pair is currently colliding
                if (collisionStates.getOrDefault(pairKey, false)) {
                    PVector collisionNormalA = colliderA.getCollisionNormal(colliderB);
                    PVector collisionNormalB = colliderB.getCollisionNormal(colliderA);

                    // Apply collision response
                    colliderA.onCollision(colliderB, collisionNormalA);
                    colliderB.onCollision(colliderA, collisionNormalB);
                }
            }
        }
    }

    // Update collisions by detecting and then responding
    void updateCollisions() {
        detectCollisions(); // Phase 1: Detect collisions
        respondToCollisions(); // Phase 2: Apply responses
    }
}
