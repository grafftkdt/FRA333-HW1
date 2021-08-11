% FRA333_ID_ID_HW1.zip  รุ่น 6
% FRA333_ID_ID_c5_HW1.zip  รุ่น 5

main_dir = pwd;
hw_zip = dir(fullfile(pwd,'*.zip'));
file_name = {hw_zip.name};
testcase = cell(1,8);
grade = zeros(80,8,2);
for i = 1:8
    if i<10
        testcase{i} = sprintf('testcase_0%d',i);
    else
        testcase{i} = sprintf('testcase_%d',i);
    end
end
for i = 1:numel(file_name)
    name = file_name{i};
    if name(14)=='H'
        n = 2;
        class = 1;
    elseif name(14)=='c'
        n = 2;
        class = 2;
    else % numeric
        if name(17)=='H'
            n = 3;
            class = 1;
        elseif name(17)=='c'
            n = 3;
            class = 2;
        end
    end
    ID = sort([str2num(name([8 9])) str2num(name([11 12])) str2num(name([14 15]))]);

    try
        unzip(name,[num2str(class) sprintf('_%d',ID)])
        
        test_folder = [main_dir '\' [num2str(class) sprintf('_%d',ID)]];
        for j = 1:numel(testcase)
            load(testcase{j});
            cd(test_folder)
            try
                if ismember(j,[1 3 5 7])
                    O_t = O;
                else
                    O_t = [];
                end
                if ismember(j,[1 2 5 6])
                    c_t = c;
                else
                    c_t = '';
                end
                [A_test,P_test] = trackBeeBot(a_i,c_t,O_t);                
                isCorrect = all(abs(A-A_test)<0.00000001,'all');
                isCorrect = isCorrect && all(abs(P-P_test)<0.00000001,'all');
                
                for k = 1:numel(ID)
                    grade(ID(k),j,class) = isCorrect;
                end
            catch
                for k = 1:numel(ID)
                    grade(ID(k),j,class) = false;
                end
            end
            cd ..;
        end
    catch
        disp('error unzipping')
        disp([class ID])
        for k = 1:numel(ID)
            grade(ID(k),j,class) = false;
        end
    end
end

your_ID = 1;
class = 1;  % รุ่น 6
% class = 2; % รุ่น 5
weight = [5*ones(1,2) 0.5*ones(1,2) 5*ones(1,2) 0.5*ones(1,2) ];
homework_grade = (grade(your_ID,:,class)*weight')*10/sum(weight);
disp(sprintf('Your HW1 grade (ID==%d) is %.2f out of 10',your_ID,homework_grade));