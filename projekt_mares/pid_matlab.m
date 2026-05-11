clear; clc;

Ts = 0.1;

G = tf(1.5, [5 5 1]);
Gs = c2d(G, Ts);

Kp = 8;
Ki = 1.5;
Kd = 6;

num = [Kp + Ki*Ts + Kd/Ts, -Kp - 2*Kd/Ts, Kd/Ts];
den = [1, -1, 0];
Cs = tf(num, den, Ts);

T = feedback(Cs*Gs, 1);

t = 0:Ts:100;
step(T, t)
grid on