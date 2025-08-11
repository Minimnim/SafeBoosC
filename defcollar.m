function y = defcollar(x)
y = arrayfun(@(x)[x-17:x+17], x, 'UniformOutput', false);
y = cell2mat(y);
y = reshape(y, numel(y), 1);
end 