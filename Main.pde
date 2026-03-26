import java.util.HashSet;
//data reading - Nora Holden 10/03/2026 2:25pm
ArrayList<Flights> flights = new ArrayList<Flights>(); //creates an empty arraylist
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

//Heatmap - Liam McManus 18/03/2026 9:40pm
HashMap<String, Integer> stateCount = new HashMap<String, Integer>();
HashMap<String, PVector> statePositions = new HashMap<String, PVector>();
HashSet<String> seenAirports = new HashSet<String>(); //hashSet like an array but doesn't allow duplicate values
PImage usaMap;
//heatmap interactive features added - Liam 25.03.2026 9pm
String hoveredState = "";
String selectedState = "";
int minAirports = 0;


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


    Flights flight = new Flights(airline, status, date, depTime, schDepTime, arrTime); // creates an object of each flight using the data
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
  statePositions.put("WA", new PVector(145, 160));
  statePositions.put("OR", new PVector(130, 210));
  statePositions.put("CA", new PVector(100, 300));
  statePositions.put("NV", new PVector(150, 270));
  statePositions.put("ID", new PVector(190, 220));
  statePositions.put("UT", new PVector(205, 290));
  statePositions.put("AZ", new PVector(200, 360));
  statePositions.put("MT", new PVector(250, 190));
  statePositions.put("WY", new PVector(250, 240));
  statePositions.put("CO", new PVector(270, 300));
  statePositions.put("NM", new PVector(260, 370));

  // MIDWEST
  statePositions.put("ND", new PVector(330, 190));
  statePositions.put("SD", new PVector(330, 230));
  statePositions.put("NE", new PVector(340, 275));
  statePositions.put("KS", new PVector(340, 315));
  statePositions.put("OK", new PVector(360, 360));
  statePositions.put("TX", new PVector(340, 420));
  
  statePositions.put("MN", new PVector(390, 200));
  statePositions.put("IA", new PVector(400, 265));
  statePositions.put("MO", new PVector(415, 320));
  statePositions.put("AR", new PVector(420, 370));
  statePositions.put("LA", new PVector(420, 425));
  
  statePositions.put("WI", new PVector(440, 220));
  statePositions.put("IL", new PVector(450, 285));
  statePositions.put("MS", new PVector(455, 395));
  
  statePositions.put("MI", new PVector(500, 220));
  statePositions.put("IN", new PVector(490, 280));
  statePositions.put("KY", new PVector(500, 320));
  statePositions.put("TN", new PVector(480, 340));
  statePositions.put("AL", new PVector(500, 400));
  
  // EAST COAST
  statePositions.put("OH", new PVector(520, 280));
  statePositions.put("WV", new PVector(560, 300));//missing
  statePositions.put("VA", new PVector(600, 300));
  statePositions.put("NC", new PVector(580, 340));
  statePositions.put("SC", new PVector(580, 380));
  statePositions.put("GA", new PVector(540, 390));
  statePositions.put("FL", new PVector(540, 460));
  
  statePositions.put("PA", new PVector(570, 260));
  statePositions.put("NY", new PVector(590, 220));
  statePositions.put("VT", new PVector(600, 180));
  statePositions.put("NH", new PVector(700, 160));
  statePositions.put("ME", new PVector(640, 160));
  
  statePositions.put("MA", new PVector(700, 200));
  statePositions.put("CT", new PVector(700, 280));
  statePositions.put("RI", new PVector(700, 240));
  statePositions.put("NJ", new PVector(700, 320));
  statePositions.put("DE", new PVector(700, 360));
  statePositions.put("MD", new PVector(700, 400));
  
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

    float scrollPercent = hs.getPercent();
    int maxStart = flights.size() - visibleFlights;

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

      if (index < flights.size())
      {
        Flights flight = flights.get(index);
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
    {
      currentScreen = screens.get(1);
      selectedState = "";
    }
    else if (b.label.equals("Find Flights"))
      currentScreen = screens.get(2);
    else if (b.label.equals("Back to Home"))
      currentScreen = screens.get(0);
  }
  
  if (currentScreen == screens.get(1))
  {
    updateSlider();
    for (String state : statePositions.keySet())
    {
      PVector pos = statePositions.get(state);
      int squareLength = 35;
      if (mouseX > pos.x && mouseX < pos.x + squareLength &&
          mouseY > pos.y && mouseY < pos.y + squareLength)
      {
        if(selectedState.equals(state))
        {
          selectedState = "";
        }
        else
        {
          selectedState = state;
        }
      }
    }
  }
  
}

void mouseDragged()
{
  updateSlider();
}

// draw heatmap function - Liam 18/03/26 10pm
// heatmap appearence updated and now also includes states with zero airports - Liam 19/03/2026 1:45pm
// interactive features added to heatmap (hover over state for more info) - Liam 25/03/2026 9pm
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

  for (String state : statePositions.keySet())
  {
    int count = 0;
    if (stateCount.containsKey(state))
    {
      count = stateCount.get(state);
    }
    if(count < minAirports)
    {
      continue;
    }
    PVector pos = statePositions.get(state);
    


    float intensity = map(count, 0, maxValue, minIntensity, 255);
    fill(intensity, 0, 255);
    rect(pos.x, pos.y, squareLength, squareLength);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(state, pos.x + squareLength/2, pos.y + squareLength/2);
    
    if (mouseX > pos.x && mouseX < pos.x + squareLength 
        && mouseY > pos.y && mouseY < pos.y + squareLength)
    {
      hoveredState = state;
    }
  }
  
  if (hoveredState != "")
  {
    int count = 0;
    if (stateCount.containsKey(hoveredState))
    {
      count = stateCount.get(hoveredState);
    }
    
    fill(255);
    stroke(150);
    rect(mouseX , mouseY-25, 140, 25);
    
    fill(0);
    textAlign(LEFT, CENTER);
    textSize(16);
    text(hoveredState + ": " + count + " airports", mouseX + 5, mouseY - 12);
    hoveredState = "";
  }
  
  if (selectedState != "")
  {
    stroke (0);

    
    for (TableRow row : data.rows())
    {
      String originState = row.getString("ORIGIN_STATE_ABR");
      String destState = row.getString("DEST_STATE_ABR");
      
      if(originState.equals(selectedState))
      {
        if(statePositions.containsKey(destState))
        {
          PVector start = statePositions.get(originState);
          PVector end = statePositions.get(destState);
          
          noFill();
          bezier(start.x + squareLength /2 , start.y + squareLength / 2,
                 start.x, start.y - 50, 
                 end.x, end.y-50, 
                 end.x + squareLength / 2, end.y );
        }
      }
    }
  }
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(30);

  text("Airports per State Heatmap", 410, 120);

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

    stroke(intensity, 0, 255);
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
  
   // slider added - Liam 26/03/2026 11pm
  float handleX = map(minAirports, 0, maxValue, legendX, legendX + legendWidth);
  float handleY = legendY;
  
  fill(255, 0, 0);
  stroke(0);
  rect(handleX, handleY, 10, legendHeight);
  
  fill(0);
  textAlign(CENTER);
  textSize(14);
  text("Min Airports: " + minAirports, legendX + legendWidth/2, legendY - 25);


  text("Number of Airports", legendX + legendWidth/2, legendY - 10);
}

void updateSlider()
{
  int legendX = 300;
  int legendY = 540;
  int legendWidth = 300;
  
  if (mouseX> legendX && mouseX < legendX + legendWidth &&
      mouseY > legendY && mouseY < legendY + 20)
  {
    float percent = map(mouseX, legendX, legendX + legendWidth, 0, 1.01);
    
    int maxValue = 0;
    for (int value : stateCount.values())
    {
      if (value>maxValue) maxValue = value;
    }
    
    minAirports = int(percent * maxValue);
  }
}
