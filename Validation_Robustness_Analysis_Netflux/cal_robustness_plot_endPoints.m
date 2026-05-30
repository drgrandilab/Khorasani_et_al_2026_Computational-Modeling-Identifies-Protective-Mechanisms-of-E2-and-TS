clear all;
clc;
close all;

% cal_r_yCumMat1_: Ang/TGFB=0.7, E2/TS = 0
% cal_r_yCumMat2_: Ang/TGFB=0.7, E2/TS = 0.25
% cal_r_yCumMat3_: Ang/TGFB=0.7, E2/TS = 0.5
% cal_r_yCumMat4_: Ang/TGFB=0.7, E2/TS = 0.75
% cal_r_yCumMat5_: Ang/TGFB=0.7, E2/TS = 1.0

flg = input('1:inp, 2:W, 3: EC50? ');

flg_st = input('1:AngII, 2:TGFB? ');
flg_hr = input('1:E2, 2:TS ? ');

if flg_st ==1
    key1 = 'AngII';
    ind_st = 2;
else
    key1 = 'TGFB';
    ind_st = 21;
end
        
if flg_hr==1
    key2 = 'E2';
    ind_hr = 108;
else
    key2 = 'TS';
    ind_hr = 99;
end

if flg==1
    pst = 'inp';
elseif flg==2
    pst = 'W';
elseif flg==3
    pst = 'EC50';
end
nodes = {'CI','aSMA','PAI1','CTGF'};
nodesind = [90, 73, 77, 69];
disp(nodes);

% ctl
name = 'yCumMat1_';
TMP = ['cal_r_',name,pst,'_',key1,'_',key2,'.mat'];
load(['cal_robustness_data/',TMP]);
rosJNKMAt1 = eval(name);

% ctl
name = 'yCumMat2_';
TMP = ['cal_r_',name,pst,'_',key1,'_',key2,'.mat'];
load(['cal_robustness_data/',TMP]);
rosJNKMAt2 = eval(name);

% ctl
name = 'yCumMat3_';
TMP = ['cal_r_',name,pst,'_',key1,'_',key2,'.mat'];
load(['cal_robustness_data/',TMP]);
rosJNKMAt3 = eval(name);

% ctl
name = 'yCumMat4_';
TMP = ['cal_r_',name,pst,'_',key1,'_',key2,'.mat'];
load(['cal_robustness_data/',TMP]);
rosJNKMAt4 = eval(name);

name = 'yCumMat5_';
TMP = ['cal_r_',name,pst,'_',key1,'_',key2,'.mat'];
load(['cal_robustness_data/',TMP]);
rosJNKMAt5 = eval(name);

flgVarNo = 1;
mat1 = rosJNKMAt1(1:flgVarNo,1:end);
mat2 = rosJNKMAt2(1:flgVarNo,1:end);
mat3 = rosJNKMAt3(1:flgVarNo,1:end);
mat4 = rosJNKMAt4(1:flgVarNo,1:end);
mat5 = rosJNKMAt5(1:flgVarNo,1:end);


%% prepare data for plotting
for ii =1 :length(nodes)
% ind = find(ismember(specID,nodes{ii}));
ind = nodesind(ii);

szPop = length(mat2);

CurrValues1 = cellfun(@(x) x(end,ind), mat1);

CurrValues2 = cellfun(@(x) x(end,ind), mat2);

CurrValues3 = cellfun(@(x) x(end,ind), mat3);

CurrValues4 = cellfun(@(x) x(end,ind), mat4);

CurrValues5 = cellfun(@(x) x(end,ind), mat5);


% Put matrices in a cell array
M = {CurrValues1, CurrValues2, CurrValues3, CurrValues4, CurrValues5};

figure; hold on; box on;

boxWidth = 0.12;

for i = 1:numel(M)   % number of matrix groups
    
    nRows = size(M{i}, 1);   % number of rows in this matrix
    
    % create centered offsets depending on number of rows
    if nRows == 1
        offsets = 0;
    else
        offsets = linspace(-0.35, 0.35, nRows);
    end%%%%%%%%%%%%%%%%%%%
    
    for r = 1:nRows
        
        data = M{i}(r, :);
        data = data(~isnan(data));  % remove NaN values
        
        % Sort data
        data_sorted = sort(data);
        n = numel(data_sorted);
        
        % Manual quartiles without Statistics Toolbox
        q1  = interp1(1:n, data_sorted, 0.25*(n-1)+1);
        med = interp1(1:n, data_sorted, 0.50*(n-1)+1);
        q3  = interp1(1:n, data_sorted, 0.75*(n-1)+1);
        
        ymin = min(data_sorted);
        ymax = max(data_sorted);
        
        x = i + offsets(r);
        
        % Draw box
        rectangle('Position', [x-boxWidth/2, q1, boxWidth, q3-q1], ...
                  'EdgeColor', 'k', 'LineWidth', 1.2);
        
        % Draw median line
        plot([x-boxWidth/2, x+boxWidth/2], [med, med], ...
             'k-', 'LineWidth', 1.5);
        
        % Draw whiskers
        plot([x, x], [ymin, q1], 'k-', 'LineWidth', 1.1);
        plot([x, x], [q3, ymax], 'k-', 'LineWidth', 1.1);
        
        % Draw whisker caps
        plot([x-boxWidth/3, x+boxWidth/3], [ymin, ymin], ...
             'k-', 'LineWidth', 1.1);
        plot([x-boxWidth/3, x+boxWidth/3], [ymax, ymax], ...
             'k-', 'LineWidth', 1.1);
        
        % Actual data points as empty circles
        jitter = 0.025 * randn(size(data_sorted));
        plot(x + jitter, data_sorted, 'ko', ...
             'MarkerSize', 4, ...
             'MarkerFaceColor', 'none');
    end
end

xlim([0.5 5.5])
xticks(1:5)
xticklabels({'0','0.25','0.5','0.75','1'})

xlabel([key2,' levels'])
ylabel('Activity Level')
title(['robustness of model to ',pst,' on ', nodes{ii},' under high ', key1])

% legend({'Data points'}, 'Location', 'best')
ax = gca;
% axis('square'); 
ylim([0,1.5]);
yticks(0:.5:1);
fig = gcf;
set(gca, 'FontSize', 20)

hold off;

if flg==1
    namee = ['cal_endP_inp_',nodes{ii},'_varp',num2str(flgVarNo),'_',key1,'_',key2,num2str(randi(1000)),'.svg'];
elseif flg==2
    namee = ['cal_endP_W_',nodes{ii},'_varp',num2str(flgVarNo),'_',key1,'_',key2,num2str(randi(1000)),'.svg'];
elseif flg==3
    namee = ['cal_endP_EC50_',nodes{ii},'_varp',num2str(flgVarNo),'_',key1,'_',key2,num2str(randi(1000)),'.svg'];
end

% print(fig, namee, '-dsvg');
end