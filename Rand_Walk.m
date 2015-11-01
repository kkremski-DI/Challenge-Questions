function ans = Rand_Walk(step, max_dist, s)

n = step+1;

P_Mat = Pascal_matrix_2D(n);

dist_map = zeros(size(P_Mat));
for h = 1:size(dist_map,1)
    for k = 1:size(dist_map,2)
        dist_map(h,k) = sqrt((h-n)^2 + (k-n)^2);
    end
end

dist_bool = dist_map>=max_dist;


switch s
    case 'max'
        rem = dist_bool.*P_Mat;
        ans = sum(rem(:));
    case 'rms'
        if isinf(max(P_Mat(:))*max(dist_map(:))*10)
            P_Mat = Pascal_matrix_2D_log(n);
            dist_map(P_Mat == 0) = 0;
%             P_Mat = log10(P_Mat);
            P_Mat(P_Mat == -Inf) = 0;
            
            tots = step*log10(4);
            rem = dist_map.*10.^(P_Mat-tots);
            rem(P_Mat== 0) = 0;
            ans = sum(rem(:));
        else
            rem = dist_map.*P_Mat./(4^step);
            ans = sum(rem(:));
        end
end