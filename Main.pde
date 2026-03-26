
// Wrote flight class - China Lynch 10/3/26 2:30pm
// Created search bar and drop down filter for dates - China
boolean dropdownOpen = false;
int selected = -1;
ArrayList<Flights> filtered = new ArrayList<Flights>();
ArrayList<String> flightsDisplay = new ArrayList<String>();   // dropdown display

// dropdown pos
int dx = 400, dy = 200, dw = 200, dh = 30;

String startDateText = "";
String endDateText = "";
String enteredText = "";
boolean typingStart = false;
boolean typingEnd = false;
boolean typingAirport = false;

// search bar pos
int sx = 400, sy = 50, sw = 200, sh = 30;
int ex = 400, ey = 100;

int ax = 50;
int ay = 170;
int aw = 200;
int ah = 50;


import java.util.HashSet;
import controlP5.*;
//data reading - Nora Holden 10/03/2026 2:25pm
ArrayList<Flights> flights = new ArrayList<Flights>(); //creates an empty arraylist
ArrayList<Flights> airportFilter = new ArrayList<Flights>(); // 25/03/2026 17:25 Nora Holden
ArrayList<Airport> airport = new ArrayList<Airport>();
ArrayList<Airline> airline = new ArrayList<Airline>();
Table data;
//Screens - Alyx Harmon
ArrayList<Screen> screens;
Screen currentScreen;
//date
PImage homescreenIcon;


//Alena - Scroll Logic 18.03.26
HScrollbar hs;
int visibleFlights = 3;
boolean firstMousePress = false;



//Heatmap - Liam McManus 18/03/2025 9:40pm
HashMap<String, Integer> stateCount = new HashMap<String, Integer>();
HashMap<String, PVector> statePositions = new HashMap<String, PVector>();
HashSet<String> seenAirports = new HashSet<String>(); //hashSet like an array but doesn't allow duplicate values
PImage usaMap;

void setup()
{
  size(800, 600);

  homescreenIcon = loadImage("plane.png");// date

  hs = new HScrollbar(width - 30, 170, 16, 400, 10);

  //data reading - Nora Holden 10/03/2026 2:25pm
  data = loadTable("flights2k.csv", "header");

  for (TableRow row : data.rows())
  {
    String origin = row.getString("ORIGIN"); //uses csv header names to find the specific data
    int depTime = row.getInt("DEP_TIME");
    String date = row.getString("FL_DATE");
    String airline= row.getString("MKT_CARRIER");
    int schDepTime = row.getInt("CRS_DEP_TIME");
    int arrTime = row.getInt("ARR_TIME");
    int status = row.getInt("CANCELLED");
    String destination = row.getString("DEST");


    Flights flight = new Flights(airline, status, date, depTime, schDepTime, arrTime, origin, destination); // creates an object of each flight using the data
    flights.add(flight); //adds the object to the arraylist
  }

  for (TableRow row : data.rows())
  {
    String code = row.getString("ORIGIN"); //uses csv header names to find the specific data
    String city = row.getString("ORIGIN_CITY_NAME");
    String state= row.getString("ORIGIN_STATE_ABR");
    int wac = row.getInt("ORIGIN_WAC");

    //loop modified so each airport is only counted once - Liam Mc 18/03/25 21:40pm
    if (!seenAirports.contains(code))
    {
      Airport airports = new Airport(code, city, state, wac ); // creates an object of each airport using the data from the row
      airport.add(airports); //adds the object to the arraylist
      seenAirports.add(code);
    }
  }

  // count number of airports per state loop - Liam 18/03/25 10pm
  for (Airport a : airport)
  {
    String state = a.state;

    if (!stateCount.containsKey(state)) //if state not in state hashmap
    {
      stateCount.put(state, 1);        //add state to hashmap with airport count = 1
    } else
    {
      stateCount.put(state, stateCount.get(state) + 1); // else increase airport count by one for that state
    }
  }

  // State positions - Liam 18/03/25 10pm
  // WEST
  statePositions.put("WA", new PVector(120, 150));
  statePositions.put("OR", new PVector(120, 200));
  statePositions.put("CA", new PVector(100, 300));
  statePositions.put("NV", new PVector(140, 270));
  statePositions.put("ID", new PVector(190, 210));
  statePositions.put("UT", new PVector(200, 280));
  statePositions.put("AZ", new PVector(200, 360));
  statePositions.put("MT", new PVector(250, 190));
  statePositions.put("WY", new PVector(260, 160)); //missing
  statePositions.put("CO", new PVector(260, 310));
  statePositions.put("NM", new PVector(260, 360));

  // MIDWEST
  statePositions.put("ND", new PVector(320, 190));
  statePositions.put("SD", new PVector(320, 230));
  statePositions.put("NE", new PVector(320, 220)); // missing
  statePositions.put("KS", new PVector(320, 280)); // missing
  statePositions.put("OK", new PVector(320, 340));
  statePositions.put("TX", new PVector(320, 420));

  statePositions.put("MN", new PVector(390, 200));
  statePositions.put("IA", new PVector(380, 270));
  statePositions.put("MO", new PVector(420, 320));
  statePositions.put("AR", new PVector(410, 360));
  statePositions.put("LA", new PVector(400, 420));

  statePositions.put("WI", new PVector(440, 240));
  statePositions.put("IL", new PVector(440, 280));
  statePositions.put("MS", new PVector(450, 390));

  statePositions.put("MI", new PVector(500, 220));
  statePositions.put("IN", new PVector(490, 280));
  statePositions.put("KY", new PVector(500, 320));
  statePositions.put("TN", new PVector(480, 340));
  statePositions.put("AL", new PVector(500, 400));

  // EAST COAST
  statePositions.put("OH", new PVector(520, 280));
  statePositions.put("WV", new PVector(560, 280));//missing
  statePositions.put("VA", new PVector(620, 300));
  statePositions.put("NC", new PVector(620, 340));
  statePositions.put("SC", new PVector(620, 380));
  statePositions.put("GA", new PVector(540, 390));
  statePositions.put("FL", new PVector(540, 460));

  statePositions.put("PA", new PVector(590, 260));
  statePositions.put("NY", new PVector(590, 220));
  statePositions.put("VT", new PVector(680, 120));
  statePositions.put("NH", new PVector(700, 140));
  statePositions.put("ME", new PVector(740, 120));

  statePositions.put("MA", new PVector(700, 180));
  statePositions.put("CT", new PVector(680, 200));
  statePositions.put("RI", new PVector(700, 200));
  statePositions.put("NJ", new PVector(660, 220));
  statePositions.put("DE", new PVector(660, 260));
  statePositions.put("MD", new PVector(640, 260));

  // NON-CONTINENTAL
  statePositions.put("AK", new PVector(100, 500));
  statePositions.put("HI", new PVector(200, 500));

  usaMap = loadImage("usaMap3.png");

  //more reading added 9:34am - Nora Holden
  for (TableRow row : data.rows())
  {
    String flightNum = row.getString("MKT_CARRIER"); //uses csv header names to find the specific data
    String carrierCode = row.getString("MKT_CARRIER_FL_NUM");



    Airline airlines = new Airline(flightNum, carrierCode); // creates an object of each airport using the data from the row
    airline.add(airlines); //adds the object to the arraylist
  }

  //Screens - Alyx Harmon
  // updated 16/03/2026
  screens = new ArrayList<Screen>();

  // homescreen (0)

  Screen homescreen = new HomeScreen(color(220, 200, 255));
  homescreen.addWidget(new Button(50, 30, 325, 50, "Go to Map"));
  homescreen.addWidget(new Button(width - 325 - 50, 30, 325, 50, "Find Flights"));

  // map screen (1)

  Screen mapScreen = new MapScreen(color(195, 240, 180));
  mapScreen.addWidget(new Button(50, 30, 325, 50, "Back to Home"));
  mapScreen.addWidget(new Button(width - 325 - 50, 30, 325, 50, "Find Flights"));

  // find flights screen (2)

  Screen flightsScreen = new FlightScreen(color(240, 180, 200));
  flightsScreen.addWidget(new Button(50, 30, 325, 50, "Back to Home"));
  flightsScreen.addWidget(new Button(width - 325 - 50, 30, 325, 50, "Go to Map"));

  screens.add(homescreen);
  screens.add(mapScreen);
  screens.add(flightsScreen);

  currentScreen = homescreen;



  //demonstration of data that has been read in - Nora Holden 10/03/2026 2:25pm



  for (Flights flight : flights) //loops through the objects
  {
    // prints data to the console
    println("flight data : " + flight.airline + " + "  + flight.depTime + " + " + flight.date  + " + " + flight.schDepTime + " + " + flight.status);
  }


  for (Airport airports : airport)
  {
    println("airport data : " + airports.code + " + " + airports.city  + " + " + airports.state + " + " + airports.wac);
  }

  for (Airline airlines : airline)
  {
    println("airline data data : " + airlines.flightNum + " + " + airlines.carrierCode);
  }

  
}

void draw()
{

  background(255);

  //Screens - Alyx Harmon

  currentScreen.draw();

  
  if (currentScreen == screens.get(1))
  {
    drawHeatMap();
  }
  // ensuring they only display when the user selects the "find flights" screen  17/03/2026 - Nora Holden
  if (currentScreen == screens.get(2))
  {
    //Alena
    hs.update();
    hs.display();
    fill(255);
    
    drawFilterScreen();

    ArrayList<Flights> listToShow; // logic to update flights when Airport filter is selected - Nora Holden 25/03/2026

    if (enteredText.length() > 0)
    {
      listToShow = airportFilter;
    } else
    {
      listToShow = flights;
    }

    float scrollPercent = hs.getPercent();
    int maxStart = listToShow.size() - visibleFlights;

    if (maxStart < 0)
    {
      maxStart = 0;
    }

    //Alena - Scroll Logic 18.03.26
    int startIndex = int(scrollPercent * maxStart);

    int y = 240;
    int x = 50;
    int a = 90;
    int b = 310;
    for (int i = 0; i < visibleFlights; i++)
    {
      int index = startIndex + i;

      if (index < listToShow.size())
      {
        Flights flight = listToShow.get(index);
        flight.drawFlightBox(x, y, a, b); // draws flights - Nora Holden

        y += 120;
        b += 120;
      }
    }
  }

  if (firstMousePress)
  {
    firstMousePress = false;
  }
}


//Screens - Alyx Harmon
void mousePressed()
{
  //alena
  firstMousePress = true;

  Button b = currentScreen.getButton(mouseX, mouseY);

  if (b != null)
  {
    if (b.label.equals("Go to Map"))
      currentScreen = screens.get(1);
    else if (b.label.equals("Find Flights"))
      currentScreen = screens.get(2);
    else if (b.label.equals("Back to Home"))
      currentScreen = screens.get(0);
  }
  
  // searching flight dates
  if (currentScreen == screens.get(2)) {

    // mouse click start search box
    if (mouseX > sx && mouseX < sx + sw && mouseY > sy && mouseY < sy + sh) {
      typingStart = true;
      typingEnd = false;
      typingAirport = false;
      return;
    }

    // end
    if (mouseX > ex && mouseX < ex + sw && mouseY > ey && mouseY < ey + sh) {
      typingEnd = true;
      typingStart = false;
      typingAirport = false;
      return;
    }
    
    //airport
      if (mouseX > ax && mouseX < ax + aw && mouseY > ay && mouseY < ay + ah) {
      typingStart = false;
      typingEnd = false;
      typingAirport = true;
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


//takes in written input - Nora Holden 24/03/2026
void keyPressed() {
  
  if (keyCode == BACKSPACE) {
    if (enteredText.length() > 0) {
      enteredText = enteredText.substring(0, enteredText.length()-1);
    }
  } else if (keyCode == DELETE) {
    enteredText = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    enteredText = enteredText + key;
  }

  airportFilter();
  
  // when backspace pressed we delete
  if (key == BACKSPACE) {
    if (typingStart && startDateText.length() > 0)
      startDateText = startDateText.substring(0, startDateText.length() - 1);

    if (typingEnd && endDateText.length() > 0)
      endDateText = endDateText.substring(0, endDateText.length() - 1);
      
     
    if (typingAirport && enteredText.length() > 0)
      enteredText = enteredText.substring(0, enteredText.length() - 1);
    return;
  }

  // Only ints allowed
  if (key >= '0' && key <= '9') {

    if (typingStart && startDateText.length() < 8)
      startDateText += key;

    if (typingEnd && endDateText.length() < 8)
      endDateText += key;
  }
  //else
  //{
  //  if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) 
  //    enteredText = enteredText + key;
  //}
  
      
  // When both dates are 8 digits → filter
  if (startDateText.length() == 8 && endDateText.length() == 8) {
    filterFlights();
  }
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

void drawFilterScreen() {

 
  

  // search bars
  drawSearchBars();
  drawSearchBars();

  // dropdown
  drawDropdown();
}


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



// filters flights to be printed based on inputted text - Nora Holden 25/03/2026
void airportFilter()
{
  airportFilter.clear(); // resets the arraylist

  for (Flights flight : flights)
  {
    if (flight.origin.equalsIgnoreCase(enteredText))
    {
      airportFilter.add(flight);
    }
  }
}

// draw heatmap function - Liam 18/03/25 10pm
void drawHeatMap()
{

  image(usaMap, 0, 140, width -100, height -200);

  int squareLength = 35;
  int maxValue = 0;
  int minIntensity = 100;
  for (int value : stateCount.values())
  {
    if (value> maxValue) maxValue = value;
  }

  for (String state : stateCount.keySet())
  {
    if (!statePositions.containsKey(state)) continue;
    int count = stateCount.get(state);
    PVector pos = statePositions.get(state);



    float intensity = map(count, 0, maxValue, minIntensity, 255);
    fill(0, intensity, 0);
    rect(pos.x, pos.y, squareLength, squareLength);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(state, pos.x + squareLength/2, pos.y + squareLength/2);
  }
  fill(0);
  textSize(20);
  textAlign(LEFT);
  text("Airports per State Heatmap", 50, 120);

  // gradient legend added - Liam 19/03/25 8:20 am
  //draw map legend
  int legendX = 300;
  int legendY = 540;
  int legendWidth = 300;
  int legendHeight = 20;

  // draw gradient bar
  for (int i = 0; i < legendWidth; i++)
  {
    float value = map(i, 0, legendWidth, 0, maxValue);
    float intensity = map(value, 0, maxValue, minIntensity, 255);

    stroke(0, intensity, 0);
    line(legendX + i, legendY, legendX + i, legendY + legendHeight);
  }

  noStroke();

  //border around legend
  noFill();
  stroke(0);
  rect(legendX, legendY, legendWidth, legendHeight);
  noStroke();

  // labels
  fill(0);
  textAlign(CENTER);
  textSize(12);

  text("0", legendX, legendY + legendHeight + 15);
  text(maxValue, legendX + legendWidth, legendY + legendHeight + 15);

  text("Number of Airports", legendX + legendWidth/2, legendY - 10);
}
