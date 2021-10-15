int width = 15; 
int height = 15; 
int mineAmount = 15; 
int squareSize = 25;
int[][] mines; 
boolean[][] flags; 
boolean[][] clicked; 

boolean outBounds(int x,int y){
  return x<0||y<0||x>=width||y>=height;
}
int calcNear(int x, int y) {
  if(outBounds(x,y))return 0;
  int i=0;
  for (int offsetX=-1; offsetX<=1; offsetX++) {
    for (int offsetY=-1; offsetY<=1; offsetY++) {
      if (outBounds(offsetX+x, offsetY+y))continue;
      i+=mines[offsetX+x][offsetY+y];
    }
  }
  return i;
}

void reveal(int x, int y){
  if(outBounds(x,y))return;
  if(clicked[x][y])return;
  clicked[x][y]=true;
  if(calcNear(x,y)!=0)return;
  reveal(x-1,y-1);
  reveal(x-1,y+1);
  reveal(x+1,y-1);
  reveal(x+1,y+1);
  reveal(x-1,y);
  reveal(x+1,y);
  reveal(x,y-1);
  reveal(x,y+1);
}

void settings(){
  size(width*squareSize, height*squareSize);
}

void setup(){
  mines=new int[width][height];
  flags=new boolean[width][height];
  clicked=new boolean[width][height];
  for(int x=0;x<width;x++){
    for(int y=0;y<height;y++){
      mines[x][y]=0;
      flags[x][y]=false;
      clicked[x][y]=false;
    }
  }
}

void placeMines(){
  int i=0;
  while(i<mineAmount){
    int x=int(random(width));
    int y=int(random(height));
    if(mines[x][y]==1)continue;
    mines[x][y]=1;
    i++;
  }
}

void clearMines() {
  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      mines[x][y]=0;
    }
  }
}

boolean firstClick=true;
void mousePressed() {
  int x=int(mouseX/squareSize);
  int y=int(mouseY/squareSize);
  if (mouseButton==RIGHT) {
    flags[x][y]=!flags[x][y];
    return;
  } else {//left-click
    if (firstClick) {
      firstClick=false;
      do {
        clearMines();
        placeMines();
      } while (calcNear(x,y)!=0);
    }
    if (mines[x][y]!=0) {
      println("You Lose!");
      exit();
    } else {
      reveal(x, y);
    }
  }
}

void draw() {
  background(0);
  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      color col1=color(2*255/5);
      color col2=color(3*255/5);
      color txtColor=color(0);
      int near=calcNear(x, y);
      if (flags[x][y]) {
        col1=color(255, 0, 0);
        col2=color(4*255/5, 255/5, 255/5);
      } else if (clicked[x][y]) {
        col1=color(255/2);
        col2=color(255/2);
      }
      if (near==1)txtColor=color(255*1/4, 255*1/4, 255*3/4);
      if (near==2)txtColor=color(255*1/4, 255*3/4, 155*1/4);
      if (near==3)txtColor=color(255, 0, 0);
      if (near==4)txtColor=color(255, 255, 0);
      if (near==5)txtColor=color(128, 0, 128);
      boolean alternate=(x+y)%2==0;
      if (alternate) {
        fill(col2);
        stroke(col2);
      } else {
        fill(col1);
        stroke(col1);
      }
      rect(x*squareSize, y*squareSize, squareSize, squareSize);
      if (near>0&&clicked[x][y]) {
        fill(txtColor);
        noStroke();
        textAlign(LEFT, TOP);
        textSize(squareSize);
        text(""+near, x*squareSize, y*squareSize);
      }
    }
  }
}
