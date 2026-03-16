ArrayList<Screen> screens;
Screen currentScreen;
PImage homescreenIcon;

void setup()
{
  size(800, 600);
  homescreenIcon = loadImage("plane.png");
  
  screens = new ArrayList<Screen>();
  
  // homescreen (0)
  
  Screen homescreen = new HomeScreen(color(220, 200, 255));
  homescreen.addWidget(new Button(50,30,325,50,"Go to Map"));
  homescreen.addWidget(new Button(width - 325 - 50,30,325,50,"Find Flights"));
  
  // map screen (1)
  
  Screen mapScreen = new MapScreen(color(195,240,180));
  mapScreen.addWidget(new Button(50,30,325,50,"Back to Home"));
  mapScreen.addWidget(new Button(width - 325 - 50,30,325,50,"Find Flights"));
  
  // find flights screen (2)
  
  Screen flightsScreen = new FlightScreen(color(240,180,200));
  flightsScreen.addWidget(new Button(50,30,325,50,"Back to Home"));
  flightsScreen.addWidget(new Button(width - 325 - 50,30,325,50,"Go to Map"));
  
  screens.add(homescreen);
  screens.add(mapScreen);
  screens.add(flightsScreen);
  
  currentScreen = homescreen;
}

class HomeScreen extends Screen // Alyx Harmon 16/3 15.30pm - added subclasses for each screen
{
  HomeScreen(color c)
  {
    super(c);
  }
  
  void draw()
  {
    background(bgColor);
    
    fill(red(bgColor)-40, green(bgColor)-40, blue(bgColor)-40);
    rect(0,0, width, 110);
    
    fill(0);
    textSize(40);
    text("Welcome To Flight Finder", 400, 150);
    textSize(20);
    text("Select a page to visit above", 400, 200);
    
    image(homescreenIcon, 150, 200);
    
    
    for (Button b : widgets)
      b.draw();
  }
}

class MapScreen extends Screen
{
  MapScreen(color c)
  {
    super(c);
  }
  
  void draw()
  {
    background(bgColor);
    
    fill(red(bgColor)-40, green(bgColor)-40, blue(bgColor)-40);
    rect(0,0, width, 110);
    
    fill(0);
    textSize(20);
    text("Map of flight departures", 400, 565);
    
    fill(255);
    rect(25, 135, 750, 400);
    
    //// put map here ////
    
    for (Button b: widgets)
      b.draw();
  }
}

class FlightScreen extends Screen
{
  FlightScreen(color c)
  {
    super(c);
  }
  
  void draw()
  {
    background(bgColor);
    
    fill(red(bgColor)-40, green(bgColor)-40, blue(bgColor)-40);
    rect(0,0, width, 110);
    
    fill(0);
    textSize(20);
    text("Filter search by:", 400, 150);
    
    fill(255);
    rect(50, 170, 700, 50);
    
    //// search bar drop box here ////
    
    for (Button b: widgets)
      b.draw();
  }
}
  
void draw()
{
  currentScreen.draw();
}

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

class Screen
{
  ArrayList<Button> widgets;
  color bgColor;
  
  Screen(color bgColor)
  {
    this.bgColor = bgColor;
    widgets = new ArrayList<Button>();
  }
  
  void addWidget(Button b)
  {
    widgets.add(b);
  }
  
  void draw()
  {
    background(bgColor);
    
    for (Button b : widgets)
      b.draw();
  }
  
  Button getButton(int mx, int my)
  {
    for (Button b: widgets)
    {
      if (b.isClicked(mx,my))
      return b;
    }
    return null;
  }
}

class Button
{
  int x,y,w,h;
  String label;
  
  Button(int x, int y, int w, int h, String label)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void draw()
  {
    noStroke();
    fill(255);
    rect(x,y,w,h);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, x + w/2, y + h/2);
  }
  
  boolean isClicked(int mx, int my)
  {
    return mx > x
    && mx < x + w
    && my > y
    && my < y + h;
  }
}
    
