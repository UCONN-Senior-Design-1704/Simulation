function data = demodulator(received,Fc,Tb,samples_per_bit)

received = received/max(received); % for testing purposes only
received = received + 0.1 * randi([-10 10], 1, 1000);

iteration_factor = 1; % How often to apply correlator
threshold = 10; % Noise threshold

ref = cos(linspace(0,2*pi*Fc*Tb,samples_per_bit)); % Used for correlator
correlatorOutput = zeros(1,(length(received)-samples_per_bit)/iteration_factor);

periods_per_bit = Fc*Tb;

mode = 0; % (0: searching for signal, 1: decoding received signal)

    for index = 1:iteration_factor:length(received)-samples_per_bit
        correlatorOutput((index+1)/iteration_factor) = sum(ref*received(index:index+samples_per_bit-1)');
    end
%   data = correlatorOutput;
    figure();
    subplot(3,1,1);
    plot(received);
    subplot(3,1,2);
    plot(ref);
    subplot(3,1,3);
    plot(correlatorOutput);
    
    %Synchronization
    sample_period = samples_per_bit/periods_per_bit;
    mode = 0; %detection (0) or processing (1) mode
    basis = cos(linspace(0,2*pi,sample_period)); % single period
    
    time = 0;
    while(mode == 0) % Signal detection state (needs revision)
        time = time + 1;
        if sum(basis .* received(time:time+sample_period-1)) > threshold
            mode = 1;
            t0 = time - ceil(sample_period/4); %t0 indicates start of sin period
        elseif sum(basis .* received(time:time+sample_period-1)) < -1*threshold
            mode = 1;
            t0 = time + ceil(sample_period/4);
        end
    end
    
    time
    
    index = 1;
    while(mode == 1) %processing state
       try
           % Phase synchronization
           sample1 = correlatorOutput(t0 + 2);
           sample2 = correlatorOutput(t0 - 2);
           
           if (sample1 + sample2 > 0) 
               t0 = t0 - 1; %ahead of phase
               time = time - 1;
           elseif (sample1 + sample2 < 0)
               t0 = t0 + 1; %behind phase
               time = time + 1;
           end %else in phase
           
           % symbol synchronization
           sample0 = correlatorOutput(time);
           sample1 = correlatorOutput(time+ceil(sample_period));
           sample2 = correlatorOutput(time-floor(sample_period));
           nextSample0 = correlatorOutput(min(time+samples_per_bit,length(received)));
           prevSample0 = correlatorOutput(max(time-samples_per_bit,1));
           
           if ((abs(sample0) < abs(sample1)) && sample0*nextSample0 < 1) % only valid on bit change
               time = time + ceil(sample_period); %symbol synchronization slow by at least 1 period
           elseif ((abs(sample0) < abs(sample2)) && sample0*prevSample0 < 1) % only valid on bit change
               time = time - floor(sample_period); %symbol synchronization fast by at least 1 period
           end
           
           % symbol evaluation
           data(index) = correlatorOutput(time); % This corresponds to the symbol value
           index = index + 1;
           time = time + samples_per_bit;
       catch
           time %display final synchronized time
           return;
       end
    end
end