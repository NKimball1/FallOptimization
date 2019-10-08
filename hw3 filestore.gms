option limrow=100, limcol=0;


set filetype /type1, type2, type3/;

parameter avgAccess(filetype) /type1 8, type2 4, type3 2/;
parameter accessTimeHD(filetype) /type1 5, type2 4, type3 4/;
parameter accessTimeCM(filetype) /type1 2, type2 1, type3 1/;
parameter accessTimeCloud(filetype) /type1 10, type2 8, type3 6/;

positive variables
    hd(filetype)
    cm(filetype)
    Cloud(filetype);

free variables
    time total time to access file- to be minimized;
    
equations
    objective
    HDLimit
    CMLimit
    CloudLimit
    totalWord
    totalPP
    totalData;
    
totalWord..
    hd("type1") + cm("type1") + Cloud("type1") =e= 300;
    
totalPP..
    hd("type2") + cm("type2") + Cloud("type2") =e= 100;
    
totalData..
    hd("type3") + cm("type3") + Cloud("type3") =e= 100;
    
HDLimit..
    sum(filetype, hd(filetype)) =l= 200;
    
CMLimit..
    sum(filetype, cm(filetype)) =l= 100;
    
CloudLimit..
    sum(filetype, Cloud(filetype)) =l= 300;
    
objective..
    time =e= sum(filetype, hd(filetype)*avgAccess(filetype)*accessTimeHD(filetype))
        + sum(filetype, cm(filetype)*avgAccess(filetype)*accessTimeCM(filetype))
            + sum(filetype, Cloud(filetype)*avgAccess(filetype)*accessTimeCloud(filetype));
            
model hw3_filestore /all/;



solve hw3_filestore using lp minimizing time;
    
set i "medium" /HD, CM, Cloud/
    j "ftype"   /Word, PP, Data/ 
    store(i,j)  /HD .Word
                 HD .PP
                 HD .Data
                 CM  .Word
                 CM  .PP
                 CM  .Data
                 Cloud .Word
                 Cloud .PP
                 Cloud .Data /;
                 
       

    

    




