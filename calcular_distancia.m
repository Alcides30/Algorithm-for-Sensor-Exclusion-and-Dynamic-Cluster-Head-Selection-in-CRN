function [d_PU, d_CH, d_FC, d_BS] = calcular_distancia(m_T, c_max, xPU, yPU, xFC, coords, idx, CH)

    % Distância entre SU --> PU
    d_PU = zeros(1, m_T); 
    for j = 1:m_T
        xa = coords(1,j);
        ya = coords(2,j);
        xb = xPU;
        yb = yPU;
        d_PU(j) = distance(xa, xb, ya, yb);
    end
    % disp(['Distância PU - SU:', num2str(d_PU)]);
    
    % disp('----------------------------');

    % Distância entre SU e CH
    d_CH = zeros(1, m_T);
    for j = 1:m_T
        cluster_idx = idx(j); % Seleciona o CH correspondente
        
        if isnan(cluster_idx)  % Verifica se o índice é NaN
            d_CH(j) = NaN;  % Define a distância como NaN se o índice for NaN
        else
            xa = coords(1, j);
            ya = coords(2, j);
            xb = CH(1, cluster_idx);
            yb = CH(2, cluster_idx);
            d_CH(j) = distance(xa, xb, ya, yb);  % Calcula a distância normalmente
        end
    end
    % disp(['Distância SU - CH:', num2str(d_CH)]);
    
    % Distância entre CH - FC
    d_FC = zeros(1, c_max); 
    for j = 1:c_max
        if isnan(CH(:, j))  % Verifica se o índice é NaN
            continue
        else
            xa = CH(1,j);
            ya = CH(2,j);
            xb = xFC;
            yb = xFC;
            d_FC(j) = distance(xa, xb, ya, yb);
        end
    end
    % disp(['Distância CH - FC:', num2str(d_FC)]);

    % Distância entre SU - BS
    d_BS = zeros(1, m_T); 
    for j = 1:m_T
        xa = coords(1, j);
        ya = coords(2, j);
        xb = xFC;
        yb = xFC;
        d_BS(j) = distance(xa, xb, ya, yb);
    end
    % disp(['Distância SU - BS:', num2str(d_BS)]);

    % disp('---------------------------');
    
    function [d] = distance(xa, xb, ya, yb)
        d = sqrt((xa - xb).^2 + (ya - yb).^2);
    end

end