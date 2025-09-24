function [CH, d_CH, d_FC] = selecao_CH(CH, c_max, idx, x, y, d_CH, d_FC, xFC, energia_SU, sensor_off)

    % Loop para cada cluster
    for c = 1:c_max
        % Encontra os índices dos sensores pertencentes a este cluster
        SUs_do_cluster = find(idx == c);
    
        % Filtra os sensores ativos (onde sensor_off == 0) dentro do cluster
        SUs_ativos = SUs_do_cluster(sensor_off(SUs_do_cluster) == 0);
    
        % Verifica se há SUs ativos no cluster antes de calcular o centro de massa
        if isempty(SUs_ativos)
            continue; % Passa para o próximo cluster se não houver SUs ativos
        end
    
        % Coordenadas X e Y dos SUs ativos neste cluster
        x_cluster = x(SUs_ativos);
        y_cluster = y(SUs_ativos);
    
        % Energias dos SUs ativos neste cluster
        energia_residual = energia_SU(SUs_ativos);
    
        % Calcula o centro de massa ponderado pela energia residual dos SUs ativos
        Xcm = sum(energia_residual .* x_cluster) / sum(energia_residual);
        Ycm = sum(energia_residual .* y_cluster) / sum(energia_residual);
    
        % Calcula a distância de cada SU ativo ao centro de massa
        distancias_ao_CM = sqrt((x_cluster - Xcm).^2 + (y_cluster - Ycm).^2);
    
        % Seleciona o SU com a maior energia residual no cluster
        [~, idx_maior_energia] = max(energia_residual);
    
        % Atualiza o CH com base no SU com maior energia residual
        if CH(1, c) ~= x_cluster(idx_maior_energia) || CH(2, c) ~= y_cluster(idx_maior_energia)
            % Atualiza o CH se ele mudar
            CH(1, c) = x_cluster(idx_maior_energia);
            CH(2, c) = y_cluster(idx_maior_energia);
    
            % Atualiza as distâncias entre o CH atual e os SUs do cluster
            d_CH(SUs_do_cluster) = sqrt((CH(1, c) - x(SUs_do_cluster)).^2 + (CH(2, c) - y(SUs_do_cluster)).^2);
    
            % Atualiza a distância entre o CH atual e o FC
            d_FC(c) = sqrt((CH(1, c) - xFC)^2 + (CH(2, c) - xFC)^2);
        end
    end
end






















% function [CH, d_CH, d_FC] = verifica_energia_CH(CH, c_max, idx, x, y, d_CH, d_FC, xFC, energia_SU, sensor_off, limiar_SU)

    
    % % global sensor_off
    % 
    % for c = 1:c_max
    %     % Encontra os índices dos sensores pertencentes a este cluster
    %     SUs_do_cluster = find(idx == c);
    % 
    %     % Filtra os sensores ativos (onde sensor_off == 0) dentro do cluster
    %     SUs_ativos = SUs_do_cluster(sensor_off(SUs_do_cluster) == 0);
    % 
    %     % Verifica se há SUs ativos no cluster antes de calcular o centro de massa
    %     if isempty(SUs_ativos)
    %         continue; % Passa para o próximo cluster se não houver SUs ativos
    %     end
    % 
    %     % Coordenadas X e Y dos SUs ativos neste cluster
    %     x_cluster = x(SUs_ativos);
    %     y_cluster = y(SUs_ativos);
    % 
    %     % Energias dos SUs ativos neste cluster
    %     energia_residual = energia_SU(SUs_ativos);
    % 
    %     % Calcula o centro de massa ponderado pela energia residual dos SUs ativos
    %     Xcm = sum(energia_residual .* x_cluster) / sum(energia_residual);
    %     Ycm = sum(energia_residual .* y_cluster) / sum(energia_residual);
    % 
    %     % Calcula a distância de cada SU ativo ao centro de massa
    %     distancias_ao_CM = sqrt((x_cluster - Xcm).^2 + (y_cluster - Ycm).^2);
    % 
    %     % Ordena os SUs ativos pela distância ao CM (do mais próximo ao mais distante)
    %     [~, indices_ordenados] = sort(distancias_ao_CM);
    % 
    %     % Verifica os SUs ativos, do mais próximo ao mais distante, até encontrar um que tenha energia residual maior que o limiar
    %     for i = 1:length(indices_ordenados)
    %         idx_sensor_ordenados = indices_ordenados(i);
    %         % idx_sensor = SUs_ativos(idx_sensor_ordenados);
    % 
    %         % Calcula o limiar de energia do SU ativo com base na distância ao FC
    %         % limiar_SU_cluster = (0.001 * 10^(P_rxFCdBm / 10)) * d_BS(idx_sensor)^alpha1;
    % 
    %         if energia_residual(idx_sensor_ordenados) > limiar_SU
    %             % Verifica se o CH antigo é diferente do CH atual
    %             if CH(1, c) ~= x_cluster(idx_sensor_ordenados) || CH(2, c) ~= y_cluster(idx_sensor_ordenados)
    %                 % Se for diferente, atualiza a posição do CH
    %                 CH(1, c) = x_cluster(idx_sensor_ordenados);
    %                 CH(2, c) = y_cluster(idx_sensor_ordenados);
    % 
    %                 % Atualiza as distâncias entre o CH atual e os SUs do cluster
    %                 d_CH(SUs_do_cluster) = sqrt((CH(1, c) - x(SUs_do_cluster)).^2 + (CH(2, c) - y(SUs_do_cluster)).^2);
    % 
    %                 % Atualiza a distância entre o CH atual e o FC
    %                 d_FC(c) = sqrt((CH(1, c) - xFC)^2 + (CH(2, c) - xFC)^2);
    %             end
    %             break; % Sai do loop ao encontrar um CH válido
    %         end
    %     end
    % end

% end

