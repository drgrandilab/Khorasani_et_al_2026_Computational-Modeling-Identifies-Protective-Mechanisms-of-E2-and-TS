clc;
clear all;
close all;
%% address to read the data
VersionFile = 99;
It2reachSS = 20;
flg_Sel_traces = input('Do you want 1: selected traces or 0: all traces  ?1? ');

disp('check the initial set values, they need to be aligned ');
disp('with the values in signalling_pathways_identification_V7.m code.');
disp('As far as I remember:');
disp('KD_val = 0.1; OE_val = 1.5; high_sti_val = 0.7;');
disp('=================================')
thrSt = 0;
thrCont = 0;%.05;
thrSubs = 0.1;

KD_val = 0.1;
OE_val = 1.5;

high_sti_val = 0.7;

final_values = {};
final1Quarter_values = {};
final2Quarter_values = {};
final3Quarter_values = {};

tmpF = VersionFile;

folder_to_save_files = ['signalling_pathways_contribution_folder_V',num2str(tmpF),'/'];

fname = ['Khorasani_Atrial_Fibroblast_Model_2026.xlsx'];

% define the path to read model files
pathname = ['models/'];

path2save = [folder_to_save_files];

input_nodes_to_study_pot = {'AngII', 'TGFB'};
flginp = input('1:AngII, 2: TGFB? ');
if flginp==1 || flginp ==2
    input_nodes_to_study = input_nodes_to_study_pot(flginp) ;
else
    disp('Something is wrong!') ;
    error('Stopping here.');
end
sz_inp_2 = size(input_nodes_to_study,2);

disp('which set 1:CI/CIII, 2:FA, 3:fib, 4, 5:pro => Ang/TGFB+E2,');
disp('6(Ang+TS)');
flg_i = input('1,2,...6? ');
if flg_i==1
    output_nodes = {'CI', 'CIII'};
    if flginp==1
        nodes2study = {'AT1R','JNK','ROS','smad3', 'CImRNA'};
    elseif flginp==2
         nodes2study = {'JNK','ROS','smad3', 'CImRNA'};
    end
elseif flg_i==2
    output_nodes = {'FA'};
    nodes2study = {'AT1R','CDK1'};
elseif flg_i==3
    output_nodes = {'fibronectin'};
    if flginp==1
        nodes2study = {'AT1R','JNK','ROS','smad3', 'p38','NFKB'}; 
    elseif flginp==2
        nodes2study = {'JNK','ROS','smad3', 'p38','NFKB'}; 
    end
elseif flg_i==4
    output_nodes = {'aSMA','PAI1','periostin','CTGF','EDAFN'};
    if flginp==1
        nodes2study = {'AT1R','JNK','ROS','smad3'};
    elseif flginp==2
        nodes2study = {'JNK','ROS','smad3'};
    end
elseif flg_i==5
    output_nodes = {'proliferation'};
    if flginp==1
        nodes2study = {'AT1R','JNK','ROS','smad3', 'CDK1'};
    elseif flginp==2
        nodes2study = {'JNK','ROS','smad3', 'CDK1'};
    end
elseif flg_i==6
    if flginp==1
        output_nodes = {'CI','aSMA','PAI1','periostin','CTGF','EDAFN'};
        nodes2study = {'smad3','IP3'};
    else
        disp('Something is wrong!') ;
        disp('you entered Ang as iput to be studied?!')
        error('Stopping here.');
    end
    disp('Something is wrong!') ;
    disp('you entered Ang as iput to be studied?!')
    error('Stopping here.');
end

input('R they really all KD? Check! ');
sz = size(nodes2study,2);
nodes2study_pert = ones(1,sz)*KD_val; %[KD_val,KD_val,KD_val,KD_val,KD_val,KD_val];

input_nodes = {'AngII','TGFB','mechanical','IL6','IL1',...
'TNFa','NE', 'PDGF','ET1',   ...
  'NP','Forskolin', ...
'E2','TS',...
'FGF23','ADL','LPS','BMP2','TNC'};

%% create all combinations:
all_combinations = all_comb(sz);
%% run netflux in baseline condition
fileNameTMP = [path2save,'yCumBL_V',num2str(VersionFile),'.mat'];
if ~isfile(fileNameTMP)
    % File does NOT exist, so save it
    ind_equal_to_0_in_w = [];
    indices_in_orig_w = ind_equal_to_0_in_w;
    W_Mat = [];
    
    [specID, ~,~, yCumBL] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w, ...
            W_Mat, fname,pathname, It2reachSS,0,[],0,[],[]);
    save(fileNameTMP, 'yCumBL');
    disp(['File saved: ' fileNameTMP]);
else
    % File exists: load it
    loadedData = load(fileNameTMP, 'yCumBL');
    yCumBL = loadedData.yCumBL; % assign to workspace

    % just to load specID
    [specID, ~,~, ~] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3([], ...
            [], fname,pathname, 1,0,[],0,[],[]);
end

% input and output indeces
outPut_indeces = findIndicesInSpecID(output_nodes,specID);
sz_out = size(outPut_indeces,2);

input_indeces = findIndicesInSpecID(input_nodes,specID);
sz_inp = size(input_indeces,2);

nodes2study_indeces = findIndicesInSpecID(nodes2study,specID);

%% run netflux for high stimuli and perturbations
for i=1:sz_inp_2
    final_values_ = [];
    final1Quarter_values_ = [];
    final2Quarter_values_ = [];
    final3Quarter_values_ = [];

    % high stimuli
    fileNameTMP = [path2save,'yCum_',input_nodes_to_study{i},'_V',num2str(VersionFile),'.mat'];
    if ~isfile(fileNameTMP)
        % File does NOT exist, so save it
        lastValues_ = yCumBL(end,:);
        indices_in_orig_w = [];
        W_Mat = [];
        W_Mat_sti = [high_sti_val,W_Mat];
        [~,indTMP] = ismember(input_nodes_to_study{i},input_nodes);
        indices_in_orig_w_sti = [indTMP,indices_in_orig_w];
        
        [~,~,~, yCum] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w_sti, ...
            W_Mat_sti, fname,pathname, It2reachSS,1,lastValues_,0,[],[]);
        save(fileNameTMP, 'yCum');
    else
        % File exists: load it
        loadedData = load(fileNameTMP, 'yCum');
        yCum = loadedData.yCum; % assign to workspace
    end
    % colloct output values
    final_values_ = [final_values_;yCum(end,outPut_indeces)];
    indTMP = size(yCum,1);
    final1Quarter_values_ = [final1Quarter_values_;yCum(round(1*indTMP/4),outPut_indeces)];
    final2Quarter_values_ = [final2Quarter_values_;yCum(round(2*indTMP/4),outPut_indeces)];
    final3Quarter_values_ = [final3Quarter_values_;yCum(round(3*indTMP/4),outPut_indeces)];
   
    % perturbation
    % do we need any OE?
    flgMx = 1;
    for i1=1:size(all_combinations,2)
        % where we need OE/KD?
        curr_comb = all_combinations{i1};

        %determine the name
        TMP = [];
        for i2=1:size(curr_comb,2)
            TMP1 = curr_comb(i2);
            TMP = [TMP,nodes2study{TMP1}];
            TMP = [TMP,'_'];
        end
        fileNameTMP = [path2save,'yCum_',input_nodes_to_study{i},'_',TMP,'V',num2str(VersionFile),'.mat'];
        if ~isfile(fileNameTMP)
            lastValues_ = yCumBL(end,:);
            % File does NOT exist, so save it
            yMax_ind = nodes2study_indeces(curr_comb);
            % the value for OE/KD?
            yMax_val = nodes2study_pert(curr_comb);
            
            indices_in_orig_w = [];
            W_Mat = [];
            W_Mat_sti = [high_sti_val, W_Mat];
            [~,indTMP] = ismember(input_nodes_to_study{i},input_nodes);
            indices_in_orig_w_sti = [indTMP,indices_in_orig_w];
            
            [~,~,~, yCum] = Netflux_NJ_for_predefined_inp_and_y0_ymax_V3(indices_in_orig_w_sti, ...
            W_Mat_sti, fname,pathname, It2reachSS,1,lastValues_,flgMx,yMax_ind,yMax_val);
            save(fileNameTMP, 'yCum');
        else
            % File exists: load it
            loadedData = load(fileNameTMP, 'yCum');
            yCum = loadedData.yCum; % assign to workspace
        end  
        % colloct output values
        final_values_ = [final_values_;yCum(end,outPut_indeces)];
        indTMP = size(yCum,1);
        final1Quarter_values_ = [final1Quarter_values_;yCum(round(1*indTMP/4),outPut_indeces)];
        final2Quarter_values_ = [final2Quarter_values_;yCum(round(2*indTMP/4),outPut_indeces)];
        final3Quarter_values_ = [final3Quarter_values_;yCum(round(3*indTMP/4),outPut_indeces)];
   
    end
    final_values{i} = final_values_;
    final1Quarter_values{i} = final1Quarter_values_;
    final2Quarter_values{i} = final2Quarter_values_;
    final3Quarter_values{i} = final3Quarter_values_;
   
end%for i

% to save/load the final values in the folder
TMP = [];
for i2=1:size(input_nodes_to_study,2)
    TMP = [TMP,input_nodes_to_study{i2}];
    TMP = [TMP,'_'];
end
for i2=1:size(nodes2study,2)
    TMP = [TMP,nodes2study{i2}];
    TMP = [TMP,'_'];
end

fileNameTMP = [path2save,'final_values_',TMP,'V',num2str(VersionFile),'.mat'];
if ~isfile(fileNameTMP)
    save(fileNameTMP, 'final_values');
else
        % File exists: load it
    loadedData = load(fileNameTMP, 'final_values');
    final_values = loadedData.final_values; % assign to workspace
end

fileNameTMP = [path2save,'final1Quarter_values_',TMP,'V',num2str(VersionFile),'.mat'];
if ~isfile(fileNameTMP)
    save(fileNameTMP, 'final1Quarter_values');
else
        % File exists: load it
    loadedData = load(fileNameTMP, 'final1Quarter_values');
    final1Quarter_values = loadedData.final1Quarter_values; % assign to workspace
end

fileNameTMP = [path2save,'final2Quarter_values_',TMP,'V',num2str(VersionFile),'.mat'];
if ~isfile(fileNameTMP)
    save(fileNameTMP, 'final2Quarter_values');
else
        % File exists: load it
    loadedData = load(fileNameTMP, 'final2Quarter_values');
    final2Quarter_values = loadedData.final2Quarter_values; % assign to workspace
end

fileNameTMP = [path2save,'final3Quarter_values_',TMP,'V',num2str(VersionFile),'.mat'];
if ~isfile(fileNameTMP)
    save(fileNameTMP, 'final3Quarter_values');
else
        % File exists: load it
    loadedData = load(fileNameTMP, 'final3Quarter_values');
    final3Quarter_values = loadedData.final3Quarter_values; % assign to workspace
end

%% to study the contributions
nodes_with_contributions = cell(sz_inp_2,sz_out); 
nodes_with_contributions_vals = cell(sz_inp_2,sz_out); 
flg_sub = 0;
for i1=1:sz_inp_2
    final_values_ = final_values{i1};
    final1Quarter_values_ = final1Quarter_values{i1};
    final2Quarter_values_ = final2Quarter_values{i1};
    final3Quarter_values_ = final3Quarter_values{i1};
    for i2=1:sz_out
        flg_sub_lst = ones(1,length(all_combinations)+1);
        disp(output_nodes{i2});
        data = final_values_(:,i2);
        data1Q = final1Quarter_values_(:,i2);
        data2Q = final2Quarter_values_(:,i2);
        data3Q = final3Quarter_values_(:,i2);
        % First element
        firstValue = data(1);
        firstValue1Q = data1Q(1);
        firstValue2Q = data2Q(1);
        firstValue3Q = data3Q(1);

        growing_set = {};
        growing_val =[];
        if firstValue >= thrSt
            % Find indices where abs difference > 0.1
            delta_changes = data - firstValue;
            delta_changes1Q = data1Q - firstValue1Q;
            delta_changes2Q = data2Q - firstValue2Q;
            delta_changes3Q = data3Q - firstValue3Q;
            
            growing_set = {};
            growing_val =[];
            sz_curr =1;
            % Display results
            % for i3=1:size(diffIndices,1)
            for i3=2:size(data,1)
                % TMP = diffIndices(i3)-1;
                % diff_combs = all_combinations{TMP};
                diff_combs = all_combinations{i3-1};
                diff_comb_nodes = nodes2study(diff_combs);
                curr_delta_ch = delta_changes(i3);
                curr_delta_ch1Q = delta_changes1Q(i3);
                curr_delta_ch2Q = delta_changes2Q(i3);
                curr_delta_ch3Q = delta_changes3Q(i3);
                
                if sz_curr<length(diff_combs)
                    sz_curr = length(diff_combs);
                end

                % check if it has any subsets which is effective as much as
                % this one
                if flg_Sel_traces == 1
                [flg_sub,flg_sub_lst] = isThereAnyEffectiveSubset(all_combinations,...
                    diff_combs,curr_delta_ch,delta_changes,thrSubs,flg_sub_lst,...
                    curr_delta_ch1Q,curr_delta_ch2Q,curr_delta_ch3Q,...
                    delta_changes1Q,delta_changes2Q,delta_changes3Q);
                end
                
                if flg_sub==0
                % update the set
                growing_set{end+1} = diff_comb_nodes;
                growing_val(end+1) = curr_delta_ch;
                disp(diff_comb_nodes);
                end
            end
        end
        nodes_with_contributions{i1,i2} = growing_set;
        nodes_with_contributions_vals{i1,i2} = growing_val;
        disp('================')
    end
end

%% plotting traces with KDs that make differences

% to load input stimuli
fileNameTMP = [path2save,'yCum_',input_nodes_to_study{1},'_V',num2str(VersionFile),'.mat'];
% File exists: load it
loadedData = load(fileNameTMP, 'yCum');
yCumSti = loadedData.yCum; % assign to workspace

% to load the yCum values in the folder from KDs
for i=1:length(nodes_with_contributions)
    curr_node_ = nodes_with_contributions{i};
    curr_node_vals_ = nodes_with_contributions_vals{i};
    szn = size(curr_node_,2);

    if szn <= 6
        parts = {1:szn};                 % one array: 1:n
    else
        idx = 1:szn;
        k = floor(szn/6);
        r = mod(szn,6);
        sizes = [repelem(6,k) r*(r>0)]; % e.g., [6 6 2] for n=14
        parts = mat2cell(idx, 1, sizes); % -> {1:6, 7:12, 13:14}
    end

    szp = size(parts,2);
    for ii=1:szp
    figure;
    
    curr_out = output_nodes{i};
    curr_ind = outPut_indeces(i);
    xArr = [yCumBL(end-4*60+1:end,curr_ind);yCumSti(:,curr_ind)];
    plot(xArr,LineWidth=3); hold on;
    lgnd = {['high',input_nodes_to_study{1}]};

    curr_node_TMP = curr_node_(parts{ii});
    curr_node_Vals_TMP = curr_node_vals_(parts{ii});
    
    for i2=1:size(curr_node_TMP,2)
        Val_ = curr_node_Vals_TMP(i2);

        TMP1 = curr_node_TMP{i2};
        TMP = [];
        for i3=1:size(TMP1,2)
            TMP = [TMP,TMP1{i3}];
            TMP = [TMP,'_'];
        end

        fileNameTMP = [path2save,'yCum_',input_nodes_to_study{1},'_',TMP,'V',num2str(VersionFile),'.mat'];
        % File exists: load it
        loadedData = load(fileNameTMP, 'yCum');
        yCum = loadedData.yCum; % assign to workspace
        
        xArr = [yCumBL(end-4*60+1:end,curr_ind);yCum(:,curr_ind)];
        plot(xArr,LineWidth=3); hold on;
        title(curr_out);
        ylabel('Activity');
        xlabel('Time (h)');
    
        lgnd{end+1} = [TMP,num2str(Val_)];
    
        ylim([0,1])
        yticks(0:.5:1);
        xlim([1,size(xArr,1)])
        xticks(0:240:size(xArr,1)-1); % Set x-tick positions (match number of bars)
    end
    legend(lgnd,'Interpreter', 'none');
    set(gca,'FontSize',20);
    axis square
    if flg_Sel_traces == 1
        saveas(gcf, [path2save,input_nodes_to_study{1},'_',curr_out,'_V',num2str(VersionFile),'_',num2str(ii),'_',num2str(flg_i),'_seltraces.svg']);
    else
        saveas(gcf, [path2save,input_nodes_to_study{1},'_',curr_out,'_V',num2str(VersionFile),'_',num2str(ii),'_',num2str(flg_i),'_alltraces.svg']);

    end
    close all;
    end
end

%% functions definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outPut_indeces = findIndicesInSpecID(output_nodes,specID)
    outPut_indeces = zeros(1, numel(output_nodes));  % Create an array to store indices
    for i = 1:numel(output_nodes)
        node = output_nodes{i};
        index = find(ismember(specID, node));  % Find the index for the current node
        outPut_indeces(i) = index;  % Store the index in the array
    end
end

%% create all combinations:
function all_combinations = all_comb(sz)
nodes2study_ = [1:sz]; % your input
all_combinations = {}; % initialize cell array to store results

% Loop over combination sizes (1 to length of nodes2study)
for k = 1:sz
    combos = nchoosek(nodes2study_, k); % all k-size combinations
    % Store each combination as a row in the cell array
    for i = 1:size(combos,1)
        all_combinations{end+1} = combos(i,:); %#ok<SAGROW>
    end
end
end

function   [flg_sub,flg_sub_lst ] = isThereAnyEffectiveSubset(all_combinations,...
    diff_combs,curr_delta_ch,delta_changes,thr,flg_sub_lst,...
        curr_delta_ch1Q,curr_delta_ch2Q,curr_delta_ch3Q,...
        delta_changes1Q,delta_changes2Q,delta_changes3Q)
    flg_sub =0;
    n = log2(length(delta_changes));
    sz = length(diff_combs);
    if sz>1
    combTMP = all_comb(sz);
    combTMP(end) = [];
    for i=1:length(combTMP)
        TMP = diff_combs(combTMP{i});
        TMP_ind = subset_number(TMP, n);
        subV = delta_changes(TMP_ind);
        diff = abs(subV-curr_delta_ch);
        subV1Q = delta_changes1Q(TMP_ind);
        diff1Q = abs(subV1Q-curr_delta_ch1Q);
        subV2Q = delta_changes2Q(TMP_ind);
        diff2Q = abs(subV2Q-curr_delta_ch2Q);
        subV3Q = delta_changes3Q(TMP_ind);
        diff3Q = abs(subV3Q-curr_delta_ch3Q);
        
        diff_ = max([diff,diff1Q,diff2Q,diff3Q]);
        if diff_<thr
                % if it is already in the package of influential ones
            if flg_sub_lst(TMP_ind)==1
                % it has a effective subset
                flg_sub = 1;
                TMP_ind = subset_number(diff_combs, n);
                flg_sub_lst(TMP_ind) = 0;
                break;
            end
        end
    end% for
    end%if sz
end
function idx = subset_number(A, n)
%SUBSET_NUMBER  1-based index of subset A of {1,2,...,n}
% Ordering: increasing cardinality, then lexicographic within same size.

    A = unique(A(:).');   % make row, unique
    A = sort(A);          % must be sorted for lex rank
    k = numel(A);

    % Sanity checks (optional but helpful)
    if any(A < 1) || any(A > n) || any(diff(A) == 0)
        error('A must contain unique integers in the range 1..n.');
    end

    % 1) Count all subsets with size < k
    idx = 1; % empty set is index 1
    for s = 0:(k-1)
        idx = idx + nchoosek(n, s);
    end

    % 2) Add lexicographic rank among k-subsets (0-based)
    rank0 = 0;
    prev = 0;
    for j = 1:k
        for x = (prev+1):(A(j)-1)
            rank0 = rank0 + nchoosek(n - x, k - j);
        end
        prev = A(j);
    end

    idx = idx + rank0;
end
