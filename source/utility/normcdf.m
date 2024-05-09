function cdf = normcdf (x, m, s)
% For each element of x, compute the cumulative distribution
% function (CDF) at x of the normal distribution with mean
% m and standard deviation s.
% Default values are m = 0, s = 1.

% Description: CDF of the normal distribution

%  Software version 1.0.1
%-------------------------------------------------------------------------------
% Copyright (C) 1995-2011 Kurt Hornik
% Copyright (C) 2024 Geomatics Research & Development srl (GReD)
%  Written by:       TT <Teresa.Twaroch@ci.tuwien.ac.at>
%  Contributors:     ...
%
%  The licence of this file can be found in source/licence.md
%-------------------------------------------------------------------------------

if (~ ((nargin == 1) || (nargin == 3)))
    error('Requires one or three input arguments.');
end

if (nargin == 1)
    m = 0;
    s = 1;
end

if (~isscalar (m) || ~isscalar (s))
    [retval, x, m, s] = common_size (x, m, s);
    if (retval > 0)
        error ('normcdf: X, M and S must be of common size or scalar');
    end
end

sz = size (x);
cdf = zeros (sz);

if (isscalar (m) && isscalar(s))
    if (find (isinf (m) | isnan (m) | ~(s >= 0) | ~(s < Inf)))
        cdf = NaN (sz);
    else
        cdf =  stdnormal_cdf ((x - m) ./ s);
    end
else
    k = find (isinf (m) | isnan (m) | ~(s >= 0) | ~(s < Inf));
    if (any (k))
        cdf(k) = NaN;
    end

    k = find (~isinf (m) & ~isnan (m) & (s >= 0) & (s < Inf));
    if (any (k))
        cdf(k) = stdnormal_cdf ((x(k) - m(k)) ./ s(k));
    end
end

cdf((s == 0) & (x == m)) = 0.5;