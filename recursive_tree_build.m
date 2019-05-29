function tree = recursive_tree_build(tree, index, Xt, criteria, class_arr)
[Xt_Y, Xt_N, feature, a] = split(Xt, criteria, class_arr);
if Xt_Y == -1
    type = classify_leaf(Xt, class_arr);
    node = Node(-1, -1, Xt(:,1:end-1), type);
    tree = tree.setByIndex(index,node);
    return;
end

node = Node(a, feature, Xt(:,1:end-1));
tree = tree.setByIndex(index,node);
tree = recursive_tree_build(tree, 2*index, Xt_Y, criteria, class_arr);
tree = recursive_tree_build(tree, 2*index + 1, Xt_N, criteria, class_arr);

end

