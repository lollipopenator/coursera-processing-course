//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies


//When running on the iPad or iPhone, you won't see anything unless you tap the screen.
//If it doesn't appear to work first time, always try refreshing the browser.

//////////////// Assignment Three /////////////////////////////////////////////////////////////////////////////////////
// Below is a list of customisations made to this file for the week 3 assignment of the Coursera/London Uni Course 
// "Creative Programming for Digitak Media and Mobile Apps".

// To quickly find all the changes I have made, search for 'wsl-diff' as I have put this i a comment on each 
// altered line.
//
// 0.DON'T FORGET TO CLICK ONCE ON PROCESSING WINDOW TO START ANIMATION AND MUSIC RUNNING!!!
//
// 1. mouseX now controls the size of the 'magnify' parameter, which in turn controls how widely 
// the visualisation is 'stretched out' horizontally across the screen.
// Moving the mouse horizontally away from the centre of the screen causes 
// the animation to stretch out wider, moving it back in  horizontally towards 
// the center of the screen causes the animation to squeeze in closer to the center.
  
// 2. I commented out the 'line(..) command (around line 80), and re-instated the 'ellipse' command, 
// as I was interested in how it would look.

// 3., 4.I also reduced the number of elements, and increased the beat-detection threshold from 0.35 to 0.7.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Maxim maxim;
AudioPlayer player;

float magnify = 200; // This is how big we want the rose to be.
float phase = 0; // Phase Coefficient : this is basically how far round the circle we are going to go
float amp = 0; // Amp Coefficient : this is basically how far from the origin we are.
int elements = 64;// wsl-diff This was  originally 128. This is the number of points and lines we will calculate at once. 1000 is alot actually. 
float threshold = 0.7;// wsl-diff  This was originally 0.35. Try increasing this if it jumps around too much
int wait=0;
boolean playit;


void setup() {
  //The size is iPad Portrait.
  //If you want landscape, you should swap the values.
  // comment out if you are on Android!
  size(768, 1024);
  maxim = new Maxim(this);
  player = maxim.loadFile("mybeat.wav");
  player.setLooping(true);
  player.volume(1.0);
  player.setAnalysing(true);
  rectMode(CENTER);
  background(0);
  colorMode(HSB);
}

void draw() {
  float power = 0;
  if (playit) {
    player.play();
    power = player.getAveragePower();
    //detect a beat
    if (power > threshold && wait<0) {
      //println("boom");
      //a beat was detected. Now we can do something about it
      //amp+=power; // for example alter the animation
      phase+=power*10; 
      wait+=10; //let's wait a bit before we look for another beat
    }
    wait--;// counting down...
  }
  amp += 0.05;
  float spacing = TWO_PI/elements; // this is how far apart each 'node' will be - study it. 
  translate(width*0.5, height*0.5);// we translate the whole sketch to the centre of the screen, so 0,0 is in the middle.
  fill(0, 50);
  rect(0, 0, width, height);
  noFill();
  strokeWeight(2);
  // wsl-diff mouseX now controls the size of the 'magnify' parameter, which in turn controls how widely 
  // the visualisation is 'stretched out' horizontally across the screen.
  // Moving the mouse horizontally away from the centre of the screen causes 
  // the animation to stretch out wider, moving it back in  horizontally towards 
  // the center of the screen causes the animation to squeeze in closer to the center.
  magnify = map(mouseX-768/2, 0, 768, 0, 200); // wsl-diff
  for (int i = 0; i < elements;i++) {
    stroke(i*2, 255, 255, 50);
    pushMatrix();
    rotate(spacing*i*phase);
    translate(sin(spacing*amp*i)*magnify, 0);
    rotate(-(spacing*i*phase));
    //line(0, i*(power*10)-(width/4),0,i*(power*10)-(height/4));
    rotate(i);
    //noStroke();
    //fill(i*2,255,255,10);
    // wsl-diff I commented out the 'line(..) command below, and re-instated the 
    // 'ellipse' command, as I was interested in how it would look.
    ellipse(0,0,i*(power*10),i*(power*10)); //wsl-diff
    //line(0, i*(power*10)-200, 0, 0); //wsl-diff
    popMatrix();
    stroke(255, 0, 0);
  }
}

void mousePressed() {

  playit = !playit;

  if (playit) {

    player.play();
  } 
  else {

    player.stop();
  }
}