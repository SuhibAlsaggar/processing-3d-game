class PlayerCamera {
    Player player; // Reference to the player to follow
    PVector offset; // Offset from the player position
    PVector currentPosition; // Current position of the camera for smooth movement

    // Constructor to initialize with player and offset
    PlayerCamera(Player player, PVector offset) {
        this.player = player;
        this.offset = offset;
        this.currentPosition = PVector.add(player.position, offset);
    }

    void update() {
        // Target camera position based on player position and offset
        PVector targetPosition = PVector.add(player.position, offset);

        // Smoothly interpolate current camera position towards target position
        currentPosition.lerp(targetPosition, 0.1); // Adjust lerp factor for desired smoothness

        camera(
            currentPosition.x, currentPosition.y, currentPosition.z, // Camera position
            player.position.x, player.position.y, player.position.z, // Look-at point (player's position)
            0, 1, 0 // Up direction
        );
    }
}
