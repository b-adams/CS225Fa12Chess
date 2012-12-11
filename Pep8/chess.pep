; Adams Stuff begins
CALL main
STOP
; Adams Stuff ends


; Steere Stuff begins
MIN_COL: .equate 'A'; Minimum column
MAX_COL: .equate 'H'; Maximum column
MIN_ROW: .equate 1; Minimum Row
MAX_ROW: .equate 8; Maximum Row
;Directions
DIR_NONE: .equate 'x'; Direction none
DIR_NORT: .equate 'n'; Directoion north
DIR_EAST: .equate 'e'; Direction east
DIR_STH: .equate 's'; Direction south
DIR_WEST: .equate 'w'; Direction west
;Display for player
BRD_WTR: .equate '~'; Board with water 
BRD_SHIP: .equate '#'; Board with ships
;Display to opponent
VIUNKWN: .equate '.'; Opponent view
;Use for everyone
GRID_BAD: .equate '?'; Not on grid
GRID_HIT: .equate '*'; Hit on ship
GRID_SPH: .equate '@'; Missing target 
;Ship sizes
BT_PT: .equate 2; size of patrol ship
BT_SUB: .equate 3; size of submarine
BT_DEST: .equate 3; size of destroyer
BT_BTSP: .equate 4; size of battlehship
BT_CARR: .equate 5; size of carrier
;Game over
GAM_NT: .equate 0; Game not over
GAM_TI: .equate -1; Game over tie
GAM_P1: .equate 1; Game over player 1
GAM_P2: .equate 2; Game over player 2
; Steere Stuff end


; Evans Stuff begins
;------------------------------int checkGameOver(PLAYER* plr1, PLAYER* plr2);---------------
ckgmeova:NOP0
ldx plr1,i
cpa 1,i
BRLT plr2win
ldx plr2,i
cpa 1,i 
BRLT plr1win

         plr2win: NOP0


         plr1win: NOP0

;------------------------------void runGame(void)--------------------------------

runGame: NOP0

player: .equate 0 #2h 



msg1: .ASCII "\t\tWelcome to Shooting Boats!\n\n\n\x00"
msg2: .ASCII "Setting up player 1\n\x00"
msg3: .ASCII "Setting up player 2\n\x00"
msg4: .ASCII "\n\n\n\n\n\n\n\n\x00"
msg5: .ASCII "\t\tTime to play!\n\x00"
msg6: .ASCII "\t\tThe game is over!\n\x00"

STRO msg1,d

STRO msg2,d
LDX plr1,i ;prepare to access player 1 for setup
CALL setupPlr 
STRO msg4,d

STRO msg3,d
LDX plr2,i ;prepare to access player 2 for setup
CALL setupPlr
STRO msg4,d

STRO msg5,d
CALL playLoop
STRO msg6,d

BR KEswitch,x

         KEswitch: .ADDRSS case0
                   .ADDRSS case1
                   .ADDRSS case2
                   .ADDRSS case3
         case0: STRO tie,d
                BR endCase
         case1: STRO plr1win,d
                BR endCase
         case2: STRO plr2win,d
                BR endCase
         case3: STRO default,d
                BR endCase
         tie: .ASCII "Mutually Assured Destruction!\n\x00"
         plr1win: .ASCII "Player 1 survives!!\n\x00"
         plr2win: .ASCII "Player 2 triumphs!\n\x00"
         default: .ASCII "The Bermuda Triangle strikes again...\x00"




;----------------------------------------void setupPlayer(PLAYER* plr);--------------------

setupPlr: NOP0

target: .equate 0 ;local address #2h

LDX column,i
STX target,sxf
LDA target,s
STA drexion,s


LDX row,i
STX target,sxf
 


;---------------------------------------void resetPlayer(PLAYER* whom);--------------------

resetPlr: NOP0


;---------------------------------------void setCoord(COORDINATE* where, int r, int c);----

setCoord: NOP0

;where->column=c+MIN_COL;
;where->row=r+MIN_ROW;

; Evans Stuff ends


; Brutscher Stuff begins
;-------------------------------------------------------------------------------;
intPlShp: NOP0 ;void interactivePlaceShip(PLAYER *plr, char* shipName, int size)
Br iPlShpSt
;DETERMINE VARIABLES AND NAMES
JBpsVplc: .equate 0 ;bool placed (=false) ;local variable #1h
JBpsVdir: .equate  1 ;char direction ;local variable #1c
;JBpsVsze: .equate 2 ; int size ;local variable #2d ; I don't actually see this declared, but I'm gonna' use it, so do I declare this or not?
;because size is going to come from one of Kyle's Constants, but what ultimately points to them or calls them here? I might figure this out once I get further.
;Oh wait...it's not a variable at all. It's a parameter.
JBpsVtrg: .equate 4 ;COORDINATE target ;local structure #row #col
;(Frame = [42] + 2 = 44)

;DETERMINE FORMAL PARAMETERS AND (CALLEE) NAMES
JBpsPplr: .equate 46 ;PLAYER *plr ;local parameter #2h
JBpsPspn: .equate 47 ;char *shipName ;local parameter #1c
JBpsPsze: .equate 49 ;int size ;local param #2d


;{
;	COORDINATE target;
;	char direction;
;	bool placed=false;
iPlShpSt: NOP0
;
;	printGrid(plr->board);

;
;	while(!placed)
;	{
;		printf("Where is the front of your %s? ", shipName);
;		inputCoord(&target);
;		printf("Which direction is the rest of it? (n,e,w,s):");
;		scanf(" %c", &direction);
;		placed = placeShip(size, &target, direction, plr);
;	}
;}
RET0

;-------------------------------------------------------------------------------;
extRound: NOP0 ;void executeRound(PLAYER* plr1, PLAYER* plr2)
BR JBerStrt ;skipping my variables and parameters and calle(e/r) names and strings and such

;DETERMINE VARIABLES AND NAMES
JBerVp1h: .equate 0 ;bool plr1hits ;local variable #1h
JBerVp2h: .equate 1 ;bool plr2hits ;local variable #1h ;check the trace tags
;not sure if I gave myself enough space for bools or what we're using for them
;but my instinct tells me that it's best to keep bools at 1 byte (1 nyyble would be nicer if we could load it)
;I need to figure out a more clever way to work with bools
JBerVtrg: .equate 3 ;COORDINATE target ;local structure #row #col
;for some reason the translation example tells me that COORDINATE is 42 bytes
;that means that there are 44 bytes in this frame theoretically, yes?

;DETERMINE FORMAL PARAMETERS AND (CALLEE) NAMES
JBerPpl1: .equate 46 ;PLAYER* plr1 ;local parameter #2h
JBerPpl2: .equate 48 ;PLAYER* plr2 ;local parameter #2h

;NOW FOR THE CALL(ER) NAMES (ARGS)
JBerApl1: .equate -4 ;PLAYER* plr1 ;function argument
JBerApl2: .equate -2 ;PLAYER* plr2 ;function argument

;FRAMES
JBerifrm: .equate 44 ;internal frame size for plr1hits, plr2hits, target
JBerXFRM: .equate 4 ;external frame size for plr1, plr2
;is this right? Or do i seperate it for plr1 and plr2?

;Now I gotta' have strings? 
JBerSg1: .ASCII "Player 1\x00"
JBerSg2: .ASCII ": Enter target! \x00"
JBerSg3: .ASCII "Player 2"
JBerSg4: .ASCII "\n\nSHELLS IN THE AIR!\n\n\x00"
JBerSg5: .ASCII "... \x00"
JBerSg6: .ASCII "hits!\n\x00"
JBerSg7: .ASCII "can take \x00"
JBerSg8: .ASCII "more hits \x00"
JBerSg9: .ASCII "misses.\n\x00"


JBerStrt: NOP0 ;Now we get down to business
;{
; I think that this line takes care of itself; COORDINATE target;
;And this one; bool plr1hits;
;And probably this one too; bool plr2hits;


	;printGrid(plr2->view)
           LDX DLview, i ;waiting on Dauris to name this, Actually I don't even believe this is the first step here
           STA JBerPpl2, x ;again this might be it and might not be it. I'm still following the translation example pretty closely
           LDA JBerPpl2, s
           STA DLpgAgrd, s ;waiting for Dauris to name grid arg of printgrid func.
           SUBSP DLpgXFRM, i ;Allocate placeholder amount #dunnoNameYet #DUNNOnAMEyET
           CALL DLprntGrd ;Call to placeholder name
           ADDSP DLpgXFRM ;Deallocate by placeholder amount #DUNNOnAMEyET #dunnoNameYet
           ;ENDPRINTGRID(PLR2->VIEW)
         

	STRO JBerSg1, d ;printf(''Player 1
	STRO JBerSg2, d ;: Enter target! '');
           

           ;inputCoord(&target)
           ;prepare target as an argument
           MOVSPA
           ADDA target, i
           STA JBicAtrg, s
           ;Allocate, call, and deallocate
           SUBSP JBicXFRM ;Allocate by amount #IMnotSURE
           CALL inpCoord ;call inputCoordinate    ;I'm assuming that this is where we ACTUALLY enter our target
           ADDSP JBicXFRM ;Deallocate by amount #IMnotSURE
           ;END INPUTCOORD (&target)
           
	;plr1hits = checkForHit(&target, plr2)

           
           ;
            
	;printGrid(plr1->view)


           ;

           STRO JBerSg3, d ; printf(''Player 2
           STRO JBerSg2, d;: Enter target! '');
	
           ;inputCoord(&target)
           MOVSPA
           ADDA target, i
           STA JBicAtrg, s
           ;Allocate, call, and deallocate
           SUBSP JBicXFRM ;Allocate by amount #IMnotSURE
           CALL inpCoord ;call inputCoordinate    ;I'm assuming that this is where we ACTUALLY enter our target
           ADDSP JBicXFRM ;Deallocate by amount #IMnotSURE

           ;END INPUTCOORD(&target)


	;plr2hits = checkForHit(&target, plr1);

	STRO JBerSg4, d ;printf(''\n\nSHELLS IN THE AIR!\n\n'');

	STRO JBerSg1, d ;printf(''Player 1
            STRO JBerSg5, d ;... '');
	JBerp1ht: NOP0;if(plr1hits)
            CPA 1, i ; compare accumulator to true
            BRNE JBerp1ms ;if not true jump to else loop
	;{
	STRO JBerSg6, d ;printf(''hits!\n'');The Original line says printf(''Player 2...''), but I think this should be printf(''hits!'') ;printf(''Player 2... '');
		STRO JBerSg3, d ;printf("Player %d 
                       STRO JBerSg7, d      ;can take 
                       ;DECO something?      ;%d 
                             
                       STRO JBerSg8, d                   ;more hits.\n", 2, plr2->hits);
           BR JBerp2ht ;branch to next if loop            		
	;} else {
            JBerp1ms: NOP0 ;initiate else loop
;do some things inside the else loop
		STRO JBerSg9, d ;printf(''misses.\n'');
	;}
           CPA 0, i ;error checking
           BRNE JBerROR ;error checking
	STRO JBerSg3, d ;printf("Player 2
           STRO JBerSg5, d  ;... ")
           BR JBerp2ht ;branch to next if loop
	JBerp2ht: NOP0;if(plr2hits)
           CPA 1, i ;compare accumulator to true (1)
           BRNE JBerp2ms ;if not true jump to else condition
	;{
		STRO JBerSg6, d;printf(''hits!\n'');
                       STRO JBerSg1, d ;printf("Player %d 
                       STRO JBerSg7, d      ;can take 
                       ;DECO something?      ;%d 
                             
                       STRO JBerSg8, d ;more hits.\n", 1, plr1->hits);
                       BR JBerEND ;jump to return		
	JBerp2ms: NOP0;} else {
           CPA 0, i ;error checking
           BRNE JBerROR ;error checking
	STRO JBerSg9, d ;printf(''misses.\n'');
           BR JBerEND
	;}
         JBerROR: NOP0
         STRO "Houston we have a problem!\n\x00" ;Error checking of my own doing. Poor form, but will be removed once I know that everything is working with this function.
         BR JBerEND
;}
JBerEND:NOP0
RET0



;-------------------------------------------------------------------------------;
inpCoord: NOP0 ;void inputCoord(COORDINATE* target)


JBicAtrg: .equate xx ;COORDINATE* target ;function argument

JBicifrm: .equate xx ;internal frame size for (variables)
JBicXFRM: .equate x ;external frame size for target

;{
;	scanf(" %c%d", &(target->column), &(target->row));
;	target->column = toupper(target->column);
;	printf("Target entered: "); printCoord(target); printf("\n");
;}
RET0

;-------------------------------------------------------------------------------;
cpyCoord: NOP0 ;void copyCoord(COORDINATE* original, COORDINATE* copy)
;{
;	copy->column = original->column;
;	copy->row = original->row;
;}
RET0
;-------------------------------------------------------------------------------;

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
CPA DIR_NORTH,s ;is equal to 'n'
BREQ north ;place it north
CPA DIR_SOUTH,i ;is equal to 's'
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
where: .Equate 0 ;local variable #2h
grid: .Equate 2 ;local array #1c2a
gtSpace: .Equate 4 ;size of stack of #grid #where

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


; Little Stuff begins``````````````````````````````````````````````````````````````````````````````````````````````66  

;typedef struct Coordinate
column:  .equate 0   ;struct field #1c
row:     .equate 1   ;struct field #2d
coordin: .block 3    ;global variable #column #row

;typedef struct Playes
board:   .equate 4   ;struct field #1c
view:    .equate 2   ;struct field #1c
hits:    .equate 0   ;struct field #2d
player:  .block 5    ;gloabl variable #board #view #hits

;void printCoord
where: .equate 0     ;??

;void printGrid
grid: .equate ??

;void setSpace
symbol: .equate 


main:nop0
call runGame
ret0

runGame:nop0
; Little Stuff ends

.END