function [request_time] = GetArrivalTime(lambda,t)

dt = - log ( rand ( 1, 1 ) ) / lambda;              % inter_arrival time [Negative Exponential Distributed]
t = t + dt;                                         % request arriving Time Instant
request_time = t;

end



