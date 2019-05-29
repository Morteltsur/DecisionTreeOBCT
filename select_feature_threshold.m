function [feature_index,best_alpha, max_entropy] = select_feature_threshold(Xt_yt, class_arr)
    [m,n] = size(Xt_yt);
    max_entropy = -inf;
    feature_index = -1;
    best_alpha = -inf;
for j = 1:m-1
    for i = 1:n-1
        alpha = (Xt(j,i) + Xt(j+1,i))/2;
            [r_y,c_y] = find(Xt_yt(:,i) < alpha);
            [r_n,c_n] = find(Xt_yt(:,i) >= alpha);
                                
            Xt_Y = Xt_yt(r_y,:);
            Xt_N = Xt_yt(r_n,:);
            
            probs_Xt = calc_probs(Xt_yt, class_arr);
            probs_Xt_Y = calc_probs(Xt_Y, class_arr);
            probs_Xt_N = calc_probs(Xt_N, class_arr);
            I_delta = entropy(probs_Xt) - (size(Xt_Y,1)/size(Xt_yt,1))*entropy(probs_Xt_Y) - ...
                      (size(Xt_N,1)/size(Xt_yt,1))*entropy(probs_Xt_N);
            if I_delta > max_entropy
                max_entropy = I_delta;
                feature_index = i;
                best_alpha = alpha;
            end
        end
    end


end

