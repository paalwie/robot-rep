function dh = dh_trafo(theta,d,a,alpha)
%Returnes frame created by Denavit Hartenberg transformation
%different in parameters from the version of Peter Corke!!!
%
%Parameter:
%
%theta          z axis rotation angle
%
%d              z axis distance 
%
%a              x axis distance
%
%alpha          x axis rotation angle
%
%Return Values:
%
%dh             [4 x4] frame
%

%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   Georg.Stark@hs-augsburg.de                  *
%   Labor CIM & Robotik                         *
%   Copyright (C) 2009                                        *
%************************************************
	
dh = rotz(theta) * trans([a 0 d]) * rotx(alpha);

% ursprünglich trans aus RMML
