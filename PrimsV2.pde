//Nicholas Latham
//prims algorithm using a binary heap
//with 5000 vertices the time was 1:23 minutes

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
int HEAPSIZE = (MAXSIZE*(MAXSIZE-1))/2;
int endOfHeap = 0;
int numberOfIterations = 0;
int lastPoint = 0;
int nextPoint = 0;

int[][] heap = new int[HEAPSIZE][3];
points[] data = new points[MAXSIZE];

void setup(){
  background(0);
  size(600, 600);
  initVariables();
  initData();
  initHeap();
  drawPoints();
}

void draw(){
  if(numberOfIterations == MAXSIZE - 2){
    numberOfIterations = 0;  
    setup();
  }
  getEdges();
  removeFromHeap();
  drawLine(lastPoint, nextPoint);
  lastPoint = nextPoint;
  numberOfIterations++;
}

//used when there is no looping
void mousePressed(){
  redraw();
}

//key to reset gragh
void keyPressed(){
  if(key == 'r'){
    setup();
  }
}

//initializes the variables
void initVariables(){
  HEAPSIZE = (MAXSIZE*(MAXSIZE-1))/2;
  endOfHeap = 0;
  numberOfIterations = 0;
}

//initializes the points on the gragh
void initData(){
  for(int i = 0; i < MAXSIZE; i++){
    data[i] = new points();
  }
  data[0].isConnected = true;
}

//initializes the heap so that all elements hold -1
void initHeap(){
  for(int i = 0; i < HEAPSIZE; i++){
    for(int j = 0; j < 3; j++){
      heap[i][j] = -1;
    }
  }
}

//draws the points on the grapgh 
void drawPoints(){
  stroke(250, 0, 0);
  strokeWeight(4);
  for(int i = 0; i< MAXSIZE; i++){
    point(data[i].x, data[i].y);
  }
}

//draws a new line
void drawLine(int start, int end){
  stroke(250, 0, 0);
  strokeWeight(4);
  line(data[start].x, data[start].y, data[end].x, data[end].y);
}

//gets all the unconnected edges connecting to the newest point and adds them to the heap
void getEdges(){
  int tempX = 0;
  int tempY = 0;
  for(int i = 0; i < MAXSIZE; i++){
    if(!data[i].isConnected){
      if(data[i].x < data[lastPoint].x){
        tempX = data[lastPoint].x - data[i].x;
      }else{
        tempX = data[i].x - data[lastPoint].x;
      }
      if(data[i].y < data[lastPoint].y){
        tempY = data[lastPoint].y - data[i].y;
      }else{
        tempY = data[i].y - data[lastPoint].y;
      }
      addToHeap(tempX + tempY, lastPoint, i);
    }
  }
}
      
//adds and item to the heap
//the heap is ordered by the weights
void addToHeap(int weight, int first, int second){
  heap[endOfHeap][0] = weight;
  heap[endOfHeap][1] = first;
  heap[endOfHeap][2] = second;
  arrangeNode(endOfHeap);
  endOfHeap++;
}

//removes an item from the heap
void removeFromHeap(){
  boolean alreadyConnected = true;
  while(alreadyConnected){                   //does the new edge connect to a connected point?
    lastPoint = heap[0][1];
    nextPoint = heap[0][2];
    if(!data[nextPoint].isConnected){
      alreadyConnected = false;
    }
    int leftChild = 1;
    int rightChild = 2;
    int parent = 0;
    while((rightChild < HEAPSIZE) && (heap[leftChild][0] != -1 || heap[rightChild][0] != -1)){  //is the rightChild greater than the array or are we at a leaf?
      if((heap[leftChild][0] < heap[rightChild][0] && heap[leftChild][0] != -1) || (heap[leftChild][0] != -1 && heap[rightChild][0] == -1)){
        setNode(parent, leftChild);
        parent = leftChild;
      }else{
        setNode(parent, rightChild);
        parent = rightChild;
      }
      leftChild = 2*parent + 1;
      rightChild = 2*parent + 2;
    }
    if(parent != endOfHeap){
      setNode(parent, endOfHeap - 1);
      arrangeNode(parent);
    }
    for(int i = 0; i < 3; i++){
      heap[endOfHeap][i] = -1;
    }
    if(endOfHeap != 0){
      endOfHeap--;
    }
  }
  data[nextPoint].isConnected = true;
}

//arranges a leaf node so that it is in the proper height
void arrangeNode(int i){
  boolean lesser = true;
  while(i != 0 && lesser){
    int parent = (i - 1)/2;
    if(heap[i][0] < heap[parent][0]){
      heapSwap(i, parent);
      i = parent;
    }else{
      lesser = false;
    }
  }
}

//sets a node to be equeal to another node
void setNode(int x, int y){
  for(int i = 0; i < 3; i++){
    heap[x][i] = heap[y][i];
  }
}

//swaps to nodes in the heap
void heapSwap(int x, int y){
  for(int i = 0; i < 3; i++){
    int temp = heap[x][i];
    heap[x][i] = heap[y][i];
    heap[y][i] = temp;
  }
}
