function [x,y] = evaluate_bestpoly(xi,yi,cx,cy)
% Helper function for TPxCalibration
x = cx(1)+...
    cx(2).*xi+...
    cx(3).*yi+...
    cx(4).*xi.*xi+...
    cx(5).*yi.*yi+...
    cx(6).*xi.*xi.*xi+...
    cx(7).*xi.*yi+...
    cx(8).*xi.*xi.*yi+...
    cx(9).*xi.*xi.*yi.*yi;

y = cy(1)+...
    cy(2).*xi+...
    cy(3).*yi+...
    cy(4).*xi.*xi+...
    cy(5).*yi.*yi+...
    cy(6).*xi.*yi.*yi+...
    cy(7).*xi.*yi+...
    cy(8).*xi.*xi.*yi+...c
    cy(9).*xi.*xi.*yi.*yi;
end

% 1 = Cst
% 2 = x
% 3 = y
% 4 = x^2
% 5 = y^2
% 6 = x^3 || xy^2
% 7 = xy
% 8 = x^2y
% 9 = x^2y^2



