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
    
    % Distância entre SU --> CH
    d_CH = zeros(1, m_T);
    for j = 1:m_T
        cluster_idx = idx(j); % Seleciona o CH correspondente
        xa = coords(1, j);
        ya = coords(2, j);
        xb = CH(1, cluster_idx);
        yb = CH(2, cluster_idx);
        d_CH(j) = distance(xa, xb, ya, yb);
    end
    % disp(['Distância SU - CH:', num2str(d_CH)]);
    
    % Distância entre CH - FC
    d_FC = zeros(1, c_max); 
    for j = 1:c_max
        xa = CH(1,j);
        ya = CH(2,j);
        xb = xFC;
        yb = xFC;
        d_FC(j) = distance(xa, xb, ya, yb);
    end
    % disp(['Distância CH - FC:', num2str(d_FC)]);

    % Distância entre SU - FC
    d_BS = zeros(1, m_T); 
    for j = 1:m_T
        xa = coords(1, j);
        ya = coords(2, j);
        xb = xFC;
        yb = xFC;
        d_BS(j) = distance(xa, xb, ya, yb);
    end
    % disp(['Distância SU - FC:', num2str(d_BS)]);
    
    function [d] = distance(xa, xb, ya, yb)
        d = sqrt((xa - xb).^2 + (ya - yb).^2);
    end

end