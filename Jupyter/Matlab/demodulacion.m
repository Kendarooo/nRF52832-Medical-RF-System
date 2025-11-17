%% DEMODULACIÓN GFSK (DIF BLE) SOLO CON LA SALIDA DEL CANAL

% 1) Cargar señal recibida desde el canal
rx_file = './csv/gfsk_rx_awgn_6dB_seed58.csv';
rx = readmatrix(rx_file);
rx = rx(:);   % columna

% 2) Parámetros (los mismos que en el TX)
bits_per_second    = 1e3;      
samples_per_bit    = 100;      
sampling_frequency = bits_per_second * samples_per_bit;
carrier_frequency  = 2e3;      

% 3) Señal analítica y fase
z   = hilbert(rx);                % señal analítica (I + jQ)
phi = unwrap(angle(z));           % fase instantánea [rad]

% 4) Frecuencia instantánea
inst_freq = [0; diff(phi)] * sampling_frequency / (2*pi);  % [Hz]

% 5) Promedio por bit
n_bits_rx = floor(length(inst_freq) / samples_per_bit);
inst_freq = inst_freq(1 : n_bits_rx * samples_per_bit);
inst_freq_mat = reshape(inst_freq, samples_per_bit, n_bits_rx);
freq_por_bit  = mean(inst_freq_mat, 1);

% 6) Decisión de bit (demodulación)
bits_rec = freq_por_bit > carrier_frequency;   % vector lógico 0/1
bits_hat = bits_rec(:);                        % nombre "oficial" para exportar

%% (Opcional) ver los primeros bits demodulados
num_bits_plot = 20;
nbp = min(num_bits_plot, numel(bits_hat));

figure('Name','Demodulación GFSK','Position',[100 100 900 400]);
subplot(2,1,1);
plot(freq_por_bit(1:nbp),'o-','LineWidth',1.5); grid on;
yline(carrier_frequency,'r--','f_c');
xlabel('Índice de bit'); ylabel('Frecuencia media [Hz]');
title('Frecuencia media por bit');

subplot(2,1,2);
stem(bits_hat(1:nbp),'filled'); grid on;
xlabel('Índice de bit'); ylabel('Bit');
title('Bits demodulados');

%% 7) Exportar bits demodulados a CSV
demod_folder = './csv';
if ~exist(demod_folder, 'dir')
    mkdir(demod_folder);
end

demod_file = fullfile(demod_folder, 'gfsk_bits_demod.csv');
writematrix(bits_hat, demod_file);

bits_csv = double(bits_hat(:));
% 2) Guardar en TXT (un bit por línea, separado por espacio si hubiera más columnas)
demod_file_txt = fullfile(demod_folder, 'gfsk_bits_demod.txt');
writematrix(bits_csv, demod_file_txt, 'Delimiter', ' ');

fprintf('[Export] Archivos guardados en %s  (N_bits = %d)\n', ...
        demod_folder, numel(bits_csv));