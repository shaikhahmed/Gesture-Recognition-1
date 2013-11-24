function [fingervalley,fingertip]=finger_finder2(degree,norm_distance)
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
    
    fingervalley(fingervalley==0)=[];
    fingertip(fingertip==0)=[];
    if(size(fingervalley,2)~=size(fingertip,2)+1)
        if(fingervalley(1)<fingertip(1))
            fingervalley=[fingervalley,size(degree,2)];
        else
            fingervalley=[1,fingervalley];
        end
    end
end