function [betas, rcarre, stderrHH, tstatsHH, stdErr, tstats, pval] = olsreg(X, Y, lag)
    
    %regression
    [T,n]   =   size(X);
    betas = (inv(X' * X)) * X' * Y;
    u = Y - X * betas;
    u = u * ones(1,n);
    err = X .* u; %estimating residuals for each beta

    %Calculer R2
    y_bar = mean(Y);
    rcarre = (betas' * X' * X * betas - T * (y_bar^2)) / (Y' * Y - T * (y_bar^2));

    %Calculate Hansen Hodrick Corrected Standard Errors
    V = (err' * err) / T; %regular weighting matrix
    if lag > -1
        for ind_i = (1:lag);
            S = err(1:T-ind_i,:)' * err(1+ind_i:T,:) / T;
            V = V + (1 - 0 * ind_i / (lag + 1)) * (S + S');
        end
    end

    D = inv((X' * X) / T);
    varb = 1 / T * D * V * D;
    seb = diag(varb);
    stderrHH = sign(seb) .* (abs(seb).^0.5);
    
    %TstatsHH
    tstatsHH = betas ./ stderrHH;
    %STDErr
    fit = fitlm(X(:,2),Y);
    stdErr = table2array(fit.Coefficients(:,2));
    
    %Tstats 
    tstats = betas ./ stdErr;
    
    %pval
    [~,~,~,~,stats] = regress(Y, X);
    pval = stats(3);
    
    
end