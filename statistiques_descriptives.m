%Les statistiques descriptives seront effectueées sur les données bid d'échéance.
%La volatilité réalisée est calculé sur une période d'un an et les options
%utilisées sont d'échéance 1 an.

%AUDUSD
RV = audusd.rv3mB .* 100;
SWvv = audusd.sr3mB_vv * 100;
SWsc = audusd.sr3mB_sc .* 100;
SWatm = audusd.vol3mB(:,3);
VRPsc = audusd.vrp3mB_sc .* 100;
VRPvv = audusd.vrp3mB_vv .* 100;
VRPatm = audusd.vrp3mB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

audusdStats_3m = [moy; et; skew; kurt; pct5; pct95];

%EURUSD

RV = eurusd.rv3mB .* 100;
SWvv = eurusd.sr3mB_vv * 100;
SWsc = eurusd.sr3mB_sc .* 100;
SWatm = eurusd.vol3mB(:,3);
VRPsc = eurusd.vrp3mB_sc .* 100;
VRPvv = eurusd.vrp3mB_vv .* 100;
VRPatm = eurusd.vrp3mB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

eurusdStats_3m = [moy; et; skew; kurt; pct5; pct95];


%GBPUSD
RV = gbpusd.rv3mB .* 100;
SWvv = gbpusd.sr3mB_vv * 100;
SWsc = gbpusd.sr3mB_sc .* 100;
SWatm = gbpusd.vol3mB(:,3);
VRPsc = gbpusd.vrp3mB_sc .* 100;
VRPvv = gbpusd.vrp3mB_vv .* 100;
VRPatm = gbpusd.vrp3mB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

gbpusdStats_3m = [moy; et; skew; kurt; pct5; pct95];

%USDCAD
RV = usdcad.rv3mB .* 100;
SWvv = usdcad.sr3mB_vv * 100;
SWsc = usdcad.sr3mB_sc .* 100;
SWatm = usdcad.vol3mB(:,3);
VRPsc = usdcad.vrp3mB_sc .* 100;
VRPvv = usdcad.vrp3mB_vv .* 100;
VRPatm = usdcad.vrp3mB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

usdcadStats_3m = [moy; et; skew; kurt; pct5; pct95];

%USDCHF
RV = usdchf.rv3mB .* 100;
SWvv = usdchf.sr3mB_vv * 100;
SWsc = usdchf.sr3mB_sc .* 100;
SWatm = usdchf.vol3mB(:,3);
VRPsc = usdchf.vrp3mB_sc .* 100;
VRPvv = usdchf.vrp3mB_vv .* 100;
VRPatm = usdchf.vrp3mB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

usdchfStats_3m = [moy; et; skew; kurt; pct5; pct95];

% USDJPY
RV = usdjpy.rv3mB .* 100;
SWvv = usdjpy.sr3mB_vv * 100;
SWsc = usdjpy.sr3mB_sc .* 100;
SWatm = usdjpy.vol3mB(:,3);
VRPsc = usdjpy.vrp3mB_sc .* 100;
VRPvv = usdjpy.vrp3mB_vv .* 100;
VRPatm = usdjpy.vrp3mB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

usdjpyStats_3m = [moy; et; skew; kurt; pct5; pct95];


%AUDUSD
RV = audusd.rv1yB .* 100;
SWvv = audusd.sr1yB_vv * 100;
SWsc = audusd.sr1yB_sc .* 100;
SWatm = audusd.vol1yB(:,3);
VRPsc = audusd.vrp1yB_sc .* 100;
VRPvv = audusd.vrp1yB_vv .* 100;
VRPatm = audusd.vrp1yB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

audusdStats_1y = [moy; et; skew; kurt; pct5; pct95];


%EURUSD
RV = eurusd.rv1yB .* 100;
SWvv = eurusd.sr1yB_vv * 100;
SWsc = eurusd.sr1yB_sc .* 100;
SWatm = eurusd.vol1yB(:,3);
VRPsc = eurusd.vrp1yB_sc .* 100;
VRPvv = eurusd.vrp1yB_vv .* 100;
VRPatm = eurusd.vrp1yB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

eurusdStats_1y = [moy; et; skew; kurt; pct5; pct95];

%GBPUSD
RV = gbpusd.rv1yB .* 100;
SWvv = gbpusd.sr1yB_vv * 100;
SWsc = gbpusd.sr1yB_sc .* 100;
SWatm = gbpusd.vol1yB(:,3);
VRPsc = gbpusd.vrp1yB_sc .* 100;
VRPvv = gbpusd.vrp1yB_vv .* 100;
VRPatm = gbpusd.vrp1yB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

gbpusdStats_1y = [moy; et; skew; kurt; pct5; pct95];

%USDCAD
RV = usdcad.rv1yB .* 100;
SWvv = usdcad.sr1yB_vv * 100;
SWsc = usdcad.sr1yB_sc .* 100;
SWatm = usdcad.vol1yB(:,3);
VRPsc = usdcad.vrp1yB_sc .* 100;
VRPvv = usdcad.vrp1yB_vv .* 100;
VRPatm = usdcad.vrp1yB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

usdcadStats_1y = [moy; et; skew; kurt; pct5; pct95];

%USDCHF
RV = usdchf.rv1yB .* 100;
SWvv = usdchf.sr1yB_vv * 100;
SWsc = usdchf.sr1yB_sc .* 100;
SWatm = usdchf.vol1yB(:,3);
VRPsc = usdchf.vrp1yB_sc .* 100;
VRPvv = usdchf.vrp1yB_vv .* 100;
VRPatm = usdchf.vrp1yB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

usdchfStats_1y = [moy; et; skew; kurt; pct5; pct95];

% USDJPY
RV = usdjpy.rv1yB .* 100;
SWvv = usdjpy.sr1yB_vv * 100;
SWsc = usdjpy.sr1yB_sc .* 100;
SWatm = usdjpy.vol1yB(:,3);
VRPsc = usdjpy.vrp1yB_sc .* 100;
VRPvv = usdjpy.vrp1yB_vv .* 100;
VRPatm = usdjpy.vrp1yB_atm .* 100;

moy = [ mean(RV) mean(SWvv) mean(SWsc) mean(SWatm) mean(VRPvv) mean(VRPsc) mean(VRPatm)];
et = [ std(RV) std(SWvv) std(SWsc) std(SWatm) std(VRPvv) std(VRPsc) std(VRPatm)];
skew = [ skewness(RV) skewness(SWvv) skewness(SWsc) skewness(SWatm) skewness(VRPvv) skewness(VRPsc) skewness(VRPatm)];
kurt = [ kurtosis(RV) kurtosis(SWvv) kurtosis(SWsc) kurtosis(SWatm) kurtosis(VRPvv) kurtosis(VRPsc) kurtosis(VRPatm)];
pct5 = [ prctile(RV,5) prctile(SWvv,5) prctile(SWsc,5) prctile(SWatm,5) prctile(VRPvv,5) prctile(VRPsc,5) prctile(VRPatm,5)];
pct95 = [ prctile(RV,95) prctile(SWvv,95) prctile(SWsc,95) prctile(SWatm,95) prctile(VRPvv,95) prctile(VRPsc,95) prctile(VRPatm,95)];

usdjpyStats_1y = [moy; et; skew; kurt; pct5; pct95];