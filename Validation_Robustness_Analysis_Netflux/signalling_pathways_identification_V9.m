clc;
clear all;
close all;
%% PAY ATTENTION
% BEFORE RUNING THIS CODE, YOU NEED TO BE SURE THAT IN THE MODEL EXCEL
% FILE, THERE IS NO DOUBLE SPACE BETWEEN THE NODES ('  ') IN THE REACTION 
% LIST, AND BE SURE THAT
% '!' IS NOT SEPERATED FROM ITS CORRESPONDING NODE
%%%%%%%%%%%%%%%%%%%
%% define parametrs
% model file version
thr_delta_Act = 0.1; 

codeV = 8;
% the time we need to keep a imput node with feedback loop after a input stimuli
% input => receptor => intermediate => input again =>...
% and each time step in netflux is 0.1 so we reach 0.5
time_FL_thr = 5;

% Ctl condition
disp('0: Baseline');
disp('1: AngII, 2: AngII+E2, 4:AngII+TS, ');
disp('5: TGFB, :TGFB+E2, 8:TGFB+TS, ');
ctl_cond = input('choose the Ctl condition: ');

% perturbed condition
disp('0: Baseline');
disp('1: AngII, 2: AngII+E2, 4:AngII+TS, ');
disp('5: TGFB, 6:TGFB+E2, 8:TGFB+TS, ');
pert_cond = input('choose the perturbed condition: ');

inp_nodes_pert = what_pert_cond(pert_cond);

target_node = input('choose your target node, Ca, CI, CIII, ... ?');

% subconditions based on "cond = signalling_pathways_identification_conditions(flg)"
% disp('1: NA, 2: TGFB: .1, 3:TGFB: 1.5,  4:IL6: .1, 5:IL6: 1.5,  6:IL1: .1');
% disp('7:IL1: 1.5,  8:TNFa: .1, 9:TNFa: 1.5, 10:ET1: .1, 11:ET1: 1.5, ');
% disp('12:FGF23: .1, 13:FGF23: 1.5, 14:TNC: .1, , 15:TNC: 1.5');
% pert_cond_sub = input('choose the sub_condition for perturbrd condition: ');
subconditions = {'TGFB','IL6','IL1', 'TNFa', 'ET1', 'FGF23', 'TNC'};

% folder_to_load_files
suff = '0p7';
VersionFile = 99;

subFolder = ['stimuli_',suff,'_E2_PG_TS_V',num2str(codeV),'/'];
folder_to_load_files = ['signalling_pathways_identification_folder_V',num2str(VersionFile),'/',subFolder];

% model file name
fname = ['Khorasani_Atrial_Fibroblast_Model_2026.xlsx'];

% define the path to read model files
pathname = ['models/'];
path2save = [folder_to_load_files];

% define inputs and outputs
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
    'E2','PG','TS',...
    'FGF23','ADL','LPS','BMP2','TNC'};
input_No = size(input_nodes,2);

%% file names to load based on desired conditions
% to load Ctl cond
if ctl_cond==0
    fileNameTMP = [path2save,'yCumBL_V',num2str(VersionFile),'.mat'];
    load(fileNameTMP);
    yCum_Ctl = yCumBL;

    time_to_capture_Ctl = (120+72)*10+1;
    time_to_capture_pert = 72*10+1;
    time_to_capture_pert_early = 10*10+1;
else
    % ctl_cond_cell = signalling_pathways_identification_conditions(ctl_cond);
    ctl_cond_sub = 1;
    fileNameTMP = [path2save,'yCum_cond_',num2str(ctl_cond),'_','_','_V',num2str(VersionFile),'.mat'];
    load(fileNameTMP);
    yCum_Ctl = yCum;
    time_to_capture_Ctl = 72*10+1;
    time_to_capture_pert = 72*10+1;
    time_to_capture_pert_early = 10*10+1;
end
time_to_capture_BL = 1201;

% to load perturbed condition
% pert_cond_cell = signalling_pathways_identification_conditions(pert_cond);
fileNameTMP = [path2save,'yCum_cond_',num2str(pert_cond),'_','_','_V',num2str(VersionFile),'.mat'];
load(fileNameTMP);
yCum_pert = yCum;

%% just to load specID file
It2reachSSTMP = 1;
ind_equal_to_0_in_w = [];
indices_in_orig_w = ind_equal_to_0_in_w;
W_Mat = zeros(1,size(indices_in_orig_w,2));
[specID, ~,~, ~,~] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w, ...
            W_Mat, fname,pathname, It2reachSSTMP,0,[],0,[],[]);

specID_orig = specID;
%% determine the nodes whose activity changes leass than thr_delta_Act 
% between Ctl and stusied perturbation
% in steady state
delta_Act_TMP = yCum_pert(time_to_capture_pert,:) - yCum_Ctl(time_to_capture_Ctl,:);
[~, indToDel] = find(abs(delta_Act_TMP)<=thr_delta_Act);

indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
    indToDel,target_node,VersionFile,path2save,specID);

indToDel = indToDel_upd;

% early after perturbation
indToDel_early = delta_Act_early(yCum_pert,time_to_capture_pert_early,...
    yCum_Ctl,time_to_capture_Ctl,thr_delta_Act,indToDel,delta_Act_TMP);

if length(indToDel)~=length(indToDel_early)
    diff_ = setdiff(indToDel,indToDel_early);
    disp(specID_orig{diff_});
    flgT = input('1: keep the updated one!');
    if flgT == 1
        indToDel = indToDel_early;
    end
end

%% read the model file
mat_species = readtable([pathname,fname], 'Sheet', 'species');
mat_reactions = readtable([pathname,fname], 'Sheet', 'reactions');
% [~,~,mat_species] = xlsread([pathname,fname], 'species');%, 'A:F');
% [~,~,mat_reactions] = xlsread([pathname,fname], 'reactions');%, 'A:F');
reaction_rules_orig = mat_reactions.Rule;
reaction_rules_id_orig = mat_reactions.ID;
reaction_rules = reaction_rules_orig;
reaction_rules_id = reaction_rules_id_orig;

%% the nodes whose activity changes leass than thr_delta_Act 
% determine nodes cannot be removed (input, target or directly connected nodes to target node)
[not2beremoved_nodes] = determine_not2beremoved_nodes(ctl_cond,...
    pert_cond,output_nodes,output_up_nodes,target_node,path2save,VersionFile,0);

% remove unwanted nodes and reactions
[reaction_rules,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indToDel,...
    reaction_rules,reaction_rules_id,...
    specID,not2beremoved_nodes,input_nodes,output_nodes);

if ~isempty(newNode2remove)
    newNode2remove = unique(newNode2remove, 'stable');
    indToDel = find(ismember(specID,newNode2remove));
    %%%%% V8 %%%%%%
    indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
    indToDel,target_node,VersionFile,path2save,specID);
    indToDel = indToDel_upd;
    %%%%%%%%%%%%%%%
    while ~isempty(newNode2remove)
        [reaction_rules,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indToDel,...
            reaction_rules,reaction_rules_id,...
        specID,not2beremoved_nodes,input_nodes,output_nodes);
        if ~isempty(newNode2remove)
            newNode2remove = unique(newNode2remove, 'stable');
            indToDel = find(ismember(specID,newNode2remove));
            %%%%% V8 %%%%%%
            indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
            indToDel,target_node,VersionFile,path2save,specID);
            indToDel = indToDel_upd;
            %%%%%%%%%%%%%%%
        end
    end
end

% to create updated tables
mask = ismember(reaction_rules_id_orig, reaction_rules_id);
TMP = mat_reactions;
TMP.Rule(mask~=0) = reaction_rules;
filtered_reactions = [TMP(mask~=0, :)];
% reaction_rules_id = modifyInputReactions(reaction_rules_id);
filtered_reactions.ID = reaction_rules_id;
mask = ismember(specID_orig, specID);
filtered_species = [mat_species(mask~=0, :)];

% counterFile = 1;
% % write in an excel file
% filename = [num2str(counterFile),'.xlsx'];
% write_an_excel_file(filename,filtered_species,filtered_reactions);counterFile=counterFile+1;

%% remove the output nodes with no path to the target node
indToDel = [];
for i=1:size(output_nodes,2)
    TMP = find(ismember(specID,output_nodes{i}));
    if ~isempty(TMP)
        node_src = output_nodes{i};
        flg_all_path = 0;
        input_No = length(find(ismember(specID,input_nodes)));
        [graph , shortest_path,path_no] = path_dGraph_shortPAth_func(filtered_species,filtered_reactions,...
        input_No,node_src,target_node,flg_all_path);
        if isempty(shortest_path)
            indToDel = [indToDel;TMP];
        end
    end
end

% determine nodes cannot be removed (input, target or directly connected nodes to target node)
[not2beremoved_nodes] = determine_not2beremoved_nodes(ctl_cond,...
    pert_cond,output_nodes,output_up_nodes,target_node,path2save,VersionFile,0);
% remove unwanted nodes and reactions
[reaction_rules,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indToDel,...
    reaction_rules,reaction_rules_id,...
    specID,not2beremoved_nodes,input_nodes,output_nodes);

if ~isempty(newNode2remove)
    newNode2remove = unique(newNode2remove, 'stable');
    indToDel = find(ismember(specID,newNode2remove));
    %%%%% V8 %%%%%%
    indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
    indToDel,target_node,VersionFile,path2save,specID);
    indToDel = indToDel_upd;
    %%%%%%%%%%%%%%%
    while ~isempty(newNode2remove)
        [reaction_rules,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indToDel,...
            reaction_rules,reaction_rules_id,...
        specID,not2beremoved_nodes,input_nodes,output_nodes);
        if ~isempty(newNode2remove)
            newNode2remove = unique(newNode2remove, 'stable');
            indToDel = find(ismember(specID,newNode2remove));
            %%%%% V8 %%%%%%
            indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
            indToDel,target_node,VersionFile,path2save,specID);
            indToDel = indToDel_upd;
            %%%%%%%%%%%%%%%
        end
    end
end

% to create updated tables
mask = ismember(reaction_rules_id_orig, reaction_rules_id);
TMP = mat_reactions;
TMP.Rule(mask~=0) = reaction_rules;
filtered_reactions = [TMP(mask~=0, :)];
% reaction_rules_id = modifyInputReactions(reaction_rules_id);
filtered_reactions.ID = reaction_rules_id;
mask = ismember(specID_orig, specID);
filtered_species = [mat_species(mask~=0, :)];

% %% write in an excel file
% filename = [num2str(counterFile),'.xlsx'];
% write_an_excel_file(filename,filtered_species,filtered_reactions);counterFile=counterFile+1;


%% to check the  remaining input nodes' impact
% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')

% ('1: NA, 2: TGFB: .1, 3:TGFB: 1.5,  4:IL6: .1, 5:IL6: 1.5,  6:IL1: .1');
% ('7:IL1: 1.5,  8:TNFa: .1, 9:TNFa: 1.5, 10:ET1: .1, 11:ET1: 1.5, ');
% ('12:FGF23: .1, 13:FGF23: 1.5, 14:TNC: .1, , 15:TNC: 1.5');

[~,target_ID]=ismember(target_node,specID_orig);
% determine the target node and its upstream nodes' indeces
nodes2study = [target_ID];
TMP = find(ismember(output_nodes,target_node));
[indTMP,~] = find(ismember(specID_orig,output_up_nodes{TMP}));
nodes2study = [nodes2study ; indTMP];


% to find nodes whose KD/OE does not change target node
% saved in indToDel_V
indToDel_V =[];
indToDel_V_early =[];
existing_inp = [];
for i=1:size(subconditions,2)
    sub_cond = subconditions{i};
    subcond_ind = find(ismember(specID,sub_cond));
    if ~isempty(subcond_ind)
        existing_inp = [existing_inp, subcond_ind];
        % load files:
        fileNameTMP = [path2save,'yCum_cond_',num2str(pert_cond),'_',sub_cond,'_0.1_V',num2str(VersionFile),'.mat'];
        load(fileNameTMP);
        yCum_pert_KD = yCum;

        fileNameTMP = [path2save,'yCum_cond_',num2str(pert_cond),'_',sub_cond,'_1.5_V',num2str(VersionFile),'.mat'];
        load(fileNameTMP);
        yCum_pert_OE = yCum;

        % to capture delta changes in SS
        delta_Act_KD = yCum_pert(time_to_capture_pert,nodes2study) - yCum_pert_KD(time_to_capture_pert,nodes2study);
        delta_Act_OE = yCum_pert(time_to_capture_pert,nodes2study) - yCum_pert_OE(time_to_capture_pert,nodes2study);
        deltaTMP = [delta_Act_KD,delta_Act_OE];
        [~, indTmp] = find(abs(deltaTMP) > thr_delta_Act);        
        if isempty(indTmp)
            indToDel_V = [indToDel_V  ; subcond_ind];
        end
    end
end

%  to find the time when the first steepest slope (maximum rate of change) happens
indToDel_T = determine_removed_inp_by_time_of_dch_after_pert(...
    yCum_pert,subconditions,specID_orig,specID,pert_cond,time_FL_thr);

% common elemens time-wise and value-wise
indToDel_T_V = intersect(indToDel_V, indToDel_T);
disp('list of the nodes deleted because of the delay!');
disp(specID(indToDel_T_V)');
disp('if face any complications later in analysis of pathways,');
disp('you can always reconsider these nodes later...');
disp('======================');

% finding the inputs with feedback loop to any node other than input node
% 1. nodes whose KD/OE has impact on target node
% diff = setdiff(existing_inp, indToDel');

% to find the model without nodes in indToDel (nodes whose KD/OE has no
% impact on target node). But these nodes we may need to keep (if they 
% activate a node dowstream other than the inp). 
% to update the model temprary
specIDT = make_temp_model(indToDel_V,ctl_cond,...
            pert_cond,output_up_nodes,target_node,path2save,...
            VersionFile,...
            reaction_rules,reaction_rules_id,...
            specID,input_nodes,output_nodes,...
            delta_Act_TMP, target_ID,specID_orig);

% to find the path from each candidate node to the target node
% we look for this shortest path in the model with all inputs

% to find a shortest path from any inputs with feedback loop to any nodes
% in the temprerry model
% this list shows potential and determined nodes to be deleted
indToDel_p = setdiff(indToDel_V,indToDel_T);

indToDel_shortPaths = find_short_path_to_TMP_model(indToDel_p,specID,...
    input_nodes,target_node,filtered_species,filtered_reactions,...
    specIDT,inp_nodes_pert);

%%%%%%%% V9 %%%%%%%%%
%here in this versionI do not remove input nodes with delay and 
% the ones whose KD/OE does not change the target node
indToDel_T_V = []; 
%%%%%%%%%%%%%%%%%%%%%
indToDel = [indToDel_T_V;indToDel_shortPaths];
%%%%% V8 %%%%%%
indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
indToDel,target_node,VersionFile,path2save,specID);
indToDel = indToDel_upd;
%%%%%%%%%%%%%%%
if ~isempty(indToDel)
    % determine nodes cannot be removed (input, target or directly connected nodes to target node)
    [not2beremoved_nodes] = determine_not2beremoved_nodes(ctl_cond,...
        pert_cond,output_nodes,output_up_nodes,target_node,path2save,VersionFile,1);
    % remove unwanted nodes and reactions
    [reaction_rules,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indToDel,...
        reaction_rules,reaction_rules_id,...
        specID,not2beremoved_nodes,input_nodes,output_nodes);
    
    if ~isempty(newNode2remove)
        newNode2remove = unique(newNode2remove, 'stable');
        indToDel = find(ismember(specID,newNode2remove));
        %%%%% V8 %%%%%%
        indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
        indToDel,target_node,VersionFile,path2save,specID);
        indToDel = indToDel_upd;
        %%%%%%%%%%%%%%%
        while ~isempty(newNode2remove)
            [reaction_rules,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indToDel,...
                reaction_rules,reaction_rules_id,...
            specID,not2beremoved_nodes,input_nodes,output_nodes);
            if ~isempty(newNode2remove)
                newNode2remove = unique(newNode2remove, 'stable');
                indToDel = find(ismember(specID,newNode2remove));
                %%%%% V8 %%%%%%
                indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
                indToDel,target_node,VersionFile,path2save,specID);
                indToDel = indToDel_upd;
                %%%%%%%%%%%%%%%
            end
        end
    end
    
    % to create updated tables
    mask = ismember(reaction_rules_id_orig, reaction_rules_id);
    TMP = mat_reactions;
    TMP.Rule(mask~=0) = reaction_rules;
    filtered_reactions = [TMP(mask~=0, :)];
    % reaction_rules_id = modifyInputReactions(reaction_rules_id);
    filtered_reactions.ID = reaction_rules_id;
    mask = ismember(specID_orig, specID);
    filtered_species = [mat_species(mask~=0, :)];
end

%% te remove nodes whose activity and reaction is not in the same direction 
% of the target nodes' delta activity
% inpu and output indeces
target_sign = delta_Act_TMP(target_ID);

[reaction_rules,reaction_rules_id,specID,newNode2remove,...
    newNode2removeBUTdidnt] = remove_reactions_notagreed(...
    reaction_rules,reaction_rules_id,...
    specID,not2beremoved_nodes,...
    input_nodes,output_nodes,specID_orig,delta_Act_TMP);

 if ~isempty(newNode2remove)
    newNode2remove = unique(newNode2remove, 'stable');
    indToDel = find(ismember(specID,newNode2remove));
    %%%%% V8 %%%%%%
    indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
    indToDel,target_node,VersionFile,path2save,specID);
    indToDel = indToDel_upd;
    %%%%%%%%%%%%%%%
    while ~isempty(newNode2remove)
        [reaction_rules,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indToDel,...
            reaction_rules,reaction_rules_id,...
        specID,not2beremoved_nodes,input_nodes,output_nodes);
        if ~isempty(newNode2remove)
            newNode2remove = unique(newNode2remove, 'stable');
            indToDel = find(ismember(specID,newNode2remove));
            %%%%% V8 %%%%%%
            indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
            indToDel,target_node,VersionFile,path2save,specID);
            indToDel = indToDel_upd;
            %%%%%%%%%%%%%%%
        end
    end
end
    
% to create updated tables
mask = ismember(reaction_rules_id_orig, reaction_rules_id);
TMP = mat_reactions;
TMP.Rule(mask~=0) = reaction_rules;
filtered_reactions = [TMP(mask~=0, :)];
% reaction_rules_id = modifyInputReactions(reaction_rules_id);
filtered_reactions.ID = reaction_rules_id;
mask = ismember(specID_orig, specID);
filtered_species = [mat_species(mask~=0, :)];

%%to recognize the nodes with feedback loop to the input nodes we are studying
indToDel = [];
[flg_fbk , inp] = find_if_input_has_feedback_connection(pert_cond,subconditions);
if flg_fbk==1
    % find the nodes cone=nected as a feedback loop to input node
    candidateNodes2remove = find_feedbackLoop_nodes(...
    inp,reaction_rules,reaction_rules_id);
    candidateNodes2remove = unique(candidateNodes2remove);
    disp('nodes with feedback lopp to the input node:')
    disp(candidateNodes2remove);
end

if (input('Do you wanna save files (1:yes)? '))==1
% write in an excel file
filename = ['sigPath_File_condCtl_',num2str(ctl_cond),'_condPert_',...
    num2str(pert_cond),'_target_',target_node,'_V',num2str(VersionFile),'_V3'];
file_model = [filename,'.xlsx'];
file_ = [path2save,file_model];
write_an_excel_file(file_,filtered_species,filtered_reactions);

%% to creat xgmml file for cytoscape
disp('Have you opened and saved and closed the created model?');
inpTMP = input('I wait for you to do it and press 1 (1:yes)');
if inpTMP==1
    It2reachSSTMP = 1;
    ind_equal_to_0_in_w = [];
    indices_in_orig_w = ind_equal_to_0_in_w;
    W_Mat = zeros(1,size(indices_in_orig_w,2));
    
    [specID, ~,~, ~,CNAmodel] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w, ...
                W_Mat, file_model,path2save, It2reachSSTMP,0,[],0,[],[]);
    outputfname = [path2save,filename,'.xgmml'];
    util.Netflux2xgmml(CNAmodel, outputfname);
end
end

%% to display the nodes were supposed to remove, as their changes were not
% aligned, but they were not removed because they already exist in the
% activating pathways
disp("Nodes were supposed to remove but were not:");
disp(newNode2removeBUTdidnt);

%% to determine the nodes with only inhibitory connections (with no activatory connections)
% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')
disp('Nodes with no activatory inputs:');
if ((ctl_cond ==1 && (pert_cond==2 || pert_cond==3 || pert_cond==4 || pert_cond==16)) ||...
        (ctl_cond ==5 && (pert_cond==6 || pert_cond==7 || pert_cond==8 || pert_cond==17)) || ...
        (ctl_cond ==12 && (pert_cond==13 || pert_cond==14 || pert_cond==15)) )

    filenameT = ['sigPath_File_condCtl_0_condPert_',...
    num2str(ctl_cond),'_target_',target_node,'_V',num2str(VersionFile),'_V3'];
    file_model = [filenameT,'.xlsx'];
    file_ = [path2save,file_model];
    mat_speciesT = readtable(file_, 'Sheet', 'species');
    SpecTMP = mat_speciesT.ID;

    % Find elements in cell1 that are not in cell2
    diff_nodes = setdiff(specID,SpecTMP);
    delims = {' ', '&', '=>', '+', '!'}; 
    for i=1:size(diff_nodes,1)
        key = diff_nodes{i};
        flgT = 0;
        if ~ismember(key,input_nodes)
            for j=1:size(reaction_rules,1)
                if flgT==1
                    break;
                end
            s = reaction_rules{j};
            %modify the s
            % Step 1: Ensure one space around each '&'
            s = regexprep(s, '\s*&\s*', ' & ');
            % Step 2: Also normalize around '+' if needed
            s = regexprep(s, '\s*\+\s*', ' + ');
            % Step 3: Also normalize around '=>' if needed
            s = regexprep(s, '\s*=>\s*', ' => ');

            parts = strsplit(s, '=>');
            rightSide = parts{2};
            tokensRight = strsplit(strtrim(rightSide), delims);
            if any(strcmp(tokensRight, key))
                % Split into tokens using all delimiters
                tokens_raw = regexp(s, '[^ &!+=>]+', 'match');
                tokens_ = regexp(s, '[^ &+=>]+', 'match'); 
                token_all = split(s,' ')';
                for k=1:size(tokens_,2)-1
                    if ~contains(tokens_{k}, '!')
                        flgT = 1;
                    end
                end
            end
            end
            if flgT==0
                node_dest = key;
                if ctl_cond ==1 
                    node_src = 'AngII';
                elseif ctl_cond ==5
                    node_src = 'TGFB';
                elseif ctl_cond ==12
                    node_src = 'ET1';
                end
                flg_all_path = 0;
                input_No = length(find(ismember(specID,input_nodes)));
                [graph , shortest_path,path_no] = path_dGraph_shortPAth_func(mat_species,mat_reactions,...
                input_No,node_src,node_dest,flg_all_path);
                if isempty(shortest_path)
                     disp(key);
                else
                    disp(shortest_path);
                end

               
            end
        end
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function definitions

function indToDel_upd = determine_indToDel_based_on_conds(ctl_cond ,pert_cond,...
    indToDel,target_node,VersionFile,path2save,specID)
indToDel_upd = indToDel;
% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')
if (pert_cond==2 || pert_cond==3 || pert_cond==4 || pert_cond==16 || ...
        pert_cond==6 || pert_cond==7 || pert_cond==8 || pert_cond==17)
            
        filenameT = ['sigPath_File_condCtl_0_condPert_',...
        num2str(ctl_cond),'_target_',target_node,'_V',num2str(VersionFile),'_V3'];
        file_model = [filenameT,'.xlsx'];
        file_ = [path2save,file_model];
        mat_speciesT = readtable(file_, 'Sheet', 'species');
        SpecTMP = mat_speciesT.ID;
        [~, ind] = ismember(SpecTMP,specID);
        inters = ismember(indToDel,ind);
        if ~isempty(inters)
        indToDel(inters) = [];
        end
end
indToDel_upd = indToDel;
end

function  nodes = what_pert_cond(pert_cond)
% to determine perturbed condition
% % perturbed condition
% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')
nodes = {};
if pert_cond ==1 || pert_cond ==2 || pert_cond ==3 || pert_cond ==4 || pert_cond ==16
    nodes{end+1} = 'AngII';
end
if pert_cond ==5 || pert_cond ==6 || pert_cond ==7 || pert_cond ==8 || pert_cond ==17
    nodes{end+1} = 'TGFB';
end
if pert_cond ==12 || pert_cond ==13 || pert_cond ==14 || pert_cond ==15
    nodes{end+1} = 'ET1';
end
if pert_cond ==2 || pert_cond ==6 || pert_cond ==11 || pert_cond ==13 || pert_cond ==16 || pert_cond ==17
    nodes{end+1} = 'E2';
end
if pert_cond ==3 || pert_cond ==7 || pert_cond ==9 || pert_cond ==14
    nodes{end+1} = 'PG';
end
if pert_cond ==4 || pert_cond ==8 || pert_cond ==10 || pert_cond ==15
    nodes{end+1} = 'TS';
end
end
% to find a shortest path from any inputs with feedback loop to any nodes
% in the temprerry model
function indToDelT = find_short_path_to_TMP_model(indToDel,specID,...
    input_nodes,target_node,filtered_species,filtered_reactions,...
    specIDT,inp_nodes_pert)

indToDelT = [];
for i=1:size(indToDel,1)
    TMP = indToDel(i);
    node_src = specID{TMP};
    flg_all_path = 0;
    input_No = length(find(ismember(specID,input_nodes)));
    
    mn = 1000;%%%%%%%%%%%%
    for j=1:size(specIDT,1)%%%%%%%%%%
        target_ = specIDT{j};%%%%%%%%%%%%%%
        if ~strcmp(target_,target_node)% I do not wanna consider target node
        [~ , shortest_path1,~] = path_dGraph_shortPAth_func(filtered_species,filtered_reactions,...
        input_No,node_src,target_,flg_all_path);
        [~ , shortest_path2,~] = path_dGraph_shortPAth_func(filtered_species,filtered_reactions,...
        input_No,target_,target_node,flg_all_path);
        shortest_path = [shortest_path1,shortest_path2(2:end)];
        % if ~isempty(find(ismember(shortest_path,specIDT)))
        if length(shortest_path) < mn
            shortest_path_chosen = shortest_path;
            mn = length(shortest_path);
        end
        % end
        end
    end

    % we need to check if the current inp is connected to any node from the
    % temprery model (specT model which only have the nodes whose KD/OE has 
    % impact on target node)

    % Loop to find the first match
    firstMatch = '';
    for ii = 1:length(shortest_path_chosen)
        if any(strcmp(shortest_path_chosen{ii}, specIDT))
            firstMatch = shortest_path_chosen{ii};
            break;  % stop at first match
        end
    end
    if ~isempty(firstMatch) && ~isempty(find(ismember(firstMatch,inp_nodes_pert)))
        indToDelT = [indToDelT, indToDel(i)];
    end
    % end
end

end% function
% make a temprary model
function specIDT = make_temp_model(indToDel,ctl_cond,...
            pert_cond,output_up_nodes,target_node,path2save,...
            VersionFile,...
            reaction_rules,reaction_rules_id,...
            specID,input_nodes,output_nodes,...
            delta_Act_TMP, target_ID,specID_orig)
    specIDT = specID;
    if ~isempty(indToDel)
        % determine nodes cannot be removed (input, target or directly connected nodes to target node)
        [not2beremoved_nodesT] = determine_not2beremoved_nodes(ctl_cond,...
            pert_cond,output_nodes,output_up_nodes,target_node,path2save,VersionFile,1);
        % remove unwanted nodes and reactions
        [reaction_rulesT,reaction_rules_idT,specIDT,newNode2removeT] = remove_nodes_reactions(indToDel,...
            reaction_rules,reaction_rules_id,...
            specID,not2beremoved_nodesT,input_nodes,output_nodes);
        
        if ~isempty(newNode2removeT)
            newNode2removeT = unique(newNode2removeT, 'stable');
            indToDelT = find(ismember(specIDT,newNode2removeT));
            while ~isempty(newNode2removeT)
                [reaction_rulesT,reaction_rules_idT,specIDT,newNode2removeT] = remove_nodes_reactions(indToDelT,...
                    reaction_rulesT,reaction_rules_idT,...
                specIDT,not2beremoved_nodesT,input_nodes,output_nodes);
                if ~isempty(newNode2removeT)
                    newNode2removeT = unique(newNode2removeT, 'stable');
                    indToDelT = find(ismember(specIDT,newNode2removeT));
                end
            end
        end

    %% te remove nodes whose activity and reaction is not in the same direction 
        % of the target nodes' delta activity
        % inpu and output indeces
        target_sign = delta_Act_TMP(target_ID);
        
        [reaction_rulesT,reaction_rules_idT,specIDT,newNode2removeT,...
            newNode2removeBUTdidnt] = remove_reactions_notagreed(...
            reaction_rulesT,reaction_rules_idT,...
            specIDT,not2beremoved_nodesT,...
            input_nodes,output_nodes,specID_orig,delta_Act_TMP);
        
         if ~isempty(newNode2removeT)
            newNode2removeT = unique(newNode2removeT, 'stable');
            indToDel = find(ismember(specIDT,newNode2removeT));
            while ~isempty(newNode2removeT)
                [reaction_rulesT,reaction_rules_idT,specIDT,newNode2removeT] = remove_nodes_reactions(indToDel,...
                    reaction_rulesT,reaction_rules_idT,...
                specIDT,not2beremoved_nodesT,input_nodes,output_nodes);
                if ~isempty(newNode2removeT)
                    newNode2removeT = unique(newNode2removeT, 'stable');
                    indToDel = find(ismember(specIDT,newNode2removeT));
                end
            end
         end

    end
end

function indToDel_early = delta_Act_early(yCum_pert,endTime,...
    yCum_Ctl,time_to_capture_Ctl,thr_delta_Act,indToDel,delta_Act_TMP)
    newThr = thr_delta_Act*.90;

    TimeArr = [1:5:endTime];
    sz = length(TimeArr);

    speciesNo = size(delta_Act_TMP,2);


    TMP = delta_Act_TMP(indToDel);
    [~, indToKeep_] = find(abs(TMP) > newThr);
    if ~isempty(indToKeep_)
        indToKeep = indToDel(indToKeep_);
    
        ToKeep_early = zeros(sz,length(indToKeep));
        ToKeep_early_T = zeros(sz,length(indToKeep));
        for i=1:sz
            curr_time = TimeArr(i);
            delta_Act_TMP_early = yCum_pert(curr_time,:) - yCum_Ctl(time_to_capture_Ctl,:);
            TMP = delta_Act_TMP_early(indToKeep);
            ToKeep_early(i,:) = TMP;        
        end
        
        ToKeep_early_T(ToKeep_early>thr_delta_Act) = 1;
        TMP = sum(ToKeep_early_T);
        [~, TMP2] = find(TMP > sz/2);
    
        toKeep_early = indToKeep_(TMP2);

        if ~isempty(toKeep_early)
            % Changing the code for nox does not change the current results. 
            % Because it only contains Nox and Nox at the beginning and in SS 
            % have the same sign of delta changes (TO DO)
            % When u running the signalling pathway algo, it displays the 
            % nodes tha were supposed to be removed and they were not, and 
            % also the nodes with feedback loop to the input node, be careful 
            % about them, when u wanna present the signalling pathways figures. (TO DO)
            disp('u need to change this part of the code based on comment in the code.');
            input('to be specific in "delta_Act_early" finction.');
        end
    
        indToDel_early = indToDel;
        indToDel_early(toKeep_early) = [];
    else
        indToDel_early = indToDel;
    end

end

% to determine slopes
function ind_to_remove = determine_removed_inp_by_time_of_dch_after_pert(...
    yCum_pert,subconditions,specID_orig,specID,pert_cond, time_FL_thr)

% % perturbed condition
% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')
nodes = {};
if pert_cond ==1 || pert_cond ==2 || pert_cond ==3 || pert_cond ==4 || pert_cond ==16
    nodes{end+1} = 'AngII';
end
if pert_cond ==5 || pert_cond ==6 || pert_cond ==7 || pert_cond ==8 || pert_cond ==17
    nodes{end+1} = 'TGFB';
end
if pert_cond ==12 || pert_cond ==13 || pert_cond ==14 || pert_cond ==15
    nodes{end+1} = 'ET1';
end
if pert_cond ==2 || pert_cond ==6 || pert_cond ==11 || pert_cond ==13 || pert_cond ==16 || pert_cond ==17
    nodes{end+1} = 'E2';
end
if pert_cond ==3 || pert_cond ==7 || pert_cond ==9 || pert_cond ==14
    nodes{end+1} = 'PG';
end
if pert_cond ==4 || pert_cond ==8 || pert_cond ==10 || pert_cond ==15
    nodes{end+1} = 'TS';
end


inp_ind = find(ismember(specID_orig,nodes));
subcond_ind = find(ismember(specID_orig,subconditions));

data = yCum_pert(:,[inp_ind;subcond_ind]);

% Number of rows and columns
[nRows, nCols] = size(data);

% Preallocate for results
startPoints = zeros(1, nCols);

% Loop through each column
for col = 1:nCols
    y = data(:, col);             % current column
    dy = diff(y);                 % first differences
    
    % Smooth the differences (optional, for noisy data)
    dy_smooth = movmean(abs(dy), 3);
    
    % Define a threshold for "starts increasing"
    threshold = max(dy_smooth) * 0.05; % 5% of max slope
    
    % Find the first index where slope exceeds threshold
    idx = find(dy_smooth > threshold, 1, 'first');
    
    % Save the index
    startPoints(col) = idx;
    
end

ln = length(nodes);
for i=1:ln
    if startPoints(i)>1
        disp("please pay attention to start point times...");
        disp(nodes{i});
        disp(startPoints(i));
        disp('enter any key if u want to skip this message! ');
        input()
    end
end

TMP_arr = startPoints(ln+1:end);
TMP = find(TMP_arr >= time_FL_thr);
indTMP = subcond_ind(TMP);
inputs2remove = specID_orig(indTMP);

ind_to_remove = find(ismember(specID,inputs2remove));

end


function newNode2remove = find_feedbackLoop_nodes(...
    inp,reaction_rules,reaction_rules_id)
    newNode2remove = {};
    testCell = reaction_rules;
    key = inp;
    delims = {' ', '&', '=>', '+', '!'}; 
    partsCell = cellfun(@(s) strsplit(s, delims), testCell, 'UniformOutput', false);

    hasIt = cellfun(@(p) find(strcmp(p, key)), partsCell, 'UniformOutput', false);
    ind_reactions = find(~cellfun('isempty', hasIt));
    if ~isempty(ind_reactions)
        for j=1:size(ind_reactions,1)
            TMP = ind_reactions(j);
            s = testCell{TMP};
            %modify the s
            % Step 1: Ensure one space around each '&'
            s = regexprep(s, '\s*&\s*', ' & ');
            % Step 2: Also normalize around '+' if needed
            s = regexprep(s, '\s*\+\s*', ' + ');
            % Step 3: Also normalize around '=>' if needed
            s = regexprep(s, '\s*=>\s*', ' => ');

            parts = strsplit(s, '=>');
            rightSide = parts{2};
            tokensRight = strsplit(strtrim(rightSide), delims);
            if any(strcmp(tokensRight, key))
                % Split into tokens using all delimiters
                tokens_raw = regexp(s, '[^ &!+=>]+', 'match');
                tokens_ = regexp(s, '[^ &+=>]+', 'match'); 
                token_all = split(s,' ')';
                for ii=1:size(tokens_raw,2)-1
                    newNode2removeT = tokens_raw{ii};
                    newNode2remove = [newNode2remove,newNode2removeT];
                end
            end
        end
    end

end

function [flg,inp] = find_if_input_has_feedback_connection(...
    pert_cond,subconditions)
flg = 0;
% not2beremoved_nodes = [{output_nodes{indTMP}}, output_up_nodes{indTMP}{:}];
% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')

condTMP = pert_cond;

if condTMP==1
    inp = 'AngII';
end
if condTMP==2 || condTMP==6 || condTMP==16 || condTMP==17
    inp = 'E2';
end
if condTMP==3 || condTMP==7 || condTMP==9
    inp = 'PG';
end
if condTMP==4 || condTMP==8 || condTMP==10
    inp = 'TS';
end
if condTMP==5
    inp = 'TGFB';
end

if ismember(inp,subconditions)
    flg = 1;
end

end

% to recreate the model excel file again
function write_an_excel_file(filename,filtered_species,filtered_reactions)
% Remove existing file if needed
if isfile(filename)
    delete(filename);  % start fresh
end
% --- Species sheet ---
% 1. Write a header label in A1
writecell({'Species information'}, filename,'Sheet','species', 'Range','A1');
% 2. Write the species table starting in row 2
writetable(filtered_species, filename, 'Sheet','species', ...
    'Range','A2', 'WriteVariableNames', true);
% --- Reactions sheet ---
writecell({'Reaction Information'}, filename, 'Sheet','reactions', 'Range','A1');
writetable(filtered_reactions, filename, 'Sheet','reactions','Range','A2', 'WriteVariableNames', true);

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
function [testCell,reaction_rules_id,specID,newNode2remove] = remove_nodes_reactions(indtoremove,...
    reaction_rules,reaction_rules_id,...
    specID,not2beremoved_nodes,...
    input_nodes,output_nodes)
    
    newNode2remove = {};

    testCell=reaction_rules;

    toberemoved = specID(indtoremove);

    indTMP = ismember(toberemoved,not2beremoved_nodes);
    toberemoved(indTMP) = [];

    indtoremove(indTMP) = [];
    specID(indtoremove') = [];
if ~isempty(toberemoved)
    for i=1:size(toberemoved,1)
        key = toberemoved{i};
        delims = {' ', '&', '=>', '+', '!'}; 
        partsCell = cellfun(@(s) strsplit(s, delims), testCell, 'UniformOutput', false);

        hasIt = cellfun(@(p) find(strcmp(p, key)), partsCell, 'UniformOutput', false);
        ind_reactions = find(~cellfun('isempty', hasIt));

        if ~isempty(ind_reactions)
            for j=1:size(ind_reactions,1)
                TMP = ind_reactions(j);
                s = testCell{TMP};
                %modify the s
                % Step 1: Ensure one space around each '&'
                s = regexprep(s, '\s*&\s*', ' & ');
                % Step 2: Also normalize around '+' if needed
                s = regexprep(s, '\s*\+\s*', ' + ');
                % Step 3: Also normalize around '=>' if needed
                s = regexprep(s, '\s*=>\s*', ' => ');

                parts = strsplit(s, '=>');
                rightSide = parts{2};
                tokensRight = strsplit(strtrim(rightSide), delims);
                if any(strcmp(tokensRight, key))
                    testCell{TMP}='';
                    reaction_rules_id{TMP}='';
                    newNode2removeT = isThereAnyNodeWithNoReaction(s,...
                        input_nodes,output_nodes,testCell,toberemoved);
                    if ~isempty(newNode2removeT)
                        newNode2remove = [newNode2remove,newNode2removeT];
                    end
                else
                    % Split into tokens using all delimiters
                    tokens_raw = regexp(s, '[^ &!+=>]+', 'match');
                    tokens_ = regexp(s, '[^ &+=>]+', 'match'); 
                    token_all = split(s,' ')';
                    
                    if size(tokens_raw,2)<=2
                        % it is the only node on the left side
                        testCell{TMP}='';
                        reaction_rules_id{TMP}='';
                        newNode2removeT = isThereAnyNodeWithNoReaction(s,...
                            input_nodes,output_nodes,testCell,toberemoved);
                        if ~isempty(newNode2removeT)
                            newNode2remove = [newNode2remove,newNode2removeT];
                        end
                    else
                        [~,indTMP] = find(ismember(tokens_raw,key));
                        TMP_key = tokens_(indTMP);
                        [~,indTMP] = find(ismember(token_all,TMP_key));
                        if indTMP==1
                            token_all([indTMP,indTMP+1]) = [];
                        else
                            token_all([indTMP,indTMP-1]) = [];
                        end
                        newStr = strjoin(token_all, ' ');  
                        testCell{TMP}=newStr;
                    end
                end%if
            end% for j
        end% if isempty
    end
testCell = testCell(~cellfun('isempty', testCell));
[testCell, ia] = unique(testCell, 'stable');
reaction_rules_id = reaction_rules_id(~cellfun('isempty', reaction_rules_id));
reaction_rules_id = reaction_rules_id(ia);
end
end


function [not2beremoved_nodes] = determine_not2beremoved_nodes(ctl_cond,...
    pert_cond,output_nodes,output_up_nodes,target_node,path2save,VersionFile,flg)
not2beremoved_nodes = {};
[~,indTMP] = ismember(target_node,output_nodes);

%%%%% in V2 VERSION %%%%%%%%
not2beremoved_nodes = [{output_nodes{indTMP}}];
%%%%% in ORIGINAL VERSION %%%%%%%%
% not2beremoved_nodes = [{output_nodes{indTMP}}, output_up_nodes{indTMP}{:}];
%%%%%%%%%%%%%%%%%%%

% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% to determine inputs that cannt be removed
for i=1:2
    if i==1
        condTMP = ctl_cond;
    else
        condTMP = pert_cond;
    end
    if condTMP==1
        not2beremoved_nodes{end+1} = 'AngII';
    end
    if condTMP==2
        not2beremoved_nodes{end+1} = 'AngII';
        not2beremoved_nodes{end+1} = 'E2';
    end
    if condTMP==3
        not2beremoved_nodes{end+1} = 'AngII';
        not2beremoved_nodes{end+1} = 'PG';
    end
    if condTMP==4
        not2beremoved_nodes{end+1} = 'AngII';
        not2beremoved_nodes{end+1} = 'TS';
    end
    if condTMP==5
        not2beremoved_nodes{end+1} = 'TGFB';
    end
    if condTMP==6
        not2beremoved_nodes{end+1} = 'TGFB';
        not2beremoved_nodes{end+1} = 'E2';
    end
    if condTMP==7
        not2beremoved_nodes{end+1} = 'TGFB';
        not2beremoved_nodes{end+1} = 'PG';
    end
    if condTMP==8
        not2beremoved_nodes{end+1} = 'TGFB';
        not2beremoved_nodes{end+1} = 'TS';
    end
    if condTMP==9
        not2beremoved_nodes{end+1} = 'PG';
    end
end

% to determine the nodes are chosen before for the ctl_cond that cannt be removed
% for e.g., the nodes that are involved in CI regulation through AngII
% comparde to BL
% disp('0: Baseline');
% disp('1: AngII, 2,3,4: AngII+E2/PG/TS, ');
% disp('5: TGFB, 6,7,8: TGFB+E2/PG/TS, ');
% disp('9,10,11: PG,TS,E2 ')
% disp('12: ET1, 13,14,15: ET1+E2/PG/TS, ')
% disp('16: AngII+E2 (E2: 0.75)')
% disp('17: TGFB+E2 (E2: 0.75) ')
if ctl_cond ==1 && (pert_cond==2 || pert_cond==3 || pert_cond==4 || pert_cond==16)
    if flg==1%it shows if we wanna keep some specific nodes from previous saved pathways
    filename = ['sigPath_File_condCtl_0_condPert_',...
    num2str(ctl_cond),'_target_',target_node,'_V',num2str(VersionFile),'_V3'];
    file_model = [filename,'.xlsx'];
    file_ = [path2save,file_model];
    mat_species = readtable(file_, 'Sheet', 'species');
    SpecTMP = mat_species.ID;
    for i=1:size(SpecTMP,1)
        not2beremoved_nodes{end+1} = SpecTMP{i};
    end
    end
end

if ctl_cond ==5 && (pert_cond==6 || pert_cond==7 || pert_cond==8 || pert_cond==17)
    if flg==1%it shows if we wanna keep some specific nodes from previous saved pathways
    filename = ['sigPath_File_condCtl_0_condPert_',...
    num2str(ctl_cond),'_target_',target_node,'_V',num2str(VersionFile),'_V3'];
    file_model = [filename,'.xlsx'];
    file_ = [path2save,file_model];
    mat_species = readtable(file_, 'Sheet', 'species');
    SpecTMP = mat_species.ID;
    for i=1:size(SpecTMP,1)
        not2beremoved_nodes{end+1} = SpecTMP{i};
    end
    end
end

if ctl_cond ==12 && (pert_cond==13 || pert_cond==14 || pert_cond==15)
    if flg==1%it shows if we wanna keep some specific nodes from previous saved pathways
    filename = ['sigPath_File_condCtl_0_condPert_',...
    num2str(ctl_cond),'_target_',target_node,'_V',num2str(VersionFile),'_V3'];
    file_model = [filename,'.xlsx'];
    file_ = [path2save,file_model];
    mat_species = readtable(file_, 'Sheet', 'species');
    SpecTMP = mat_species.ID;
    for i=1:size(SpecTMP,1)
        not2beremoved_nodes{end+1} = SpecTMP{i};
    end
    end
end

not2beremoved_nodes = unique(not2beremoved_nodes);
end

function newNode2removeT = isThereAnyNodeWithNoReaction(s,...
    input_nodes,output_nodes,testCell,toberemoved)


    newNode2removeT = {};
    
    tokens_raw = regexp(s, '[^ &!+=>]+', 'match');
    tokens_ = regexp(s, '[^ &+=>]+', 'match'); 
    token_all = split(s,' ')';
    
    for i=1:size(tokens_raw,2)
        key = tokens_raw{i};
        if isempty(toberemoved) || isempty(find(ismember(toberemoved,key),1))%it does not already belong to the list
            delims = {' ', '&', '=>', '+', '!'}; 
            partsCell = cellfun(@(s) strsplit(s, delims), testCell, 'UniformOutput', false);
    
            hasIt = cellfun(@(p) find(strcmp(p, key)), partsCell, 'UniformOutput', false);
            ind_reactions = find(~cellfun('isempty', hasIt));
            
            if isempty(ind_reactions)%it does not belong to any reaction in the list
                newNode2removeT{end+1} = key;
             else
                flg_inp = 0;
                flg_out = 0;
                for j=1:size(ind_reactions,1)
                    TMP = ind_reactions(j);
                    sT = testCell{TMP};
                    parts = regexp(sT, '[^ &!+=>]+', 'match');
                    if any(strcmp(parts{end}, key))
                        flg_inp = 1;
                    end
                    if ~isempty(find(ismember(parts(1:end-1), key)))
                        flg_out = 1;
                    end

                    % we found at least one inp and one out already
                    if flg_out*flg_inp==1
                        break
                    end
                end
                if ~isempty( find(ismember(input_nodes,key),1))% if it belongs to input nodes
                    if flg_out==0
                        newNode2removeT{end+1} = key;
                    end
                elseif ~isempty( find(ismember(output_nodes,key),1))% if it belongs to output nodes
                    if flg_inp==0
                        newNode2removeT{end+1} = key;
                    end
                else
                    if flg_out*flg_inp==0
                        newNode2removeT{end+1} = key;
                    end
                end
            end
        end
        

    end
  
end


function reaction_rules_id = modifyInputReactions(reaction_rules_id)
    % Step 1: Identify 'i' entries
    is_i = startsWith(reaction_rules_id, 'i');
    i_ids = reaction_rules_id(is_i);  % e.g. {'i1','i2','i5','i6','i9','i12'}
    n_i = numel(i_ids);
    % Step 2: Create new sequential 'i' IDs
    new_i_ids = arrayfun(@(k) ['i' num2str(k)], 1:n_i, 'UniformOutput', false);
    % Step 3: Replace in the full list
    reaction_rules_id(is_i) = new_i_ids;

    is_i = startsWith(reaction_rules_id, 'r');
    i_ids = reaction_rules_id(is_i);  % e.g. {'i1','i2','i5','i6','i9','i12'}
    n_i = numel(i_ids);
    new_i_ids = arrayfun(@(k) ['r' num2str(k)], 1:n_i, 'UniformOutput', false);
    reaction_rules_id(is_i) = new_i_ids;
end


function [testCell,reaction_rules_id,specID,newNode2remove,...
    newNode2removeBUTdidnt] = remove_reactions_notagreed(...
    reaction_rules,reaction_rules_id,...
    specID,not2beremoved_nodes,...
    input_nodes,output_nodes,specID_orig,delta_Act_TMP)
    
    newNode2remove = {};
    newNode2removeBUTdidnt = {};
    testCell=reaction_rules;

    for i=1:size(testCell,1)
        s = testCell{i};
        %modify the s
        % Step 1: Ensure one space around each '&'
        s = regexprep(s, '\s*&\s*', ' & ');
        % Step 2: Also normalize around '+' if needed
        s = regexprep(s, '\s*\+\s*', ' + ');
        % Step 3: Also normalize around '=>' if needed
        s = regexprep(s, '\s*=>\s*', ' => ');

        % Split into tokens using all delimiters
        tokens_raw = regexp(s, '[^ &!+=>]+', 'match');
        tokens_ = regexp(s, '[^ &+=>]+', 'match'); 
        token_all = split(s,' ')';

        if size(tokens_raw,2) > 1
            [~, TMP1] = ismember(tokens_raw, specID_orig);
            signs_ = delta_Act_TMP(TMP1);
            signs_(signs_ < 0) = -1;
            signs_(signs_ > 0) = 1;
            TMP = find(contains(tokens_,'!'));
            signs_(TMP) = signs_(TMP)*-1;
            last_elem = signs_(end);
            % if abs(last_elem) < 0.001
            %     test = 1;
            % end
            diff_indices = find(signs_(1:end-1) ~= last_elem);
            if ~isempty(diff_indices)
            % check if the chosen node in among the nodes in not2beremoved_nodes
                candidateNode = tokens_raw(diff_indices);
                TMPP = find(ismember(candidateNode,not2beremoved_nodes));
                if isempty(TMPP)
                    diff_indices(TMPP) = [];
                else
                    newNode2removeBUTdidnt = [newNode2removeBUTdidnt,candidateNode];
                end
            end
            sz = size(diff_indices,2);
            if ~isempty(diff_indices)
                if size(tokens_raw,2)<=2 || sz==size(tokens_raw,2)-1
                    % it is the only node on the left side
                    testCell{i}='';
                    reaction_rules_id{i}='';
                    newNode2removeT = isThereAnyNodeWithNoReaction(s,...
                        input_nodes,output_nodes,testCell,[]);
                    if ~isempty(newNode2removeT)
                        newNode2remove = [newNode2remove,newNode2removeT];
                        % newNode2remove{end+1} = newNode2removeT;
                    end
                else
                    for j=1:sz
                        TMP = diff_indices(j);
                        key = tokens_raw{TMP};
                        [~,indTMP] = find(ismember(tokens_raw,key));
                        TMP_key = tokens_(indTMP);
                        [~,indTMP] = find(ismember(token_all,TMP_key));
                        if indTMP==1
                            token_all([indTMP,indTMP+1]) = [];
                        else
                            token_all([indTMP,indTMP-1]) = [];
                        end
                        newStr = strjoin(token_all, ' ');  
                        testCell{i}=newStr;
                        newNode2removeT = isThereAnyNodeWithNoReaction(s,...
                        input_nodes,output_nodes,testCell,[]);%%%%%%%%%%%%%
                        if ~isempty(newNode2removeT)%%%%%%%%%%%%%
                            newNode2remove = [newNode2remove,newNode2removeT];
                        end%%%%%%%%%%%%
                    end
                end%if size(tokens_raw,2)<=2

            end%~isempty(diff_indices)
        end
    end                   
                    
testCell = testCell(~cellfun('isempty', testCell));
[testCell, ia] = unique(testCell, 'stable');
reaction_rules_id = reaction_rules_id(~cellfun('isempty', reaction_rules_id));
reaction_rules_id = reaction_rules_id(ia);
end
