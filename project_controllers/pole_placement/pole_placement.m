clear;
close all;
clc;

Ts = 1;
N = 100;

continuousPlant = tf([1.5], [5 5 1]);
discretePlant = c2d(continuousPlant, Ts, 'zoh');
[B, A] = tfdata(discretePlant, 'v');

desiredPoles = 0.65;
C = poly(desiredPoles);

controller = controller_structure(A, B, C);

N = floor(N / Ts);
w = [1 * ones(N/2, 1); 2 * ones(N/2, 1)];

[t, y, u] = simulation(A, B, controller, w, Ts);

figure('Color', 'w');
plot(t, w, 'blue');
hold on;
plot(t, y, 'black');
plot(t, u, 'yellow');
grid on;
legend('w', 'y', 'u');
xlabel('t [s]');
ylabel('Amplitude');
title('Pole placement');
hold off;
