%% Event-driven Optical Network Simulator

% Dynamic Simuations for a range of Load.

%% It consists of 3 classes. 1 - BST. 2 - BSTnode. 3 - Events.

% 1: BST's instance is used to implement Binary Search tree which help to handle
%    Requests that are yet to arrive and all the active connections.
% 
% 2: BSTnode's instance are the Tree-nodes that are inserted in Binary Search Tree.
%    These are inserted in Tree on the basis of TimeInstant field of Event.
% 
% 3: Events's instance contains all info of a Request.
%    These instances are stored in BSTnode's instance's field 'Data'.

%%   

%  TimeInstant field of Events's instance i.e Requests [Events is a class here] 
%  stores the time at which Requests in Queue must be served.
%  Therefore, TimeInstant can be Arrival time or Departure time of a Request.

% If EventType field of event == 1 -> Arrival Type [here event is a Request and is instance of Events class]
% If EventType field of event == 0 -> Departure Type

%% Transient and Steady state of Network.

% It is found that Network will be in Transient state  till 6*Average holdin time.
% Thereore, Observations are taken when "clock > 6* Average holding time" to make sure 
% Network is in steady state. 


%% clear workspace
clc;
clear;
%close all;

%% Initializing some parameters

No_of_iterations =2;                           % Repeating the whole simulation for "No_of_iterations" times and then Averaging them.

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
Total_wavelengths = 15;                        % Total number of Wavelengths

%   Since Network is static, we can Avoid calling Dijkstra fn for every time 
%   Request arrives, we store ROUTE of every S-D pair possible in Network in 
%   the below data structure [Structure]. This data structure is a kind of 
%   inbuilt class in MATLAB and its field [property] 'StoredPath' is used to 
%   store Routes of every distinct S-D pair.

Routes(Total_nodes,Total_nodes).StoredPath = []; 

LambdaArray = 50:40:400;                                                        % Average Arrival-rate (Poisson process)
AverageHoldingTimeArray = ones([1 length(LambdaArray)]);                        % [Average-holding time = 1/mu ] (Exponential probability distribution)

a = zeros(No_of_iterations,length(LambdaArray));                                % Initializing matrix to store Blocking Probabilities for every load in the ith iteration row
b = zeros(No_of_iterations,length(LambdaArray));  

%% Starting Simuations.

for z= 1:No_of_iterations                                                       % Loop to repeat whole simulation 'No_of_iterations' times.
    disp(z);
    
    for m= 1:length(LambdaArray)                                                % Loop to find Blocking Probability for different 'Lambda' values
        disp(m);temp100=0;
        clear Tree
        Lambda = LambdaArray(m);                                                % Average arrival Rate 
        AverageHoldingTime = AverageHoldingTimeArray(m);                        % Average holding time 
        
        blocked_requests = 0;                                                   % Statistical Counter to count blocked requests
        Spectrum_Status = zeros(Total_nodes,Total_nodes,Total_wavelengths);     % Initializing a matrix to store the status of each frequecy slices of every Link in the network.
        AH_Overall_request_number = 0;                                          % Total number of request arrivals in steady state
                                  
        Clock = 0;                                                              % Clock contains the TimeInstant of Request that is being Processed. It jumps to the next-event time.
        
        
        %% Queue [Implemented as Binar Search Tree] - it store all the Request that are to come and all active connections. 
        
        Tree = BST;                                                             % 'Tree' is the instance of BST class, Tree is the Binary Search Tree.
       
        % Creating 1 Event[ 1 Requests ] per node as per their Arrival rate [Lambda]
        for temp1 = 1:Total_nodes
            Event = Events;                                                     % Event [Event is a Request/Connection] is the object of Events class
            Event.TimeInstant = GetArrivalTime(Lambda,Clock);                   % Arrival time is calculated using Poisson Process [Acc to respective Lambda]
            NewNode = BSTnode(Event);                                           % NewNode is object of BSTnode, Data field is initialized with Event while other fields kept empty.
            [Tree] =  InsertEvent(Tree,NewNode);                                % Inserting NewNode in the Tree making sure the Tree remains Binary Search Tree.         
            Event.Source = temp1;                                               % Assigning node [node belongs to Network here] number, i.e the Request's Source.
            Event.EventType = 1;                                                % EventType is 1 shows this event is of Arrival type. 
        end
        
       %% Main Simulation starts from here
        
        while blocked_requests < 20000                                           % To get good Blocking Probability estimate, atleast 100 connections should be blocked.
              
             [LeftMostNode,Tree] =removeNode(Tree);                             % LeftMostNode [i.e the node with shortest TimeInstant value] is removed from Tree.
             CurrentEvent = LeftMostNode.Data;                                  % CurrentEvent [That is to be processed] is extracted from LeftMostNode.
             Clock = CurrentEvent.TimeInstant;                                  % Clock gets CurrentEvent's TimeInstant value.
                                        
            
            if  CurrentEvent.EventType == 1                                     % The event belongs to Arrival Type
                
        %% Creating new Event [As per Lambda] at the source where CurrentEvent belongs.
                NewArrivalEvent = Events;
                NewArrivalEvent.TimeInstant = GetArrivalTime(Lambda,Clock);
                NewArrivalEvent.Source = CurrentEvent.Source;
                NewArrivalEvent.EventType =1;                                   
                NewNode = BSTnode(NewArrivalEvent);
                Tree =  InsertEvent(Tree,NewNode);
        
        %% The Blocking probility is calculated when network is in steady state. So we'll wait for 6 times the Average holding time before we take any observation.        
        % When Network is in steady state, we start counting No of events arrived in 'AH_Overall_request_number'.
                
                if Clock > 20*AverageHoldingTime                                 % when clock is greater than 6 times average holding time. 
                    AH_Overall_request_number = AH_Overall_request_number + 1;
                end
                
        %%
                Source = CurrentEvent.Source;                                   % CurrentEvent's Source
                CurrentEvent.GetItsDestination(Total_nodes);                    % CurrentEvent's Destination
                Destination = CurrentEvent.Destination;          
                
                % This loop makes sure Destination node chosen for this event is not same as Source node
                while Source == Destination              
                    CurrentEvent.GetItsDestination(Total_nodes);
                    Destination = CurrentEvent.Destination;
                end
                
                CurrentEvent.GetItsBandwidth;                                   % CurrentEvent's Bandwidth
                
                
                
                % This block avoids calling Dijkstra function again if the event with same S-D pair served earlier
                if  isempty(Routes(Source,Destination).StoredPath)
                    CurrentEvent.GetItsRoute(optical_network,Source,Destination);   % CurrentEvent's Route is decided based on Dijkstra Algorithm [shortest path]
                    Routes(Source,Destination).StoredPath = CurrentEvent.Route;
                else
                    CurrentEvent.Route = Routes(Source,Destination).StoredPath;     % Route is extracted from 'Routes' Data structure
                end
                
        %%  Checking Resource's availability (FOR SPECTRUM ALLOCATION)
                
                NoOfNodes = length(CurrentEvent.Route);                            % Total no of nodes in this event's route.
                
                
                [flag1, WavelengthIndexes] = ResourcesChecking_SimpleFullPlacement1(CurrentEvent.Bandwidth,NoOfNodes , Spectrum_Status, CurrentEvent.Route, Total_wavelengths);
                
                if flag1                                                           % Here, flag1 =1 [Indicator of Resource's availability].
                    
                    % When network is in steady state, we'll start counting blocked_requests
                    if Clock > 20*AverageHoldingTime                                % When clock is greater than 6 times average holding time. 
                        blocked_requests = blocked_requests + 1;
                    end
                else                                                               % Here, flag1 =0, i.e Resources are available.
                        CurrentEvent.WavelengthIndex = WavelengthIndexes;
                end
                
         %% Setup connection (i.e marking corresponding FS as BUSY )
                
                if flag1 == 0                                                      % Event will be served here if flag1 =0
                    [Spectrum_Status] = SetupConnection(NoOfNodes, WavelengthIndexes,CurrentEvent.Route,CurrentEvent.Bandwidth, Spectrum_Status);
                end
                
         %% If Current Event is not blocked [i.e can be served], It's closure event will be created [i.e Departure type] 
                
                if flag1 ==0   
                    CurrentEvent.EventType =0;                                     % EventType field is '0' ensuring it is of Departure type
                    CurrentEvent.TimeInstant = GetReleaseTime(AverageHoldingTime,Clock);
                    NewNode = BSTnode(CurrentEvent);
                    Tree =  InsertEvent(Tree,NewNode);
                    
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
        b(z,m) = sum(sum(sum(Spectrum_Status==1)))/(42*Total_wavelengths);
    end
end

load = LambdaArray.*AverageHoldingTimeArray;                                       % Load is product of 'Average Arrival rate' and 'Average holding time'
finalBP = sum(a);                                                                  % It sums up 'No_of_iterations' Blocking probabilities corresponding to every load value.                           
SU = sum(b);
finalBP = finalBP./No_of_iterations; hold on;                                      % Averaging them out
plot(load,finalBP,'d--');
xlabel('Traffic Load');
ylabel('Blocking Probability');








