function resetTimeTicks(h, num, format)
% reset function for setTimeTicks
% SEE ALSO: setTimeTicks

%  Software version 1.0.1
%-------------------------------------------------------------------------------
%  Copyright (C) 2024 Geomatics Research & Development srl (GReD)
%  Written by:       Andrea Gatti
%  Contributors:     Andrea Gatti, ...
%
%  The licence of this file can be found in source/licence.md
%-------------------------------------------------------------------------------

    if (nargin == 1)
        num = 9;
        format = 'yyyy/mm/dd HH:MM';
    end
    if isa(h, 'matlab.ui.Figure')
        h = get(h,'Children');
    end
    if num == 0
        h.XTick = {};
    else
        for i = 1 : numel(h)
            try
                h(i).TickLength = [0.005 0.01];
                ax = double(axis(h(i)));

                step = (ax(2)-ax(1))/(num);
                % Calculate the time span of the data
                time_span = ax(2)-ax(1);

                % Depending on the time_span, round ticks
                round_val = 1 / 86400; % default to one second

                if time_span > 20
                    round_val = 1;
                elseif time_span > 8
                    round_val = 12 / 24;
                elseif time_span > 6
                    round_val = 6 / 24;
                elseif time_span > 4
                    round_val = 3 / 24;
                elseif time_span > 1
                    round_val = 1 / 24;
                elseif time_span > 12 / 24
                    round_val = 30 / (24 * 60);
                elseif time_span > 5 / 24
                    round_val = 15 / (24 * 60);
                elseif time_span > 1 / 24
                    round_val = 5 / (24 * 60);
                elseif time_span > 10 / (24 * 60)
                    round_val = 1 / (24 * 60);
                elseif time_span > 5 / (24 * 60)
                    round_val = 30 / 86400;
                elseif time_span > 1 / (24 * 60)
                    round_val = 5 / 86400;
                end

                step = round(step/(round_val))*(round_val);

                % Find the center of the axis
                is_odd = mod(num,2) == 1;
                center = round(( (ax(1) + ax(2)) / 2) /(round_val))*(round_val); % center but rounded according to round_val/2

                % Calculate the tick positions symmetrically about the center
                num_ticks_each_side = ceil(diff(ax(1:2)) / step / 2) + 1;
                tick_pos = iif(is_odd, step/2, 0) + center + (-num_ticks_each_side:num_ticks_each_side) * step;

                % Remove tick positions outside the axis limits
                % how many are fitting?
                num_fitting = sum(((tick_pos < ax(1)) | (tick_pos > ax(2))) == 0);
                fitting_is_odd = mod(num_fitting,2) == 1;
                tick_pos = -iif(fitting_is_odd, step/2, 0) + iif(is_odd, step/2, 0) + center + (-num_ticks_each_side:num_ticks_each_side) * step;
                tick_pos((tick_pos < ax(1)) | (tick_pos > ax(2))) = [];

                % Determine the granularity of the tick labels
                c_out = 0;
                if round_val >= 1 / (24 * 60)
                    c_out = 3;
                elseif round_val >= 1
                    c_out = 9;
                end

                if all(mod(tick_pos, 1) == 0)
                    round_val = 1;
                end

                % Set the tick positions for the axis
                set(h(i), 'XTick', tick_pos);
                if strcmp(format, 'auto') || strcmp(format, 'doy')
                    last_date = [0 0 0 0 0 0];
                    h.XTickLabel = cell(size(tick_pos));

                    x_labels = cell(size(tick_pos));
                    for l = 1 : numel(tick_pos)
                        str_time_format = 'HH:MM:SS';
                        new_date = datevec(double(tick_pos(l)));
                        if last_date(1) ~= new_date(1)        % if the year is different
                            if strcmp(format, 'doy')
                                str_time_format = [char(32 * ones(1, floor(c_out/2) + 3)) str_time_format(1:end - c_out) '-newlineyyyy XXX'];
                            else
                                str_time_format = [char(32 * ones(1, floor(c_out/2) + 5)) str_time_format(1:end - c_out) '-newlinemmm dd, yyyy'];
                            end
                        elseif last_date(2) ~= new_date(2)    % if the month is different
                            if strcmp(format, 'doy')
                                str_time_format = [char(32 * ones(1, floor(c_out/2) + 3)) str_time_format(1:end - c_out) '-newlineyyyy XXX'];
                            else
                                str_time_format = [char(32 * ones(1, floor(c_out/2) + 5)) str_time_format(1:end - c_out) '-newlinemmm dd, yyyy'];
                            end
                        elseif last_date(3) ~= new_date(3)    % if the day is different
                            if strcmp(format, 'doy')
                                str_time_format = [char(32 * ones(1, floor(c_out/2) + 3)) str_time_format(1:end - c_out) '-newlineyyyy XXX'];
                            else
                                str_time_format = [char(32 * ones(1, floor(c_out/2) + 5)) str_time_format(1:end - c_out) '-newlinemmm dd, yyyy'];
                            end
                        elseif last_date(4) ~= new_date(4)    % if the hour is different
                            str_time_format = str_time_format(1:end - c_out);
                        else % if last_date(5) ~= new_date(5)    % if the hour is different
                            str_time_format = str_time_format(1:end - c_out);
                        end
                        if isempty(str_time_format)
                            h.XTickLabel{l} = '';
                        else
                            if round_val == 1
                                %if any(strfind(str_time_format,'-newline'))
                                %    tmp = datestr(tick_pos(l), regexp(str_time_format(strfind(str_time_format,'-newline')+8:end), '(?<=line).*','match', 'once'));
                                %else
                                tmp = datestr(tick_pos(l), regexp(str_time_format, '(?<=line).*','match', 'once'));
                                %end
                                if strcmp(format, 'doy')
                                    time = GPS_Time(tick_pos(l));
                                    [year, doy] = time.getDOY;
                                    tmp = strrep(tmp, 'XXX', sprintf('%03d', doy));
                                end
                            else
                                %if any(strfind(str_time_format,'-newline'))
                                %    tmp = datestr(tick_pos(l), str_time_format(strfind(str_time_format,'-newline')+8:end));
                                %else
                                    tmp = datestr(tick_pos(l), str_time_format);
                                %end
                                if strcmp(format, 'doy')
                                    time = GPS_Time(tick_pos(l));
                                    [year, doy] = time.getDOY;
                                    tmp = strrep(tmp, 'XXX', sprintf('%03d', doy));
                                end
                                tmp(tmp == '-') = '\';
                            end
                            h.XTickLabel{l} = tmp;
                            if h.XTickLabelRotation > 0
                                nl_id = strfind(tmp, '\newline');
                                if not(isempty(nl_id))
                                    tmp = [tmp(nl_id+8:end) '   ' strtrim(tmp(1:nl_id-1))];
                                end
                                h.XTickLabel{l} = tmp;
                            end
                        end
                        last_date = new_date;
                    end
                else
                    h.XTickLabel = {};
                    nl_id = strfind(format, '\n');
                    format = strrep(format, '\n','??');
                    for l = 1:numel(tick_pos)
                        h.XTickLabel{l} = strrep(datestr(tick_pos(l), format),'??','\newline');
                    end
                end
                axis(h(i),ax);
            catch ex
                Core_Utils.printEx(ex);
            end
        end
    end
end