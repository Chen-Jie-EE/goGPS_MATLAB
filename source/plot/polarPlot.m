function h = polarPlot(az, decl, varargin)
% Equivalent of polar plot but with support for older Matlab versions
% SYNTAX:
%    polarPlot(az, decl, varargin)
%
% INPUT
%   az      azimuth      [rad]
%   decl    declination  [rad]
%   varargin
%
% OUTPUT
%   h       handle to the scattered points

%  Software version 1.0.1
%-------------------------------------------------------------------------------
%  Copyright (C) 2024 Geomatics Research & Development srl (GReD)
%  Written by:       Mirko Reguzzoni
%  Contributors:     Giulio Tagliaferro, Andrea Gatti ...
%  A list of all the historical goGPS contributors is in CREDITS.nfo
%--------------------------------------------------------------------------
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%----------------------------------------------------------------------------------------------


%%% INTERNAL PARAMETER
    scale = 1;
    %%%

    decl_n = decl/(pi/2)*scale;
    decl_n(decl_n > 1) = nan;
    is_hold = ishold();
    plot_bg = ~is_hold;
    if plot_bg
        hold on
        %plot parallel
        az_l = [0:pi/200:2*pi];
        d_step = 15/180*pi;
        decl_s = ([0:d_step:pi/2]/(pi/2))*scale;
        for d = decl_s
            x = cos(az_l).*d;
            y = sin(az_l).*d;
            plot(x,y,'color',[0.6 0.6 0.6]);
        end
        for d = decl_s
            text(cos(80/180*pi)*d,sin(80/180*pi)*d,sprintf('%d',round(d*90)),'HorizontalAlignment','center', 'FontWeight', 'bold', 'FontSize', 13);            
        end
        %plot meridian
        az_step = 30/180 *pi;
        az_s = [0:az_step:2*pi];
        decl_l = ([0 1])*scale;
        for a = az_s
            x = cos(a).*decl_l;
            y = sin(a).*decl_l;
            plot(x,y,'color',[0.6 0.6 0.6]);
        end
        for a = az_s
            if abs(a-2*pi) > 0.0001
                text(cos(a)*1.1,sin(a)*1.1,sprintf('%d', mod(round((2*pi - a + pi/2) / pi * 180), 360)), 'HorizontalAlignment','center', 'FontWeight', 'bold', 'FontSize', 13);
            end
        end
        axis equal
        % xlim([-2 2])
        % ylim([-2 2])
        axis off
        set(gcf,'color','w');
        xlim([-1.15 1.15]); ylim([-1.15 1.15]);
    end

    x = sin(az) .* decl_n;
    y = cos(az) .* decl_n;
    varargin = [{x},{y}, varargin];
    h = plot(varargin{:});
    if ~is_hold
        hold off
    end       
end