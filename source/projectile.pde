//NOTES
//modify for colour: drops change colour w speed
//or, blocks explode in colour when hit. explosion material size and speed function of block size and missile speed
//turn into a puzzle: you have to hit pattern of blocks with one volley; blocks reveal themselves in sequence after hits;
//one volley is from initial fire to impact w first block;
//infinite game - randomly generated problems, increasing steadily in hardness: number & size of targets;
//turn into tablet app?


//variables defined at top
Projectile p = null;
Launcher l;

//background/foreground shade universal var;
int bg = 0; 
int fg = 255;
int oX = 500; 
int oY = 0;

//float[] pos = new float[2];

//need an array or list of Projectiles;
//options are Array and ArrayList;
//try both....
//array first

//fix in advance how many elements in the arrray? resizing requires an extra function; 

Projectile[] fly, flyTemp;
int flyi, flyTempi; 
Target t;

//Explosion e;
Explosion[] e;
Explosion e1;
int ei=0;

float vMax, vMin;

TargetSet ts;

int level;
int maxShots;

void setup(){
  
  size(1000, 1000);
  //background(bg);
  stroke(fg);
  strokeWeight(3);
  fill(fg);
  loop();
  frameRate(80);

  maxShots=100;

  //pos[1] = -1;
  l = new Launcher(oX, oY);
  fly = new Projectile[maxShots];
  flyTemp = new Projectile[maxShots];
  flyi = flyTempi = 0;
  
   //t = new Target( int(random(width)), int(random(height)), int(random(100))+10 );
   //e = new Explosion(int(width/2), int(height/2), 256, 70); 
   e = new Explosion[8];
   e1 = null;
   
   ts = new TargetSet();
   
   
   level = 1;
   textSize(40);
}

/*
Controlling void draw(){}
 loop();
 noLoop();
 redraw();
 */


void draw() {
  background(bg);
  
  
  //reposition & redraw launcher;
  l.undraw();
  l.setA(atan2(height-mouseY-l.getY(), mouseX-oX));
  l.setS(0.2 * (sqrt(pow(mouseX-oX, 2) + pow(height-mouseY-l.getY(), 2))));
  l.draw();
  
  //level
  stroke(fg);
  text(level, 30, height-30);
  
  //print shots remaining
  
        
  
  //check for mouseclick
  if( mousePressed == true ){
    if( mouseButton == LEFT  && flyi < fly.length && ts.getTI()==0 ){      
      fly[flyi] = l.fire();
      flyi += 1;
    }
  }
  
  //check keyboard
  if( keyPressed == true ){
    if( key=='a' ){
      l.raise();
    } else if( key=='z' ){
      l.lower();
    } else if( key =='q' ){
      print(vMin, vMax,"\n");
      return;
    }
  }
    
  //advance and draw target set
  ts.draw();
  if( ts.isComplete() && flyi==0 ){
    level++;
    ts = new TargetSet( 2+(level/5), 100+60/level );
    
    //ts.reset();
  }
  
  
  //advance projectiles
  for( int i=0; i < flyi; i++ ){
      if( fly[i].getY() >= 0 ){
        stroke(fg);
        fly[i].draw();
        
        //check for collisions;
        ts.checkCollision( fly[i] );
        
        //poke TargetSet
        
        //advance and draw target set
       
        
        
        /*
        if( t.isCollision(fly[i]) ){
          print(ei);
          //e1 = new Explosion(t.getX(), t.getY(), 5*t.getS(), fly[i].getV()/2);
          t = new Target( int(random(width)), int(random(height)), int(random(100))+10 );
        }
        */
        
        
        fly[i].advance(0.1);
        //move to flyTemp array
        flyTemp[flyTempi] = fly[i];
        flyTempi++;      
      } 
  }
  fly = flyTemp;
  flyi = flyTempi;
  flyTempi = 0;
  
  //if all missiles lost, and targets remain, reset target set
  if( flyi==0 && ts.isActive()==false && ts.targetsRemain() && ts.getTI()>0 ){
    ts.reset();
  }
  
  /*
  //advance explosions;
  if( e1 != null ){
   if( e1.advance(0.15) ){
      e1.draw();
   }else{
     e1 = null;
   }    
  }*/
  /*
  Explosion[] eTmp = new Explosion[ei];
  int eTmpi = 0;
  //
  for( int i=0; i < ei; i++ ){
     if( e[i].advance(0.1) ){
       eTmp[eTmpi] = e[i];
       eTmpi++;
       e[i].draw();
     }
  }
  e = eTmp;
  ei = eTmpi;
  */
  
}



class TargetSet{
  Target[] t;
  int tn, ti;
  Explosion e;
  int ei;
  
  TargetSet(int n, int s){
    tn = n;
    t = new Target[tn];
    ti = 0;
    //e = new Explosion[n];
    e = null;
    ei = 0;
    for( int i=0; i<tn; i++ ){
      t[i] = new Target(10+int(random(width-20)), 10+int(random(height-20)), int(random(s))+s/2 ); 
    }
  }
  
  //default - first
  TargetSet(){
    tn = 2;
    t = new Target[2];
    ti = 0;
    //e = new Explosion[n];
    e = null;
    ei = 0;
    t[0] = new Target(100, height-300, 80 ); 
    t[1] = new Target(width-100-80, height-300, 80 ); 
    
  }
  
  
  void reset(){
    ti=0;
    e=null;
  }
  
  int getTI(){
    return ti;
  }
   
  Boolean targetsRemain(){
    return (ti<tn); 
  }
  
  Boolean isActive(){
    return (e!=null);
  }
  
  Boolean isComplete(){
    if( !targetsRemain() && !isActive() ){
      return true;
    }
    return false;
  }
  
  void checkCollision(Projectile p){
      if( targetsRemain() && t[ti].isCollision(p) ){
        e = new Explosion( t[ti].getX(), t[ti].getY(), 5*t[ti].getS(), p.getV()/2 );
        ti++;
      }
  }
  
  void draw(){
    //draw current target if any left
    if( targetsRemain() ){
       t[ti].draw();
    }
    
    //process explosions; 
    if( isActive() ){
      if( e.advance(0.2) ){
        e.draw();
      }else{
        e = null; 
      }
    }  
  }
}





class Target{
  int x, y, s;
  
  Target(int xpos, int ypos, int size){
      x = xpos;
      y = ypos;
      s = size;
  }
  
  void draw(){
     stroke(fg);
     fill(fg);
     strokeWeight(1);
     square(x,height-y,s); 
  }
  
  Boolean isCollision(Projectile p){
      int px, py;
      if( p.getX() >= x && p.getX() <= x+s && p.getY() <= y && p.getY() >= y-s ){
        return true;
      }
      return false;
  }
  
  int getX(){
    return x;
  }
  int getY(){
    return y;
  }
  int getS(){
    return s;
  }
}




color colorScale(float v){
    //v some value between 0, 1;
    if( v>1 ){
      v=1/v;
    }
    return color(255, v*255, 128);
}




class Explosion{
  int x, y;
  int n; //keeps track of explosion particle number. Initial value here.
  float s, v; //size, initial velocity;
  Projectile[] p;   
  
   
  Explosion(int xpos, int ypos, int size, float vel){
      x = xpos; y = ypos; n = size; v = vel;
      p = new Projectile[n];
      //print(size/100.0,"\n");
      //create all explosion particles;        
      for( int i=0; i<n; i++ ){
        p[i] = new Projectile(random(1)*TWO_PI, (random(1)+0.5)*v, x, y, (size/18.0) );
        //p[i] = new Projectile(random(1)*TWO_PI, random(2)*v, x, y, 2 );
      }
  }
  
  Boolean advance(float t){
    Projectile[] p_tmp = new Projectile[n];
    int n_tmp = 0; //p_tmp index
          
    for( int i=0; i<n; i++ ){        
      p[i].advance(t);
      if( p[i].getY() > 0 ){
        p_tmp[n_tmp] = p[i];
        n_tmp++;
      }
    }  
    
    p = p_tmp; n = n_tmp;
    if( n > 0 ){
      return true;
    }
    return false;
  }
  
  void draw(){
    for( int i=0; i<n; i++ ){
      //stroke(colorScale(p[i].getV()/));
      //stroke(colorScale(p[i].getV()/100.0));
      stroke(255, (p[i].getV()/100.0)*255, (v/90)*255);
      p[i].draw();
    }     
  }
}


//classes and functions here
class Projectile {
  //class variables at top of class;
  float v, vH, vV, x, y, s;
  float g = -9.81;

  //constructor method
  Projectile(float angle, float velocity, int xStart, int yStart, float size) {
    //split velocity into horiz and vert components;
    v = velocity;
    vH = velocity*cos(angle);
    vV = velocity*sin(angle);
    x = xStart;
    y = yStart;
    s = size;
  }  
  
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
  float getV(){
    //
   return sqrt(pow(vH,2)+pow(vV,2)); 
  }
  
  float[] getPos() {
    float[] p = new float[2];
    p[0] = x;
    p[1] = y;
    return p;
  }
  
  
  //inc alternative method w/out parameter
  void advance(float t) {
    x += t*vH;

    float vVNew = vV += t*g;
    float vVMean = (vV + vVNew)/2;
    y += t*vVMean;
    vV = vVNew;
    
    /*
    if( getV() > vMax ){
      vMax = getV();
    }
    */
  }

  void draw() {
    //stroke(fg);
    if( getV()/400 > vMax ){
      vMax = getV()/400;
    }
    if( getV()/700 < vMin ){
      vMin = getV()/400;
    }
    //stroke(color(255,random(1)*255, random(1)*255));
    
    
    
    //stroke(fg);
    
    
    //strokeWeight((getV()/100.0)*s);
    strokeWeight(s);
    point(x, height-y);
  }
}



class Launcher {
  int x, y, x2, y2;  //launch point
  float a, s;
  

  Launcher(int xLoc, int yLoc) {
    //initialize launcher at a point
    //default values for initial angle and launch speed;
    x = xLoc; 
    y = yLoc;
    //initial values default
    a = 0.5*PI;
    s = 90;
    //draw launch vector
    draw();
  }

  //methods with default values?


  void draw() {
    stroke(fg);
    strokeWeight(2);
    line(x, height-y, x+(2.0*s*cos(a)), height-y-(2.0*s*sin(a)));  
  }

  void undraw() {
    stroke(bg);
    strokeWeight(3);
    line(x, height-y, x+(2*s*cos(a)), height-y-2*s*sin(a));
  }

  void setA(float angle) {
    a = angle;
  }
  void setS(float speed) {
    s = speed;
  }
  
  void raise(){
    y++;
  }
  void lower(){
    y--;
  }
  
  int getY(){
    return y;
  }

  Projectile fire() {
    Projectile p = new Projectile(a, s, x, y, 10);
    return p;
  }
}
