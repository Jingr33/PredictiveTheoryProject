clear; 
close all;
clc;

sampleTime = 1;
N = 400;
numerator = [1.5];
denominator = [5 5 1];
horizon = 30;
lambda = 5;

reference = [1 * ones(N/2, 1); 2 * ones(N/2, 1)];

continuousPlant = tf(numerator, denominator);
discretePlant = c2d(continuousPlant, sampleTime, 'zoh');
[Bpoly, Apoly] = tfdata(discretePlant, 'v');

model = buildGpc(Apoly, Bpoly, horizon);
plant = ss(discretePlant);

state = zeros(size(plant.A, 1), 1);
output = 0;
inputPrevious = 0;
deltaPrevious = 0;

yHistory = zeros(size(model.Avlnovka, 2), 1);

U = zeros(N, 1);
Y = zeros(N, 1);
W = reference;

for k = 1:N
    refWindow = referenceWindow(reference, k, horizon);
    move = moveGpc(model, yHistory, deltaPrevious, inputPrevious, refWindow, lambda);

    inputCurrent = move.uNext;
    U(k) = inputCurrent;
    deltaPrevious = move.deltaU;

    [state, outputNext] = discretePlantStep(plant, state, inputCurrent);
    Y(k) = outputNext;

    if ~isempty(yHistory)
        yHistory = [outputNext; yHistory(1:end-1)];
    end

    inputPrevious = inputCurrent;
    output = outputNext;
end

figure('Color', 'w');
plot((0:N-1)' * sampleTime, W, 'blue');
hold on;
plot((0:N-1)' * sampleTime, Y, 'black');
plot((0:N-1)' * sampleTime, U, 'yellow');
grid on;
legend('w', 'y', 'u');
xlabel('t [s]');
ylabel('Amplitude');
title('GPC controller');
hold off;
