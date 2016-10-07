function [OutBPSK] = Array2BPSK(InArray, FC, TB, EB, SamplesPerBit)
% IMPORTANT NOTE: FC must be a multiple of (1/TB)!
% InArray is the message in binary to be sent
% FC is the Carrier Frequency at which the message is to be sent in Hertz
% TB is the duration of a single bit in seconds
% EB is the energy of a single bit in Joules
% SamplesPerBit is the number of values to be used to describe one bit
TotalDuration=linspace(0,TB*length(InArray),SamplesPerBit*length(InArray));
% TotalDuration is the total number of seconds necessary to transmit the
% message given the number of bits and the bit length
coef=sqrt(2/TB);
% defines the coefficient for the cosine function
x=coef*sqrt(EB)*cos(2*pi*FC*TotalDuration);
% forms the basis function, to be multiplied later by 1 or -1
PrepArray=2*InArray-1;
% transforms binary 0 into -1, while maintaining binary 1 as 1
for i=1:length(PrepArray)
    % for each bit in the original message
    for j=1:SamplesPerBit
        % for each sample representing a part of this bit
        Sample=(i-1)*SamplesPerBit + j;
        % defines which specific sample to be worked with
        OutBPSK(Sample)=x(Sample)*PrepArray(i);
        % performs the actual multiplication of the basis function with -1
        % or 1, appropriately
    end
end
end