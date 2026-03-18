//Alena - Scroll LOgic 18.03.26

boolean firstMousePress = false;
HScrollbar hs;

String[] items = new String[100];
int visibleCount = 10; // number of visible items

void setup() {
  size(400, 400);
  noStroke();

  // Fill list
  for (int i = 0; i < items.length; i++) {
    items[i] = "Item " + (i + 1);
  }

  hs = new HScrollbar(50, height - 30, 300, 16, 10);
}

void draw() {
  background(255);

  hs.update();
  hs.display();

  // ✅ Correct scroll percentage (0 → 1)
  float scrollPercent = hs.getPercent();

  int maxStart = items.length - visibleCount;
  int startIndex = int(scrollPercent * maxStart);

  // Draw visible items
  fill(0);
  textSize(16);

  for (int i = 0; i < visibleCount; i++) {
    int index = startIndex + i;
    if (index < items.length) {
      text(items[index], 50, 40 + i * 30);
    }
  }

  if (firstMousePress) {
    firstMousePress = false;
  }
}

void mousePressed() {
  if (!firstMousePress) {
    firstMousePress = true;
  }
}

class HScrollbar {
  int swidth, sheight;
  float xpos, ypos;
  float spos, newspos;
  float sposMin, sposMax;
  int loose;
  boolean over;
  boolean locked;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;

    xpos = xp;
    ypos = yp - sheight/2;

    sposMin = xpos;
    sposMax = xpos + swidth - sheight;

    spos = sposMin;   // ✅ start at far left
    newspos = spos;

    loose = l;
  }

  void update() {
    over = overEvent();

    if (firstMousePress && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }

    if (locked) {
      newspos = constrain(mouseX - sheight/2, sposMin, sposMax);
    }

    if (abs(newspos - spos) > 1) {
      spos += (newspos - spos) / loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    return (mouseX > xpos && mouseX < xpos + swidth &&
            mouseY > ypos && mouseY < ypos + sheight);
  }

  void display() {
    fill(204);
    rect(xpos, ypos, swidth, sheight);

    if (over || locked) {
      fill(0);
    } else {
      fill(102);
    }

    rect(spos, ypos, sheight, sheight);
  }

  // ✅ Returns value between 0 and 1
  float getPercent() {
    return (spos - sposMin) / (sposMax - sposMin);
  }
}
