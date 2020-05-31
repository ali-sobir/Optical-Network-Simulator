function [flag, WavelengthIndexes] = ResourcesChecking_SimpleFullPlacement1(BW, total_nodes, Links, shortestPaths, No_of_FS )

%   TotalHops = total_nodes -1;
%   Links : Spectrum status
%   request_demand : request's BW
%   No_of_FS : Total Frequency Slice/wavelength available on each link.
%   FS : Frequency Slice.

%%
flag= 0;
WavelengthIndexes =1;

for HopNumber = 1:total_nodes-1                           
        FSindex = 1;
        contigous_FS = 0;
        while (FSindex < No_of_FS+1)                                                          % WHILE loop checks availability on 1st hop.
            if Links(shortestPaths(HopNumber),shortestPaths(HopNumber+1),FSindex) == 1
                FSindex = FSindex+1;
                contigous_FS = 0;
            else
                contigous_FS = contigous_FS+1;
                FSindex = FSindex+1;
            end
            
            
            if contigous_FS == BW                                                                       % it checks if required Resources are available on 1st hop or not
                FSindex = FSindex - BW;
                WavelengthIndexes(HopNumber) = FSindex; 
                break
            end
        end
        
        if contigous_FS ~= BW                                                                           % Enough Resources aren't available on 1st hop.
            flag = 1;
            WavelengthIndexes = [];
            return
        end
end                                                                            % If we again need to check resources on this HOP then we'll need this.
                                                                                                     %  [If continuity constraint don't meet, then we'll need to check availability on this HOP.]
   

