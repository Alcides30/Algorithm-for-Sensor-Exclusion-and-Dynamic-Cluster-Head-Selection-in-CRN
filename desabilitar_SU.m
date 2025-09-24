function [sensor_off] = desabilitar_SU(c_max, x, y, CH, idx, energia_SU, limiar_SU, sensor_off)
    
    for c = 1:c_max
    % Encontra o índice do CH no vetor de SUs
    CH_index = find(x == CH(1, c) & y == CH(2, c));  
    SU_grupo = find(idx == c);  % SUs pertencentes ao cluster CH 'c'
    
        if ~isempty(CH_index)
            
            % Verifica se a energia do CH é menor que o limiar
            if energia_SU(CH_index) < limiar_SU
                % Desativa todos os SUs do cluster (incluindo o próprio CH)
                for j = SU_grupo'
                    sensor_off(j) = 1;  % Desativa SU
                end
            else
                % Verifica a energia de cada SU do cluster (c)
                for j = 1:length(SU_grupo)
                    SU_idx = SU_grupo(j);  % Índice do sensor SU no grupo
    
                    if SU_idx ~= CH_index
                        % Verifica se o SU tem energia abaixo do limiar (não é o CH)
                        if energia_SU(SU_idx) <  limiar_SU 
                            sensor_off(SU_idx) = 1;  % Desativa o SU
                        end
                    end
                 end
            end
        end
    end




end