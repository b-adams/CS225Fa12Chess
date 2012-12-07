; Adams Stuff begins
CALL main
STOP
; Adams Stuff ends


; Steere Stuff begins

; Steere Stuff end


; Evans Stuff begins

; Evans Stuff ends


; Brutscher Stuff begins
intPlShp: NOP0 ;void interactivePlaceShip(PLAYER *plr, char* shipName, int size)
direc: .BLOCK 1
placed: .EQUATE 0
;{
         ;COORDINATE target
         LDA target, d ; (check addressing mode
         STA COORDINATE, x; (check addressing mode)
         ;char direction
                             
         ;bool placed = false;
                             
         
         ;printGrid(plr->board);
         LDA plr, 
         CALL printGrid, 





RET0


extRound: NOP0 ;void executeRound(PLAYER* plr1, PLAYER* plr2)

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