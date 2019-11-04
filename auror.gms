$title Homework 6 Auror CS 524-UW Madison

option limcol=0;

set iter /1*4/;
parameter it(iter) /1 1, 2 2, 3 3, 4 4/;
parameter n "Number of Aurors";
set d "# of wizarding world distracts" /1*8/;
parameter population(d) /1 40, 2 30, 3 35, 4 20, 5 15, 6 50, 7 45, 8 60/;

alias(d, i, j, z);



table travelTime(i, j) "Time in seconds to travel between districts"
    1   2   3   4   5   6   7   8
1   0   3   4   6   8   9   8   10
2   3   0   5   4   8   6   12  9
3   4   5   0   2   2   3   5   7
4   6   4   2   0   3   2   5   4
5   8   8   2   3   0   2   2   4
6   9   6   3   2   2   0   3   2
7   8   12  5   5   2   3   0   2
8   10  9   7   4   4   2   2   0;

set cover(i, j) "Auror at district i covers district j";
set notC(i, j);
cover(i, j) = yes$(travelTime(i, j) <= 2 and ord(i) ne ord(j));
notC(i, j) = yes$(travelTime(i, j) > 2);
display cover;
display notC;

binary variables tobuild(d);
binary variables covered(d);

free variable people;


equations
    objective
    numberAurors
    c
;

*Covered d implies either node tobuild(d) or tobuild i w/ arc (i,d)
c(d)..
    covered(d) =l= sum(i$cover(i,d), tobuild(i)) + tobuild(d);

numberAurors..
    sum(d, tobuild(d)) =e= n;
               
objective..
    people =e= sum(d, covered(d)*population(d));
    

model auror /all/;
auror.optca = 0.999;
loop (iter,
    n = it(iter);
    solve auror using mip maximizing people;
    display tobuild.l, people.l;
);






