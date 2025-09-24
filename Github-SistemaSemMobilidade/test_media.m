
m=5;
Pd_iter=[];
for i=1:m
    c = 0;  % Começa do ciclo 1
    
    % Inicializa a matriz para armazenar as probabilidades de detecção para cada ciclo
    Pd_FC = [];
    
    % Coleta das métricas para cada ciclo
    while c < 10
        c = c + 1;  % Incrementa o contador de ciclos
        Pd_FC(c) = rand();  % Aqui deve vir o cálculo de Pd_FC para o ciclo c
        
    end
    
    Pd_iter(i, :)=Pd_FC;

end

% Pd_med = mean(Pd_iter, 2);

disp(Pd_iter)


% % Plot
% figure;
% plot(1:c, Pd_FC, 'LineWidth', 2);  % Plota a probabilidade de detecção (Pd_FC) ao longo dos ciclos
% xlabel('Ciclo de Sensing');
% ylabel('Probabilidade de Detecção');
% grid on;
