function PR = powerRatio(y, n0, W, T)
%POWERRATIO Calculates the ratio of periodic power/aperiodic power
%   Uses the difference function as periodic power, and apPower as the
%   aperiodic power

PR = cmndiff(y, n0, W, T)./apPower(y, n0, W, T);

end