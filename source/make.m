% Run this to compile all the binaries of BREVA
%
% INPUT
%   target_list     cell array, values:
%                       'TIVAN'
%                       'BREVA'
%                       'slave'
%                       'mex'
%
% SYNTAX
%   make(target_list)
%
% EXAMPLE
%    make({'slave', 'TIVAN', 'TIVANprj'})

%  Software version 1.0.1
%-------------------------------------------------------------------------------
%  Copyright (C) 2024 Geomatics Research & Development srl (GReD)
%  Written by:        Andrea Gatti
%  Contributors:      Andrea Gatti, ...
%
%  The licence of this file can be found in source/licence.md
%-------------------------------------------------------------------------------

function make(target_list, deploy_dir)
    if isempty(target_list) || (ischar(target_list) && strcmp(target_list, 'all'))
        target_list = {'slave', 'goGPS'};
    end
    if ischar(target_list)
        target_list = {target_list};
    end
    
    % Deploy BREVA
    if nargin == 1
        deploy_dir = fullfile('../bin/', computer('arch'));
    end
    
    if ~exist(deploy_dir, 'dir')
        mkdir(deploy_dir)
    end
    
    for trg = target_list(:)'
        switch trg{1}
            case {'slave', 'slaves'}
                fprintf('Compile startSlave.m -------------------------- \n');
                % tic; mcc('-v', '-d', deploy_dir, '-m', 'startSlave', '-a', 'remote_resource.ini', '-a', 'credentials.example.txt', '-a', 'app_settings.ini', '-a', 'tai-utc.dat', '-a', 'cls.csv', '-a', 'icpl.csv', '-a', 'nals.csv', '-a', 'napl.csv', '-a', 'icons/*.png', '-a', 'utility/thirdParty/guiLayoutToolbox/layout/+uix/Resources/*.png', '-R', '-singleCompThread'); toc;
                tic; mcc('-v', '-d', deploy_dir, '-m', 'startSlave', '-a', 'remote_resource.ini', '-a', 'credentials.example.txt', '-a', 'app_settings.ini', '-a', 'tai-utc.dat', '-a', 'cls.csv', '-a', 'icpl.csv', '-a', 'nals.csv', '-a', 'napl.csv', '-a', 'icons/*.png', '-a', 'utility/thirdParty/guiLayoutToolbox/layout/+uix/Resources/*.png', '-a', 'utility/thirdParty/7z1602-extra/*'); toc;
                
            case {'goGPS', 'gogps'}
                fprintf('Compile goGPS.m ------------------------------- \n');
                tic; mcc('-v', '-d', deploy_dir, '-m', 'goGPS.m', '-a', 'remote_resource.ini', '-a', 'credentials.example.txt', '-a', 'app_settings.ini', '-a', 'tai-utc.dat', '-a', 'cls.csv', '-a', 'icpl.csv', '-a', 'nals.csv', '-a', 'napl.csv', '-a', 'icons/*.png', '-a', 'utility/thirdParty/guiLayoutToolbox/layout/+uix/Resources/*.png', '-a', 'utility/thirdParty/7z1602-extra/*'); toc;
        end
    end
end