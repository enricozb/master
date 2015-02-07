ArrayList<Path> paths = new ArrayList<Path>();

boolean lColor = true;

float col;

float lx;
float ly;

void setup()
{
  size(1200,800,OPENGL);
  smooth(8);
  //noSmooth();
  background(255);
  colorMode(HSB);
  //hint(ENABLE_RETINA_PIXELS);
  
  col = random(0,256);
  lx = -1;
  ly = -1;
}
void draw()
{
  background(35);
  if(mousePressed && mouseButton == LEFT)
  {
    lColor = true;
    if(lx < 0 || ly < 0)
    {
      lx = mouseX;
      ly = mouseY;
    }
    if(dist(lx,ly,mouseX,mouseY) > 1)
    {
      paths.add(new Path(lx,ly,mouseX,mouseY, col));
      lx = mouseX;
      ly = mouseY;
    }
  }
  else if(mouseButton == RIGHT)
  {
    paths = new ArrayList<Path>();
  }
  else
  {
    lx = -1;
    ly = -1;
    if(lColor)
      col = random(0,256);
    lColor = false;
  }
  for(Path p : paths)
  {
    p.draw();
  }
}

class Path
{
  
  float time;
  
  float[] sPoint;
  float[] fPoint;
  
  float cols;
  
  float factor;
  float factor2;
  
  Path(float x1, float y1, float x2, float y2, float col)
  {
    sPoint = new float[] {x1,y1};
    fPoint = new float[] {x2,y2};
    factor = dist(sPoint[0],sPoint[1],fPoint[0],fPoint[1]);
    factor2 = 100/factor;
    cols = col;
    time = 0;
  }
  
  void draw()
  {
    pushMatrix();
    //rotate
    translate(width/2,height/2);
    rotateY(time);
    translate(-width/2,-height/2);
    
    //draw
    strokeWeight(factor2);
    stroke(cols, 255 - factor ,255 - factor);
    strokeCap(SQUARE);
    line(sPoint[0],sPoint[1],fPoint[0],fPoint[1]);
    
    time += .01;
    
    popMatrix();
  }
  
}