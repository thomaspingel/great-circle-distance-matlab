% function [dist] = greatCircleDistance(a1, b1, a2, b2)
% Computes Great Circle distance (in meters).
% Input:given: Start Lat, Start Lon,
% End Lat, End Lon in degrees

function [dist] = greatCircleDistance(a1, b1, a2, b2)

%% If supplied in matrix format, rearrange.  Note, this uses significantly
% more space because Matlab has to make a copy of the array before it can
% delete anything.  AFAIK there is no easy way around this.  If you are
% encountering memory errors, try supplying the vectors separately.

if nargin==1
    b2=a1(:,4);
    a1(:,4)=[];
    a2=a1(:,3);
    a1(:,3)=[];
    b1=a1(:,2);
    a1(:,2)=[];
end

%%
% preAllocate memory space for distance;
dist = zeros(size(a1));

% Check and see if the mapping toolbox is installed.  If it is, just use that
% function.
isthere = [];
isthere = toolboxdir('map');
if ~isempty(isthere)
    chunkSize = 100000;
    if (size(dist,1)>chunkSize) % If the size of the list is very large, break 
                             % into chunks to reduce memory demand.
    sp = 1;
    ep = chunkSize;
    while ep<size(dist,1)
        dist(sp:ep) = 1000*distance(a1(sp:ep),b1(sp:ep),a2(sp:ep),b2(sp:ep),almanac('earth','wgs84'));
        sp=ep+1;
        ep=sp+chunkSize-1;
        if ep>size(dist,1)
            ep = size(dist,1);
        end
        if sp>size(dist,1)
            sp = size(dist,1);
        end
    end
    else
    dist = 1000*distance(a1,b1,a2,b2,almanac('earth','wgs84'));
    end
else
    % This function returns the spheroid distance in meters between lon,lat(a1,b1) and
    % lon,lat(a2,b2).  The earth isn't a sphere, but it's close.
    r = 6372795; % Radius in meters
    dist = (acosd(cosd(a1).*cosd(b1).*cosd(a2).*cosd(b2) + cosd(a1).*sind(b1).*cosd(a2).*sind(b2)...
      + sind(a1).*sind(a2))./360) * 2 * pi * r;
end


% Note: The same thing can be accomplished much more accurately and
% flexibly with the Mapping Toolbox, an optional add-on for Matlab.  The
% syntax is:
% distance(lon1,lat1,lon2,lat2,almanac('earth','wgs84'))
% (Or whatever ellipsoid you want to use.)  

