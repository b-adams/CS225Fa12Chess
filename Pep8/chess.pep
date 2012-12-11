; Adams Stuff begins
CALL main
STOP
; Adams Stuff ends


; Steere Stuff begins

; Steere Stuff end


; Evans Stuff begins

; Evans Stuff ends


; Brutscher Stuff begins

; Brutscher Stuff ends


;---------------LeBerth Stuff begins-------------
;******************************************************************
;const char DIR_NONE='x';
;const char DIR_NORTH='n';
;const char DIR_EAST='e';
;const char DIR_SOUTH='s';
;const char DIR_WEST='w';
;***void movCoord(COORDINATE* where, int distance, char direction);***
  ;void moveCoord(COORDINATE* where, int distance, char direction)
  ;{
  ;	if(direction==DIR_NORTH) where->row -= distance;
  ;	if(direction==DIR_SOUTH) where->row += distance;
  ;	if(direction==DIR_WEST) where->column -= distance;
  ;	if(direction==DIR_EAST) where->column += distance;
  ;}

prompt: .ASCII "Where would you like place the tail of the ship?"
oops: .ASCII "Can't be placed there..."

where: .Equate 0 ;struct field #2h
distance: .Equate 2 ;struct field #2d
drection: .Equate 4 ;struct field #1c
mvCoord: .Equate 5 ;local variable #drection #distance #where
   
movCoord: NOP0
SUBSP mvCoord,i ;allocating #drection #distance #where
LDA 1,i
STA distance,s
STRO prompt,i
CHARO drection,s
LDA drection,s ;if drection..
CPA DIR_NORT,s ;is equal to 'n'
BREQ north ;place it north
CPA DIR_STH,i ;is equal to 's'
BREQ south ;place it south
CPA DIR_EAST,i ;is equal to 'e'
BREQ east ;place it east
CPA DIR_WEST,i ;is equal to 'w'
BREQ west ;place it west
CPA DIR_NONE ;is equal to none
BR none ;it is one point
BR retry ;is equal to no valid choice...

north: NOP0 ;where->row -= distance
LDX row,i
STX where,sxf
LDA where,sxf
SUBA distance,s
STA where,sxf
LDX where,sxf
STX row,i
BR placed

south: NOP0 ;where->row += distance
LDX row,i
STX where,sxf
LDA where,sxf
ADDA distance,s
STA where,sxf
LDX where,sxf
STX row,i
BR placed

east: NOP0 ;where->column += distance
LDX column,i
STX where,sxf
LDA where,sxf
ADDA distance,s
STA where,sxf
LDX where,sxf
STX column,i
BR placed

west: NOP0 ;where->column -= distance
LDX column,i
STX where,sxf
LDA where,sxf
SUBA distance,s
STA where,sxf
LDX where,sxf
STX column,i
BR placed

none: NOP0
BR placed

retry: NOP0
STRO oops,i
BR movCoord

placed: NOP0
ADDSP mvCoord,i ;deallocating #where #distance #drection
RET0
;*****************************************************************
;*****************************************************************
;const int MIN_ROW = 1;
;const char MIN_COL = 'A';
;const char GRID_BAD = '?';
;***char getSpace(COORDINATE* where, char grid[8][8]);***
  ;{
  ;	if(!validSpace(where)) return GRID_BAD;
  ;	int colIndex = where->column - MIN_COL;
  ;	int rowIndex = where->row - MIN_ROW;
  ;	return grid[colIndex][rowIndex];
  ;}

where: .Equate 0 ;local variable #column #row
grid: .Equate 3 ;local array #1c2a
gtSpace: .Equate 5 ;size of stack of #grid #where

getSpace: NOP0
SUBSP gtSpace,i ;allocating #grid #where
LDX column,i
STX where,sxf
LDA where,sxf
SUBA MIN_COL,i
STA grid,sx ;should be first variable in grid?? And should Store BYTE!
LDX row,i
STX where,sxf
LDA where,sxf
SUBA MIN_ROW ;row is an integer.... column is a character..... ??!!
LDX 3,i ;Maybe useful in shifting from grid[colIndex] to grid[rowIndex]??
STA grid,sx ;Should store byte!! STBYTE?


ADDSP gtSpace,i ;deallocating #where #grid
;****************************************************************
;****************************************************************
;const char BOARD_WATER = '~';
;***bool placeShip(int size, COORDINATE* where, char direction, PLAYER* whom);***
  ;{
  ;	int dist;
  ;	COORDINATE target;
  ;	
  ;	//Make sure all of the spaces are clear (water)
  ;	copyCoord(where, &target);
  ;	dist=0;
  ;	while(dist<size)
  ;	{
  ;		if(getSpace(&target, whom->board) != BOARD_WATER)
  ;		{
  ;			return error("Could not place ship there\n");
  ;		}
  ;		moveCoord(&target, 1, direction);
  ;		dist++;
  ;	}
  ;
  ;	//Clear for placement!
  ;	whom->hits += size; //Keep track of remaining hits
  ;
  ;	//Place ship bits
  ;	for(dist=0, copyCoord(where, &target); dist<size; dist++, moveCoord(&target, 1, direction))
  ;	{
  ;		setShip(&target, whom);
  ;	}
  ;	return true; //Success!
  ;}

size: .Equate 0 ;local variable #2d
target: .Equate 2 ;local variable #column #row
drection: .Equate 5;local variable #1c
whom: .Equate 6 ;local variable #2h
plcShip: .Equate 8 ;size of stack of #whom #drection #where #size

placShip: NOP0
SUBSP plcShip,i ;allocating #whom #drection #where #size



ADDSP plcShip,i ;deallocating #size #where #drection #whom
;****************************************************************
;****************************************************************
;const int GAME_NOT_OVER = 0;
;***void playLoop(PLAYER* plr1, PLAYER* plr2);***
  ;{
  ;	int endGame=GAME_NOT_OVER;
  ;	while(endGame == GAME_NOT_OVER)
  ;	{
  ;		printf("\n\n\n\n\n");
  ;		executeRound(plr1, plr2);
  ;		endGame = checkGameOver(plr1, plr2);
  ;	}
  ;}

;const char BOARD_WATER = '~';
;const char BOARD_SHIP = '#';
;const char GRID_BAD = '?';
;const char GRID_HIT = '*';
;const char GRID_SPLOOSH = '@';
;***bool checkForHit(COORDINATE* where, PLAYER* whom);***
  ;{
  ;	char actual = getSpace(where, whom->board);
  ;	if(actual == BOARD_SHIP) {
  ;		setSpace(where, whom->board, GRID_HIT);
  ;		setSpace(where, whom->view, GRID_HIT);
  ;		whom->hits --;
  ;		return true;
  ;	} else if(actual == BOARD_WATER) {
  ;		setSpace(where, whom->board, GRID_SPLOOSH);
  ;		setSpace(where, whom->view, GRID_SPLOOSH);
  ;		return false;
  ;	} else {
  ;		setSpace(where, whom->board, GRID_BAD);
  ;		setSpace(where, whom->view, GRID_BAD);
  ;		return false;
  ;	}
  ;}


;--------------LeBerth Stuff ends-----------------


; Little Stuff begins

; Little Stuff ends

.END