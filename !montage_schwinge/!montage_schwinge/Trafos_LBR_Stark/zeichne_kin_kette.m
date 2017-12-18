function zeichne_kin_kette(koor,ks_linie)

%Eingabeparameter:
% koor: Rückgabedatenstruktur der Funktion koortraf, enthält alle
%       Koordinatensysteme als cellarray.
% ks_linie: Linienbreite, benötigt für die Funktion plot3.
% Es werden Basis- und Effektorkoordinatensystem gezeichnet.
% Die Ursprünge aller Koordinatensysteme werden nur mit einer 
% linie verbunden.


%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   Georg.Stark@hs-augsburg.de             *
%   Labor CIM & Robotik                         *
%   2009                                        *
%************************************************
% $Revision: 
% Copyright (C) 2008, by Georg Stark

%Initialisierung


% Initialisiere Grafik
%axis([-0.2 1 -0.2 1 -0.2 1]);
%grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');


% Berechne Anfangskoordinatensystem
[zz nk]=size(koor);

zeichne_ks(koor{1},ks_linie);
p_vor=koor{1}(1:3,4);
for ii=2:nk
    p_neu= koor{ii}(1:3,4);   
    % Zeichne Verbindung Koordinatensysteme
    plot3([p_vor(1) p_neu(1)],[p_vor(2) p_neu(2)],[p_vor(3) p_neu(3)],'LineWidth',1.5);
    if ii==2  zeichne_ks1(koor{ii},ks_linie); end
    if ii==nk  zeichne_ks1(koor{ii},ks_linie); end %  Effektorkoordinatensystem
   
    p_vor=p_neu;
end % Ende for-Schleife

