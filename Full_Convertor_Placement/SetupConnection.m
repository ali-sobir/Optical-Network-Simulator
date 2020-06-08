function [Spectrum_Status] = SetupConnection(NoOfNodes, WavelengthIndexes, Route, Bandwidth, Spectrum_Status)

TotalHops = NoOfNodes - 1;                                         % Total number of hops on a Route of this Event.
for i = 1:TotalHops
    wavelength = WavelengthIndexes(i);                             % WavelengthIndexes(i) gives wavelength's index on ith hop.
    while (wavelength < WavelengthIndexes(i) + Bandwidth)
        Spectrum_Status(Route(i),Route(i+1),wavelength) = 1;       % Marking corresponding wavelength 1 ensuring it is allocated to this Route.
        wavelength = wavelength+1;
    end
end

end