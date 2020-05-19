function [flag, WavelengthIndexes] = ResourcesChecking(BW, total_nodes, Links, shortestPaths, No_of_FS )

%   TotalHops = total_nodes -1;
%   Links : Spectrum status
%   request_demand : request's BW
%   No_of_FS : Total Frequency Slice/wavelength available on each link.
%   FS : Frequency Slice.

%%
HopNumber = 1;
FSindexOnFirstHop = 1;
contigous_FS = 0;
flag= 0;
WavelengthIndexes =1;

while (HopNumber < total_nodes)                                                                         % WHILE loop checks resource's availability on every HOP.
    
    if HopNumber == 1
        
        while (FSindexOnFirstHop < No_of_FS+1)                                                          % WHILE loop checks availability on 1st hop.
            if Links(shortestPaths(HopNumber),shortestPaths(HopNumber+1),FSindexOnFirstHop) == 1
                FSindexOnFirstHop = FSindexOnFirstHop+1;
                contigous_FS = 0;
            else
                contigous_FS = contigous_FS+1;
                FSindexOnFirstHop = FSindexOnFirstHop+1;
            end
            
            
            if contigous_FS == BW                                                                       % it checks if required Resources are available on 1st hop or not
                FSindexOnFirstHop = FSindexOnFirstHop - BW;
                WavelengthIndexes = FSindexOnFirstHop *ones([1 total_nodes-1]);
                break
            end
        end
        
        if contigous_FS ~= BW                                                                           % Enough Resources aren't available on 1st hop.
            flag = 1;
            WavelengthIndexes = [];
            return
        end
        contigous_FS = 0;                                                                            % If we again need to check resources on this HOP then we'll need this.
                                                                                                     %  [If continuity constraint don't meet, then we'll need to check availability on this HOP.]
        
    else                                                                                             % If HopNumber is >1.
        FSindexOnOtherHops = FSindexOnFirstHop;
        
        while (FSindexOnOtherHops < FSindexOnFirstHop + BW)                                          % 'WHILE' loop checks availibility on 2nd, 3rd HOPS and so on with same index as on 1st HOP.
            
             % [IF BLOCK] if any of the same indexed FS on next hops is found busy, resources availability is checked again from 1st hop
            if Links(shortestPaths(HopNumber),shortestPaths(HopNumber+1),FSindexOnOtherHops) == 1
                HopNumber = 0;
                FSindexOnFirstHop = 1 + FSindexOnOtherHops;                                          %  avoids checking availability on 1st link from 0 index
                break
                
            else                                                                                     % [ELSE BLOCK] if same index FS is available, next index in checked
                FSindexOnOtherHops = FSindexOnOtherHops+1;
            end
            
        end
        
    end
    HopNumber = HopNumber + 1;                                                                        % Now, Resources'll be checked on next hops
end
end


