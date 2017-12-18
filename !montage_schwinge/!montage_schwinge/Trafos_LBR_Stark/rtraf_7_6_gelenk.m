function [q7_6 error] = rtraf_7_6_gelenk(ZF,config_MR,robot)
% Rücktransformation eines Gelenkarmroboters mit 7 Achsen
% Achse 3: theta3=0!
% Dat-Dateiformat von MRobot 
% (nicht wie in "Robotik mit Matlab" beschrieben!!
%
% Prinzip:
%   Die DH-Matrix von MRobot wird auf das Format von "Robotik mit Matlab"
%   umgeformt. Anschliessend wird sie von einem 7-Achsen-Roboter auf 6 Achsen
%   umgerechnet mit theta3=0;
%   Die Winkel theta2 und theta3 müssen am Ende wieder angepasst werden.
%
%
% Eingangsparameter:
% ZF:       Ziel-Frame in Weltkoordinaten, [4 4] Array; 
%  
% config:   auf [0 0 0] gesetzt, entspricht kf=1 in RMML
%     
%
% robot:    Roboterparameter
%           robot.dhp   DH-Parameter, [n 6] Array
%           Spalten:    atyp   vorz  theta  d    a    alpha 
%                       (0/1) (1/-1)
%
%           robot.ef:   Effektortransformation
%           [4 4] Array
%
%           robot.bas   Roboterbasis in Weltkoordinaten
%           [4 4] Array
%                              
% Rückgabeparameter:
% q7_6:      Liste der Achswerte,6-El-Array, Zeilenvektor, Winkel von A3 wird ignoriert;
%            Angabe in rad oder m.     
%
%
%
%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   Georg.Stark@hs-augsburg.de             *
%   Labor CIM & Robotik                         *
%   Copyright (C) 2014                                       *
%************************************************

kf=2; % gesetzt!!!

if kf<1 | kf>8
    error('Wert für kf nicht 1<=kf<=8')
end

DH7x = robot.DH;      
BAS = robot.BKS;        % Roboter-Basiskoordinatensystem
EF = robot.TOOL;        % Effektor-Transformation

% Umformung  von Format MRobot nach RMML
DH7(1:7,1)= [1 1 1 1 1 1 1]';
DH7(:,2:6)=DH7x;

%Umrechnung Konfig,  zunächst Standardkonfig 1

dhp(1,:)=DH7(1,:);
%           Vorz     theta    d  a        alpha
dhp(2,:)=  [1 DH7(2,2) DH7(2,3)  0  DH7(3,4)    0 ]; % Vorz  theta2   d3
dhp(3,:)=  [1 DH7(4,2) DH7(4,3)  0  0        -pi/2]; % theta4                          

dhp(4,:)=DH7(5,:);
dhp(5,:)=DH7(6,:);
dhp(6,:)=DH7(7,:);


% Flanschtransformation
FL=inv(BAS)*ZF*inv(EF);

% Handwurzelpunkt hwp
hwp= FL(1:3,4)-FL(1:3,3)*dhp(6,4); % hwp=uf-zf*d6
hx0=hwp(1); hy0=hwp(2); hz0=hwp(3);

% Achswinkel A1,  Transformation von H nach K1
hy1=-(hz0-dhp(1,4));        % d1-hz

if  kf==1 | kf==2 | kf==3 | kf==4 % Konfiguration vorne
    q1=atan2(hy0,hx0);    
    hx1=sqrt(hx0^2+hy0^2)-dhp(1,5);     % a1
else                              % Konfiguration hinten
    q1=atan2(hy0,hx0)+pi;   
    hx1=-sqrt(hx0^2+hy0^2)-dhp(1,5); 
end

% Berechnung der Strecken
oa=dhp(2,5); % a2
ua=sqrt(dhp(3,5)^2+dhp(4,4)^2); % a3, d4

l=sqrt(hx1^2+hy1^2);
if (oa+ua<l | norm(oa-ua)>l | l<eps )
    error('H ausserhalb der Reichweite');
    q=[0 0];
    return
end

% Hilfswinkel
alpha=atan2(hy1,hx1);
epsilon=atan(dhp(3,5)/dhp(4,4)); % atan(a3/d4)
beta=acos( (oa^2-ua^2+l^2)/(2*l*oa) );
gamma=acos( (oa^2+ua^2-l^2)/(2*oa*ua) );

% Achswinkel A2, A3
if  kf==1 | kf==2 | kf==5 | kf==6
    q2=alpha-beta; % z1-Achse zeigt in die Ebene
    q3=-gamma+pi/2+epsilon;
else
    q2=alpha+beta; % z1-Achse zeigt in die Ebene
    q3=gamma-3*pi/2+epsilon;  %
end
q(1)=q1; q(2)=q2; q(3)=q3;

% Orientierung im HWP
K3=eye(4);
for ii=1:3
    vorz=dhp(ii,2);
    if dhp(ii,1)==1     % Drehachse
        traf=dh_trafo(dhp(ii,3)+vorz*q(ii), dhp(ii,4), dhp(ii,5),dhp(ii,6));
        % geändert dhp(ii,3)+vorz*, 13.12.08  ??
    else
        error('nur Drehachse (1) möglich')
    end
    K3=K3*traf;
end
OH=K3(1:3,1:3);

% Differenzorientierung
OF=FL(1:3,1:3);
DF=inv(OH)*OF;

%Rücktrafo Hand
if kf==1|kf==3|kf==5|kf==7 % direkt
    [aw bw gw ]=inv_zyz_euler(DF,1);
    q(4)=aw; q(5)=bw; q(6)= gw; 
else                       % gedreht
    [aw bw gw ]=inv_zyz_euler(DF,2);
    q(4)=aw; q(5)=bw; q(6)= gw; 
end

q7_6(1)=q(1); 
q7_6(2)=q(2)-pi/2; %q6(2) - q7_6(2), q7_6: 6 Winkel bezogen auf DH7
q7_6(3)=q(3)+pi/2;
q7_6(4:6)=q(4:6);

error=0;






