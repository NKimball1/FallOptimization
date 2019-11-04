set i /1*10/;
alias(i,j);
set m(i) /2*10/;
alias(m, n);
table clean(i,j)
   1  2  3  4  5  6  7  8   9  10
1     11 7  13 11 12 4  9   7  11
2  5     13 15 15 6  8  10  9   8
3  13 15    23 11 11 16 18  5   7
4  9  13 5     3  8  10 12 14   5
5  3  7  7  7     9  10 11 12  13
6  10 6  3  4  14    8  5  11  12
7  4  6  7  3  13 7     10  4   6
8  7  8  9  9  12 11 10    10   9
9  9  14 8  4  9  6  10 8      12
10 11 17 11 6  10 4  7  9  11
;

*Make sure MIP solver finds global optima.
option optcr=0;

parameter dur(i) /1 40, 2 35, 3 45, 4 32, 5 50, 6 42, 7 44, 8 30, 9 33, 10 55 /;

free variable time;

positive variable u(i) Positive variable for MTZ constraints;
*First subtour exclusion Theorem 2 constraint
u.l('1') = 1; 

binary variable x(i, j) Arcs in batch order;

equations
    objective minimize total time
    steConsT11(i) First constraints for  MTZ subtour elimination theorem 1
    steConsT12(i) First constraints for  MTZ subtour elimination theorem 1
    steConsT22lower(i)
    steConsT22upper(i)
    steArcConstraint(m, n)
;
    
objective..
    sum((i,j), x(i,j)*(clean(i,j) + dur(i))) =e= time;

steArcConstraint(m,n)..
    (u(m) - u(n) + card(dur)*x(m,n)) =l= (card(dur) - 1);

steConsT22lower(i)$(ord(i) > 1)..
    u(i) =g= 2;
    
steConsT22upper(i)$(ord(i) > 1)..
  u(i) =l= 10;

steConsT11(i)..
    sum(j$(ord(i) ne ord(j)), x(i, j)) =e= 1;
    
steConsT12(j)..
    sum(i$(ord(i) ne ord(j)), x(i, j)) =e= 1;
    
model paint /all/;

solve paint using mip minimizing time;

display x.l;

parameter batchlength;
batchlength = time.l
parameter order(i);

loop(j,
    order(i)$(abs(u.L(j) - ord(i)) < .5) = ord(j) );

display n;
display batchlength, order, u.l;

