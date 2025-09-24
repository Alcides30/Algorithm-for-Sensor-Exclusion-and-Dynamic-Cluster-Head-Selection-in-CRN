%% Preparação do ambiente de simulação
clear variables; close all; clc;

% %% Semente para geração de números aleatórios
% SEED                       = 555; % Define o gerador de números aleatórios, garantindo que seja a mesma em diferentes execussões.
% rng(SEED);                        % Inicializa o gerador de números aleatórios com o valor da semente definida. 

%% Sensoriamento espectral cooperativo com detector de energia
m_T                        = 100; % Número de usuários secundários
c_max                      = 5; % Número máximo de clusters
r                          = 1000; % Área de cobertura, m
PU                         = 1; % Transmissor primário
xPU                        = -r; % Coordenada x do PU
yPU                        = r; % Coordenada y do PU
xFC                        = 0; % Coordenada x do FC, igual yFC
P_txPU                     = 1; % Potência de transmissão, W
alpha                      = 2; % Expoente de perda de percurso em áreas sem obstáculo
alpha1                     = 4; % Expoente de perda de percurso em áreas com obstáculo
n                          = 60; % Número de amostras
P_n                        = 1.0*10^-6; % Potência média do ruído
Pfa_ref                    = 0.1; % Probabilidade de falso alarme de referência
nSensing                   = 5000; % Número de ciclos das batérias dos SUs
% start_time                 = 1; % Tempo base para o calculo do backoff
max_back                   = 20;
g                          = 1; % Número de geração dos SUs

%% Parâmetros para análise do consumo energético
P_s                        = 1.0*10^-6; % Potência dissipada por SU durante o sensoriamento, w
tau_s                      = 1; % Intervalo de sensoriamento, s
tau_rSU                    = 1; % Intervalo de reporte de cada SU para o CH, s
tau_rCH                    = 3; % Intervalo de reporte de cada CH para o FC, s
P_rxCHdBm                  = -100; % Sensibilidade de recepção do CH, dBm
P_rxFCdBm                  = -100; % Sensibilidade de recepção do FC, dBm
limiar_SU                  = ((0.001 * 10^(P_rxFCdBm / 10)) * r^alpha) + P_s; % Mínima power necessária para os SUs realizarem SS e Reportar suas decisões ao FC
energia_inicial            =  limiar_SU * nSensing; % Cálculo da potência inicial de todos os SUs
energia_SU                 = energia_inicial * ones(1, m_T); % Potência inicial de cada SUs

% %% Geradção de dados
% cluster_radius             = 300;             % Raio da área circular de cobertura para cada cluster (aumentado)
% min_dist_between_centroids = 2*cluster_radius; % Distância mínima entre os centróides para evitar sobreposição
% min_dist_from_origin       = 100;       % Distância mínima dos centróides em relação à origem (0,0)
% std                        = cluster_radius * 0.4;         % Desvio padrão para aumentar a dispersão dos SUs

%% Determinação das áreas com obstáculos
% Área_1
raio_1                     = 150; % Raio da área de obstáculo
x_center_1                 = -200; % Coordenada x do centro da área de obstáculo
y_center_1                 = 600; % Coordenada y do centro da área de obstáculo

% Área_2
raio_2                     = 150; % Raio da área de obstáculo
x_center_2                 = 700; % Coordenada x do centro da área de obstáculo
y_center_2                 = 400; % Coordenada y do centro da área de obstáculo

% Área_3
raio_3                     = 150; % Raio da área de obstáculo
x_center_3                 = 400; % Coordenada x do centro da área de obstáculo
y_center_3                 = -400; % Coordenada y do centro da área de obstáculo

% Área_4
raio_4                     = 150; % Raio da área de obstáculo
x_center_4                 = 0; % Coordenada x do centro da área de obstáculo
y_center_4                 = -800; % Coordenada y do centro da área de obstáculo

% Área_5
raio_5                     = 150; % Raio da área de obstáculo
x_center_5                 = -600; % Coordenada x do centro da área de obstáculo
y_center_5                 = -100; % Coordenada y do centro da área de obstáculo

% clustering = false;
% back_off = false;

% clustering = true;
% back_off = false;

% clustering = true;
% back_off = true;

% var_n_clusters = [5 7];
% 
% % Definir a pasta principal para salvar os resultados
% results_folder = 'results_clusters';
% if ~exist(results_folder, 'dir')
%     mkdir(results_folder); % Criar a pasta se não existir
% end
% 
% Pd_total = {};
% vida_sus_total = {};
% inicio_queda_total = [];
% 
% % Definir as combinações de parâmetros
% combinacoes = {
%     struct('clustering', false, 'back_off', false),  % Clássico
%     struct('clustering', true, 'back_off', false),   % Com clustering
%     struct('clustering', true, 'back_off', true)     % Algoritmo Proposto
% };
% 
% % Iniciar o temporizador
% tic;
% 
% % Loop principal para testar todas as combinações de sistemas
% for c = 1:length(combinacoes)
%     clustering = combinacoes{c}.clustering;
%     back_off = combinacoes{c}.back_off;
%     % CH_mood = combinacoes{c}.CH_mood;
% 
%     % Loop para diferentes números de sensores
%     for m = 1:length(var_n_clusters)
%         c_max = var_n_clusters(m);
% 
%         % energia_SU = energia_inicial * ones(1, m_T);
% 
%         % Criar uma pasta única para a combinação de parâmetros e valor de sensores
%         folder_name = sprintf('folderSU_cltg%d_back%d_cmax%d', clustering, back_off, c_max);
%         folder_path = fullfile(results_folder, folder_name);
% 
%         % Criar a pasta se não existir
%         if ~exist(folder_path, 'dir')
%             mkdir(folder_path);
%         end
% 
%         for i = 1:g
%             % Chamar a função mobil_system para gerar os resultados
%             [Pd_FC, Pfa_FC, SUs_vivos, ciclo, inicio_queda, ciclo_50_morte, inicio_queda_pd] = mobil_system(PU, m_T, c_max, r, xPU, yPU, xFC, energia_SU, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5, P_txPU, alpha, alpha1, P_n, n, Pfa_ref, P_s, tau_s, tau_rSU, tau_rCH, P_rxCHdBm, P_rxFCdBm, limiar_SU, max_back, start_time, clustering, back_off);
% 
%             % Armazenar os resultados da iteração i nas variáveis
%             Pd_total{i} = Pd_FC';
%             vida_sus_total{i} = SUs_vivos;
%             inicio_queda_total(i) = inicio_queda;
%         end
% 
%         % Processar e salvar os resultados para cada combinação
%         rows = cellfun(@numel, Pd_total);
%         cols = size(Pd_total, 2);
%         Pd_matriz = zeros(max(rows), cols) + NaN;
%         for k = 1:cols
%             Pd_matriz(1:rows(k), k) = Pd_total{k};
%         end
%         Pd_medio = mean(Pd_matriz, 2, "omitnan");
% 
%         % Calcular a média do início da queda
%         inicio_queda_medio = int32(mean(inicio_queda_total));
% 
%         % Processar e salvar a vida dos sensores
%         rows = cellfun(@numel, vida_sus_total);
%         cols = size(vida_sus_total, 2);
%         SUs_matriz = zeros(max(rows), cols) + NaN;
%         for k = 1:cols
%             SUs_matriz(1:rows(k), k) = vida_sus_total{k};
%         end
% 
%         SUs_vivos_medio = mean(SUs_matriz, 2, "omitnan");
% 
%         % Estimativa de tempo restante
%         tempo_decorrido = toc;  % Tempo decorrido até agora
%         iteracoes_restantes = (g - i);  % Iterações restantes
%         tempo_restante = (tempo_decorrido / i) * iteracoes_restantes;  % Estimativa do tempo restante
% 
%         % Exibir tempo restante
%         minutos = floor(tempo_restante / 60);
%         segundos = mod(tempo_restante, 60);
%         fprintf('Combinacao %d, Clusters: %d, Iteração %d de %d. Tempo restante: %d minutos e %.2f segundos.\n', ...
%                 c, c_max, i, g, minutos, segundos);
% 
%         % Salvar os resultados em arquivos .csv com sufixo único
%         file_suffix = sprintf('cltg%d_back%d_cmax%d', clustering, back_off, c_max);  % Criação do sufixo para nome do arquivo
%         writematrix(SUs_vivos_medio, fullfile(folder_path, [file_suffix '_SUs_vivos_medio.csv']));
%         writematrix(Pd_medio, fullfile(folder_path, [file_suffix '_Pd_medio.csv']));
%         writematrix(inicio_queda_medio, fullfile(folder_path, [file_suffix '_inicio_queda_medio.csv']));
%         writematrix(ciclo, fullfile(folder_path, [file_suffix '_ciclo.csv']));
% 
%     end
% end

clustering = true;
back_off = true;

Pd_total = {};
vida_sus_total = {};
inicio_queda_total = [];

for i=1:g

    [Pd_FC, Pfa_FC, SUs_vivos, ciclo, inicio_queda, ciclo_50_morte, inicio_queda_pd] = mobil_system(PU, m_T, c_max, r, xPU, yPU, xFC, energia_SU, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5, P_txPU, alpha, alpha1, P_n, n, Pfa_ref, P_s, tau_s, tau_rSU, tau_rCH, P_rxCHdBm, P_rxFCdBm, limiar_SU, max_back, clustering, back_off);

    % Armazena os resultados da iteração i nas variáveis
    Pd_total{i} = Pd_FC';
    vida_sus_total{i}=SUs_vivos;
    inicio_queda_total(i)=inicio_queda;

end

rows = cellfun(@numel,Pd_total);
cols = size(Pd_total,2);
Pd_matriz = zeros(max(rows),cols)+NaN;
for k = 1:cols
    Pd_matriz(1:rows(k),k) = Pd_total{k};
end

Pd_medio = mean(Pd_matriz, 2, "omitnan");

%%%%%%%%%%%%%

inicio_queda_medio=int32(mean(inicio_queda_total));

%%%%%%%%%%%%%

rows = cellfun(@numel,vida_sus_total);
cols = size(vida_sus_total,2);
SUs_matriz = zeros(max(rows),cols)+NaN;
for k = 1:cols
    SUs_matriz(1:rows(k),k) = vida_sus_total{k};
end

SUs_vivos_medio = mean(SUs_matriz, 2, "omitnan");

% Plotagem das métricas de desempenho (Pd e Pfa)
figure(3);
plot(1:ciclo, Pd_medio(1:ciclo)', 'LineWidth', 2); % Plota a probabilidade de detecção (Pd) ao longo dos ciclos de sensoriamento
hold on; % Mantém o gráfico atual para adicionar mais elementos
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'LineWidth', 1);
set(findall(gcf, 'type', 'text'), 'FontName', 'Times New Roman', 'FontSize', 10);
plot(1:ciclo, Pfa_FC, 'LineWidth', 2); % Plota a probabilidade de falso alarme (Pfa) ao longo dos ciclos de sensoriamento

xline(ciclo, '--', 'LineWidth', 2, 'DisplayName', 'Last cycle');
text(ciclo + 700, Pd_FC(ciclo) + 0.02, num2str(ciclo), ...
    'VerticalAlignment', 'top', 'HorizontalAlignment', 'right', 'FontSize', 12);

xlabel('Ciclo de Sensoriamento (i)'); % Adiciona rótulo ao eixo X
ylabel('Probabilidades'); % Adiciona rótulo ao eixo Y
% title('Pd & Pfa'); % Adiciona título ao gráfico
legend('\bf{P}_{d}', '\bf{P}_{fa}'); % Adiciona legenda ao gráfico
legend('show'); % Exibe a legenda
grid on; % Ativa a grade no gráfico
ylim([0, 1]);
xlim([1 7600]);

% Plotagem do número de sensores vivos ao longo dos ciclos de sensoriamento
figure(4);
plot(1:ciclo, SUs_vivos_medio(1:ciclo), 'LineWidth', 2); % Plota o número de sensores atuantes ao longo dos ciclos de sensoriamento
hold on;
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10, 'LineWidth', 1);
set(findall(gcf, 'type', 'text'), 'FontName', 'Times New Roman', 'FontSize', 10);

% Marcar o início da queda com um ponto verde
plot(inicio_queda_medio, SUs_vivos_medio(inicio_queda_medio), 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'r');
xline(inicio_queda_medio, '--r', 'LineWidth', 2);
text(inicio_queda_medio, SUs_vivos_medio(inicio_queda_medio), [' Inicio da queda = ' num2str(inicio_queda_medio) ''], 'Color', 'r');

% Marcar o ciclo onde 50% dos SUs estão mortos com um ponto vermelho
plot(ciclo_50_morte, SUs_vivos(ciclo_50_morte), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
text(ciclo_50_morte, SUs_vivos(ciclo_50_morte), [' Morte 50% dos SUs = ' num2str(ciclo_50_morte) ''], 'Color', 'k');

xlabel('Ciclo de Sensoriamento (i)'); % Adiciona rótulo ao eixo X
ylabel('Número de SUs ativos'); % Adiciona rótulo ao eixo Y
% title('Número de Sensores Vivos por Ciclo de Sensoriamento'); % Adiciona título ao gráfico
grid on; % Ativa a grade no gráfico
hold off; % Libera o gráfico atual
xlim([1 200+ciclo]);

%% Guardar resultados em ficheiros
% %%%%%%%%%%%%%%%%%%%% Sistema sem clustering (classic)
% filename = sprintf('sus_vivos_base_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(SUs_vivos_medio, filename)
% 
% filename = sprintf('Pd_base_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(Pd_medio, filename)
% 
% filename = sprintf('Pfa_base_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(Pfa_FC, filename)
% 
% filename = sprintf('inicio_queda_base_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(inicio_queda, filename)
% 
% filename = sprintf('ciclo_50_morte_base_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(ciclo_50_morte, filename)
% 
% filename = sprintf('ciclo_base_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(ciclo, filename)

% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Com clustering
% filename = sprintf('sus_vivos_clusteringSU_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(SUs_vivos_medio, filename)
% 
% filename = sprintf('Pd_clusteringSU_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(Pd_medio, filename)
% 
% filename = sprintf('Pfa_clusteringSU_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(Pfa_FC, filename)
% 
% filename = sprintf('inicio_queda_clusteringSU_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(inicio_queda, filename)
% 
% filename = sprintf('ciclo_50_morte_clusteringSU_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(ciclo_50_morte, filename)
% 
% filename = sprintf('ciclo_clusteringSU_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(ciclo, filename)

% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Com clustering, com backcoff
% filename = sprintf('sus_vivos_backoff_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(SUs_vivos_medio, filename)
% 
% filename = sprintf('Pd_backoff_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(Pd_medio, filename)
% 
% filename = sprintf('Pfa_backoff_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(Pfa_FC, filename)

% filename = sprintf('inicio_queda_backoff_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(inicio_queda_medio, filename)

% filename = sprintf('ciclo_50_morte_backoff_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(ciclo_50_morte, filename)
% 
% filename = sprintf('ciclo_backoff_clst_%s_bo_%s_SUs_%s.csv', string(clustering), string(back_off), string(m_T));
% writematrix(ciclo, filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Criar strings formatadas para os nomes dos arquivos, incluindo o valor de max_back
% filename = sprintf('sus_vivos_base_clst_bo_%d_CH_SUs_%s.csv', max_back);
% writematrix(SUs_vivos_medio, filename);
% 
% filename = sprintf('Pd_base_clst_bo_%d_CH.csv', max_back);
% writematrix(Pd_medio, filename);
% 
% filename = sprintf('Pfa_base_clst_bo_%d_CH.csv', max_back);
% writematrix(Pfa_FC, filename);
% 
% filename = sprintf('inicio_queda_base_clst_bo_%d_CH.csv', max_back);
% writematrix(inicio_queda_medio, filename);
% 
% filename = sprintf('ciclo_50_morte_base_clst_bo_%d_CH.csv', max_back);
% writematrix(ciclo_50_morte, filename);
% 
% filename = sprintf('ciclo_base_clst_bo_%d_CH.csv', max_back);
% writematrix(ciclo, filename);