function [img, georef, lat, lon, info] = geotiffReader(file_name)
% Custom simplyfied implementatation of geotiffread
% useful when the mapping toolbox is not available
%
% INPUT
%   file_name   full path of the geotiff
%
% OUTPUT
%   img         matrix containing the tiff image
%   georef      GeographicPostingsReference as struct
%                  - LatitudeLimits
%                  - LongitudeLimits
%                  - RasterSize
%                  - RasterInterpretation
%                  - ColumnsStartFrom
%                  - RowsStartFrom
%                  - SampleSpacingInLatitude
%                  - SampleSpacingInLongitude
%                  - RasterExtentInLatitude
%                  - RasterExtentInLongitude
%                  - XIntrinsicLimits
%                  - YIntrinsicLimits
%                  - CoordinateSystemType
%                  - AngleUnit
%   lat         array of latitude coordinates of the image [deg]
%   lon         array of longitude coordinates of the image [deg]
%   info        as output of infinfo
%
%
% SYNTAX
%   [img, georef, lat, lon, info] = geotiffReader(file_name)
    
%  Software version 1.0.1
%-------------------------------------------------------------------------------
%  Copyright (C) 2024 Geomatics Research & Development srl (GReD)
%  Written by:       Andrea Gatti
%  Contributors:     Andrea Gatti, ...
%
%  The licence of this file can be found in source/licence.md
%-------------------------------------------------------------------------------

    img = imread(file_name);
    info = imfinfo(file_name);

    try
        lat = flipud(info.ModelTiepointTag(5) - ((0 : info.Height - 1)' .* info.ModelPixelScaleTag(2)));
        lon = info.ModelTiepointTag(4) + ((0 : info.Width - 1)' .* info.ModelPixelScaleTag(1));

        georef = struct('LatitudeLimits',           [lat(1) lat(end)], ...
            'LongitudeLimits',          [lon(1) lon(end)], ...
            'RasterSize',               [info.Height info.Width], ...
            'RasterInterpretation',     'postings', ...
            'ColumnsStartFrom',         'north', ...
            'RowsStartFrom',            'west', ...
            'SampleSpacingInLatitude',  info.ModelPixelScaleTag(2), ...
            'SampleSpacingInLongitude', info.ModelPixelScaleTag(1), ...
            'RasterExtentInLatitude',   diff([lat(1) lat(end)]), ...
            'RasterExtentInLongitude',  diff([lon(1) lon(end)]), ...
            'XIntrinsicLimits',         [1 info.Width], ...
            'YIntrinsicLimits',         [1 info.Height], ...
            'CoordinateSystemType',     'geographic', ...
            'AngleUnit',                'degree'); % in geotiffread this is an object "GeographicPostingsReference"
    catch
        georef = struct();
        lat = nan;
        lon = nan;
    end

    if isfield(info, 'GDAL_NODATA')
        img(img == str2num(info.GDAL_NODATA)) = nan;
    end
end