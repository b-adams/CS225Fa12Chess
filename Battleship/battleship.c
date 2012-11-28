#include <stdio.h>
#include <stdbool.h>
#include <ctype.h> //for toupper

typedef struct {
	char column;
	int row;
} COORDINATE;

const char MIN_COL = 'A';
const char MAX_COL = 'H';
const int MIN_ROW = 1;
const int MAX_ROW = 8;

const int WIDTH=8;


typedef struct {
 	char board[WIDTH][WIDTH];
 	char view[WIDTH][WIDTH];
 	int hits;
} PLAYER;

const char DIR_NONE='x';
const char DIR_NORTH='n';
const char DIR_EAST='e';
const char DIR_SOUTH='s';
const char DIR_WEST='w';


//For display to the player
const char BOARD_WATER = '~';
const char BOARD_SHIP = '#';

//For display to the opponent
const char VIEW_UNKNOWN = '.';

//For use by everyone
const char GRID_BAD = '?';
const char GRID_HIT = '*';
const char GRID_SPLOOSH = '@';

//Ship Sizes
const int BOAT_PT = 2;
const int BOAT_SUB = 3;
const int BOAT_DESTROYER = 3;
const int BOAT_BATTLESHIP = 4;
const int BOAT_CARRIER = 5;

const int GAME_NOT_OVER = 0;
const int GAME_OVER_TIE = -1;
const int GAME_OVER_PLR1_WINS = 1;
const int GAME_OVER_PLR2_WINS = 2;



void printCoord(COORDINATE* where);
void printGrid(char grid[WIDTH][WIDTH]);

void resetPlayer(PLAYER* whom);
void setupPlayer(PLAYER* plr);
void interactivePlaceShip(PLAYER *plr, char* shipName, int size);

void inputCoord(COORDINATE* target);
void setCoord(COORDINATE* where, int r, int c);
void copyCoord(COORDINATE* original, COORDINATE* copy);
void moveCoord(COORDINATE* where, int distance, char direction);

bool validSpace(COORDINATE* where);
void setSpace(COORDINATE* where, char grid[WIDTH][WIDTH], char symbol);
char getSpace(COORDINATE* where, char grid[WIDTH][WIDTH]);

void setWater(COORDINATE* where, PLAYER* whom);
void setShip(COORDINATE* where, PLAYER* whom);
bool placeShip(int size, COORDINATE* where, char direction, PLAYER* whom);

bool error(char* message);

void runGame(void);
void playLoop(PLAYER* plr1, PLAYER* plr2);
void executeRound(PLAYER* plr1, PLAYER* plr2);
bool checkForHit(COORDINATE* where, PLAYER* whom);
int checkGameOver(PLAYER* plr1, PLAYER* plr2);

int main(void)
{
	runGame();
	return 0;
}

int runGame(void)
{
	//Players (hits, boards)
	PLAYER player1;
	PLAYER player2;

	printf("\t\tWelcome to Shooting Boats!\n\n\n");

	printf("Setting up player 1\n");
	setupPlayer(&player1); printf("\n\n\n\n\n\n\n\n");

	printf("Setting up player 2\n");
	setupPlayer(&player2); printf("\n\n\n\n\n\n\n\n");

	printf("\t\tTime to play!\n");

	playLoop(&player1, &player2);

	printf("\t\tThe game is over!\n");

	switch(checkGameOver(&player1, &player2))
	{
		case GAME_OVER_TIE:
			printf("Mutually Assured Destruction!\n"); break;
		case GAME_OVER_PLR1_WINS:
			printf("Player 1 survives!!\n"); break;
		case GAME_OVER_PLR2_WINS:
			printf("Player 2 triumphs!\n"); break;
		default: printf("The Bermuda Triangle strikes again...");
	}
    //(jbrutscher)
}

void resetPlayer(PLAYER *whom)//int* hits, char board[WIDTH][WIDTH], char view[WIDTH][WIDTH])
{
	whom->hits = 0;
	COORDINATE target;
	for(int r=0; r<WIDTH; r++)
	{
		for(int c=0; c<WIDTH; c++)
		{
			setCoord(&target, c, r);
			setWater(&target, whom);
		}
	}
	
}
//******************** I'm Here ******************************
bool placeShip(int size, COORDINATE* where, char direction, PLAYER* whom)
{
	int dist;
	COORDINATE target;
	
	//Make sure all of the spaces are clear (water)
	copyCoord(where, &target);
	dist=0;
	while(dist<size)
	{
		if(getSpace(&target, whom->board) != BOARD_WATER)
		{
			return error("Could not place ship there\n");
		}
		moveCoord(&target, 1, direction);
		dist++;
	}

	//Clear for placement!
	whom->hits += size; //Keep track of remaining hits

	//Place ship bits
	for(dist=0, copyCoord(where, &target); dist<size; dist++, moveCoord(&target, 1, direction))
	{
		setShip(&target, whom);
	}
	return true; //Success!
}

void setWater(COORDINATE* where, PLAYER* whom)
{
	setSpace(where, whom->board, BOARD_WATER);
	setSpace(where, whom->view, VIEW_UNKNOWN);
}

void setShip(COORDINATE* where, PLAYER* whom)
{
	//printf("Setting "); printCoord(where); printf(" to ship.\n");
	setSpace(where, whom->board, BOARD_SHIP);
	setSpace(where, whom->view, VIEW_UNKNOWN);
}

bool checkForHit(COORDINATE* where, PLAYER* whom)
{
	char actual = getSpace(where, whom->board);
	if(actual == BOARD_SHIP) {
		setSpace(where, whom->board, GRID_HIT);
		setSpace(where, whom->view, GRID_HIT);
		whom->hits --;
		return true;
	} else if(actual == BOARD_WATER) {
		setSpace(where, whom->board, GRID_SPLOOSH);
		setSpace(where, whom->view, GRID_SPLOOSH);
		return false;
	} else {
		setSpace(where, whom->board, GRID_BAD);
		setSpace(where, whom->view, GRID_BAD);
		return false;
	}
}

void setSpace(COORDINATE* where, char grid[WIDTH][WIDTH], char symbol)
{
    int colIndex = where->column - MIN_COL;
	int rowIndex = where->row - MIN_ROW;
	grid[colIndex][rowIndex] = symbol;
}

char getSpace(COORDINATE* where, char grid[WIDTH][WIDTH])
{
	if(!validSpace(where)) return GRID_BAD;
	int colIndex = where->column - MIN_COL;
	int rowIndex = where->row - MIN_ROW;
	return grid[colIndex][rowIndex];
}
<<<<<<< HEAD
//Kyle is a bool and has claimed this one....
=======
//******************** But I'm Not Here **********************
>>>>>>> ec201f85fe9006b52ae60434b7692b0bbb1c0d62
bool validSpace(COORDINATE* where)
{
	if(where->column<MIN_COL) return error("Too far West!\n");
	if(where->column>MAX_COL) return error("Too far East!\n");
	if(where->row<MIN_ROW) return error("Too far North!\n");
	if(where->row>MIN_COL) return error("Too far South!\n");	
	return true;
}

void setCoord(COORDINATE* where, int c, int r)
{
	where->column=c+MIN_COL;
	where->row=r+MIN_ROW;
}
void copyCoord(COORDINATE* original, COORDINATE* copy)
{
	copy->column = original->column;
	copy->row = original->row;
}
void moveCoord(COORDINATE* where, int distance, char direction)
{
	if(direction==DIR_NORTH) where->row -= distance;
	if(direction==DIR_SOUTH) where->row += distance;
	if(direction==DIR_WEST) where->column -= distance;
	if(direction==DIR_EAST) where->column += distance;
}

bool error(char* message)
{
	printf("%s", message);
	return false;
}

void printGrid(char grid[WIDTH][WIDTH])
{
	COORDINATE target;
	char symbol;
	for(int r=-1; r<WIDTH; r++)
	{
		for(int c=-1; c<WIDTH; c++)
		{
			if(r>=0 && c>=0)
			{
				setCoord(&target, c, r);
				symbol=getSpace(&target, grid);
				printf("%c", symbol);
			} 
			else //In row, column, or both
			{
				if(c<0 && r<0) printf("   ");
				if(c<0 && r>=0) printf("%2d ", MIN_ROW+r); //Show row numbers
				if(r<0 && c>=0) printf("%c", MIN_COL+c); //Show col letters
			}
		}
		printf("\n");
	}	
}

void interactivePlaceShip(PLAYER *plr, char* shipName, int size)
{
	COORDINATE target;
	char direction;
	bool placed=false;

	printGrid(plr->board);

	while(!placed)
	{
		printf("Where is the front of your %s? ", shipName);
		inputCoord(&target);
		printf("Which direction is the rest of it? (n,e,w,s):");
		scanf(" %c", &direction);
		placed = placeShip(size, &target, direction, plr);
	}
}

void setupPlayer(PLAYER* plr)
{
	COORDINATE target;
	char direction;
	char ok = 'n';

	while(ok=='n')
	{

		resetPlayer(plr);
	
		interactivePlaceShip(plr, "Carrier", BOAT_CARRIER);
		interactivePlaceShip(plr, "Battleship", BOAT_BATTLESHIP);
		interactivePlaceShip(plr, "Destroyer", BOAT_DESTROYER);
		interactivePlaceShip(plr, "Submarine", BOAT_SUB);
		interactivePlaceShip(plr, "Patrol Boat", BOAT_PT);
		
		printGrid(plr->board);
	
		printf("Is this setup ok? [y/n] ");
		scanf(" %c", &ok);
	}


	printf("Done setting up.\n");
}

int checkGameOver(PLAYER* plr1, PLAYER* plr2)
{
	if(plr1->hits < 1) return GAME_OVER_PLR2_WINS;
	if(plr2->hits < 1) return GAME_OVER_PLR1_WINS;
	return GAME_NOT_OVER;
}

void playLoop(PLAYER* plr1, PLAYER* plr2)
{
	int endGame=GAME_NOT_OVER;
	while(endGame == GAME_NOT_OVER)
	{
		printf("\n\n\n\n\n");
		executeRound(plr1, plr2);
		endGame = checkGameOver(plr1, plr2);
	}
}

void executeRound(PLAYER* plr1, PLAYER* plr2)
{
	COORDINATE target;
	bool plr1hits;
	bool plr2hits;


	printGrid(plr2->view);
	printf("Player 1: Enter target! ");
	inputCoord(&target);
	plr1hits = checkForHit(&target, plr2);

	printGrid(plr1->view);
	printf("Player 2: Enter target! ");
	inputCoord(&target);
	plr2hits = checkForHit(&target, plr1);

	printf("\n\nSHELLS IN THE AIR!\n\n");

	printf("Player 1... ");
	if(plr1hits)
	{
		printf("hits!\n");
		printf("Player %d can take %d more hits.\n", 2, plr2->hits);		
	} else {
		printf("misses.\n");
	}

	printf("Player 2... ");
	if(plr2hits)
	{
		printf("hits!\n");
		printf("Player %d can take %d more hits.\n", 1, plr1->hits);
	} else {
		printf("misses.\n");
	}
}

void inputCoord(COORDINATE* target)
{
	scanf(" %c%d", &(target->column), &(target->row));
	target->column = toupper(target->column);
	printf("Target entered: "); printCoord(target); printf("\n");
}

void printCoord(COORDINATE* where)
{
	printf("[%c%d]", where->column, where->row);
}

//Prof A typed this
