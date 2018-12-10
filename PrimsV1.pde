//Nicholas Latham
//prims algorithm using 2 arrays
//linear time O'(V^2) where V is the number of vertuces of the graph
//with 5000 vertices the time to complete was 3:10 minutes

//class which contains the information of a vertex
//the x and y coordinates as well as a boolean to see of it is connected to the tree
class points{
  int x;
  int y;
  boolean isConnected;
  points(){
    x = int(random(width));
    y = int(random(height));
    isConnected = false;
  }
}

int MAXSIZE = 5000;
int CSIZE = 1;
int OSIZE = MAXSIZE;
int lastPoint = 0;
int nextPoint = 0;
int numberOfIterations = 0;

int[] conV = new int[CSIZE];
int[] outV = new int[OSIZE];
points[] data = new points[MAXSIZE];

void setup(){
  background(0);
  size(600, 600);
//fullScreen();
  initData();
  drawPoints();
  //noLoop();
}

void draw(){
  if(OSIZE == 1){
    numberOfIterations = 0;
    noLoop();
  }
  getEdges();
  drawLine();
  numberOfIterations++;
  lastPoint = nextPoint = 0;
}

void mousePressed(){
  redraw();
}

//initializes the array of points in data[] and outV which is an array of poisitions of data[]
void initData(){
  for(int i = 0; i < MAXSIZE; i++){
    data[i] = new points();
  }
  data[0].isConnected = true;
  for(int i = 0; i < OSIZE; i++){
    outV[i] = i;
  }
  conV[0] = outV[0];
  outV[0] = outV[OSIZE-1];
  OSIZE--;
}

//draws the points on the graph
void drawPoints(){
  stroke(250, 0, 0);
  strokeWeight(4);
  for(int i = 0; i < MAXSIZE; i++){
    point(data[i].x, data[i].y);
  }
}

//draws a line
void drawLine(){
  stroke(250, 0, 0);
  strokeWeight(4);
  line(data[lastPoint].x, data[lastPoint].y, data[nextPoint].x, data[nextPoint].y);
}

//gets the lowest edge from points in conV[] to points in outV[]
void getEdges(){
  int weight = MAXSIZE * MAXSIZE * MAXSIZE;
  int tempX = 0;
  int tempY = 0;
  int n = 0;;
  int p = 0;
  int tempO = 0;
  for(int j = 0; j < CSIZE; j++){
    n = conV[j]; 
    for(int i = 0; i < OSIZE; i++){
      p = outV[i];
      if(data[p].x < data[n].x){
        tempX = data[n].x - data[p].x;
      }else{
        tempX = data[p].x - data[n].x;
      }
      if(data[p].y < data[n].y){
        tempY = data[n].y - data[p].y;
      }else{
        tempY = data[p].y - data[n].y;
      }
      if(tempX + tempY < weight){
        weight = tempX + tempY;
        lastPoint = n;
        nextPoint = p;
        tempO = i;
      }
    }
  }
  data[nextPoint].isConnected = true;
  conV = append(conV, nextPoint);
  CSIZE++;
  outV[tempO] = outV[OSIZE-1];
  OSIZE--;
}
      
      
