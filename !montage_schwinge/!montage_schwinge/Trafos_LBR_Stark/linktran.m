function dh = linktran(theta,d,a,alpha)

%[dh] = linktran(theta,d,a,alpha)
%
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
%   stark@informatik.fh-augsburg.de             *
%   Labor CIM & Robotik                         *
%   2006                                        *
%************************************************

%*******************************
%* Author: Peter Schmuttermair *
%* Ver 1.0                     *
%* 15.07.05                    *
%*******************************


	
dh = rotz(theta) * transl(a,0,d) * rotx(alpha);
