function r = rotv(v, t)
% Rotation um einen beliebigen Vektor
%
% 	TR = rotv(vec, alpha)
%
% Liefert eine homogene Transformation, die eine Rotation von alpha um den
% Vektor vec darstellt. 
%
% Copyright (C) 2008, Georg Sark
%
% Änderungen:


%
%
%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   Georg.Stark@hs-augsburg.de                  *
%   Labor CIM & Robotik                         *
%   Copyright (C) 2009                          *
%************************************************

	v = v / norm(v,'fro');
	ct = cos(t);
	st = sin(t);
	vt = 1-ct;
	v = v(:);
	r = [ct         -v(3)*st	v(2)*st
		 v(3)*st	ct          -v(1)*st
		-v(2)*st	v(1)*st		ct	];
	
	r = [v*v'*vt+r zeros(3,1); 0 0 0 1];

