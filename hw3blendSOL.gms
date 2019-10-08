option limrow=100, limcol=0;

set crude /crude1, crude2, crude3/;
set gas /gas1, gas2, gas3/;


scalar totalLimit maxium barrels producible a day /14000/
    barrelLimit max barrels of each type you can buy a day /5000/;
    
parameter octane(crude) /crude1 12, crude2 6, crude3 8/;
parameter priceCrude(crude) /crude1 45, crude2 35, crude3 25/;
parameter priceGas(gas) /gas1 70, gas2 60, gas3 50/;
parameter sulfur(crude) /crude1 0.5, crude2 2, crude3 3/;
parameter demand(gas) /gas1 3000, gas2 2000, gas3 1000/;

free variables
    cost
    revenue
    profit;
    
positive variables
    x(crude) number of each barrels to buy
    z(gas) number of gas types to produce
    g1(crude)
    g2(crude)
    g3(crude);
    
*Constraints
    z.lo("gas1") = demand("gas1");
    z.lo("gas2") = demand("gas2");
    z.lo("gas3") = demand("gas3");
    
    x.up("crude1") = barrelLimit;
    x.up("crude2") = barrelLimit;
    x.up("crude3") = barrelLimit;
    
equations
    costEQ
    revenueEQ
    totalLimitEQ
    objective
    linear_limit_gas1Octane
    linear_limit_gas1Sulfur
    linear_limit_gas2Octane
    linear_limit_gas2Sulfur
    linear_limit_gas3Octane
    linear_limit_gas3Sulfur
    crude1BL
    crude2BL
    crude3BL
    sumCrude1;
    
crude1BL..
    g1("crude1") + g2("crude1") + g3("crude1") =l= barrelLimit;
    
crude2BL..
    g1("crude2") + g2("crude2") + g3("crude2") =l= barrelLimit;
    
crude3BL..
    g1("crude3") + g2("crude3") + g3("crude3") =l= barrelLimit;
    
linear_limit_gas1Sulfur..
    sum(crude, g1(crude)*sulfur(crude)) =l= z("gas1");
    
linear_limit_gas1Octane..
    sum(crude, g1(crude)*octane(crude)) =g= 10*z("gas1");
    
linear_limit_gas2Sulfur..
    sum(crude, g2(crude)*sulfur(crude)) =l= 2*z("gas2");
    
linear_limit_gas2Octane..
    sum(crude, g2(crude)*octane(crude)) =g= 8*z("gas2");
    
linear_limit_gas3Sulfur..
    sum(crude, g3(crude)*sulfur(crude)) =l= z("gas3");
    
linear_limit_gas3Octane..
    sum(crude, g3(crude)*octane(crude)) =g= 6*z("gas3");
    
totalLimitEQ..
    sum(gas, z(gas)) =l= 14000;
    
costEQ..
    cost =e= sum(crude, x(crude)*priceCrude(crude)) + 4*sum(gas, z(gas));
    
revenueEQ..
    revenue =e= sum(gas, priceGas(gas)*z(gas));
    
objective..
    profit =e= revenue - cost;
    
model blending /all/;

solve blending using lp maximizing profit;

display profit.l, revenue.l, cost.l, g1.l, g2.l, g3.l;
    


    
    