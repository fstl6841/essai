% %%%%%%%%figure 1, volatilité implicites brutes
% figure
% plot(audusd.vol3mB(1,:),'O-', 'LineWidth', 2.5)
% titre = strcat('Volatilités implicites brutes - AUD/USD - 3 janvier 2005');
% title(titre)
% xlabel('Delta')
% ylabel('Volatilité')
% labels = {'10 delta put', '25 delta put', 'At the money', '25 delta call', '10 delta call'};
% set(gca, 'XTick', 1:5,  'xticklabel', labels, 'fontsize', 10)

% %%%%%%%% figure 2-1, delta premium-adjusted pour les puts
% fPrice = cell2mat(audusd.forward(1,4));
% strike = 0;
% rf  = cell2mat(audusd.taux(1,4)) ./ 100;
% 
% %Trouver les strikes pour les put 0.1 delta
% vol = audusd.vol3mB(1,1)./100;
% f = fPrice;
% r = rf;
% t = 1;
% k = 0:0.01:2;
% 
% %Équation 14 Reiswich
% delta = -exp(-r .* t) .* (k ./ f) .* normcdf(-((log(f ./ k) - 0.5 .* vol.^2 .* t) ./ (vol .* sqrt(t))));
% 
% figure
% plot(k, delta,'b','linewidth', 3)
% set(gca, 'fontsize', 10)
% xlabel('Prix d''exercice')
% ylabel('Delta')
% titre = 'Delta d''une option de vente "premium adjusted"';
% title(titre)

% %%%%%%%% figure 2-2, delta premium-adjusted pour les call
% fPrice = cell2mat(audusd.forward(1,4));
% strike = 0;
% rf  = cell2mat(audusd.taux(1,4)) ./ 100;
% 
% %Trouver les strikes pour les put 0.1 delta
% vol = audusd.vol3mB(1,5)./100;
% f = fPrice;
% r = rf;
% t = 1;
% k = 0:0.01:2;
% 
% %Équation 14 Reiswich
% delta = exp(-r .* t) .* (k ./ f) .* normcdf((log(f ./ k) - 0.5 .* vol.^2 .* t) ./ (vol .* sqrt(t)));
% 
% figure
% plot(k, delta,'b','linewidth', 3)
% set(gca, 'fontsize', 10)
% xlabel('Prix d''exercice')
% ylabel('Delta')
% titre = 'Delta d''une option d''achat "premium adjusted"';
% title(titre)

% %%%%%%%%figure 3, volatilité implicites brutes avec prix d'exercices
% figure
% plot(audusd.strikes_3mB(1,:),audusd.vol3mB(1,:),'O-', 'LineWidth', 2.5)
% titre = strcat('Volatilités implicites brutes - AUD/USD - 3 janvier 2005');
% title(titre)
% xlabel('Strikes')
% ylabel('Volatilité')
% set(gca, 'fontsize', 10)

% %%%%%%%% figure 4-1, spline cubique non réaliste
% index = 500;
% strikes_1yb = usdcad.strikes_1yB;
% strikes_1yB_sc = [usdcad.strikes_1yB_G usdcad.strikes_1yB_D(:,2:end)];
% 
% vol_1yB = usdcad.vol1yB;
% 
% smile_1yB_sc = zeros(length(vol_1yB), size(usdcad.strikes_1yB_G, 2) + size(usdcad.strikes_1yB_D, 2) - 1);
% 
% long = length(usdcad.smile_1yB_sc);
% 
% for i = 1:long
%     smile_1yB_sc(i,:) = spline(strikes_1yb(i,:), vol_1yB(i,:), strikes_1yB_sc(i,:));
% end
% 
% figure
% plot(strikes_1yb(index,:), vol_1yB(index,:),'* k' ,strikes_1yB_sc(index,40:80), smile_1yB_sc(index,40:80), 'r', 'LineWidth',3);
% titre = strcat('Graphique des smiles de volatilité',{' - '}, {'USD/CAD'}, {' - '}, char(usdcad.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique')

% %%%%%%%% figure 4-2, spline cubique non réaliste
% index = 800;
% strikes_1yb = usdjpy.strikes_1yB;
% strikes_1yB_sc = [usdjpy.strikes_1yB_G usdjpy.strikes_1yB_D(:,2:end)];
% 
% vol_1yB = usdjpy.vol1yB;
% 
% smile_1yB_sc = zeros(length(vol_1yB), size(usdjpy.strikes_1yB_G, 2) + size(usdjpy.strikes_1yB_D, 2) - 1);
% 
% long = length(usdjpy.smile_1yB_sc);
% 
% for i = 1:long
%     smile_1yB_sc(i,:) = spline(strikes_1yb(i,:), vol_1yB(i,:), strikes_1yB_sc(i,:));
% end
% 
% figure
% plot(strikes_1yb(index,:), vol_1yB(index,:),'* k' ,strikes_1yB_sc(index,40:80), smile_1yB_sc(index,40:80), 'r', 'LineWidth',3);
% titre = strcat('Graphique des smiles de volatilité',{' - '}, {'USD/JPY'}, {' - '}, char(usdjpy.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique')

% % %%%%%%%%figure 5, graphiques des smiles similaires
% index = 26;
% vol = eurusd.vol1yB(index,:);
% strike_brut = eurusd.strikes_1yB(index,:);
% strike_int = [eurusd.strikes_1yB_G(index,1:end-1) eurusd.strikes_1yB_D(index,:)];
% smile_sc = eurusd.smile_1yB_sc(index,:) .* 100;
% smile_vv = eurusd.smile_1yB_vv(index,:) .* 100;
% 
% figure
% plot(strike_brut, vol,'* k' ,strike_int, smile_sc, 'r' ,strike_int, smile_vv,'k', 'LineWidth',3);
% titre = strcat('Graphique des smiles de volatilité',{' - '}, {'EUR/USD'}, {' - '}, char(eurusd.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique', 'Smile Vanna-Volga')

% % %%%%%%%%figure 6, graphiques des smiles problématiques
% index = 500;
% vol = usdcad.vol1yB(index,:);
% strike_brut = usdcad.strikes_1yB(index,:);
% strike_int = [usdcad.strikes_1yB_G(index,1:end-1) usdcad.strikes_1yB_D(index,:)];
% smile_sc = usdcad.smile_1yB_sc(index,:) .* 100;
% smile_vv = usdcad.smile_1yB_vv(index,:) .* 100;
% 
% figure
% plot(strike_brut, vol,'* k' ,strike_int(40:80), smile_sc(40:80), 'r' ,strike_int(40:80), smile_vv(40:80),'k', 'LineWidth',3);
% titre = strcat('Graphique des smiles de volatilité',{' - '}, {'USD/CAD'}, {' - '}, char(usdcad.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique', 'Smile Vanna-Volga')

% % %%%%%%%%figure 7, graphiques des smiles problématiques (0 vol)
% index = 800;
% vol = usdjpy.vol1yB(index,:);
% strike_brut = usdjpy.strikes_1yB(index,:);
% strike_int = [usdjpy.strikes_1yB_G(index,1:end-1) usdjpy.strikes_1yB_D(index,:)];
% smile_sc = usdjpy.smile_1yB_sc(index,:) .* 100;
% smile_vv = usdjpy.smile_1yB_vv(index,:) .* 100;
% 
% figure
% plot(strike_brut, vol,'* k' ,strike_int(40:80), smile_sc(40:80), 'r' ,strike_int(40:80), smile_vv(40:80),'k', 'LineWidth',3);
% titre = strcat('Graphique des smiles de volatilité',{' - '}, {'USD/JPY'}, {' - '}, char(usdjpy.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique', 'Smile Vanna-Volga')

% %%%%%%%%%% figure 8, graphique de l'intégrale de Carr et Wu sur des
% % données brutes
% 
% volc = audusd.vol1yB(1,3:5) ./ 100;
% volp = audusd.vol1yB(1,1:3) ./ 100;
% 
% rf = (cell2mat(audusd.taux(1,3)) ./ 100) * ones(1,3);
% rd = (cell2mat(audusd.taux(1,5)) ./ 100) * ones(1,3);
% 
% kp = audusd.strikes_3mB(1,1:3);
% % kp(1,3) = cell2mat(audusd.forward(1,3));
% kc = audusd.strikes_3mB(1,3:5);
% % kc(1,1) = cell2mat(audusd.forward(1,3));
% t = 0.25 * ones(1,3);
% spot = cell2mat(audusd.spot(1,3)) * ones(1,3);
% calls = blsprice(spot, kc, rd, t, volc, rf);
% [lol, puts] = blsprice(spot, kp, rd, t, volp, rf);
% calls = calls ./ kc.^2;
% puts = puts ./ kp.^2;
% 
% figure
% plot(kc, calls, kp, puts, 'LineWidth', 3)
% titre = strcat('Intégrale de Carr et Wu sur données brutes');
% title(titre)
% xlabel('Strikes')
% ylabel('Prix des options Out of the money / K^2')
% set(gca,'fontsize',10)

% %%%%%%%%%%%%% figure 9, intégrale de Carr et Wu sur smile complet.
% index = 1;
% uns = ones(1,60);
% rf = cell2mat(audusd.taux(index,2)) ./ 100 * uns;
% rd = cell2mat(audusd.taux(index,4)) ./ 100 * uns;
% s0 = cell2mat(audusd.spot(index,2)) * uns;
% vol_put = audusd.smile_3mB_vv(index,1:60);
% vol_call = audusd.smile_3mB_vv(index,60:end);
% strikes_calls = audusd.strikes_3mB_D(index,:);
% strikes_puts = audusd.strikes_3mB_G(index,:);
% 
% calls = audusd.blsCall(s0, strikes_calls, rd, 0.25, vol_call, rf);
% puts = audusd.blsPut(s0, strikes_puts, rd, 0.25, vol_put, rf);
% 
% calls = calls ./ strikes_calls .^ 2;
% puts = puts ./ strikes_puts .^ 2;
% 
% plot(strikes_puts, puts, strikes_calls, calls, 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Intégrale de Carr et Wu sur smile complet')
% xlabel('Strikes')
% ylabel('Prix des options Out of the money / K^2')

% % %%%%%%%%figure 10-1, graphique spline cubique
% index = 1000;
% vol = usdjpy.vol1yB(index,:);
% strike_brut = usdjpy.strikes_1yB(index,:);
% strike_int = [usdjpy.strikes_1yB_G(index,1:end-1) usdjpy.strikes_1yB_D(index,:)];
% smile_sc = usdjpy.smile_1yB_sc(index,:) .* 100;
% 
% figure
% plot(strike_brut, vol,'* K' ,strike_int(40:80), smile_sc(40:80), 'r', 'LineWidth',3);
% titre = strcat('Graphique du smile de volatilité (spline cubique)',{' - '}, {'USD/JPY'}, {' - '}, char(usdjpy.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique')

% %%%%%%%%%%%%% figure 10-2, intégrale de Carr et Wu sur smile complet (pas beau).
% index = 1000;
% uns = ones(1,60);
% rf = cell2mat(usdjpy.taux(index,6)) ./ 100 * uns;
% rd = cell2mat(usdjpy.taux(index,8)) ./ 100 * uns;
% s0 = cell2mat(usdjpy.spot(index,2)) * uns;
% vol_put = usdjpy.smile_1yB_sc(index,1:60);
% vol_call = usdjpy.smile_1yB_sc(index,60:end);
% strikes_calls = usdjpy.strikes_1yB_D(index,:);
% strikes_puts = usdjpy.strikes_1yB_G(index,:);
% t = 1;
% calls = usdjpy.blsCall(s0, strikes_calls, rd, t, vol_call, rf);
% puts = usdjpy.blsPut(s0, strikes_puts, rd, t, vol_put, rf);
% 
% calls = calls ./ strikes_calls .^ 2;
% puts = puts ./ strikes_puts .^ 2;
% 
% plot(strikes_puts, puts, strikes_calls, calls, 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Intégrale de Carr et Wu sur smile complet (spline cubique)')
% xlabel('Strikes')
% ylabel('Prix des options Out of the money / K^2')


% %%%%%%%%% figure 11, graphique des taux de swap de volatilité
% index1 = 200;
% index2 = 1200;
% 
% sr_sc = usdcad.sr1yB_sc(index1:index2) .* 100;
% sr_vv = usdcad.sr1yB_vv(index1:index2) .* 100;
% vol_atm = usdcad.vol1yB(index1:index2,3);
% date = usdcad.current_dates(index1:index2);
% 
% figure
% plot(date, sr_sc,'k', date, sr_vv, 'r', date, vol_atm, 'b', 'linewidth', 1)
% set(gca, 'fontsize', 10)
% titre = strcat('Graphique des taux de swap de volatilité - USD/CAD');
% title(titre)
% xlabel('Dates')
% ylabel('Taux de swap')
% legend('Swap spline cubique', 'Swap Vanna-Volga', 'Vol at-the-money')

% %%%%%%%% figure 12-1, series VRP
% 
% index1 = 1;
% index2 = length(eurusd.vrp1yB_vv);
% debut = length(eurusd.sr1yB_vv) - length(eurusd.vrp1yB_vv) + 1;
% date = eurusd.current_dates(debut:end);
% date = date(index1:index2);
% vrp_sc = eurusd.vrp1yB_sc(index1:index2) .* 100;
% vrp_vv = eurusd.vrp1yB_vv(index1:index2) .* 100;
% figure
% plot(date, vrp_sc,'k', date, vrp_vv, 'r', 'linewidth', 1)
% set(gca, 'fontsize', 10)
% titre = 'VRP échéance 1 an - EUR/USD';
% title(titre)
% xlabel('Dates')
% ylabel('VRP')
% legend('VRP spline cubique', 'VRP Vanna-Volga')

% %%%%%%% figure 12-2, series VRP
% index1 = 1;
% index2 = length(usdjpy.vrp1yB_vv);
% debut = length(usdjpy.sr1yB_vv) - length(usdjpy.vrp1yB_vv) + 1;
% date = usdjpy.current_dates(debut:end);
% date = date(index1:index2);
% vrp_sc = usdjpy.vrp1yB_sc(index1:index2) .* 100;
% vrp_vv = usdjpy.vrp1yB_vv(index1:index2) .* 100;
% figure
% plot(date, vrp_sc,'k', date, vrp_vv, 'r', 'linewidth', 1)
% set(gca, 'fontsize', 10)
% titre = 'VRP échéance 1 an - USD/JPY';
% title(titre)
% xlabel('Dates')
% ylabel('VRP')
% legend('VRP spline cubique', 'VRP Vanna-Volga')

% %%%%%%% figure 13-1, distribution AUDUSD - 3 mois
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.3;
% figure
% histogram(audusd.vrp3mB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(audusd.vrp3mB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(audusd.vrp3mB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% 
% titre = 'Distributions VRP AUD/USD - 3 mois';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%%% figure 13-2, distribution AUDUSD - 1 an
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.15;
% figure
% histogram(audusd.vrp1yB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(audusd.vrp1yB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(audusd.vrp1yB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP AUD/USD - 1 an';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%%% figure 13-3, distribution EURUSD - 3 mois
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.1;
% figure
% histogram(eurusd.vrp3mB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(eurusd.vrp3mB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(eurusd.vrp3mB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP EUR/USD - 3 mois';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money','Vanna-Volga', 'Spline cubique')
% 
% %%%%%%% figure 13-4, distribution EURUSD - 1 an
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.1;
% figure
% histogram(eurusd.vrp1yB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(eurusd.vrp1yB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(eurusd.vrp1yB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP EUR/USD - 1 an';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%% figure 13-5, distribution GBPUSD - 3 mois
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.1;
% figure
% histogram(gbpusd.vrp3mB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(gbpusd.vrp3mB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(gbpusd.vrp3mB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP GBP/USD - 3 mois';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money','Vanna-Volga', 'Spline cubique')

% %%%%%%%% figure 13-6, distribution GBPUSD - 1 an
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.1;
% figure
% histogram(gbpusd.vrp1yB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(gbpusd.vrp1yB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(gbpusd.vrp1yB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP GBP/USD - 1 an';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%%% figure 14-1, distribution USDCAD - 3 mois
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.1;
% figure
% histogram(usdcad.vrp3mB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdcad.vrp3mB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdcad.vrp3mB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP USD/CAD - 3 mois';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%%%% figure 14-2, distribution USDCAD - 1 an
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.1;
% figure
% histogram(usdcad.vrp1yB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdcad.vrp1yB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdcad.vrp1yB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP USD/CAD - 1 an';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%% figure 14-3, distribution USDCHF - 3 mois
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.15;
% figure
% histogram(usdchf.vrp3mB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdchf.vrp3mB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdchf.vrp3mB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP USD/CHF - 3 mois';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%%%% figure 14-4, distribution USDCHF - 1 an
% map = brewermap(3,'Set1');
% min = -0.15;
% ecart = 0.005;
% max = 0.15;
% figure
% histogram(usdchf.vrp1yB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdchf.vrp1yB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdchf.vrp1yB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP USD/CHF - 1 an';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%% figure 14-5, distribution USDJPY - 3 mois
% map = brewermap(3,'Set1');
% min = -0.1;
% ecart = 0.005;
% max = 0.15;
% figure
% histogram(usdjpy.vrp3mB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdjpy.vrp3mB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdjpy.vrp3mB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP USD/JPY - 3 mois';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%%% figure 14-6, distribution USDJPY - 1 an
% map = brewermap(3,'Set1');
% min = -0.15;
% ecart = 0.005;
% max = 0.15;
% figure
% histogram(usdjpy.vrp1yB_atm, min:ecart:max, 'FaceColor', map(3,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdjpy.vrp1yB_vv, min:ecart:max, 'FaceColor', map(1,:), 'FaceAlpha', 0.5)
% hold on
% histogram(usdjpy.vrp1yB_sc, min:ecart:max, 'FaceColor', map(2,:), 'FaceAlpha', 0.5)
% 
% titre = 'Distributions VRP USD/JPY - 1 an';
% title(titre)
% xlabel('VRP')
% ylabel('Nombre de données')
% legend('At the money', 'Vanna-Volga', 'Spline cubique')

% %%%%%%%%%%%%figure 15-1
% rcarre = [audusdstats_sc(:,3) audusdstats_vv(:,3) audusdstats_atm(:,3)];
% xs = 1:12;
% plot(xs, rcarre(:,1), 'r', xs, rcarre(:,2), 'b', xs, rcarre(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Horizon de prévision (mois)')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 15-2
% pval = [audusdstats_sc(:,12) audusdstats_vv(:,12) audusdstats_atm(:,12)];
% xs = 1:12;
% plot(xs, pval(:,1), 'r', xs, pval(:,2), 'b', xs, pval(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value du F-test')
% xlabel('Horizon de prévision (mois)')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 15-3
% b0 = [audusdstats_sc(:,1) audusdstats_vv(:,1) audusdstats_atm(:,1)];
% xs = 1:12;
% plot(xs, b0(:,1), 'r', xs, b0(:,2), 'b',  xs, b0(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 15-4
% b1 = [audusdstats_sc(:,2) audusdstats_vv(:,2) audusdstats_atm(:,2)];
% xs = 1:12;
% plot(xs, b1(:,1), 'r', xs, b1(:,2), 'b', xs, b1(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 15-5
% ttest = [audusdstats_sc(:,10) audusdstats_vv(:,10) audusdstats_atm(:,10)];
% ttestHH = [audusdstats_sc(:,6) audusdstats_vv(:,6) audusdstats_atm(:,6)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')

% %%%%%%%%%%%%%figure 15-6
% ttest = [audusdstats_sc(:,11) audusdstats_vv(:,11) audusdstats_atm(:,11)];
% ttestHH = [audusdstats_sc(:,7) audusdstats_vv(:,7) audusdstats_atm(:,7)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')

% %%%%%%%%%%%%figure 16-1
% rcarre = [eurusdstats_sc(:,3) eurusdstats_vv(:,3) eurusdstats_atm(:,3)];
% xs = 1:12;
% plot(xs, rcarre(:,1), 'r', xs, rcarre(:,2), 'b', xs, rcarre(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Horizon de prévision (mois)')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 16-2
% pval = [eurusdstats_sc(:,12) eurusdstats_vv(:,12) eurusdstats_atm(:,12)];
% xs = 1:12;
% plot(xs, pval(:,1), 'r', xs, pval(:,2), 'b',  xs, pval(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value du F-test')
% xlabel('Horizon de prévision (mois)')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 16-3
% b0 = [eurusdstats_sc(:,1) eurusdstats_vv(:,1) eurusdstats_atm(:,1)];
% xs = 1:12;
% plot(xs, b0(:,1), 'r', xs, b0(:,2), 'b', xs, b0(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 16-4
% b1 = [eurusdstats_sc(:,2) eurusdstats_vv(:,2) eurusdstats_atm(:,2)];
% xs = 1:12;
% plot(xs, b1(:,1), 'r', xs, b1(:,2), 'b', xs, b1(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 16-5
% ttest = [eurusdstats_sc(:,10) eurusdstats_vv(:,10) eurusdstats_atm(:,10)];
% ttestHH = [eurusdstats_sc(:,6) eurusdstats_vv(:,6) eurusdstats_atm(:,6)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')

% %%%%%%%%%%%%%figure 16-6
% ttest = [eurusdstats_sc(:,11) eurusdstats_vv(:,11) eurusdstats_atm(:,11)];
% ttestHH = [eurusdstats_sc(:,7) eurusdstats_vv(:,7) eurusdstats_atm(:,7)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')

% %%%%%%%%%%%%figure 17-1
% rcarre = [gbpusdstats_sc(:,3) gbpusdstats_vv(:,3) gbpusdstats_atm(:,3)];
% xs = 1:12;
% plot(xs, rcarre(:,1), 'r', xs, rcarre(:,2), 'b', xs, rcarre(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Horizon de prévision (mois)')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 17-2
% pval = [gbpusdstats_sc(:,12) gbpusdstats_vv(:,12) gbpusdstats_atm(:,12)];
% xs = 1:12;
% plot(xs, pval(:,1), 'r', xs, pval(:,2), 'b', xs, pval(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value du F-test')
% xlabel('Horizon de prévision (mois)')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 17-3
% b0 = [gbpusdstats_sc(:,1) gbpusdstats_vv(:,1) gbpusdstats_atm(:,1)];
% xs = 1:12;
% plot(xs, b0(:,1), 'r', xs, b0(:,2), 'b', xs, b0(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 17-4
% b1 = [gbpusdstats_sc(:,2) gbpusdstats_vv(:,2) gbpusdstats_atm(:,2)];
% xs = 1:12;
% plot(xs, b1(:,1), 'r', xs, b1(:,2), 'b', xs, b1(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 17-5
% ttest = [gbpusdstats_sc(:,10) gbpusdstats_vv(:,10) gbpusdstats_atm(:,10)];
% ttestHH = [gbpusdstats_sc(:,6) gbpusdstats_vv(:,6) gbpusdstats_atm(:,6)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')

% %%%%%%%%%%%%%figure 17-6
% ttest = [gbpusdstats_sc(:,11) gbpusdstats_vv(:,11) gbpusdstats_atm(:,11)];
% ttestHH = [gbpusdstats_sc(:,7) gbpusdstats_vv(:,7) gbpusdstats_atm(:,7)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')

% %%%%%%%%%%%%figure 18-1
% rcarre = [usdchfstats_sc(:,3) usdchfstats_vv(:,3) usdchfstats_atm(:,3)];
% xs = 1:12;
% plot(xs, rcarre(:,1), 'r', xs, rcarre(:,2), 'b', xs, rcarre(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Horizon de prévision (mois)')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 18-2
% pval = [usdchfstats_sc(:,12) usdchfstats_vv(:,12) usdchfstats_atm(:,12)];
% xs = 1:12;
% plot(xs, pval(:,1), 'r', xs, pval(:,2), 'b', xs, pval(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value du F-test')
% xlabel('Horizon de prévision (mois)')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 18-3
% b0 = [usdchfstats_sc(:,1) usdchfstats_vv(:,1) usdchfstats_atm(:,1)];
% xs = 1:12;
% plot(xs, b0(:,1), 'r', xs, b0(:,2), 'b', xs, b0(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 18-4
% b1 = [usdchfstats_sc(:,2) usdchfstats_vv(:,2) usdchfstats_atm(:,2)];
% xs = 1:12;
% plot(xs, b1(:,1), 'r', xs, b1(:,2), 'b', xs, b1(:,3), 'k', 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 18-5
% ttest = [usdchfstats_sc(:,10) usdchfstats_vv(:,10) usdchfstats_atm(:,10)];
% ttestHH = [usdchfstats_sc(:,6) usdchfstats_vv(:,6) usdchfstats_atm(:,6)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient alpha')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')

% %%%%%%%%%%%%%figure 18-6
% ttest = [usdchfstats_sc(:,11) usdchfstats_vv(:,11) usdchfstats_atm(:,11)];
% ttestHH = [usdchfstats_sc(:,7) usdchfstats_vv(:,7) usdchfstats_atm(:,7)];
% seuil = ones(12,1) .* 1.984;
% xs = 1:12;
% plot(xs, seuil, 'k', xs, ttest(:,1), 'r', xs, ttest(:,2), 'b', xs, ttest(:,3), 'k' , xs, ttestHH(:,1) , 'r--', xs, ttestHH(:,2), 'b--', xs, ttestHH(:,3), 'k--', 'linewidth', 2)
% % plot(xs, ttestHH(:,1), xs, ttestHH(:,2), xs, ttestHH(:,3), '*')
% set(gca, 'fontsize', 10)
% title('Statistique T, coefficient beta')
% xlabel('Horizon de prévision (mois)')
% ylabel('T-stat')
% legend('SC', 'VV', 'ATM', 'SC HH', 'VV HH', 'ATM HH', 'location', 'northwest')







% %%%%%%%%%%%%%figure 15-4
% b1 = audusdb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%figure 16-1
% rcarre = eurusdrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 16-2
% pval = eurusdpval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 16-3
% b0 = eurusdb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 16-4
% b1 = eurusdb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%figure 17-1
% rcarre = usdjpyrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 17-2
% pval = usdjpypval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 17-3
% b0 = usdjpyb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%figure 17-4
% b1 = usdjpyb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')













% %%%%%%%% figure 11-1, delta premium-adjusted pour les puts
% fPrice = cell2mat(audusd.forward(1,4));
% strike = 0;
% rf  = cell2mat(audusd.taux(1,4)) ./ 100;
% 
% %Trouver les strikes pour les put 0.1 delta
% vol = audusd.vol3mB(1,1)./100;
% f = fPrice;
% r = rf;
% t = 1;
% k = 0:0.01:2;
% 
% %Équation 14 Reiswich
% delta = -exp(-r .* t) .* (k ./ f) .* normcdf(-((log(f ./ k) - 0.5 .* vol.^2 .* t) ./ (vol .* sqrt(t))));
% 
% figure
% plot(k, delta,'b','linewidth', 3)
% set(gca, 'fontsize', 10)
% xlabel('Prix d''exercice')
% ylabel('Delta')
% titre = 'Delta d''une option de vente "premium adjusted"';
% title(titre)

% %%%%%%%% figure 11-2, delta premium-adjusted pour les call
% fPrice = cell2mat(audusd.forward(1,4));
% strike = 0;
% rf  = cell2mat(audusd.taux(1,4)) ./ 100;
% 
% %Trouver les strikes pour les put 0.1 delta
% vol = audusd.vol3mB(1,5)./100;
% f = fPrice;
% r = rf;
% t = 1;
% k = 0:0.01:2;
% 
% %Équation 14 Reiswich
% delta = exp(-r .* t) .* (k ./ f) .* normcdf((log(f ./ k) - 0.5 .* vol.^2 .* t) ./ (vol .* sqrt(t)));
% 
% figure
% plot(k, delta,'b','linewidth', 3)
% set(gca, 'fontsize', 10)
% xlabel('Prix d''exercice')
% ylabel('Delta')
% titre = 'Delta d''une option d''achat "premium adjusted"';
% title(titre)

% %%%%%%%% figure 12-1, spline cubique non réaliste
% index = 500;
% strikes_1yb = usdcad.strikes_1yB;
% strikes_1yB_sc = [usdcad.strikes_1yB_G usdcad.strikes_1yB_D(:,2:end)];
% 
% vol_1yB = usdcad.vol1yB ./ 100;
% 
% smile_1yB_sc = zeros(length(vol_1yB), size(usdcad.strikes_1yB_G, 2) + size(usdcad.strikes_1yB_D, 2) - 1);
% 
% long = length(usdcad.smile_1yB_sc);
% 
% for i = 1:long
%     smile_1yB_sc(i,:) = spline(strikes_1yb(i,:), vol_1yB(i,:), strikes_1yB_sc(i,:));
% end
% 
% figure
% plot(strikes_1yb(index,:), vol_1yB(index,:),'* k' ,strikes_1yB_sc(index,40:80), smile_1yB_sc(index,40:80), 'r', 'LineWidth',3);
% titre = strcat('Graphique des smiles de volatilité',{' - '}, {'USD/CAD'}, {' - '}, char(usdcad.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique')

% %%%%%%%% figure 12-2, spline cubique non réaliste
% index = 800;
% strikes_1yb = usdjpy.strikes_1yB;
% strikes_1yB_sc = [usdjpy.strikes_1yB_G usdjpy.strikes_1yB_D(:,2:end)];
% 
% vol_1yB = usdjpy.vol1yB ./ 100;
% 
% smile_1yB_sc = zeros(length(vol_1yB), size(usdjpy.strikes_1yB_G, 2) + size(usdjpy.strikes_1yB_D, 2) - 1);
% 
% long = length(usdjpy.smile_1yB_sc);
% 
% for i = 1:long
%     smile_1yB_sc(i,:) = spline(strikes_1yb(i,:), vol_1yB(i,:), strikes_1yB_sc(i,:));
% end
% 
% figure
% plot(strikes_1yb(index,:), vol_1yB(index,:),'* k' ,strikes_1yB_sc(index,40:80), smile_1yB_sc(index,40:80), 'r', 'LineWidth',3);
% titre = strcat('Graphique des smiles de volatilité',{' - '}, {'USD/JPY'}, {' - '}, char(usdjpy.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique')


% % %%%%%%%%figure 13-1, graphique spline cubique
% index = 1000;
% vol = usdjpy.vol1yB(index,:) ./ 100;
% strike_brut = usdjpy.strikes_1yB(index,:);
% strike_int = [usdjpy.strikes_1yB_G(index,1:end-1) usdjpy.strikes_1yB_D(index,:)];
% smile_sc = usdjpy.smile_1yB_sc(index,:);
% 
% figure
% plot(strike_brut, vol,'* K' ,strike_int(40:80), smile_sc(40:80), 'r', 'LineWidth',3);
% titre = strcat('Graphique du smile de volatilité (spline cubique)',{' - '}, {'USD/JPY'}, {' - '}, char(usdjpy.spot(index)));
% set(gca, 'fontsize', 10)
% title(titre)
% xlabel('strikes')
% ylabel('volatilité')
% legend('Smile brute', 'Smile spline cubique')

% %%%%%%%%%%%%% figure 13-2, intégrale de Carr et Wu sur smile complet (pas beau).
% index = 1000;
% uns = ones(1,60);
% rf = cell2mat(usdjpy.taux(index,6)) ./ 100 * uns;
% rd = cell2mat(usdjpy.taux(index,8)) ./ 100 * uns;
% s0 = cell2mat(usdjpy.spot(index,2)) * uns;
% vol_put = usdjpy.smile_1yB_sc(index,1:60);
% vol_call = usdjpy.smile_1yB_sc(index,60:end);
% strikes_calls = usdjpy.strikes_1yB_D(index,:);
% strikes_puts = usdjpy.strikes_1yB_G(index,:);
% t = 1;
% calls = usdjpy.blsCall(s0, strikes_calls, rd, t, vol_call, rf);
% puts = usdjpy.blsPut(s0, strikes_puts, rd, t, vol_put, rf);
% 
% calls = calls ./ strikes_calls .^ 2;
% puts = puts ./ strikes_puts .^ 2;
% 
% plot(strikes_puts, puts, strikes_calls, calls, 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Intégrale de Carr et Wu sur smile complet (spline cubique)')
% xlabel('Strikes')
% ylabel('Prix des options Out of the money / K^2')

% %%%%%%%%%%%%figure 20-1
% rcarre = audusdrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 20-2
% pval = audusdpval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 20-3
% b0 = audusdb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 20-4
% b1 = audusdb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%figure 21-1
% rcarre = eurusdrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 21-2
% pval = eurusdpval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 21-3
% b0 = eurusdb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%%figure 21-4
% b1 = eurusdb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%figure 22-1
% rcarre = gbpusdrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 22-2
% pval = gbpusdpval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 22-3
% b0 = gbpusdb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 22-4
% b1 = gbpusdb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%figure 23-1
% rcarre = usdcadrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 23-2
% pval = usdcadpval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 23-3
% b0 = usdcadb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 23-4
% b1 = usdcadb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%figure 24-1
% rcarre = usdchfrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 24-2
% pval = usdchfpval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 24-3
% b0 = usdchfb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%figure 24-4
% b1 = usdchfb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%figure 25-1
% rcarre = usdjpyrcarre;
% xs = 1:12;
% plot(xs, rcarre(:,1), xs, rcarre(:,2), xs, rcarre(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('R carrés')
% xlabel('Mois')
% ylabel('R carrées')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 25-2
% pval = usdjpypval;
% xs = 1:12;
% plot(xs, pval(:,1), xs, pval(:,2), xs, pval(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('P-value')
% xlabel('Mois')
% ylabel('P-value')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%%figure 25-3
% b0 = usdjpyb0;
% xs = 1:12;
% plot(xs, b0(:,1), xs, b0(:,2), xs, b0(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient alpha')
% xlabel('Mois')
% ylabel('Alpha')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

% %%%%%%%%%%%figure 25-4
% b1 = usdjpyb1;
% xs = 1:12;
% plot(xs, b1(:,1), xs, b1(:,2), xs, b1(:,3), 'linewidth', 3)
% set(gca, 'fontsize', 10)
% title('Coefficient beta')
% xlabel('Mois')
% ylabel('Beta')
% legend('Spline cubique', 'Vanna-Volga', 'At the money')

