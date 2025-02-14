function inv = betainv (x, a, b)
% For each component of x, compute the quantile (the inverse of
% the CDF) at x of the Beta distribution with parameters a
% and b.

% Description: Quantile function of the Beta distribution

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
        error ('betainv: X, A and B must be of common size or scalars');
    end
end

sz = size (x);
inv = zeros (sz);

k = find ((x < 0) | (x > 1) | ~(a > 0) | ~(b > 0) | isnan (x));
if (any (k))
    inv (k) = NaN;
end

k = find ((x == 1) & (a > 0) & (b > 0));
if (any (k))
    inv (k) = 1;
end

k = find ((x > 0) & (x < 1) & (a > 0) & (b > 0));
if (any (k))
    if (~isscalar(a) || ~isscalar(b))
        a = a (k);
        b = b (k);
        y = a ./ (a + b);
    else
        y = a / (a + b) * ones (size (k));
    end
    x = x (k);

    if (isa (y, 'single'))
        myeps = eps ('single');
    else
        myeps = eps;
    end

    l = find (y < myeps);
    if (any (l))
        y(l) = sqrt (myeps) * ones (length (l), 1);
    end
    l = find (y > 1 - myeps);
    if (any (l))
        y(l) = 1 - sqrt (myeps) * ones (length (l), 1);
    end

    y_old = y;
    for i = 1 : 10000
        h     = (betacdf (y_old, a, b) - x) ./ betapdf (y_old, a, b);
        y_new = y_old - h;
        ind   = find (y_new <= myeps);
        if (any (ind))
            y_new (ind) = y_old (ind) / 10;
        end
        ind = find (y_new >= 1 - myeps);
        if (any (ind))
            y_new (ind) = 1 - (1 - y_old (ind)) / 10;
        end
        h = y_old - y_new;
        if (max (abs (h)) < sqrt (myeps))
            break;
        end
        y_old = y_new;
    end

    inv (k) = y_new;
end