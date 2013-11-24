function [x_array,y_array]=edge_connector(edge_map,row,colum)
    edge_map(row+1,:)=0;
    edge_map(:,colum+1)=0;
    % [y_origin,x_origin]=ind2sub(size(edge_map),min(find(edge_map)));
    [y_index,x_index]=find(edge_map==1);
    [y_origin,index]=max(y_index);
    x_origin=min(x_index(index));
    x_array=zeros(1,sum(sum(edge_map)));
    y_array=zeros(1,sum(sum(edge_map)));
    x_array(1)=x_origin;
    y_array(1)=y_origin;
    i=1;

    while(1)
        x_present=x_array(i);
        y_present=y_array(i);
        i=i+1;
        if(sum(sum(edge_map(y_present-1:y_present,x_present-1:x_present)))>1)%top left direction
            if(edge_map(y_present-1,x_present))%top
                x_array(i)=x_present;
                y_array(i)=y_present-1;
            elseif(edge_map(y_present,x_present-1))%left
                x_array(i)=x_present-1;
                y_array(i)=y_present;
            else%top_left
                x_array(i)=x_present-1;
                y_array(i)=y_present-1;
            end
        elseif(sum(sum(edge_map(y_present-1:y_present,x_present:x_present+1)))>1)%top right direction
            if(edge_map(y_present-1,x_present))%top
                x_array(i)=x_present;
                y_array(i)=y_present-1;
            elseif(edge_map(y_present,x_present+1))%right
                x_array(i)=x_present+1;
                y_array(i)=y_present;
            else%top_right
                x_array(i)=x_present+1;
                y_array(i)=y_present-1;
            end
        elseif(sum(sum(edge_map(y_present:y_present+1,x_present:x_present+1)))>1)%bottom_right direction
            if(edge_map(y_present+1,x_present))%bottom
                x_array(i)=x_present;
                y_array(i)=y_present+1;
            elseif(edge_map(y_present,x_present+1))%right
                x_array(i)=x_present+1;
                y_array(i)=y_present;
            else%bottom_right
                x_array(i)=x_present+1;
                y_array(i)=y_present+1;
            end
        elseif(sum(sum(edge_map(y_present:y_present+1,x_present-1:x_present)))>1)%bottom_left direction
            if(edge_map(y_present+1,x_present))%bottom
                x_array(i)=x_present;
                y_array(i)=y_present+1;
            elseif(edge_map(y_present,x_present-1))%left
                x_array(i)=x_present-1;
                y_array(i)=y_present;
            else%bottom_left
                x_array(i)=x_present-1;
                y_array(i)=y_present+1;
            end
        else
            break;
        end
        edge_map(y_present,x_present)=0;
    end
    x_array(x_array==0)=[];
    y_array(y_array==0)=[];
end