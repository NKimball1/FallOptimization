
*This model will find the lowest cost between every node to all others
*Set
*   i      'cities' / boston, chicago, dallas, kansas-cty, losangeles,
*                   memphis, portland, salt-lake, wash-dc            
*  r(i,i) 'routes';'
   
*parameter neededPersonnel(months) /feb 3, mar 4, apr 6, may 7, jun 4, jul 6 , aug 2, sep 3/;

scalar offset /200/
    add /100/
    redeploy /-160/

*Set of nodes representing months with possible workers. Possible
*month nodes derived from minimum labor needed for overtime constraints
*No reason to ever carry surplus over max month needed; 7 workers most any month
*Minimum workers each month derived from overtime constraint of max 25% of original hours to fufill demand
set i 'nodes, one at each month with possible workers'
    /feb3,
     mar3, mar4, mar5, mar6
     apr5, apr6, apr7,
     may6, may7,
     jun4, jun5, jun6, jun7,
     jul5, jul6, jul7,
     aug2, aug3, aug4, aug5, 
     sep3 /;
     
Alias (i,j,k);

set months /1*7/;

Parameter darc(i, j) 'Directed Arcs between month nodes with cost derived from add/redeploy'
        /feb3 .mar3 0, feb3 .mar4 100, feb3 .mar5 200, feb3 . mar6 300,
         mar3 .apr5 200, mar3 .apr6 300,
         mar4 .apr5 100, mar4 .apr6 200, mar4 .apr7 300,
         mar5 .apr5 0, mar5 .apr6 100, mar5 .apr7 200,
         mar6 .apr5 -160, mar6 .apr6 0, mar6 .apr7 100
         apr5 .may6 100, apr5 .may7 200,
         apr6 .may6 0, apr6 .may7 100,
         apr7 .may6 -160, apr7 .may7 0,
         may6 .jun4 -320, may6 .jun5 -160, may6 .jun6 0, may6 .jun7 100,
         may7 .jun5 -320, may7 .jun6 -160, may7 .jun7 0,
         jun4 .jul5 100, jun4 .jul6 200, jun4 .jul7 300,
         jun5 .jul5 0, jun5 .jul6 100, jun5 .jul7 200,
         jun6 .jul5 -160, jun6 .jul6 0, jun6 .jul7 100,
         jun7 .jul5 -320, jun7 .jul6 -160, jun7 .jul7 0,
         jul5 .aug4 -160, jul5 .aug5 0,
         jul6 .aug4 -320, jul6 .aug5 -160,
         jul7 .aug5 -320,
         aug2 .sep3 100,
         aug3 .sep3 0,
         aug4 .sep3 -160,
         aug5 .sep3 -320  /;
        
*parameter neededPersonnel(months) /feb 3, mar 4, apr 6, may 7, jun 4, jul 6 , aug 2, sep 3/;

set offsetCost(i) 'nodes, one at each month with possible workers'
    /feb3 0,
     mar3 offset*3, mar4 0, mar5 offset*5, mar6 offset*6,
     apr5 offset*5, apr6 0, apr7 offset*7,
     may6 offset*6, may7 0,
     jun4 0, jun5 offset*5, jun6 offset*6, jun7 offset*7,
     jul5 offset*5, jul6 0, jul7 offset*7,
     aug2 0, aug3 offset*3, aug4 offset*4, aug5 offset*5, 
     sep3 0/;


variables
    cost 'minimize cost'
    path(i, j, months);
    
equations
    costEQ
    pathCons
;
    







     