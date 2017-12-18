function zeichne_ks1(P,L)

% P: Frame
%         x: rot,  z: blau
% L: Länge der Linien


%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   stark@informatik.fh-augsburg.de             *
%   Labor CIM & Robotik                         *
%   2006                                        *
%************************************************

B = P(1:3,1:3) .* L;
O = [P(1:3,4)'; P(1:3,4)'; P(1:3,4)']';
B = B + O;
hold on
plot3([P(1,4) B(1,1)],[P(2,4) B(2,1)],[P(3,4) B(3,1)],'Color','r','LineWidth',3);
%plot3([P(1,4) B(1,2)],[P(2,4) B(2,2)],[P(3,4) B(3,2)],'Color','g','LineWidth',3);
plot3([P(1,4) B(1,3)],[P(2,4) B(2,3)],[P(3,4) B(3,3)],'Color','b','LineWidth',3);

