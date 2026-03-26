import java.util.HashSet;
import controlP5.*;
//data reading - Nora Holden 10/03/2026 2:25pm
ArrayList<Flights> flights = new ArrayList<Flights>(); //creates an empty arraylist
ArrayList<Flights> airportFilter = new ArrayList<Flights>(); // 25/03/2026 17:25 Nora Holden
ArrayList<Airport> airport = new ArrayList<Airport>();
ArrayList<Airline> airline = new ArrayList<Airline>();
Airline a;
//Screens - Alyx Harmon
ArrayList<Screen> screens;
Screen currentScreen;
//date
PImage homescreenIcon;
String enteredText = "";

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
  
  
   size(600, 400);
  
  cp5 = new ControlP5(this);

  data = loadTable("flights2k.csv", "header");

  for (int i = 0; i < data.getRowCount(); i++) {
    String flightNum = data.getString(i, "MKT_CARRIER_FL_NUM");
    String carrier = data.getString(i, "MKT_CARRIER");

    Airline a = new Airline(flightNum, carrier);
    a.setFlightNum(flightNum);
    a.setCarrierCode(carrier);

    if (!flightsByAirline.containsKey(carrier)) { // if airline not seen before 
      flightsByAirline.put(carrier, new ArrayList<Airline>());  // add flight to that airline's list
      airlineCodes.add(carrier);
    }

    flightsByAirline.get(carrier).add(a);
  }

  airlineDDL = cp5.addDropdownList("Airlines")
                 .setPosition(50, 100)
                 .setSize(200, 200);

  customizeAirlineDDL();

  flightDDL = cp5.addDropdownList("Flights")
                .setPosition(300, 100)
                .setSize(200, 200);

  customizeFlightDDL();
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


//Airline filter : Alena Serondo 25.03.26

import controlP5.*;
import java.util.*;

ControlP5 cp5;
DropdownList airlineDDL;
DropdownList flightDDL;

Table data;
HashMap<String, ArrayList<Airline>> flightsByAirline = new HashMap<String, ArrayList<Airline>>();
ArrayList<String> airlineCodes = new ArrayList<String>();


void customizeAirlineDDL() {
  airlineDDL.setBackgroundColor(color(190));
  airlineDDL.setItemHeight(20);
  airlineDDL.setBarHeight(20);
  airlineDDL.getCaptionLabel().setText("Select Airline");

  for (int i = 0; i < airlineCodes.size(); i++) {
    airlineDDL.addItem(airlineCodes.get(i), i);
  }
}

void customizeFlightDDL() {
  flightDDL.setBackgroundColor(color(190));
  flightDDL.setItemHeight(20);
  flightDDL.setBarHeight(20);
  flightDDL.getCaptionLabel().setText("Select Flight");
}


void controlEvent(ControlEvent theEvent) {

  if (theEvent.getController().getName().equals("Airlines")) {

    int index = int(theEvent.getValue());
    String selectedCarrier = airlineCodes.get(index);

    println("Selected airline: " + selectedCarrier);

    ArrayList<Airline> flights = flightsByAirline.get(selectedCarrier);

    flightDDL.clear();

    for (int i = 0; i < flights.size(); i++) {
      flightDDL.addItem(flights.get(i).getFlightNum(), i);
    }
  }

  if (theEvent.getController().getName().equals("Flights")) {

    int index = int(theEvent.getValue());
    println("Selected flight index: " + index);
  }
}
