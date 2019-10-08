
option limrow=100, limcol=0;

set grades /defective, grade1, grade2, grade3, grade4/;

parameter method1(grades) /defective .3, grade1 .3, grade2 .2, grade3 .15, grade4 .5 /;
parameter method2(grades) /defective .2, grade1 .2, grade2 .25, grade3 .2, grade4 .15 /;
parameter refD(grades) /defective .3, grade1 .25, grade2 .15, grade3 .2, grade4 .1 /;
parameter ref1(grades) /defective 0, grade1 .3, grade2 .3, grade3 .2, grade4 .2 /;
parameter ref2(grades) /defective 0, grade1 0, grade2 .4, grade3 .3, grade4 .3 /;
parameter ref3(grades) /defective 0, grade1 0, grade2 0, grade3 .5, grade4 .5 /;
parameter demand(grades) /defective 0, grade1 3000, grade2 3000, grade3 2000, grade4 1000 /;


integer variables
    method1Ts
    method2Ts

positive variables
    amount(grades)
    amount1(grades)
    amount2(grades)
    amountRD(grades)
    amountR1(grades)
    amountR2(grades)
    amountR3(grades)
    refireCount
    refireCount1
    refireCount2
    cost;
    

equations
    totalTs
    costEQ
    refire
    total
    demand1
    demand2
    demand3
    demand4;
    
totalTs..
    sum(grades, method1(grades)*amount1(grades)) + sum(grades, method2(grades)*amount2(grades)) =l= 20000 - refireCount;
    

refire..
    sum(grades, refD(grades)*amountRD(grades)) + sum(grades, ref1(grades)*amountR1(grades))
            + sum(grades, ref2(grades)*amountR2(grades)) + sum(grades, ref3(grades)*amountR3(grades))
                =e= refireCount;

demand1..
    amount1("grade1") + amount2("grade1") + amountRD("grade1") + amountR1("grade1") + amountR2("grade1")
        + amountR3("grade1") =e= demand("grade1");
        
demand2..
    amount1("grade2") + amount2("grade2") + amountRD("grade2") + amountR1("grade2") + amountR2("grade2")
        + amountR3("grade2") =e= demand("grade2");
        
demand3..
    amount1("grade3") + amount2("grade3") + amountRD("grade3") + amountR1("grade3") + amountR2("grade3")
        + amountR3("grade3") =e= demand("grade3");
        
demand4..
    amount1("grade4") + amount2("grade4") + amountRD("grade4") + amountR1("grade4") + amountR2("grade4")
        + amountR3("grade4") =e= demand("grade4");
        
model silvco /all/;

solve silvco using lp minimizing cost;
        



    


    
    


