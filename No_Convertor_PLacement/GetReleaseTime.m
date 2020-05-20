function [request_releasingtime] = GetReleaseTime(mu,t);

request_holdingtime = - mu*log ( rand ( 1, 1 ) ) ;             % 'mu' here is Average holding time
request_releasingtime = request_holdingtime + t;

end   
    
