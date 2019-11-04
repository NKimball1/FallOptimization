$title Homework 6 Dragon UW-Madison CS524- Optimization

option limcol=0;

set l "Legs of route" /2*5/;
set tt "Types of transport" /Train, Portkey, Thestral/;
scalar d "20 dragons to be transported" /20/;


option optcr=0;

table tc(tt, l) "Transport cost between cities. You start in Romania"
                2   3   4   5
Train           30  25  40  60
Portkey         25  40  45  50
Thestral        40  20  50  45
;

table cc(tt, tt) "Cost to change mode of transport"
            Train   Portkey   Thestral
Train       0       5         12
Portkey     8       0         10
Thestral    15      10        0
;

free variable totalCost
    changeCost
;
binary variables tB(l) "1 if train used for leg"
    pB(l) "1 if Portkey used for leg"
    thB(l) "1 if Thestral used for leg"
    
    sTfromP(l) "If 1, charge for switch from portkey to Train"
    sTfromTH(l) "If 1, charge for switch from Thestral to Train"
    sPfromT(l) "If 1, charge for switch from train to Portkey"
    sPfromTH(l) "If 1, charge for switch from Thestral to Portkey"
    sTHfromT(l) "If 1, charge for switch from train to Thestral"
    sTHfromP(l) "If 1, charge for switch from Portkey to Thestral"
;

equations
    obj Minimize cost to transport 20 dragons
    transportBinaryConstraint Must use a type of transportation for each leg
    changeCostEq
    lbp1
    lbp2
    lbp3
    lbp4
    lbp5
    lbp6
    lbp7
    lbp8
    lbp9
    lbp10
    lbp11
    lbp12
    lbp13
    lbp14
    lbp15
    lbp16
    lbp17
    lbp18
   
   
*    linearizeBinaryProduct1
*    linearizeBinaryProduct2
*    linearizeBinaryProduct3
*    linearizeBinaryProduct4
*    linearizeBinaryProduct5
*    linearizeBinaryProduct6
;

lbp1(l)..
    sTfromTH(l + 1) =l= thB(l);
    
lbp2(l)..
    sTfromTH(l) =l= tB(l);
    
lbp3(l)..
    sTfromTH(l + 1) =g= thB(l) + tB(l + 1) - 1;
    

lbp4(l)..
    sTfromP(l + 1) =l= pB(l);
    
lbp5(l)..
    sTfromP(l) =l= tB(l);
    
lbp6(l)..
    sTfromP(l + 1) =g= pB(l) + tB(l + 1) - 1;
    

lbp7(l)..
    sPfromT(l + 1) =l= tB(l);
    
lbp8(l)..
    sPfromT(l) =l= pB(l);
    
lbp9(l)..
    sPfromT(l + 1) =g= tB(l) + pB(l + 1) - 1;
    
lbp10(l)..
    sPfromTH(l + 1) =l= thB(l);
    
lbp11(l)..
    sPfromTH(l) =l= pB(l);
    
lbp12(l)..
    sPfromTH(l + 1) =g= thB(l) + pB(l + 1) - 1;
    
lbp13(l)..
    sTHfromP(l + 1) =l= pB(l);
    
lbp14(l)..
    sTHfromP(l) =l= thB(l);
    
lbp15(l)..
    sTHfromP(l + 1) =g= pB(l) + thB(l + 1) - 1;
    
lbp16(l)..
    sTHfromT(l + 1) =l= tB(l);
    
lbp17(l)..
    sTHfromT(l) =l= thB(l);
    
lbp18(l)..
    sTHfromT(l + 1) =g= tB(l) + thB(l + 1) - 1;


obj..
    totalCost =e= sum(l, (tB(l)*tc("Train",l) + pB(l)*tc("Portkey",l) + thB(l)*tc("Thestral",l))*d) + changeCost;
    
transportBinaryConstraint(l)..
    tB(l) + pB(l) + thB(l) =e= 1;
    
changeCostEq..
    sum(l, d*(sTfromP(l)*cc("Portkey", "Train") + sTfromTH(l)*cc("Thestral", "Train") + sPfromT(l)*cc("Train", "Portkey")
                + sPfromTH(l)*cc("Thestral", "Portkey") + sTHfromT(l)*cc("Train", "Thestral") + sTHfromP(l)*cc("Portkey","Thestral"))) =e= changeCost;
    
$ontext
Assign cost of switching transport IF AND ONLY IF leg i assigned to transport type a and leg i + 2 assigned different transport type b
In other words, in the example of a switch from train in leg i to Portkey in leg i+1,
tB(i) AND pB(i+1) need to IMPLY sPfromT(i+1) = 1

Linearize product of 2 binarys
sPfromT(i+1) <= tB(i)
sPfromT(i+1) <= pB(i+1)
sPfromT(i+1) >= tB(i) + pB(i+1) - 1

Easier way to do it in a single constraint from slide of tricks
tB(i) + pB(i+1) + 2sPfromT(i+1) >= 0

$offtext

$ontext
linearizeBinaryProduct1(l)..
    pB(l) + tB(l + 1) - 2*sTfromP(l + 1) =g= 0;

linearizeBinaryProduct2(l)..
    thB(l) + tB(l + 1) - 2*sTfromTH(l + 1) =g= 0;
    
linearizeBinaryProduct3(l)..
    tB(l) + pB(l + 1) - 2*sPfromT(l + 1) =g= 0;
    
linearizeBinaryProduct4(l)..
    thB(l) + pB(l + 1) - 2*sPfromTH(l + 1) =g= 0;

linearizeBinaryProduct5(l)..
    tB(l) + thB(l + 1) - 2*sTHfromT(l + 1) =g= 0;
    
linearizeBinaryProduct6(l)..
    pB(l) + thB(l + 1) - 2*sTHfromP(l + 1) =g= 0;
    
$offtext 

model dragon /all/;

dragon.optca = 0.999;

solve dragon using mip minimizing totalCost;


display tB.l, pB.l, thB.l, sTfromP.l, sTfromTH.l, sPfromT.l, sPfromTH.l, sTHfromT.l, sTHfromP.l ;