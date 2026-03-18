
// Wrote flight class - China Lynch 10/3/26 2:30pm
class Flights  
{
  String date;
  String airline;
  int schDepTime;
  int depTime;
  int status;
  color statusCol; 
  String message;
  //int arrTime;

 
  Flights(String airline, int status, String date, int depTime, int schDepTime)
  {
    this.status = status;
    this.date = date;
    this.depTime = depTime;
    this.schDepTime = schDepTime;
    this.airline = airline;
    //this.arrTime = arrTime;
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

// Updated draw method to display flight status - China Lynch 18/3/26 8:11pm
  void drawFlights(float x, float y, float w, float h)
  {
    // Fixed colour setting loops to work with functions - China Lynch 11/3/26 9pm
    if (cancelled())
    {
      statusCol = color(#FF0D0D); // red
      message = "CANCELLED";
    } else if (late())
    {
      statusCol = color(#FFA30D); // orange
      message = "DELAYED";

    } else
    {
     statusCol = color(#0DFF4A); // green
     message = "ON TIME";
    }
    
    fill(statusCol);
    rect(x, y, w, h, 10)
  }
  
}

