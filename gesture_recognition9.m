% clear;
names=char('0305-11','0305-12','0305-31','0305-32','0305-41','0305-42','0305-51','0305-52','0305-111','0305-112','0305-151','0305-152','0305-161','0305-162','0314-01','0314-02','0314-11','0314-12','0314-21','0314-22','0314-31','0314-32','0314-41','0314-42','0314-61','0314-62','0314-81','0314-82','0314-91','0314-92','0327-11','0327-12','0327-21','0327-22','0327-31','0327-32','0327-41','0327-42','0327-132','0327-141','0327-142','0717-11','0717-12','0717-21','0717-22','0717-31','0717-32','0717-41','0717-42','0717-51','0717-52','0717-61','0717-62','0717-71','0717-72','0717-81','0717-82','0717-91','0717-92','0717-101','0717-102','0717-111','0717-112','0717-121','0717-122','0717-131','0717-132','0717-141','0717-142','0717-151','0717-152','0717-161','0717-162','0717-171','0717-172','0717-181','0717-182','0717-191','0717-192','0717-201','0717-202','0717-211','0717-212','0717-221','0717-222','0717-231','0717-232','0717-241','0717-242','0717-251','0717-252','0717-261','0717-262','0717-271','0717-272','0717-281','0717-282','0717-291','0717-292','0717-301','0717-302','0717-311','0717-312','0717-341','0717-342','0717-351','0717-352','0717-361','0717-362','0717-371','0717-372','0717-381','0717-382','0717-391','0717-392','0717-401','0717-402','0717-421','0717-422','0717-431','0717-432','0717-441','0717-442');
for image_index=63
    length=(sum(names(image_index,:)==' ')==1)*7+(sum(names(image_index,:)==' ')==0)*8;
    load(['hand1\',names(image_index,1:length),'.mat']);
    % load('E:\Document\Goer\Essay\Çå»ª\Kay''s code\hand\hand36.mat');
    if(exist('dis1_d2_e2','var'))
        image=dis1_d2_e2;
    elseif(exist('dis2_d2_e2','var'))
        image=dis2_d2_e2;
    end
    row=size(image,1);
    colum=size(image,2);
    binary_map=zeros(size(image));
    binary_map(image>0)=1;
    %% ----find the edge points---- %%
    edge_map=edge_finder(binary_map,row,colum);
    %% ----connect the edge points---- %%
    [x_array,y_array]=edge_connector(edge_map,row,colum);
    %% ----find the center point---- %%
    [x_center,y_center]=center_finder(edge_map,binary_map,x_array,y_array);
    %% ----detect the direction---- %%
    direction_angle=direction_detector1(x_array,y_array);
    x_line=zeros(1,row);
    y_line=(1:row);
    x_line(1:y_center)=x_center+round((y_center-(1:y_center))./tand(direction_angle));
    x_line(y_center+1:row)=x_center-round(((y_center+1:row)-y_center)./tand(direction_angle));
    %% ----find the start and end points---- %%
    [start_index,end_index]=start_end_points(x_array,y_array,x_center,y_center,direction_angle);
    x_start=x_array(start_index);
    y_start=y_array(start_index);
    x_end=x_array(end_index);
    y_end=y_array(end_index);
    %% ----transfer to polar graph---- %%
    [degree,norm_distance]=trans_graph1(x_array(start_index:end_index),y_array(start_index:end_index),x_center,y_center);
    %% ----find the region of fingers---- %%
    if(max(norm_distance)<1.5)
        disp(['figure',num2str(image_index)]);
        disp('fist');
        figure;
        imagesc(edge_map);
        continue;
    else
        [fingervalley,fingertip]=finger_finder2(degree,norm_distance);
    end
    %% ----find the fingerroots---- %%
    length=size(fingertip,2);
    fingeredge=zeros(1,2*length);
    for i=1:length
        fingeredge_start=start_index+fingervalley(i)-1;
        fingeredge_end=start_index+fingervalley(i+1)-1;
        direction_angle=direction_detector3(x_array,y_array,start_index+fingertip(i)-1,[fingeredge_start,fingeredge_end]);
        firstTime=1;
        k=1;
        while(true)
            [fingeredge_start,fingeredge_end]=finger_finder3(x_array,y_array,fingertip(i),[fingeredge_start,fingeredge_end],direction_angle,start_index);
            direction_angle=direction_detector3(x_array,y_array,start_index+fingertip(i)-1,[fingeredge_start,fingeredge_end]);
            imagesc(edge_map);
            hold on;
            x_line1=zeros(1,row);
            x_line1(1:y_array(start_index+fingertip(i)-1))=x_array(start_index+fingertip(i)-1)+round((y_array(start_index+fingertip(i)-1)-(1:y_array(start_index+fingertip(i)-1)))./tand(direction_angle));
            x_line1(y_array(start_index+fingertip(i)-1)+1:row)=x_array(start_index+fingertip(i)-1)-round(((y_array(start_index+fingertip(i)-1)+1:row)-y_array(start_index+fingertip(i)-1))./tand(direction_angle));
            plot(x_line1,y_line);
            plot([x_array(fingeredge_start),x_array(fingeredge_end)],[y_array(fingeredge_start),y_array(fingeredge_end)],'r*');
            if(firstTime)
                firstTime=~firstTime;
                area_percent=zeros(min([start_index+fingertip(i)-1-fingeredge_start,fingeredge_end-start_index-fingertip(i)+1]),1);
%                 fingerroots=zeros(min([start_index+fingertip(i)-1-fingeredge_start,fingeredge_end-start_index-fingertip(i)+1]),2);
                P=[y_array(start_index+fingertip(i)-1),x_array(start_index+fingertip(i)-1)];
                Q=[P(1)+10,P(2)-10/tand(direction_angle)];
                dist=zeros(1,fingeredge_end-fingeredge_start+1);
                dist_start=fingeredge_start;
                n=1;
                for j=fingeredge_start:fingeredge_end
                    dist(n)=abs(det([P-Q;[y_array(j),x_array(j)]-Q]))/norm(P-Q);
                    n=n+1;
                end
            end
            Q1=[y_array(fingeredge_start),x_array(fingeredge_start)];
            Q2=[y_array(fingeredge_end),x_array(fingeredge_end)];
            length=max(dist(fingeredge_start-dist_start+1:start_index+fingertip(i)-dist_start))+max(dist(start_index+fingertip(i)-dist_start:fingeredge_end-dist_start+1));
            height=abs(det([Q2-Q1;P-Q1]))/norm(Q2-Q1);
            area=length*height;
            
            finger_area=0;
            finger_top=min(y_array(fingeredge_start:fingeredge_end));
            up=min(y_array([fingeredge_start,fingeredge_end]));
            low=max(y_array([fingeredge_start,fingeredge_end]));
            for j=finger_top:1:low
                if(j<=up)
                    x=x_array(fingeredge_start+find(j==y_array(fingeredge_start:fingeredge_end))-1);
                    finger_area=finger_area+max(x)-min(x)+1;
                else
                    if(up==y_array(fingeredge_end))
                        x=x_array(fingeredge_end)+(x_array(fingeredge_end)-x_array(fingeredge_start))/(up-low)*(j-up);
                        finger_area=finger_area+x-min(x_array(fingeredge_start+find(j==y_array(fingeredge_start:fingeredge_end))-1))+1;
                    else
                        x=x_array(fingeredge_start)+(x_array(fingeredge_start)-x_array(fingeredge_end))/(up-low)*(j-up);
                        finger_area=finger_area+max(x_array(fingeredge_start+find(j==y_array(fingeredge_start:fingeredge_end))-1))-x+1;
                    end
                    
                end
            end
            area_percent(k)=finger_area/area;
%             fingerroots(k,:)=[fingeredge_start,fingeredge_end];
            if(area_percent(k)>0.6||(fingeredge_start>start_index+fingertip(i)-1||fingeredge_end<start_index+fingertip(i)-1))
                fingeredge([2*i-1,2*i])=[fingeredge_start,fingeredge_end];
                break;
            end
            k=k+1;
        end
    end
    %% ----find the start and end points again---- %%
%     [start_index,end_index]=start_end_points(x_array,y_array,x_center,y_center,direction_angle1);
%     x_start1=x_array(start_index);
%     y_start1=y_array(start_index);
%     x_end1=x_array(end_index);
%     y_end1=y_array(end_index);
    %% ----transfer to polar graph again---- %%
%     [degree,norm_distance]=trans_graph1(x_array(start_index:end_index),y_array(start_index:end_index),x_center,y_center);
    %% ----find the region of fingers again---- %%
%     [fingeredge,fingertip]=finger_finder1(degree,norm_distance);
    %% ----recognize the hand---- %%
%     fingeredge_pos=[0.0146337246580488,0.0745627290901638,0.139065841518239,0.203921402368815,0.222327352013204,0.276706742776597,0.290740936319473,0.339176702348911,0.366791637913254,0.429338507398574];
%     fingeredge_var=[0.000136991948716690,0.000612701660560093,0.000403083795722937,0.000261988990173902,0.000204718582808144];
%     length=find(fingertip,1,'last');
%     variance=zeros(1,5);
%     finger_index=zeros(1,length);
%     for i=1:length
%         for j=1:5
%             variance(j)=pdist([fingeredge_pos([2*j-1,2*j]);degree(fingeredge([2*i-1,2*i]))],'euclidean');
%         end
%         [a,index]=min(variance);
%         finger_index(i)=index;
%     end
%     switch(length)
%         case 1
%             variance=variance./fingeredge_var;
%         case 4
%             for i=1:5
%                 finger_index=1:10;
%                 finger_index([2*i-1,2*i])=[];
%                 variance(i)=pdist([fingeredge_pos(finger_index);degree(fingeredge)],'euclidean');
%             end
%     end
%     [a,index]=min(variance);
%     if(length==4)
%         finger_index=1:5;
%         finger_index(index)=[];
%     elseif(length==1)
%         finger_index=index;
%     end
% 
%     disp(['figure',num2str(image_index)]);
%     for i=1:find(finger_index,1,'last')
%         disp(num2str(finger_index(i)));
%     end
    %% ----draw graph---- %%
    figure;
    axis equal;
    imagesc(edge_map);
    hold on;
    plot(x_array(start_index+fingertip-1),y_array(start_index+fingertip-1),'r^');
    plot(x_array(fingeredge),y_array(fingeredge),'ro');
    for i=1:size(fingertip,2)
        up=min(y_array([fingeredge(2*i-1),fingeredge(2*i)]));
        low=max(y_array([fingeredge(2*i-1),fingeredge(2*i)]));
        x=zeros(low-up+1);
        for j=up:low
            if(up==y_array(fingeredge(2*i)))
                x(j-up+1)=x_array(fingeredge(2*i))+(x_array(fingeredge(2*i))-x_array(fingeredge(2*i-1)))/(up-low)*(j-up);
            else
                x(j-up+1)=x_array(fingeredge(2*i-1))+(x_array(fingeredge(2*i-1))-x_array(fingeredge(2*i)))/(up-low)*(j-up);
            end
        end
        if(up==low)
            plot(x_array(fingeredge(2*i-1)):x_array(fingeredge(2*i)),up,'r-');
        end
        plot(x,up:low,'r-');
    end

    if(exist('dis1_d2_e2','var'))
        clear dis1_d2_e2;
    elseif(exist('dis2_d2_e2','var'))
        clear dis2_d2_e2;
    end
end