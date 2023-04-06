function [] = tensor_analyze(A)
    addpath("Tensor-tensor-product-toolbox-master/tproduct toolbox 1.0/");
    
    % Get image dimensions
    [rows,cols,channels] = size(A);
    
    % using the defualt transformation 

    [U,S,V] = tsvd(A,'econ');
    
    % cumsum algorithm, sum in 3rd dim.
    cum_e = cumsum(diag(sum(S,3)))/sum(diag(sum(S,3)));
    
    % find the 90 percent cut off
    cut_90 = find(cum_e>.9, 1 );
    
    % find the 99.99 percent cut off ( for croppping ) 
    cut_0 = find(cum_e>0.9999,1);
    
    % plotting the cumulative energy 
    figure();
    subplot(1, 2, 1);
    plot(cum_e(1:cut_0+10)), grid on, hold on;
    title("Cumulative energy in singular values")
    ylabel("Cumulative Energy");
    xlabel("r");
    
    % draw cut off lines 
    %xline(cut_90,'Color','red', 'DisplayName','90% cutoff');
    xline(cut_90, '-.','90% Cutoff','DisplayName', 'Cumulative energy cutoff','Color','red');
    %xline(cut_0,'Color','blue');
    
    % plotting the singular value 
    subplot(1,2,2);
    cropped_S = diag(sum(S,3));
    semilogy(cropped_S(1:cut_0+4),'-ok','LineWidth',1.5), grid on, hold on;
    title("Singular values per rank")
    ylabel("Singular Value");
    xlabel("r");
    
    % draw cut off lines 
    xline(cut_90, '-.','90% Cutoff','DisplayName', 'Cumulative energy cutoff','Color','red');
    %xline(cut_0,'Color','blue');
end