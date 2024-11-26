class Gun {
    Player player;
    ArrayList < Bullet > bullets;
    float bulletSpeed = 15;
    float maxRange = 1000;

    AudioSample fireSoundSample;

    Gun(Player player) {
        this.player = player;
        this.bullets = new ArrayList < Bullet > ();
    }

    void fire() {
        if (!player.isIdle() || !player.isGrounded() || player.isCrouching || player.isStandingUp) {
            return;
        }

        P3G.ammoUsed += 1;
        PVector bulletPosition = player.position.copy();
        bulletPosition.y -= player.height / 5;
        PVector bulletDirection = player.getDirection();

        fireSoundSample = P3G.minim.loadSample("audio/fire_sound.mp3");

        // Pass the player reference to the Bullet constructor
        Bullet newBullet = new Bullet(bulletPosition, bulletDirection, bulletSpeed, maxRange, fireSoundSample, 0.65);
        bullets.add(newBullet);

        // Register the new bullet with the collision manager
        P3G.collisionManager.addCollider(newBullet);

        player.isShooting = true;
        player.shootAnimationTimer = 12;
    }

    void update() {
        for (int i = bullets.size() - 1; i >= 0; i--) {
            Bullet bullet = bullets.get(i);
            bullet.update();

            if (bullet.isPendingRemoval || bullet.isOutOfRange()) {
                bullets.remove(i);
                P3G.collisionManager.removeCollider(bullet); // Remove bullet from manager
            }
        }

    }

    void display() {
        for (Bullet bullet: bullets) {
            bullet.display();
        }
    }
}
