function controller = controller_structure(A, B, desiredPolynomial)
A = A(:).';
B = B(:).';
desiredPolynomial = desiredPolynomial(:).';

nA = numel(A) - 1;
nB = numel(B) - 1;
nC = numel(desiredPolynomial) - 1;

nP = nB - 1;

if nA + nB > nC
    nQ = nA - 1;
else
    nQ = nC - nB - 1;
end

rowCount = nP + nQ + 2;
sylvesterMatrix = zeros(rowCount, rowCount);
Acol = A(:);
Bcol = B(:);

for column = 1:(nP + 1)
    sylvesterMatrix(column:column + nA, column) = Acol;
end

for column = (nP + 2):rowCount
    firstRow = column - (nP + 1);
    sylvesterMatrix(firstRow:firstRow + nB, column) = Bcol;
end

rightHandSide = zeros(rowCount, 1);
rightHandSide(1:nC + 1) = desiredPolynomial(:);

solution = sylvesterMatrix \ rightHandSide;
P = solution(1:nP + 1).';
Q = solution(nP + 2:end).';

R = sum(desiredPolynomial) / sum(B);

controller = struct();
controller.P = P;
controller.Q = Q;
controller.R = R;
controller.matrix = sylvesterMatrix;
controller.rhs = rightHandSide;
controller.desiredPolynomial = desiredPolynomial;
end
