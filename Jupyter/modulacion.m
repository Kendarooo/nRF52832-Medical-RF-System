clc; clear; close all;

tic;  % comienza a medir el tiempo de ejecución

%% parámetros principales
bits_per_second     = 1e3;     % 1 kbit/s (1 ms por bit)
samples_per_bit     = 100;     % 100 muestras por bit, resolución temporal
sampling_frequency  = bits_per_second * samples_per_bit; % = 100 kHz
carrier_frequency   = 2e3;     % 2 kHz, frecuencia de la portadora
frequency_deviation = 2e3/2;   % Δf = 1 kHz

%% lectura de datos binarios
if exist('./bits_codificados_h1511.txt','file')
    bit_stream = load('./bits_codificados_h1511.txt');
elseif exist('./bits_codificados_h74.txt','file')
    bit_stream = load('./bits_codificados_h74.txt');
else
    error('No se encontraron archivos de bits: h1511 o h74. Exporta desde Python primero.');
end

%% normalización de forma y niveles 
bit_stream = bit_stream(:) ~= 0;        % columna 0/1 lógico
nrz_signal = 2*double(bit_stream) - 1;  % ±1 formato NRZ

%% upsampling (retención por repetición) 
nrz_upsampled = repelem(nrz_signal, samples_per_bit); % genera señal digital de mayor resolución

%% modulación FSK (fase continua)
instantaneous_frequency = carrier_frequency + frequency_deviation * nrz_upsampled;   %  frecuencia inst. de la portadora
instantaneous_phase     = 2*pi*cumsum(instantaneous_frequency) / sampling_frequency; % integra la frec inst para obtener la fase acumulada en el tiempo
fsk_signal              = cos(instantaneous_phase); %genera la FSK signal

%  GFSK BLE 
BT = 0.5;                   % producto BT del filtro gaussiano (BLE)

h  = 2*frequency_deviation / bits_per_second; %índice de modulación a partir de Δf y Rb (h = 2Δf/Rb)

Tb = 1/bits_per_second;% periodo de bit
% sigma del filtro en "muestras" (discreto) controla cuánto se suaviza
sigma_s = (Tb*sqrt(log(2)) / (2*pi*BT)) * sampling_frequency;  
Lh = ceil(3*sigma_s);
n  = (-Lh:Lh).';  % eje discreto del kernel
g  = exp(-(n.^2)/(2*sigma_s^2));
g  = g / sum(g);            % normalizar a área unitaria

m_filt = conv(nrz_upsampled, g, 'same');                  % suavizado gaussiano (baseband)
dphi   = pi*h * m_filt / samples_per_bit;                 % incremento de fase por muestra
phi_gfsk = cumsum(dphi);                                   % fase continua CPFSK filtrada

% asegurar vector columna y construir portadora a la misma Fs/tamaño
phi_gfsk = phi_gfsk(:);
phi_car  = 2*pi*carrier_frequency * ((0:numel(phi_gfsk)-1).') / sampling_frequency;
% GFSK en pasobanda 
gfsk_signal = cos(phi_car + phi_gfsk);                    


%% selecciona cuántos bits mostrar 
num_bits_to_plot = 10;                    % decisión de cuantos bits utilizar 
Ns = num_bits_to_plot * samples_per_bit;   % cuantas muestras corresponden según n bits
Ns = min([Ns, numel(fsk_signal), numel(gfsk_signal), numel(nrz_upsampled)]);
t  = (0:Ns-1) / sampling_frequency;        % vector t para graficar

figure('Name','FSK vs GFSK visible','Position',[80 80 900 800]);

% Señal NRZ (arriba)
subplot(3,1,1);
stairs(t, (nrz_upsampled(1:Ns)+1)/2, 'LineWidth',1.4); grid on;
ylim([-0.2 1.2]); 
xlabel('Time [s]'); ylabel('V');
title('Señal NRZ');
for k = 1:num_bits_to_plot-1
    x = k/bits_per_second;
    if x <= t(end), xline(x,'k:'); end
end

% Señal FSK (medio)
subplot(3,1,2);
plot(t, fsk_signal(1:Ns), 'LineWidth',1.2); grid on;
xlabel('Time [s]'); ylabel('V');
title('Señal FSK (CPFSK)');
for k = 1:num_bits_to_plot-1
    x = k/bits_per_second;
    if x <= t(end), xline(x,'k:'); end
end

% Señal GFSK (abajo)
subplot(3,1,3);
plot(t, gfsk_signal(1:Ns), 'LineWidth',1.2); grid on;
xlabel('Time [s]'); ylabel('V');
title(sprintf('Señal GFSK', BT, h));
for k = 1:num_bits_to_plot-1
    x = k/bits_per_second;
    if x <= t(end), xline(x,'k:'); end
end

sgtitle('Comparación: NRZ, FSK y GFSK (BLE)','FontWeight','bold');

elapsed_time = toc;  % finaliza el temporizador
fprintf('\nTiempo total de ejecución: %.6f segundos\n', elapsed_time);

output_folder = './Figuras';              % carpeta donde se guardará
if ~exist(output_folder, 'dir')
    mkdir(output_folder);                    
end

file_name = fullfile(output_folder, 'Modulacion_FSK_GFSK.png');  
saveas(gcf, file_name);

