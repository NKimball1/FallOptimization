set nationality /Brit, German, Norwegian, Dane, Swede/
    smoke /Blends, Dunhill, BlueMaster, PallMall, Prince/
    beverage/tea, beer, milk, water, coffee/
    color /yellow, red, green, white, blue/
    pet /dog, bird, cat, horse, fish/
;
set fishowner(nationality) /german/;

set homeowner /1*5/;
*C here stands for category, i/j are for homeowners
alias(homeowner, i, j, c);
binary variable
    n(i, c) nationality 
    p(i, c) Pet 
    s(i, c) smoke 
    b(i, c) Beverage
    z(i, c) color
;
 
free variable total total spots on 5x5 matrix occupied by homeowners;


$ontext
1.The Brit lives in a red house.
2. The Swede keeps dogs as pets.
3. The Dane drinks tea.
4. The Green house is on the left of the White house. (i.e. the number of the white house is one greater than the green house)
5. he owner of the Green house drinks coffee.
6. The person who smokes Pall Mall rears birds.
The owner of the Yellow house smokes Dunhill.
The man living in the centre house drinks milk.
The Norwegian lives in the first house.
The man who smokes Blends lives next to the one who keeps cats.
The man who keeps horses lives next to the man who smokes Dunhill.
The man who smokes Blue Master drinks beer.
The German smokes Prince.
The Norwegian lives next to the blue house.
The man who smokes Blends has a neighbour who drinks water.
$offtext

equations
    objective each homeowner takes 1 value
    nationality1(i) only one homeowner may occupy each nationality
    nationality2(c) only one nationality per homeowner
    pet1(i) only one person may have each pet
    pet2(c) only ony pet per person
    smoke1(i) one person per smoke
    smoke2(c) one smoke per person
    color1(i)
    color2(c)
    bev1(i)
    bev2(c)
    cons1 Constraint 1 given in text above
    cons2 Constraint 2 given in text above
    cons3
    cons4
    cons5
    cons6
    cons7
    cons8
    cons9
    cons10
    cons11
    cons12
    cons13
    cons14
    cons15
    uniqueCheck
    
;

objective..
    sum((i,c), n(i,c)) +  sum((i,c), p(i,c)) + sum((i,c), s(i,c)) + sum((i,c), z(i,c)) + sum((i,c), b(i,c)) =e= total;

nationality1(i)..
    sum(c, n(i, c)) =e= 1;
    
nationality2(c)..
    sum(i, n(i, c)) =e= 1;
    
smoke1(i)..
    sum(c, s(i, c)) =e= 1;
    
smoke2(c)..
    sum(i, s(i, c)) =e= 1;
    
pet1(i)..
    sum(c, p(i, c)) =e= 1;
    
pet2(c)..
    sum(i, p(i, c)) =e= 1;
    
color1(i)..
    sum(c, z(i, c)) =e= 1;
    
color2(c)..
    sum(i, z(i, c)) =e= 1;
    
bev1(i)..
    sum(c, b(i, c)) =e= 1;
    
bev2(c)..
    sum(i, b(i, c)) =e= 1;
    
cons1(i, c)..
    n(i, "1") =e= z(i, "2");
    
cons2(i, c)..
    n(i, "5") =e= p(i, "1");
    
cons3(i, c)..
    n(i, "4") =e= b(i, "1");
    
cons4(i, c)..
    z(i, "3") =e= z(i + 1, "4");
    
cons5(i, c)..
    z(i, "3") =e= b(i, "5");
    
cons6(i, c)..
    s(i, "4") =e= p(i, "2");
    
cons7(i, c)..
    z(i, "1") =e= s(i, "2");
    
cons8(i, c)..
    b("3", "3") =e= 1;
    
cons9(i, c)..
    n("1", "3") =e= 1;
    
cons10(i, c)..
    s(i, "1") =e= p(i - 1, "3") + p(i + 1, "3");
    
cons11(i, c)..
    p(i, "4") =e= s(i + 1, "2") + s(i - 1, "2");
    
cons12(i, c)..
    s(i, "3") =e= b(i, "2");
    
cons13(i, c)..
    s(i, "5") =e= n(i, "2");
  
*From constraint 9 Norweigan lives in house 1- Therefore only need to check house + 1  
cons14(i, c)..
   n(i, "3") =e= z(i + 1, "5");
   
cons15(i, c)..
    s(i, "1") =e= b(i + 1, "4") + b(i - 1, "4");
    
uniqueCheck(i, c)..
    p(i, "1") + p(i, "2") + p(i, "3") + p(i, "4") =e= 1;
    
model einstein /objective 
    nationality1, 
    nationality2, 
    pet1,
    pet2,
    smoke1,
    smoke2,
    color1,
    color2,
    bev1,
    bev2,
    cons1,
    cons2,
    cons3,
    cons4,
    cons5,
    cons6,
    cons7,
    cons8,
    cons9,
    cons10,
    cons11,
    cons12,
    cons13,
    cons14,
    cons15 /;

solve einstein maximixing total using mip;


display n.l, p.l, s.l, z.l, b.l, fishowner;


    



