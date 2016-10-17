clc
clear
rng('shuffle')
TB=input('Bit Duration(s):');
FC=input('Carrier Frequency (Hz). NOTE: FC must be a multiple of (1/(Bit Duration)):');
i=1;
while i==1
    IdealRatioFCTB=round(FC*TB);
    ActualRatioFCTB=FC*TB;
    if IdealRatioFCTB ~= ActualRatioFCTB
        TB=input('Bit Duration(s):');
        FC=input('ERROR! Carrier Frequency (Hz). NOTE: FC must be a multiple of (1/TB):');
    else
        i=i+1;
    end
end
EB=input('Energy Per Bit (Joules):');
SamplesPerBit=input('Samples Per Bit:');
MessageLength=input('Message Length (bits):');
j=1;
while j==1
    IdealMessageLength=round(MessageLength);
    if IdealMessageLength ~= MessageLength
        MessageLength=input('ERROR: Message Length must be whole number! Message Length (bits):');
    else
        j=j+1;
    end
end
StDev=input('Standard Deviation of AWGN noise:');
Message=round(rand(1,MessageLength));
OutBPSK=Array2BPSK(Message,FC,TB,EB,SamplesPerBit);
NoisyBPSK=AddNoise(OutBPSK, StDev);
ReceivedMessage=BPSK2Array(NoisyBPSK,FC,TB,SamplesPerBit);
[Error SNR]=ErrorRate(Message,ReceivedMessage, StDev, EB, TB);
if MessageLength >=5
    GraphSize=5*SamplesPerBit;
else
    GraphSize=MessageLength*SamplesPerBit;
end
figure
subplot(1,2,1)
plot(OutBPSK(1:GraphSize))
subplot(1,2,2)
plot(NoisyBPSK(1:GraphSize))
Error
SNR