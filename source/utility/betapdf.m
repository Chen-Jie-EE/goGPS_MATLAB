function pdf = betapdf (x, a, b)
% For each element of x, returns the PDF at x of the beta
% distribution with parameters a and b.

% Description: PDF of the Beta distribution

%  Software version 1.0.1
%-------------------------------------------------------------------------------
% Copyright (C) 1995-2011 Kurt Hornik
% Copyright (C) 2010 Christos Dimitrakakis
% Copyright (C) 2024 Geomatics Research & Development srl (GReD)
% Adapted from Octave
%  Written by:       KH <Kurt.Hornik@wu-wien.ac.at>
%                    CD <christos.dimitrakakis@gmail.com>
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
        error ('betapdf: X, A and B must be of common size or scalar');
    end
end

sz = size (x);
pdf = zeros (sz);

k = find (~(a > 0) | ~(b > 0) | isnan (x));
if (any (k))
    pdf (k) = NaN;
end

k = find ((x > 0) & (x < 1) & (a > 0) & (b > 0) & ((a ~= 1) | (b ~= 1)));
if (any (k))
    if (isscalar(a) && isscalar(b))
        pdf(k) = exp ((a - 1) .* log (x(k)) + (b - 1) .* log (1 - x(k)) + gammaln(a + b) - gammaln(a) - gammaln(b));
    else
        pdf(k) = exp ((a(k) - 1) .* log (x(k)) + (b(k) - 1) .* log (1 - x(k)) + gammaln(a(k) + b(k)) - gammaln(a(k)) - gammaln(b(k)));
    end
end

% Most important special cases when the density is finite.
k = find ((x == 0) & (a == 1) & (b > 0) & (b ~= 1));
if (any (k))
    if (isscalar(a) && isscalar(b))
        pdf(k) = exp(gammaln(a + b) - gammaln(a) - gammaln(b));
    else
        pdf(k) = exp(gammaln(a(k) + b(k)) - gammaln(a(k)) - gammaln(b(k)));
    end
end

k = find ((x == 1) & (b == 1) & (a > 0) & (a ~= 1));
if (any (k))
    if (isscalar(a) && isscalar(b))
        pdf(k) = exp(gammaln(a + b) - gammaln(a) - gammaln(b));
    else
        pdf(k) = exp(gammaln(a(k) + b(k)) - gammaln(a(k)) - gammaln(b(k)));
    end
end

k = find ((x >= 0) & (x <= 1) & (a == 1) & (b == 1));
if (any (k))
    pdf(k) = 1;
end

% Other special case when the density at the boundary is infinite.
k = find ((x == 0) & (a < 1));
if (any (k))
    pdf(k) = Inf;
end

k = find ((x == 1) & (b < 1));
if (any (k))
    pdf(k) = Inf;
end