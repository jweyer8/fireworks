//This class creates a firework, which can move, explode, and be displayed as output
class Fire1 {
  int x, y, nowExplode, rad, nspark;
  float ang, speed;
  color cc;
  float angspeed = random(.3);   //correspoding to the wavelength of sin path
  float amp = random(2, 4);   //aplitude of sin path
  float angy;
  int str;
  float z;  //z starting postion
  float zs = random(1, 3);  //speed of change in z value
  float zsound; //sound amplidute value amplitude increase with higher z value
  int lx, ly;
  int[] lpos = new int[2];

  //this method constructs an instance of the class Fire1
  Fire1(int tx, int ty, int tnowExplode, int trad, float tspeed, float tang, int tnspark, color tcc, float tangy, int tstr, float tzstart) {
    x = tx;
    y = ty;
    nowExplode = tnowExplode; 
    rad = trad;
    speed = tspeed;
    ang = tang;
    nspark = tnspark;
    cc = tcc;
    angy = tangy;
    str = tstr;
    z = tzstart;
  }

  //This method draws a firework at given x y z cordinates
  void display() {
    fill(250, 250, 250, 50);
    pushMatrix();
    translate(0, 0, z);
    stroke(255, 50);
    strokeWeight(rad * 2);
    line(x, y, lpos[0], lpos[1]);
    noStroke();
    ellipse(x, y, rad, rad);
    popMatrix();

    move();
  }

  //this method moves the object to new coordinates
  void move() {

    lx = x;
    ly = y;
    lpos[0] = lx;
    lpos[1] = ly;
    z+=zs;  //increment z val 

    //if firework reaches defined explotion height call explode function
    if (y <= nowExplode && y != 0) {
      explode();
    }
    //if firewrork reaches max z distance call explode function
    if (z >= maxz && y != 0) {
      explode();
    }

    //move x and y cordiates according to if they are moveing linearally or sinusodaly
    if (str == 0) {
      x += cos(ang) * amp;
      y -= speed * sin(angy);
      ang += angspeed;
    }

    if (str == 1) {
      x += cos(ang) * speed;
      y -= sin(ang) * speed;
    }
  }

  //this method gives the object the visual effect of exploding
  void explode() {
    float sradmax = 3;  //max spark radius
    float sradmin = 1;   // min explode radius
    float srad;  //actual radius
    float sxr, syr, sxt, syt, sxs, sys;  //x y positions for different spark shapes
    float dist=1;   // distance away from firework in which spark appears

    //make explostion sound
    zsound = map(z, -1510, 1510, -1, 1);
    if (zsound == 0) {
      zsound = .001;
    }
    expsound.amp(zsound);
    expsound.play();

    //create sparks at x,y,z
    for (int k = 0; k <nspark; k++) {
      fill(cc);
      srad = random(sradmin, sradmax);
      sxr= random(-dist, dist) + x;
      syr = random(-dist, dist) + y;

      sxt= random(-dist, dist) + x;
      syt = random(-dist, dist) + y;

      sxs= random(-dist, dist) + x;
      sys = random(-dist, dist) + y;

      pushMatrix();
      translate(0, 0, z);
      strokeWeight(.2);
      stroke(255);
      line(x, y, sxr, syr);
      noStroke();
      pushMatrix();
      translate(0, 0, (random(-10, 10)));
      ellipse(sxr, syr, srad, srad);
      triangle(sxt, syt, sxt + 1, syt + 1, sxt -1, syt -1);
      square(sxs, sys, srad);
      popMatrix();
      popMatrix();

      cc += 10; //change color 
      if (cc > 255) {
        cc -= 100;
      }
      dist++; //increase distance away from firework explosion point
    }
    
    //kill firework
    speed = 0;
    rad = 0;
    x = 0; 
    y = 0;
    ang = 0;
    nowExplode = 0;

  }
}
