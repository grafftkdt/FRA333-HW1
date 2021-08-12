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
direction = 1;
dis_x = 1;
dis_y = 1;
P = [1.5;sqrt(3)/2]*d*(a_i(1,1)-1)+[-1.5;sqrt(3)/2]*d*(a_i(2,1)-1)+[0;sqrt(3)];
%     _ 1
% 6 /   \2
% 5 \ _ /3
%     4
current_position = a_i;
pre_position = [0;0];
A = a_i;
for i = 1:length(c)
    pre_position = current_position;
    if (c(i) == '1')
        current_position(1,1) = current_position(1,1)+dis_x;
        current_position(2,1) = current_position(2,1)+dis_y;
        if ~isempty(O)
            find_x = find(O(1,:)==current_position(1,1));
            find_y = find(O(2,:)==current_position(2,1));
             if isempty((intersect(find_y,find_x)))
                 A = [A current_position];
                 P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]];
             else
                 current_position = pre_position;
             end
        else
            A = [A current_position];
            P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]];
        end
        
    elseif (c(i) == '2')
            current_position(1,1) = current_position(1,1)-dis_x;
            current_position(2,1) = current_position(2,1)-dis_y;
        if ~isempty(O)
                    find_x = find(O(1,:)==current_position(1,1));
                    find_y = find(O(2,:)==current_position(2,1));
                     if isempty((intersect(find_y,find_x)))
                         A = [A current_position];
                         P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]];
                     else
                         current_position = pre_position;
                     end
                else
                    A = [A current_position];
                    P = [P [1.5;sqrt(3)/2]*d*(current_position(1,1)-1)+[-1.5;sqrt(3)/2]*d*(current_position(2,1)-1)+[0;sqrt(3)]];
        end
    elseif (c(i) == '4')
        direction = direction +1;
        if(direction == 7)
            direction = 1;
        end
    elseif (c(i) == '3')
        direction = direction - 1;
        if(direction == 0)
            direction = 6;
        end
    end
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

isequal(A,A)
if ~isempty(O)
    min_i = min([A(1,:) O(1,:)]);
    max_i = max([A(1,:) O(1,:)]);
    min_j = min([A(2,:) O(2,:)]);
    max_j = max([A(2,:) O(2,:)]);
else
    min_i = min(A(1,:));
    max_i = max(A(1,:));
    min_j = min(A(2,:));
    max_j = max(A(2,:));
end

d = 1;
clf;
ax = axes;
hold(ax,'on');
axis(ax,'equal')
hex = d/(2*sin(pi/6))*[cos(2*pi*[1:6 1]/6);sin(2*pi*[1:6 1]/6)];

%creat hex graph
for i = min_i:max_i
    hex_i = hex + [1.5;sqrt(3)/2]*d*(i-1);
    for j = min_j:max_j
        hex_ij = hex_i + [-1.5;sqrt(3)/2]*d*(j-1)+[0;sqrt(3)];
        plot(ax,hex_ij(1,:),hex_ij(2,:),'k','linewidth',3)
    end
end

%black walls
for k = 1:size(O,2)
    hex_ij = hex + [1.5;sqrt(3)/2]*d*(O(1,k)-1)+[-1.5;sqrt(3)/2]*d*(O(2,k)-1)+[0;sqrt(3)];
    patch(ax,hex_ij(1,:),hex_ij(2,:),[0,0,0])
end

%yellow path
for k = 1:size(A,2)
    hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,k)-1)+[-1.5;sqrt(3)/2]*d*(A(2,k)-1)+[0;sqrt(3)];
    patch(ax,hex_ij(1,:),hex_ij(2,:),'yellow')
end

%green hex at start point
hex_ij = hex + [1.5;sqrt(3)/2]*d*(a_i(1,1)-1)+[-1.5;sqrt(3)/2]*d*(a_i(2,1)-1)+[0;sqrt(3)];
patch(ax,hex_ij(1,:),hex_ij(2,:),'green')
start = hex_ij;

%red hex at final point
hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,end)-1)+[-1.5;sqrt(3)/2]*d*(A(2,end)-1)+[0;sqrt(3)];
patch(ax,hex_ij(1,:),hex_ij(2,:),'red')
final = hex_ij;

%blue travelling
for k = 1:size(A,2)
    hex_ij = hex + [1.5;sqrt(3)/2]*d*(A(1,k)-1)+[-1.5;sqrt(3)/2]*d*(A(2,k)-1)+[0;sqrt(3)];
    patch(ax,hex_ij(1,:),hex_ij(2,:),'blue')
    pause(0.1);
    if hex_ij == start
        patch(ax,hex_ij(1,:),hex_ij(2,:),'green')
    elseif hex_ij == final
        patch(ax,hex_ij(1,:),hex_ij(2,:),'red')
    else 
        patch(ax,hex_ij(1,:),hex_ij(2,:),'yellow')
    end
end

end