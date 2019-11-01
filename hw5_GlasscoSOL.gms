
set glass types of glasses /Wine, Beer, Chmpgne, Whiskey/;
set yVal /1*3/

free variable revenue, dual;

positive variables
    x(glass)
    y1, y2, y3
;

parameters
    mold(glass) "Time(minutes) it takes to mold glass" /Wine 4, Beer 9, Chmpgne 7, Whiskey 10/
    pack(glass) "Time(minutes) it takes to pack glass" /Wine 1, Beer 1, Chmpgne 3, Whiskey 40/
    weight(glass) "Weight(oz) of the glass type" /Wine 3, Beer 4, Chmpgne 2, Whiskey 1/
    price(glass) "Selling price (Dollars) of the glass type" /Wine 6, Beer 10, Chmpgne 9, Whiskey 20/
;

scalar moldTime time glassco has for packaging /600/
    packTime time glassco has for molding /400/
    weightAv weight of glass avaialable /500/
;


equations
    objective maxamize revenue
    moldTimeConstraint
    packTimeConstraint
    weightConstraint
    dualObj dual variables to minimize
    dualCons constraint for dual model
    dualCons1
    dualCons2
    dualCons3
    dualCons4
;

dualCons1..
    y1*mold("Wine") + y2*pack("Wine") + y3*weight("Wine") =g= price("Wine");
    
dualCons2..
    y1*mold("Beer") + y2*pack("Beer") + y3*weight("Beer") =g= price("Beer");
    
dualCons3..
    y1*mold("Chmpgne") + y2*pack("Chmpgne") + y3*weight("Chmpgne") =g= price("Chmpgne");
    
dualCons4..
    y1*mold("Whiskey") + y2*pack("Whiskey") + y3*weight("Whiskey") =g= price("Whiskey");


dualObj..
    600*y1 + 400*y2 + 500*y3 =e= dual;
    
    
objective..
    sum(glass, x(glass) * price(glass)) =e= revenue;
    
moldTimeConstraint..
    sum(glass, x(glass) * mold(glass)) =l= moldTime;
    
packTimeConstraint..
     sum(glass, x(glass) * pack(glass)) =l= packTime;
     
weightConstraint..
    sum(glass, x(glass) * weight(glass)) =l= weightAv;
    
model primal /objective, moldTimeConstraint, packTimeConstraint, weightConstraint/;

model dualModel /dualCons1, dualCons2, dualCons3, dualCons4, dualObj/;

solve primal using lp maximizing revenue;

solve dualModel using lp minmizing dual;

display x.l;
     