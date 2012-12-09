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


; LeBerth Stuff begins

; LeBerth Stuff ends


; Little Stuff begins``````````````````````````````````````````````````````````````````````````````````````````````66  

;typedef struct Coordinate
column:   .equate 0   ;struct field #1c
row:      .equate 1   ;struct field #2d
coordin:  .block 3    ;global variable #column #row

;typedef struct Playes
board:    .equate 4   ;struct field #1c
view:     .equate 2   ;struct field #1c
hits:     .equate 0   ;struct field #2d
player:   .block 5    ;gloabl variable #board #view #hits

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

; Little Stuff ends

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
.END