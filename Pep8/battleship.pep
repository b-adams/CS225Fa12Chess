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

KEwhowin: .equate -2 ;local variable for return value #2d
plr1: .equate -4 ;local pointer #2h
plr2: .equate -6 ;local pointer #2h
KEovaFRM: .equate 6 ;frame for CALLER

ovafrm: .equate 8 ;frame for callee
whowin: .equate 6 ;return value #2d



ldx plr1,i
LDA hits,sxf
STA plr1,sxf
cpa 1,i
BRLT plr2win
ldx plr2,i
LDA hits,sxf
STA plr2,sxf
cpa 1,i 
BRLT plr1win
BR notover,d

         plr2win: NOP0
         LDA GAM_P2,d
         STA KEwhowin,s

         plr1win: NOP0
         LDA GAM_P1,d
         STA KEwhowin,s
      

         notover: NOP0
         LDA GAM_NT,d
         STA KEwhowin,s
      
RET0

;------------------------------void runGame(void)--------------------------------

runGame: NOP0
plr1: .equate 0 ;local structure #board #view #hits
plr2: .equate 2 ;local structure #board #view #hits
KErungme: .equate 6;frame for local structures


msg1: .ASCII "\t\tWelcome to Shooting Boats!\n\n\n\x00"
msg2: .ASCII "Setting up player 1\n\x00"
msg3: .ASCII "Setting up player 2\n\x00"
msg4: .ASCII "\n\n\n\n\n\n\n\n\x00"
msg5: .ASCII "\t\tTime to play!\n\x00"
msg6: .ASCII "\t\tThe game is over!\n\x00"
tie: .ASCII "Mutually Assured Destruction!\n\x00"
plr1win: .ASCII "Player 1 survives!!\n\x00"
plr2win: .ASCII "Player 2 triumphs!\n\x00"
default: .ASCII "The Bermuda Triangle strikes again...\x00"

STRO msg1,d
STRO msg2,d
LDX plr1,i ;prepare to access player 1 for setup
SUBSP plrFRAME,i ;allocating space for call #plr
CALL setupPlr 
ADDSP plrFRAME,i ;deallocating space for call #plr

STRO msg4,d

STRO msg3,d
LDX plr2,i ;prepare to access player 2 for setup
SUBSP plrFRAME,i ;allocating space for call #plr
CALL setupPlr
ADDSP plrFRAME,i ;deallocating space for call #plr

STRO msg4,d

STRO msg5,d
SUBSP ;*************dont forget to allocate space
CALL playLoop
ADDSP ;*************dont forget to deallocate space
STRO msg6,d

SUBSP KEovaFRM,i
LDX KEwhowin,s
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
ADDSP KEovaFRM,i

endCase: RET0   

;----------------------------------------void setupPlayer(PLAYER* plr);--------------------

setupPlr: NOP0

KEdirect: .equate 0 ;local variable #1c
KEok: .equate 1 ;local variable #1c
KEtarget: .equate 2 ;local structure #row #column
setupFR: .equate 5;frame for callee

plr: .equate -2 ;local pointer #2h
plrFRAME: .equate 2 ;frame for CALLER

KEokmsg: .ASCII "Is this setup ok? [y/n]\x00"

subsp setupFR,i
while: LDBYTEA KEok,s ;THE WHILE LOOP
CPA 'n',i
BREQ endWh
BR setup


setup: NOP0
SUBSP KEwhoFRM
CALL resetPlr ;resetPlater(plr)
ADDSP KEwhoFRM
SUBSP  ;*****************************check
CALL intPlShp ;Call the interactivePlaceShip
ADDSP i ;*****************************check
SUBSP plrFRAME,i ;*****************************check
CALL prntgrid ;Call printGrid(plr->board)
ADDSP plrFRAME,i ;*****************************check
STRO KEokmsg,d
CHARI ok,d
BR while

endWh: NOP0
ADDSP setupFR,i
RET0     
 


;---------------------------------------void resetPlayer(PLAYER* whom);--------------------

resetPlr: NOP0

KEwhom: .equate -2 ;local pointer #2h
KEwhoFRM: .equate 2 ;frame for caller

j: .equate 0 ;local variable #2d

LDX hits,i ;whom->hits=0
LDA 0,i
STA KEwhom,s
;SETTING UP FOR LOOP: NEED LOOP WITHIN LOOP
SUBSP 2,i ;allocate #j 
LDA 0,i
STA j,s
CPA 8
BRGE endFor
Call setCoord
Call setWater
DECO j,s
CHARO '\n',i
LDA j,s
ADDA 1,i
STA j,s
BR for

endFor: NOP0
DECO j,s
CHARO '\n',i
ADDSP 2,i ;deallocate #j
RET0



;---------------------------------------void setCoord(COORDINATE* where, int r, int c);----

setCoord: NOP0
;where->column=c+MIN_COL;
;where->row=r+MIN_ROW;
c: .equate -6 ;local variable #2d
r: .equate -4 ;local variable #2d
KEwhere: .equate -2 ;local structure #column #row
KEsetFRM: .equate 6 ;frame for CALLER

LDA MIN_COL,d
ADDA c,s
STA column,sxf

LDA MIN_ROW,d
ADDA r,s
STA row,sxf

RET0



; Evans Stuff ends


; Brutscher Stuff begins
;-------------------------------------------------------------------------------;
intPlShp: NOP0 ;void interactivePlaceShip(PLAYER *plr, char* shipName, int size)
Br iPlSpSt
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

;DETERMINE ARGUMENTS/(CALLER) NAMES
JBpsAsze: .equate -2 ;arg int size #2d
JBpsAspn: .equate -3 ;arg char *shipName #1c
JBpsAplr: .equate -5 ;arg PLAYER *plr #2h 

;FRAMES
JBpsifrm: .equate 44
JBpsXFRM: .equate 5

;STRINGS
JBpsSg1: .ASCII "Where is the front of your \x00"
JBpsSg2: .ASCII "? \n\x00"
JBpsSg3: .ASCII "Which direction is the rest of it? (n,e,w,s): \x00"

;{
;	COORDINATE target;
;	char direction;
;	bool placed=false;
iPlSpSt: NOP0
;
;	printGrid(plr->board);

JBipswhl: NOP0 ;call this for while loop
;	while(!placed)
;	{
		STRO JBpsSg1, d ;printf(''Where is the front of your 
                       STRO ???, sf               ;%s[...], shipName);
                       STRO JBpsSg2   ;? \n''
                       
		;inputCoord(&target);
		;printf("Which direction is the rest of it? (n,e,w,s):");
                 	;scanf(" %c", &direction);
		;placed = placeShip(size, &target, direction, plr);
;         }
BRNE iPlSpEnd ;check to see if the placed value has been set to NOT FALSE
BR JBipswhl

;}
iPlSpEnd:NOP0
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
           LDX view, i ;using up-to-date name on this
           LDA JBerPpl2, sf ;again this might be it and might not be it. I'm still following the translation example pretty closely
           ;LDA JBerPpl2, s
           STA DLpgAgrd, s ;waiting for Dauris to name grid arg of printgrid func.
           SUBSP DLpgXFRM, i ;Allocate placeholder amount #grid
           CALL printGrid ;up-to-date name that will need to be changed
           ADDSP DLpgXFRM ;Deallocate by placeholder amount #grid
           ;ENDPRINTGRID(PLR2->VIEW)
         

	STRO JBerSg1, d ;printf(''Player 1
	STRO JBerSg2, d ;: Enter target! '');
           

           ;inputCoord(&target)
           ;prepare target as an argument
           MOVSPA
           ADDA JBerAtrg, i
           STA JBicAtrg, s
           ;Allocate, call, and deallocate
           SUBSP JBicXFRM ;Allocate by amount #IMnotSURE
           CALL inpCoord ;call inputCoordinate    ;I'm assuming that this is where we ACTUALLY enter our target
           ADDSP JBicXFRM ;Deallocate by amount #IMnotSURE
           ;END INPUTCOORD (&target)
           
	;plr1hits = checkForHit(&target, plr2) ;Delocalized args are checkForHit(COORDINATE*where, PLAYER* whom);
            ;prepare arg (plr2)
            LDA JBerApl2, s
            STA CLcfhApl, s ;Store to placeholder name for PLAYER* whom arg in checkForHit
            ;DONE LOADING PLR2 ARG
            ;prepare arg (&target)
             MOVSPA
             ADDA JBerAtrg, i
             STA CLcfhAwh, s ;I think stack deferred is right here. It's either this or just plain ol' stack addressing. ;placeholder name for COORDINATE* where
            ;DONE PREPARING T(ARG)ument ;(I'm punny! Please no-one read this!)
             ;Allocate/Deallocate and Call
             SUBSP CLchXFRM, i ; allocate by placeholder amount #dunnoNameYet #DUNNOnAMEyET
             CALL checkHit ;Call to placeholder name
             ADDSP CLchXFRM, i ;Deallocate by placeholder amount #DUNNOnAMEyET #dunnoNameYet
             LDBYTEA checkHit, d 
             STBYTEA JBerVp1h, s ;store the returned value in bool player1hits
             ;if I'm loading and storing directly to a variable then do I really need to call checkHit anyway?
            ;END PLR1HITS = CHECKFORHIT(&TARGET, PLR2)
            
	;printGrid(plr1->view)
            LDX view, i ;load view into the index
            LDA JBerPpl1, sf
            STA grid, s ;store PLAYER* player1 to grid
            SUBSP DLpgXFRM, i ;Allocate placeholder amount #gridTBA
            CALL printGrid ;Call to printgrid (The name of this function will eventually have to change because it is too long, but for now this is the up-to-date name)
            ADDSP DLpgXFRM ;Deallocate by placeholder amount #gridTBA
            ;END PRINTGRID(plr1->view)

           STRO JBerSg3, d ; printf(''Player 2
           STRO JBerSg2, d;: Enter target! '');
	
           ;inputCoord(&target)
           MOVSPA
           ADDA JBerAtrg, i
           STA JBicAtrg, s
           ;Allocate, call, and deallocate
           SUBSP JBicXFRM ;Allocate by amount #IMnotSURE
           CALL inpCoord ;call inputCoordinate    ;I'm assuming that this is where we ACTUALLY enter our target
           ADDSP JBicXFRM ;Deallocate by amount #IMnotSURE
           ;END INPUTCOORD(&target)


	;plr2hits = checkForHit(&target, plr1);prepare arg (plr2)
            LDA JBerApl1, s
            STA CLcfhApl, s ;Store to placeholder name for PLAYER* whom arg in checkForHit
            ;DONE LOADING PLR2 ARG
            ;prepare arg (&target)
             MOVSPA
             ADDA JBerAtrg, i
             STA CLcfhAwh, s
            ;DONE PREPARING T(ARG)ument ;(I'm punny! Please no-one read this!)
             ;Allocate/Deallocate and Call
             SUBSP CLchXFRM, i ; allocate by placeholder amount #dunnoNameYet #DUNNOnAMEyET
             CALL checkHit ;Call to placeholder name
             ADDSP CLchXFRM, i ;Deallocate by placeholder amount #DUNNOnAMEyET #dunnoNameYet
             LDBYTEA checkHit, d
             STBYTEA JBerVp2h, s ;store the returned value to bool plr2hits
           ;END PLR2HITS =  CHECKFORHIT(&TARGET, PLR1)
;spider-senses tell me that these lines require more messing with the index. I might not be doing these right since I'm all in the accumulator
            

	 STRO JBerSg4, d ;printf(''\n\nSHELLS IN THE AIR!\n\n'');
	 STRO JBerSg1, d ;printf(''Player 1
            STRO JBerSg5, d ;... '');
            
            ;IF PLAYER 1 HITS
	JBerp1ht: NOP0;if(plr1hits)
            ;LOAD plr1hits from stack
             LDA JBerVp1h, s
            ;OKAY NOW FINISH YOUR IF LOOP



            CPA 1, i ; compare accumulator to true
            BRNE JBerp1ms ;if not true jump to else loop
	;{
	STRO JBerSg6, d ;printf(''hits!\n'');The Original line says printf(''Player 2...''), but I think this should be printf(''hits!'') ;printf(''Player 2... '');
		STRO JBerSg3, d ;printf("Player %d 
                       STRO JBerSg7, d      ;can take 
                       ;DECO something?      ;%d [...], plr2->hits);
                             
                       STRO JBerSg8, d                   ;more hits.\n", 2, plr2->hits);
            BR JBerp2ht ;branch to next if loop
           ;END IF PLAYER 1 HITS

           ;ELSE (PLAYER 1 MISSES)            		
	;} else {
            JBerp1ms: NOP0 ;initiate else loop
                      ;LDA ;**************************************SOMETHING OR OTHER **********************************************************
                      ;CPA 0, i ;error checking
                      ;BRNE JBerROR ;error checking
		STRO JBerSg9, d ;printf(''misses.\n'');
	;}
           ;END ELSE (PLAYER 1 MISSES)


          JBerp2ht: NOP0
	STRO JBerSg3, d ;printf("Player 2
           STRO JBerSg5, d  ;... ")
           ;LOAD VALUE OF PLAYER2HITS FROM STACK
           LDA JBerVp2h, s
           ;DONE LOADING PLAYER2HITS...DO CONTINUE...
           
           ;IF PLAYER 2 HITS
           ;if(plr2hits)
           CPA 1, i ;compare accumulator to true (1)
           BRNE JBerp2ms ;if not true jump to else condition
	;{
		STRO JBerSg6, d;printf(''hits!\n'');
                       STRO JBerSg1, d ;printf("Player %d 
                       STRO JBerSg7, d      ;can take 
                       ;DECO something?      ;%d[...], plr1->hits);
                             
                       STRO JBerSg8, d ;more hits.\n''
                       BR JBerEND ;jump to return
           ;FINISH IF PLAYER 2 HITS

           ;START ELSE (PLAYER 2 MISSES)		
	JBerp2ms: NOP0;} else {
           ;LDA ;**************************************SOMETHING OR OTHER **********************************************************
           ;CPA 0, i ;error checking
           ;BRNE JBerROR ;error checking
           STRO JBerSg9, d ;printf(''misses.\n'');
           BR JBerEND
           ;END ELSE (PLAYER 2 MISSES)


	;}
         ;JBerROR: NOP0
         ;STRO ''Houston we have a problem!\n\x00'' ;Error checking of my own doing. Poor form, but will be removed once I know that everything is working with this function.
         ;BR JBerEND
;}
JBerEND:NOP0
RET0



;-------------------------------------------------------------------------------;
inpCoord: NOP0 ;void inputCoord(COORDINATE* target)


JBicAtrg: .equate xx ;COORDINATE* target ;function argument

JBicifrm: .equate xx ;internal frame size for (variables)
JBicXFRM: .equate x ;external frame size for target

JBicSg1:  .ASCII "Target entered: \x00"

;{
;	scanf(" %c%d", &(target->column), &(target->row));
;	target->column = toupper(target->column);
;	printf("Target entered: "); printCoord(target); printf("\n");
;}
RET0

;-------------------------------------------------------------------------------;
cpyCoord: NOP0 ;void copyCoord(COORDINATE* original, COORDINATE* copy)

;NAME ARGS
JBccPorg: .equate xx ;local parameter; arg COORDINATE* original #2h
JBccPcpy: .equate xx ;local parameter; arg COORDINATE* copy #2h
;I have these arguments but I don't know what to do with them. Are they characters or integers
;Meh, maybe I'll just want to load them as hexxes?

;{
;	copy->column = original->column;
;	copy->row = original->row;
;}
RET0
;-------------------------------------------------------------------------------;

; Brutscher Stuff ends


;---------------LeBerth Stuff begins-------------
;******************************************************************
;***void movCoord(COORDINATE* where, int distance, char direction);***
  ;{
  ;	if(direction==DIR_NORTH) where->row -= distance;
  ;	if(direction==DIR_SOUTH) where->row += distance;
  ;	if(direction==DIR_WEST) where->column -= distance;
  ;	if(direction==DIR_EAST) where->column += distance;
  ;}
;Doesn't this function just alter stuff that already exists?? Do I make up variables anyway??
prompt: .ASCII "Where would you like place the tail of the ship?"
oops: .ASCII "Can't be placed there..."
;///Adresses for Caller///
CLmcAwhr: .Equate -6 ;formal argument #DLcolumn #DLrow
CLmcAdis: .Equate -3 ;formal argument #2d
CLmcAdre: .Equate -1 ;formal argument #1c
ClmcClrF: .Equate 6 ;size of #CLmcAdre #CLmcAdis #CLmcAwhr
;///Local variables and addresses for function as callee///
CLmcAdis: .Equate 0 ;local variable #2d
CLmcAdre: .Equate 2 ;local variable #1d
CLmcCleF: .Equate 3 ;size of #CLmcAdre #CLmcAdis
CLmcPwhr: .Equate 5 ;formal perameters #DLcolumn #DLrow
ClmcPdis: .Equate 8 ;formal perameterse #2d
CLmcdre: .Equate 10 ;formal perameters #1c

CLmvCord: NOP0
SUBSP CLmcCleF,i ;allocating #CLmcAdre #CLmcAdis
LDA 1,i
STA CLmcAdis,s
STRO prompt,i
CHARO CLmcAdre,s
LDA CLmcAdre,s ;if drection..
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
LDX DLrow,i
STX CLmcAwhr,sxf
LDA CLmcAwhr,sxf
SUBA CLmcAdis,s
STA CLmcAwhr,sxf
LDX CLmcAwhr,sxf
STX DLrow,i
BR placed

south: NOP0 ;where->row += distance
LDX DLrow,i
STX CLmcAwhr,sxf
LDA CLmcAwhr,sxf
ADDA CLmcAdist,s
STA CLmcAwhr,sxf
LDX CLmcAwhr,sxf
STX DLrow,i
BR placed

east: NOP0 ;where->column += distance
LDX DLcolumn,i
STX CLmcAwhr,sxf
LDA CLmcAwhr,sxf
ADDA CLmcAdis,s
STA CLmcAwhr,sxf
LDX CLmcAwhr,sxf
STX DLcolumn,i
BR placed

west: NOP0 ;where->column -= distance
LDX DLcolumn,i
STX CLmcAwhr,sxf
LDA CLmcAwhr,sxf
SUBA CLmcAdis,s
STA CLmcAwhr,sxf
LDX CLmcAwhr,sxf
STX DLcolumn,i
BR placed

none: NOP0
BR placed

retry: NOP0
STRO oops,i
BR CLmvCord

placed: NOP0
ADDSP CLmcCleF,i ;deallocating #CLmcAdis #CLmcAdre
RET0
;*****************************************************************
;*****************************************************************
;***char getSpace(COORDINATE* where, char grid[8][8]);***
  ;{
  ;	if(!validSpace(where)) return GRID_BAD;
  ;	int colIndex = where->column - MIN_COL;
  ;	int rowIndex = where->row - MIN_ROW;
  ;	return grid[colIndex][rowIndex];
  ;}
;///Adresses for Caller///
CLgsAwhr: .Equate -66 ;formal argument #2d
CLgsAgrd: .Equate -64 ;Formal argument #1c64a
CLgsClrF: .Equate 66 ;size of #CLgsAgrd #CLgsAwhr
;///Local variables and addresses for function as callee///
CLgsVclI: .Equate 0 ;local variable #2d
CLgsVrwI: .Equate 2 ;local variable #2d
CLgsCleF: .Equate 4 ;size of stack of #grid #where
CLgsPwhr: .Equate 6 ;formal perameter #column #row
CLgsPgrd: .Equate 9 ;formal perameter #1c64

CLgtSpac: NOP0
SUBSP CLgsCleF,i ;allocating #CLgsVrwI #CLgsVclI
;if(!validSpace(where)) return GRID_BAD;??
LDX DLcolumn,i
STX CLgsPwhr,sxf
LDA CLgsPwhr,sxf
SUBA MIN_COL,i
STBYTEA CLgsPgrd,sx ;should be first variable in grid?? And should Store BYTE!   ;int colIndex = where->column - MIN_COL;
LDX DLrow,i
STX CLgsPwhr,sxf
LDA CLgsPwhr,sxf
SUBA MIN_ROW ;row is an integer.... column is a character..... ??!!
LDX 3,i ;Maybe useful in shifting from grid[colIndex] to grid[rowIndex]??
STBYTEA CLgsPgrd,sx ;Should store byte!! STBYTE?  ;int rowIndex = where->row - MIN_ROW;
LDA CLgsPgrd,s ;return grid[colIndex][rowIndex];
ADDSP CLgsCleF,i ;deallocating #CLgsVclI #CLgsVrwI
RET0
;****************************************************************
;****************************************************************
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
;///Adresses for Caller///
CLpsAsiz: .Equate -8 ;formal arguement #2d
CLpsAdre: .Equate -6;formal arguement #1c
CLpsAwhr: .Equate -5 ;formal arguement #2h
CLpsAwho: .Equate -3 ;formal arguement #2h
CLspORtV: .Equate -1 ;formal return value #1d
CLpsClrF: .Equate 8 ;size of #CLpsAsiz #CLpsAdre #CLpsAwhr #CLpsAwho #CLspORtV
;///Local variables and addresses for function as callee///
CLpsVdis: .Equate 0 ;local variable #2d
CLpsVtar: .Equate 2 ;local variable #DLcolumn #DLrow
CLpsCleF: .Equate 5 ;size of stack of #CLpstarg #CLpsdist
CLpsPsiz: .Equate 7 ;formal perameter #2d
CLpsPdre: .Equate 9 ;formal perameter #1c
CLpsPwhr: .Equate 10 ;formal perameter #2h
CLpsPwho: .Equate 12 ;formal perameter #2h
CLpsRetV: .Equate 14 ;formal return value #1d

CLplcShp: NOP0
SUBSP CLpsCleF,i ;allocating #CLpsVtar #CLpsVdis
SUBSP ;Whatever the Frame for copyCoord it...
CALL ;Name of CopyCoord...
ADDSP ;Whatever the Frame for copyCoord it...
LDA 0,i
STA CLpsVdis,s ;distance = 0
BR while

while: NOP0
LDA CLpsVdis,s
CPA CLpsPsiz,s
BRLT if
BR out

if: NOP0
;if(getSpace(&target, whom->board) != BOARD_WATER)
;{
;        
;}
SUBSP CLgsClrF,i ;allocating #CLgsAgrd #CLgsAwhr
CALL CLgtSpac
ADDSP CLgsClrF,i ;deallocating #CLgsAwhr #CLgsAgrd
LDA CLgsVclI,d
STA CLpsPtar,sx ;&target to column
LDA CLgsVrwI,d
LDX 3,i
STA CLpsAtar,sx ;&target to row
;not sure about the whom->board thing...
LDA CLpsAtar,s
CPA BRD_WTR
BRNE error
BR mvCor

error: NOP0
;Must call error function.... Need SUBSP and ADDSP ...??
;return error("Could not place ship there\n")

mvCor: NOP0
SUBSP ClmcClrF,i ;allocating #CLmcAdre #CLmcAdis #CLmcAwhr
CALL CLmvCord ;moveCoord(&target, 1, direction)
ADDSP ClmcClrF,i ;allocating #CLmcAwhr #CLmcAdis #CLmcAdre
LDA CLpsVdis,s
ADDA 1,d
LDA CLpsVdis,s ;dist++
BR while

out: NOP0
LDA CLpsPsiz,s
ADDA 1,i
STA CLpsPsiz,s ;whom->hits += size; ?Add 1 to size??
LDA 0,i
STA CLpsVdis,s ;for(dist=0,
SUBSP ;frame for CopyCoord
CALL ;Name of CopyCoord (;copyCoord(where, &target);??)
ADDSP ;frame for CopyCoord
LDA CLpsVdis,s
CPA CLpsPsiz,s ;dist<size;
BRLT setship ;dist++, moveCoord(&target, 1, direction))

setship: NOP0
SUBSP ;frame of setShip function
CALL ;name of setShip Function ;setShip(&target, whom);
ADDSP ;frame of setShip function
BR end

end: NOP0
LDBYTEA 1,i
STBYTEA CLpsRetV ;return true; //Success!
ADDSP CLpsCleF,i ;deallocating #CLpsVdis #CLpsVtar
RET0
;****************************************************************
;****************************************************************
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
;///Adresses for Caller///
CLplApr1: .Equate -12 ;formal argument #DLhit #DLgrid #DLboard
CLplApr2: .Equate -6 ;formal argument #DLhit #DLgrid #DLboard
CLplCleF: .Equate 12 ;size of stack of #CLplApr2 #CLplApr1
;///Local variables and addresses for function as callee///
CLplEnGm: .Equate 0 ;local variable #2d
CLplClrF: .Equate 2 ;size of stack of #endGame
CLplPpr1: .Equate 4 ;formal perameter #DLhit #DLgrid #DLboard
CLplPpr2: .Equate 9 ;formal perameter #DLhit #DLgrid #DLboard

CLplylop: NOP0
SUBSP CLplClrF,i ;allocating #CLplEnGm
LDA GAME_NOT_OVER,d
STA CLplEnGm,s

start: NOP0
LDA CLplEnGm,s
CPA GAME_NOT_OVER,d
BRNE end
BR play

play: NOP0
SUBSP CLplCleF,i ;allocating #CLplPpr2 #CLplPpr1
CALL extRound ;Needs to change (name)??
ADDSP CLplCleF,i ;deallocating #CLplPpr1 #CLplPpr2
BR start

end: NOP0
ADDSP CLplClrF,i ;deallocating #CLplEnGm
RET0
;****************************************************************
;****************************************************************
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
;///Adresses for Caller///
CLchAwhr: .Equate -10 ;formal argument #DLcolumn #DLrow
CLchAwho: .Equate -7 ;formal argument #DLhit #DLgrid #DLboard
CLchORtV: .Equate -1 ;formal argument #1d
CLchClrF: .Equate 10 ;size of #CLchORtV #CLchAwho #CLchAwhr
;///Local variables and addresses for function as callee///
CLchVact: .Equate 0 ;local variable #1c
CLchCleF: .Equate 1 ;size of #CLchVact
CLchPwhr: .Equate 3 ;formal perameter #DLcolumn #DLrow
CLchPply: .Equate 6 ;formal perameter #DLhit #DLgrid #DLboard
CLchRetV: .Equate 12 ;formal return value

CLCk4Hit: NOP0
SUBSP CLchCleF,i ;allocating #CLchVact
SUBSP CLgsClrF ;allocating #CLgsAgrd #CLgsAwhr
CALL ClgetSpac
ADDSP CLgsClrF ;deallocating #CLgsAwhr #CLgsAgrd
LDA CLgsAwhr
STA CLchVact,s ;char actual = getSpace(where, whom->board);

check: NOP0
LDA CLchVact,s
CPA BRD_SHIP,i
BREQ set ;if(actual == BOARD_SHIP) {
BR water

set: NOP0
  ;	setSpace(where, whom->board, GRID_HIT); Call SetSpace??
  ;	setSpace(where, whom->view, GRID_HIT);  Or just use its addresses for its variables??
  ;	whom->hits --;
LDBYTEA 1,i
STBYTEA CLchRetV ;return true;
BR end

water: NOP0
LDA CLchVact,s
CPA BRD_WTR
BRNE else ;} else if(actual == BOARD_WATER) {
SUBSP ;frame for setSpace
  ;setSpace(where, whom->board, GRID_SPLOOSH); Call SetSpace??
CALL ;name for SetSpace
  ;setSpace(where, whom->view, GRID_SPLOOSH);  Or just use its addresses for its variables??
ADDSP ;frame for setSpace
LDA 0,i
STBYTEA CLchRetV  ;	return false;
BR end

else: NOP0 ;} else {
SUBSP ;frame for setSpace
  ;setSpace(where, whom->board, GRID_BAD); Call SetSpace??
CALL ;name for SetSpace
  ;setSpace(where, whom->view, GRID_BAD);  Or just use its addresses for its variables??
ADDSP ;frame for setSpace
LDBYTEA 0,i
STBYTEA CLchRetV  ;	return false;
BR end

end: NOP0
ADDSP CLchCleF,i ;deallocating #CLchVact
RET0
;***************************************************************
;--------------LeBerth Stuff ends-----------------


; Little Stuff begins``````````````````````````````````````````````````````````````````````````````````````````````66  

;typedef struct Coordinate
column:   .equate 0   ;struct field #1c
row:      .equate 1   ;struct field #2d
coordin:  .equate 3    ;global variable #column #row

;typedef struct Playes
board:    .equate 4   ;struct field #1c
view:     .equate 2   ;struct field #1c
hits:     .equate 0   ;struct field #2d
player:   .equate 5    ;gloabl variable #board #view #hits

;void printCoord
where:    .equate 0   ;local variable #2h
prinCoor: .equate 2   ;size of frame #where

;void printGrid
grid:     .equate 0   ;local array variable #1c2a
prinGrid: .equate 1   ;size of frame #grid
;void setSpace
where:    .equate 0   ;local variable #2h
grid:     .equate 2   ;local array #1c2a
symbol:   .equate 3   ;local variable #1c
space: .equate 6   ;size of frame  #where #grid #symbol


main:nop0
call runGame
ret0


setSpace: nop0
subsp space,i ;allocating #symbol #grid #where
ldx column,i
stx where, sxf
suba MIN_COL,i
sta grid,sx
ldx row,i
stx where,sxf
lda where,sxf
suba MIN_ROW,i
ldx 
sta grid,sx
addsp space,i ;deallocating #where #grid #symbol

PinGrid: nop0
coordin: .equate 0  ;local variable #2h
symbol:  .equate 1  ;local variable #1c
r:       .block 0   ;local variable #2d
c:       .block 2   ;local variable #2d

for: cpx 8,i
for2: cpx 8,i
lda r,i 
cpa c,i
brlt   

; Little Stuff ends
; More Adams Stuff Begins


.END
; More Adams Stuff Ends
