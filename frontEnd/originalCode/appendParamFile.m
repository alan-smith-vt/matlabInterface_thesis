%This function will append the stated arguments to the end of the given
%file
function res = appendParamFile(name, varargin)
    res = 0;
    fid = fopen(name,'a+');
    for i = 1:length(varargin)
        fprintf(fid,'%s\n',varargin{i});
    end
    res = 1;
    fclose(fid);
end