function mm = MinimumMagnitude(fcc)
i = find(fcc == min(fcc));
    k = 0;
    a = zeros(length(i), length(fcc));
    for v = i
        k =k + 1;
        a(k,:) = circshift(fcc,[0 - (v-1)]);
    end
    [M,N] = size(a);
    k = (1:M)';
    for v = 2:N
        D(1:M,1) = inf;
        D(k,1) = a(k,v);
        amin = min(a(k,v));
        k = find(D(:,1) == amin);
        
        mm = a(k,:);
    end