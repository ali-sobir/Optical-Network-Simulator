function [request_time] = GetArrivalTime(lambda,t)

dt = - log ( rand ( 1, 1 ) ) / lambda; % inter_arrival times
t = t + dt;  % request arriving TIME INSTANT
request_time = t;




