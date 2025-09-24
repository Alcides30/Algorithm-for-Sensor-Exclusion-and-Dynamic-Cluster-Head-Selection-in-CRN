function [P_rxSU] = calcular_prx(d_PU, P_txPU, alpha, m_T, alpha1, coords, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5)

    % Coordenadas dos sensores
    x = coords(1, :); % Coordenadas X dos sensores
    y = coords(2, :); % Coordenadas Y dos sensores
    
    % Distância dos SUs até o centro das áreas com obstáculo
    dist_1 = sqrt((x - x_center_1).^2 + (y - y_center_1).^2);
    dist_2 = sqrt((x - x_center_2).^2 + (y - y_center_2).^2);
    dist_3 = sqrt((x - x_center_3).^2 + (y - y_center_3).^2);
    dist_4 = sqrt((x - x_center_4).^2 + (y - y_center_4).^2);
    dist_5 = sqrt((x - x_center_5).^2 + (y - y_center_5).^2);
    
    P_rxSU = zeros(1, m_T); % Inicializa o vetor de potência de recepção com zeros
    % Cálculo da potência de recepção em áreas com e sem obstáculo
    for j = 1:m_T
        % if dist_1(j) <= raio_1 || dist_2(j) <= raio_2 || dist_3(j) <= raio_3
        if dist_1(j) <= raio_1 || dist_2(j) <= raio_2 || dist_3(j) <= raio_3 || dist_4(j) <= raio_4 || dist_5(j) <= raio_5
            % Dentro de qualquer área de obstáculo
            P_rxSU(j) = P_txPU * d_PU(j)^(-alpha1);    % Aplica o expoente de perda de caminho betha para os sensores que estão na área sombreada
        else
            % Fora das áreas de obstáculo
            P_rxSU(j) = P_txPU * d_PU(j)^(-alpha);    % Aplica o expoente de perda de caminho alpha para os sensores que estão fora das áreas sombreada
        end
    end

    % disp(['Potência dos SUs:', num2str(P_rxSU)]);
    % disp('-------------------------------------');
end