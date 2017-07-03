% Height of cube(mm) 
% Zw = 0;

kImageName = input('Enter full image name (with extension): ','s');
kImage = imread(kImageName);
figure(2),imshow(kImage);
% figure(2);

fprintf('Select Origin Then the point');
%% Select Origin
Zw = 0;
[kxi,kyi] = ginput(1);
[kxxi] = cornerfinder([kxi;kyi],kImage,winty,wintx);
xim = kxxi(1);
yim = kxxi(2);

figure(2);
hold on;
plot(xim, yim, '+');
% xim = input('Enter x: ','s'); 
% yim = input('Enter x: ','s');

A11 = (xim-cc(1))*Rc_ext(3,1) + fc(1)*Rc_ext(1,1);
A12 = (xim-cc(1))*Rc_ext(3,2) + fc(1)*Rc_ext(1,2);
A21 = (yim-cc(2))*Rc_ext(3,1) + fc(2)*Rc_ext(2,1);
A22 = (yim-cc(2))*Rc_ext(3,2) + fc(2)*Rc_ext(2,2);

matA = [A11,A12;A21,A22];

B1 = (cc(1)-xim)*(Rc_ext(3,3)*Zw + Tc_ext(3)) - fc(1)*Rc_ext(1,3)*Zw - fc(1)*Tc_ext(1);
B2 = (cc(2)-yim)*(Rc_ext(3,3)*Zw + Tc_ext(3)) - fc(2)*Rc_ext(2,3)*Zw - fc(2)*Tc_ext(2);

matB = [B1;B2];

origin = inv(matA)*matB

while(1)
    %% Select Point
    Zw = 60;
    [kxi,kyi] = ginput(1);
    [kxxi] = cornerfinder([kxi;kyi],kImage,winty,wintx);
    xim = kxxi(1);
    yim = kxxi(2);

    figure(2);
    hold on;
    plot(xim, yim, '+');
    % xim = input('Enter x: ','s'); 
    % yim = input('Enter x: ','s');

    A11 = (xim-cc(1))*Rc_ext(3,1) + fc(1)*Rc_ext(1,1);
    A12 = (xim-cc(1))*Rc_ext(3,2) + fc(1)*Rc_ext(1,2);
    A21 = (yim-cc(2))*Rc_ext(3,1) + fc(2)*Rc_ext(2,1);
    A22 = (yim-cc(2))*Rc_ext(3,2) + fc(2)*Rc_ext(2,2);

    matA = [A11,A12;A21,A22];

    B1 = (cc(1)-xim)*(Rc_ext(3,3)*Zw + Tc_ext(3)) - fc(1)*Rc_ext(1,3)*Zw - fc(1)*Tc_ext(1);
    B2 = (cc(2)-yim)*(Rc_ext(3,3)*Zw + Tc_ext(3)) - fc(2)*Rc_ext(2,3)*Zw - fc(2)*Tc_ext(2);

    matB = [B1;B2];

    point = inv(matA)*matB;

    worldCor = (origin - point)/10
end



