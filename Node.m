classdef Node
   properties
      a
      feature
      Xt
      index
      class
   end
   methods
      function obj = Node(a, feature, Xt, index, class)
         if nargin > 0
            obj.a = a;
         end
         if nargin > 1
            obj.feature = feature;
         end
         if nargin > 2
            obj.Xt = Xt;
         end
         if nargin > 3
             obj.index = index;
         end
         if nargin > 4
             obj.class = class;
         else 
             obj.class = '';
         end
      end
   end
end