function [P_Rot] = Pascal_matrix_2D_log(n)

t = pascal(n);
P_Mat = zeros(1,n);
for i = 1:n
    P_Mat(i) = t(n-i+1,i);
end
P_Mat = log10(P_Mat);

for i = 2:n
    P_Mat(i,:) = P_Mat(1,:)+P_Mat(1,i);
end

P_Rot = zeros(2*n-1);

for i = -n+1:2:n-1

    h = 1 + (n-1-i)/2;
    k = (n-1-abs(i))/2;

    D{h} = {[zeros(1,k), P_Mat(h,:), zeros(1,k)]};
    P_Rot = P_Rot + diag(D{h}{1},i);
end

end