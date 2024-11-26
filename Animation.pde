class Animation {
    PShape[] frames;
    int totalFrames;
    int frameCount;
    int currentFrame = 0;
    int animationStep;
    String animationName;

    // Constructor for the Animation class
    Animation(int totalFrames, String animationName, int animationStep) {
        this.totalFrames = totalFrames;
        this.animationName = animationName;
        this.animationStep = animationStep;

        frameCount = ceil(totalFrames / (float) animationStep);
        frames = new PShape[frameCount];

        // Load each OBJ file into the frames array
        int loadFramesTracker = 0;
        for (int i = 0; i < frameCount; i++) {
            String filename = "animations/" + animationName + "/frame_" + nf(loadFramesTracker + 1, 4) + ".obj";
            PShape shape = loadShape(filename);
            if (shape != null) {
                frames[i] = shape;
            } else {
                println("Warning: Failed to load " + filename);
            }
            loadFramesTracker += animationStep;
        }
    }

    // Method to display the current frame
    void display() {
        if (frames[currentFrame] != null) {
            shape(frames[currentFrame]);
        } else {
            println("Warning: Frame " + currentFrame + " is null and cannot be displayed.");
        }
        advanceFrame();
    }

    void advanceFrame() {
        currentFrame = (currentFrame + 1) % frames.length;
    }
}
