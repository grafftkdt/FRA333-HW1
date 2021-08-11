function plot_trackBeeBot(A,O)
%PLOT_TRACKBEEBOT plot the animation of trackBeeBot 
%   PLOT_TRACKBEEBOT(P,W) plot the movement of the trackBeeBot based on the 
%   given path indices A and given obstacle indices O on a hexagonal grid .

%{
 NAME           : plot_trackBeeBot
 AUTHOR         : Thanacha Choopojcharoen
 DATE           : August 11th 2021
 MODIFIED BY    : -
%}

dt = 0.05;      % time to display each frame
% find the range of entire field based on the path and obstacle
if isempty(O)   % there is no obstacle
    C = A;      % use only path to find the range
else
    C = [A O];  % use both path and obstavles
end
min_i = min(C(1,:));    % find minimum range of index i
max_i = max(C(1,:));    % find maximum range of index i
min_j = min(C(2,:));    % find minimum range of index j
max_j = max(C(2,:));    % find maximum range of index j

d = 1;  % the legnth of hexagon's side
clf;
ax = axes;
hold(ax,'on');
axis(ax,'equal')  % since we are plotting in spatial domain

% calculate positions of vertices of an equilateral hexagon
hex = d/(2*sin(pi/6))*[cos(2*pi*[1:6 1]/6);sin(2*pi*[1:6 1]/6)];
% plot the entire grid
for i = min_i:max_i
    hex_i = hex + [1.5;sqrt(3)/2]*d*(i-1); % translate a hexagon according to i
    for j = min_j:max_j
        hex_ij = hex_i + [-1.5;sqrt(3)/2]*d*(j-1); % translate a hexagon according to j
        plot(ax,hex_ij(1,:),hex_ij(2,:),'k') % draw the hexagon
    end
end
% color the special tiles
for k = 1:size(A,2)
    % compute postion of vertices of the tile on the path
    hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,k)-1)+[-1.5;sqrt(3)/2]*d*(A(2,k)-1);
    if k == 1 % start tile
        color = [0,1,0];
    elseif k == size(A,2) % end tile
        color = [1,0,0];
    else % tiles on the path
        color = [1,1,0];
    end
    patch(ax,hex_ij(1,:),hex_ij(2,:),color) % color the tiles on the path
end
% color the obstacle
for k = 1:size(O,2)
   % compute postion of vertices of the obstacle tile
   hex_ij = hex + [1.5;sqrt(3)/2]*d*(O(1,k)-1)+[-1.5;sqrt(3)/2]*d*(O(2,k)-1); 
   patch(ax,hex_ij(1,:),hex_ij(2,:),[0,0,0]) % color the ostavles
end

% animate the movement of BeeBot
for k = 1:size(A,2)
    % compute postion of vertices of the current tile
    hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,k)-1)+[-1.5;sqrt(3)/2]*d*(A(2,k)-1);
    patch(ax,hex_ij(1,:),hex_ij(2,:),[0,0,1]) % color the current tile
    if k>1 % if there exists a previous tile
        if all(A(:,k-1)==A(:,1)) % if the previous tile is the start tile
            color = [0,1,0]; 
        elseif all(A(:,k-1)==A(:,end)) % if the previous tile is the end tile
            color = [1,0,0];
        else % if the previous is other tile in the path
            color = [1,1,0];
        end
        % compute postion of vertices of the previous tile 
        hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,k-1)-1)+[-1.5;sqrt(3)/2]*d*(A(2,k-1)-1);
        patch(ax,hex_ij(1,:),hex_ij(2,:),color) % color the previous accordingly
    end
    pause(dt);
end