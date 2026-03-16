//data reading - Nora Holden 10/03/2026 2:25pm
ArrayList<Flights> flights = new ArrayList<Flights>(); //creates an empty arraylist
ArrayList<Airport> airport = new ArrayList<Airport>(); 
ArrayList<Airline> airline = new ArrayList<Airline>();
Table data;
//Screens - Alyx Harmon
ArrayList<Screen> screens;
Screen currentScreen;



void setup()
{
  size(800, 600);
  
  //data reading - Nora Holden 10/03/2026 2:25pm
  data = loadTable("flights2k.csv","header");
  
  for(TableRow row : data.rows())
  {
    String origin = row.getString("ORIGIN"); //uses csv header names to find the specific data
    int depTime = row.getInt("DEP_TIME");
    String date = row.getString("FL_DATE");
    String airline= row.getString("MKT_CARRIER");
    int schDepTime = row.getInt("CRS_DEP_TIME");
    int arrTime = row.getInt("ARR_TIME");
    int status = row.getInt("CANCELLED");
   
    
    Flights flight = new Flights(airline,  status,  date,  depTime, schDepTime); // creates an object of each flight using the data
    flights.add(flight); //adds the object to the arraylist
  }
  
  for(TableRow row : data.rows())
  {
    String code = row.getString("ORIGIN"); //uses csv header names to find the specific data
    String city = row.getString("ORIGIN_CITY_NAME");
    String state= row.getString("ORIGIN_STATE_ABR");
    int wac = row.getInt("ORIGIN_WAC");
   
     
    Airport airports = new Airport(code, city, state, wac ); // creates an object of each airport using the data from the row
    airport.add(airports); //adds the object to the arraylist
  }

//more reading added 9:34am - Nora Holden 
  for(TableRow row : data.rows())
    {
      String flightNum = row.getString("MKT_CARRIER"); //uses csv header names to find the specific data
      String carrierCode = row.getString("MKT_CARRIER_FL_NUM");
      
     
       
      Airline airlines = new Airline(flightNum, carrierCode); // creates an object of each airport using the data from the row
      airline.add(airlines); //adds the object to the arraylist
    }
    
  //Screens - Alyx Harmon
  
   screens = new ArrayList<Screen>();
  
  // homescreen (0)
  
  Screen homescreen = new Screen(color(220, 200, 255));
  homescreen.addWidget(new Button(50,30,325,50,"Go to Map"));
  homescreen.addWidget(new Button(425,30,325,50,"Find Flights"));
  
  // map screen (1)
  
  Screen mapScreen = new Screen(color(195,240,180));
  mapScreen.addWidget(new Button(50,30,325,50,"Back to Home"));
  mapScreen.addWidget(new Button(425,30,325,50,"Find Flights"));
  
  // find flights screen (2)
  
  Screen flightsScreen = new Screen(color(240,180,200));
  flightsScreen.addWidget(new Button(50,30,325,50,"Back to Home"));
  flightsScreen.addWidget(new Button(425,30,325,50,"Go to Map"));
  
  screens.add(homescreen);
  screens.add(mapScreen);
  screens.add(flightsScreen);
  
  currentScreen = homescreen;
  
  
  
  //demonstration of data that has been read in - Nora Holden 10/03/2026 2:25pm

 
  
  for(Flights flight : flights) //loops through the objects 
  {
    // prints data to the console 
    println("flight data : " + flight.airline + " + "  + flight.depTime + " + " + flight.date  + " + " + flight.schDepTime + " + " + flight.status);
  
  }
  
  
  for(Airport airports : airport)
  {
    println("airport data : " + airports.code + " + " + airports.city  + " + " + airports.state + " + " + airports.wac);
  }
  
   for(Airline airlines : airline)
  {
    println("airline data data : " + airlines.flightNum + " + " + airlines.carrierCode);
  }
  
  
}

void draw()
{

  background(255);
 
 //Screens - Alyx Harmon
  currentScreen.draw();

 int x = 100;
  int y = 250;
  text("flight data :", 100,100);
  text("airline", 100, 150);
  text("Dept Time", 200, 150);
  text("Sch Time", 300, 150);
  text("status", 400, 150);
   for(Flights flight : flights) //loops through the objects 
  {
    // prints data to the console
    
    fill(0);
    text(flight.airline ,x,y);
    x +=100;
    text(flight.depTime, x,y);
    x +=100;
    text(flight.schDepTime, x,y);
    x +=100;
    text(flight.status, x,y);
    x = 100;
    y += 100;
    
  }
   
}


//Screens - Alyx Harmon
void mousePressed()
{
  Button b = currentScreen.getButton(mouseX, mouseY);
  
  if(b != null)
  {
    if (b.label.equals("Go to Map"))
      currentScreen = screens.get(1);
    else if (b.label.equals("Find Flights"))
      currentScreen = screens.get(2);
    else if (b.label.equals("Back to Home"))
      currentScreen = screens.get(0);
  }
}


