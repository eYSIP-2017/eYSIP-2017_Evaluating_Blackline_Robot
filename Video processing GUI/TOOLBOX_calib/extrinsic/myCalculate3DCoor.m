function[points3D] = myCalculate3DCoor(origin2D,points2D,cc,fc,Rc_ext,Tc_ext)


%% First calculate 3D Coordinate for Origin
Zw = 0;
% [kxi,kyi] = origin2D;
% [kxxi] = cornerfinder(origin2D',kImage,wintx,winty);
xim = origin2D(1);
yim = origin2D(2);

% figure(2);
% hold on;
% plot(xim, yim, '+');
% xim = input('Enter x: ','s'); 
% yim = input('Enter x: ','s');

A11 = (xim-cc(1))*Rc_ext(3,1) - fc(1)*Rc_ext(1,1);
A12 = (xim-cc(1))*Rc_ext(3,2) - fc(1)*Rc_ext(1,2);
A21 = (yim-cc(2))*Rc_ext(3,1) - fc(2)*Rc_ext(2,1);
A22 = (yim-cc(2))*Rc_ext(3,2) - fc(2)*Rc_ext(2,2);

matA = [A11,A12;A21,A22];

% B1 = (cc(1)-xim)*(Rc_ext(3,3)*Zw + Tc_ext(3)) - fc(1)*Rc_ext(1,3)*Zw - fc(1)*Tc_ext(1);
% B2 = (cc(2)-yim)*(Rc_ext(3,3)*Zw + Tc_ext(3)) - fc(2)*Rc_ext(2,3)*Zw - fc(2)*Tc_ext(2);
B1 = Zw*(fc(1)*Rc_ext(1,3)-(xim-cc(1))*Rc_ext(3,3)) + fc(1)*Tc_ext(1) - (xim-cc(1))*Tc_ext(3);
B2 = Zw*(fc(2)*Rc_ext(2,3)-(yim-cc(2))*Rc_ext(3,3)) + fc(2)*Tc_ext(2) - (yim-cc(2))*Tc_ext(3);


matB = [B1;B2];

origin = -1*(inv(matA)*matB);

% KW_count = 4;
worldCor=[];
for KW_count=1:1
    
    %% Select Point
%     Zw = 71;
    Zw = 83;
%     [kxi,kyi] = points2D(KW_count,:);
%     [kxxi] = cornerfinder(points2D(KW_count,:)',kImage,5,5);
    xim = points2D(KW_count,1);
    yim = points2D(KW_count,2);

%     figure(2);
%     hold on;
%     plot(xim, yim, '+');
    % xim = input('Enter x: ','s'); 
    % yim = input('Enter x: ','s');

    A11 = (xim-cc(1))*Rc_ext(3,1) - fc(1)*Rc_ext(1,1);
    A12 = (xim-cc(1))*Rc_ext(3,2) - fc(1)*Rc_ext(1,2);
    A21 = (yim-cc(2))*Rc_ext(3,1) - fc(2)*Rc_ext(2,1);
    A22 = (yim-cc(2))*Rc_ext(3,2) - fc(2)*Rc_ext(2,2);

    matA = [A11,A12;A21,A22];

    B1 = Zw*(fc(1)*Rc_ext(1,3)-(xim-cc(1))*Rc_ext(3,3)) + fc(1)*Tc_ext(1) - (xim-cc(1))*Tc_ext(3);
    B2 = Zw*(fc(2)*Rc_ext(2,3)-(yim-cc(2))*Rc_ext(3,3)) + fc(2)*Tc_ext(2) - (yim-cc(2))*Tc_ext(3);

    matB = [B1;B2];

    point = inv(matA)*matB;

    worldCor = [worldCor; -1*((origin - point)/10)];
end
% % % worldCor
% KW_XX = [];
% KW_XX = [KW_XX worldCor(1)+5.5];
% KW_XX = [KW_XX worldCor(3)-5.5];
% KW_XX = [KW_XX worldCor(5)-5.5];
% KW_XX = [KW_XX worldCor(7)+5.5];
% KW_XX
% mean(KW_XX);
% KW_YY = [];
% KW_YY = [KW_YY worldCor(2)+5.5];
% KW_YY = [KW_YY worldCor(4)+5.5];
% KW_YY = [KW_YY worldCor(6)-5.5];
% KW_YY = [KW_YY worldCor(8)-5.5];
% KW_YY
% mean(KW_YY);


% points3D = [mean(KW_XX) mean(KW_YY)];
points3D = worldCor;


end