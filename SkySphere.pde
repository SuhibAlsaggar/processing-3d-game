class SkySphere {
    PImage skyTexture;
    float radius;

    // Constructor to initialize the texture and radius
    SkySphere(PImage skyTexture, float radius) {
        this.skyTexture = skyTexture;
        this.radius = radius;
    }

    // Display the skysphere
    void display() {
        pushMatrix();

        // Set texture mode and wrap
        textureMode(NORMAL);
        textureWrap(REPEAT);

        // Translate to center of the scene
        translate(800, -1600, 0);
        fill(255);

        // Begin rendering a sphere using TRIANGLE_STRIP
        beginShape(TRIANGLE_STRIP);
        texture(skyTexture);

        // Loop through latitudes and longitudes
        for (int lat = 0; lat <= 20; lat++) {
            float theta1 = map(lat, 0, 20, -HALF_PI, HALF_PI);
            float theta2 = map(lat + 1, 0, 20, -HALF_PI, HALF_PI);

            for (int lon = 0; lon <= 40; lon++) {
                float phi = map(lon, 0, 40, -PI, PI);

                // First point
                float x1 = radius * cos(theta1) * cos(phi);
                float y1 = radius * sin(theta1);
                float z1 = radius * cos(theta1) * sin(phi);
                float u1 = map(lon, 0, 40, 0, 1);
                float v1 = map(lat, 0, 20, 0, 1);
                vertex(x1, y1, z1, u1, v1);

                // Second point
                float x2 = radius * cos(theta2) * cos(phi);
                float y2 = radius * sin(theta2);
                float z2 = radius * cos(theta2) * sin(phi);
                float u2 = u1;
                float v2 = map(lat + 1, 0, 20, 0, 1);
                vertex(x2, y2, z2, u2, v2);
            }
        }

        endShape();

        // Reset texture mode for other objects
        textureMode(IMAGE);

        popMatrix();
    }
}
