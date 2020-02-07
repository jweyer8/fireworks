//Name: Jared Weyer, Andy Reding, Andrew Carlson
//Class: CPSC 211 01
//Assigment: Homework 7 Final Project 
//Theme: Celebratioin
//Date: 12/2/2019

//This program creates a firework animation 
//this is done by creating a firework class (Fire1)
//the program in rendered in 3d space 
//fireworks move in an angle path that is either straight or sinusodal
//the firework path also moves in the z direction

//Imorting the sound library to get the explosion mp3 sound file
import processing.sound.*;
SoundFile expsound;


//variables for fireworks 
int numf = 30;  //number of fireworks
int maxspeed = 9;   //max speed of firework
int minspeed = 3;   //min speed of firework
int nsparkmax= 150;   //max number of sparks (ellipses,triangles, and squares)drawn during explosion function call
int nsparkmin = 50;   //min number sparks
int nspark;  //actual number of sparks
float angy;  //angle of firework moving in sinusodal path
int str;  //bool value 1 if straight; path 0 if sinusodal path
int maxz = 1500;  //max z value to which the firework can travel
float zstart;
int t;
Fire1[] fireworks;   //array of fire1 class objects
 
//variables for terrain generation
PImage img;
int scl = 1;
float noiseScale = .004;
int col,row;
float[][] z;

//creates canvas to create animation on. Also, calls functions to create fireworks 
//array and create the background image 
 void setup() 
 {
  frameRate(15);
  size(1000,700,P3D);
  expsound = new SoundFile(this, "explosion_small.mp3");
  
  createFireworks();
  createEnvironment();
  img = loadImage("imgBckgrnd.png");
}
 
//call class methods to move the position of the fireworks 
//and display new position for the duration of the life of the firework
void draw() 
{
  image(img, 0, 0);
  
  for(int j = 0; j<numf; j++){
    fireworks[j].display();
  }
  
  //stop animation after specific time 
  if(millis() >= 50000){
    exit();
  }  
}
 
 
//creates a background image will be saved and used in the draw function
void createEnvironment() 
{
  background(20);
  float inc = .005;
  float xnoise = 0;
  
  //create mesh of verticies to create mountain looking terrian
  pushMatrix();
  translate(width/2, height/2);
  rotateX(PI/2.7);
  pointLight(255,255,255, 0, height/2,100);
  noStroke();
 
  translate(-width*1.5/2, -height/2.8);
  beginShape();
  for (int i = 0; i<row-1; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j<col; j++) {
      float n = noise(xnoise)*100;
      fill(n*.6,n,n*.4);
      vertex(j*scl,i*scl, z[j][i]);
      vertex(j*scl, (i+1)*scl, z[j][i+1]);
      xnoise += inc;
    }
    endShape();
  }
  beginShape();
  popMatrix();
   
  save("imgBckgrnd.png");
}


//creates an array of firework objects. This array will be looped through 
//in the draw function which will create the firework animation
void createFireworks(){
  int x,y,nowExplode,rad;  //starting postions of firework and radius of firework, h is the y value at which the explode funtion will be triggered
  float speed, ang;  //speed of the firework and angle the firework is traveling in 
  fireworks = new Fire1[numf];
  
  terrianHeights(); //get terrian heights 
  
  for(int i = 0; i<numf; i++){
    x = round(random(col-1));
    y = round(random(row*.5,row-1));
    zstart = z[x][y];
    nowExplode = height/3;
    rad = 1;
    speed = random(minspeed,maxspeed);
    ang = random(.35,.65)*PI;
    angy=random(.35,.65)*PI;
    nspark = round(random(nsparkmin,nsparkmax));
    color[] colors = {#0080ff,#0000ff,#8000ff,#ff00ff,#ff0080,#b250e0}; //color array used in firework sparks 
    int nc = round(random(5));
    color cc = colors[nc];
    
    //randomly assign the firework to move linearly or sinusodaly 
    if(round(random(0,1)) == 1){
      str = 1;
    }
    else{
      str = 0;
    }   
    fireworks[i] = new Fire1(x,y,nowExplode,rad,speed,ang,nspark,cc,angy,str,zstart);
  } 
}


//creates z cordinates for every mesh point to create the mountian terrian
void terrianHeights(){
  row = (height)/scl;
  col = round((width*1.5)/scl);
  
  z = new float[col][row];
  for(int i = 0; i<row; i++){
    for(int j = 0; j<col; j++){
       z[j][i] = map(noise(i*noiseScale,j*noiseScale),0,1,-150,150);
    }
  }
}
