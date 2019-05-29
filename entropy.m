function [I] = entropy(probs)
    I = 0;
    for i=1:length(probs)
        I = I + probs(i)*log2(probs(i));
    end
    I = -I;
end

