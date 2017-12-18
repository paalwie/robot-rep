function [robot] = LBR_PLAT_DAT()

%************************************************
%   Prof. Georg Stark, Fachhochschule Augsburg  *
%   stark@informatik.fh-augsburg.de            *
%   Labor CIM & Robotik                         *
%   2006                                        *
%************************************************


%Robot Data ****************************************************
robot.name = 'LBR_PLAT_DAT';

%sign = -1 if robot turn direction different from math turn dir!
%            sign  theta   d       a       alpha    Einheit: Bogenmass,Meter
robot.DH  = [ 1  0.000   0.300   0.000   -pi/2;  %eigentlich 340
              1  0.000   0.000   0.000   -pi/2;  % w_2: -pi/2
              1  0.000   0.400   0.000    pi/2; 
              1  0.000   0.000   0.000   -pi/2;
              1  0.000   0.400   0.000   -pi/2; 
              1  0.000   0.000   0.000    pi/2;
              1  0.000   0.100   0.000    0.0]; % eigentlich 111
 
 robot.DH_PLAT =[1    pi/2    0.000   0.000   pi/2;
                1    -pi/2   0.000   0.000   -pi/2;
                1    0.000   0.000   0.000    0.0 ];         
       
%robot.vmax_axis_plat = [0.2 0.2 0.2];
%robot.amax_axis_plat = [2.2 2.0 2.0] 
         
robot.vmax_axis = [1.9 1.9 0.8 0.8 0.8 0.8 0.8 0.8 0.8 0.8];
robot.amax_axis = [0.8 0.8 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0];
%maximum          s      alpha            beta     velocity
%                 m/s    rad/s            rad/s
robot.vmax_lin = [0.8 (pi/180)*40.0   (pi/180)*40.0];

%maximum          s      alpha            beta     acceleration
%                 m/s^2  rad/s^2          rad/s^2
robot.amax_lin = [0.6 (pi/180)*20.0   (pi/180)*20.0];


%maximum joint angles [rad]
robot.anglesmax =  [-500*(180/pi) 500*(180/pi);
                    -500*(180/pi) 500*(180/pi);
                    -180 180;
                    
                    -160 160;  %redundant!
                    -160 150; 
                    -160 160;
                    -145 125; 
                    -160 160;  %redundant!
                    -120 120; 
                    -180 180].* (pi/180); %redundant!

robot.angles_critical = [0 0 0 0 0 0 0 0 0 0]; %not used at the moment

%TOOL Data **************************************************** 
%                  x y z    [rad]     [rad]     [rad]
%robot.TOOL =transl(0,0,0.12) * rotz(0) * roty(0) * rotx(0);   % Kuli
%robot.TOOL =transl(0,0,0.129) * rotz(0) * roty(0) * rotx(0);   % für die Aufhnahemn mit GOM ATOS muss es 0.129 sein, edit by Michael Reiter

  robot.TOOL =    [1 0 0 0; 0 1 0 0; 0 0 1 0.04; 0 0 0 1];
  
%BKS Data **************************************************** 
%                  x y z    [rad]     [rad]     [rad]
%robot.BKS = transl(0,0,0) * rotz(0) * roty(0) * rotx(0);

robot.BKS_PLAT =[0  0   1   0;
                 1  0   0   0;
                 0  1   0   0;
                 0  0   0   1];

robot.BKS =     [1  0   0   0;
                 0  1   0   0;
                 0  0   1   0;
                 0  0   0   1];
             
                 
             
%***************************************************************

%   robot current pose

robot.cur_angles=[0 0 0 0 0 0 0];
robot.cur_plat_values=[0 0 0];





