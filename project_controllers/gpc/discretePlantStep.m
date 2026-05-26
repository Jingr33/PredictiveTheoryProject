function [nextState, y] = discretePlantStep(plant, currentState, u)
    nextState = plant.A * currentState + plant.B * u;
    y = plant.C * currentState + plant.D * u;
end