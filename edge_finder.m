function edge_map=edge_finder(binary_map,row,colum)
    edge_map=zeros(size(binary_map));
    edge_direction=zeros(size(binary_map));
    for i=1:row
        j=1;
        while(true)
            if(j==colum+1)
                break;
            elseif(i~=1&&j~=1&&i~=row&&j~=colum)
                if(xor(binary_map(i,j),binary_map(i,j+1)))
                    if(edge_map(i,j+binary_map(i,j+1))==1&&(edge_direction(i,j+binary_map(i,j+1))==1||edge_direction(i,j+binary_map(i,j+1))==3))%����ȥ����101ͼ�еĹ���������
                        edge_map(i,j+binary_map(i,j+1))=0;
                        edge_direction(i,j+binary_map(i,j+1))=0;
                        binary_map(i,j+binary_map(i,j+1))=0;
                        continue;
                    else
                        edge_map(i,j+binary_map(i,j+1))=1;
                        edge_direction(i,j+binary_map(i,j+1))=edge_direction(i,j+binary_map(i,j+1))+1;
                    end
                end
                if(xor(binary_map(i,j),binary_map(i+1,j)))
                    if(edge_map(i+binary_map(i+1,j),j)==1&&(edge_direction(i+binary_map(i+1,j),j)==2||edge_direction(i+binary_map(i+1,j),j)==3))
                        edge_map(i+binary_map(i+1,j),j)=0;
                        binary_map(i+binary_map(i+1,j),j)=0;
                        if(binary_map(i+binary_map(i+1,j),j-1))
                            j=j-1;
                        end
                        edge_direction(i+binary_map(i+1,j),j)=0;
                        continue;
                    else
                        edge_map(i+binary_map(i+1,j),j)=1;
                        edge_direction(i+binary_map(i+1,j),j)=edge_direction(i+binary_map(i+1,j),j)+2;
                    end
                end
            else
                if(binary_map(i,j))
                   edge_map(i,j)=1;
                end
            end
            j=j+1;
        end
    end
end