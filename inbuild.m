clc, close all;
st1 = 27221; st2 = 4831; % States for random number generator
n = 7; k = 4; % Parameters for Hamming code
msg = randi([0 1],k*500,1); % Data to encode
msg1=msg';
disp('Message')
disp(msg1)
code = encode(msg,n,k,'hamming/binary'); % Encoded data
code1=code';
disp('code')
disp(code1)
% Create a burst error that will corrupt two adjacent codewords.
errors = zeros(size(code)); errors(n-2:n+3) = [1 1 1 1 1 1];
error1=errors';
disp('errors')
disp(error1)
%chk2 = isequal(code1,error1);
% With Interleaving
%------------------
inter = randintrlv(code,st2); % Interleave.
inter_err = bitxor(inter,errors); % Include burst error.
deinter = randdeintrlv(inter_err,st2); % Deinterleave.
decoded = decode(deinter,n,k,'hamming/binary'); % Decode.
decoded1=decoded';
disp('Number of errors and error rate, with interleaving:');
[number_with,rate_with] = biterr(msg,decoded); % Error statistics
disp([number_with,rate_with])
chk2 = isequal(msg1,decoded1);
disp('Result')
disp(chk2)
% Without Interleaving
%---------------------
code_err = bitxor(code,errors); % Include burst error.
%disp('without interleaving')
%disp(code_err)
decoded = decode(code_err,n,k,'hamming/binary'); % Decode.
%disp('Number of errors and error rate, without interleaving:');
[number_without,rate_without] = biterr(msg,decoded); % Error statistics
%disp('[number_without,rate_without]')
%disp([number_without,rate_without])