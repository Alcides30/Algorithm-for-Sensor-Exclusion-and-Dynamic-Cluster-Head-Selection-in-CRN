function [limiar_sistema] = limiar_decisao(P_n, n, Pfa_ref)

    nEventos = 10000;  % Número de eventos Monte Carlo
    T_H0 = zeros(nEventos, 1); % Inicializa um vetor para armazenar as estatísticas de teste
    
    % Loop Monte Carlo
    for i = 1:nEventos
        % Geração de ruído AWGN (ruído branco aditivo gaussiano)
        V = sqrt(P_n/2) * complex(randn(1, n), randn(1, n)); % Gera ruído AWGN com potência P_n
        % Cálculo da estatística de teste do detector de energia
        T_H0(i) = (1/n) * sum(abs(V).^2);  % Calcula a média da potência do sinal recebido, que na ausência de sinal transmitido o sinal recebido é apenas o ruído (sob H0)
    end
    
    % % Plotagem da PDF (função densidade de probabilidade) empírica
    % figure(3)
    % hold on;

    % % Configuração do tamanho e tipo de fonte para os eixos
    % set(gca, 'FontSize', 10, 'FontName', 'Times New Roman');
    % 
    % % Configuração do tipo de fonte para todos os textos no gráfico
    % set(findall(gcf, 'Type', 'text'), 'FontSize', 10, 'FontName', 'Times New Roman');
    % 
    % % Plotagem do histograma
    % histogram(T_H0, 'Normalization', 'pdf');
    % 
    % % Adicionando rótulos aos eixos
    % xlabel('Estatística de Teste', 'FontName', 'Times New Roman');
    % ylabel('Densidade de Probabilidade', 'FontName', 'Times New Roman');
    % 
    % % Determinação do limiar_sistema (percentil 90 para Pfa = 0.1)
    limiar_sistema = prctile(T_H0, (1 - Pfa_ref) * 100); % Calcula o percentil 90 das estatísticas de teste, que corresponde a uma Pfa de 0.1
    % disp(['limiar_sistema (Pfa = 0.1): ', num2str(limiar_sistema)]);
    % 
    % % Linha vertical no gráfico
    % line([limiar_sistema limiar_sistema], ylim, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
    % 
    % % Texto para indicar o limiar
    % text(limiar_sistema, max(ylim) * 0.9, ...
    %     ['limiar (Pfa = 0.1): ', num2str(limiar_sistema)], ...
    %     'Color', 'r', 'HorizontalAlignment', 'left', ...
    %     'FontName', 'Times New Roman');
    % 
    % hold off;

    

end