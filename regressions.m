% [frame_atm_dom_bid3m, frame_sc_dom_bid3m, frame_vv_dom_bid3m, frame_spot_dom_bid3m, frame_atm_for_bid3m, frame_sc_for_bid3m, frame_vv_for_bid3m, frame_spot_for_bid3m,...
%  frame_atm_dom_ask3m, frame_sc_dom_ask3m, frame_vv_dom_ask3m, frame_spot_dom_ask3m, frame_atm_for_ask3m, frame_sc_for_ask3m, frame_vv_for_ask3m, frame_spot_for_ask3m,...
%  frame_atm_dom_bid1y, frame_sc_dom_bid1y, frame_vv_dom_bid1y, frame_spot_dom_bid1y, frame_atm_for_bid1y, frame_sc_for_bid1y, frame_vv_for_bid1y, frame_spot_for_bid1y,...
%  frame_atm_dom_ask1y, frame_sc_dom_ask1y, frame_vv_dom_ask1y, frame_spot_dom_ask1y, frame_atm_for_ask1y, frame_sc_for_ask1y, frame_vv_for_ask1y, frame_spot_for_ask1y]...
%  = frame(audusd, eurusd, gbpusd, usdcad, usdchf, usdjpy);

series = 'bid1y';

if(strcmp(series, 'bid3m'))
    
    xvrp_dom_atm = (cell2mat(frame_atm_dom_bid3m{1}(:,2)) + cell2mat(frame_atm_dom_bid3m{2}(:,2)) + cell2mat(frame_atm_dom_bid3m{3}(:,2))) ./ 3;
    xvrp_dom_sc = (cell2mat(frame_sc_dom_bid3m{1}(:,2)) + cell2mat(frame_sc_dom_bid3m{2}(:,2)) + cell2mat(frame_sc_dom_bid3m{3}(:,2))) ./ 3;
    xvrp_dom_vv = (cell2mat(frame_vv_dom_bid3m{1}(:,2)) + cell2mat(frame_vv_dom_bid3m{2}(:,2)) + cell2mat(frame_vv_dom_bid3m{3}(:,2))) ./ 3;
    frame_dom_spot = frame_spot_dom_bid3m;
    
    xvrp_for_atm = (cell2mat(frame_atm_for_bid3m{1}(:,2)) + cell2mat(frame_atm_for_bid3m{2}(:,2)) + cell2mat(frame_atm_for_bid3m{3}(:,2))) ./ 3;
    xvrp_for_sc = (cell2mat(frame_sc_for_bid3m{1}(:,2)) + cell2mat(frame_sc_for_bid3m{2}(:,2)) + cell2mat(frame_sc_for_bid3m{3}(:,2))) ./ 3;
    xvrp_for_vv = (cell2mat(frame_vv_for_bid3m{1}(:,2)) + cell2mat(frame_vv_for_bid3m{2}(:,2)) + cell2mat(frame_vv_for_bid3m{3}(:,2))) ./ 3;
    frame_for_spot = frame_spot_for_bid3m;
    
elseif(strcmp(series, 'ask3m'))
    
    xvrp_dom_atm = (cell2mat(frame_atm_dom_ask3m{1}(:,2)) + cell2mat(frame_atm_dom_ask3m{2}(:,2)) + cell2mat(frame_atm_dom_ask3m{3}(:,2))) ./ 3;
    xvrp_dom_sc = (cell2mat(frame_sc_dom_ask3m{1}(:,2)) + cell2mat(frame_sc_dom_ask3m{2}(:,2)) + cell2mat(frame_sc_dom_ask3m{3}(:,2))) ./ 3;
    xvrp_dom_vv = (cell2mat(frame_vv_dom_ask3m{1}(:,2)) + cell2mat(frame_vv_dom_ask3m{2}(:,2)) + cell2mat(frame_vv_dom_ask3m{3}(:,2))) ./ 3;
    frame_dom_spot = frame_spot_dom_ask3m;
    
    xvrp_for_atm = (cell2mat(frame_atm_for_ask3m{1}(:,2)) + cell2mat(frame_atm_for_ask3m{2}(:,2)) + cell2mat(frame_atm_for_ask3m{3}(:,2))) ./ 3;
    xvrp_for_sc = (cell2mat(frame_sc_for_ask3m{1}(:,2)) + cell2mat(frame_sc_for_ask3m{2}(:,2)) + cell2mat(frame_sc_for_ask3m{3}(:,2))) ./ 3;
    xvrp_for_vv = (cell2mat(frame_vv_for_ask3m{1}(:,2)) + cell2mat(frame_vv_for_ask3m{2}(:,2)) + cell2mat(frame_vv_for_ask3m{3}(:,2))) ./ 3;
    frame_for_spot = frame_spot_for_ask3m;
    
elseif(strcmp(series, 'bid1y'))
    
    xvrp_dom_atm = (cell2mat(frame_atm_dom_bid1y{1}(:,2)) + cell2mat(frame_atm_dom_bid1y{2}(:,2)) + cell2mat(frame_atm_dom_bid1y{3}(:,2))) ./ 3;
    xvrp_dom_sc = (cell2mat(frame_sc_dom_bid1y{1}(:,2)) + cell2mat(frame_sc_dom_bid1y{2}(:,2)) + cell2mat(frame_sc_dom_bid1y{3}(:,2))) ./ 3;
    xvrp_dom_vv = (cell2mat(frame_vv_dom_bid1y{1}(:,2)) + cell2mat(frame_vv_dom_bid1y{2}(:,2)) + cell2mat(frame_vv_dom_bid1y{3}(:,2))) ./ 3;
    frame_dom_spot = frame_spot_dom_bid1y;
    
    xvrp_for_atm = (cell2mat(frame_atm_for_bid1y{1}(:,2)) + cell2mat(frame_atm_for_bid1y{2}(:,2)) + cell2mat(frame_atm_for_bid1y{3}(:,2))) ./ 3;
    xvrp_for_sc = (cell2mat(frame_sc_for_bid1y{1}(:,2)) + cell2mat(frame_sc_for_bid1y{2}(:,2)) + cell2mat(frame_sc_for_bid1y{3}(:,2))) ./ 3;
    xvrp_for_vv = (cell2mat(frame_vv_for_bid1y{1}(:,2)) + cell2mat(frame_vv_for_bid1y{2}(:,2)) + cell2mat(frame_vv_for_bid1y{3}(:,2))) ./ 3;
    frame_for_spot = frame_spot_for_bid1y;
    
elseif(strcmp(series, 'ask1y'))
    
    xvrp_dom_atm = (cell2mat(frame_atm_dom_ask1y{1}(:,2)) + cell2mat(frame_atm_dom_ask1y{2}(:,2)) + cell2mat(frame_atm_dom_ask1y{3}(:,2))) ./ 3;
    xvrp_dom_sc = (cell2mat(frame_sc_dom_ask1y{1}(:,2)) + cell2mat(frame_sc_dom_ask1y{2}(:,2)) + cell2mat(frame_sc_dom_ask1y{3}(:,2))) ./ 3;
    xvrp_dom_vv = (cell2mat(frame_vv_dom_ask1y{1}(:,2)) + cell2mat(frame_vv_dom_ask1y{2}(:,2)) + cell2mat(frame_vv_dom_ask1y{3}(:,2))) ./ 3;
    frame_dom_spot = frame_spot_dom_ask1y;
    
    xvrp_for_atm = (cell2mat(frame_atm_for_ask1y{1}(:,2)) + cell2mat(frame_atm_for_ask1y{2}(:,2)) + cell2mat(frame_atm_for_ask1y{3}(:,2))) ./ 3;
    xvrp_for_sc = (cell2mat(frame_sc_for_ask1y{1}(:,2)) + cell2mat(frame_sc_for_ask1y{2}(:,2)) + cell2mat(frame_sc_for_ask1y{3}(:,2))) ./ 3;
    xvrp_for_vv = (cell2mat(frame_vv_for_ask1y{1}(:,2)) + cell2mat(frame_vv_for_ask1y{2}(:,2)) + cell2mat(frame_vv_for_ask1y{3}(:,2))) ./ 3;
    frame_for_spot = frame_spot_for_ask1y;
    
end

audusdstats_atm = zeros(12, 12);
eurusdstats_atm = zeros(12, 12);
gbpusdstats_atm = zeros(12, 12);
usdcadstats_atm = zeros(12, 12);
usdchfstats_atm = zeros(12, 12);
usdjpystats_atm = zeros(12, 12);

audusdstats_sc = zeros(12, 12);
eurusdstats_sc = zeros(12, 12);
gbpusdstats_sc = zeros(12, 12);
usdcadstats_sc = zeros(12, 12);
usdchfstats_sc = zeros(12, 12);
usdjpystats_sc = zeros(12, 12);

audusdstats_vv = zeros(12, 12);
eurusdstats_vv = zeros(12, 12);
gbpusdstats_vv = zeros(12, 12);
usdcadstats_vv = zeros(12, 12);
usdchfstats_vv = zeros(12, 12);
usdjpystats_vv = zeros(12, 12);

%AUDUSD
ys = cell2mat(frame_dom_spot{1}(:,2));
xs_atm = [ones(length(xvrp_dom_atm),1), xvrp_dom_atm];
xs_sc = [ones(length(xvrp_dom_sc),1), xvrp_dom_sc];
xs_vv = [ones(length(xvrp_dom_vv),1), xvrp_dom_vv];

for i = 1:12
    %ATM
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_atm(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    audusdstats_atm(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %sc
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_sc(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    audusdstats_sc(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %vv
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_vv(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    audusdstats_vv(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
end

%EURUSD
ys = cell2mat(frame_dom_spot{2}(:,2));
xs_atm = [ones(length(xvrp_dom_atm),1), xvrp_dom_atm];
xs_sc = [ones(length(xvrp_dom_sc),1), xvrp_dom_sc];
xs_vv = [ones(length(xvrp_dom_vv),1), xvrp_dom_vv];

for i = 1:12
    %ATM
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_atm(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    eurusdstats_atm(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %sc
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_sc(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    eurusdstats_sc(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %vv
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_vv(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    eurusdstats_vv(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
end

%GBPUSD
ys = cell2mat(frame_dom_spot{3}(:,2));
xs_atm = [ones(length(xvrp_dom_atm),1), xvrp_dom_atm];
xs_sc = [ones(length(xvrp_dom_sc),1), xvrp_dom_sc];
xs_vv = [ones(length(xvrp_dom_vv),1), xvrp_dom_vv];

for i = 1:12
    %ATM
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_atm(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    gbpusdstats_atm(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %sc
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_sc(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    gbpusdstats_sc(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %vv
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_vv(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    gbpusdstats_vv(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
end

%USDCAD
ys = cell2mat(frame_for_spot{1}(:,2));
xs_atm = [ones(length(xvrp_for_atm),1), xvrp_for_atm];
xs_sc = [ones(length(xvrp_for_sc),1), xvrp_for_sc];
xs_vv = [ones(length(xvrp_for_vv),1), xvrp_for_vv];

for i = 1:12
    %ATM
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_atm(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdcadstats_atm(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %sc
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_sc(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdcadstats_sc(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %vv
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_vv(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdcadstats_vv(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
end

%USDCHF
ys = cell2mat(frame_for_spot{2}(:,2));
xs_atm = [ones(length(xvrp_for_atm),1), xvrp_for_atm];
xs_sc = [ones(length(xvrp_for_sc),1), xvrp_for_sc];
xs_vv = [ones(length(xvrp_for_vv),1), xvrp_for_vv];

for i = 1:12
    %ATM
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_atm(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdchfstats_atm(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %sc
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_sc(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdchfstats_sc(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %vv
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_vv(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdchfstats_vv(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
end

%USDJPY
ys = cell2mat(frame_for_spot{1}(:,2));
xs_atm = [ones(length(xvrp_for_atm),1), xvrp_for_atm];
xs_sc = [ones(length(xvrp_for_sc),1), xvrp_for_sc];
xs_vv = [ones(length(xvrp_for_vv),1), xvrp_for_vv];

for i = 1:12
    %ATM
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_atm(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdjpystats_atm(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %sc
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_sc(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdjpystats_sc(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
    
    %vv
    ysreg = (ys(1+i:end) ./ ys(1:end-i)) - 1;
    xsreg = xs_vv(1:end-i,:);
    [betas, rcarre, seHH, tstatsHH, seR, tstats, pval] = olsreg(xsreg, ysreg, i);
    usdjpystats_vv(i, :) = [betas(1) betas(2) rcarre seHH(1) seHH(2) tstatsHH(1) tstatsHH(2) seR(1) seR(2) tstats(1) tstats(2) pval];
end

