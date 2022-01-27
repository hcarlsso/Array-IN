function printpdf_multiple(h,outfilename,folders)
%PRINTPDF_MULTIPLE printpdf for multiple folders
%   
for f = folders
    printpdf(h, fullfile(f,outfilename));
end

end

