PImage enemy,BImage1,BImage2,fighter,hp,treasure,end1,end2,start1,start2,shootimage;
int enemyCount = 8;
int Bx,hpy,Tx,Ty,gameState,n,HP,currentFrame,f,flyn,Ex,score,N,closestEnemyIndex;
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
final int GAME_START = 1,GAME_WIN = 2,GAME_LOSE = 3,GAME_RUN = 4;
int x,y;
float speed = 5,K;
boolean upPressed = false , downPressed = false , leftPressed = false , rightPressed = false , backspacePressed = false,Hit = false;
int numFrames=5;
PImage[]imagesF=new PImage[numFrames];
int []boomX = new int [enemyCount];
int []boomY = new int [enemyCount];
int [] shootX =new int [enemyCount];
int [] shootY =new int [enemyCount];
boolean [] shoot =new boolean [enemyCount];
final int first = 1,second = 2,third = 3;
float [] num =new float [enemyCount];
//**********************************************************************************

void setup () {
	size(640, 480) ;
	enemy = loadImage("img/enemy.png");
	addEnemy(0);
  n=1;
  gameState = GAME_START;
  currentFrame =0;
  for (int i=0;i<numFrames;i++){imagesF[i]=loadImage("img/flame"+(i+1)+".png");}
  frameRate(60);
  BImage1 = loadImage("img/bg1.png");
  BImage2 = loadImage("img/bg2.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  shootimage = loadImage("img/shoot.png");
  hpy = 38; 
  HP = floor((hpy * 10) / 19);
  Tx = floor(random(0,599));
  Ty = floor(random(0,439));
  x = width;
  y = height/2;
  for (int i=0;i<5;i++){shoot[i]=false;}
}

void draw()
{
	background(0);    
  switch(gameState){
  case GAME_START:
  image(start2,0,0);
  if (mouseX > 208 && mouseX < 450 && mouseY > 378 && mouseY < 410){image(start1,0,0);if (mousePressed == true){gameState = GAME_RUN;}}
  break;
  
  case GAME_WIN:  
  break;
  
  case GAME_LOSE:
  image(end2,0,0);
  if (mouseX > 205 && mouseX < 436 && mouseY > 308 && mouseY < 350){
          image(end1,0,0);
          if (mousePressed == true){ 
          hpy = 38;
          HP = floor((hpy * 10) / 19);
          Tx = floor(random(0,599));
          Ty = floor(random(0,439));
          x = width;
          y = height/2;
          addEnemy(0);
          gameState = GAME_RUN;
          score = 0;}
          for (int i=0;i<8;i++){shoot[i]=false;}
          }
  break;
  
  case GAME_RUN:
    image(BImage1,Bx,0);image(BImage2,Bx-640,0);image(BImage1,Bx-1280,0);
    Bx += 2 ;Bx = Bx % 1280 ; // background
    noStroke();fill(255,10,10);rect(27,26,hpy,15);image(hp,15,20); //hp
    image(fighter,x,y);
    for (int i=0;i<8;i++){    //shoot image
    shootX[i] -= 4;
    closestEnemyIndex=closestEnemy(shootX[i],shootY[i]);
    if (closestEnemyIndex!=-1){
    if (enemyY[closestEnemyIndex]>shootY[i]){shootY[i]++;}else if (enemyY[closestEnemyIndex]<shootY[i]){shootY[i]--;}}
    
    if (shoot[i]==true){image(shootimage,shootX[i],shootY[i]+8);}if (shootX[i]<-31){shoot[i]=false;}}  
    //boom!!!!!boom!
    for (int i = 0;i<enemyCount;++i){if (enemyX[i] != -1 || enemyY[i] != -1){image(enemy,enemyX[i],enemyY[i]);enemyX[i]+=5;}  
        if (boomX[i] > 0 && boomY[i] >0){if (frameCount % 6 ==0 && f !=5){f++;f=f%6;}if(f==5){boomX[i] = -300;boomY[i] =-300;f=0;}image(imagesF[f], boomX[i],boomY[i]);}
        if (Ex-400 >=640){addEnemy(n);n++;n=n%3;}if(i==0){Ex +=5;}
        }     
    image(treasure,Tx,Ty);
    for (int i = 0;i<enemyCount;++i){if (enemyX[i] != -1 || enemyY[i] != -1){  //enemy and x,y Hit
    if (isHit(enemyX[i],enemyY[i],61,61,x,y,51,51)==true){boomX[i]=enemyX[i];boomY[i]=enemyY[i];enemyX[i]=-1;enemyY[i]=-1;hpy -=38;HP=floor((hpy * 10) / 19);if  (HP < 1){gameState = GAME_LOSE;}}
    }}
    for (int i = 0;i<enemyCount;++i){  //Treasure and x,y Hit
    if (isHit(Tx,Ty,41,41,x,y,51,51)==true){hpy +=19;HP=floor((hpy * 10) / 19);Tx = floor(random(0,599));Ty = floor(random(0,439));}
    }
    if (hpy > 190){hpy = 190;HP = 100;}
    for(int j =0;j<5;j++){
    for (int i = 0;i<enemyCount;++i){  //shoot and x,y Hit
    if (isHit(enemyX[i],enemyY[i],61,61,shootX[j],shootY[j],31,27)==true && shoot[j]==true){shoot[j]=false;boomX[i]=enemyX[i];boomY[i]=enemyY[i];enemyX[i]=-1;enemyY[i]=-1;scoreChange(20);}
    }}
    textSize(32);
    fill(255);
    text("Score  "+score,20,440);    
    //**********************************************************************************************
    if (upPressed) {
          y -= speed;
        }
          if (downPressed) {
          y += speed;
        }
          if (leftPressed) {
          x -= speed;
        }
          if (rightPressed) {
          x += speed;
        }
          if (x > 589){
            x = 588;
          }
          if (y > 429){
            y = 428;
          }
          if (x < 0){
            x = 0;
          }
          if (y < 0){
            y = 0;
          }
     //**********************************************************************************************
  break;
  }
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{	
	for (int i = 0; i < enemyCount; ++i) {
		enemyX[i] = -1;
		enemyY[i]=-1;
          boomX[i]=-1;
          boomY[i]=-1;
          Ex=0;
	}
	switch (type) {
		case 0:
			addStraightEnemy();
			break;
		case 1:
			addSlopeEnemy();
			break;
		case 2:
			addDiamondEnemy();
			break;
	}
}

void scoreChange(int value){
 score +=value;}

void addStraightEnemy()
{
	float t = random(height - enemy.height);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h;
	}
}
void addSlopeEnemy()
{
	float t = random(height - enemy.height * 5);
	int h = int(t);
	for (int i = 0; i < 5; ++i) {

		enemyX[i] = (i+1)*-80;
		enemyY[i] = h + i * 40;
	}
}
void addDiamondEnemy()
{
	float t = random( enemy.height * 3 ,height - enemy.height * 3);
	int h = int(t);
	int x_axis = 1;
	for (int i = 0; i < 8; ++i) {
		if (i == 0 || i == 7) {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h;
			x_axis++;
		}
		else if (i == 1 || i == 5){
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 1 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 1 * 40;
			i++;
			x_axis++;
			
		}
		else {
			enemyX[i] = x_axis*-80;
			enemyY[i] = h + 2 * 40;
			enemyX[i+1] = x_axis*-80;
			enemyY[i+1] = h - 2 * 40;
			i++;
			x_axis++;
		}
	}
}

boolean isHit(int ax,int ay,int aw,int ah,int bx,int by,int bw,int bh){
  if (bx>ax-bw && bx<ax+aw && by>ay - bh && by<ay+ah){ return true;}else {return false;}
}

int closestEnemy(int Sx,int Sy){
    for(int i=0;i<8;i++){num[i]=dist(enemyX[i],enemyY[i],Sx,Sy);}
    K=num[1];N=1;
    for(int i=0;i<8;i++){if(num[i]<K){K=num[i];N=i;}}
    if(num[0]==dist(-1,-1,Sx,Sy)&&num[1]==dist(-1,-1,Sx,Sy)&&num[2]==dist(-1,-1,Sx,Sy)&&num[3]==dist(-1,-1,Sx,Sy)&&num[4]==dist(-1,-1,Sx,Sy)&&num[5]==dist(-1,-1,Sx,Sy)&&num[6]==dist(-1,-1,Sx,Sy)&&num[7]==dist(-1,-1,Sx,Sy)){N=-1;}
    return N;
  }

void keyPressed() {
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
      case BACKSPACE:
        backspacePressed = false;
        break;
    }
  }
  if (key ==' '){
     if (shoot[0]==true && shoot[1]==true && shoot[2]==true && shoot[3]==true && shoot[4]==true){}else{
     shootX[flyn]= int(x);
     shootY[flyn]= int(y);
     shoot[flyn] = true;
     flyn ++;
     flyn =flyn%5;
     }
    }
}
