import controlP5.*;
import java.util.*;

// UI
ControlP5 cp5;
DropdownList ddl;

// Data
Table data;
HashMap<String, ArrayList<Airline>> flightsByAirline = new HashMap<String, ArrayList<Airline>>();
ArrayList<String> airlineCodes = new ArrayList<String>();

void setup() {
  size(600, 400);
  
  cp5 = new ControlP5(this);

  // Load CSV (PUT YOUR FILE IN THE "data" FOLDER)
  data = loadTable("flights2k.csv", "header");

  //  Load data + group by airline
  for (int i = 0; i < data.getRowCount(); i++) {
    String flightNum = data.getString(i, "flightNum");
    String carrier = data.getString(i, "carrierCode");

    Airline a = new Airline();
    a.setFlightNum(flightNum);
    a.setCarrierCode(carrier);

    // Create list if airline not seen before
    if (!flightsByAirline.containsKey(carrier)) {
      flightsByAirline.put(carrier, new ArrayList<Airline>());
      airlineCodes.add(carrier); // store unique airline
    }

    flightsByAirline.get(carrier).add(a);
  }

  println("Loaded airlines: " + airlineCodes.size());

  // Create dropdown
  ddl = cp5.addDropdownList("Airlines")
           .setPosition(100, 100)
           .setSize(200, 200);

  customize(ddl);
}

void customize(DropdownList ddl) {
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(20);
  ddl.getCaptionLabel().setText("Select Airline");

  // Add only unique airline codes
  for (int i = 0; i < airlineCodes.size(); i++) {
    ddl.addItem(airlineCodes.get(i), i);
  }

  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void draw() {
  background(240);
}

//  FILTER when dropdown changes
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {

    int index = int(theEvent.getGroup().getValue());
    String selectedCarrier = airlineCodes.get(index);

    println("Selected airline: " + selectedCarrier);

    // Get filtered flights instantly
    ArrayList<Airline> filteredFlights = flightsByAirline.get(selectedCarrier);

    println("Flights for " + selectedCarrier + ":");

    // Print first 10 (avoid spamming console)
    for (int i = 0; i < min(10, filteredFlights.size()); i++) {
      println(filteredFlights.get(i).getFlightNum());
    }

    println("Total flights: " + filteredFlights.size());
  }
}

// CLASS
class Airline {
  private String flightNum;
  private String carrierCode;

  public String getFlightNum() {
    return flightNum;
  }

  public String getCarrierCode() {
    return carrierCode;
  }

  public void setFlightNum(String flightNumber) {
    flightNum = flightNumber;
  }

  public void setCarrierCode(String airlineCarrierCode) {
    carrierCode = airlineCarrierCode;
  }
}
