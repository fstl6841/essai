classdef donnees < handle
    %donnees Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        brutes
        indices
        noms
        dates
        spot
        forward
        taux
        taux_noms
        forward_noms
        current_dates

        %données utilisées pour trouver les strikes de façon numériques
        vol_num
        t_num
        f_num
        r_num
        delta_num
        
        %données brutes
        v3m
        v1y
        r3m10
        r1y10
        r3m25
        r1y25
        b3m10
        b1y10
        b3m25
        b1y25
        
        %volatilités brutes
        vol3mB
        vol3mA
        vol1yB
        vol1yA
        
        %strikes provenant des données de volatilité
        strikes_3mB
        strikes_3mA
        strikes_1yB
        strikes_1yA
        
        %strikes servant pour les inter-extrapolations de vanna volga
        strikes_3mB_D
        strikes_3mA_D
        strikes_1yB_D
        strikes_1yA_D 
        
        strikes_3mB_G
        strikes_3mA_G
        strikes_1yB_G
        strikes_1yA_G


        %smiles provenant de la méthode de vanna-volga 1
        smile_3mB_vv
        smile_3mA_vv
        smile_1yB_vv
        smile_1yA_vv
        
        %smile provenant d'un spline cubique
        smile_3mB_sc
        smile_3mA_sc
        smile_1yB_sc
        smile_1yA_sc
        
        %Realized volatility
        rv3mB
        rv3mA
        rv1yB
        rv1yA
        
        %swap rate provenant des volatilités obtenus par la méthode de
        %vanna-volga passant par le prix des calls
        sr3mB_vv
        sr3mA_vv
        sr1yB_vv
        sr1yA_vv
        
        %swap rate provenant des volatilités du spline cubique
        sr3mB_sc
        sr3mA_sc
        sr1yB_sc
        sr1yA_sc
        
        %VRP provenant du spline cubique
        vrp3mB_sc
        vrp3mA_sc
        vrp1yB_sc
        vrp1yA_sc
        
        %VRP provenant de vanna-volga
        vrp3mB_vv
        vrp3mA_vv
        vrp1yB_vv
        vrp1yA_vv
        
        %VRP provenant de la vol ATM
        vrp3mB_atm
        vrp3mA_atm
        vrp1yB_atm
        vrp1yA_atm
        
        %vanna-volga
        call_vv
        put_vv
    end
    
    methods
        function this = donnees(brutes)
            %Constructeur de la classe donnees
            %Arguments:
                %brutes est la série de données brutes qui a déjà été
                %importé dans matlab sous forme de cell array.
            this.brutes = brutes;
            this.trouver_indices;
            this.noms = cell(1,length(this.indices));
            this.trouver_noms;
            this.formater_dates;
        end
        
        function this = trouver_indices(this)
            %Fonction qui trouve les indices pour les changements de
            %tickers et les insère dans l'attribut "indices"
            index = cell2mat(this.brutes(:,4));
            index = ~isnan(index);
            indice = find(index);
            this.indices = indice - 1;
        end
        
        function this = trouver_noms(this)
            %Fonction qui trouve le nom des différents tickers et les
            %insère dans l'attribut "noms"
            for i = 1:(length(this.indices)/2)
                temp = cell2mat(this.brutes(this.indices(i*2-1),1));
                temp = strcat(temp, ' PX_BID');
                this.noms(i*2-1) = cellstr(temp);
                temp = cell2mat(this.brutes(this.indices(i*2),1));
                temp = strcat(temp, ' PX_ASK');
                this.noms(i*2) = cellstr(temp);
            end
        end
        
        function this = formater_dates(this)
            %Fonction qui crée un cell array avec les différentes dates
            %provenants des données brutes
            this.dates = {};
            for i = 1:length(this.indices)
                if i == 1
                    temp = this.brutes(2:this.indices(i),2:3);
                    disp(temp)
                    this.dates{1} = temp;
                else
                    temp = this.brutes(this.indices(i-1)+3:this.indices(i),2:3);
                    this.dates{end+1} = temp;
                end
            end
        end
        
        function exact = verifier_dates(this, index1, index2)
            %Fonction qui vérifie si 2 séries de dates sont identiques.
            %Arguments:
                %index1: Index de la 1ère série de dates
                %index2: Index de la 2ème série de dates
            %return:
                %retourne TRUE si les 2 séries sont identiques, FALSE
                %autrement
            dates1 = cell2mat(this.dates{index1}(:,1));
            dates2 = cell2mat(this.dates{index2}(:,1));
            if (length(dates1) ~= length(dates2))
                exact = 0;
                return;
            end
            conc = dates1 == dates2;
            conc = sum(conc,2);
            conc = conc == 10;
            conc = sum(conc);
            if conc == length(dates1)
                exact = 1;
                return;
            else
                exact = 0;
                return;
            end
        end
        
        function this = supprimer_trous(this)
            %Fonction qui nettoye les données de façon à supprimer
            %chaque dates dont une donnée est manquante dans une des
            %séries. Par exemple, s'il manque le bid butterfly 25d le 2
            %janvier 2004, cette date sera supprimée pour chacune des
            %autres séries.

            date = cell(1,20);
            frame = this.dates;
            
            for i = 1:length(this.dates)
                date{i} = datetime(this.dates{i}(:,1));
            end
            
            for i = 1:length(date)
                if i == 1
                    mini = length(date{i});
                elseif length(date{i}) < mini
                    mini = length(date{i});
                end
            end
                
            index = 1;
             
            while index < mini
                 
                datetimes = datetime.empty;
                for i = 1:length(date)
                    datetimes(i) = date{i}(index,1);
                end
                  
                if min(datetimes) == max(datetimes)
                    index = index + 1;
                else
                    for i = 1:length(date)
                        new_dates = date{i};
                        new_frame = frame{i};
                        if new_dates(index) < max(datetimes)
                            new_dates(index) = [];
                            new_frame(index,:) = [];
                            date{i} = new_dates;
                            frame{i} = new_frame;
                        end
                    end
                end
                for i = 1:length(date)
                    if i == 1
                        mini = length(date{i});
                    elseif length(date{i}) < mini
                        mini = length(date{i});
                    end
                end
                disp(index)
            end
            this.dates = frame;
        end        
        
        function [index1, index2] = couper_dates(this, index_dates, annee1, annee2)
           %Fonction qui coupe le vecteur dates selon les années demandées 
           %dans la fonction formater_données et va en même temps détourner les index pour formater 
           %le vecteur de données. Fonction seulement utilisée dans
           %la fonction "formater_donnees".
            %Arguments:
                %index_dates: position dans this.dates
                %annee1: année de début que l'on veut couper (string)
                %année2: année de fin que l'on veut couper (string)
            %return:
                %index1: index de début du vecteur de données
                %index2: index de fin du vecteur de données
            date = this.dates{index_dates};
            date = cell2mat(date(:,1));
            index1 = 0;
            index2 = 0;
            for i = 1:length(date)
                temp = date(i,:);
                if ~isempty(strfind(temp, annee1))
                    index1 = i;
                    break;
                end
            end

            in = 0;
            for i = 1:length(date)
                temp = date(i,:);
                if (~isempty(strfind(temp, annee2)) && in == 0)
                    in = 1;
                end
                if (isempty(strfind(temp, annee2)) && in ==1)
                    index2 = i - 1;
                    in = 0;
                    break;
                end
            end

            if in == 1
                index2 = length(date);
            end
            if index1 == 0
                index1 = 1;
            end
            if index2 == 0
                index2 = length(date);
            end
            this.dates{index_dates} = this.dates{index_dates}(index1:index2,1:2);
        end
        
        function this = formater_donnees(this, annee1, annee2)
            %Fonction qui crée une matrice bid-ask pour chacune des
            %différentes données. Si les dates du bid et du ask ne
            %concordent pas, un message sera envoyé dans la console et la
            %matrice correspondante ne sera pas créée. Avant de pouvoir
            %procéder, il faudra corriger les données pour les données
            %manquantes (supprimer_trous) puisqu'il est impossible de créer une matrice avec
            %des vecteurs de longueurs différentes.
            %Arguments:
                %annee1: année de début que l'on veut formater
                %année2: année de fin que l'on veut formater
            %return:
                %rien n'est retourné, les matrices correspondantes seront
                %enmagasinées dans les attributs de la classe.
            titres = {'V3M', 'V1Y', '10R3M', '10R1Y', '25R3M', '25R1Y', '10B3M', '10B1Y', '25B3M', '25B1Y'};
            indexes = zeros(length(this.indices) / 2);
            for i = 1:length(titres)
                for j = 1:length(this.noms)
                    if strfind(this.noms{j}, cell2mat(titres(i)))
                        indexes(i,j) = 1;
                    end
                end
            end

            series = cell(1,10);

            for i = 1:length(this.dates)
                this.couper_dates(i, annee1, annee2);
            end

            for i = 1:size(indexes,1)

                index = find(indexes(i,:));
                if ~isempty(index)
                    index1 = index(1);
                    index2 = index(2);
                else
                    continue
                end

                if this.verifier_dates(index1, index2)
                    series{i} = [cell2mat(this.dates{index1}(:,2)),cell2mat(this.dates{index2}(:,2))];
                else
                    disp('il y a discordance entre le vecteur des bid et le vecteur des ask')
                    disp(titres(i));
                end
            end

            this.v3m = series{1};
            this.v1y = series{2};
            this.r3m10 = series{3};
            this.r1y10 = series{4};
            this.r3m25 = series{5};
            this.r1y25 = series{6};
            this.b3m10 = series{7};
            this.b1y10 = series{8};
            this.b3m25 = series{9};
            this.b1y25 = series{10};

        end
        
        function this = formater_vol(this)
            %Fonction qui formate les volatilités implicites d'après
            %les formules obtenues dans Castagna(2006). Nous obtenons des
            %smiles pour chacune des dates dans le format suivant:
            %10c, 25c, ATM, 25p, 10p
             
            vol10pB = this.v3m(:,1) + this.b3m10(:,1) - 0.5 * this.r3m10(:,1);
            vol25pB = this.v3m(:,1) + this.b3m25(:,1) - 0.5 * this.r3m25(:,1);
            volatmB = this.v3m(:,1);
            vol25cB = this.v3m(:,1) + this.b3m25(:,1) + 0.5 * this.r3m25(:,1);
            vol10cB = this.v3m(:,1) + this.b3m10(:,1) + 0.5 * this.r3m10(:,1);
            this.vol3mB = [vol10pB, vol25pB, volatmB, vol25cB, vol10cB];
            
            vol10pA = this.v3m(:,2) + this.b3m10(:,2) - 0.5 * this.r3m10(:,2);
            vol25pA = this.v3m(:,2) + this.b3m25(:,2) - 0.5 * this.r3m25(:,2);
            volatmA = this.v3m(:,2);
            vol25cA = this.v3m(:,2) + this.b3m25(:,2) + 0.5 * this.r3m25(:,2);
            vol10cA = this.v3m(:,2) + this.b3m10(:,2) + 0.5 * this.r3m10(:,2);
            this.vol3mA = [vol10pA, vol25pA, volatmA, vol25cA, vol10cA];
            
            vol10pB = this.v1y(:,1) + this.b1y10(:,1) - 0.5 * this.r1y10(:,1);
            vol25pB = this.v1y(:,1) + this.b1y25(:,1) - 0.5 * this.r1y25(:,1);
            volatmB = this.v1y(:,1);
            vol25cB = this.v1y(:,1) + this.b1y25(:,1) + 0.5 * this.r1y25(:,1);
            vol10cB = this.v1y(:,1) + this.b1y10(:,1) + 0.5 * this.r1y10(:,1);
            this.vol1yB = [vol10pB, vol25pB, volatmB, vol25cB, vol10cB];
            
            vol10pA = this.v1y(:,2) + this.b1y10(:,2) - 0.5 * this.r1y10(:,2);
            vol25pA = this.v1y(:,2) + this.b1y25(:,2) - 0.5 * this.r1y25(:,2);
            volatmA = this.v1y(:,2);
            vol25cA = this.v1y(:,2) + this.b1y25(:,2) + 0.5 * this.r1y25(:,2);
            vol10cA = this.v1y(:,2) + this.b1y10(:,2) + 0.5 * this.r1y10(:,2);
            this.vol1yA = [vol10pA, vol25pA, volatmA, vol25cA, vol10cA];
        end
        
        function this = formater_autres(this, taux_mat)
            %Fonction qui formate la matrice des taux et autres donnees pour que les
            %dates correspondent aux dates du premier élément des données
            %brutes.

            this.taux_noms = {'Dates', 'taux Rf bid 3m', 'taux Rf ask 3m', 'taux Rd bid 3m', 'taux Rd ask 3m'...
                               'taux Rf bid 1y', 'taux Rf ask 1y', 'taux Rd bid 1y', 'taux Rd ask 1y'};

            a = this.dates{1};
            b = taux_mat;
            date_a = datetime(a(:,1));
            date_b = datetime(b(:,1));
            lengtha = size(a,1);
            lengthb = size(b,1);
            ia = 1;
            ib = 1;
%             
            while ia < (lengtha+1) && ib < (lengthb+1)
                if date_a(ia) > date_b(ib)
                    b(ib,:) = [];
                    date_b(ib) = [];
                    lengthb = size(b,1);
                elseif date_a(ia) < date_b(ib)
                    a(ia,:) = [];
                    date_a(ib) = [];
                    lengtha = size(a,1);
                else
                    ia = ia + 1;
                    ib = ib + 1;
                end
            end
            
            this.taux = b(:,1:9);
            this.spot = [b(:,1) b(:,10:11)];
            this.calculer_forward;
            this.current_dates = datetime(this.spot(:,1));
        end
        
        function this = calculer_forward(this)
            %Fonction qui calcule les forward 3m et 1y et les insère
            %dans la matrice forward.
            
            this.forward_noms = {'Dates', 'forward 3m bid', 'forward 3m ask', 'forward 1y bid', 'forward 1y ask'};
            this.forward = this.taux(:,1);
            
            rf3m = cell2mat(this.taux(:,2:3)) ./ 100;
            rd3m = cell2mat(this.taux(:,4:5)) ./ 100;
            rf1y = cell2mat(this.taux(:,6:7)) ./ 100;
            rd1y = cell2mat(this.taux(:,8:9)) ./ 100;
            
            spot1 = cell2mat(this.spot(:,2:3));
            
            forward3m = spot1 .* exp(0.25 * (rd3m-rf3m));
            forward1y = spot1 .* exp(rd1y - rf1y);
            this.forward = [this.forward num2cell(forward3m)];
            this.forward(:,4:5) = num2cell(forward1y);
        end
        
        function this = formater_strike_unadjusted(this)
            %Fonction qui formate les matrices de strike selon la
            %méthode de Reiswich et Wystup pour les paires de devises dont
            %les delta sont unadjusted (équation 18)
            
            %arrangement des variables de taux
            rf3mb = (cell2mat(this.taux(:,2)) ./ 100) * [1 1 1 1 1];
            rf3ma = (cell2mat(this.taux(:,3)) ./ 100) * [1 1 1 1 1];
            rf1yb = (cell2mat(this.taux(:,6)) ./ 100) * [1 1 1 1 1];
            rf1ya = (cell2mat(this.taux(:,7)) ./ 100) * [1 1 1 1 1];
            
            %arrangement des autres variables
            f3mb = cell2mat(this.forward(:,2)) * [1 1 1 1 1];
            f3ma = cell2mat(this.forward(:,3)) * [1 1 1 1 1];
            f1yb = cell2mat(this.forward(:,4)) * [1 1 1 1 1];
            f1ya = cell2mat(this.forward(:,5)) * [1 1 1 1 1];
            long = length(rf3mb);
            delta_call = ones(long,1) * [0.9 0.75 0.5 0.25 0.1];
            delta_put = ones(long,1) * [0.1 0.25 0.5 0.75 0.9];
            
            %calcul de la matrice des strike pour les BID d'échéance 3 mois
            %selon la méthode de Reiswich (équation 18)
            t = ones(long,1) * [0.25 0.25 0.25 0.25 0.25];
            vol = this.vol3mB ./ 100;
            k3mB_call = f3mb .* exp(-norminv(exp(rf3mb .* t) .* delta_call) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k3mB_put = f3mb .* exp(norminv(-exp(rf3mb .* t) .* -delta_put) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k3mB_atm = f3mb .* exp(0.5 .* vol .^2 .* t);
            this.strikes_3mB = [k3mB_put(:,1:2) k3mB_atm(:,3) k3mB_call(:,4:5)];
            
            %calcul de la matrice des strike pour les ASK d'échéance 3 mois
            %selon la méthode de Reiswich (équation 18)
            t = ones(long,1) * [0.25 0.25 0.25 0.25 0.25];
            vol = this.vol3mA ./ 100;
            k3mA_call = f3ma .* exp(-norminv(exp(rf3ma .* t) .* delta_call) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k3mA_put = f3ma .* exp(norminv(-exp(rf3ma .* t) .* -delta_put) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k3mA_atm = f3ma .* exp(0.5 .* vol .^2 .* t);
            this.strikes_3mA = [k3mA_put(:,1:2) k3mA_atm(:,3) k3mA_call(:,4:5)];
            
            %calcul de la matrice des strike pour les BID d'échéance 1 an
            %selon la méthode de Reiswich (équation 18)
            t = ones(long,1) * [1 1 1 1 1];
            vol = this.vol1yB ./ 100;
            k1yB_call = f1yb .* exp(-norminv(exp(rf1yb .* t) .* delta_call) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k1yB_put = f1yb .* exp(norminv(-exp(rf1yb .* t) .* -delta_put) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k1yB_atm = f1yb .* exp(0.5 .* vol .^2 .* t);
            this.strikes_1yB = [k1yB_put(:,1:2) k1yB_atm(:,3) k1yB_call(:,4:5)];
            
            %calcul de la matrice des strike pour les ASK d'échéance 1 an
            %selon la méthode de Reiswich (équation 18)
            t = ones(long,1) * [1 1 1 1 1];
            vol = this.vol1yA ./ 100;
            k1yA_call = f1ya .* exp(-norminv(exp(rf1ya .* t) .* delta_call) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k1yA_put = f1ya .* exp(norminv(-exp(rf1ya .* t) .* -delta_put) .* vol .* sqrt(t) + (0.5 .* vol.^2 .* t));
            k1yA_atm = f1ya .* exp(0.5 .* vol .^2 .* t);
            this.strikes_1yA = [k1yA_put(:,1:2) k1yA_atm(:,3) k1yA_call(:,4:5)];            
        end
        
        function this = formater_strike_adjusted(this)
            %Fonction qui formate les matrices de strike selon la
            %méthode de Reiswich et Wystup pour les paires de devises dont
            %les delta sont adjusted

%%%%%%%%%%%%%%%%    3mb  %%%%%%%%%%%%%%%%%%%%%%
            fPrice = cell2mat(this.forward(:,2));
            this.strikes_3mB = zeros(length(fPrice), 5);
            rf  = cell2mat(this.taux(:,4)) ./ 100;
            
            %Trouver les strikes pour les put 0.1 delta
            vol = this.vol3mB(:,1)./100;
            this.delta_num = -0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_3mB(i, 1) = z;
            end
            
            %Trouver les strikes pour les put 0.25 delta
            vol = this.vol3mB(:,2)./100;
            this.delta_num = -0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_3mB(i, 2) = z;
            end
            
            %Trouver les strikes ATM
            f3mb = cell2mat(this.forward(:,2));
            vol = this.vol3mB(:,3) ./ 100;
            t = 0.25;
            this.strikes_3mB(:,3) =  f3mb .* exp(-0.5 .* vol .^2 .* t);
            
            %trouver les strikes pour les call 0.25 delta
            vol = this.vol3mB(:,4)./100;
            this.delta_num = 0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_3mB(i, 4) = z;
            end

            %trouver les strikes pour les call 0.1 delta
            vol = this.vol3mB(:,5)./100;
            this.delta_num = 0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_3mB(i, 5) = z;
            end
            
%%%%%%%%%%%%%%%%    3mA  %%%%%%%%%%%%%%%%%%%%%%
            fPrice = cell2mat(this.spot(:,3));
            this.strikes_3mA = zeros(length(fPrice), 5);
            rf  = cell2mat(this.taux(:,5)) ./ 100;
            
            %Trouver les strikes pour les put 0.1 delta
            vol = this.vol3mA(:,1)./100;
            this.delta_num = -0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_3mA(i, 1) = z;
            end
            
            %Trouver les strikes pour les put 0.25 delta
            vol = this.vol3mA(:,2)./100;
            this.delta_num = -0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_3mA(i, 2) = z;
            end
            
            %Trouver les strikes ATM
            f3ma = cell2mat(this.forward(:,3));
            vol = this.vol3mA(:,3) ./ 100;
            t = 0.25;
            this.strikes_3mA(:,3) =  f3ma .* exp(-0.5 .* vol .^2 .* t);
            
            %trouver les strikes pour les call 0.25 delta
            vol = this.vol3mA(:,4)./100;
            this.delta_num = 0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_3mA(i, 4) = z;
            end

            %trouver les strikes pour les call 0.1 delta
            vol = this.vol3mA(:,5)./100;
            this.delta_num = 0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_3mA(i, 5) = z;
            end

%%%%%%%%%%%%%%%%    1yB  %%%%%%%%%%%%%%%%%%%%%%
            fPrice = cell2mat(this.spot(:,2));
            this.strikes_1yB = zeros(length(fPrice), 5);
            rf  = cell2mat(this.taux(:,8)) ./ 100;
            
            %Trouver les strikes pour les put 0.1 delta
            vol = this.vol1yB(:,1)./100;
            this.delta_num = -0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_1yB(i, 1) = z;
            end
            
            %Trouver les strikes pour les put 0.25 delta
            vol = this.vol1yB(:,2)./100;
            this.delta_num = -0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_1yB(i, 2) = z;
            end
            
            %Trouver les strikes ATM
            f1yb = cell2mat(this.forward(:,2));
            vol = this.vol1yB(:,3) ./ 100;
            t = 0.25;
            this.strikes_1yB(:,3) =  f1yb .* exp(-0.5 .* vol .^2 .* t);
            
            %trouver les strikes pour les call 0.25 delta
            vol = this.vol1yB(:,4)./100;
            this.delta_num = 0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_1yB(i, 4) = z;
            end

            %trouver les strikes pour les call 0.1 delta
            vol = this.vol1yB(:,5)./100;
            this.delta_num = 0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_1yB(i, 5) = z;
            end

            %%%%%%%%%%%%%%%%    1yA  %%%%%%%%%%%%%%%%%%%%%%
            fPrice = cell2mat(this.spot(:,3));
            this.strikes_1yA = zeros(length(fPrice), 5);
            rf  = cell2mat(this.taux(:,9)) ./ 100;
            
            %Trouver les strikes pour les put 0.1 delta
            vol = this.vol1yA(:,1)./100;
            this.delta_num = -0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_1yA(i, 1) = z;
            end
            
            %Trouver les strikes pour les put 0.25 delta
            vol = this.vol1yA(:,2)./100;
            this.delta_num = -0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_put;
                k0 = [0 this.f_num];
                z = fzero(fun, k0);
                this.strikes_1yA(i, 2) = z;
            end
            
            %Trouver les strikes ATM
            f1ya = cell2mat(this.forward(:,3));
            vol = this.vol1yA(:,3) ./ 100;
            t = 0.25;
            this.strikes_1yA(:,3) =  f1ya .* exp(-0.5 .* vol .^2 .* t);
            
            %trouver les strikes pour les call 0.25 delta
            vol = this.vol1yA(:,4)./100;
            this.delta_num = 0.25;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_1yA(i, 4) = z;
            end

            %trouver les strikes pour les call 0.1 delta
            vol = this.vol1yA(:,5)./100;
            this.delta_num = 0.1;
            
            for i = 1:length(fPrice)
                this.vol_num = vol(i);
                this.f_num = fPrice(i);
                this.t_num = 0.25;
                this.r_num = rf(i);
                
                fun = @this.minimum_call;
                k0 = [this.f_num (this.f_num * 2)];
                z = fzero(fun, k0);
                this.strikes_1yA(i, 5) = z;
            end

        end
        
        function racine = minimum_call(this, k)
            %Fonction pour trouver les 0 utilisée dans
            %"formater_strike_adjusted"
            vol = this.vol_num;
            f = this.f_num;
            r = this.r_num;
            t = this.t_num;
            delta = this.delta_num;
            
            %Équation 14 Reiswich
            racine = exp(-r .* t) .* (k ./ f) .* normcdf((log(f ./ k) - 0.5 .* vol.^2 .* t) ./ (vol .* sqrt(t))) - delta;
        end
        
        function racine = minimum_put(this, k)
            %Fonction pour trouver les 0 utilisée dans
            %"formater_strike_adjusted"
            vol = this.vol_num;
            f = this.f_num;
            r = this.r_num;
            t = this.t_num;
            delta = this.delta_num;
            
            %Équation 14 Reiswich
            racine = -exp(-r .* t) .* (k ./ f) .* normcdf(-((log(f ./ k) - 0.5 .* vol.^2 .* t) ./ (vol .* sqrt(t)))) - delta;
        end
        
        function call = blsCall(this, s0, k, rd, t, vol, rf)
            %Fonction qui calcule le prix d'options call selon le modèle de
            %Black and Scholes
            d1 = (log(s0 ./ k) + (rd - rf + (vol.^2 ./ 2)) .* t) ./ (vol .* sqrt(t));
            d2 = (log(s0 ./ k) + (rd - rf - (vol.^2 ./ 2)) .* t) ./ (vol .* sqrt(t));

            call = (s0 .* exp(-rf .* t) .* normcdf(d1)) - (k .* exp(-rd .* t) .* normcdf(d2));
        end
        
        function put = blsPut(this, s0, k, rd, t, vol, rf)
            %Fonction qui calcule le prix d'options put selon le modèle de
            %Black and Scholes   
            d1 = (log(s0 ./ k) + (rd - rf + (vol.^2 ./ 2)) .* t) ./ (vol .* sqrt(t));
            d2 = (log(s0 ./ k) + (rd - rf - (vol.^2 ./ 2)) .* t) ./ (vol .* sqrt(t));
            
            put = (k .* exp(-rd .* t) .* normcdf(-d2)) - (s0 .* exp(-rf .* t) .* normcdf(-d1));
        end
        
        function vega = calculer_vega(this, s0, k, rd, t, vol, rf)
            %Fonction qui calcule le vega d'une option
            
            d1 = (log(s0 ./ k) + (rd - rf + (vol.^2 ./ 2)) .* t) ./ (vol .* sqrt(t));
            vega = s0 .* sqrt(t) .* normpdf(d1) .* exp(-rf .* t);
        end
        
        function [impvol_put, impvol_call] = calculer_impvol(this, s0, strikes_put, strikes_call, rd, rf, put, call, t)
            %Fonction qui calcule la volatilité implicite d'options
            
            impvol_put = ones(length(s0),size(strikes_put,2)) * 0.2;
            impvol_call = ones(length(s0),size(strikes_call,2)) * 0.2;
            
            for i = 1:500
    
                disp(i)

                %put
                d1_put = (log(s0 ./ strikes_put) + (rd - rf + (impvol_put.^2 ./ 2)) .* t) ./ (impvol_put .* sqrt(t));
                d2_put = (log(s0 ./ strikes_put) + (rd - rf - (impvol_put.^2 ./ 2)) .* t) ./ (impvol_put .* sqrt(t));

                test_put = (strikes_put .* exp(-rd .* t) .* normcdf(-d2_put)) - (s0 .* exp(-rf .* t) .* normcdf(-d1_put));
                vega_put = s0 .* sqrt(t) .* normpdf(d1_put) .* exp(-rf .* t);

                %call
                d1_call = (log(s0 ./ strikes_call) + (rd - rf + (impvol_call.^2 ./ 2)) .* t) ./ (impvol_call .* sqrt(t));
                d2_call = (log(s0 ./ strikes_call) + (rd - rf - (impvol_call.^2 ./ 2)) .* t) ./ (impvol_call .* sqrt(t));

                test_call = (s0 .* exp(-rf .* t) .* normcdf(d1_call)) - (strikes_call .* exp(-rd .* t) .* normcdf(d2_call));
                vega_call = s0 .* sqrt(t) .* normpdf(d1_call) .* exp(-rf .* t);

                impvol_put = impvol_put - (test_put - put) ./ vega_put;
                impvol_call = impvol_call - (test_call - call) ./ vega_call;
            end
        end

        function this = find_strikes(this)
            %Fonction qui trouve les strikes pour l'interpolation de
            %vanna-volga
            
            %trouver strikes pour 3mB droite
            strikes_debut = cell2mat(this.forward(:,2));
            strikes_fin = cell2mat(this.forward(:,2)) + 3 .* (this.vol3mB(:,3) ./ 100) .* cell2mat(this.forward(:,2));
            temp = [strikes_debut this.strikes_3mB(:,5) strikes_fin];
            this.strikes_3mB_D = zeros(length(temp),60);

            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 11);
               section_2 = linspace(temp(i,2), temp(i,3) ,50);
               this.strikes_3mB_D(i,:) = [section_1 section_2(:,2:end)];
            end
            
            %trouver strikes pour 3mB droite
            strikes_debut = cell2mat(this.forward(:,3));
            strikes_fin = cell2mat(this.forward(:,3)) + 3 .* (this.vol3mA(:,3) ./ 100) .* cell2mat(this.forward(:,3));
            temp = [strikes_debut this.strikes_3mA(:,5) strikes_fin];
            this.strikes_3mA_D = zeros(length(temp),60);

            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 11);
               section_2 = linspace(temp(i,2), temp(i,3) ,50);
               this.strikes_3mA_D(i,:) = [section_1 section_2(:,2:end)];
            end
            
            %trouver strikes pour 1yB droite
            strikes_debut = cell2mat(this.forward(:,4));
            strikes_fin = cell2mat(this.forward(:,4)) + 3 .* (this.vol1yB(:,3) ./ 100) .* cell2mat(this.forward(:,4));
            temp = [strikes_debut this.strikes_1yB(:,5) strikes_fin];
            this.strikes_1yB_D = zeros(length(temp),60);

            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 11);
               section_2 = linspace(temp(i,2), temp(i,3) ,50);
               this.strikes_1yB_D(i,:) = [section_1 section_2(:,2:end)];
            end
            
            %trouver strikes pour 1yA droite
            strikes_debut = cell2mat(this.forward(:,5));
            strikes_fin = cell2mat(this.forward(:,5)) + 3 .* (this.vol1yA(:,3) ./ 100) .* cell2mat(this.forward(:,5));
            temp = [strikes_debut this.strikes_1yA(:,5) strikes_fin];
            this.strikes_1yA_D = zeros(length(temp),60);

            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 11);
               section_2 = linspace(temp(i,2), temp(i,3) ,50);
               this.strikes_1yA_D(i,:) = [section_1 section_2(:,2:end)];
            end
            
            %trouver strikes pour 3mB gauche
            strikes_fin = cell2mat(this.forward(:,2));
            strikes_debut = cell2mat(this.forward(:,2)) - 3 .* (this.vol3mB(:,3) ./ 100) .* cell2mat(this.forward(:,2));
            temp = [strikes_debut this.strikes_3mB(:,1) strikes_fin];
            this.strikes_3mB_G = zeros(length(temp), 60);
            
            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 50);
               section_2 = linspace(temp(i,2), temp(i,3) ,11);
               this.strikes_3mB_G(i,:) = [section_1 section_2(:,2:end)];
            end
            this.strikes_3mB_G(this.strikes_3mB_G < 0) = 0;
            
            %trouver strikes pour 3mA gauche
            strikes_fin = cell2mat(this.forward(:,3));
            strikes_debut = cell2mat(this.forward(:,3)) - 3 .* (this.vol3mA(:,3) ./ 100) .* cell2mat(this.forward(:,3));
            temp = [strikes_debut this.strikes_3mA(:,1) strikes_fin];
            this.strikes_3mA_G = zeros(length(temp), 60);
            
            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 50);
               section_2 = linspace(temp(i,2), temp(i,3) ,11);
               this.strikes_3mA_G(i,:) = [section_1 section_2(:,2:end)];
            end
            this.strikes_3mA_G(this.strikes_3mA_G < 0) = 0;
            
            %trouver strikes pour 1yB gauche
            strikes_fin = cell2mat(this.forward(:,4));
            strikes_debut = cell2mat(this.forward(:,4)) - 3 .* (this.vol1yB(:,3) ./ 100) .* cell2mat(this.forward(:,4));
            temp = [strikes_debut this.strikes_1yB(:,1) strikes_fin];
            this.strikes_1yB_G = zeros(length(temp), 60);
            
            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 50);
               section_2 = linspace(temp(i,2), temp(i,3) ,11);
               this.strikes_1yB_G(i,:) = [section_1 section_2(:,2:end)];
            end
            this.strikes_1yB_G(this.strikes_1yB_G < 0) = 0;
            
            %trouver strikes pour 1yA gauche
            strikes_fin = cell2mat(this.forward(:,5));
            strikes_debut = cell2mat(this.forward(:,5)) - 3 .* (this.vol1yB(:,3) ./ 100) .* cell2mat(this.forward(:,5));
            temp = [strikes_debut this.strikes_1yA(:,1) strikes_fin];
            this.strikes_1yA_G = zeros(length(temp), 60);
            
            for i = 1:length(temp)
               section_1 = linspace(temp(i,1), temp(i,2), 50);
               section_2 = linspace(temp(i,2), temp(i,3) ,11);
               this.strikes_1yA_G(i,:) = [section_1 section_2(:,2:end)];
            end
            this.strikes_1yA_G(this.strikes_1yA_G < 0) = 0;
        end
        
        function this = vanna_volga_sommaire(this)
            %Foonction qui appelle à répétition la fonction "vanna_volga"
            %pour calculer l'extrapolation du prix des call de chacune des
            %séries
            
            this.vanna_volga1(1, 1);
            this.vanna_volga1(1, 0);
            this.vanna_volga1(0, 1);
            this.vanna_volga1(0, 0);
        end
        
        function this = vanna_volga1(this, annee, bid)

            %Utilisation de la méthode de vanna-volga pour extrapoler ma
            %série de call out of the money. Cette fonction est une
            %sous-fonction qui sera seulement utilisée dans
            %"vanna_volga_sommaire"

            %arrangement des variables
            if annee == 1 && bid ==1
                
                t = 1;
                k1 = this.strikes_1yB(:,2);
                k2 = this.strikes_1yB(:,3);
                k3 = this.strikes_1yB(:,4);

                sigma1 = this.vol1yB(:,2) ./ 100;
                sigma2 = this.vol1yB(:,3) ./ 100;
                sigma3 = this.vol1yB(:,4) ./ 100;

                kc = this.strikes_1yB_D;
                kp = this.strikes_1yB_G;

                uns = ones(1,size(kp,2));
                rf = (cell2mat(this.taux(:,6)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,8)) ./ 100) * uns;
                ts = ones(length(rd), size(rd,2)) .* t;
                s0 = cell2mat(this.spot(:,2)) * uns; 
                
            elseif annee == 1 && bid == 0
                
                t = 1;
                k1 = this.strikes_1yA(:,2);
                k2 = this.strikes_1yA(:,3);
                k3 = this.strikes_1yA(:,4);

                sigma1 = this.vol1yA(:,2) ./ 100;
                sigma2 = this.vol1yA(:,3) ./ 100;
                sigma3 = this.vol1yA(:,4) ./ 100;

                kc = this.strikes_1yA_D;
                kp = this.strikes_1yA_G;

                uns = ones(1,size(kp,2));
                rf = (cell2mat(this.taux(:,7)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,9)) ./ 100) * uns;
                ts = ones(length(rd), size(rd,2)) .* t;
                s0 = cell2mat(this.spot(:,3)) * uns; 
                
            elseif annee == 0 && bid == 1
                
                t = 0.25;
                k1 = this.strikes_3mB(:,2);
                k2 = this.strikes_3mB(:,3);
                k3 = this.strikes_3mB(:,4);

                sigma1 = this.vol3mB(:,2) ./ 100;
                sigma2 = this.vol3mB(:,3) ./ 100;
                sigma3 = this.vol3mB(:,4) ./ 100; 

                kc = this.strikes_3mB_D;
                kp = this.strikes_3mB_G;
                
                uns = ones(1,size(kp,2));
                rf = (cell2mat(this.taux(:,2)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,4)) ./ 100) * uns;
                ts = ones(length(rd), size(rd,2)) .* t;
                s0 = cell2mat(this.spot(:,2)) * uns; 
                
            elseif annee == 0 && bid == 0
                
                t = 0.25;
                k1 = this.strikes_3mA(:,2);
                k2 = this.strikes_3mA(:,3);
                k3 = this.strikes_3mA(:,4);

                sigma1 = this.vol3mA(:,2) ./ 100;
                sigma2 = this.vol3mA(:,3) ./ 100;
                sigma3 = this.vol3mA(:,4) ./ 100; 

                kc = this.strikes_3mA_D;
                kp = this.strikes_3mA_G;
                
                uns = ones(1,size(kp,2));
                rf = (cell2mat(this.taux(:,3)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,5)) ./ 100) * uns;
                ts = ones(length(rd), size(rd,2)) .* t;
                s0 = cell2mat(this.spot(:,3)) * uns; 
                
            end

            k1 = k1 * uns;
            k2 = k2 * uns;
            k3 = k3 * uns;
            sigma1 = sigma1 * uns;
            sigma2 = sigma2 * uns;
            sigma3 = sigma3 * uns;

            vega1 = this.calculer_vega(s0, k1, rd, ts, sigma2, rf);
            vega3 = this.calculer_vega(s0, k3, rd, ts, sigma2, rf);
            vegakp = this.calculer_vega(s0, kp, rd, ts, sigma2, rf);
            vegakc = this.calculer_vega(s0, kc, rd, ts, sigma2, rf);
            
            x1p = (vegakp .* log(k2./kp) .* log(k3./kp)) ./ (vega1 .* log(k2./k1) .* log(k3./k1));
            x3p = (vegakp .* log(kp./k1) .* log(kp./k2)) ./ (vega3 .* log(k3./k1) .* log(k3./k2));
            x1c = (vegakc .* log(k2./kc) .* log(k3./kc)) ./ (vega1 .* log(k2./k1) .* log(k3./k1));
            x3c = (vegakc .* log(kc./k1) .* log(kc./k2)) ./ (vega3 .* log(k3./k1) .* log(k3./k2));

            if annee == 1 && bid == 0

                call_1yA_vv = this.blsCall(s0,kc,rd,ts,sigma2,rf)...
                    + x1c .* (this.blsCall(s0,k1,rd,ts,sigma1,rf) - this.blsCall(s0,k1,rd,ts,sigma2,rf))...
                    + x3c .* (this.blsCall(s0,k3,rd,ts,sigma3,rf) - this.blsCall(s0,k3,rd,ts,sigma2,rf));
                put_1yA_vv = this.blsPut(s0,kp,rd,ts,sigma2,rf)...
                    + x1p .* (this.blsPut(s0,k1,rd,ts,sigma1,rf) - this.blsPut(s0,k1,rd,ts,sigma2,rf))...
                    + x3p .* (this.blsPut(s0,k3,rd,ts,sigma3,rf) - this.blsPut(s0,k3,rd,ts,sigma2,rf));

                %calcul du smile 1yA
                disp('smile 1yA')
                
                s0 = cell2mat(this.spot(:,3)) * uns;
                rf = (cell2mat(this.taux(:,7)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,9)) ./ 100) * uns;
                t = ones(length(s0),size(rd,2)) * t;
                
                strikes_put = this.strikes_1yA_G;
                put_1yA_vv(put_1yA_vv < 0) = 0;
                
                strikes_call = this.strikes_1yA_D;
                call_1yA_vv(call_1yA_vv < 0) = 0;
                
                [smile_vvP, smile_vvC] = this.calculer_impvol(s0, strikes_put, strikes_call, rd, rf, put_1yA_vv, call_1yA_vv, t);
                this.smile_1yA_vv = [smile_vvP smile_vvC(:,2:end)];

                
            elseif annee == 1 && bid == 1
                
                call_1yB_vv = this.blsCall(s0,kc,rd,ts,sigma2,rf)...
                    + x1c .* (this.blsCall(s0,k1,rd,ts,sigma1,rf) - this.blsCall(s0,k1,rd,ts,sigma2,rf))...
                    + x3c .* (this.blsCall(s0,k3,rd,ts,sigma3,rf) - this.blsCall(s0,k3,rd,ts,sigma2,rf));
                
                put_1yB_vv = this.blsPut(s0,kp,rd,ts,sigma2,rf)...
                    + x1p .* (this.blsPut(s0,k1,rd,ts,sigma1,rf) - this.blsPut(s0,k1,rd,ts,sigma2,rf))...
                    + x3p .* (this.blsPut(s0,k3,rd,ts,sigma3,rf) - this.blsPut(s0,k3,rd,ts,sigma2,rf));

                %calcul du smile 1yB
                disp('smile 1yB')
                
                s0 = cell2mat(this.spot(:,2)) * uns;
                rf = (cell2mat(this.taux(:,6)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,8)) ./ 100) * uns;
                t = ones(length(s0),size(rd,2)) * t;
                
                strikes_put = this.strikes_1yB_G;
                put_1yB_vv(put_1yB_vv < 0) = 0;
                
                strikes_call = this.strikes_1yB_D;
                call_1yB_vv(call_1yB_vv < 0) = 0;
                
                [smile_vvP, smile_vvC] = this.calculer_impvol(s0, strikes_put, strikes_call, rd, rf, put_1yB_vv, call_1yB_vv, t);
                this.smile_1yB_vv = [smile_vvP smile_vvC(:,2:end)];
            
                
            elseif annee == 0 && bid == 0

                call_3mA_vv = this.blsCall(s0,kc,rd,ts,sigma2,rf)...
                    + x1c .* (this.blsCall(s0,k1,rd,ts,sigma1,rf) - this.blsCall(s0,k1,rd,ts,sigma2,rf))...
                    + x3c .* (this.blsCall(s0,k3,rd,ts,sigma3,rf) - this.blsCall(s0,k3,rd,ts,sigma2,rf));
                
                put_3mA_vv = this.blsPut(s0,kp,rd,ts,sigma2,rf)...
                    + x1p .* (this.blsPut(s0,k1,rd,ts,sigma1,rf) - this.blsPut(s0,k1,rd,ts,sigma2,rf))...
                    + x3p .* (this.blsPut(s0,k3,rd,ts,sigma3,rf) - this.blsPut(s0,k3,rd,ts,sigma2,rf));
                
                %calcul du smile 3mA
                disp('smile 3mA')
                
                s0 = cell2mat(this.spot(:,3)) * uns;
                rf = (cell2mat(this.taux(:,3)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,5)) ./ 100) * uns;
                t = ones(length(s0),size(rd,2)) * t;
                
                strikes_put = this.strikes_3mA_G;
                put_3mA_vv(put_3mA_vv < 0) = 0;
                
                strikes_call = this.strikes_3mA_D;
                call_3mA_vv(call_3mA_vv < 0) = 0;

                [smile_vvP, smile_vvC] = this.calculer_impvol(s0, strikes_put, strikes_call, rd, rf, put_3mA_vv, call_3mA_vv, t);
                this.smile_3mA_vv = [smile_vvP smile_vvC(:,2:end)];

            elseif annee == 0 && bid == 1

                call_3mB_vv = this.blsCall(s0,kc,rd,ts,sigma2,rf)...
                    + x1c .* (this.blsCall(s0,k1,rd,ts,sigma1,rf) - this.blsCall(s0,k1,rd,ts,sigma2,rf))...
                    + x3c .* (this.blsCall(s0,k3,rd,ts,sigma3,rf) - this.blsCall(s0,k3,rd,ts,sigma2,rf));
                
                put_3mB_vv = this.blsPut(s0,kp,rd,ts,sigma2,rf)...
                    + x1p .* (this.blsPut(s0,k1,rd,ts,sigma1,rf) - this.blsPut(s0,k1,rd,ts,sigma2,rf))...
                    + x3p .* (this.blsPut(s0,k3,rd,ts,sigma3,rf) - this.blsPut(s0,k3,rd,ts,sigma2,rf));
                
                %calcul du smile 3mB
                disp('smile 3mB')
                
                s0 = cell2mat(this.spot(:,2)) * uns;
                rf = (cell2mat(this.taux(:,2)) ./ 100) * uns;
                rd = (cell2mat(this.taux(:,4)) ./ 100) * uns;
                t = ones(length(s0),size(rd,2)) * t;
                
                strikes_put = this.strikes_3mB_G;
                put_3mB_vv(put_3mB_vv < 0) = 0;

                strikes_call = this.strikes_3mB_D;
                call_3mB_vv(call_3mB_vv < 0) = 0;
                
                [smile_vvP, smile_vvC] = this.calculer_impvol(s0, strikes_put, strikes_call, rd, rf, put_3mB_vv, call_3mB_vv, t);
                this.smile_3mB_vv = [smile_vvP smile_vvC(:,2:end)];

                
            end

        end
        
        function this = spline_cubique(this)
           %Fonction qui calcule les smiles en extrapolant les 5 données brutes à l'aide d'un spline cubique

           strikes_3mb = this.strikes_3mB;
           strikes_3ma = this.strikes_3mA;
           strikes_1yb = this.strikes_1yB;
           strikes_1ya = this.strikes_1yA;

           strikes_3mB_sc = [this.strikes_3mB_G(:,50:end) this.strikes_3mB_D(:,2:11)];
           strikes_3mA_sc = [this.strikes_3mA_G(:,50:end) this.strikes_3mA_D(:,2:11)];
           strikes_1yB_sc = [this.strikes_1yB_G(:,50:end) this.strikes_1yB_D(:,2:11)];
           strikes_1yA_sc = [this.strikes_1yA_G(:,50:end) this.strikes_1yA_D(:,2:11)];
           
           vol_3mB = this.vol3mB ./ 100;
           vol_3mA = this.vol3mA ./ 100;
           vol_1yB = this.vol1yB ./ 100;
           vol_1yA = this.vol1yA ./ 100;

           this.smile_3mB_sc = zeros(length(vol_3mB), size(this.strikes_3mB_G, 2) + size(this.strikes_3mB_D, 2) - 1);
           this.smile_3mA_sc = zeros(length(vol_3mA), size(this.strikes_3mA_G, 2) + size(this.strikes_3mB_D, 2) - 1);
           this.smile_1yB_sc = zeros(length(vol_1yB), size(this.strikes_1yB_G, 2) + size(this.strikes_3mB_D, 2) - 1);
           this.smile_1yA_sc = zeros(length(vol_1yA), size(this.strikes_1yA_G, 2) + size(this.strikes_3mB_D, 2) - 1);

           long = length(this.smile_3mB_sc);

           for i = 1:long
               this.smile_3mB_sc(i,50:70) = spline(strikes_3mb(i,:), vol_3mB(i,:), strikes_3mB_sc(i,:));
               this.smile_3mA_sc(i,50:70) = spline(strikes_3ma(i,:), vol_3mA(i,:), strikes_3mA_sc(i,:));
               this.smile_1yB_sc(i,50:70) = spline(strikes_1yb(i,:), vol_1yB(i,:), strikes_1yB_sc(i,:));
               this.smile_1yA_sc(i,50:70) = spline(strikes_1ya(i,:), vol_1yA(i,:), strikes_1yA_sc(i,:));
               
               this.smile_3mB_sc(i,1:49) = this.smile_3mB_sc(i,50);
               this.smile_3mA_sc(i,1:49) = this.smile_3mA_sc(i,50);
               this.smile_1yB_sc(i,1:49) = this.smile_1yB_sc(i,50);
               this.smile_1yA_sc(i,1:49) = this.smile_1yA_sc(i,50);
           
               this.smile_3mB_sc(i,71:end) = this.smile_3mB_sc(i,70);
               this.smile_3mA_sc(i,71:end) = this.smile_3mA_sc(i,70);
               this.smile_1yB_sc(i,71:end) = this.smile_1yB_sc(i,70);
               this.smile_1yA_sc(i,71:end) = this.smile_1yA_sc(i,70);
           end
           
        end
        
        function this = calculer_sr(this)
           %Fonction qui calcule tous les swap rate
           this.calculer_sr_vv;
           this.calculer_sr_sc;
        end
        
        function this = calculer_sr_vv(this)
            %Fonction qui calcule les variance swap rate de chacune des
            %séries selon la formule (2) de Ammann
            
            
%%%%%%%%%%%%    3mB    %%%%%%%%%%%

            %Calcul de l'intégrale des options put nécéssaires dans la formule de Carr et
            %Wu
            t = 0.25;
            larg = size(this.strikes_3mB_G,2);
            s0 = cell2mat(this.spot(:,2)) * ones(1, larg);
            rd = cell2mat(this.taux(:,4)) ./ 100;
            rf = cell2mat(this.taux(:,2)) ./ 100;
            t_opt = ones(length(s0), larg) .* t;
            rd = rd * ones(1, larg);
            rf = rf * ones(1, larg);

            vol_put = this.smile_3mB_vv(:,1:larg);
            vol_call = this.smile_3mB_vv(:,larg:end);

            strikes_put = this.strikes_3mB_G;
            strikes_call = this.strikes_3mB_D;
            
            puts = this.blsPut(s0, strikes_put, rd, t_opt, vol_put, rf);
            puts(puts < 0) = 0;
            puts = puts ./ (this.strikes_3mB_G .^ 2);
            
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                       (this.strikes_3mB_G(:,2:end) - this.strikes_3mB_G(:,1:(end-1))) ./ 2, 2);
                   
            %Calcul de l'intégrale des options call nécéssaires dans la formule de Carr et
            %Wu
            calls = this.blsCall(s0, strikes_call, rd, t_opt, vol_call, rf);
            calls(calls < 0) = 0;
            calls = calls ./ (this.strikes_3mB_D .^ 2);
            calls(isnan(calls)) = 0;
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_3mB_D(:,2:end) - this.strikes_3mB_D(:,1:(end-1))) ./ 2, 2);
            
            %Racine carrée de la formule 2 de Ammann

            this.sr3mB_vv = sqrt((2 / t) .* exp(rd(:,1) .* t) .* (int_call + int_put));

%%%%%%%%%%%%    3mA    %%%%%%%%%%%

            %Calcul de l'intégrale des options put nécéssaires dans la formule de Carr et
            %Wu
            
            t = 0.25;
            larg = size(this.strikes_3mA_G,2);
            s0 = cell2mat(this.spot(:,3)) * ones(1,larg);
            rd = cell2mat(this.taux(:,5)) ./ 100;
            rf = cell2mat(this.taux(:,3)) ./ 100;
            t_opt = ones(length(s0),larg) .* t;
            rd = rd * ones(1,larg);
            rf = rf * ones(1,larg);
            
            vol_put = this.smile_3mA_vv(:,1:larg);
            vol_call = this.smile_3mA_vv(:,larg:end);              

            strikes_put = this.strikes_3mA_G;
            strikes_call = this.strikes_3mA_D;
            
            puts = this.blsPut(s0, strikes_put, rd, t_opt, vol_put, rf);
            puts(puts < 0) = 0;
            puts = puts ./ (this.strikes_3mA_G .^ 2);
            
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                       (this.strikes_3mA_G(:,2:end) - this.strikes_3mA_G(:,1:(end-1))) ./ 2, 2);
                   
            %Calcul de l'intégrale des options call nécéssaires dans la formule de Carr et
            %Wu
            calls = this.blsCall(s0, strikes_call, rd, t_opt, vol_call, rf);
            calls(calls < 0) = 0;
            calls = calls ./ (this.strikes_3mA_D .^ 2);
            calls(isnan(calls)) = 0;
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_3mA_D(:,2:end) - this.strikes_3mA_D(:,1:(end-1))) ./ 2, 2);
            
            %Racine carrée de la formule 2 de Ammann

            this.sr3mA_vv = sqrt((2 ./ t) .* exp(rd(:,1) .* t) .* (int_call + int_put));
            
%%%%%%%%%%%%    1yB    %%%%%%%%%%%

            %Calcul de l'intégrale des options put nécéssaires dans la formule de Carr et
            %Wu
            t = 1;
            larg = size(this.strikes_1yB_G,2);
            s0 = cell2mat(this.spot(:,2)) * ones(1,larg);
            rd = cell2mat(this.taux(:,8)) ./ 100;
            rf = cell2mat(this.taux(:,6)) ./ 100;
            t_opt = ones(length(s0),larg) .* t;
            rd = rd * ones(1,larg);
            rf = rf * ones(1,larg);
            
            vol_put = this.smile_1yB_vv(:,1:larg);
            vol_call = this.smile_1yB_vv(:,larg:end);

            strikes_put = this.strikes_1yB_G;
            strikes_call = this.strikes_1yB_D;
            
            puts = this.blsPut(s0, strikes_put, rd, t_opt, vol_put, rf);
            puts(puts < 0) = 0;
            puts = puts ./ (this.strikes_1yB_G .^ 2);
            
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                       (this.strikes_1yB_G(:,2:end) - this.strikes_1yB_G(:,1:(end-1))) ./ 2, 2);
                   
            %Calcul de l'intégrale des options call nécéssaires dans la formule de Carr et
            %Wu
            calls = this.blsCall(s0, strikes_call, rd, t_opt, vol_call, rf);
            calls(calls < 0) = 0;
            calls = calls ./ (this.strikes_1yB_D .^ 2);
            calls(isnan(calls)) = 0;
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_1yB_D(:,2:end) - this.strikes_1yB_D(:,1:(end-1))) ./ 2, 2);
            %Racine carrée de la formule 2 de Ammann
            
            this.sr1yB_vv = sqrt((2 ./ t) .* exp(rd(:,1) .* t) .* (int_call + int_put));

%%%%%%%%%%%%    1yA    %%%%%%%%%%%

            %Calcul de l'intégrale des options put nécéssaires dans la formule de Carr et
            %Wu
            t = 1;
            larg = size(this.strikes_1yA_G,2);
            s0 = cell2mat(this.spot(:,3)) * ones(1,larg);
            rd = cell2mat(this.taux(:,9)) ./ 100;
            rf = cell2mat(this.taux(:,7)) ./ 100;
            t_opt = ones(length(s0),larg) .* t;
            rd = rd * ones(1,larg);
            rf = rf * ones(1,larg);

            vol_put = this.smile_1yA_vv(:,1:larg);
            vol_call = this.smile_1yA_vv(:,larg:end);

            strikes_put = this.strikes_1yA_G;
            strikes_call = this.strikes_1yA_D;
            
            puts = this.blsPut(s0, strikes_put, rd, t_opt, vol_put, rf);
            puts(puts < 0) = 0;
            puts = puts ./ (this.strikes_1yA_G .^ 2);
            
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                       (this.strikes_1yA_G(:,2:end) - this.strikes_1yA_G(:,1:(end-1))) ./ 2, 2);
                   
            %Calcul de l'intégrale des options call nécéssaires dans la formule de Carr et
            %Wu
            calls = this.blsCall(s0, strikes_call, rd, t_opt, vol_call, rf);
            calls(calls < 0) = 0;
            calls = calls ./ (this.strikes_1yA_D .^ 2);
            calls(isnan(calls)) = 0;
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_1yA_D(:,2:end) - this.strikes_1yA_D(:,1:(end-1))) ./ 2, 2);
            
            %Racine carrée de la formule 2 de Ammann

            this.sr1yA_vv = sqrt((2 ./ t) .* exp(rd(:,1) .* t) .* (int_call + int_put));
        end

        function this = calculer_sr_sc(this)
            %Fonction qui calcule les taux de swap de variance avec les
            %volatilités obtenues à partir d'un spline cubique
            
%%%%%%%%%%%%    3mB    %%%%%%%%%%%

            %Déclaration des variables nécéssaires
            t = 0.25;
            larg = size(this.strikes_3mB_G,2);
            s0_bls = cell2mat(this.spot(:,2)) * ones(1,larg);
            rd = cell2mat(this.taux(:,4)) ./ 100;
            rf = cell2mat(this.taux(:,2)) ./ 100;
            t_bls = ones(length(s0_bls),larg) .* t;
            rd_bls = rd * ones(1,larg);
            rf_bls = rf * ones(1,larg);
            vol_put = this.smile_3mB_sc(:,1:larg);
            vol_call = this.smile_3mB_sc(:,larg:end);
            strikes_put = this.strikes_3mB_G;
            strikes_call = this.strikes_3mB_D;
            
            %Calcul du prix des puts et de l'intégrale nécéssaire dans la
            %formule de Carr et Wu
            puts = this.blsPut(s0_bls, strikes_put, rd_bls, t_bls, vol_put, rf_bls);
            puts(puts<0) = 0;
            puts = puts ./ (this.strikes_3mB_G .^ 2);
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                      (this.strikes_3mB_G(:,2:end) - this.strikes_3mB_G(:,1:(end-1))) ./ 2, 2);

            %Calcul du prix des calls et d el'intégrale nécéssaire dans la
            %formule de Carr et Wu
            
            calls = this.blsCall(s0_bls, strikes_call, rd_bls, t_bls, vol_call, rf_bls);
            calls(calls<0) = 0;
            calls = calls ./ (this.strikes_3mB_D .^ 2);
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_3mB_D(:,2:end) - this.strikes_3mB_D(:,1:(end-1))) ./ 2, 2);


            %Racine carrée de la formule 2 de Ammann
            this.sr3mB_sc = sqrt((2 / t) .* exp(rd .* t) .* (int_call + int_put));
            
%%%%%%%%%%%%    3mA    %%%%%%%%%%%

            %Déclaration des variables nécéssaires
            t = 0.25;
            larg = size(this.strikes_3mA_G,2);
            s0_bls = cell2mat(this.spot(:,3)) * ones(1,larg);
            rd = cell2mat(this.taux(:,5)) ./ 100;
            rf = cell2mat(this.taux(:,3)) ./ 100;
            t_bls = ones(length(s0_bls),larg) .* t;
            rd_bls = rd * ones(1,larg);
            rf_bls = rf * ones(1,larg);
            vol_put = this.smile_3mA_sc(:,1:larg);
            vol_call = this.smile_3mA_sc(:,larg:end);
            strikes_put = this.strikes_3mA_G;
            strikes_call = this.strikes_3mA_D;
            
            %Calcul du prix des puts et de l'intégrale nécéssaire dans la
            %formule de Carr et Wu
            puts = this.blsPut(s0_bls, strikes_put, rd_bls, t_bls, vol_put, rf_bls);
            puts(puts<0) = 0;
            puts = puts ./ (this.strikes_3mA_G .^ 2);
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                      (this.strikes_3mA_G(:,2:end) - this.strikes_3mA_G(:,1:(end-1))) ./ 2, 2);

            %Calcul du prix des calls et d el'intégrale nécéssaire dans la
            %formule de Carr et Wu
            
            calls = this.blsCall(s0_bls, strikes_call, rd_bls, t_bls, vol_call, rf_bls);
            calls(calls<0) = 0;
            calls = calls ./ (this.strikes_3mA_D .^ 2);
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_3mA_D(:,2:end) - this.strikes_3mA_D(:,1:(end-1))) ./ 2, 2);
            
            %Racine carrée de la formule 2 de Ammann
            this.sr3mA_sc = sqrt((2 / t) .* exp(rd .* t) .* (int_call + int_put));
            
%%%%%%%%%%%%    1yB    %%%%%%%%%%%

            %Déclaration des variables nécéssaires
            t = 1;
            larg = size(this.strikes_1yB_G,2);
            s0_bls = cell2mat(this.spot(:,2)) * ones(1,larg);
            rd = cell2mat(this.taux(:,8)) ./ 100;
            rf = cell2mat(this.taux(:,6)) ./ 100;
            t_bls = ones(length(s0_bls),larg) .* t;
            rd_bls = rd * ones(1,larg);
            rf_bls = rf * ones(1,larg);
            vol_put = this.smile_1yB_sc(:,1:larg);
            vol_call = this.smile_1yB_sc(:,larg:end);
            strikes_put = this.strikes_1yB_G;
            strikes_call = this.strikes_1yB_D;
            
            %Calcul du prix des puts et de l'intégrale nécéssaire dans la
            %formule de Carr et Wu
            puts = this.blsPut(s0_bls, strikes_put, rd_bls, t_bls, vol_put, rf_bls);
            puts(puts<0) = 0;
            puts = puts ./ (this.strikes_1yB_G .^ 2);
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                      (this.strikes_1yB_G(:,2:end) - this.strikes_1yB_G(:,1:(end-1))) ./ 2, 2);

            %Calcul du prix des calls et d el'intégrale nécéssaire dans la
            %formule de Carr et Wu
            
            calls = this.blsCall(s0_bls, strikes_call, rd_bls, t_bls, vol_call, rf_bls);
            calls(calls<0) = 0;
            calls = calls ./ (this.strikes_1yB_D .^ 2);
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_1yB_D(:,2:end) - this.strikes_1yB_D(:,1:(end-1))) ./ 2, 2);
            
            %Racine carrée de la formule 2 de Ammann
            this.sr1yB_sc = sqrt((2 / t) .* exp(rd .* t) .* (int_call + int_put));
            
%%%%%%%%%%%%    1yA    %%%%%%%%%%%

            %Déclaration des variables nécéssaires
            t = 1;
            larg = size(this.strikes_1yA_G,2);
            s0_bls = cell2mat(this.spot(:,3)) * ones(1,larg);
            rd = cell2mat(this.taux(:,9)) ./ 100;
            rf = cell2mat(this.taux(:,7)) ./ 100;
            t_bls = ones(length(s0_bls),larg) .* t;
            rd_bls = rd * ones(1,larg);
            rf_bls = rf * ones(1,larg);
            vol_put = this.smile_1yA_sc(:,1:larg);
            vol_call = this.smile_1yA_sc(:,larg:end);
            strikes_put = this.strikes_1yA_G;
            strikes_call = this.strikes_1yA_D;
            
            %Calcul du prix des puts et de l'intégrale nécéssaire dans la
            %formule de Carr et Wu
            puts = this.blsPut(s0_bls, strikes_put, rd_bls, t_bls, vol_put, rf_bls);
            puts(puts<0) = 0;
            puts = puts ./ (this.strikes_1yA_G .^ 2);
            puts(isnan(puts)) = 0;
            int_put = sum((puts(:,1:(end-1)) + puts(:,2:end)) .* ...
                      (this.strikes_1yA_G(:,2:end) - this.strikes_1yA_G(:,1:(end-1))) ./ 2, 2);

            %Calcul du prix des calls et d el'intégrale nécéssaire dans la
            %formule de Carr et Wu
            
            calls = this.blsCall(s0_bls, strikes_call, rd_bls, t_bls, vol_call, rf_bls);
            calls(calls<0) = 0;
            calls = calls ./ (this.strikes_1yA_D .^ 2);
            
            int_call = sum((calls(:,1:(end-1)) + calls(:,2:end)) .* ...
                       (this.strikes_1yA_D(:,2:end) - this.strikes_1yA_D(:,1:(end-1))) ./ 2, 2);

            %Racine carrée de la formule 2 de Ammann
            this.sr1yA_sc = sqrt((2 / t) .* exp(rd .* t) .* (int_call + int_put));
            
        end
        
        function this = calculer_vrp(this)
            %Cette fonction calcule la VRP pour chacun des smiles.
            
            %Calcul de la volatilité réalisée journalière annualisée sur une période
            %de 3 mois
            spot_bid = cell2mat(this.spot(:,2));
            spot_ask = cell2mat(this.spot(:,3));
            
            rend_spot_bid = (spot_bid(2:end) ./ spot_bid(1:end-1)) - 1;
            rend_spot_ask = (spot_ask(2:end) ./ spot_ask(1:end-1)) - 1;
            
            std_spot_bid = zeros(length(rend_spot_bid) - 63,1);
            std_spot_ask = zeros(length(rend_spot_ask) - 63,1);
            
            for i = 63:length(rend_spot_bid)
                std_spot_bid(i-62) = std(rend_spot_bid(i-62:i));
                std_spot_ask(i-62) = std(rend_spot_ask(i-62:i));
            end

            this.rv3mB = std_spot_bid .* sqrt(252);
            this.rv3mA = std_spot_ask .* sqrt(252);
            
            this.vrp3mB_sc = this.rv3mB - this.sr3mB_sc(64:end);
            this.vrp3mA_sc = this.rv3mA - this.sr3mA_sc(64:end);
            
            this.vrp3mB_vv = this.rv3mB - this.sr3mB_vv(64:end);
            this.vrp3mA_vv = this.rv3mA - this.sr3mA_vv(64:end);
            
            this.vrp3mB_atm = this.rv3mB - (this.vol3mB(64:end,3) ./ 100);
            this.vrp3mA_atm = this.rv3mA - (this.vol3mA(64:end,3) ./ 100);
            
            %Calcul de la volatilité réalisée journalière annualisée sur une période
            %de 1 an
            spot_bid = cell2mat(this.spot(:,2));
            spot_ask = cell2mat(this.spot(:,3));
            
            rend_spot_bid = (spot_bid(2:end) ./ spot_bid(1:end-1)) - 1;
            rend_spot_ask = (spot_ask(2:end) ./ spot_ask(1:end-1)) - 1;
            
            std_spot_bid = zeros(length(rend_spot_bid) - 252,1);
            std_spot_ask = zeros(length(rend_spot_ask) - 252,1);
            
            for i = 252:length(rend_spot_bid)
                std_spot_bid(i-251) = std(rend_spot_bid(i-251:i));
                std_spot_ask(i-251) = std(rend_spot_ask(i-251:i));
            end

            this.rv1yB = std_spot_bid .* sqrt(252);
            this.rv1yA = std_spot_ask .* sqrt(252);

            this.vrp1yB_sc = this.rv1yB - this.sr1yB_sc(253:end);
            this.vrp1yA_sc = this.rv1yA - this.sr1yA_sc(253:end);

            this.vrp1yB_vv = this.rv1yB - this.sr1yB_vv(253:end);
            this.vrp1yA_vv = this.rv1yA - this.sr1yA_vv(253:end);
            
            this.vrp1yB_atm = this.rv1yB - (this.vol1yB(253:end,3) ./ 100);
            this.vrp1yA_atm = this.rv1yA - (this.vol1yA(253:end,3) ./ 100);
        end
        
        function this = graph_smile(this, series, index)
            %Cette fonction montre sur un graphique le smile dérivé par la
            %méthode de vanna-volga, le smile dérivé par le spline cubique
            %et les données brutes utilisées pour dériver les smiles.

            if index > length(this.current_dates)
                index = length(this.current_dates);
            end
            
            if strcmp(series, '3mb')
                larg = size(this.strikes_3mB_G, 2);
                vol = this.vol3mB(index,:) ./ 100;
                strike_brut = this.strikes_3mB(index,:);
                strike_int = [this.strikes_3mB_G(index,1:(larg-1)) this.strikes_3mB_D(index,:)];
                smile_sc = this.smile_3mB_sc(index,:);
                smile_vv = this.smile_3mB_vv(index,:);
            elseif strcmp(series, '3ma')
                larg = size(this.strikes_3mA_G, 2);
                vol = this.vol3mA(index,:) ./ 100;
                strike_brut = this.strikes_3mA(index,:);
                strike_int = [this.strikes_3mA_G(index,1:(larg-1)) this.strikes_3mA_D(index,:)];
                smile_sc = this.smile_3mA_sc(index,:);
                smile_vv = this.smile_3mA_vv(index,:);
            elseif strcmp(series, '1yb')
                larg = size(this.strikes_1yB_G, 2);
                vol = this.vol1yB(index,:) ./ 100;
                strike_brut = this.strikes_1yB(index,:);
                strike_int = [this.strikes_1yB_G(index,1:(larg-1)) this.strikes_1yB_D(index,:)];
                smile_sc = this.smile_1yB_sc(index,:);
                smile_vv = this.smile_1yB_vv(index,:);
            elseif strcmp(series, '1ya')
                larg = size(this.strikes_1yA_G, 2);
                vol = this.vol1yA(index,:) ./ 100;
                strike_brut = this.strikes_1yA(index,:);
                strike_int = [this.strikes_1yA_G(index,1:(larg-1)) this.strikes_1yA_D(index,:)];
                smile_sc = this.smile_1yA_sc(index,:);
                smile_vv = this.smile_1yA_vv(index,:);
            end
            
            figure
            plot(strike_brut, vol,'* k' ,strike_int(35:85), smile_sc(35:85), 'r' ,strike_int(35:85), smile_vv(35:85),'k', 'LineWidth',3);
            titre = strcat('Graphique des smiles de volatilité', {' '}, char(this.spot(index)));
            set(gca, 'fontsize', 10)
            title(titre)
            xlabel('strikes')
            ylabel('volatilité')
            legend('Smile brute', 'Smile spline cubique', 'Smile Vanna-Volga')

        end
        
        function this = graph_swap(this, series, index1, index2)
            %Fonction qui va mettre sur un graphique le taux de swap
            %obtenu avec la méthode de vanna-volga, le taux de swap obtenu
            %avec le spline cubique et la volatilité brute at-the-money.
            
            if index2 > length(this.current_dates)
                index2 = length(this.current_dates);
            end
            date = this.current_dates(index1:index2);
            
            if strcmp(series, '3mb')
                sr_sc = this.sr3mB_sc(index1:index2) .* 100;
                sr_vv = this.sr3mB_vv(index1:index2) .* 100;
                vol_atm = this.vol3mB(index1:index2,3);
            elseif strcmp(series, '3ma')
                sr_sc = this.sr3mA_sc(index1:index2) .* 100;
                sr_vv = this.sr3mA_vv(index1:index2) .* 100;
                vol_atm = this.vol3mA(index1:index2,3);
            elseif strcmp(series, '1yb')
                sr_sc = this.sr1yB_sc(index1:index2) .* 100;
                sr_vv = this.sr1yB_vv(index1:index2) .* 100;
                vol_atm = this.vol1yB(index1:index2,3);
            elseif strcmp(series, '1ya')
                sr_sc = this.sr1yA_sc(index1:index2) .* 100;
                sr_vv = this.sr1yA_vv(index1:index2) .* 100;
                vol_atm = this.vol1yA(index1:index2,3);
            end
            
            
            figure
            plot(date, sr_sc,'k', date, sr_vv, 'r', date, vol_atm, 'b', 'linewidth', 1)
            set(gca, 'fontsize', 10)
            titre = strcat('Graphique des taux de swap de volatilité');
            title(titre)
            xlabel('Dates')
            ylabel('Swap rate')
            legend('Swap spline cubique', 'Swap Vanna-Volga (3 pts)', 'Vol at-the-money')
        end
        
        function this = graph_vrp(this, series, index1, index2)
            %Fonction qui va mettre sur un graphique le vrp vanna-volga, le vrp obtenu
            %avec le spline cubique.
            
            if strcmp(series, '3mb') || strcmp(series, '3ma')
                if index2 > length(this.vrp3mB_vv)
                    index2 = length(this.vrp3mB_vv);
                end
                debut = length(this.current_dates) - length(this.vrp3mB_vv);
                date = this.current_dates(debut+1:end);
                date = date(index1:index2);
            elseif strcmp(series, '1yb') || strcmp(series, '1ya')
                if index2 > length(this.vrp1yB_vv)
                    index2 = length(this.vrp1yB_vv);
                end
                debut = length(this.current_dates) - length(this.vrp1yB_vv);
                date = this.current_dates(debut+1:end);
                date = date(index1:index2);
            end
            
            if strcmp(series, '3mb')
                vrp_sc = this.vrp3mB_sc(index1:index2) .* 100;
                vrp_vv = this.vrp3mB_vv(index1:index2) .* 100;
                vrp_atm = this.vrp3mB_atm(index1:index2) .* 100;
            elseif strcmp(series, '3ma')
                vrp_sc = this.vrp3mA_sc(index1:index2) .* 100;
                vrp_vv = this.vrp3mA_vv(index1:index2) .* 100;
                vrp_atm = this.vrp3mA_atm(index1:index2) .* 100;
            elseif strcmp(series, '1yb')
                vrp_sc = this.vrp1yB_sc(index1:index2) .* 100;
                vrp_vv = this.vrp1yB_vv(index1:index2) .* 100;
                vrp_atm = this.vrp1yB_atm(index1:index2) .* 100;
            elseif strcmp(series, '1ya')
                vrp_sc = this.vrp1yA_sc(index1:index2) .* 100;
                vrp_vv = this.vrp1yA_vv(index1:index2) .* 100;
                vrp_atm = this.vrp1yA_atm(index1:index2) .* 100;
            end
            
            
            figure
            plot(date, vrp_sc,'k', date, vrp_vv, 'b', date, vrp_atm, 'r', 'linewidth', 1)
            set(gca, 'fontsize', 16)
            titre = strcat('VRP');
            title(titre)
            xlabel('Dates')
            ylabel('VRP')
            legend('VRP spline cubique', 'VRP Vanna-Volga', 'VRP At the money')
        end
    end
end

