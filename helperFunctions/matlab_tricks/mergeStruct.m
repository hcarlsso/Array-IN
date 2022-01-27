function [structB] = mergeStruct(structA,structB)
%mergeStruct Merge two structs
%   If similar then structA has precedence
 f = fieldnames(structA);
 for i = 1:length(f)
    structB.(f{i}) = structA.(f{i});
 end
end

