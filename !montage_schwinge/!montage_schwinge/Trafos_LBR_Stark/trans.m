function H = trans(v)
% v: Translationsvektor, Spaltenvektor
% H: homogene 4*4-Matrix

%
%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   Georg.Stark@hs-augsburg.de                  *
%   Labor CIM & Robotik                         *
%   Copyright (C) 2009                          *
%************************************************
%
		H = [eye(3)	    v'; [0	0	0	1 ]]; %