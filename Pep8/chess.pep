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
intPlShp: NOP0 ;void interactivePlaceShip(PLAYER *plr, char* shipName, int size)
direc: .BLOCK 1 ;make into NOT GLOBAL later 
placed: .EQUATE 0 ;yeah again...
;{
         ;COORDINATE target
         LDA target, d  ;(check addressing mode)/(It's not going to be a global)
         STA COORDINATE, x; (check addressing mode)
         ;char direction
                             
         ;bool placed = false;
                             
         
         ;printGrid(plr->board);
       
         CALL printGrid, x ;(I need to do more here)
         
         ;while (!placed)
         
         ;{
                 





RET0


extRound: NOP0 ;void executeRound(PLAYER* plr1, PLAYER* plr2)
BR JBerStrt ;skipping my variables and parameters and calle(e/r) names and strings and such

;DETERMINE VARIABLES AND NAMES
JBerVp1h: .equate 0 ;bool plr1hits ;local variable #1h
JBerVp2h: .equate 1 ;bool plr2hits ;local variable #1h ;check the trace tags
;not sure if I gave myself enough space for bools or what we're using for them
;but my instinct tells me that it's best to keep bools at 1 byte (1 nyyble would be nicer if we could load it)
;I need to figure out a more clever way to work with bools
JBerVtrg: .equate 3 ;COORDINATE target ;local structer #row #col
;for some reason the translation example tells me that COORDINATE is 42 bytes
;that means that there are 44 bytes in this frame theoretically, yes?

;DETERMINE FORMAL PARAMETERS AND (CALLEE) NAMES
JBerPpl1: .equate 46 ;PLAYER* plr1 ;local parameter #2h
JBerPpl2: .equate 48 ;PLAYER* plr2 ;local parameter #2h

;NOW FOR THE CALL(ER) NAMES (ARGS)
JBerApl1: .equate -2 ;PLAYER* plr1 ;function argument
JBerApl2: .equate -4 ;PLAYER* plr2 ;function argument

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
;	COORDINATE target;
;	bool plr1hits;
;	bool plr2hits;
;
;
;	printGrid(plr2->view);
;	printf("Player 1: Enter target! ");
;	inputCoord(&target);
;	plr1hits = checkForHit(&target, plr2);
;
;	printGrid(plr1->view);
;	printf("Player 2: Enter target! ");
;	inputCoord(&target);
;	plr2hits = checkForHit(&target, plr1);
;
;	printf("\n\nSHELLS IN THE AIR!\n\n");
;
;	printf("Player 1... ");
;	if(plr1hits)
;	{
;		printf("Player 2... ");
;		printf("Player %d can take %d more hits.\n", 2, plr2->hits);		
;	} else {
;		printf("misses.\n");
;	}
;
;	printf("Player 2... ");
;	if(plr2hits)
;	{
;		printf("hits!\n");
;		printf("Player %d can take %d more hits.\n", 1, plr1->hits);
;	} else {
;		printf("misses.\n");
;	}
;}
RET0


inpCoord: NOP0 ;void inputCoord(COORDINATE* target)

RET0


cpyCoord: NOP0 ;void copyCoord(COORDINATE* original, COORDINATE* copy)

RET0


; Brutscher Stuff ends


; LeBerth Stuff begins

; LeBerth Stuff ends


; Little Stuff begins

; Little Stuff ends

.END