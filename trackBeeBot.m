function [A,P] = trackBeeBot(a_i,c,O)
% Write your code here.
%load testcase_01.mat;                  %pass
%load testcase_02.mat;
%load testcase_03.mat;
%load testcase_04.mat;
%load testcase_05.mat;                  %pass
%load testcase_06.mat;
%load testcase_07.mat;
%load testcase_08.mat;
%load testcase_without_wall.mat;        %pass
%load testcase_with_wall.mat;           %pass
d = 1;
min_x = a_i(1,1);
max_x = a_i(1,1);
min_y = a_i(2,1);
max_y = a_i(2,1);
%     _ 1              _+1,+1
% 6 /   \2      0,+1 /   \ +1,0
% 5 \ _ /3      -1,0 \ _ / 0,-1
%     4              -1,-1

direction = 1;      %set the default direction as 1                    
dis_x = 1;          %represent the distance to move in X axis
dis_y = 1;          %represent the distance to move in Y axis
P = [1.5;sqrt(3)/2]*d*(a_i(1,1)-1)+[-1.5;sqrt(3)/2]*d*(a_i(2,1)-1)+[0;sqrt(3)]; 
%the equation to transform the order in to position in graph
%P is the position of the point in the graph


current_position = a_i;     % start point at a_i
pre_position = [0;0];       % set the position before moving as 0
A = a_i;                    % A represents to coordinate(x,y) of the points
for i = 1:length(c)     %flow n loops ;n = length of c
    pre_position = current_position;
    if (c(i) == '1')    %go forward
        current_position(1,1) = current_position(1,1)+dis_
        current_position(2,1) = current_position(2,1)+dis_y;
        if ~isempty(O)  %in case of having walls
            find_x = find(O(1,:)==current_position(1,1));   %find the [X,Y] when X equals to current_position(1,1) in first row of O 
            find_y = find(O(2,:)==current_position(2,1));   %find the [X,Y] when Y equals to current_position(2,1) in second row of O 
             if isempty((intersect(find_y,find_x)))     %if the current_position is not an element of walls, find_x and find_y won't share any elements.
                 A = [A current_position];  %add current_position into A
                 P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]]; %add current location into P
             else
                 current_position = pre_position; %in case of facing to walls >> stay at same point
             end
        else  %in case of no walls
            A = [A current_position];
            P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]];
        end
        
    elseif (c(i) == '2')    %go backward
            current_position(1,1) = current_position(1,1)-dis_x;
            current_position(2,1) = current_position(2,1)-dis_y;
        if ~isempty(O)  %in case of having walls
                    find_x = find(O(1,:)==current_position(1,1));
                    find_y = find(O(2,:)==current_position(2,1));
                     if isempty((intersect(find_y,find_x)))
                         A = [A current_position];
                         P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]];
                     else
                         current_position = pre_position; %in case of facing to walls >> stay at same point
                     end
                else %in case of no walls
                    A = [A current_position];
                    P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]];
        end
    elseif (c(i) == '4')    %turn right 60 degrees >> clockwise >> 1>2>3>4>5>6
        direction = direction +1;
        if(direction == 7)
            direction = 1;
        end
    elseif (c(i) == '3')    %turn left 60 degrees >> counterclockwise >> 6>5>4>3>2>1
        direction = direction - 1;
        if(direction == 0)
            direction = 6;
        end
    end
    %circling along the hexagonal sides
    if (direction == 1)
        dis_x = 1;
        dis_y = 1;
    elseif (direction == 2)
        dis_x = 1;
        dis_y = 0;
    elseif (direction == 3)
        dis_x = 0;
        dis_y = -1;
    elseif (direction == 4)
        dis_x = -1;
        dis_y = -1;
    elseif (direction == 5)
        dis_x = -1;
        dis_y = 0;
    elseif (direction == 6)
        dis_x = 0;
        dis_y = 1;
    end
end

isequal(A,A)    %recheck the calculated answers 
if ~isempty(O) %in case of having walls
    min_i = min([A(1,:) O(1,:)]);
    max_i = max([A(1,:) O(1,:)]);
    min_j = min([A(2,:) O(2,:)]);
    max_j = max([A(2,:) O(2,:)]);
else %in case of no walls
    min_i = min(A(1,:));
    max_i = max(A(1,:));
    min_j = min(A(2,:));
    max_j = max(A(2,:));
end

% d = 1;
% clf;
% ax = axes;
% hold(ax,'on');
% axis(ax,'equal')
% hex = d/(2*sin(pi/6))*[cos(2*pi*[1:6 1]/6);sin(2*pi*[1:6 1]/6)];
% %patch command >> plots one or more filled polygonal regions using the elements of X and Y as the coordinates for each vertex
% 
% %creat hex graph
% for i = min_i:max_i  %limit the boundaries of hexagon
%     hex_i = hex + [1.5;sqrt(3)/2]*d*(i-1);
%     for j = min_j:max_j
%         hex_ij = hex_i + [-1.5;sqrt(3)/2]*d*(j-1)+[0;sqrt(3)];
%         plot(ax,hex_ij(1,:),hex_ij(2,:),'k','linewidth',3)
%     end
% end
% 
% %black walls
% for k = 1:size(O,2) %limit the boundaries of the walls
%     hex_ij = hex + [1.5;sqrt(3)/2]*d*(O(1,k)-1)+[-1.5;sqrt(3)/2]*d*(O(2,k)-1)+[0;sqrt(3)];
%     patch(ax,hex_ij(1,:),hex_ij(2,:),'black')   %filled the hexagon walls with black
% end
% 
% %yellow path
% for k = 1:size(A,2) %along the given coordinates
%     hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,k)-1)+[-1.5;sqrt(3)/2]*d*(A(2,k)-1)+[0;sqrt(3)];
%     patch(ax,hex_ij(1,:),hex_ij(2,:),'yellow')  %filled the hexagon paths with yellow
% end
% 
% %green hex at start point
% hex_ij = hex + [1.5;sqrt(3)/2]*d*(a_i(1,1)-1)+[-1.5;sqrt(3)/2]*d*(a_i(2,1)-1)+[0;sqrt(3)];
% patch(ax,hex_ij(1,:),hex_ij(2,:),'green')   %filled the starting hexagon block with green
% start = hex_ij;
% 
% %red hex at final point
% hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,end)-1)+[-1.5;sqrt(3)/2]*d*(A(2,end)-1)+[0;sqrt(3)];
% patch(ax,hex_ij(1,:),hex_ij(2,:),'red')     %filled the final hexagon block with red
% final = hex_ij;
% 
% %blue travelling
% for k = 1:size(A,2) %along the given coordinates
%     hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,k)-1)+[-1.5;sqrt(3)/2]*d*(A(2,k)-1)+[0;sqrt(3)];
%     patch(ax,hex_ij(1,:),hex_ij(2,:),'blue')    %filled the travelling hexagon blocks with blue
%     pause(0.1);     %delay 0.1 sec
%     if hex_ij == start
%         patch(ax,hex_ij(1,:),hex_ij(2,:),'green')   %start block remains green after blue block travelled
%     elseif hex_ij == final
%         patch(ax,hex_ij(1,:),hex_ij(2,:),'red')     %final block remains red after blue block travelled
%     else 
%         patch(ax,hex_ij(1,:),hex_ij(2,:),'yellow')  %path blocks remain yellow after blue block travelled
%     end
% end

end