$title hw7_threelights CS524 Optimization - UW Madison



set cell form 5x5 cell set from cell set /1*5/;
alias(cell, i, j);

free variable numberTurns Number of turns to turn out all of the lights (Minimize);

parameter g(i, j);
g(i, j) = 1;

integer variable grid(i, j) "Grid representing light state.";

binary variables
    clicks(i, j) "1 if cell was switched"
;

equations
    obj "Minimize total turns to turn off all the lights"
    balance "equation to balance the grid/clicks, If a cell has been clicked, constraints on up/down/left/right"
;

obj..
    sum((i,j), clicks(i,j)) =e= numberTurns;
    
$ontext
To balance the grid/minimize turns-
For EACH CELL- If cell clicked, cell and neighbors status turned off/on. This implies
that if cell (i,j) isn't clicked, its clicked neighbors should sum to an ODD amount.
If cell (i,j) IS clicked, it's neighbors should sum to an even amount. 

The balance equation expresses this by adding 1 to the LHS and setting the RHS to ALWAYS be even(multiple of 2)
implying that if cell clicked and has neighbors, this amount of neighbors must be even
(Constrained by the fact that if clicked, the + 1 makes the equality even,
so any sum of the neighbors must also be even)
and that if the cell is not clicked, the sum of the neighbors must be odd
(Constrained by the fact the sum of the cell's neighbors must be odd + 1 to satisfy
total even constraint imposed by RHS). 
$offtext
balance(i, j)..
    clicks(i, j) + 1 + clicks(i + 1, j) + clicks(i - 1, j) + clicks(i, j + 1) + clicks(i, j - 1)
        =e= 2*grid(i, j);
    
    
model threelights_p1 /obj, balance/;

*Ensure global optimum is found
option optcr=0;

solve threelights_p1 using mip minmizing numberTurns;

display numberTurns.l, clicks.l;

$ontext
Now the same problem but bulbs may be in 3 states, 0-off 1-low 2-med 3- high
Logic be be similar but now need to account states 0-3 instead of just 0-1
$offtext

integer variable numClicks(i, j) "New variable to store clicks as now cells may be clicked more than once";

scalar startingState "Indicate which level the bulbs start at";

equations
    obj3way "Sum over numClicks instead of binary clicks"
    balance3way
;

$ontext
The new stipulation that bulbs may be set to 0-3 implies now that each
cell's clicks + the clicks of it's neighbors + it's starting state
must be a multiple of 4 to constrain the cell's ending state to be OFF.
$offtext
obj3way..
    sum((i, j), numClicks(i, j)) =e= numberTurns;

balance3way(i, j)..
    numClicks(i, j) + startingState + numClicks(i + 1, j) + numClicks(i - 1, j) +
        numClicks(i, j + 1) + numClicks(i, j - 1) =e= 4*grid(i, j);

startingState = 1;
model state1 /obj3way, balance3way/;
solve state1 using mip minimizing numberTurns;

startingState = 2;
model state2 /obj3way, balance3way/;
solve state2 using mip minimizing numberTurns;

startingState = 3;
model state3 /obj3way, balance3way/;
solve state3 using mip minimizing numberTurns;



































