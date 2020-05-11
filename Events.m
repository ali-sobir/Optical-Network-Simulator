% 'Events' is a class with some properties inherited from 'handle' super-class. 
% Every connection request is an instance[object] of 'Events' class. Whose fields store connection request's attribute. 
% It's Every field [property] corresponds to the every other attribute of connection request.
% It's Methods are ways to fill its fields with their corresponding values.



classdef  Events  < handle
    properties
        Source           % Event's Source
        Destination      % Event's Destination
        Bandwidth        % It shows how many Wavelengths of Frequecy slices are asked from Event
        Route            % It stores the path from given Source to given Destination
        WavelengthIndex  % If it is vector, each element represent Wavelength index (to be given to en Event) on corresponding link
        TimeInstant      % Time at which Event is suppose to get served (It can be of Arriva-time or Departure-time)
        EventType        % It is of Arrival type if it is '1' otherwise Departure type
    end
    
    methods
        function GetItsSource(Object,Total_nodes)
            Object.Source = randi([1 Total_nodes], 1,1);
        end
        
        function GetItsDestination(Object,Total_nodes)
            Object.Destination = randi([1 Total_nodes], 1,1);
        end
        
        function GetItsBandwidth(Object)
            Object.Bandwidth = 1;
            %Object.Wavelength = unidrnd(4);
        end
        
        function GetItsRoute(Object,network,Source,Destination)
            Object.Route = ROUTING_dijkstra(network,Source,Destination);
           
        end
        
        function GetItsWavelengthIndexes(Object,WavelengthIndexes)
            Object.WavelengthIndex = WavelengthIndexes;
        end
        
        function GetItsType(Object, temp)
            Object.EventType = temp;                                           % temp is 1 or 0 depending on event is arrival or departure
        end
        
    end
end