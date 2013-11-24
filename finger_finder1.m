function [fingeredge,fingertip]=finger_finder1(degree,norm_distance)
    j=1;
    firstTime=1;
    finger_edge=1;
    length=size(degree,2);
    fingervalley=zeros(1,6);
    min_distance=norm_distance(1);
    max_distance=norm_distance(1);
    for i=1:length
        if(norm_distance(i)<min_distance)
            min_distance=norm_distance(i);
            max_distance=norm_distance(i);
            if(min_distance-norm_distance(finger_edge)<0.027)
                finger_edge=i;
            end
        elseif(norm_distance(i)<max_distance)
            if(max_distance-norm_distance(finger_edge)>0.2)%0.26
                fingervalley(j)=finger_edge;
                j=j+1;
                firstTime=~firstTime;
            end
            min_distance=norm_distance(i);
            max_distance=norm_distance(i);
        elseif(norm_distance(i)>max_distance)
            if(firstTime)
                finger_edge=i-1;
                firstTime=~firstTime;
            end
            max_distance=norm_distance(i);
        end
    end
    
    %remove invalid valley
    j=1;
    length=find(fingervalley, 1, 'last');
    finger_remove=zeros(1,6);
    for i=1:length-1
        index1=i;
        index2=i+1;
        [a,index]=max(norm_distance(fingervalley(index1):fingervalley(index2)));
        if(a-norm_distance(fingervalley(index2))<0.3)%a=norm_distance(finger(index1)+index-1)
            finger_remove(j)=index2;
            j=j+1;
        end
    end
    fingervalley(finger_remove(1:find(finger_remove, 1, 'last')))=[];
    
    % find the fingertips of the hand
%     length=find(fingervalley, 1, 'last');
%     if(length==1)
%         fingervalley=[1,fingervalley(1),find(degree,1,'last')];
%     end
    length=find(fingervalley, 1, 'last');
    fingertip=zeros(1,5);
    for i=1:length
        if(i==length)
            [a,index]=max(norm_distance(fingervalley(i):find(degree,1,'last')));
        else
            [a,index]=max(norm_distance(fingervalley(i):fingervalley(i+1)));
        end
        fingertip(i)=fingervalley(i)+index-1;
    end
    
    %remove invalid fingertip
    length=find(fingertip,1,'last');
    fingertip_max=max(norm_distance(fingertip(1:length)));
    fingertip(norm_distance(fingertip(1:length))<0.52*fingertip_max)=[];
    
    %find the accurate positions of the edges of fingers
    length=find(fingertip,1,'last');
    fingeredge=zeros(1,2*length);
    degree_dist=0;
    fingervalley(length+1)=find(degree,1,'last');
    for i=1:length
        index=fingertip(i)-1;
        while(true)
            [a,index1]=min(abs(norm_distance(fingertip(i):fingervalley(i+1))-norm_distance(index)));
            index1=fingertip(i)+index1-1;
            degree_dist1=degree(index1)-degree(index);
            if((length==1&&norm_distance(index1)<0.4*norm_distance(fingertip(i))&&degree_dist~=0&&degree_dist1>1.01*degree_dist)||index==fingervalley(i))
                break;
            elseif((norm_distance(index1)<0.5*norm_distance(fingertip(i))&&norm_distance(index1)<1.05*(max([norm_distance(fingervalley(i)),norm_distance(fingervalley(i+1))]))&&degree_dist~=0&&degree_dist1>1.01*degree_dist)||index==fingervalley(i))
                break;
            end
            degree_dist=degree_dist1;
            index=index-1;
        end
        fingeredge([2*i-1,2*i])=[index,index1];
    end
    
    %narrow down the first and last finger
    length=find(fingertip,1,'last');
    flag1=1;
    flag2=1;
    if(length>1)
        fingeredge_temp1=fingeredge(2);
        fingeredge_temp2=fingeredge(end-1);
        norm_distance_start=norm_distance(fingeredge(1));
        norm_distance_end=norm_distance(fingeredge(end));
        while(true)
            if(degree(fingeredge(end))-degree(fingeredge(end-1))>0.07)%flag2&&degree(fingeredge(end))-degree(fingeredge_temp2)>0.07
                fingeredge_temp2=fingeredge_temp2+1;
                [a,index]=min(abs(norm_distance(fingertip(length):fingeredge(end))-norm_distance(fingeredge_temp2)));
                fingeredge(end)=fingertip(length)+index-1;
            else
                if(norm_distance(fingeredge(end))>1.2*norm_distance_end)
                    
                flag2=0;
            end
            if(degree(fingeredge(2))-degree(fingeredge(1))>0.07)%flag1&&degree(fingeredge_temp1)-degree(fingeredge(1))>0.07
                fingeredge_temp1=fingeredge_temp1-1;
                [a,index]=min(abs(norm_distance(fingeredge(1):fingertip(1))-norm_distance(fingeredge_temp1)));
                fingeredge(1)=fingeredge(1)+index-1;
            else
                flag1=0;
            end
            if(~(flag1||flag2))
                break;
            end
        end
    else
        fingeredge_temp=fingeredge(1);
        while(true)
            if(degree(fingeredge(end))-degree(fingeredge(1))>0.08)
                fingeredge_temp=fingeredge_temp+1;
                [a,index]=min(abs(norm_distance(fingertip(1):fingeredge(end))-norm_distance(fingeredge_temp)));
                fingeredge(end)=fingertip(1)+index-1;
                fingeredge(1)=fingeredge_temp;
            else
                break;
            end
        end
    end
    


%     length=find(fingertip, 1, 'last');
%     finger_max=max(norm_distance(fingertip(1:length)));
%     fingertip(norm_distance(fingertip(1:length))<0.73*finger_max)=[];
%     
%     n=1;
%     length=find(fingertip,1,'last');
%     finger_remove=zeros(1,length);
%     for i=1:length-1
%         finger_valley=min(norm_distance(fingertip(i):fingertip(i+1)));
%         if(finger_valley>0.6*mean([norm_distance(fingertip(i)),norm_distance(fingertip(i+1))]))
%             if(norm_distance(fingertip(i))<norm_distance(fingertip(i+1)))
%                 finger_remove(n)=i;
%             else
%                 finger_remove(n)=i+1;
%             end
%         end
%     end
%     length=find(finger_remove,1,'last');
%     fingertip(finger_remove(1:length))=[];
end
