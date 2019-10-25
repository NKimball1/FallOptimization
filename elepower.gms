option limrow=100, limcol=0;

set nodes /1*7/;

alias(nodes, i);
alias(nodes, j);

set arcs(i, j) arcs from node i to node j
    /1 .2
     2 .1
     2 .3
     2 .7
     3 .2
     3 .4
     3 .5
     4 .3
     4 .5
     5 .3
     5 .4 
     6 .7
     7 .2
     7 .6  /;
     

free variable cost;

positive variables
    x(i, j) electrcity flowing along arc from i to j
    powerCost
;

variables
     constraints(i)
;

*No power generated/consumed
constraints.fx("3") = 0;

*Power consumed at nodes
constraints.fx("2") = -35000;
constraints.fx("5") = -50000;
constraints.fx("6") = -60000;

*Power capacity to be generated
constraints.up("1") = 100000;
constraints.up("4") = 20000;
constraints.up("7") = 80000;

equations
    objective cost to minimize
    cons
    powerC
;

cons(i)..
    sum(arcs(i,j), x(i, j)) - sum(arcs(j,i), x(j,i)) =e= constraints(i);

objective..
     powerCost / 1000 + (sum(arcs(i,j), x(i,j))*11) / 1000 =e= cost;
     
powerC..
    (sum(arcs(i,j), x("1",j))*15  + sum(arcs(i,j), x("4",j))*13.5 + sum(arcs(i,j), x("7",j))*21) =e= powerCost;
    

model elepower /all/;

solve elepower using lp minimizing cost;

