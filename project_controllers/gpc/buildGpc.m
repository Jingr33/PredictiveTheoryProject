function model = buildGpc(Apoly, Bpoly, predictionHorizon)

Apoly = Apoly(:).';
Bpoly = Bpoly(:).';

if abs(Apoly(1) - 1) > 1e-12
    Apoly = Apoly / Apoly(1);
end

Delta = [1 -1];
Ainc = conv(Apoly, Delta);
Binc = Bpoly(:).';
if numel(Binc) > 1
    Binc = Binc(2:end);
else
    Binc = [];
end

na = numel(Ainc) - 1;
nb = numel(Binc);
N = predictionHorizon;

A = eye(N);
for row = 2:N
    for col = 1:row - 1
        lag = row - col + 1;
        if lag <= numel(Ainc)
            A(row, col) = Ainc(lag);
        end
    end
end

B = zeros(N, N);
for row = 1:N
    for col = 1:row
        lag = row - col + 1;
        if lag <= numel(Binc)
            B(row, col) = Binc(lag);
        end
    end
end

Avlnovka = zeros(N, na);
for row = 1:N
    for col = 1:size(Avlnovka, 2)
        idx = row + col;
        if idx <= numel(Ainc)
            Avlnovka(row, col) = -Ainc(idx);
        end
    end
end

Bvlnovka = zeros(N, 1);
for row = 1:N
    idx = row + 1;
    if idx <= numel(Binc)
        Bvlnovka(row, 1) = Binc(idx);
    end
end

G = A \ B;
F = A \ [Bvlnovka Avlnovka];

model = struct();
model.A = A;
model.B = B;
model.Avlnovka = Avlnovka;
model.Bvlnovka = Bvlnovka;
model.G = G;
model.F = F;
model.Apoly = Apoly;
model.Bpoly = Bpoly;
model.na = na;
model.nb = nb;
model.predictionHorizon = N;
end
