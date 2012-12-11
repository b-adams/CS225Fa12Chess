br main 

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