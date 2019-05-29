classdef Tree
   properties
      tree;
   end
   methods 
      function obj = Tree(root)
          obj.tree = Node.empty(1,0);
          if nargin > 0
            obj.tree(1,1) = root;
          end
      end
      
      function left = getLeft(obj,node)
          if strcmp(obj.tree(node.index).class, '') == 0
              left = -1;
              fprintf('ERROR: Node is a leaf\n');
              return;
          elseif isempty(obj.tree(node.index).Xt)
              left = -1;
              fprintf('ERROR: Node is invalid\n');
              return;
          end
          left = obj.tree(2*node.index);
      end
      
      function right = getRight(obj,node)
          if strcmp(obj.tree(node.index).class, '') == 0
              right = -1;
              fprintf('ERROR: Node is a leaf\n');
              return;
          elseif isempty(obj.tree(node.index).Xt)
              right = -1;
              fprintf('ERROR: Node is invalid\n');
              return;
          end
          right = obj.tree(2*node.index);
      end
      
      function root = getRoot(obj)
          if isempty(obj.tree) || isempty(obj.tree(1).Xt)
              fprintf('ERROR: tree wasnt initialized');
              root = -1;
              return;
          end
          root = obj.tree(1);
      end
      
      function par = getParent(obj,node)
          if node.index == 1
              par = -1;
              fprintf('ERROR: Node is root\n');
              return
          end
          if isempty(node.Xt) && strcmp(node.class, '') == 1
              fprintf('ERROR: Node is invalid\n');
          end
          par = obj.tree(floor(node.index/2));
      end
      
      function obj = OBCT(obj, Xt, yt, criteria)
          class_arr = cell(0);
          y_temp = yt;
          num_labels = zeros(size(yt));
          while(~isempty(y_temp))
              class_arr = [class_arr , y_temp(1)];
              y_temp = y_temp(~strcmp(y_temp , class_arr(end)));
              num_labels(strcmp(yt , class_arr(end))) = length(class_arr);
          end
          Xt_yt = [Xt , num_labels];
          obj.tree = recursive_tree_build(Tree(), 1, Xt_yt, criteria, class_arr);
      end
      
   end
   
   methods (Access = private)
      function obj = setByIndex(obj, index, node)
          obj.tree(index) = node;
      end
      
      function obj = recursive_tree_build(obj, index, Xt, criteria, class_arr)
          [Xt_Y, Xt_N, feature, a] = obj.split(Xt, criteria, class_arr);
          if Xt_Y == -1
              type = obj.classify_leaf(Xt, class_arr);
              node = Node(-1, -1, Xt(:,1:end-1), index, type);
              obj = obj.setByIndex(index,node);
              return;
          end

          node = Node(a, feature, Xt(:,1:end-1), index, '');
          obj = obj.setByIndex(index,node);
          obj = recursive_tree_build(obj, 2*index, Xt_Y, criteria, class_arr);
          obj = recursive_tree_build(obj, 2*index + 1, Xt_N, criteria, class_arr);
      end
      
      function [Xt_Y, Xt_N, feature_index, a] = split(obj, Xt_yt, criteria, class_arr)
          [feature_index,a, impurity_dec] = obj.select_feature_threshold(Xt_yt, class_arr);
          if impurity_dec < criteria
              fprintf('LEAF\n');
              Xt_Y = -1;
              Xt_N = -1;
              return;
          end
          [r_y,c_y] = find(Xt_yt(:,feature_index) <  a);
          [r_n,c_n] = find(Xt_yt(:,feature_index) >= a);
          Xt_Y = Xt_yt(r_y,:);
          Xt_N = Xt_yt(r_n,:);
      end
      
      function [feature_index,best_alpha, max_entropy] = select_feature_threshold(obj, Xt_yt, class_arr)
          [m,n] = size(Xt_yt);
          max_entropy = -inf;
          feature_index = -1;
          best_alpha = -inf;
          for j = 1:m-1
              for i = 1:n-1
                  alpha = (Xt_yt(j,i) + Xt_yt(j+1,i))/2;
                  [r_y,c_y] = find(Xt_yt(:,i) < alpha);
                  [r_n,c_n] = find(Xt_yt(:,i) >= alpha);
                                
                  Xt_Y = Xt_yt(r_y,:);
                  Xt_N = Xt_yt(r_n,:);
            
                  probs_Xt = obj.calc_probs(Xt_yt, class_arr);
                  probs_Xt_Y = obj.calc_probs(Xt_Y, class_arr);
                  probs_Xt_N = obj.calc_probs(Xt_N, class_arr);
                  I_delta = obj.entropy(probs_Xt) - (size(Xt_Y,1)/size(Xt_yt,1))*obj.entropy(probs_Xt_Y) - ...
                      (size(Xt_N,1)/size(Xt_yt,1))*obj.entropy(probs_Xt_N);
                  if I_delta > max_entropy
                      max_entropy = I_delta;
                      feature_index = i;
                      best_alpha = alpha;
                  end
              end
          end
      end
      
      function [I] = entropy(obj, probs)
          I = 0;
          for i=1:length(probs)
              I = I + probs(i)*log2(probs(i));
          end
          I = -I;
      end

      function probs = calc_probs(obj, Xt, class_arr)
          probs = zeros(size(Xt(:,end)));
          for i=1:length(class_arr) 
              probs(Xt(:,end) == i) = sum(Xt(:,end) == i)/size(Xt(:,end),1);
          end
      end
      
      function type = classify_leaf(obj, Xt_yt, class_arr)
          class_count = hist(Xt_yt(:,end), 1:length(class_arr));
          [val, ind] = max(class_count);
          type = class_arr(ind);
      end
   end
end