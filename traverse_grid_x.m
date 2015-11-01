function [n] = traverse_grid_x(x, dep, n, q)

if x>dep-2 || (q == -1 &&  dep - 2*(abs(x))<0)
    dep = 0;
end
if x > 1 && (q == -1 || x>q)
    q = x;
end
if dep == 0 && x<-1 && q > 0
    n = 1;
%     fprintf(f, '%i,%i\r\n', q, x);
end

if dep ~= 0
    n = traverse_grid_x(x-1, dep-1, n, q) + ...
        traverse_grid_x(x+1, dep-1, n, q) + ...
        2*traverse_grid_x(x, dep-1, n, q);
end

end
