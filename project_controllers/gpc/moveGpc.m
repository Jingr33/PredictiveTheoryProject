function move = moveGpc(model, yHistory, deltaPrevious, uPrevious, referenceWindow, lambda)

N = model.predictionHorizon;

if numel(referenceWindow) < N
    referenceWindow = [referenceWindow(:); repmat(referenceWindow(end), N - numel(referenceWindow), 1)];
else
    referenceWindow = referenceWindow(:);
end

yHistory = yHistory(:);

history = [deltaPrevious; yHistory];
freeResponse = model.F * history;

K = (model.G' * model.G + lambda * eye(size(model.G, 2))) \ model.G';
K = K(1, :);

deltaCurrent = K * (referenceWindow - freeResponse);
uNext = uPrevious + deltaCurrent;

move = struct();
move.deltaU = deltaCurrent;
move.uNext = uNext;
move.futureInput = uNext;
move.predictedOutput = freeResponse;
move.referenceWindow = referenceWindow;
end
