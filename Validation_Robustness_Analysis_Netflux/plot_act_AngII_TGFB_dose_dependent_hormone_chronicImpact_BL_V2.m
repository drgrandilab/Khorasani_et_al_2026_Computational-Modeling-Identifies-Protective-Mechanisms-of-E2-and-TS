%% for V199,... AGT=>AngII
% I use this for E2/PG-TS signalling
% the protocol here: 
% BL: 120 h
% BL:48 h, and  high AngII: 72 h,
% BL:48 h, and  high AngII+E2: 72 h
% BL:48 h, and  high AngII+TS: 72 h
% BL:48 h, and  high AngII+PG: 72 h

clc;
clear all;
close all;
%% address to read the data
VersionFile = input('File Version: ');
It2reachSS = 20;

tmpF = VersionFile;

fname = ['nj_aFb_model_with hormones_',num2str(tmpF),'.xlsx'];
% input indecs to study
%1:AngII, 2:TGFB, 3:mechanical, \n' ...
%             ,'4: IL6, 5: IL1, 6: TNFa, 7: NE, 8: PDGF, 9: ET1, 10: NP, \n' ...
%             '11: Forskolin,
disp('1:AngII, 2:TGFB, 3:mechanical,');
disp('4: IL6, 5: IL1, 6: TNFa, 7: NE,');
disp('8: PDGF, 9: ET1, 10: NP, 11: Forskolin.');
inds = input('which input? ');

% define the path to read model files
pathname = '/Users/najmekhorasani/Library/CloudStorage/Dropbox/nj/myPrj/5-myofibroblasts/Netflux-master_Original/Netflux_NJ/models/';

%% define inputs and outputs
output_nodes = {'FA','CI', 'CIII','aSMA','PAI1','periostin','fibronectin',...
    'proliferation','CTGF','migration','EDAFN'};

flginp = input('1: E2, 2: E2,PG,TS Model?, 3: E2,TS Model ');
if flginp == 1
input_nodes = {'AGT','TGFB','mechanical','IL6','IL1',...
    'TNFa','NE', 'PDGF','ET1',   ...
      'NP','Forskolin', ...
    'E2',...
    'LPS','BMP2','TNC'};
elseif flginp==2
        input_nodes = {'AGT','TGFB','mechanical','IL6','IL1',...
    'TNFa','NE', 'PDGF','ET1',   ...
      'NP','Forskolin', ...
    'E2','PG','TS',...
    'FGF23','ADL','LPS','BMP2','TNC'};
elseif flginp==3
        input_nodes = {'AGT','TGFB','mechanical','IL6','IL1',...
    'TNFa','NE', 'PDGF','ET1',   ...
      'NP','Forskolin', ...
    'E2','TS',...
    'FGF23','ADL','LPS','BMP2','TNC'};
end

%% define consitions
TMP = input('1: 0.25, O.W: 0.7? ');
if TMP ==1
    high_Val = 0.25;
else
    high_Val = 0.7;
    % high_Val = 0.5;
end

disp('conditions shows: ');
disp('Which inputs (especially hormones) do you want to examine for dose-dependent behavior?');
input('have checked the conditions value? ');
TMP = input('enter the 2nd input to increase: E2, TS, PG? ');
[~,TMP2]=(ismember(TMP,input_nodes));
if isempty(TMP2)
    disp('MAKE SURE! the input is not correct!');
    exit();
end
conditions = [TMP2];

% condtions_Val = [[.5,.75,1]
%     [.5,.75,1]
%     [.5,.75,1]];
% condtions_Val = [[.4,.55,.7,.85,1]
%     [.4,.55,.7,.85,1]
%     [.4,.55,.7,.85,1]];
condtions_Val = [[0, .25, .5,.75,1]
    [0, .25, .5,.75,1]
    [0, .25, .5,.75,1]];
%% run netflux in baseline condition
It2reachSSTMP = It2reachSS*1;

ind_equal_to_0_in_w = [];
indices_in_orig_w = ind_equal_to_0_in_w;
W_Mat = zeros(1,size(indices_in_orig_w,2));

[specID, lastValuesBL,tCum, yCum] = Netflux_NJ_for_predefined_inp_and_y0_V2(indices_in_orig_w, ...
            W_Mat, fname,pathname, It2reachSSTMP,0,[]);

%% inpu and output indeces
outPut_indeces = findIndicesInSpecID(output_nodes,specID);
sz_out = size(outPut_indeces,2);
input_indeces = findIndicesInSpecID(input_nodes,specID);
sz_inp = size(input_indeces,2);

tCumBL_1 = tCum;
yCumBL_1 = yCum(:,outPut_indeces);

%% run netflux for Baseline
It2reachSS_TMP = It2reachSS * 1;

ind_equal_to_0_in_w = [];
indices_in_orig_w = ind_equal_to_0_in_w;
W_Mat = zeros(1,size(indices_in_orig_w,2));

[specID, ~,tCum, yCum] = Netflux_NJ_for_predefined_inp_and_y0_V2(indices_in_orig_w, ...
            W_Mat, fname,pathname, It2reachSS_TMP,1,lastValuesBL);
tCumBL_2 = tCum;
yCumBL_2 = yCum(:,outPut_indeces);
%% run netflux for high first input
W_Mat_sti = [high_Val,W_Mat];
indices_in_orig_w_sti = [inds,indices_in_orig_w];
 [~,~,tCum, yCum] = Netflux_NJ_for_predefined_inp_and_y0_V2(indices_in_orig_w_sti, ...
    W_Mat_sti, fname,pathname, It2reachSS_TMP,1,lastValuesBL);

tCumSti = tCum;
yCumSti = yCum(:,outPut_indeces);

%% run netflux for second high input

sz = size(conditions,2);
for i=1:sz
    vals = condtions_Val(i,:);
    sz2 = size(vals,2);
    for j=1:sz2
        W_Mat_sti = [high_Val,vals(j),W_Mat];
        indices_in_orig_w_sti = [inds,conditions(i),indices_in_orig_w];
         [~,lastValuesSti_2nd,tCum, yCum] = Netflux_NJ_for_predefined_inp_and_y0_V2(indices_in_orig_w_sti, ...
             W_Mat_sti, fname,pathname, It2reachSS_TMP,1,lastValuesBL);

         tCumTMP = tCum;
         yCumTMP = yCum(:,outPut_indeces);
         
         lastValues_mat{i,j} = yCumTMP;
    end
end

%% plotting
lstEnd = zeros(size(outPut_indeces,2),sz2);
for i=1:size(outPut_indeces,2)
    for j=1:sz
        figure;
        TMP = [yCumBL_1(end-240:end,i);yCumBL_2(:,i)];
        plot(TMP,LineWidth=3);
        hold on;
        TMP = [yCumBL_1(end-240:end,i);yCumSti(:,i)];
        plot(TMP,LineWidth=3);
        hold on;
        
        for k=1:sz2
            TMP = [yCumBL_1(end-240:end,i);lastValues_mat{j,k}(:,i)];
            plt = plot(TMP,LineWidth=3);
            hold on;
            lstEnd(i,k) = lastValues_mat{j,k}(end,i);
        end
        title(output_nodes{i});
        ylabel('Activity');
        xlabel('Time (h)');
        lgnd = {'Baseline',['high ',input_nodes{inds}]};
        for k=1:sz2
            lgnd{end+1} = [input_nodes{conditions(j)},': ',num2str(condtions_Val(j,k))];
        end
        legend(lgnd);
        ylim([0,1])
        yticks(0:.5:1);
        xlim([1,size(TMP,1)])
        xticks(0:240:size(TMP,1)-1);                % Set x-tick positions (match number of bars)
        set(gca,'FontSize',20);
        axis square
        saveas(gcf, ['Act_Chronic_',output_nodes{i},'_BL_',input_nodes{conditions(j)},'_',input_nodes{inds},'_AGT.svg'])
    end
end


%% ploting last values for each fibrotic marker 
for i=1:size(outPut_indeces,2)
figure;
TMP = lstEnd(i,:);
plot(TMP,'-o',LineWidth=2,MarkerSize=12);
title(output_nodes{i});
ylabel('Activity');
xlabel('Time (h)');
legend(input_nodes{inds});
ylim([0,1])
yticks(0:.5:1);
xlim([1,size(TMP,2)])
% xticks(0:240:size(TMP,1)-1);                % Set x-tick positions (match number of bars)
set(gca,'FontSize',20);
axis square
saveas(gcf, ['Act_Chronic_endpoint',output_nodes{i},'_BL_',input_nodes{conditions(j)},'_',input_nodes{inds},'.svg'])

end

function lastValues = readTXTfile(pathname4Data,fName,specIDToExtract,specID)
    % Specify the file path
    nfname = fullfile(pathname4Data,fName);
    nfilename = nfname; 

    % Read the data using importdata
    data = importdata(nfilename);


    % Initialize variables to store the last values
    lastValues = struct();

    % Extract the last values of specific factors
    for i = 1:numel(specIDToExtract)
        factorIndex = find(strcmp(specID, specIDToExtract{i}));
        factorData = data.data(factorIndex,:);
        lastValue = factorData(end);
        lastValues.(specIDToExtract{i}) = lastValue;
    end


end

function outPut_indeces = findIndicesInSpecID(output_nodes,specID)
    outPut_indeces = zeros(1, numel(output_nodes));  % Create an array to store indices
    for i = 1:numel(output_nodes)
        node = output_nodes{i};
        index = find(ismember(specID, node));  % Find the index for the current node
        outPut_indeces(i) = index;  % Store the index in the array
    end
end
