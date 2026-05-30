function [graph,shortest_path,path_no] = path_dGraph_shortPAth_func(networkSpecies,networkReactions,...
    input_No,node_src,node_dest,flg_all_path)

%% paraeters and input values
% pathname = '/Users/najmekhorasani/Library/CloudStorage/Dropbox/nj/myPrj/5-myofibroblasts/Netflux-master_Original/Netflux_NJ/models/';
% fileName= 'nj_aFb_model_with hormones_45.xlsx';

% flg_show = input('Do u wanna show shortest path? 1:yes 0:No');

global lenP pathM
lenP = [];
pathM = [];
% node_src = 'IL1';
% node_dest = 'CI';

%%input numbers + 1
% where non-input reactions start
% inpNo = 12;

%%
% networkSpecies = readtable([pathname,fileName], 'Sheet', 'species');
% networkReactions = readtable([pathname,fileName], 'Sheet', 'reactions');

speciesID = networkSpecies.ID;
node_test_list = speciesID';
%% make a directed graph for the network
graph = make_a_directed_graph(speciesID,networkReactions,input_No);

% ismember(strrep(splitted2{k}, ' ', ''),speciesID)
[~, src] = ismember(node_src,speciesID); % Source vertex
[~,dest] = ismember(node_dest,speciesID); % Source vertex; % Destination vertex


% Call the function to print all paths from source to destination
printAllPaths(graph, src, dest,speciesID,flg_all_path);

if ~isempty(pathM)
    %% find shortest paths
    % disp('###################');
    % disp('#########shortest path##########');
    [lenV, lenInd] = sort(lenP);
    pathM_sorted = pathM(lenInd);
    % disp(pathM_sorted{1})
    shortest_path = pathM_sorted{1};
    path_no = size(pathM,2);
else
    path_no = 0;
    shortest_path = [];
end
end

%% functions
function printAllPaths(graph, src, dest,speciesID,flg_all_path)
    global lenP pathM
    visited = false(length(graph), 1);
    path = [];
    printAllPathsUtil(graph, src, dest, visited, path,speciesID,flg_all_path);
end

function printAllPathsUtil(graph, u, dest, visited, path,speciesID,flg_all_path)
    global lenP pathM
    visited(u) = true;
    path = [path u];
    
    if u == dest
        %disp(path);
        if flg_all_path==1
        disp(speciesID(path)');
        end
        lenP = [lenP,length(path)];
        pathM{end+1}=speciesID(path)';
        if flg_all_path==1
        disp('====================================')
        end
    else
        neighbors = find(graph(u, :)); % find neighboring vertices
        for v = neighbors
            if ~visited(v)
                printAllPathsUtil(graph, v, dest, visited, path,speciesID,flg_all_path);
            end
        end
    end
    
    visited(u) = false; % backtrack
    path(end) = []; % remove the last vertex from the path
end

function graph = make_a_directed_graph(speciesID,networkReactions,inpNp)
networkReactionsRules = networkReactions.Rule(inpNp+1:end);

sz = size(speciesID,1 );
graph = zeros(sz,sz );
%formattedReactions = load('formattedReactions.mat');
%formattedReactions = formattedReactions.formattedReactions; % Extract from struct
% Initialize a cell array to store the parts after '=>'
formattedDest = cell(size(networkReactionsRules));
formattedSrc = cell(size(networkReactionsRules));
% Loop through each string in the cell array
for i = 1:numel(networkReactionsRules)
    
    s = networkReactionsRules{i};
    %modify the s
    % Step 1: Ensure one space around each '&'
    s = regexprep(s, '\s*&\s*', ' & ');
    % Step 2: Also normalize around '+' if needed
    s = regexprep(s, '\s*\+\s*', ' + ');
    % Step 3: Also normalize around '=>' if needed
    s = regexprep(s, '\s*=>\s*', ' => ');

    % Split the string based on '=>'
    splitted = strsplit(s, ' => ');
    
    % Extract the part after '=>'
    if numel(splitted) > 1
        if ~isempty(splitted{1})
            % disp(splitted{1})
            tmpsrc = splitted{1};
            splitted1 = strsplit(tmpsrc, ' & ');
            tmpSz = size(splitted1,2);
            for j=1:tmpSz
                tmpInd = strfind(splitted1{j}, '+');
                if ~isempty(tmpInd)
                    splitted2 = strsplit(splitted1{j}, ' + ');
                    for k=1:size(splitted2,2)
                        tmpInd = strfind(splitted2{k}, '!');
                        if ~isempty(tmpInd)
                            splitted2{k}(1)='';
                        end
                        [v1 ind1] = ismember(strrep(splitted2{k}, ' ', ''),speciesID);
                        [v2 ind2] = ismember(strrep(splitted{2}, ' ', ''),speciesID);
                        if ~isempty(tmpInd)
                            if graph(ind1,ind2)==0
                                graph(ind1,ind2) = -1;
                            elseif graph(ind1,ind2) == 1
                                 graph(ind1,ind2) = 2;
                            end
                        else
                            if graph(ind1,ind2)==0
                                graph(ind1,ind2) = 1;
                            elseif graph(ind1,ind2) == -1
                                 graph(ind1,ind2) = 2;
                            end
                        end
                    end
                else
                    tmpInd = strfind(splitted1{j}, '!');
                    if ~isempty(tmpInd)
                        splitted1{j}(1)='';
                    end
                    [v1 ind1] = ismember(strrep(splitted1{j}, ' ', ''),speciesID);
                    [v2 ind2] = ismember(strrep(splitted{2}, ' ', ''),speciesID);
                   
                    if ~isempty(tmpInd)
                        graph(ind1,ind2) = -1;
                    else
                        graph(ind1,ind2) = 1;
                    end
                end
            end
            
            

            
            formattedDest{i} = strtrim(splitted{2});
            formattedSrc{i} = strtrim(splitted{1});
        end
    % else
    %     % If '=>' is not found, store an empty string
    %     formattedDest{i} = '';
    %     formattedSrc{i} = '';
    end
end
end