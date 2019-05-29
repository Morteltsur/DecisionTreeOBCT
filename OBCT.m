function tree = OBCT(Xt, yt, criteria)
import Tree
import Node

class_arr = cell(0);
y_temp = yt;
num_labels = zeros(size(yt));
while(~isempty(y_temp))
    class_arr = [class_arr , y_temp(1)];
    y_temp = y_temp(~strcmp(y_temp , class_arr(end)));
    num_labels(strcmp(yt , class_arr(end))) = length(class_arr);
end
Xt_yt = [Xt , num_labels];
tree = recursive_tree_build(Tree(), 1, Xt_yt, criteria, class_arr);


end

