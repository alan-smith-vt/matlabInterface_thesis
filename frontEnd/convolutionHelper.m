function [X,Y,idx] = convolutionHelper(res,thresh,kernel,epsilon,minPoints)
    s = size(res);
    id = res>thresh;
    X = zeros(nnz(id),3);
    count = 0;
    sInput = size(kernel);
%     if nnz(id) > 20000
%         Y = [0,0];
%         idx = [0];
%         X = [0,0,0];
%         fprintf('Skipping convolution due to too many points above threshold (%d)\n',nnz(id))
%         return
%     end
    
    %For each point above thresh, transform them to match the original
    %coordinate system and populate a new array with just these points
    for i = 1:s(1)
        for j = 1:s(2)
            if id(i,j)~= 0
                count = count+1;
                X(count,:) = [j-sInput(2)/2+5,i-sInput(1)/2,res(i,j)];
            end
        end
    end
    
    %Cluster the transformed points
    idx = DBSCAN(X(:,1:2),epsilon,minPoints);
    Y = zeros(max(idx), 2);
    
    %For each cluster, return its centroid
    for cluster = 1:max(idx)
        A = X(idx == cluster,:);%A is a single cluster extracted from the point set
%         [~,row] = max(A(:,3));%This is not getting the centroid... THIS IS GETTING THE MAX POINT IN THE SET
%         Y(cluster,:) = A(row,1:2);
        Y(cluster,:) = [mean(A(:,1)),mean(A(:,2))];
    end
end