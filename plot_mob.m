function plot_mob(m_T, paths, r, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5)

    
    % Plotagem do movimento dos SUs para o ciclo atual
    figure(4);
    hold on;
    set(gca, 'FontName', 'Times New Roman'); % Configura a fonte dos eixos
    set(findall(gcf, 'type', 'text'), 'FontName', 'Times New Roman'); % Configura a fonte de todos os textos na figura
    for i = 1:m_T
        plot(paths{i}(:, 1), paths{i}(:, 2), '-o', 'LineWidth', 1.5); % Caminho do SU
        % text(positions(i, 1), positions(i, 2), sprintf('SU %d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right'); % Rótulo
    end
    % Adicionar círculo de cobertura

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

    rectangle('Position', [-r, -r, 2*r, 2*r], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1);
    axis equal;
    xlabel('X');
    ylabel('Y');
    title('Mobilidade dos SUs');
    % legend(arrayfun(@(x) sprintf('SU %d', x), 1:m_T, 'UniformOutput', false), 'Location', 'best');
    axis([-r r -r r]);
    grid on;
    hold off;

end