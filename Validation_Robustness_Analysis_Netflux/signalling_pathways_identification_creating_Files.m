
clc;
clear all;
close all;
%% address to read the data
VersionFile = 99;
It2reachSS = 20;
tmpF = VersionFile;

flg_inputVal = 2;
suff = '0p7';

subFolder = ['stimuli_',suff,'_E2_PG_TS_V8/'];
folder_to_save_files = ['signalling_pathways_identification_folder_V',num2str(VersionFile),'/',subFolder];

fname = ['Khorasani_Atrial_Fibroblast_Model_2026.xlsx'];

% define the path to read model files
pathname = ['models/'];
path2save = [folder_to_save_files];

%% define inputs and outputs
output_nodes = {'FA','CI', 'CIII','aSMA','PAI1','periostin','fibronectin',...
    'proliferation','CTGF','migration','EDAFN'};

output_up_nodes = {{'CDK1','B1int','Factin'},{'MMP1','MMP2','CImRNA'},...
    {'MMP1','MMP2','CIIImRNA'},{'SRF','CBP','smad3'},{'smad3'},...
    {'smad3','CBP','CREB'},{'smad3','CBP','NFKB'},...
    {'CDK1','CTGF','CREB','AP1','cmyc','PKC'},...
    {'ERK','smad3','CBP'},{'MMP2','MMP9','PKA','epac'},{'NFAT'}};
all_elements = [output_up_nodes{:}];
output_up_nodes_uniq = unique(all_elements);


input_nodes = {'AngII','TGFB','mechanical','IL6','IL1',...
    'TNFa','NE', 'PDGF','ET1',   ...
      'NP','Forskolin', ...
    'E2','TS',...
    'FGF23','ADL','LPS','BMP2','TNC'};

% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ')
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ')
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')
% disp('18,19: mechanical/mechanical+E2 ')
set_ = [1,2,4,5,6,8,10,11];

disp('1:FA ,2:CI, 3:CIII, 4:aSMA');
disp(['5:PAI1 ','6:periostin ','7:fibronectin']);
disp(['8:proliferation ','9:CTGF ','10:migration ','11:EDAFN ']);

flgBL = input('Do you load yCumBL? 1:yes 0: No(save)? ');

%% define the protocols
% conditions can be defined by:
% It2reachSS, y0_name, yo_ind, Ymax_ind, Ymax_val,  input values, high Vals
% inputs with feedback loop: AngII, TGFB, IL6, IL1, TNFa, ET1, FGF23, TNC
% high_Val = 0.7; 
% co =1;
BL = {40, [],[], [], [], [],[]};


%% just to load specID file
It2reachSSTMP = 1;
ind_equal_to_0_in_w = [];
indices_in_orig_w = ind_equal_to_0_in_w;
W_Mat = zeros(1,size(indices_in_orig_w,2));
[specID, ~,~, ~] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w, ...
            W_Mat, fname,pathname, It2reachSSTMP,0,[],0,[],[]);

% inpu and output indeces
outPut_indeces = findIndicesInSpecID(output_nodes,specID);
sz_out = size(outPut_indeces,2);
outPut_up_indeces = {};
for i=1:size(output_up_nodes,2)
    outPut_up_indeces{end+1} = findIndicesInSpecID(output_up_nodes{i},specID);
end
output_up_nodes_uniq_indeces = findIndicesInSpecID(output_up_nodes_uniq,specID);
sz_out_uniq = size(output_up_nodes_uniq_indeces,2);
input_indeces = findIndicesInSpecID(input_nodes,specID);
sz_inp = size(input_indeces,2);

%% run netflux in baseline condition
if flgBL==1
    fileNameTMP = [path2save,'yCumBL_V',num2str(VersionFile),'.mat'];
    load(fileNameTMP);
elseif flgBL==0
It2reachSSTMP = BL{1};

ind_equal_to_0_in_w = [];
indices_in_orig_w = ind_equal_to_0_in_w;
W_Mat = [];

[~, ~,~, yCumBL] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w, ...
            W_Mat, fname,pathname, It2reachSSTMP,0,[],0,[],[]);

fileNameTMP = [path2save,'yCumBL_V',num2str(VersionFile),'.mat'];
save(fileNameTMP, 'yCumBL');
% outPut_indecesTMP = [outPut_indeces,output_up_nodes_uniq_indeces];
% yCumBL = yCum(:,outPut_indecesTMP);

end

%% run netflux 
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ')
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ')
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')
for iiii=1:size(set_,2)
    it = set_(iiii);
    if flg_inputVal==1
        % determine conditions
        
        cond = signalling_pathways_identification_conditions_stimuli_0p5(it);

    else
        
        cond = signalling_pathways_identification_conditions_stimuli_0p7(it);
    end

for i=1:size(cond,2)
    % It2reachSS, y0_name, yo_ind, Ymax_ind, Ymax_val, input values, high Vals
    It2reachSSTMP = cond{i}{1};
    TMP = cond{i}{2}{1};
    lastValues_Mat = eval(TMP);
    lastValues_ = lastValues_Mat(cond{i}{3},:);
    node2pert = cond{i}{4};
    flgMx = double(~isempty(node2pert));
    if (flgMx == 0 )|| (flgMx == 1 && ismember(node2pert,input_nodes))
    yMax_ind = findIndicesInSpecID(node2pert,specID);
    yMax_val = cond{i}{5};
    
    indices_in_orig_w = [];
    W_Mat = [];
    W_Mat_sti = [cond{i}{7},W_Mat];
    [~,indTMP] = ismember(cond{i}{6},input_nodes);
    indices_in_orig_w_sti = [indTMP,indices_in_orig_w];

    
    [~,~,~, yCum] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w_sti, ...
    W_Mat_sti, fname,pathname, It2reachSSTMP,1,lastValues_,flgMx,yMax_ind,yMax_val);

    
    % outPut_indecesTMP = [outPut_indeces,output_up_nodes_uniq_indeces];
    % yCumBL = yCum(:,outPut_indecesTMP);
    if isempty(cond{i}{4})
        fileNameTMP = [path2save,'yCum_cond_',num2str(it),'_',cond{i}{4},'_',num2str(cond{i}{5}),'_V',num2str(VersionFile),'.mat'];
    else
        fileNameTMP = [path2save,'yCum_cond_',num2str(it),'_',cond{i}{4}{1},'_',num2str(cond{i}{5}),'_V',num2str(VersionFile),'.mat'];
    end
    save(fileNameTMP, 'yCum');
    end% isempty
end
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
