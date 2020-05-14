# Optical-Network-Simulator

This Simulator runs simulations for NSF Network in which links are bidirectional. Shortest Routes have been found by 'Dijkstra algorithm' and First Fit technique is adopted in spectrum allocation. Total of 15 wavelengths are available at each link and 1 wavelength is given to every connection. If you want to simulate for different parameters, see below:  


To start simulations, open MainFunction.m file and Run.

If you want to change Network topology, take out nsf_network.mat file.

If you want to make modifications in Spectrum Allocation Algorithm or change it, Take out ResourcesChecking.m file.

If you want to modify how much Bandwith to allocate to a request, go to Events.m -> methods-> GetItsBandwidth.

If you want to modify the Routing Algorithm, Take out ROUTING_dijkstra.m file.

etc and etc....
