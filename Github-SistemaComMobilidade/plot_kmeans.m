function plot_kmeans(m_T, c_max, r, xPU, yPU, xFC, CH_1, SU, positions, centroids, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5)


    % x = positions(:,1)';
    % y = positions(:,2)';

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


end