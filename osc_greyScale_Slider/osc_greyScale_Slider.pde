/**
 * osc_greyScale_Slider based upon oscP5sendreceive by andreas schlegel
 *
 * osc_greyScale_Slider developed by hex705 (Steve Daniels)
 *
 * steve daniels can be found at http://www.spinningtheweb.org
 *
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;

OscP5 sliderSketch;
int sliderPort = 12000;

NetAddress  remoteLocation;  // someone to talk to
int remotePort = 12001;

// create a slider
Slider greySlider;
int selectedFill ;  // store the currently selected color from slider
int lastFill;

  
void setup() {
  
  size(490,600);
  background( 67 );

  sliderSketch = new OscP5(this, sliderPort);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
   remoteLocation = new NetAddress( "127.0.0.1", remotePort );   // connect to local host
   // remoteLocation = new NetAddress( "255.255.255.255", remotePort );  // BROADCAST -- > connect ot subnet
  
  // define the slider for interface
    greySlider =  new Slider(width-60, 90, 40, 200, 0, 255, GREYSCALE, true);
    greySlider.setField(color(200,200,200));
}



void draw() {
   
    // get new fill color from slider
    selectedFill = greySlider.update();
    
    if (selectedFill != lastFill) { // prevent repeated data on the network
   
        // draw the display box in upper right corner (display what we selected)
        fill( selectedFill );  // set fill 0 -255
        stroke(200);           // set Stroke color 0-255
        rect (width - 70, 10,60,60);  // draw the square
        
        
        // build and send the message
        OscMessage sliderMessage = new OscMessage("/sliderSetting");  // create a new message -- with address pattern
        
        // add a value to the message
        sliderMessage.add( selectedFill ); /* add an int to the osc message */
    
        /* send the message */
        sliderSketch.send(sliderMessage, remoteLocation); 
        
    }
    
    
    lastFill = selectedFill;
    
}
 

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println("   typetag: "+theOscMessage.typetag());
  
  int temp = theOscMessage.get(0).intValue();
  String s =  theOscMessage.addrPattern();
  
  //output the type tag of the sender -- >
  fill(67);
  rect (0,height-100,width,height); // this rectangle covers up the text each time -- making it look like it changes
  
  // write add pattern of speaker
  fill(255);
  text (s, 110, height-50);
  // visualize
  noStroke();
  fill(temp);
  rect (0,(height-20),width,height);
}
