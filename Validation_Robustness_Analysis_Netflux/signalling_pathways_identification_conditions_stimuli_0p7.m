function cond = signalling_pathways_identification_conditions_stimuli_0p7(flg)
co = 1;
% It2reachSS, y0_name, yo_ind, Ymax_ind, Ymax_val, input values, high Vals
if flg==1
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'AngII'},[0.7]}; co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'AngII'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'AngII'},[0.7]};co = co+1;
end

if flg==2
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'AngII','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'AngII','E2'},[0.7,1]};co = co+1;
end

if flg==3
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'AngII','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'AngII','PG'},[0.7,1]};co = co+1;
end

if flg==4
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'AngII','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'AngII','TS'},[0.7,1]};co = co+1;
end

if flg==5
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'TGFB'},[0.7]}; co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'TGFB'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'TGFB'},[0.7]};co = co+1;
end

if flg==6
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'TGFB','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'TGFB','E2'},[0.7,1]};co = co+1;
end

if flg==7
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'TGFB','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'TGFB','PG'},[0.7,1]};co = co+1;
end

if flg==8
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'TGFB','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'TGFB','TS'},[0.7,1]};co = co+1;
end

if flg==9
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'PG'},[0.7]}; co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'PG'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'PG'},[0.7]};co = co+1;
end

if flg==10
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'TS'},[0.7]}; co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'TS'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'TS'},[0.7]};co = co+1;
end
if flg==11
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'E2'},[0.7]}; co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'E2'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'E2'},[0.7]};co = co+1;
end

if flg==12
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'ET1'},[0.7]}; co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'ET1'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'ET1'},[0.7]};co = co+1;
end

if flg==13
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'ET1','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'ET1','E2'},[0.7,1]};co = co+1;
end

if flg==14
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'ET1','PG'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'ET1','PG'},[0.7,1]};co = co+1;
end

if flg==15
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'ET1','TS'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'ET1','TS'},[0.7,1]};co = co+1;
end

if flg==16
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'TGFB','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'TGFB','E2'},[0.7,0.75]};co = co+1;
end

if flg==17
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'AngII','E2'},[0.7,0.75]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'AngII','E2'},[0.7,0.75]};co = co+1;
end

if flg==18
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'mechanical'},[0.7]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'mechanical'},[0.7]};co = co+1;
end

if flg==19
cond{co} = {20, {'yCumBL'},[120*10], [], [], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [.1], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TGFB'}, [1.5], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [.1], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL6'}, [1.5], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [.1], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'IL1'}, [1.5], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [.1], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNFa'}, [1.5], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [.1], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'ET1'}, [1.5], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [.1], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'FGF23'}, [1.5], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [.1], {'mechanical','E2'},[0.7,1]};co = co+1;
cond{co} = {20, {'yCumBL'},[120*10], {'TNC'}, [1.5], {'mechanical','E2'},[0.7,1]};co = co+1;
end


end