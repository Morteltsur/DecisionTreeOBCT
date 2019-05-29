function [Xt_Y, Xt_N, feature_index, a] = split(Xt_yt, criteria, class_arr)
    [feature_index,a, impurity_dec] = select_feature_threshold(Xt_yt, class_arr);
    if impurity_dec < criteria
        fprintf('LEAF!\n');
        Xt_Y = -1;
        Xt_N = -1;
        return;
    end
    [r_y,c_y] = find(Xt_yt(:,feature_index) <  a);
    [r_n,c_n] = find(Xt_yt(:,feature_index) >= a);
    Xt_Y = Xt_yt(r_y,:);
    Xt_N = Xt_yt(r_n,:);
end

