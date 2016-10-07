function [OutArray] = BPSK2Array(BPSK,FC,TB,SamplesPerBit)
% IMPORTANT NOTE: FC must be a multiple of (1/TB)!
% OutArray is the message in binary that has been decoded
% FC is the Carrier Frequency at which the message is to be sent in Hertz
% TB is the duration of a single bit in seconds
% SamplesPerBit is the number of values to be used to describe one bit
TotalDuration=linspace(0,length(BPSK)*TB/SamplesPerBit,length(BPSK));
% TotalDuration is the total number of seconds necessary to transmit the
coef=sqrt(2/TB);
% defines the coefficient for the cosine function
x=coef*cos(2*pi*FC*TotalDuration);
% forms the basis function
for j=1:length(BPSK)/SamplesPerBit
    %for each bit
    dot1=x(((j-1)*SamplesPerBit+1):(j*SamplesPerBit));
    %create the first vector to be a product in a dot product; contains all
    %values of the BPSK signal that correspond to the jth bit
    dot2=BPSK(((j-1)*SamplesPerBit+1):(j*SamplesPerBit));
    %create the second vector to be a product in a dot product; contains all
    %values of the BPSK signal that correspond to the jth bit    
    product=dot(dot1,dot2);
    %creates the dot product of the two vectors, to be 
    Integral=product/SamplesPerBit;
    % while not technically necessary because our decision threshold is 0,
    % this step completes the process of 'discrete integration' that is
    % being simulated.
    if Integral >= 0
        OutArray(j)=1;
        % identifies the jth bit as 1 if appropriate
    elseif Integral < 0
        OutArray(j)=0;
        % identifies the jth bit as 0 if appropriate
    else
        OutArray(j)=2;
        % If the jth bit fits into neither decision area, a problem has
        % ocurred.
    end
end