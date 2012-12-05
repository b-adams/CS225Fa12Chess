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
where: .Equate 0 ;struct field #2h
distance: .Equate 2 ;struct field #2d
drection: .Equate 4 ;struct field #1c
coord: .Equate 5 ;local variable #drection #distance #where
   ;Making a Coordinate as a single concept/object/structure
mvCoord: NOP0
SUBSP coord,i ;allocating #drection #distance #where
;?
;LDX row,i Dauris choses row name...
; sxf
;LDX drection,i
;CPA DIR_NORTH,i
;BRNE ;someplace....(Not North...)

;?
ADDSP coord,i ;deallocating #where #distance #drection

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