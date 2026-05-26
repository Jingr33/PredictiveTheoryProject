function move = moveGpcConstrained(model, yHistory, deltaPrevious, uPrevious, referenceWindow, lambda, uMin, uMax)

N = model.predictionHorizon;

if numel(referenceWindow) < N
    referenceWindow = [referenceWindow(:); repmat(referenceWindow(end), N - numel(referenceWindow), 1)];
else
    referenceWindow = referenceWindow(:);
end

yHistory = yHistory(:);

history = [deltaPrevious; yHistory];
freeResponse = model.F * history;

baseInput = uPrevious * ones(N, 1);
moveMatrix = tril(ones(N, N));

inputMap = model.G;
baseOutput = freeResponse;

H = inputMap' * inputMap + lambda * eye(N);
f = inputMap' * (baseOutput - referenceWindow);

Aineq = [ moveMatrix; -moveMatrix ];
bineq = [ uMax * ones(N,1) - baseInput; -(uMin * ones(N,1) - baseInput) ];

deltaU = quadprog(H, f, Aineq, bineq, [], [], [], []);
futureInput = baseInput + moveMatrix * deltaU;

move = struct();
move.deltaU = deltaU;
move.uNext = futureInput(1);
move.futureInput = futureInput;
move.freeResponse = freeResponse;
move.referenceWindow = referenceWindow;
end
