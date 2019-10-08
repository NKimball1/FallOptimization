option limrow=100, limcol=0;

set months /month1, month2/;

parameter waterInflowA /month1 200, month2 130/;
parameter waterInflowB /month1 130, month2 15/;
parameter startingA(months) 'starting water level' /month1 1900/;
parameter startingB(months) 'starting water level' /month1 850/;

scalar capacityA maximum water dam A can store /2000/
    capacityB maximum water dam B can store /1500/
    minimumA minimum water dam A can store /1200/
    minimumB minimum water dam B can store /800/
    profitRegular profit per kwh under 50k sold /5/
    profitOver profit per kwh over 50k sold /3.50/
    powerProfitCutoff limit for rate to sell power at /50000/
    wpAConversion power produced per KAF in A /400/
    wpBConversion power produced per KAF in  B /200/
    powerACapacity capacity of power plant A /60000/
    powerBCapacity capacity of power plant B /35000/;
    
variables
    levelA(months) level of water in dam A passed to next month 
    levelB(months) level of water in dam B passed to next month
    APower(months) power produced from dam A
    BPower(months) power produced from damn B
    totalPower total power
    profit total profit;
    
*capacity constraints
levelA.lo(months) = minimumA;
levelA.up(months) = capacityA;
APower.up(months) = powerACapacity;

levelB.lo(months) = minimumB;
levelB.up(months) = capacityB;
BPower.up(months) = powerBCapacity;

equations
    powerA(months) power produced at dam A month nodes
    powerB(months) power produced at dam B month nodes
    profitEQ
    objective;
    
powerA(months)..
    APower(months) =e= (startingA(months)
        + levelA(months-1) - levelA(months) + waterInflowA(months))*wpAConversion;
        
powerB(months)..
    BPower(months) =e= (startingB(months)
        + levelB(months-1) - levelB(months) + waterInflowB(months))*wpBConversion;
        
objective..
    totalPower =e= sum(months, APower(months)) + sum(months, BPower(months));
    
profitEQ..
    profit =e= ((totalPower - 100000)*profitOver) + (100000 * profitRegular);
        
model hydro /all/;

solve hydro using lp max totalPower;



display totalPower.l, levelA.l, levelB.l, profit.l;


        
        



    

    

    

    