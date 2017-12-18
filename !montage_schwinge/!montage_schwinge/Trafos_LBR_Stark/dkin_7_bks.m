function [model config] = dkin_7_bks(angles7_6, robot,basis_arm)
%
%direct kinematic 
%
%   Benutzt die DH7 Matrix von MRobot
%   Die Winkel entsprechen dieser Matrix,
%   Der Winkel theta3 fehlt. Er wird auf 0 gesetzt.
%   model{8} liefert den TCP, model{9} das Koor der 7. Achse  
%   Es wird nur die Standardkonfiguration [0 1 0] geliefert.
%
%Parameters:
%angles:    Vector 1x6 containing  angles
%
%robot:     robot structure
%
%
%Return values:
%model:    1x8 cell array containing homogenous matices
%          of robot stick model
%          TCP => model{8}
%
%config:   1x9 vector with robot configuration  
%              and turn bits
%              config(1:3) => configuration
%              config(4:9) => turn bits of axis 
%                             1 to 6
%

%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   stark@informatik.fh-augsburg.de            *
%   Labor CIM & Robotik                         *
%   2006                                        *
%************************************************


angles(1:2)=angles7_6(1:2); angles(3)=0;
angles(4:7)=angles7_6(3:6);

DH = robot.DH;
BKS = basis_arm;  % einzige Änderung gegenüber dkin_7.m
TOOL = robot.TOOL;

[R C] = size(DH);

D1 = linktran(DH(1,2)+ angles(1) * DH(1,1),DH(1,3),DH(1,4),DH(1,5));
D2 = linktran(DH(2,2)+ angles(2) * DH(2,1),DH(2,3),DH(2,4),DH(2,5));
D3 = linktran(DH(3,2)+ angles(3) * DH(3,1),DH(3,3),DH(3,4),DH(3,5));
D4 = linktran(DH(4,2)+ angles(4) * DH(4,1),DH(4,3),DH(4,4),DH(4,5));
D5 = linktran(DH(5,2)+ angles(5) * DH(5,1),DH(5,3),DH(5,4),DH(5,5));
D6 = linktran(DH(6,2)+ angles(6) * DH(6,1),DH(6,3),DH(6,4),DH(6,5));
D7 = linktran(DH(7,2)+ angles(7) * DH(7,1),DH(7,3),DH(7,4),DH(7,5));

model{1} = BKS;
frame = BKS * D1;
model{2} = frame;
frame = frame * D2;
model{3} = frame;
frame = frame * D3;
model{4} = frame;
frame = frame * D4;
model{5} = frame;
frame = frame * D5;
model{6} = frame;
frame = frame * D6;
model{7} = frame;
frame = frame * D7;
frame8=frame;
model{8} = frame;
frame = frame * TOOL;
model{9} = frame;
TCP = frame;

% Vertauschung aus Kompatibilitätsgründen!!
model{8}=TCP;
model{9}=frame8;

%Robot Konfiguration********

% Dies ist die Standardkonfiguration.
config = [0 1 0];

% Die genaue Berechnung erfolgt über die Formeln in "Robotik mit ML", 64,
% 152, 155

