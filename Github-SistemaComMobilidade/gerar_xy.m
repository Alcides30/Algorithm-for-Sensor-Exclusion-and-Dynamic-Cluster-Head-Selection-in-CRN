function [coords, positions, paths, speed, destinations, P_move] = gerar_xy(m_T, r, xPU, yPU, xFC, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5)

    % c_max = 5;
    % 
    % % Divide os pontos igualmente entre os clusters
    % points_per_cluster = floor(m_T / c_max); % Calcula o número inteiro de pontos por cluster
    % points_remaining = mod(m_T, c_max);      % Calcula os pontos que sobram após a divisão igualitária
    % 
    % % Critério de distância mínima entre centroides e a origem (0, 0)
    % centroid_coords = zeros(2, c_max);  % Matriz para armazenar as coordenadas (x, y) dos centróides
    % 
    % % Geração dos centróides com distância mínima garantida
    % for c = 1:c_max
    %     while true
    %         % Gera coordenadas polares aleatórias dentro da área global ajustada
    %         p = (r - cluster_radius) * sqrt(rand);      % Distância radial aleatória até r - cluster_radius
    %         theta = 2 * pi * rand;                      % Ângulo aleatório de 0 a 2*pi
    % 
    %         % Converte coordenadas polares para cartesianas
    %         new_centroid = [p * cos(theta); p * sin(theta)];
    % 
    %         % Verifica se o novo centróide está longe o suficiente dos já existentes e da origem
    %         if norm(new_centroid) >= min_dist_from_origin && ... % Verifica a distância mínima da origem
    %            (c == 1 || all(vecnorm(centroid_coords(:, 1:c-1) - new_centroid, 2, 1) >= min_dist_between_centroids)) % Verifica a distância mínima dos outros centróides
    %             centroid_coords(:, c) = new_centroid; % Armazena as coordenadas do novo centróide
    %             break; % Sai do loop de tentativa
    %         end
    %     end
    % end
    % 
    % % Inicialização das coordenadas dos dispositivos
    % x = []; % Vetor vazio para coordenadas x
    % y = []; % Vetor vazio para coordenadas y
    % 
    % % Gera os dispositivos em torno de cada centróide
    % for c = 1:c_max
    %     % Determina o número de pontos para este cluster
    %     if c <= points_remaining
    %         num_cluster_points = points_per_cluster + 1; % Cluster recebe um ponto adicional se há sobra
    %     else
    %         num_cluster_points = points_per_cluster; % Caso contrário, recebe o número base de pontos
    %     end
    % 
    %     % Gera coordenadas polares uniformes dentro da área total permitida
    %     p = sqrt(rand(1, num_cluster_points)) * cluster_radius; % Distâncias aleatórias até o limite global da área
    %     theta = 2 * pi * rand(1, num_cluster_points); % Ângulos aleatórios de 0 a 2*pi
    % 
    %     % Converte para coordenadas cartesianas em torno do centróide atual e aumenta a dispersão entre os pontos
    %     x_cluster = centroid_coords(1, c) + p .* cos(theta) ...
    %         + (std * randn(1, num_cluster_points));
    %     y_cluster = centroid_coords(2, c) + p .* sin(theta) ...
    %         + (std * randn(1, num_cluster_points));
    % 
    %     % Ajusta pontos que estejam fora da área total de cobertura
    %     for i = 1:num_cluster_points
    %         distance = sqrt(x_cluster(i)^2 + y_cluster(i)^2); % Distância do ponto à origem
    %         if distance > r
    %             % Ajusta o ponto para dentro da área total (raio r)
    %             scaling_factor = r / distance;
    %             x_cluster(i) = x_cluster(i) * scaling_factor;
    %             y_cluster(i) = y_cluster(i) * scaling_factor;
    %         end
    %     end
    % 
    %     % Armazena as coordenadas dos dispositivos
    %     x = [x, x_cluster]; % Adiciona as coordenadas x ao vetor total
    %     y = [y, y_cluster]; % Adiciona as coordenadas y ao vetor total
    % end
    
    p = sqrt(rand(1, m_T));  % Distribuição radial para manter a uniformidade
    theta = 2 * pi * rand(1, m_T);  % Ângulo aleatório entre 0 e 2π
    x = p .* cos(theta) * r;  % Coordenada x
    y = p .* sin(theta) * r;  % Coordenada y

    coords = [x; y]; % Matriz com todas as coordenadas (x, y) dos dispositivos
    positions = [x; y]'; % Matriz transposta com as posições, útil para outros cálculos ou armazenamento

    speed = 5 * rand(m_T, 1);  % Velocidades aleatórias para cada SU
    P_move = 0.5; % Probabilidade de movimento para cada sensor

    % Gerar destinos iniciais dentro do mesmo círculo
    p_dest = sqrt(rand(1, m_T));  % Distribuição radial para destinos
    theta_dest = 2 * pi * rand(1, m_T);  % Ângulo aleatório para destinos
    x_dest = p_dest .* cos(theta_dest) * r;  % Coordenada x do destino
    y_dest = p_dest .* sin(theta_dest) * r;  % Coordenada y do destino
    destinations = [x_dest' y_dest'];  % Matriz de destinos (N x 2)

    % Inicializar posições e destinos
    paths = cell(m_T, 1);  % Para armazenar os caminhos dos nós
    for i = 1:m_T
        paths{i} = positions(i, :);  % Inicializar caminhos com as posições iniciais
    end

    % % Plot dos pontos gerados
    % figure(1);
    % hold on;
    % % Alterar a fonte globalmente
    % set(gca, 'FontName', 'Times New Roman'); % Configura a fonte dos eixos
    % set(findall(gcf,'type','text'), 'FontName', 'Times New Roman'); % Configura a fonte de todos os textos na figura
    % 
    % % Se necessário, configure também o tamanho da fonte
    % set(gca, 'FontSize', 10); % Configura o tamanho da fonte dos eixos
    % set(findall(gcf, 'type', 'text'), 'FontSize', 10); % Configura o tamanho da fonte dos textos
    % % Plot PU
    % scatter(xPU, yPU, 100, 'r^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5);
    % text(xPU, yPU + 5, 'PU', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
    % % Plot FC
    % scatter(xFC, xFC, 100, 'g^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1.5); 
    % text(xFC, xFC - 15, 'FC', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10, 'FontWeight', 'bold');
    % % scatter(x, y, 50, 'bo', 'MarkerFaceColor', 'b', 'LineWidth', 1.5);
    % scatter(x, y, 'b', 'filled');  
    % % for i = 1:m_T
    % %     text(x(i), y(i), sprintf('%d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    % % end
    % legendLabels = {'Primary User (PU)', 'Fusion Center (FC)', 'Secondary User (SUs)'};
    % scatter(centroid_coords(1, :), centroid_coords(2, :), 50, 'r', 'filled', 'o'); % Centróides
    % viscircles(centroid_coords', cluster_radius * ones(c_max, 1), 'LineStyle', '--'); % Áreas circulares dos clusters
    % % title('Distribuição Uniforme de Pontos com Maior Dispersão em Torno de Centróides');
    % 
    % 
    % % Zonas sombreadas
    % rectangle('Position', [x_center_1 - raio_1, y_center_1 - raio_1, 2*raio_1, 2*raio_1], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--'); % Desenha a área obstáculo
    % rectangle('Position', [x_center_2 - raio_2, y_center_2 - raio_2, 2*raio_2, 2*raio_2], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % rectangle('Position', [x_center_3 - raio_3, y_center_3 - raio_3, 2*raio_3, 2*raio_3], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % rectangle('Position', [x_center_4 - raio_4, y_center_4 - raio_4, 2*raio_4, 2*raio_4], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % rectangle('Position', [x_center_5 - raio_5, y_center_5 - raio_5, 2*raio_5, 2*raio_5], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
    % 
    % % Adicionar legenda nas zonas sombreadas
    % text(x_center_1, y_center_1, 'Shadowed Areas 1', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k'); % Adiciona rótulo à área obstáculo
    % text(x_center_2, y_center_2, 'Shadowed Areas 2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % text(x_center_3, y_center_3, 'Shadowed Areas 3', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % text(x_center_4, y_center_4, 'Shadowed Areas 4', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
    % text(x_center_5, y_center_5, 'Shadowed Areas 5', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
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
    % % title('Distribuição espacial dos SUs');
    % legend(legendLabels, 'Location', 'best');

end





