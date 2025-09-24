function [SUs_vivos, Pd_FC, Pfa_FC, ciclo, inicio_queda, ciclo_50_morte] = fixoSys(PU, m_T, c_max, r, xPU, yPU, xFC, P_txPU, alpha, alpha1, P_n, P_rxCHdBm, P_rxFCdBm, n, Pfa_ref, P_s, tau_s, tau_rSU, tau_rCH, energia_SU, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5, limiar_SU, back_off, clustering, CH_mood, max_back, cycle_CH, start_time)

    [coords] = gerarXY(xPU,yPU, xFC, r, m_T, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5);

    [CH, idx] = k_means(coords, c_max, xPU, yPU, xFC, r, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5);

    [d_PU, d_CH, d_FC, d_BS] = calcular_distancia(m_T, c_max, xPU, yPU, xFC, coords, idx, CH);
    
    [P_rxSU] = calcular_prx(m_T, d_PU, P_txPU, alpha, alpha1, coords, raio_1, x_center_1, y_center_1, raio_2, x_center_2, y_center_2, raio_3, x_center_3, y_center_3, raio_4, x_center_4, y_center_4, raio_5, x_center_5, y_center_5);
    
    [limiar_sistema] = limiar_decisao(P_n, n, Pfa_ref);

    global ativar_clustering
    global ativar_backoff        % Bandera que habilita e desabilita a inatividade dos SUs
    global ativar_CH

    ativar_clustering = clustering;
    ativar_backoff = back_off;
    ativar_CH = CH_mood;
    
    
    ciclo                        = 0; % Contador que conta o número de ciclos de sensoriamento do sistema
    count_back                   = zeros(1, m_T); % Conta o número de backoff consecutivos de cada SU
    backoff                      = zeros(1, m_T); % Vetor que determina o tempo de inatividade do SU
    sensor_off                   = zeros(1, m_T);  % Inicializa vetor de sensores desativados
    n_frac_SU                    = zeros(m_T, 1); % Conta o número de fracasso durante todo ciclo, para visualização
    SUs_vivos                    = zeros(ciclo, 1); % Conta o número de SUs vivos por ciclo de sensoriamento, para visulização
    
    % Inicializa vetores para Pd e Pfa
    GlobalDecision_FC            = []; % Decisão global do sistema c
    TX                           = []; % Estado do transmissor primário (0 inativo - 1 ativo)
    Pd_FC                        = []; % Probabilidade de detecção do sistema por ciclo de sensoriamento
    Pfa_FC                       = []; % Probabilidade de falso alarme do sistema por ciclo de sensoriamento 

    %% Rodada de sensoriamento
    while true
        ciclo = ciclo + 1;
        TX(ciclo) = randi([0, 1]);
        f = zeros(1, m_T);
   
        H = sqrt(1/2)*complex(randn(m_T, PU), randn(m_T, PU));
        X = sqrt(1/PU)*complex(randn(PU, n), randn(PU, n));
        V = sqrt(P_n/2)*complex(randn(m_T, n), randn(m_T, n));
        Y = zeros(m_T, n);  % Alocação do sinal recebido em cada SU
        for j = 1:m_T
            Y(j,:) = TX(ciclo) * sqrt(P_rxSU(j) / 2) * (H(j, :) * X) + V(j, :);  % Sinal recebido por cada SU
        end

        % Estatística de teste do detector de energia
        T_ed = (1/n) * sum(abs(Y).^2, 2);
        
        % Vetor que armazena as decisões locais dos SUs
        LD = T_ed > limiar_sistema; 

        if ativar_clustering
            decisoes_ativas = cell(c_max, 1);  % Inicializa a célula de decisões ativas
            for j = 1:m_T  % Loop para cada sensor 
                if sensor_off(j) == 0 && backoff(j) == 0 % SU morto por falta de energia ou inabilitado por um tempo de espera
                    grupo = idx(j);  % Determina o grupo do sensor
                    decisoes_ativas{grupo} = [decisoes_ativas{grupo}, LD(j)];  % Armazena a decisão no grupo correspondente
                    energia_SU(j) = energia_SU(j) - P_s*tau_s; % Energia consumida no SS
                end
            end
            decisoes_cluster = cell(c_max, 1);
            for cluster_idx = 1:c_max
                decisoes_ativa = decisoes_ativas{cluster_idx};
                sensor_ativo_cluster = length(decisoes_ativa);
                decisoes_cluster{cluster_idx} = sum(decisoes_ativa) >= floor(sensor_ativo_cluster / 2 + 1);
            end
            % Energia consumida no reporte SU --> CH
            for j = 1:m_T
                if d_CH(j) ~= 0 && sensor_off(j) == 0 && backoff(j) == 0
                    energia_SU(j) = energia_SU(j) - ((0.001 * 10^(P_rxCHdBm / 10)) * d_CH(j)^alpha)*tau_rSU;
                end
            end
            % Energia consumida no reporte CH --> FC
            x = coords(1, :);  % Coordenadas X dos SUs
            y = coords(2, :);  % Coordenadas Y dos SUs
            for c = 1:c_max
                ch_index = find(x == CH(1, c) & y == CH(2, c));
                energia_SU(ch_index) = energia_SU(ch_index) - ((0.001 * 10^(P_rxFCdBm / 10)) * d_FC(c)^alpha) * tau_rCH;
            end

            % Decisão global do sistema
            GlobalDecision_FC(ciclo) = sum(cell2mat(decisoes_cluster)) >= floor(c_max / 2 + 1);

            m_ativos = 0;
            for j = 1:m_T
                 % Conta o sensor como ativo se ele não estiver desativado
                if sensor_off(j) == 0
                    m_ativos = m_ativos + 1;
                end
            end
            % Armazena o número de sensores vivos no ciclo atual
            SUs_vivos(ciclo) = m_ativos;

            % Função que verifica a energia restante nos SUs
            [sensor_off] = desabilitar_SU(c_max, x, y, CH, idx, energia_SU, limiar_SU, sensor_off);

            % for j = 1:m_T
            %     if energia_SU(j) < limiar_SU
            %         sensor_off(j) = 1;
            %     end
            % end

        else
            
            LD1 = []; % Inicializa vetor de decisões locais para sensores ativos
            for j = 1:m_T
                if sensor_off(j) == 0 % Verifica se o sensor está ativo
                     LD1 = [LD1, LD(j)]; % % Adiciona a decisão local do sensor ativo a LD1
                    % Atualiza a carga do SU considerando o consumo de energia para sensoriamento e reporte
                    energia_SU(j) = energia_SU(j) - (P_s*tau_s + ((0.001 * 10^(P_rxFCdBm / 10)) * d_BS(j)^alpha) * tau_rCH);
                end
            end
            % Calcula o número de SUs ativos
            ativos_count = length(LD1);

            % Decisão global do sistema
            GlobalDecision_FC(ciclo) = sum(LD1) >= floor(ativos_count / 2 + 1);

            m_ativos = 0;
            for j = 1:m_T
                 % Conta o sensor como ativo se ele não estiver desativado
                if sensor_off(j) == 0
                    m_ativos = m_ativos + 1;
                end
            end
            % Armazena o número de sensores vivos no ciclo atual
            SUs_vivos(ciclo) = m_ativos;

            for j = 1:m_T
                if energia_SU(j) < limiar_SU
                    sensor_off(j) = 1;
                end
            end
 
        end

        
        if ativar_CH
            % Verifica se estamos em um ciclo múltiplo de 1000 antes de chamar a função
            if mod(ciclo, cycle_CH) == 0 
               x = coords(1, :);  % Coordenadas X dos SUs
               y = coords(2, :);  % Coordenadas Y dos SUs
               [CH, d_CH, d_FC] = selecao_CH(CH, c_max, idx, x, y, d_CH, d_FC, xFC, energia_SU, sensor_off);
               cycle_CH = cycle_CH + 1000; % Atualiza para o próximo ciclo de troca do CH
            end
        end

        if ativar_backoff

            % Atualizar backoff e fracassos
            for j = 1:m_T
                if backoff(j) == 0 && sensor_off(j) == 0
                    % Lógica baseada na tabela GD, TX e LD
                    if GlobalDecision_FC(ciclo) == 0 && TX(ciclo) == 0 && LD(j) == 1
                        % SGFL-C (GD=0, TX=0, LD=1)
                        f(j) = 2;
                        n_frac_SU(j) = n_frac_SU(j) + 1;
                    elseif GlobalDecision_FC(ciclo) == 0 && TX(ciclo) == 1 && LD(j) == 0
                        % FGL-C (GD=0, TX=1, LD=0)
                        f(j) = 2;
                        n_frac_SU(j) = n_frac_SU(j) + 1;
                    elseif GlobalDecision_FC(ciclo) == 1 && TX(ciclo) == 1 && LD(j) == 0
                        % SGFL-NC (GD=1, TX=1, LD=0)
                        f(j) = 1;
                        n_frac_SU(j) = n_frac_SU(j) + 1;
                    end
                end
            end

            % Atualizar backoff e verificar desabilitação
            for j = 1:m_T
                if sensor_off(j) == 0
                    if f(j) ~= 0 && backoff(j) == 0
                        backoff(j) = (2^f(j) - 1);  % Calcula o tempo de espera
                        count_back(j) = count_back(j) + 1;
                    elseif backoff(j) == 0
                        count_back(j) = 0;  % Reinicia o contador de backoffs consecutivos
                    elseif backoff(j) > 0
                        backoff(j) = backoff(j) - 1;  % Decrementa o backoff
                    end
                end
            end

        end

        % % Desabilitar sensores com backoffs consecutivos
        for j = 1:m_T  
            if count_back(j) == max_back
                sensor_off(j) = 1;  % Marca o sensor como desabilitado
                % disp(['Sensor ', num2str(j), ' desabilitado por 5 backoffs consecutivos.']);
            end
        end

        % Encontrar o índice onde começa a queda (primeira redução no número de SUs vivos)
        inicio_queda = find(diff(SUs_vivos) < 0, 1) + 1;

        
    
        % Encontrar o ciclo onde 50% dos SUs estão mortos
        limite_50_morte = m_T / 2;
        ciclo_50_morte = find(SUs_vivos <= limite_50_morte, 1);
    
        % Calcula as métricas de desempenho com base nas decisões acumuladas até a iteração atual
        Pd_FC(ciclo) = sum(GlobalDecision_FC(1:ciclo) & TX(1:ciclo) == 1) / sum(TX(1:ciclo) == 1);
        Pfa_FC(ciclo) = sum(GlobalDecision_FC(1:ciclo) & TX(1:ciclo) == 0) / sum(TX(1:ciclo) == 0);
    
        CH_existe = false;  % Variável para verificar se existe algum CH com energia suficient
        if ativar_clustering
            for c = 1:c_max
                % Encontra o índice do CH no vetor de sensores
                CH_index = find(x == CH(1, c) & y == CH(2, c), 1);  % Retorna o primeiro índice
                if isempty(CH_index)
                    error('CH_index não encontrado. Verifique os valores de x, y e CH.');
                end

                % Verifica se a energia do CH é maior ou igual ao limiar
                if energia_SU(CH_index) >= limiar_SU
                    CH_existe = true;  % Ainda existe CH com energia suficiente
                    break;  % Não precisa verificar os demais CHs
                end
            end
            % Se nenhum CH tiver energia suficiente, a simulação para
            if ~CH_existe
                SUs_vivos(ciclo) = 0; 
                break;
            end   
        else
            % Verifica se todos os sensores estão desligados
            if all(sensor_off == 1)
                SUs_vivos(ciclo) = 0;
                break;
            end
        end

        % % Verifica se todos os sensores estão desligados
        % if all(sensor_off == 1)
        %     SUs_vivos(ciclo) = 0;
        %     break;
        % end

    end % while

end % function