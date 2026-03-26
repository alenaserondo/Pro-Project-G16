
// Wrote flight class - China Lynch 10/3/26 2:30pm
// Created search bar and drop down filter for dates - China
boolean dropdownOpen = false;
int selected = -1;
ArrayList<Flights> filtered = new ArrayList<Flights>();
ArrayList<String> flightsDisplay = new ArrayList<String>();   // dropdown display

// dropdown pos
int dx = 100, dy = 200, dw = 200, dh = 30;

String startDateText = "";
String endDateText = "";
boolean typingStart = false;
boolean typingEnd = false;

// search bar pos
int sx = 100, sy = 50, sw = 200, sh = 30;
int ex = 100, ey = 100;

// draw()
// if (currentScreen == screens.get(2)) {
//   drawFilterScreen();
//}


// Create date range filtering methods - China Lynch 24/03/26 3:30pm
// Adds flights to new ArrayList if in date range
ArrayList<Flights> listOfDateMatch(int startDate, int endDate)
{
  ArrayList<Flights> dateMatch = new ArrayList<Flights>();
  for (Flights f : flights)   // Flights == type, flights == arrayList of flights
  {
    if (f.inRange(startDate, endDate))
    {
      dateMatch.add(f);
    }
  }
  return dateMatch;
}

void drawFilterScreen() {
  // search bars
  drawSearchBars();
  drawSearchBars();

  // dropdown
  drawDropdown();
}

void drawSearchBars() {
  // Start search
  fill(typingStart ? 220 : 240);
  stroke(0);
  rect(sx, sy, sw, sh);
  fill(0);
  text("Start Date (MMDDYYYY): " + startDateText, sx + 10, sy + 20);

  // End search
  fill(typingEnd ? 220 : 240);
  stroke(0);
  rect(ex, ey, sw, sh);
  fill(0);
  text("End Date (MMDDYYYY):   " + endDateText, ex + 10, ey + 20);
}

// dropdown display
void drawDropdown() {
  fill(240);
  stroke(0);
  rect(dx, dy, dw, dh);

  fill(0);
  if (selected == -1) text("Select flight", dx + 20, dy + 30);
  else text(flightsDisplay.get(selected), dx + 20, dy + 30);

  if (dropdownOpen) {
    for (int i = 0; i < flightsDisplay.size(); i++) {
      int iy = dy + dh * (i + 1);
      fill(255);
      rect(dx, iy, dw, dh);
      fill(0);
      text(flightsDisplay.get(i), dx + 10, iy + 20);
    }
  }
}

void mousePressed()
{
  // searching flight dates
  if (currentScreen == screens.get(2)) {

    // mouse click start search box
    if (mouseX > sx && mouseX < sx + sw && mouseY > sy && mouseY < sy + sh) {
      typingStart = true;
      typingEnd = false;
      return;
    }

    // end
    if (mouseX > ex && mouseX < ex + sw && mouseY > ey && mouseY < ey + sh) {
      typingEnd = true;
      typingStart = false;
      return;
    }

    // clicking on dropdown box
    if (mouseX > dx && mouseX < dx + dw && mouseY > dy && mouseY < dy + dh) {
      dropdownOpen = !dropdownOpen;
      return;
    }

    // dropdown selection
    if (dropdownOpen) {
      for (int i = 0; i < flightsDisplay.size(); i++) {
        int iy = dy + dh * (i + 1);
        if (mouseX > dx && mouseX < dx + dw && mouseY > iy && mouseY < iy + dh) {
          selected = i;
          dropdownOpen = false;
          return;
        }
      }
      dropdownOpen = false;
    }
  }
}

// user entries
void keyPressed() {

  // when backspace pressed we delete
  if (key == BACKSPACE) {
    if (typingStart && startDateText.length() > 0)
      startDateText = startDateText.substring(0, startDateText.length() - 1);

    if (typingEnd && endDateText.length() > 0)
      endDateText = endDateText.substring(0, endDateText.length() - 1);
    return;
  }

  // Only ints allowed
  if (key >= '0' && key <= '9') {

    if (typingStart && startDateText.length() < 8)
      startDateText += key;

    if (typingEnd && endDateText.length() < 8)
      endDateText += key;
  }

  // When both dates are 8 digits → filter
  if (startDateText.length() == 8 && endDateText.length() == 8) {
    filterFlights();
  }
}

void filterFlights() {

  flightsDisplay.clear();
  filtered.clear();

  int start = int(startDateText);
  int end = int(endDateText);

  filtered = listOfDateMatch(start, end);

  for (Flights f : filtered) {
    String label = f.airlineName() + f.depTime + " " + f.date;
    flightsDisplay.add(label);
  }
  selected = -1;
  dropdownOpen = false;
}
