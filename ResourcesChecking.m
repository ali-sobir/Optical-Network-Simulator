function [flag1, WavelengthIndexes] = ResourcesChecking(request_demand, total_nodes, Links, shortestPaths, No_of_FS )


Rth_link = 1; %  'Rth_link' gives link no. out of 't' links
Rth_FS_index_link_1 = 1; % 'Rth_FS_index_link_1' gives lowest index of available contiguous FS equal to reqest's demand.
contigous_FS = 0; % counts no. of contigous FS available to satisfy request's demand.
flag1= 0;
WavelengthIndexes =1;
% this WHILE BLOCK checks the availability for required FS demand on each link
while (Rth_link<total_nodes)
    
    % this IF BLOCK is checking availibility from 2nd link onwards
    if Rth_link>1
        Rth_FS_index_next_links = Rth_FS_index_link_1;
        
        % this WHILE BLOCK checks availibility of FS on next links with same index as on 1st link
        while (Rth_FS_index_next_links < Rth_FS_index_link_1 + request_demand)
            
            % [IF BLOCK] if any of the same indexed FS on next links is found busy in serving request, resources availability is checked again from 1st link onwards
            if Links(shortestPaths(Rth_link),shortestPaths(Rth_link+1),Rth_FS_index_next_links) == 1
                Rth_link = 0;
                Rth_FS_index_link_1 = 1 + Rth_FS_index_next_links; %  avoids checking availability on 1st link from 0 index
                break
                
                % [ELSE BLOCK] if same index FS is available, next index in checked
            else
                Rth_FS_index_next_links = Rth_FS_index_next_links+1;
            end
            
        end
        
        % this ELSE BLOCK is checking availibility on 1st link
    else
        % [WHILE BLOCK] checks whether required FS are available on 1st link
        while (Rth_FS_index_link_1<No_of_FS+1)
            if Links(shortestPaths(Rth_link),shortestPaths(Rth_link+1),Rth_FS_index_link_1) == 1
                Rth_FS_index_link_1 = Rth_FS_index_link_1+1;
                contigous_FS = 0;
            else
                contigous_FS = contigous_FS+1;
                Rth_FS_index_link_1 = Rth_FS_index_link_1+1;
            end
            
            % it checks if required FS are available on 1st link or not
            if contigous_FS == request_demand
                Rth_FS_index_link_1 = Rth_FS_index_link_1 - request_demand;
                WavelengthIndexes = Rth_FS_index_link_1 *ones([1 total_nodes-1]);
                break
            end
            
        end
        
        % it increments blocked_requests if enough FS are not available
        % on 1st link
        if contigous_FS ~= request_demand
            flag1 = 1;
            WavelengthIndexes = [];
            return
        end
        contigous_FS = 0;
    end
    Rth_link = Rth_link+1; % FS's availability on next link
end

