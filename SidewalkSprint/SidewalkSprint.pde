// Sidewalk Sprint - A compact endless-runner game prototype built with Processing (Java mode).
// Built from simple shapes in Processing (Java mode).

float playerX = 0;
float walkSpeed = 3;
float scrollPosition = 0;
boolean gameOver = false;

// Parallel arrays hold the changing data for each pedestrian.
float[] pedestrianX = new float[6];
float[] pedestrianY = new float[6];
float[] pedestrianSpeed = new float[6];

// Parallel arrays hold the position of each no-sugar drink can.
float[] cokeX = new float[3];
float[] cokeY = new float[3];

// Each tree keeps its own position and randomised appearance.
float[] treeX = new float[6];
float[] treeY = new float[6];
float[] treeScale = new float[6];
int[] treeBulbs = new int[6];
float[] treeRadius = new float[6];

void setup() {
  size(400, 600);
  smooth();
  
  for (int i = 0; i < 6; i++) {
    pedestrianX[i] = random(105, 295);
    pedestrianY[i] = -75 - i * 120;
    pedestrianSpeed[i] = random(2, 5);
  }
  
  for (int i = 0; i < 3; i++) {
    cokeX[i] = random(94, 306);
    cokeY[i] = -100 - i * 200;
  }
  
  for (int row = 0; row < 3; row++) {
    for (int side = 0; side < 2; side++) {
      int treeIndex = row * 2 + side;
      treeY[treeIndex] = 120 + row * 220;
      randomiseTree(treeIndex);
    }
  }
}

void draw() {
  // Only update positions while the game is active.
  if (gameOver == false) {
    scrollPosition = scrollPosition + walkSpeed;
    
    // Move each pedestrian at its own speed and check for a collision.
    for (int i = 0; i < 6; i++) {
      pedestrianY[i] = pedestrianY[i] + pedestrianSpeed[i];
      if (pedestrianY[i] > height + 50) {
        respawnPedestrian(i);
      }
      
      if (abs(200 + playerX - pedestrianX[i]) < 43 && 
          pedestrianY[i] > 395 && pedestrianY[i] < 585) {
        gameOver = true;
      }
    }
    
    // Cans travel at the same speed as the paving and are collected on contact.
    for (int i = 0; i < 3; i++) {
      cokeY[i] = cokeY[i] + walkSpeed;
      if (cokeY[i] > height + 20) {
        respawnCoke(i);
      } else if (abs(200 + playerX - cokeX[i]) < 32 &&
                  cokeY[i] > 425 && cokeY[i] < 545) {
        respawnCoke(i);
      }
    }
    
    // Move trees with the walk. Each replacement gets a new appearance.
    for (int i = 0; i < 6; i++) {
      treeY[i] = treeY[i] + walkSpeed;
      if (treeY[i] > height + 100) {
        treeY[i] = -random(100, 240);
        randomiseTree(i);
      }
    }
  }
  
  // Grass strips: each is one fifth of the canvas width (80 pixels).
  noStroke();
  fill(105, 166, 91);
  rect(0, 0, 80, 600);
  rect(320, 0, 80, 600);
  
  // Wally's walk: three fifths of the canvas width (240 pixels).
  drawWalk();
  
  // Soft path edges help the walk stand out from the grass.
  fill(194, 185, 161);
  rect(77, 0, 3, 600);
  rect(320, 0, 3, 600);
  
  // Three randomised trees on each side, drawn with nested loops.
  drawTrees();
  
  // Key guide
  fill(81, 91, 85);
  textAlign(CENTER);
  textSize(12);
  text("A  <  MOVE LEFT      MOVE RIGHT  >  D", 200, 24);
  
  // Draw the oncoming pedestrians and the drinks on the walk.
  for (int i = 0; i < 6; i++) {
    drawPedestrian(pedestrianX[i], pedestrianY[i]);
  }
  for (int i = 0; i < 3; i++) {
    drawCoke(cokeX[i], cokeY[i]);
  }
  
  // Player near the bottom: a cyclist made from several simple shapes.
  // playerShift moves each shape directly without using a transformation.
  float playerShift = 8 + playerX;
  // Wheels
  noFill();
  stroke(39, 49, 61);
  strokeWeight(5);
  ellipse(157 + playerShift, 522, 40, 40);
  ellipse(226 + playerShift, 522, 40, 40);
  // Bicycle frame
  stroke(40, 126, 143);
  strokeWeight(4);
  line(157 + playerShift, 522, 185 + playerShift, 493);
  line(185 + playerShift, 493, 204 + playerShift, 522);
  line(204 + playerShift, 522, 157 + playerShift, 522);
  line(185 + playerShift, 493, 226 + playerShift, 522);
  line(204 + playerShift, 522, 218 + playerShift, 489);
  line(211 + playerShift, 489, 226 + playerShift, 489);
  // Rider's body, arms, and legs
  stroke(45, 57, 74);
  strokeWeight(9);
  line(185 + playerShift, 464, 176 + playerShift, 491);
  line(176 + playerShift, 491, 202 + playerShift, 500);
  line(184 + playerShift, 470, 211 + playerShift, 486);
  strokeWeight(6);
  line(183 + playerShift, 472, 208 + playerShift, 488);
  // Jacket and head
  noStroke();
  fill(49, 125, 145);
  ellipse(181 + playerShift, 470, 24, 34);
  fill(245, 195, 148);
  ellipse(176 + playerShift, 445, 23, 25);
  // Helmet
  fill(238, 183, 61);
  arc(176 + playerShift, 444, 28, 25, PI, TWO_PI);
  rect(163 + playerShift, 443, 27, 5, 3);
  
  // Small frame details
  stroke(39, 49, 61);
  strokeWeight(3);
  line(179 + playerShift, 489, 174 + playerShift, 494);
  line(199 + playerShift, 520, 207 + playerShift, 524);
  strokeWeight(1);
  
  // The game-over message stays fixed when movement stops.
  if (gameOver) {
    noStroke();
    fill(31, 42, 53, 205);
    rect(55, 255, 290, 90, 12);
    fill(255);
    textAlign(CENTER);
    textSize(28);
    text("GAME OVER", 200, 294);
    textSize(14);
    text("Refresh the sketch to play again", 200, 322);
  }
}

void keyPressed() {
  // Ignore all keys after a collision.
  if (gameOver == false) {
    if (key == 'a' || key == 'A') {
      playerX = playerX - 20;
    }
    if (key == 'd' || key == 'D') {
      playerX = playerX + 20;
    }
    
    // Keep the player (including the bicycle wheels) on the walk.
    if (playerX < -62) {
      playerX = -62;
    }
    if (playerX > 63) {
      playerX = 63;
    }
  }
}

void drawWalk() {
  int tileSize = 40;
  float tileOffset = scrollPosition % tileSize;
  int tileStep = int(scrollPosition / tileSize);
  
  noStroke();
  for (int row = -1; row < 16; row++) {
    for (int column = 0; column < 6; column++) {
      if ((row + column + tileStep) % 2 == 0) {
        fill(226, 218, 196);
      } else {
        fill(217, 208, 185);
      }
      rect(80 + column * tileSize,
            row * tileSize + tileOffset,
            tileSize,
            tileSize);
    }
  }
}

void drawTrees() {
  for (int row = 0; row < 3; row++) {
    for (int side = 0; side < 2; side++) {
      int treeIndex = row * 2 + side;
      drawTree(treeX[treeIndex], treeY[treeIndex],
                treeScale[treeIndex], treeBulbs[treeIndex],
                treeRadius[treeIndex]);
    }
  }
}

void drawPedestrian(float x, float y) {
  noStroke();
  fill(187, 179, 157, 100);
  ellipse(x, y + 34, 44, 12);

  stroke(54, 69, 82);
  strokeWeight(7);
  line(x - 8, y + 2, x - 11, y + 25);
  line(x + 8, y + 2, x + 11, y + 25);
  strokeWeight(1);
  noStroke();
  fill(44, 54, 67);
  ellipse(x - 14, y + 27, 13, 7);
  ellipse(x + 14, y + 27, 13, 7);

  fill(230, 127, 74);
  rect(x - 13, y - 19, 26, 31, 8);
  stroke(230, 127, 74);
  strokeWeight(6);
  line(x - 11, y - 12, x - 20, y + 2);
  line(x + 11, y - 12, x + 20, y + 2);
  strokeWeight(1);
  noStroke();
  fill(244, 197, 151);
  ellipse(x, y - 30, 22, 24);
  fill(88, 59, 48);
  arc(x, y - 32, 23, 19, PI, TWO_PI);
}

void drawCoke(float x, float y) {
  noStroke();
  fill(195, 42, 52);
  rect(x - 11, y - 17, 22, 34, 5);
  fill(235, 228, 205);
  rect(x - 8, y - 8, 16, 17, 3);
  fill(176, 37, 45);
  textAlign(CENTER, CENTER);
  textSize(5);
  text("NO", x, y - 3);
  text("SUGAR", x, y + 4);
  stroke(180, 180, 180);
  strokeWeight(2);
  line(x - 6, y - 18, x + 6, y - 18);
  strokeWeight(1);
}

void respawnPedestrian(int index) {
  pedestrianX[index] = random(105, 295);
  pedestrianY[index] = -random(70, 230);
  pedestrianSpeed[index] = random(2, 5);
}

void respawnCoke(int index) {
  cokeX[index] = random(94, 306);
  cokeY[index] = -random(45, 190);
}

void randomiseTree(int index) {
  if (index % 2 == 0) {
    treeX[index] = random(32, 48);
  } else {
    treeX[index] = random(352, 368);
  }
  treeScale[index] = random(0.75, 1.25);
  treeBulbs[index] = int(random(3, 8));
  treeRadius[index] = random(12, 18);
}

void drawTree(float x, float y, float scale, int bulbs, float radius) {
  noStroke();
  fill(112, 75, 48);
  rect(x - 5 * scale, y - 40 * scale, 10 * scale, 40 * scale);
  
  for (int branch = 0; branch < 4; branch++) {
    float branchY = y - (26 + branch * 11) * scale;
    float branchWidth = radius * 2 * (1.35 - branch * 0.15) * scale;
    float branchHeight = branchWidth * 0.72;
    if (branch % 2 == 0) {
      fill(42, 119, 61);
    } else {
      fill(52, 137, 137, 69);
    }
    ellipse(x, branchY, branchWidth, branchHeight);
  }
  
  for (int bulb = 0; bulb < bulbs; bulb++) {
    float angle = TWO_PI * bulb / bulbs;
    float bulbX = x + cos(angle) * radius * 0.82 * scale;
    float bulbY = y - 45 * scale + sin(angle) * radius * 0.72 * scale;
    if (bulb % 3 == 0) {
      fill(245, 197, 74);
    } else if (bulb % 3 == 1) {
      fill(112, 184, 207);
    } else {
      fill(112, 184, 207);
    }
    noStroke();
    ellipse(bulbX, bulbY, 5 * scale, 5 * scale);
  }
}
