function [alpha beta gamma ]=inv_zyz_euler(OM,kf)
% alpha,beta,gamma: ZYZ-Eulerwinkel 
% OM: homogene 3,3-Matrix, zur Darstellung der Orientierung, 
% kf: Konfigurationswert zur Auswahl einer von zwei möglichen Lösungen.

%
%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   Georg.Stark@hs-augsburg.de                  *
%   Labor CIM & Robotik                         *
%   Copyright (C) 2009                          *
%************************************************
%
% basierend auf 
%     Weber, W.: Industrieroboter. Methoden der Steuerung und Regelung. 
%     Hanser, 2002.

delta=0.0001; %10*eps;   % Überprüfung von beta auf 0, Singularität
a=OM(1:3,3); o=OM(1:3,2); n=OM(1:3,1);
beta=atan2(norm([a(1) a(2)]), a(3));
if abs(beta)>delta
    
    alpha=atan2(a(2),a(1)); % kf=1
    gamma=  atan2(o(3),-n(3));
    if kf==2
       if alpha>=0
           alpha=alpha-pi;
       else
           alpha=alpha+pi;
       end
       beta=-beta;
       if  gamma>=0
           gamma=gamma-pi;
       else
           gamma=gamma+pi;
       end
       
    end;
   
else
    alpha= atan2(n(2),n(1));
    if kf==2
       if alpha>=0
           alpha=alpha-pi;
       else
           alpha=alpha+pi;
       end
     end;
  
    beta=0; gamma=0;
end



