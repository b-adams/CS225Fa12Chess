#include <stdio.h>
#include <stdbool.h>
#include <ctype.h> //for toupper

typedef int T_MOVE_LEGALITY;
const T_MOVE_LEGALITY MOVE_LEGAL_OPEN      =0x10; //0001 0000
const T_MOVE_LEGALITY MOVE_LEGAL_CAPTURE   =0x20; //0010 0000

const T_MOVE_LEGALITY MOVE_ILLEGAL_BLOCKED =0x01; //0000 0001
const T_MOVE_LEGALITY MOVE_ILLEGAL_OFFBOARD=0x02; //0000 0010
const T_MOVE_LEGALITY MOVE_ILLEGAL_MOTION  =0x04; //0000 0100
const T_MOVE_LEGALITY MOVE_ILLEGAL_COLOR   =0x08; //0000 1000

#define WIDTH 8

typedef char T_PIECE;
const T_PIECE SQUARE_WHITE      =' ';
const T_PIECE SQUARE_BLACK      ='#';

#define NUM_PIECES 32
const T_PIECE PIECE_NONE        ='.';

const T_PIECE PIECE_WHITE_PAWN  ='p';
const T_PIECE PIECE_WHITE_BISHOP='b';
const T_PIECE PIECE_WHITE_KNIGHT='h';
const T_PIECE PIECE_WHITE_ROOK  ='r';
const T_PIECE PIECE_WHITE_KING  ='k';
const T_PIECE PIECE_WHITE_QUEEN ='q';

const T_PIECE PIECE_BLACK_PAWN  ='P';
const T_PIECE PIECE_BLACK_BISHOP='B';
const T_PIECE PIECE_BLACK_KNIGHT='H';
const T_PIECE PIECE_BLACK_ROOK  ='R';
const T_PIECE PIECE_BLACK_KING  ='K';
const T_PIECE PIECE_BLACK_QUEEN ='Q';

typedef int T_PIECE_CODE;

const T_PIECE_CODE PIECE_PAWN   = 0;
const T_PIECE_CODE PIECE_BISHOP = 1;
const T_PIECE_CODE PIECE_ROOK   = 2;
const T_PIECE_CODE PIECE_KNIGHT = 3;
const T_PIECE_CODE PIECE_KING   = 4;
const T_PIECE_CODE PIECE_QUEEN  = 5;

typedef char T_PLAYER_COLOR;
const T_PLAYER_COLOR PLAYER_BLACK='B';
const T_PLAYER_COLOR PLAYER_WHITE='w';
const T_PLAYER_COLOR PLAYER_NONE='?';

typedef int T_DIRECTION;
const T_DIRECTION DIRECTION_NONE = 0;
const T_DIRECTION DIRECTION_BLACK = 1;
const T_DIRECTION DIRECTION_WHITE = -1;
const T_DIRECTION DIRECTION_RIGHT = 1;
const T_DIRECTION DIRECTION_LEFT = -1;

typedef char T_COL;
const T_COL MIN_COL = 'A';
const T_COL MAX_COL = 'H';
typedef int T_ROW;
const T_ROW  MIN_ROW = 1;
const T_ROW  MAX_ROW = 8;

typedef struct {
	T_COL col;
	T_ROW row;
} COORD;



T_PIECE board[WIDTH][WIDTH];
T_PIECE captured[NUM_PIECES]; //Place to put captured pieces
T_PIECE* nextFreeCaptureSlot; //Which place is the next available
T_PLAYER_COLOR currentPlayerColor;

void playGame(void);
void playTurn(T_PLAYER_COLOR player);

bool isValidCoordinate(COORD* where);
char getPieceAt(COORD* where);
/**
 @brief Figure out which square (white or black) should go at a given location
 @param where coordinate to determine color
 @returns  SQUARE_WHITE or SQUARE_BLACK
 */
char getSquareAt(COORD* where);
char colorOfPiece(T_PIECE piece);
bool isEmpty(COORD* where);
bool isEnemyOccupied(COORD* where, T_PLAYER_COLOR myColor);
/**
 @brief Determine if all squares on horiz/vert/diag route are empty
 @param from Source to begin at (not checked for emptyness)
 @param to Target to end at (not checked for emptyness)
 @returns true if intervening space clear, false if not
 */
bool isPathClear(COORD* from, COORD* to);
void printCoord(COORD* where);
int validityOfMoveBy(COORD* from, COORD* to, T_PLAYER_COLOR playerColor);
bool isInvalid(T_MOVE_LEGALITY validCode);

bool isValidMotion(COORD* from, COORD* to);

bool isValidMotionKnight(COORD* from, COORD* to);
bool isValidMotionPawn(COORD* from, COORD* to);
bool isValidMotionRook(COORD* from, COORD* to);
bool isValidMotionBishop(COORD* from, COORD* to);
bool isValidMotionKing(COORD* from, COORD* to);
bool isValidMotionQueen(COORD* from, COORD* to);

void moveCoordToward(COORD* where, COORD* destination);
bool isCoordDifferent(COORD* one, COORD* another);
void copyCoordTo(COORD* original, COORD* copy);
void seetCoordFromRowCol(COORD* where, int r, int c);
void inputCoordFromUser(COORD* where);

void captureAt(COORD* target);
void resetCaptures(void);
void resetBoard(void);
void resetSquareAt(COORD* target);
void setPieceAtTo(COORD* where, T_PIECE piece);
/**
 @brief Moves a piece, and captures if appropriate. DOES NOT CHECK MOVE VALIDITY
 @param from Source location
 @param to Target location
 */
void doMove(COORD* from, COORD* to);

void printBoard();
void printCaptures();

int main(void)
{
	playGame();
	return 0;
}



void playGame(void)
{
    resetBoard();
    resetCaptures();
    printf("Welcome to... CHESSish\n\n");
    char player = PLAYER_WHITE;
    while(true)
    {
        playTurn(player);
        
        //Switch players
        if(player==PLAYER_WHITE)
            player=PLAYER_BLACK;
        else
            player=PLAYER_WHITE;
    }
}

void playTurn(T_PLAYER_COLOR player)
{
    int validity;
    bool invalid;
    COORD from;
    COORD to;
    
    printCaptures();
    printf("\nPlayer %c's turn\n", player);
    do {
        printBoard();
        printf("Where do you want to move from and to? E.g. A5 B3\n");
        inputCoordFromUser(&from);
        inputCoordFromUser(&to);
        validity=validityOfMoveBy(&from, &to, player);
        invalid = isInvalid(validity);
    } while (invalid);
    doMove(&from, &to);
    printf("\n\n\n");
    
}

bool isInvalid(int validCode)
{
    bool illegal = true;
    if(validCode & MOVE_LEGAL_OPEN)
    {
//        printf("A standard move\n");
        illegal=false;
    }
    if(validCode & MOVE_LEGAL_CAPTURE)
    {
//        printf("Oooh, a capture!\n");
        illegal=false;
    }
    if(validCode & MOVE_ILLEGAL_BLOCKED)
    {
        printf("Illegal: Can't capture your own pieces\n");
        illegal=true;
    }
    if(validCode & MOVE_ILLEGAL_COLOR)
    {
        printf("Illegal: Wrong colored piece\n");
        illegal=true;
    }
    if(validCode & MOVE_ILLEGAL_MOTION)
    {
        printf("Illegal: The piece is blocked or doesn't move that way\n");
        illegal=true;
    }
    if(validCode & MOVE_ILLEGAL_OFFBOARD)
    {
        printf("Illegal: The board is not that big\n");
        illegal=true;
    }
    return illegal;
}

bool isValidCoordinate(COORD* where)
{
	if(where->col<MIN_COL) return false;
	if(where->col>MAX_COL) return false;
	if(where->row<MIN_ROW) return false;
	if(where->row>MIN_COL) return false;
	return true;
}

char getPieceAt(COORD* where)
{
	if(!isValidCoordinate(where)) return PIECE_NONE;
	int colIndex = where->col - MIN_COL;
	int rowIndex = where->row - MIN_ROW;
	return board[colIndex][rowIndex];
}
int getPieceCode(char piece)
{
    switch(piece)
    {
        case PIECE_WHITE_QUEEN:
        case PIECE_BLACK_QUEEN:
            return PIECE_QUEEN;
        case PIECE_WHITE_KING:
        case PIECE_BLACK_KING:
            return PIECE_KING;
        case PIECE_WHITE_BISHOP:
        case PIECE_BLACK_BISHOP:
            return PIECE_BISHOP;
        case PIECE_WHITE_KNIGHT:
        case PIECE_BLACK_KNIGHT:
            return PIECE_KNIGHT;
        case PIECE_WHITE_PAWN:
        case PIECE_BLACK_PAWN:
            return PIECE_PAWN;
        case PIECE_WHITE_ROOK:
        case PIECE_BLACK_ROOK:
            return PIECE_ROOK;
        default:
            return PIECE_NONE;
    }
}

char getSquareAt(COORD* where)
{
	if(!isValidCoordinate(where)) return PIECE_NONE;
	int colIndex = where->col - MIN_COL;
	int rowIndex = where->row - MIN_ROW;
	//Just a joint parity check
	if((rowIndex+colIndex)%2 == 0) return SQUARE_WHITE;
	else return SQUARE_BLACK;
}

bool isEmpty(COORD* where)
{
	//You're empty if you're a black or white square
	char piece;
	piece = getPieceAt(where);
	if(piece==SQUARE_WHITE) return true;
	if(piece==SQUARE_BLACK) return true;
	return false;
}

char colorOfPiece(T_PIECE piece)
{
	//Translate to bit masking shiftery
	if('a'<=piece && piece<='z') return PLAYER_WHITE;
	if('A'<=piece && piece<='Z') return PLAYER_BLACK;
	return PLAYER_NONE;
}

bool isEnemyOccupied(COORD* where, T_PLAYER_COLOR myColor)
{
	if(myColor==PLAYER_NONE) return false; //Seriously? How?
	T_PIECE piece = getPieceAt(where);
	T_PLAYER_COLOR pieceColor = colorOfPiece(piece);
	if(pieceColor==PLAYER_NONE) return false; //No piece, no player
	return (pieceColor != myColor); //Different colors therefore enemies
}

bool isCoordDifferent(COORD* one, COORD* another)
{
	if(one->row != another->row) return true;
	if(one->col != another->col) return true;
	return false;
}
bool isPathClear(COORD* from, COORD* to)
{
	COORD between;
	copyCoordTo(from, &between);
//    printf("Starting path check at "); printCoord(&between);
	moveCoordToward(&between, to); //Skip source location
	while(isCoordDifferent(&between, to))
	{ //check if intermediates are occupied
//        printf("Checking coord "); printCoord(&between);
		if(!isEmpty(&between))
        {
//            printf("Path encountered blockage at "); printCoord(&between);
            return false;
        }
        moveCoordToward(&between, to);
	}
	return true; //It's not bad, it must be good!
}
int validityOfMoveBy(COORD* from, COORD* to, T_PLAYER_COLOR playerColor)
{
	int failCode = 0;
	int passCode = 0;
	
	if(!isValidCoordinate(from))
		failCode |= MOVE_ILLEGAL_OFFBOARD;
	
	if(!isValidCoordinate(to))
		failCode |= MOVE_ILLEGAL_OFFBOARD;
	
	if(failCode != 0) return failCode; //Check no farther.
    
	
    
	if(isEnemyOccupied(from, playerColor))
		failCode |= MOVE_ILLEGAL_COLOR;
	
	if(isEnemyOccupied(to, playerColor))
		passCode |= MOVE_LEGAL_CAPTURE;
	else if(isEmpty(to))
		passCode |= MOVE_LEGAL_OPEN;
	else
		failCode |= MOVE_ILLEGAL_BLOCKED; //Blocked by own color piece
    
	if(!isValidMotion(from, to))
		failCode |= MOVE_ILLEGAL_MOTION;
	
	if(failCode != 0) return failCode; //Bad trumps good :(
	else return passCode;
}

bool isValidMotion(COORD* from, COORD* to)
{
	char piece = getPieceAt(from);
	int pieceCode = getPieceCode(piece);
	bool motionOk;
	bool pathClear;
    
	switch(pieceCode)
	{ //Check if motion is ok
		case PIECE_QUEEN:
			motionOk = isValidMotionQueen(from, to);
			break;
		case PIECE_KING:
			motionOk = isValidMotionKing(from, to);
			break;
		case PIECE_BISHOP:
			motionOk = isValidMotionBishop(from, to);
			break;
		case PIECE_KNIGHT:
			motionOk = isValidMotionKnight(from, to);
			break;
		case PIECE_PAWN:
			motionOk = isValidMotionPawn(from, to);
			break;
		case PIECE_ROOK:
			motionOk = isValidMotionRook(from, to);
			break;
		default:
			return false;
	}
	if(!motionOk)
    {
//        printf("BAD MOTION\n");
        return false;
    }
    
	switch(pieceCode)
	{ //Check if motion is ok
		case PIECE_QUEEN:
			pathClear = isPathClear(from, to);
			break;
		case PIECE_BISHOP:
			pathClear = isPathClear(from, to);
			break;
		case PIECE_ROOK:
			pathClear = isPathClear(from, to);
			break;
		case PIECE_KING:
		case PIECE_KNIGHT:
		case PIECE_PAWN:
		default:
			pathClear = true;
			break;
	}
    if(!pathClear)
    {
//        printf("BAD PATH\n");
    }
	return pathClear;
}

bool isValidMotionKnight(COORD* from, COORD* to)
{
	int xdist = from->col - to->col;;
	int ydist = from->row - to->row;
//    printf("%s| dX: %d dy: %d\n", "KNIGHT", xdist, ydist);
	if(xdist*xdist + ydist*ydist == 5) return true;
	else return false;
}
bool isValidMotionPawn(COORD* from, COORD* to)
{
	char thePiece=getPieceAt(from);
	char theColor=colorOfPiece(thePiece);
	int requestedDirection=(to->row - from->row);
	
	bool nonCapture;
	
	int allowedDirection = DIRECTION_NONE;
	if(theColor==PLAYER_BLACK)
		allowedDirection=DIRECTION_BLACK;
	if(theColor==PLAYER_WHITE)
		allowedDirection=DIRECTION_WHITE;
    
	if(allowedDirection!=requestedDirection) return false;
	//Pawn going in right direction, but move depends
	//on capture/noncapture
    
	requestedDirection=(to->col - from->col);
	if(requestedDirection<-1) return false; //Too far
	if(requestedDirection>1) return false; //Too far
	nonCapture = isEmpty(to);
	if(requestedDirection==0)
	{//moving forward
		return nonCapture; //Forward requires no capture
	}
	else
	{//Diagonal move
		return !nonCapture; //Diagonal requires a capture
	}
}
bool isValidMotionRook(COORD* from, COORD* to)
{
	int xdist = from->col - to->col;
	int ydist = from->row - to->row;
//    printf("%s| dX: %d dy: %d\n", "ROOK", xdist, ydist);
	if(xdist==0) return true;
	if(ydist==0) return true;
	return false;
    //	if(xdist*ydist == 0) return true;
}
bool isValidMotionBishop(COORD* from, COORD* to)
{
    int xdist = from->col - to->col;
    int ydist = from->row - to->row;
//    printf("%s| dX: %d dy: %d\n", "BISHOP", xdist, ydist);
    if(xdist==ydist) return true;
    if(xdist+ydist==0) return true;
    else return false;
    //	if(xdist*xdist == ydist*ydist) return true;
}
bool isValidMotionKing(COORD* from, COORD* to)
{
    int xdist = from->col - to->col;
    int ydist = from->row - to->row;
//    printf("%s| dX: %d dy: %d\n", "KING", xdist, ydist);
    if(xdist*xdist + ydist*ydist <= 2) return true;
    else return false;
}
bool isValidMotionQueen(COORD* from, COORD* to)
{
    if(isValidMotionBishop(from, to)) return true;
    if(isValidMotionRook(from, to)) return true;
    return false;
}



void moveCoordToward(COORD* where, COORD* destination)
{
    int xdist = where->col - destination->col;
    int ydist = where->row - destination->row;

    if(xdist>0) where->col--;
    if(xdist<0) where->col++;
    
    if(ydist>0) where->row--;
    if(ydist<0) where->row++;
    
    if(xdist==0) return; //Vertical OK
    if(ydist==0) return; //Horizontal OK
    if(xdist == ydist) return; //Back Diagonal OK
    if(xdist+ydist==0) return; //Forward Diagonal OK

    //Weird move - shouldn't have been attempted
//    printf("WARNING: Weird move dX:%d dY:%d\n", xdist, ydist);
}

void copyCoordTo(COORD* original, COORD* copy)
{
    copy->col = original->col;
    copy->row = original->row;
}
void seetCoordFromRowCol(COORD* where, int r, int c)
{
    where->col=c+MIN_COL;
    where->row=r+MIN_ROW;
}
void inputCoordFromUser(COORD* where)
{
    scanf(" %c%d", &(where->col), &(where->row));
    //Use bit maskery
    where->col = toupper(where->col);
    printCoord(where);
}

void captureAt(COORD* target)
{
    char square;
    char piece;
    square = getSquareAt(target);
    piece = getPieceAt(target);
    setPieceAtTo(target, square); //Remove from board
    *nextFreeCaptureSlot = piece; //Add to prison
    nextFreeCaptureSlot++; //Increment counter
}
void resetCaptures(void)
{
    for(int i=0; i<NUM_PIECES; i++)
    {
        captured[i]=PIECE_NONE; //Clear cells
    }
    nextFreeCaptureSlot=captured; //Reset counter
}
void resetBoard(void)
{
    COORD target;
    int blackrow = 0;
    int whiterow = WIDTH-1;
    
    //Big Pieces
    int offset;
    
    offset = 0;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_ROOK);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_ROOK);
    offset = WIDTH-1-offset;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_ROOK);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_ROOK);
    
    offset = 1;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_KNIGHT);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_KNIGHT);
    offset = WIDTH-1-offset;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_KNIGHT);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_KNIGHT);
    
    offset = 2;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_BISHOP);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_BISHOP);
    offset = WIDTH-1-offset;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_BISHOP);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_BISHOP);
    
    offset = 3;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_QUEEN);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_KING);
    offset = WIDTH-1-offset;
    seetCoordFromRowCol(&target, blackrow, offset);
    setPieceAtTo(&target, PIECE_BLACK_KING);
    seetCoordFromRowCol(&target, whiterow, offset);
    setPieceAtTo(&target, PIECE_WHITE_QUEEN);
    
    //Pawns
    
    int blackpanrow = blackrow+DIRECTION_BLACK;
    int whitepawnrow = whiterow+DIRECTION_WHITE;
    
    for(int col=0; col<WIDTH; col++)
    {
        seetCoordFromRowCol(&target, blackpanrow, col);
        setPieceAtTo(&target, PIECE_BLACK_PAWN);
        //resetSquareAt(&target); //FOR TESTING
        seetCoordFromRowCol(&target, whitepawnrow, col);
        setPieceAtTo(&target, PIECE_WHITE_PAWN);
        //resetSquareAt(&target); //FOR TESTING
    }
     
    
    //Squares
    for(int row=blackpanrow+DIRECTION_BLACK;
        row<whitepawnrow; row++)
    {
        for(int col=0; col<WIDTH; col++)
        {
            seetCoordFromRowCol(&target, row, col);
            resetSquareAt(&target);
        }
    }
}

void resetSquareAt(COORD* target)
{
    char piece;
    piece = getSquareAt(target);
    setPieceAtTo(target, piece);
}
void setPieceAtTo(COORD* where, char piece)
{
    int colIndex = where->col - MIN_COL;
    int rowIndex = where->row - MIN_ROW;
    board[colIndex][rowIndex] = piece;
}
void doMove(COORD* from, COORD* to)
{
    if(!isEmpty(to)) captureAt(to);
    setPieceAtTo(to, getPieceAt(from));
    resetSquareAt(from);
    setPieceAtTo(from, getSquareAt(from));
}



//Stuff to track kings
//Stuff to note if they're in check? Prevent illegal moves while in check?

//	Check for check

void printBoard()
{
    int r,c;
    
    printf("   ");
    for(c=0; c<WIDTH; c++)
    {
        printf("%c", c+MIN_COL);
    }
    printf("    \n\n");
    
    
    for(r=0; r<WIDTH; r++)
    {
        printf("%d  ", r+MIN_ROW);
        for(c=0; c<WIDTH; c++)
        {
            printf("%c", board[c][r]);
        }
        printf("  %d", r+MIN_ROW);
        printf("\n");
    }
    
    
    printf("\n   ");
    for(c=0; c<WIDTH; c++)
    {
        printf("%c", c+MIN_COL);
    }
    printf("    \n");
    
}

void printCaptures()
{
    printf("Captured: ");
    for(int c=0; c<NUM_PIECES; c++)
    {
        printf("%c", captured[c]);
    }
    printf("\n");
}

void printCoord(COORD* where)
{
    printf("[%c%d]", where->col, where->row);
}
