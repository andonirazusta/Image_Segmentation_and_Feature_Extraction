function d = codediff(fcc, CONN)
sr = circshift(fcc, [0, -1]); 
delta = sr - fcc; 
d = delta; 
I = find(delta < 0);  
switch CONN 
    case 4 % Code is 4-connectivity
        d(I) = d(I) + 4;
    case 8 % Code is 8-connectivity
        d(I) = d(I) + 8;
end 


end