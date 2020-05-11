function [Links] = EstablishingConnection(NoOfNodes, WavelengthIndexes, Route, Bandwidth, Links)

   
    
    r5 =1;
    while (r5<NoOfNodes)  % total_nodes is associated with no of hops
        r6 = WavelengthIndexes(r5);
        while (r6 < WavelengthIndexes(r5) + Bandwidth)
            Links(Route(r5),Route(r5+1),r6) = 1;
            r6 = r6+1;
        end
        r5 = r5+1;
    end

