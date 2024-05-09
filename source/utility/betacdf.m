function cdf = betacdf (x, a, b)
% For each element of x, returns the CDF at x of the beta
% distribution with parameters a and b.

% Description: CDF of the Beta distribution

%  Software version 1.0.1
%-------------------------------------------------------------------------------
% Copyright (C) 1995-2011 Kurt Hornik
% Copyright (C) 2024 Geomatics Research & Development srl (GReD)
% Adapted from Octave
%  Written by:       KH <Kurt.Hornik@wu-wien.ac.at>
%  Contributors:     Andrea Gatti ...
%
%  The licence of this file can be found in source/licence.md
%-------------------------------------------------------------------------------

if (nargin ~= 3)
    error('Requires three input arguments.');
end

if (~isscalar (a) || ~isscalar(b))
    [retval, x, a, b] = common_size (x, a, b);
    if (retval > 0)
        error ('betacdf: X, A and B must be of common size or scalar');
    end
end

sz = size(x);
cdf = zeros (sz);

k = find (~(a > 0) | ~(b > 0) | isnan (x));
if (any (k))
    cdf (k) = NaN;
end

k = find ((x >= 1) & (a > 0) & (b > 0));
if (any (k))
    cdf (k) = 1;
end

k = find ((x > 0) & (x < 1) & (a > 0) & (b > 0));
if (any (k))
    if (isscalar (a) && isscalar(b))
        cdf (k) = betainc (x(k), a, b);
    else
        cdf (k) = betainc (x(k), a(k), b(k));
    end
end