% clear variables; 
% close all;
% clc; 
% 
% 
% % Coordenadas dos pontos
% X = [1 1 1 1.5 2 2 2 2.5 2.8 3 3 4 4.5 5 5 5 6 7];
% Y = [2 2.5 3 2.5 0 2.5 5 5.5 5.5 5 6 2 2.5 2 2.5 3 5 1];
% 
% % Criando a figura
% figure;
% hold on; % Mantém a figura ativa para adicionar rótulos
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 12); % Configura a fonte dos eixos
% scatter(X, Y, 50, 'k', 'filled'); % Plota os pontos em preto ('k'), tamanho 50, preenchidos
% 
% % Configurações do gráfico
% grid on;
% xlabel('X', 'FontName', 'Times New Roman', 'FontSize', 12);
% ylabel('Y', 'FontName', 'Times New Roman', 'FontSize', 12);
% % title('Distribuição Espacial dos Pontos', 'FontName', 'Times New Roman', 'FontSize', 14);
% xlim([0 8]); % Ajustando os limites do eixo X para melhor visualização
% ylim([-1 7]); % Ajustando os limites do eixo Y para melhor visualização
% 
% % Adicionando rótulos aos pontos
% for i = 1:length(X)
%     text(X(i), Y(i), sprintf('P_{%d}', i), 'VerticalAlignment', 'bottom', ...
%         'HorizontalAlignment', 'right', 'FontSize', 10, 'FontName', 'Times New Roman');
% end
% 
% % Adicionando legenda
% legend('Pontos', 'Location', 'Best', 'FontName', 'Times New Roman', 'FontSize', 10);
% hold off;

clear;
close all;
clc;

% Coordenadas dos pontos
X = [1 1 1 1.5 2 2 2 2.5 2.8 3 3 4 4.5 5 5 5 6 7];
Y = [2 2.5 3 2.5 0 2.5 5 5.5 5.5 5 6 2 2.5 2 2.5 3 5 1];

% Número de clusters
k = 3;

% Matriz de pontos
dados = [X' Y'];

% Aplicando K-Means
[idx, C] = kmeans(dados, k, 'Replicates', 10);

% Cores para os clusters
cores = {'b', 'r', 'y'};

% Criando a figura
figure;
hold on; % Mantém a figura ativa para adicionar rótulos
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12); % Configura a fonte dos eixos
grid on;

% Plotando os pontos de cada cluster
for i = 1:k
    scatter(X(idx == i), Y(idx == i), 50, cores{i}, 'filled');
end

% Plotando os centroides
scatter(C(:,1), C(:,2), 100, 'k', 'x', 'LineWidth', 2);

% Configuração do gráfico
xlabel('X');
ylabel('Y');
% title('Clusters formados pelo K-means');
legend({'Cluster 1', 'Cluster 2', 'Cluster 3', 'Centroids'}, 'Location', 'Best');
xlim([0 8]); % Ajustando os limites do eixo X para melhor visualização
ylim([-1 7]); % Ajustando os limites do eixo Y para melhor visualização
hold off;
