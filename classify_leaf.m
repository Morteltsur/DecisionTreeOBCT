function type = classify_leaf(Xt_yt, class_arr)
class_count = hist(Xt_yt(:,end), 1:length(class_arr));
[val, ind] = max(class_count);
type = class_arr(ind);
end

