N = 63;  % Codeword length
K = 51;  % Message length
S = 39;  % Shortened message length
M = 64;  % Modulation order
numErrors = 200;
numBits = 10000;%1e7
ebnoVec = (8:13)';
[ber0,ber1] = deal(zeros(size(ebnoVec)));
errorRate = comm.ErrorRate;
gp = rsgenpoly(N,K,[],0);
rsEncoder = comm.RSEncoder(N,K,gp,S,'BitInput',true);
rsDecoder = comm.RSDecoder(N,K,gp,S,'BitInput',true);
rate = S/(N-(K-S));
for k = 1:length(ebnoVec)

    % Convert the coded Eb/No to an SNR. Initialize the error statistics
    % vector.
    snrdB = ebnoVec(k) + 10*log10(rate) + 10*log10(log2(M));
    errorStats = zeros(3,1);

    while errorStats(2) < numErrors && errorStats(3) < numBits

        % Generate binary data.
        txData = randi([0 1],S*log2(M),1);
        txData1=reshape(txData,1,[]);
        disp('txData')
        disp(txData1)
        % Encode the data.
        encData = rsEncoder(txData);
        encData1=reshape(encData,1,[]);
        disp('encData')
        disp(encData1)
        % Apply 64-QAM modulation.
        txSig = qammod(encData,M, ...
            'UnitAveragePower',true,'InputType','bit');
        txSig1=reshape(txSig,1,[]);
        disp('txSig-qam')
        disp(txSig1)
        % Pass the signal through an AWGN channel.
        rxSig = awgn(txSig,snrdB);
        disp('rxSig-awgn')
        disp(rxSig)
        % Demodulated the noisy signal.
        demodSig = qamdemod(rxSig,M, ...
            'UnitAveragePower',true,'OutputType','bit');
        demodSig1=reshape(demodSig,1,[]);
        disp('demodSig')
        disp(demodSig1)
        % Decode the data.
        rxData = rsDecoder(demodSig);
        rxData1=reshape(rxData,1,[]);
        disp('rxData-decoded')
        disp(rxData1)
        % Compute the error statistics.
        errorStats = errorRate(txData,rxData);
        chk2 = isequal(txData,rxData);
        disp chk2
        disp(chk2)
    end

    % Save the BER data, and reset the errorRate counter.
    ber1(k) = errorStats(1);
    reset(errorRate)
end
berapprox = bercoding(ebnoVec,'RS','hard',N,K,'qam',64);
semilogy(ebnoVec,ber1,'c^-',ebnoVec,berapprox,'k--')
legend('RS(63,51)','RS(51,39)','Theory')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
grid
