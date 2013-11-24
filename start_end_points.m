function [start_index,end_index]=start_end_points(x_array,y_array,x_center,y_center,direction_angle)
    flag1=1;
    flag2=1;
    direction_angle1=atan2((y_array-y_center),(x_array-x_center))/pi*180;
    direction_angle1(direction_angle1>0)=360-direction_angle1(direction_angle1>0);    % -180~+180=>0~360
    direction_angle1(direction_angle1<0)=-direction_angle1(direction_angle1<0);
    direction_angle2=direction_angle1;
    if(direction_angle<90)
        direction_angle1=direction_angle+270-direction_angle1;%end point,-90+360
    else
        direction_angle1=direction_angle1-direction_angle+90;
    end
    direction_angle2=direction_angle2-direction_angle-90;%start point
    
    while(true)
        [a,end_index]=min(abs(direction_angle1));
        [a,start_index]=min(abs(direction_angle2));
        if(x_array(end_index)>x_center)
            flag1=0;
        else
            direction_angle1(end_index)=360;
        end
        if(x_array(start_index)<x_center)
            flag2=0;
        else
            direction_angle2(start_index)=360;
        end
        if(~(flag1||flag2))
            break;
        end
    end
end