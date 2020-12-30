%% 3D single use
p = [12,33,20];
q = [6,-5,3];

s = [20,10,5];

figure;
scatter3(s(1),s(2),s(3))
hold on
plot3([p(1),q(1)],[p(2),q(2)],[p(3),q(3)])


top = dot(s-q,p-q);%previously top = dot(s-p,p-q);
bot = dot(p-q,p-q);
dist = norm((top/bot)*(p-q)+(q-s));
distWolfram = norm(cross((p-q),(q-s)))/norm(p-q);


%% 2D Variant plot many
p = [0,0,-25];
q = [0,0,25];

dist = @(sPoint) norm((dot(sPoint-q,p-q)/dot(p-q,p-q))*(p-q)+(q-sPoint));
distWolfram = @(sPoint) norm(cross((p-q),(q-sPoint)))/norm(p-q);

sDist = [];
sDistWolf = [];
count = 1;
for i = -20:20
    for j = 0:20
        for k = -20:20
            sDist(count,:) = [i,j,k,dist([i,j,k])];
            sDistWolf(count,:) = [i,j,k,distWolfram([i,j,k])];
            count = count + 1;
        end
    end
end

%% Plot stuff
close all;
pointSize = 25;
figure;
hold on
plot3([p(1),q(1)],[p(2),q(2)],[p(3),q(3)],'r','LineWidth',5)
title('Distance Value Distribution using OLD formula')
scatter3(sDist(:,1),sDist(:,2),sDist(:,3),pointSize,sDist(:,4),'filled')
colorbar
xlim([-20,20])
ylim([-20,20])
zlim([-20,20])

figure;
hold on
plot3([p(1),q(1)],[p(2),q(2)],[p(3),q(3)],'r','LineWidth',5)
title('Distance Value Distribution using NEW formula')
scatter3(sDistWolf(:,1),sDistWolf(:,2),sDistWolf(:,3),pointSize,sDistWolf(:,4),'filled')
colorbar
xlim([-20,20])
ylim([-20,20])
zlim([-20,20])

%% Plot a 1D slice
close all;
for x = 0:20.12345
    d_old(x+1,:) = dist([x,0,0]);
    d_new(x+1,:) = distWolfram([x,0,0]);
end
figure;
plot(d_old-d_old(1));
hold on
plot(d_new);
legend('old','new')
grid on;

