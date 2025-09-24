function [coords] = gerarXY(xPU,yPU, xFC, r, m_T, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5)

    %% Gerar X e Y aleatoriamente com distribuição uniforme
    p = sqrt(rand(1, m_T));  % Distribuição radial para manter a uniformidade
    theta = 2 * pi * rand(1, m_T);  % Ângulo aleatório entre 0 e 2π
    x = p .* cos(theta) * r;  % Coordenada x
    y = p .* sin(theta) * r;  % Coordenada y

    coords = [x; y];
    
    % % Plot dos pontos gerados
    % figure(1);
    % hold on;
    % % Alterar a fonte globalmente
    % set(gca, 'FontName', 'Times New Roman'); % Configura a fonte dos eixos
    % set(findall(gcf,'type','text'), 'FontName', 'Times New Roman'); % Configura a fonte de todos os textos na figura
    % 
    % % Plot PU
    % scatter(xPU, yPU, 100, 'r^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5);
    % text(xPU, yPU + 5, '\bf{PU}_{tx}', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    % % Plot FC
    % scatter(xFC, xFC, 100, 'g^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1.5); 
    % text(xFC, xFC - 15, 'FC', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10, 'FontWeight', 'bold');
    % 
    % legendLabels = {'Primary User (PU)', 'Fusion Center (FC)', 'Secondary User (SUs)'};
    % 
    % % scatter(x, y, 50, 'bo', 'MarkerFaceColor', 'b', 'LineWidth', 1.5);
    % scatter(x, y, 'b', 'filled');  
    % for i = 1:m_T
    %     text(x(i), y(i), sprintf('%d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    % end
    % 
    % % Zonas sombreadas
    % rectangle('Position', [x_center_1 - raio_1, y_center_1 - raio_1, 2*raio_1, 2*raio_1], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--'); % Desenha a área obstáculo
    % rectangle('Position', [x_center_2 - raio_2, y_center_2 - raio_2, 2*raio_2, 2*raio_2], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % rectangle('Position', [x_center_3 - raio_3, y_center_3 - raio_3, 2*raio_3, 2*raio_3], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % rectangle('Position', [x_center_4 - raio_4, y_center_4 - raio_4, 2*raio_4, 2*raio_4], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % rectangle('Position', [x_center_5 - raio_5, y_center_5 - raio_5, 2*raio_5, 2*raio_5], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % 
    % % % Adicionar legenda nas zonas sombreadas
    % % text(x_center_1, y_center_1, 'Shadowed Areas 1', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k'); % Adiciona rótulo à área obstáculo
    % % text(x_center_2, y_center_2, 'Shadowed Areas 2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % % text(x_center_3, y_center_3, 'Shadowed Areas 3', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % % text(x_center_4, y_center_4, 'Shadowed Areas 4', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % % text(x_center_5, y_center_5, 'Shadowed Areas 5', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % 
    % % Adicionando o círculo de cobertura ao gráfico
    % rectangle('Position', [xFC - r, xFC - r, 2*r, 2*r], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1) %.5, 'LineStyle', '--');
    % axis equal;
    % 
    % grid on;
    % hold off;
    % xlim([-r, r]);
    % ylim([-r, r]);
    % xlabel('X');
    % ylabel('Y');
    % title('Distribuição espacial dos SUs');
    % legend(legendLabels, 'Location', 'best');

end