function data = demodulator(received,Fc,Tb,samples_per_bit)

iteration_factor = 2; % Skip every other bit when applying correlator
threshold = 1; % Noise threshold

ref = cos(linspace(0,2*pi*Fc*Tb,samples_per_bit)); % Used for correlator
correlatorOutput = zeros(1,(length(received)-samples_per_bit)/iteration_factor);

state = 0; % (0: searching for signal, 1: decoding received signal)

    for index = 1:iteration_factor:length(received)-samples_per_bit
        correlatorOutput((index+1)/2) = sum(ref*received(index:index+samples_per_bit-1)');
    end
    data = correlatorOutput;
    figure();
    subplot(3,1,1);
    plot(received);
    subplot(3,1,2);
    plot(ref);
    subplot(3,1,3);
    plot(correlatorOutput);
end