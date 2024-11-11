function y = Rob(x, Fc, Fs)
N = length(x);
y = zeros(N, 1);
t = 1;
for k = (1:N)/Fs
    y(t) = real(x(t)*exp(-2*i*pi*Fc*k));
    t = t + 1;
end
end