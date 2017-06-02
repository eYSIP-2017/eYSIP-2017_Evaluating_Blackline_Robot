figure();
hold on;
plot(KK_PX, KK_PY, 'g+');
plot([100 110 110 100 100],[63 63 69 69 63], 'r-');
plot([100 110 110 100],[63 63 69 69], 'b*');
title('Four Corners of Cube')
xlabel('Xw(mm)')
ylabel('Yw(mm)')