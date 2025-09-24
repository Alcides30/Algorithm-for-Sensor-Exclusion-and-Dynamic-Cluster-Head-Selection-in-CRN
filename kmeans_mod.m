function [coords, positions, idx, CH] = kmeans_mod(m_T, c_max, r, xPU, yPU, xFC, energia_SU, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5)
    
    % Gerar valores aleatórios num raio 'r' uniformemente distribuídos entre 0 e 1
    p = sqrt(rand(1, m_T));
    theta = 2 * pi * rand(1, m_T);
    % Colocar os pontos gerados dentro de um circulo especifícado (raio)
    x = p .* cos(theta) * r; 
    y = p .* sin(theta) * r;
    coords = [x; y];
    % disp(coords)
    positions = [x; y]';
    % disp(positions)

    % Inicializa os centroides de forma aleatória
    centroids = positions(randperm(m_T, c_max), :);
    % disp(centroids)
    
    % Itera até que os centroides não mudem mais significativamente
    tolerancia = 1e-5;
    mudanca_centroides = Inf;
    
    while mudanca_centroides > tolerancia
        % Atribui cada SU ao cluster mais próximo
        distancias = pdist2(positions, centroids);
        [~, idx] = min(distancias, [], 2);
    
        % Calcula os novos centroides ponderados pela energia residual
        novos_centroides = zeros(c_max, 2);
        for c = 1:c_max
            membros = positions(idx == c, :);
            energias_membros = energia_SU(idx == c);
            
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

    % Usar k-means clustering para formar c_max clusters
    % [idx, centroids] = kmeans([x;y]',c_max);

    % Array para armazenar as coordenadas dos SUs. Uso apenas plotar a figura 2 
    SU = cell(c_max, 1); % Inicializa um array de células para armazenar as coordenadas dos SUs em cada cluster
    for i = 1:c_max
        SU{i} = [x(idx == i); y(idx == i)]; % Armazena as coordenadas dos SUs pertencentes ao i-ésimo cluster
    end

    % Array para armazenar as coordenadas dos CHs. Use CH{#} para recuperar os valores.
    CH = cell(c_max, 1); % Array to store the CHs' coordinates. Use CH{#} to retrive the values.,
    if c_max == 1
        distances = sqrt((centroids(1, 1) - x).^2 + (centroids(1, 2) - y).^2); 
        [~, min_index] = min(distances);  
        CH{1} = [x(min_index), y(min_index)]';
    else    
        for i = 1:c_max
            x_cluster = x(idx == i); % Obtém as coordenadas x dos SUs no i-ésimo cluster
            y_cluster = y(idx == i); % Obtém as coordenadas y dos SUs no i-ésimo cluster
            distances = sqrt((centroids(i, 1) - x_cluster).^2 + (centroids(i, 2) - y_cluster).^2);  % Calcula as distâncias de cada SU ao centróide do cluste
            [~, min_index] = min(distances);  % Encontra o SU mais próximo do centróide
            CH{i} = [x_cluster(min_index), y_cluster(min_index)]'; % Armazena as coordenadas do CH mais próximo ao centróide
        end
    end
    
    % Plot dos pontos gerados
    figure(1);
    hold on;
    % Alterar a fonte globalmente
    set(gca, 'FontName', 'Times New Roman'); % Configura a fonte dos eixos
    set(findall(gcf,'type','text'), 'FontName', 'Times New Roman'); % Configura a fonte de todos os textos na figura

    % % Se necessário, configure também o tamanho da fonte
    % set(gca, 'FontSize', 10); % Configura o tamanho da fonte dos eixos
    % set(findall(gcf, 'type', 'text'), 'FontSize', 10); % Configura o tamanho da fonte dos textos
    % Plot PU
    scatter(xPU, yPU, 100, 'r^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5);
    text(xPU, yPU + 5, 'PU', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    % Plot FC
    scatter(xFC, xFC, 100, 'g^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1.5); 
    text(xFC, xFC - 15, 'FC', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10, 'FontWeight', 'bold');
    % scatter(x, y, 50, 'bo', 'MarkerFaceColor', 'b', 'LineWidth', 1.5);
    scatter(x, y, 'b', 'filled');  
    for i = 1:m_T
        text(x(i), y(i), sprintf('%d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    legendLabels = {'Primary User (PU)', 'Fusion Center (FC)', 'Secondary User (SUs)'};
    % scatter(centroid_coords(1, :), centroid_coords(2, :), 50, 'r', 'filled', 'o'); % Centróides
    % viscircles(centroid_coords', cluster_radius * ones(c_max, 1), 'LineStyle', '--'); % Áreas circulares dos clusters
    % title('Distribuição Uniforme de Pontos com Maior Dispersão em Torno de Centróides');


    % Zonas sombreadas
    rectangle('Position', [x_center_1 - raio_1, y_center_1 - raio_1, 2*raio_1, 2*raio_1], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--'); % Desenha a área obstáculo
    rectangle('Position', [x_center_2 - raio_2, y_center_2 - raio_2, 2*raio_2, 2*raio_2], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    rectangle('Position', [x_center_3 - raio_3, y_center_3 - raio_3, 2*raio_3, 2*raio_3], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    rectangle('Position', [x_center_4 - raio_4, y_center_4 - raio_4, 2*raio_4, 2*raio_4], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    rectangle('Position', [x_center_5 - raio_5, y_center_5 - raio_5, 2*raio_5, 2*raio_5], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');

    % Adicionar legenda nas zonas sombreadas
    text(x_center_1, y_center_1, 'Shadowed Areas 1', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k'); % Adiciona rótulo à área obstáculo
    text(x_center_2, y_center_2, 'Shadowed Areas 2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    text(x_center_3, y_center_3, 'Shadowed Areas 3', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    text(x_center_4, y_center_4, 'Shadowed Areas 4', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    text(x_center_5, y_center_5, 'Shadowed Areas 5', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');

    % Adicionando o círculo de cobertura ao gráfico
    rectangle('Position', [xFC - r, xFC - r, 2*r, 2*r], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1) %.5, 'LineStyle', '--');
    axis equal;

    grid on;
    hold off;
    xlim([-r, r]);
    ylim([-r, r]);
    xlabel('X');
    ylabel('Y');
    title('Distribuição espacial dos SUs');
    legend(legendLabels, 'Location', 'best');


    % Cores para cada cluster
    cluster_colors = parula(c_max+1);
    figure(2)
    hold on;
    % Alterar a fonte globalmente
    set(gca, 'FontName', 'Times New Roman'); % Configura a fonte dos eixos
    set(findall(gcf,'type','text'), 'FontName', 'Times New Roman'); % Configura a fonte de todos os textos na figura

    % Se necessário, configure também o tamanho da fonte
    set(gca, 'FontSize', 10); % Configura o tamanho da fonte dos eixos
    set(findall(gcf, 'type', 'text'), 'FontSize', 10); % Configura o tamanho da fonte dos textos
    for i = 1:c_max
        scatter(SU{i}(1, :), SU{i}(2, :), 'filled', 'MarkerFaceColor', cluster_colors(i, :));
    end

    % Plotar o FC, PU
    scatter(xFC, xFC, 100, 'g^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1.5); % FC 
    scatter(xPU, yPU, 100, 'r^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5); % PU 

    % Adicionar os nomes para FC, PU 
    text(xFC, xFC - 15, 'FC', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10, 'FontWeight', 'bold');
    % text(xPU, yPU + 5, '\bf{PU}_{tx}', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    text(xPU, yPU + 6, 'PU', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');


    % % Adicionar rótulos aos pontos
    % for i = 1:m_T
    %     text(x(i), y(i), sprintf('%d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    % end

    % Plotar os centroides com uma cruz
    for i = 1:c_max
        scatter(centroids(i, 1), centroids(i, 2), 'kx', 'LineWidth', 1.5);
    end

    % Plotar os CH com um círculo preto, que são os pontos mais próximos dos centroids
    for i = 1:c_max
        scatter(CH{i}(1), CH{i}(2), 100, 'ko', 'LineWidth', 1.5); % Círculo preto para representar a média do cluster head
    end
    % Colocar legenda no CH
    for i = 1:c_max
        text(CH{i}(1), CH{i}(2), sprintf('CH %d', i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    end

    % Representação das zonas sombreadas
    rectangle('Position', [x_center_1 - raio_1, y_center_1 - raio_1, 2*raio_1, 2*raio_1], ...
      'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    rectangle('Position', [x_center_2 - raio_2, y_center_2 - raio_2, 2*raio_2, 2*raio_2], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    rectangle('Position', [x_center_3 - raio_3, y_center_3 - raio_3, 2*raio_3, 2*raio_3], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    rectangle('Position', [x_center_4 - raio_4, y_center_4 - raio_4, 2*raio_4, 2*raio_4], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    rectangle('Position', [x_center_5 - raio_5, y_center_5 - raio_5, 2*raio_5, 2*raio_5], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');

    % Adicionar legenda à área obstáculo
    text(x_center_1, y_center_1+10, 'Shadowed Areas', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k'); % Adiciona rótulo à área obstáculo
    text(x_center_2, y_center_2, 'Shadowed Areas 2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    text(x_center_3, y_center_3, 'Shadowed Areas 3', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    text(x_center_4, y_center_4, 'Shadowed Areas 4', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    text(x_center_5, y_center_5, 'Shadowed Areas 5', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');

    % Adicionando o círculo de cobertura ao gráfico
    rectangle('Position', [xFC - r, xFC - r, 2*r, 2*r], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1) %.5, 'LineStyle', '--');
    axis equal;

    hold off;
    xlim([-r, r]);
    ylim([-r, r]);

    % Criar rótulos da legenda automaticamente
    legendLabels = cell(c_max + 3, 1);
    for i = 1:c_max
        legendLabels{i} = sprintf('Cluster %d', i);
    end
    legendLabels{c_max+1} = 'FC';
    legendLabels{c_max+2} = 'PU';
    legendLabels{c_max+3} = 'Centroids';

    title('Agrupamento dos SUs (K-Means)');
    grid on
    xlabel('X');
    ylabel('Y');
    legend(legendLabels, 'Location', 'best', 'FontSize', 8);

    % Salvar a figura como EMF
    % print('figure1.emf', '-dmeta', '-r300'); % Salva como EMF com 300 DPI

    % Converte o array de células de coordenadas dos CHs para matriz
    CH = cell2mat(CH');  
    % disp(CH)
    % disp(idx')

end