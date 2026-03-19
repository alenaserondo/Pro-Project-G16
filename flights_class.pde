
// Wrote flight class - China Lynch 10/3/26 2:30pm
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
  //int arrTime;

 
  Flights(String airline, int status, String date, int depTime, int schDepTime)
  {
    this.status = status;
    this.date = date;
    this.depTime = depTime;
    this.schDepTime = schDepTime;
    this.airline = airline;
    //this.arrTime = arrTime;
    
    // convert date into int format MMDDYYYY
    dateInt = int(date.replace("/",""));
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
    return (dateInt >= startDate && dateInt <= endDate)
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

String airlineName()
  {
     if( airline.equals("AA"))
    {
      
      return airlineName = "American Airlines";
    }
    else if( airline.equals("AS"))
    {
      return airlineName = "Alaska Airlines";
    }
    else if( airline.equals("WN"))
    {
      return airlineName = "Southwest Airlines";
    }
    else if( airline.equals("B6"))
    {
      return airlineName = "Jet Blue Airlines";
    }
    else if( airline.equals("HA"))
    {
      return airlineName = "Hawaiian Airlines";
    }
        else if( airline.equals("NK"))
    {
      return airlineName = "Spirit Airlines";
    }
    else
    {
      return airlineName = "name";
    }
    
    
  }
  color airlineColour() 
  {
     if( airline.equals("AA"))
    {
      
      return airlineColor = color(219, 3, 50);
    }
    else if( airline.equals("AS"))
    {
      return airlineColor = color(23, 126, 150);
    }
    else if( airline.equals("B6"))
    {
      return airlineColor = color(88, 205, 232);
    }
    else if( airline.equals("HA"))
    {
      return airlineColor = color(146, 50, 179);
    }
        else if( airline.equals("NK"))
    {
      return airlineColor = color(239, 255, 56);
    }
    else
    {
      return airlineColor = color(6, 103, 214);
    }
    
  }
  
  // Draws flight visualizations 16/03/2026 - Nora Holden
  void drawFlightBox(int x,int y, int a , int b)
  {
    int hours = depTime / 100;
    int minutes = depTime % 100;
    //int length = arrTime = depTime;
    int z = 700;
    int w = 100;
    airlineColor = airlineColour();
    airlineName = airlineName();
   
    if (late())
    {
      statusCol = color(#FFA30D); // orange
      
    }
    else if (cancelled())
    {
      statusCol = color(#FF0D0D); // red
    }
    else
    {
      statusCol = color(177, 178, 179);
    }
    
    
    //stroke(0);
    fill(177, 178, 179);
    rect(x, y, z - 40, w);//10,10,10,10
    fill(statusCol);
    rect(x +( z -40), y, 30, w);
    fill(airlineColor);
    rect(x , y, 70, w);
    fill(0);
    text(airline , a - 5, b - 20);
    text(airlineName , a + 120, b - 40);
    text( date, a +120, b - 0);
    text( "loc1", a + 310, b - 40);
    text ( hours, a +300, b );
    text( ":", a+ 315, b );
    text(minutes, a + 330, b );
    text( "loc2", a + 410, b - 40);
    text ( hours, a +400, b );
    text( ":", a+ 415, b );
    text(minutes, a + 430, b );
    text("length", a + 550, b - 20);
    rect( a +345, b - 1, a -50, 2);
    
    if (late())
    {
      statusCol = color(#FFA30D); // orange
      pushMatrix();              
      translate( x + ( z - 25), y + w/2);       
      rotate(-HALF_PI); 
      fill(0);
      text("Late", 0,0);       
      popMatrix(); 
    }
    else if (cancelled())
    {
      statusCol = color(#FF0D0D); // red
      pushMatrix();              
      translate( x + ( z - 25), y + w/2);       
      rotate(-HALF_PI); 
      fill(0);
      text("Cancelled", 0,0);       
      popMatrix();
    }
    else
    {
      statusCol = color(177, 178, 179);
    }
  }
  
}
