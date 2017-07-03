bgImage = imread('Background Image/bgImage.jpg');
figure(2), imshow(bgImage,'InitialMagnification','fit');

set (gcf, 'WindowButtonMotionFcn', @mouseMove);
