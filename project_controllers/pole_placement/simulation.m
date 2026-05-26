function [t, y, u] = simulation(A, B, controller, w, Ts)
A = A(:).';
B = B(:).';
P = controller.P(:).';
Q = controller.Q(:).';
R = controller.R;

N = numel(w);
y = zeros(N, 1);
u = zeros(N, 1);
t = (1:N).' * Ts;

plantY = zeros(numel(A), 1);
plantU = zeros(numel(B), 1);
ctrlY = zeros(numel(Q), 1);
ctrlU = zeros(numel(P), 1);

for k = 1:N
    plantOutput = B * plantU;
    if numel(A) > 1
        plantOutput = plantOutput - A(2:end) * plantY(2:end);
    end

    ctrlY(1) = plantOutput;

    feedbackTerm = Q * ctrlY;
    feedforwardTerm = 0;
    if numel(P) > 1
        feedforwardTerm = P(2:end) * ctrlU(2:end);
    end

    controlSignal = (R * w(k) - feedbackTerm - feedforwardTerm) / P(1);

    plantU(1) = controlSignal;
    plantY(1) = plantOutput;
    ctrlU(1) = controlSignal;

    plantU = [0; plantU(1:end-1)];
    plantY = [0; plantY(1:end-1)];
    ctrlY = [0; ctrlY(1:end-1)];
    ctrlU = [0; ctrlU(1:end-1)];

    y(k) = plantOutput;
    u(k) = controlSignal;
end
end
