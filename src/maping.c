#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void createWay(unsigned char c);//create a way between the start and a specific room, opening doors
void randomNumber();//give an random number
unsigned char unvisitedNeighbour(unsigned char k);//give a random neighbour in the unvisited accessible rooms
unsigned char * neighbours(unsigned char k);//give the subscripts of theoric accesible rooms for a given subscript
void display();//display the map in the terminal
void binaryDisplay(unsigned char n);//show a char in its binaty form

unsigned char x=0;
unsigned char y=0;
unsigned char z=0;
unsigned char a=1;
unsigned char level = 5;//level of the stage to generate
unsigned char height;//height of the arrayof rooms
unsigned char width;//width of the array of rooms
unsigned char * map;//array of rooms
unsigned char current;//current room in the algo
unsigned char temp[4];//subscript of theoric accessible rooms for a specifi room
unsigned char start;//subscript of start room
unsigned char boss;//subscript of boss's room
unsigned char item;//subscript of item's room

int main(int argc, char const *argv[]) {

  //get the number of second since january the first
  int times = time(NULL)%200;
  for (int i = 0 ; i < times ; i++){
    randomNumber();
  }


  //Initialization of width and jeight on level
  level=level+6;
  height= level/2;
  width = level - height;

  //Initialization of the list map wich is a grid and will contain all the rooms
  map = (unsigned char *) malloc (height * width);
  for (int i = 0; i < height*width; i++){
    map[i] = 0b00000000;//Initialisation of each box = rooms
    //Each room is represented by a byte
    //Here each room is a normal room without any door and unvisited
    //Room format (same than first byte int the room file Format in the wiki)
    //Up | Down | Left | Right | Visited | Cat | Cat | Cat
    //000 : normal
    //001 : item
    //010 : boss
    //100 : start
  }

  //Start room in the middle of the grid
  unsigned char i;
  unsigned char j;
  if (width%2 != 0){
    i = width/2 + 1;
  }
  else {
    randomNumber();
    unsigned char b = a % 2;
    i = width / 2 + b;
  }
  if (height % 2 != 0){
    j = height/2 + 1;
  }
  else {
    randomNumber();
    unsigned char b = a % 2;
    j = height / 2 + b;
  }
  i--;
  j--;
  start = j * width + i;
  map[start] = 0b00001100;//Put the start room as a start and visited room

  //Boss's room with a Way of a length between width/3 and height

  unsigned char diff = height - width/3 ;
  randomNumber();
  unsigned char c = a % (diff + 1) ;//generate a random length of the way between the limits mentionned above
  c = c + 1 + width/3;

  createWay(c);

  map[current] = map[current] & 0b11111000;
  map[current] = map[current] | 0b00000010;//Put the final room as the boss's room

  for (int i = 0; i < height*width; i++){
    if (i != start){
      map[i] = map[i] & 0b11110111; //put back all room as unvisited rooms except the start room
    }
  }

  //Item's room with way of a length between width/6 and height/2
  diff = height/2 - width/6 ;
  randomNumber();
  c = a % (diff + 1) ;//generate a random length of the way between the limits mentionned above
  c = c + width/6;

  createWay(c);

  map[current] = map[current] & 0b11111000;
  map[current] = map[current] | 0b00000001;//Put the final room as the boss's room

  for (int i = 0; i < height*width; i++){
    if (i != start){
      map[i] = map[i] & 0b11110111;//Put back all the rooms unvisited rooms except the start room
    }
  }

  //Dead ends between height/2 and max 3*height/4
  //First dead end
  diff = 3*height/4 - height/2 ;
  randomNumber();
  c = a % (diff + 1) ;//generate a random length of the way between the limits mentionned above
  c = c + height/2;

  createWay(c);

  //Second dead end
  diff = height/2 - width/6 ;
  randomNumber();
  c = a % (diff + 1) ;//generate a random length of the way between the limits mentionned above
  c = c + width/6;

  createWay(c);
  display();

  return 0;
}

//Give the subscripts of the 4 theoric rooms next to the room correcponding to the subscript in argument
unsigned char * neighbours(unsigned char k){
  temp[0] = k - width;
  temp[1] = k - 1;
  temp[2] = k + 1;
  temp[3] = k + width;
  return temp;
}

//one random unvisited and accessible room next to the room correcponding to the subscript in argument
unsigned char unvisitedNeighbour(unsigned char k){
  unsigned char * possibleNeighbours;
  possibleNeighbours = neighbours(k);//Give theoric neighbours
  int compteur = 0;//will count accessible unvisited rooms
  unsigned char neighbour;
  char bool[4];//will contain booleans about if the room is (accessible and unvisited)
  //For the room above
  neighbour = possibleNeighbours[0];
  if (!(map[neighbour] & (1u << 3))){//check if it is unvisited
    if (k < width){//check if it is accessible
      bool[0] = 0;
    } else{
      bool[0] = 1;
      compteur++;//count unvisited accessible rooms
    }
  }
  //For the room on the left
  neighbour = possibleNeighbours[1];
  if (!(map[neighbour] & (1u << 3))){//check if it is unvisited
    if (k % width == 0){//check if it is accessible
      bool[1] = 0;
    } else{
      bool[1] = 1;
      compteur++;//count unvisited accessible rooms
    }
  }
  //for the room on the right
  neighbour = possibleNeighbours[2];
  if (!(map[neighbour] & (1u << 3))){//check if it is unvisited
    if (k % width == width - 1){//check if it is accessible
      bool[2] = 0;
    } else{
      bool[2] = 1;
      compteur++;//count unvisited accessible rooms
    }
  }
  //for the room below
  neighbour = possibleNeighbours[3];
  if (!(map[neighbour] & (1u << 3))){//check if it is unvisited
    if (k >= (height - 1) * width){//check if it is accessible
      bool[3] = 0;
    } else{
      bool[3] = 1;
      compteur++;//count unvisited accessible rooms
    }
  }
  randomNumber();
  char alea = a % compteur;//chose a random room in thos unvisited and accessible
  int i = 0;
  char chose;
  while(alea >= 0){//Circle to find the alea-nd unvisited accessible rooms
    if (bool[i] == 1){
      chose = possibleNeighbours[i];
      alea--;
    }
    i++;
  }
  return chose;
}

void randomNumber(){//Have a random number
  unsigned char t = x ^ (x << 4);
  x=y;
  y=z;
  z=a;
  a = z ^ t ^ ( z >> 1) ^ (t << 1);
}

void createWay(unsigned char c){//create a random way from the start to a specific room with the length mentionned in argument
  current = start;//the way start in the start room
  while (c > 0){//until the length of the way is not reached
    unsigned char next = unvisitedNeighbour(current);//take a random unvisited accessible neighbour
    c--;
    map[next] = map[next] | 0b00001000;//set the new room as visited
    //The following code aim to open the right door between the previous and the next room in different cases
    if (next == current + 1){
      map[current] = map[current] | 0b00010000;
      map[next] = map[next] | 0b00100000;
    } else{
      if (next == current - 1){
        map[current] = map[current] | 0b00100000;
        map[next] = map[next] | 0b00010000;
      } else{
        if (next == current - width){
          map[current] = map[current] | 0b10000000;
          map[next] = map[next] | 0b01000000;
        } else{
          if(next == current + width){
            map[current] = map[current] | 0b01000000;
            map[next] = map[next] | 0b10000000;
          }
        }
      }
    }
    current = next;//Move on next room
  }
}

//Specific C code to display and check the code above
void display(){//to show the map of rooms, each room is represented by a byte
  for (int k = 0 ; k < height ; k++){
    for (int l = 0 ; l < width ; l++){
      binaryDisplay(map[k * width + l]);
      printf("    ");
    }
    printf("\n");
  }
  printf("\n");
}

void binaryDisplay(unsigned char n) {//to show a char in its binary form
  int i = 7;
  while (i >= 0){
    printf("%d", (n >> i ) & 1);
    i--;
  }
}
