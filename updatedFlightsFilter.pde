
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

  // labels
  fill(0);
  textSize(15);
  text("Start Date (MMDDYYYY):", 50, 120);
  text("End Date (MMDDYYYY):", 50, 170);

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
  if (selected == -1) text("Select flight", dx + 10, dy + 20);
  else text(flightsDisplay.get(selected), dx + 10, dy + 20);

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
    String label = f.airlineName() + "Departure: " + f.depTime + " " + f.date;
    flightsDisplay.add(label);
  }
  selected = -1;
  dropdownOpen = false;
}

class Flights
{
  String date;
  int dateInt;
  String airline;
  int schDepTime;
  int depTime;
  int status;
  color statusCol;
  String message;
  String airlineName;
  int arrTime;
  color airlineColor;

  Flights(String airline, int status, String date, int depTime, int schDepTime, int arrTime)
  {
    this.status = status;
    this.date = date;
    this.depTime = depTime;
    this.schDepTime = schDepTime;
    this.airline = airline;
    this.arrTime = arrTime;

    // convert date into int format MMDDYYYY
    dateInt = int(date.replace("/", ""));
  }

  // Updated booleans to be boolean functions - China Lynch 10/3/26 7pm
  boolean cancelled()
  {
    if (status == 1)
    {
      return true;
    } else
    {
      return false;
    }
  }

  // Fixed late logic for visualisations - China Lynch 18/3/26 8pm
  boolean late()
  {
    return (depTime > schDepTime);
  }

  // Checks if flight is in range of dates user gives
  boolean inRange(int startDate, int endDate)
  {
    return (dateInt >= startDate && dateInt <= endDate);
  }

  String airlineName()
  {
    if ( airline.equals("AA"))
    {

      return airlineName = "American Airlines";
    } else if ( airline.equals("AS"))
    {
      return airlineName = "Alaska Airlines";
    } else if ( airline.equals("WN"))
    {
      return airlineName = "Southwest Airlines";
    } else if ( airline.equals("B6"))
    {
      return airlineName = "Jet Blue Airlines";
    } else if ( airline.equals("HA"))
    {
      return airlineName = "Hawaiian Airlines";
    } else if ( airline.equals("NK"))
    {
      return airlineName = "Spirit Airlines";
    } else
    {
      return airlineName = "name";
    }
  }
  color airlineColour()
  {
    if ( airline.equals("AA"))
    {

      return airlineColor = color(219, 3, 50);
    } else if ( airline.equals("AS"))
    {
      return airlineColor = color(23, 126, 150);
    } else if ( airline.equals("B6"))
    {
      return airlineColor = color(88, 205, 232);
    } else if ( airline.equals("HA"))
    {
      return airlineColor = color(146, 50, 179);
    } else if ( airline.equals("NK"))
    {
      return airlineColor = color(239, 255, 56);
    } else
    {
      return airlineColor = color(6, 103, 214);
    }
  }

  // Draws flight visualizations 16/03/2026 - Nora Holden
  // Updated draw method to display flight status - China Lynch 18/3/26 8:11pm
  void drawFlightBox(int x, int y, int a, int b)
  {
    int hours = depTime / 100;
    int minutes = depTime % 100;
    int length = abs(arrTime  - depTime);
    int lHours = length / 100;
    int lMinutes = length % 100;
    int aHours = arrTime / 100;
    int aMins = arrTime % 100;
    int z = 700;
    int w = 100;
    airlineColor = airlineColour();
    airlineName = airlineName();

    //stroke(0);
    fill(177, 178, 179);
    rect(x, y, z - 40, w);//10,10,10,10
    fill(statusCol);
    rect(x +( z -40), y, 30, w);
    fill(airlineColor);
    rect(x, y, 70, w);
    fill(0);
    text(airline, a - 5, b - 20);
    text(airlineName, a + 120, b - 40);
    text( date, a +120, b - 0);
    text( "loc1", a + 310, b - 40);
    text ( hours, a +300, b );
    text( ":", a+ 315, b );
    text(minutes, a + 330, b );
    text( "loc2", a + 410, b - 40);
    text ( aHours, a +400, b );
    text( ":", a+ 415, b );
    text(aMins, a + 430, b );
    text(lHours, a + 550, b - 20);
    text( ":", a+ 560, b - 20 );
    text(lMinutes, a + 575, b - 20);
    text("h", a + 590, b - 20);
    rect( a +345, b - 1, a -50, 2);

    // Fixed colour setting loops to work with functions - China Lynch 11/3/26 9pm
    // Rotate text - Nora Holden 18/03/2026
    if (late())
    {
      statusCol = color(#FFA30D); // orange
      pushMatrix();
      translate( x + ( z - 25), y + w/2);
      rotate(-HALF_PI);
      fill(0);
      text("LATE", 0, 0);
      popMatrix();
    } else if (cancelled())
    {
      statusCol = color(#FF0D0D); // red
      pushMatrix();
      translate( x + ( z - 25), y + w/2);
      rotate(-HALF_PI);
      fill(0);
      text("CANCELLED", 0, 0);
      popMatrix();
    } else
    {
      statusCol = color(#0DFF4A); // green
      pushMatrix();
      translate( x + ( z - 25), y + w/2);
      rotate(-HALF_PI);
      fill(0);
      text("ON TIME", 0, 0);
      popMatrix();
    }
  }
}
