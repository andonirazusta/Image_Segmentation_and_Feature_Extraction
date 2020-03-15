function c = FreemanChainCode(b)
% input b is a set of 2-D coordinate pairs for a boundary and CONN can be 
% 8 for an 8-connected chain code or 4 for a 4-connected chain code. 
% The output c is a structure with the following fields:
% c.fcc = chain code (1×𝑛𝑝 where 𝑛𝑝 is the number of boundary pixels)
% c.diff = First difference of code c.fcc (1×𝑛𝑝)
% c.mm = Integer of minimum magnitude from c.fcc (1×𝑛𝑝)
% c.diffmm = First difference of code c.mm (1×𝑛𝑝)
% c.x0y0 = Coordinates where the code starts (1×2)

% sb=circshift(b,[-1 0]);
% delta=sb-b;
% 
% idx=3*delta(:,1)+delta(:,2)+5;
% cm([1 2 3 4 6 7 8 9])=[5 6 7 4 0 3 2 1];


diffB = diff([b; b(1,:)]);
c.x0y0 = b(1,:);
idx([1 2 3 5 7 9 10 11]) = [5 4 3 6 2 7 0 1];
diffB_map = 4*diffB(:,1) + diffB(:,2) + 6;
c.fcc = idx(diffB_map); 
c.diff = mod(diff([c.fcc(end), c.fcc])+8,8);
SNum_all = sortrows(toeplitz([c.diff(1) fliplr(c.diff(2:end))], c.diff));
c.ShapeNum = SNum_all(1,:);

c.mm = minmag(c.fcc);
c.diffmm = mod(diff([c.mm(end), c.mm])+8,8);
c.diffmm = codediff(c.mm,8);
    
end

