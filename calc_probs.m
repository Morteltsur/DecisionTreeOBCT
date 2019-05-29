function probs = calc_probs(Xt, class_arr)
probs = zeros(size(Xt(:,end)));
for i=1:length(class_arr) 
    probs(Xt(:,end) == i) = sum(Xt(:,end) == i)/size(Xt(:,end),1);
end
end

