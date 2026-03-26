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

    xpos = xp - swidth/2;
    ypos = yp;

    sposMin = ypos;
    sposMax = ypos + sheight - swidth;

    spos = sposMin;   //  start at far left
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
      newspos = constrain(mouseY - swidth/2, sposMin, sposMax);
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

    rect(xpos, spos, swidth, swidth);
  }

  // Returns value between 0 and 1
  float getPercent() {
    return (spos - sposMin) / (sposMax - sposMin);
  }
}
