/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */
 
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;  // a listener
int listeningPort  = 12001;


NetAddress  remoteLocation;  // someone to talk to
int remotePort = 13000;


void setup() {
  
  size(400,400);
  noStroke();
  frameRate(25);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, listeningPort); // what does this remind you of ?
  
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
   
  remoteLocation = new NetAddress("127.0.0.1",remotePort);  // is this familiar?
  
  background(0);  
  
}



void draw() {
  
  // nothing here 
  
  // but look at the event handlers below ...
  
}
 

void mousePressed() {

  OscMessage myMessage = new OscMessage("/PlayANote");  // starts with an ADDRESS PATTERN --> = / + any string you like
  
  int rVal = (int)random( 0,255 );                       // create the value to send
  myMessage.add( 1 );                               // add an int to the osc message

  oscP5.send(myMessage, remoteLocation);   // actually do the sending -- oscP5 object sends a message called myMessage to remoteLocation
   
  // visualize the value sent -- bottom half of sketch
  fill(rVal);
  rect (0,height/2,width,height);

}

void keyPressed() {
  println("pressed a key");
  OscMessage noteMessage = new OscMessage("/YOURNAME/z1");
  
  switch(key) {
    
    case 'a':
    case 'A':
      noteMessage = new OscMessage("/YOURNAME/A1");
    break;
    
    case 's':
    case 'S':
       noteMessage = new OscMessage("/YOURNAME/S1");
    break;
 
  }
   
    noteMessage.add( 1 );                               // add an int to the osc message

    oscP5.send(noteMessage, remoteLocation); 
    delay(1);
   

}
  

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println("    addrpattern: " + theOscMessage.addrPattern());
  String s =  theOscMessage.addrPattern();  
  println("    typetag: " + theOscMessage.typetag());
  println();
  
  int temp = theOscMessage.get(0).intValue();
  
  // visualize the value sent -- top half of sketch
  fill(temp);
  rect (0,0,width,height/2);
  
}
