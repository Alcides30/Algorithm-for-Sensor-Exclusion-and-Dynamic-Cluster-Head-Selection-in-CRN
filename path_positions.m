function [speed, P_move, destinations, paths] = path_positions(m_T, positions, r)
    speed = 5 * rand(m_T, 1); % Velocidade aleatória para cada sensor
    P_move = 0.7; % Probabilidade de movimento para cada sensor

    % Gerar destinos iniciais dentro do círculo
    p_dest = sqrt(rand(1, m_T)); % Distribuição radial para destinos
    theta_dest = 2 * pi * rand(1, m_T); % Ângulo aleatório para destinos
    x_dest = p_dest .* cos(theta_dest) * r; % Coordenada x do destino
    y_dest = p_dest .* sin(theta_dest) * r; % Coordenada y do destino
    destinations = [x_dest' y_dest']; % Matriz de destinos (N x 2)

    % Inicializar caminhos com as posições iniciais
    paths = cell(m_T, 1); % Armazena os caminhos dos sensores
    for i = 1:m_T
        paths{i} = positions(i, :); % Cada caminho começa na posição inicial
    end
end
