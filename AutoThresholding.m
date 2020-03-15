function [g,T] = AutoThresholding(f)
    To = 1e-18; % Min change of T
    Tnew = 255*rand(1); % Randomly pick the starting T
    dT = 1000; % A high value
    
    hist=imhist(f); % Compute the histogram
    N=sum(hist);
    for i=1:256
        P(i)=hist(i)/N; % Compute the cumulative sums
    end
    
    while dT>To
        Told = Tnew;

        mean1 = sum([0:Told-1] .* P(1:Told));
        mean2 = sum([Told:255] .* P(Told+1:256));      

        Tnew = 0.5*(mean1+mean2);
        dT = abs(Told-Tnew);
    end
    T = Tnew;
   
    g = zeros(size(f));
    g(find(f>=T)) = 255;
    g(find(f<T)) = 0;
end
