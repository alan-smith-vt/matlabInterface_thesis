%This function will assist in creating a parameter python file
%
%Beware that if a file with the given name exists, it will be overwritten
%without warning.
function res = createParamFile(name, varargin)
    res = 0;
    fid = fopen(name,'wt');
    for i = 1:length(varargin)
        fprintf(fid,'%s\n',varargin{i});
    end
    fclose(fid);
    res = 1;
end