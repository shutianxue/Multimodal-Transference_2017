function [ScrnRes, ScrnPPI] = ScreenSpecs(scrnvbl)

%Get resolution
ScrnRes = get(0, 'ScreenSize');

%Get PPI
ScrnPPI = sqrt(ScrnRes(3)^2 + ScrnRes(4)^2)/scrnvbl;

