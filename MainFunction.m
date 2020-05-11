%% Event-driven Simulator

% Dynamic Simuation for a range of Load.
% It consists of 2 classes. 1 - Doubly-Linked list Node. 2 - Events.
% Doubly-Linked list Node's objects are used to Implement Queue [Doubly - link List]
% Events's objects are used to handle all info of a event [Request].
% TimeInstant field of objects of Events class stores the time at which requests in Queue must be served
% Therefore, TimeInstant can be Arrival time or Departure time of a Request.
% If EventType field of event == 1 -> Arrival Type
% If EventType field of event == 0 -> Departure Type

% Observations are taken when "clock > 6* Average holding time" to make sure 
% Network is in steady state. 

%% clear workspace
clc;
clear;
close all;

%% Initializing some parameters

No_of_iterations =10;                           % Repeating the whole simulation for "No_of_iterations" times and then Averaging them.

%% defining "optical_network" 
% Any network can be written in matrix form (as shown below). You can save
% this matix and then load this file while doing simulations as its been
% done in next instruction.

% optical_network =[ inf  1  inf inf  2  inf;  % declaring network graph
%                     1  inf  5  inf inf  3
%                    inf  5  inf  4  inf  4
%                    inf inf  5  inf  6  inf
%                     2   inf inf 6  inf  3  
%                    inf  3   4  inf  3  inf ];
%%
load('nsf_network');                           % Loading Network topology [Its in form of Matrix]
Total_nodes = size(optical_network,1);         % Total number of Nodes in network
Total_wavelength = 15;                         % Total number of Wavelengths

% Since Network is static, we can Avoid calling Dijkstra fn for every event, we store ROUTE of every S-D
% pair possible in Network in the below data structure [Structure]. This data 
% structure is a kind of inbuilt class in MATLAB and its field [property] 
% 'StoredPath' is used to store Routes of every distinct S-D pair.

Routes(Total_nodes,Total_nodes).StoredPath = []; 

lambda_1 = 20:20:100;                           % Average Arrival-rate (Poisson process)
mu_1 = ones([1 length(lambda_1)]);             % This array contains 1/mu values [Average-holding time] (Exponential probability distribution)

a = zeros(No_of_iterations,length(lambda_1));  % Initializing matrix to store Blocking Probabilities for every load in the ith iteration row


%% Starting Simuations.

for z= 1:No_of_iterations                      % Loop to repeat whole simulation 'No_of_iterations' times.
    disp(z);
    
    for m= 1:length(lambda_1)                  % Loop to find Blocking Probability for different 'Lambda' values
        disp(m);
        
        lambda = lambda_1(m);                                    % Average arrival Rate 
        mu = mu_1(m);                                            % Average holding time 
        
        blocked_requests = 0;                                    % Statistical Counter to count blocked requests
        Spectrum_Status = zeros(Total_nodes,Total_nodes,Total_wavelength); % Initializing a matrix to store the status of each frequecy slices of every Link in the network.
        AH_Overall_request_number = 0;                           % Total number of request arrivals in steady state
        Served_request_number = 0;                               % Total number of unblocked requests (i.e Served)
        clock = 0;                                               % Clock thet sweeps from '0' to 'Simulation_time'. It jumps to the next-event time.
        
        
        %% Queue [Implemented as Double Linked List] - it store all the Request that are to be served
        
        Head = DoubleLinkedListNode(1);                          % Head's Next field will store the adress of 1st request in the Queue.
        
        % Creating Event per node as per their Arrival rate [Lambda]
        for temp1 = 1:Total_nodes
            Event = Events;                                      % Event is the object of Events class
            Event.TimeInstant = GetArrivalTime(lambda,clock);    % Arrival time is calculated using Poisson Process [Acc to respective Lambda]
            NewNode = DoubleLinkedListNode(Event);               % NewNode is object of DoubleLinkedListNode, Data field is initialized with Event while other fields kept empty.
            Head =  InsertEvent(NewNode,Head);                   % Inserting NewNode in the Queue making sure the sortedness of Queue         
            Event.Source = temp1;                                % Assigning which node's event it is.
            Event.EventType = 1;                                 % EventType is 1 shows this event is of Arrival type. 
        end
        
       %% Main Simulation starts from here
        
        while blocked_requests < 1000                           % To get good Blocking Probability observation, atleast 100 connections should be blocked
            
            clock = Head.Next.Data.TimeInstant;                  % clock is jumped to 1st event's TimeInstant in the Queue
            CurrentEvent = Head.Next.Data;                       % So this event is to be served now. Node's Data field is taken into CurrentEvent
            removeNode(Head.Next);                               % Removing 1st event from the Queue
            
            if  CurrentEvent.EventType == 1                      % The event belongs to Arrival Type
                
        %% Creating new Event [As per Lambda] at the source where CurrentEvent belongs.
                NewArrivalEvent = Events;
                NewArrivalEvent.TimeInstant = GetArrivalTime(lambda,clock);
                NewArrivalEvent.Source = CurrentEvent.Source;
                NewArrivalEvent.EventType =1;                                   
                NewNode = DoubleLinkedListNode(NewArrivalEvent);
                Head =  InsertEvent(NewNode,Head);
        
        %% The Blocking probility is calculated when network is in steady state. So we'll wait for 6 times the Average holding time before we take any observation.        
        % When Network is in steady state, we start counting No of events arrived in 'AH_Overall_request_number'.
                
                if clock > 6*mu                                  % when clock is greater than 6 times average holding time. 
                    AH_Overall_request_number = AH_Overall_request_number + 1;
                end
                
        %%
                Source = CurrentEvent.Source;                    % CurrentEvent's Source
                CurrentEvent.GetItsDestination(Total_nodes);     % CurrentEvent's Destination
                Destination = CurrentEvent.Destination;          
                
                % This loop makes sure Destination node chosen for this event is not same as Source node
                while Source == Destination              
                    CurrentEvent.GetItsDestination(Total_nodes);
                    Destination = CurrentEvent.Destination;
                end
                
                CurrentEvent.GetItsBandwidth;                    % CurrentEvent's Bandwidth
                
                
                
                % This block avoids calling Dijkstra function again if the event with same S-D pair served earlier
                if  isempty(Routes(Source,Destination).StoredPath)
                    CurrentEvent.GetItsRoute(optical_network,Source,Destination);  % CurrentEvent's Route is decided based on Dijkstra Algorithm [shortest path]
                    Routes(Source,Destination).StoredPath = CurrentEvent.Route;
                else
                    CurrentEvent.Route = Routes(Source,Destination).StoredPath;        % Route is extracted from 'Routes' Data structure
                end
                
        %%  Checking Resource's availability (FOR SPECTRUM ALLOCATION)
                
                NoOfNodes = length(CurrentEvent.Route);                            % Total no of nodes in this event's route.
                [flag1, WavelengthIndexes] = ResourcesChecking(CurrentEvent.Bandwidth,NoOfNodes , Spectrum_Status, CurrentEvent.Route, Total_wavelength);
                
                if flag1                                                           % Here, flag1 =1 [Indicator of Resource's availability].
                    % When network is in steady state, we'll start counting blocked_requests
                    if clock > 6                                                   % When clock is greater than 6 times average holding time. 
                        blocked_requests = blocked_requests + 1;
                    end
                else                                                               % Here, flag1 =0
                        CurrentEvent.WavelengthIndex = WavelengthIndexes;
                end
                
         %% Setup connection (i.e marking corresponding FS as BUSY )
                
                if flag1 == 0                                                      % Event will be served here if flag1 =0
                    [Spectrum_Status] = SetupConnection(NoOfNodes, WavelengthIndexes,CurrentEvent.Route,CurrentEvent.Bandwidth, Spectrum_Status);
                end
                
         %% If Current Event is not blocked [i.e can be served], It's closure event will be created [i.e Departure type] 
                
                if flag1 ==0   
                    CurrentEvent.EventType =0;                                     % EventType field is '0' ensuring it is of Departure type
                    CurrentEvent.TimeInstant = GetReleaseTime(mu,clock);
                    NewNode = DoubleLinkedListNode(CurrentEvent);
                    Head =  InsertEvent(NewNode,Head);
                    
                end
                
                
            else                                                                   % The Current event belongs to Departure Queue
                
         %% RELEASING REQUESTS [according to their HOLDING time]
                
                WavelengthIndexesArray = CurrentEvent.WavelengthIndex;
                Route = CurrentEvent.Route;
                HopIndex = 1;
                
                TotalHops = length(CurrentEvent.Route)-1;
                for HopIndex = 1 : TotalHops
                    Wavelength = WavelengthIndexesArray(HopIndex);
                    while Wavelength < WavelengthIndexesArray(HopIndex) + CurrentEvent.Bandwidth
                        Spectrum_Status(Route(HopIndex), Route(HopIndex + 1), Wavelength) = 0;
                        Wavelength = Wavelength + 1;
                    end
                    
                end
                
                
            end
            
        end
        
         %% Calculating Blocking Probability
        blocking_probability(m) = (blocked_requests)/AH_Overall_request_number;    % Blocking probability for particular lambda 
        a(z,m) = blocking_probability(m);                                          % Storing blocking probabilities in a matrix
        
    end
end

load = lambda_1.*mu_1;                                                             % Load is product of 'Average Arrival rate' and 'Average service time'
finalBP = sum(a);                                                                  % It sums up 'No_of_iterations' Blocking probabilities corresponding to every load value                           
finalBP = finalBP./No_of_iterations;                                               % Averaging them out
plot(load,finalBP);
xlabel('Traffic Load');
ylabel('Blocking Probability');
title('WDM Network');







