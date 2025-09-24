clear variables; close all; clc; 

%% Parâmetros
m_T                        = 20; % Número de usuários secundários
c_max                      = 3; % Número máximo de clusters
r                          = 1000; % Área de cobertura, m
PU                         = 1; % Transmissor primário
xPU                        = -r; % Coordenada x do PU
yPU                        = r; % Coordenada y do PU
xFC                        = 0; % Coordenada x do FC, igual yFC

%% Áreas de sombras
raio_1                     = 150; 
x_center_1                 = -200;
y_center_1                 = 600; 

raio_2                     = 150; 
x_center_2                 = 700; 
y_center_2                 = 400; 

raio_3                     = 150;
x_center_3                 = 400; 
y_center_3                 = -400; 

raio_4                     = 150; 
x_center_4                 = 0; 
y_center_4                 = -800; 

raio_5                     = 150; 
x_center_5                 = -600; 
y_center_5                 = -100; 


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
%  % % Zonas sombreadas
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
% % grid on;
% hold off;
% xlim([-r, r]);
% ylim([-r, r]);
% xlabel('X');
% ylabel('Y');
% title('Distribuição espacial dos SUs');
% legend(legendLabels, 'Location', 'best');


x = coords(1, :);  % Coordenadas X dos SUs
y = coords(2, :);  % Coordenadas Y dos SUs


% Usar k-means clustering para formar c_max clusters
[idx, centroids] = kmeans([x;y]',c_max);

% Array para armazenar as coordenadas dos SUs. Uso apenas plotar a figura 2 
SU = cell(c_max, 1); % Inicializa um array de células para armazenar as coordenadas dos SUs em cada cluster
for i = 1:c_max
    SU{i} = [x(idx == i); y(idx == i)]; % Armazena as coordenadas dos SUs pertencentes ao i-ésimo cluster
end

% Array para armazenar as coordenadas dos CHs. Use CH{#} para recuperar os valores.
CH = cell(c_max, 1); % Array to store the CHs' coordinates. Use CH{#} to retrive the values.,
for i = 1:c_max
    x_cluster = x(idx == i); % Obtém as coordenadas x dos SUs no i-ésimo cluster
    y_cluster = y(idx == i); % Obtém as coordenadas y dos SUs no i-ésimo cluster
    distances = sqrt((centroids(i, 1) - x_cluster).^2 + (centroids(i, 2) - y_cluster).^2);  % Calcula as distâncias de cada SU ao centróide do cluste
    [~, min_index] = min(distances);  % Encontra o SU mais próximo do centróide
    CH{i} = [x_cluster(min_index), y_cluster(min_index)]'; % Armazena as coordenadas do CH mais próximo ao centróide
end

% Cores para cada cluster
cluster_colors = [0 0 1;  % Azul
                  0 1 0;  % Verde
                  1 0 0]; % Vermelho
figure(2)
hold on;
% Alterar a fonte globalmente
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10); % Configura a fonte dos eixos
set(findall(gcf,'type','text'), 'FontName', 'Times New Roman', 'FontSize', 10); % Configura a fonte de todos os textos na figura

% Se necessário, configure também o tamanho da fonte
set(gca, 'FontSize', 10); % Configura o tamanho da fonte dos eixos
set(findall(gcf, 'type', 'text'), 'FontSize', 10); % Configura o tamanho da fonte dos textos

for i = 1:c_max
    scatter(SU{i}(1, :), SU{i}(2, :), 50, 'filled', 'MarkerFaceColor', cluster_colors(i, :));
end

% Plotar o FC, PU
scatter(xFC, xFC, 100, 'g^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'LineWidth', 1.5); % FC 
scatter(xPU, yPU, 100, 'r^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'LineWidth', 1.5); % PU 

% Adicionar os nomes para FC, PU 
text(xFC, xFC - 15, 'FC', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10, 'FontWeight', 'bold');
% text(xPU, yPU + 5, '\bf{PU}_{tx}', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
text(xPU, yPU + 6, '\bf{PU}_{tx}', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');


% % Adicionar rótulos aos pontos
% for i = 1:m_T
%     text(x(i), y(i), sprintf('%d', i), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
% end

% Plotar os centroides com uma cruz
for i = 1:c_max
    scatter(centroids(i, 1), centroids(i, 2), 'kx', 'LineWidth', 2);
end

% Plotar os CH com um círculo preto, que são os pontos mais próximos dos centroids
for i = 1:c_max
    scatter(CH{i}(1), CH{i}(2), 50, 'ko', 'LineWidth', 2); % Círculo preto para representar a média do cluster head
end
% Colocar legenda no CH
for i = 1:c_max
    text(CH{i}(1), CH{i}(2), sprintf('CH_{%d}', i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 10, 'FontWeight', 'bold');
end

% Representação das zonas sombreadas
rectangle('Position', [x_center_1 - raio_1, y_center_1 - raio_1, 2*raio_1, 2*raio_1], ...
  'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
rectangle('Position', [x_center_2 - raio_2, y_center_2 - raio_2, 2*raio_2, 2*raio_2], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
rectangle('Position', [x_center_3 - raio_3, y_center_3 - raio_3, 2*raio_3, 2*raio_3], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
rectangle('Position', [x_center_4 - raio_4, y_center_4 - raio_4, 2*raio_4, 2*raio_4], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');
rectangle('Position', [x_center_5 - raio_5, y_center_5 - raio_5, 2*raio_5, 2*raio_5], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1, 'LineStyle', '--');

% % Adicionar legenda à área obstáculo
% text(x_center_1, y_center_1+180, 'Shadowed Areas', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 8, 'FontWeight', 'bold', 'Color', 'k'); % Adiciona rótulo à área obstáculo
% text(x_center_2, y_center_2, 'Shadowed Areas 2', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
% text(x_center_3, y_center_3, 'Shadowed Areas 3', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
% text(x_center_4, y_center_4, 'Shadowed Areas 4', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');
% text(x_center_5, y_center_5, 'Shadowed Areas 5', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'k');

% Adicionando o círculo de cobertura ao gráfico
rectangle('Position', [xFC - r, xFC - r, 2*r, 2*r], 'Curvature', [1, 1], 'EdgeColor', [0 0 0], 'LineWidth', 1) %.5, 'LineStyle', '--');
axis equal;

% grid on; % Adicionar grid

hold off;
xlim([-r, r]);
ylim([-r, r]);

% % Criar rótulos da legenda automaticamente
% legendLabels = cell(c_max + 3, 1);
% for i = 1:c_max
%     legendLabels{i} = sprintf('Cluster %d', i);
% end
% legendLabels{c_max+1} = 'FC';
% legendLabels{c_max+2} = 'PU';
% legendLabels{c_max+3} = 'Centroids';

% title('Agrupamento dos SUs (K-Means)');
% grid on
xlabel('X');
ylabel('Y');
% legend(legendLabels, 'Location', 'best', 'FontSize', 8);

% Salvar a figura como EMF
% print('figure1.emf', '-dmeta', '-r300'); % Salva como EMF com 300 DPI
% savefig('figure1.fig'); % Salva como EMF com 300 DPI


%createfigure(X1, Y1, Size1, X2, Y2, X3, Y3, X4, Size2, Color1, X5, Y4, Color2, X6, Y5, Size3, Color3, X7, Y6, X8, Y7, X9, Y8, X10, Y9, X11, Y10)