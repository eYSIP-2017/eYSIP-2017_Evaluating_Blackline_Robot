function[angle] = myFindAngle(bPoint,gPoint)
    angle = atan2d((gPoint(2)-bPoint(2)),(gPoint(1)-bPoint(1)));
    if(angle<0)
        angle = 360+angle;
    end
    angle = mod((angle+90),360);
    if(angle>180)
        angle = angle-360;
    end
end