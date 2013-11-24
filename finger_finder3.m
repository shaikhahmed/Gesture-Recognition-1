function [fingeredge_start,fingeredge_end]=finger_finder3(x_array,y_array,fingertip,fingeredge,direction_angle,start_index)
    for i=1:2
        if(i==1)%左边的点
            edge_degree=atan2(y_array(start_index+fingertip-1:fingeredge(2))-y_array(fingeredge(1)),x_array(start_index+fingertip-1:fingeredge(2))-x_array(fingeredge(1)))/pi*180;
            edge_degree(edge_degree>0)=360-edge_degree(edge_degree>0);
            edge_degree(edge_degree<0)=-edge_degree(edge_degree<0);
            edge_degree(edge_degree>180)=edge_degree(edge_degree>180)-360;
        else%右边的点
            edge_degree1=atan2(y_array(fingeredge(1):start_index+fingertip(1)-1)-y_array(fingeredge(2)),x_array(fingeredge(1):start_index+fingertip(1)-1)-x_array(fingeredge(2)))/pi*180;
            edge_degree1(edge_degree1>0)=360-edge_degree1(edge_degree1>0);
            edge_degree1(edge_degree1<0)=-edge_degree1(edge_degree1<0);
        end
        if(i==2)
            [a,index1]=min(abs(edge_degree-direction_angle+90));%开始选左边为起点
            [a,index2]=min(abs(edge_degree1-direction_angle-90));%开始选右边为终点
            if(start_index+fingertip+index1-2<fingeredge(2)&&index2==1)
                fingeredge_start=fingeredge(1);
                fingeredge_end=start_index+fingertip+index1-2;
            elseif(index2>1&&start_index+fingertip+index1-2==fingeredge(2))
                fingeredge_start=fingeredge(1)+index2-1;
                fingeredge_end=fingeredge(2);
            else
                fingeredge_start=fingeredge(1)+1;
                fingeredge_end=fingeredge(2)-1;
            end
%             if(min(edge_degree)<=0&&max(edge_degree1)<=180)%选左边
%                 [a,index1]=min(abs(edge_degree-direction(index)/2+90));
%                 fingeredge_start=fingeredge(1);
%                 fingeredge_end=start_index+fingertip+index1-2;
%             else
%                 [a,index1]=min(abs(edge_degree1-direction(index)/2-90));%选右边
%                 fingeredge_start=fingeredge(1)+index1-1;
%                 fingeredge_end=fingeredge(2);
%             end
        end
    end
end