% NAME : A-n32-k5
vehiclesCapacity = 100;
nVehicles = 5;
points = [
 2 96 44
 3 50 5
 4 49 8
 5 13 7
 6 29 89
 7 58 30
 8 84 39
 9 14 24
 10 2 39
 11 3 82
 12 5 10
 13 98 52
 14 84 25
 15 61 59
 16 1 65
 17 88 51
 18 91 2
 19 19 32
 20 93 3
 21 50 93
 22 98 14
 23 5 42
 24 42 9
 25 61 62
 26 9 97
 27 80 55
 28 57 69
 29 23 15
 30 20 70
 31 85 60
 32 98 5];
points = points(:,[2,3]);
weights = [
2 19 
3 21 
4 6 
5 19 
6 7 
7 12 
8 16 
9 6 
10 16 
11 8 
12 14 
13 21 
14 16 
15 3 
16 22 
17 18 
18 19 
19 1 
20 24 
21 8 
22 12 
23 4 
24 8 
25 24 
26 24 
27 2 
28 20 
29 15 
30 2 
31 14 
32 9 ];
weights = weights(:,2);
startingPoint = [82 76];

optSol = cell(nVehicles,1);
optSol{1} = [21 31 19 17 13 7 26]';
optSol{2} = [12 1 16 30]';
optSol{3} = [27 24]';
optSol{4} = [29 18 8 9 22 15 10 25 5 20]';
optSol{5} = [14 28 11 4 23 3 2 6]';
optCost = 787;

save('test1.mat',"startingPoint","points","weights","nVehicles","vehiclesCapacity",'optCost',"optSol");