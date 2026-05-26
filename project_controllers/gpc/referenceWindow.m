function window = referenceWindow(reference, index, horizon)
    window = reference(index:min(index + horizon - 1, numel(reference)));
    if numel(window) < horizon
        window = [window; repmat(window(end), horizon - numel(window), 1)];
    end
end