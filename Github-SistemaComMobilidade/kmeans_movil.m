function [CH, idx] = kmeans_movil(positions, c_max, r, energia_SU, sensor_off, ciclo, xPU, yPU, xFC, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5)

   
    % Filtra os SUs vivos (sensor_off == 0)
    vivos = (sensor_off == 0);
    positions_vivos = positions(vivos, :);
    SUs_vivos = energia_SU(vivos);

    % Inicializa os centroides de forma aleatória
    centroids = positions_vivos(randperm(size(positions_vivos, 1), c_max), :);
    
    % Itera até que os centroides não mudem mais significativamente
    tolerancia = 1e-5;
    mudanca_centroides = Inf;
    
    while mudanca_centroides > tolerancia
        % Atribui cada SU ao cluster mais próximo
        distancias = pdist2(positions_vivos, centroids);
        [~, idx_vivos] = min(distancias, [], 2);

        % Reatribui os valores para todos os sensores (mesmo os que estão desligados)
        idx = NaN(size(sensor_off));  % Inicializa o vetor de índice com NaN
        idx(vivos) = idx_vivos;  % Atribui os índices dos sensores ativos

        % Calcula os novos centroides ponderados pela energia residual
        novos_centroides = zeros(c_max, 2);
        for c = 1:c_max
            membros = positions_vivos(idx_vivos == c, :);
            energias_membros = SUs_vivos(idx_vivos == c);
            
            if ~isempty(membros)
                % Calcula o centro de massa ponderado pela energia
                novos_centroides(c, :) = sum(membros .* energias_membros', 1) / sum(energias_membros);
            else
                % Se um cluster não tiver membros, mantém o centróide antigo
                novos_centroides(c, :) = centroids(c, :);
            end
        end
    
        % Calcula a mudança nos centroides
        mudanca_centroides = max(vecnorm(novos_centroides - centroids, 2, 2));
        centroids = novos_centroides;
    end

    % Array para armazenar as coordenadas dos SUs. Uso apenas plotar a figura 2 
    SU = cell(c_max, 1); % Inicializa um array de células para armazenar as coordenadas dos SUs em cada cluster
    for i = 1:c_max
        SU{i} = positions(idx_vivos == i, :)'; % Armazena as coordenadas dos SUs pertencentes ao i-ésimo cluster
    end

    % Array para armazenar as coordenadas dos CHs
    CH = cell(c_max, 1);  % Array para armazenar os CHs; use CH{#} para recuperar os valores.
    for i = 1:c_max
        % Membros do cluster i
        membros_cluster = positions_vivos(idx_vivos == i, :);
        energias_membros = SUs_vivos(idx_vivos == i);
        % distances_to_centroid = vecnorm(membros_cluster - centroids(i, :), 2, 2);

        % Verifica se o índice é NaN (para clusters com índice NaN ou sem membros)
        if isempty(membros_cluster)
            % Atribui uma coordenada padrão (pode ser uma coordenada arbitrária, como [NaN, NaN])
            CH{i} = [NaN, NaN]';  % Define o CH como NaN.NaN
        else 
            [~, idx_maior_energia] = max(energias_membros); % Índice do SU com maior energia
            CH{i} = membros_cluster(idx_maior_energia, :)'; % O SU com maior energia é o CH
        end 
    end

    % if ciclo == 1
    %      % Cores para cada cluster
    %     cluster_colors = parula(c_max+1);
    %     figure(2)
    %     hold on;
    %     % Alterar a fonte globalmente
    %     set(gca, 'FontName', 'Times New Roman'); % Configura a fonte dos eixos
    %     set(findall(gcf,'type','text'), 'FontName', 'Times New Roman'); % Configura a fonte de todos os textos na figura
    % 
    %     % Se necessário, configure também o tamanho da fonte
    %     set(gca, 'FontSize', 10); % Configura o tamanho da fonte dos eixos
    %     set(findall(gcf, 'type', 'text'), 'FontSize', 10); % Configura o tamanho da fonte dos textos
    %     for i = 1:c_max
    %         scatter(SU{i}(1, :), SU{i}(2, :), 'filled', 'MarkerFaceColor', cluster_colors(i, :));
    %     end
    % 
    %     % Plotar o FC, PU
    %     scatter(xFC, xFC, 100, 'g^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1.5); % FC 
    %     scatter(xPU, yPU, 100, 'r^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5); % PU 
    % 
    %     % Adicionar os nomes para FC, PU 
    %     text(xFC, xFC - 15, 'FC', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10, 'FontWeight', 'bold');
    %     % text(xPU, yPU + 5, '\bf{PU}_{tx}', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    %     text(xPU, yPU + 6, 'PU', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    % 
    % 
    %     % % Adicionar rótulos aos pontos
    %     % for i = 1:m_T
    %     %     text(x(i), y(i), sprintf('%d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    %     % end
    % 
    %     % Plotar os centroides com uma cruz
    %     for i = 1:c_max
    %         scatter(centroids(i, 1), centroids(i, 2), 'kx', 'LineWidth', 1.5);
    %     end
    % 
    %     % Plotar os CH com um círculo preto, que são os pontos mais próximos dos centroids
    %     for i = 1:c_max
    %         scatter(CH{i}(1), CH{i}(2), 100, 'ko', 'LineWidth', 1.5); % Círculo preto para representar a média do cluster head
    %     end
    %     % Colocar legenda no CH
    %     for i = 1:c_max
    %         text(CH{i}(1), CH{i}(2), sprintf('CH %d', i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    %     end
    % 
    %     % Representação das zonas sombreadas
    %     rectangle('Position', [x_center_1 - raio_1, y_center_1 - raio_1, 2*raio_1, 2*raio_1], ...
    %       'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    %     rectangle('Position', [x_center_2 - raio_2, y_center_2 - raio_2, 2*raio_2, 2*raio_2], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    %     rectangle('Position', [x_center_3 - raio_3, y_center_3 - raio_3, 2*raio_3, 2*raio_3], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    %     rectangle('Position', [x_center_4 - raio_4, y_center_4 - raio_4, 2*raio_4, 2*raio_4], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    %     rectangle('Position', [x_center_5 - raio_5, y_center_5 - raio_5, 2*raio_5, 2*raio_5], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % 
    %     % Adicionar legenda à área obstáculo
    %     text(x_center_1, y_center_1+10, 'Shadowed Areas', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k'); % Adiciona rótulo à área obstáculo
    %     text(x_center_2, y_center_2, 'Shadowed Areas 2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    %     text(x_center_3, y_center_3, 'Shadowed Areas 3', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    %     text(x_center_4, y_center_4, 'Shadowed Areas 4', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    %     text(x_center_5, y_center_5, 'Shadowed Areas 5', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % 
    %     % Adicionando o círculo de cobertura ao gráfico
    %     rectangle('Position', [xFC - r, xFC - r, 2*r, 2*r], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1) %.5, 'LineStyle', '--');
    %     axis equal;
    % 
    %     hold off;
    %     xlim([-r, r]);
    %     ylim([-r, r]);
    % 
    %     % Criar rótulos da legenda automaticamente
    %     legendLabels = cell(c_max + 3, 1);
    %     for i = 1:c_max
    %         legendLabels{i} = sprintf('Cluster %d', i);
    %     end
    %     legendLabels{c_max+1} = 'FC';
    %     legendLabels{c_max+2} = 'PU';
    %     legendLabels{c_max+3} = 'Centroids';
    % 
    %     title('Agrupamento dos SUs (K-Means)');
    %     grid on
    %     xlabel('X');
    %     ylabel('Y');
    %     legend(legendLabels, 'Location', 'best', 'FontSize', 8);
    % end

    % Converte o array de células de coordenadas dos CHs para matriz
    CH = cell2mat(CH');  
    % disp(CH)

    % disp(idx)

end


