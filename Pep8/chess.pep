; Adams Stuff begins
CALL main
STOP
; Adams Stuff ends


; Steere Stuff begins

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

; Brutscher Stuff ends


; LeBerth Stuff begins

; LeBerth Stuff ends


; Little Stuff begins

; Little Stuff ends

.END