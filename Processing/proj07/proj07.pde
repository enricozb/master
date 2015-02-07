ArrayList<float[]> points = new ArrayList<float[]>();
float theta;
float step;
float maxim;
void setup()
{
  size(500,500, OPENGL);
  colorMode(HSB);
  theta = 0;
  step = .5;
  maxim = 2000;
}

void draw()
{
  background(35);
  pushMatrix();
  translate(250,250);
  rotateZ(radians(theta));
  stroke(0);
  drawGrid();

  if(points.size() < maxim)
  points.add(new float[]{radians(theta),func(theta)});
  for(float[] a : points)
  {
    pushMatrix();
    rotate(-a[0]);
    dot(a[1],0);
    popMatrix();
  }
  popMatrix();
  strokeWeight(.5);
  stroke(255,255,255);
  line(0,250,500,250);
  theta += step;
}

void dot(float a, float b)
{
  noStroke();
  fill(255);
  ellipse(a, b, 5,5);
  noFill();
}

void drawGrid()
{
  pushMatrix();
  strokeWeight(1);
  line(0,500,0,-500);
  line(-500,0,500,0);
  popMatrix();
}

float func(float val)
{
  val = radians(val);
  return f(val);
}

//Change this to the desired equation.

float f(float val)
{
  return 100 * cos(3.15 * val);
}