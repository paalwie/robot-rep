import viz
import os
import robot_trans
import math

print('imports done in RobotModel2 !')

class RobotModel2(object):
    
    def __init__(self, stl_directory, objects_STL,
            initial_orientations=None, initial_position=None):
        #robot_trans.setup_octave()
        self.__angles = []
        self.__axes = []
        self.__load_STL(stl_directory, objects_STL, initial_orientations, initial_position)
        
    def get_axes(self):
        return self.__axes
        
    def __load_STL(self, stl_directory, objects_STL, initial_orientations, initial_position):
        parent_object = None
        for file_name, dh_parameters in objects_STL:
            full_file_name = os.path.join(stl_directory, file_name)
            if parent_object:
                current_object = viz.addChild(full_file_name, parent=parent_object)
            else:
                current_object = viz.addChild(full_file_name)
            current_object.color(1.0, .5, 0)
            current_object.specular(.1, .1, .1)
            current_object.shininess(50)
            current_object.collideMesh()
            self.__axes.append(current_object)
            self.__angles.append(0.0)
            parent_object = current_object
            
        self.__axes[1].color(.8, .8, .8)  # andere Farbe als Roboter1 ??
        self.__axes[3].color(.8, .8, .8)
        self.__axes[5].color(.8, .8, .8)
        self.__axes[7].color(.8, .8, .8)
       
            
    
        for index, current_object in enumerate(self.__axes):
            dh_parameters = objects_STL[index][1]
            current_object.setAxisAngle(0, 0, 1, dh_parameters[0], 
                viz.REL_PARENT)
            current_object.setPosition(0, 0, dh_parameters[1], 
                viz.REL_PARENT)
            current_object.setPosition(dh_parameters[2], 0, 0, 
                viz.REL_LOCAL)
            current_object.setAxisAngle(1, 0, 0, dh_parameters[3], 
                viz.REL_LOCAL)
                
        for o in initial_orientations:
            self.set_axis_angle(o[0], o[1])
                
        if initial_position != None:
            self.set_position(initial_position)
            
    def set_position(self, new_pos):
        self.__axes[0].setPosition(new_pos[0], new_pos[1], new_pos[2], 
            viz.ABS_GLOBAL)
            
    def get_position(self, index=0):
        return self.__axes[index].getPosition(viz.ABS_GLOBAL)
        
    def get_orientation(self,index=0):
        return self.__axes[index].getAxisAngle(viz.ABS_GLOBAL)
    
    def set_axis_angle(self, axes_index, angle_deg):
        delta = angle_deg - self.__angles[axes_index]
        self.__axes[axes_index].setEuler(0, 0, delta, viz.REL_PARENT)
        self.__angles[axes_index] = angle_deg
        
    def visible(self, b):
        for o in self.__axes:
            o.visible(b)
        

class LBR_Model2(RobotModel2):
    
    def __init__(self, stl_directory):
        self.objects_STL = [
            ('LBR_PL_K3n_mit_Raeder.stl', (0, 0, 0, -90)),
            ('LBR_K1.stl', (0, 0.34, 0, -90)),
            ('LBR_K2.stl', (0, 0, 0, -90)),
            ('LBR_K3.stl', (0, 0.4, 0, 90)),
            ('LBR_K4.stl', (0, 0, 0, -90)),
            ('LBR_K5.stl', (0, 0.4, 0, -90)),
            ('LBR_K6.stl', (0, 0, 0, 90)),
            ('LBR_K7.stl', (0, 0.111, 0, 0))
            ]
            
        self.initial_orientations = []
        
        self.initial_position = (0, 0.64, 0)  # Ändern??
        
        RobotModel2.__init__(self, stl_directory, self.objects_STL, 
            self.initial_orientations, self.initial_position)
            
        robot_trans.setup_octave()
        self.m_robot = robot_trans.get_robot2()
        self.kf = robot_trans.get_default_kf()
        
    def set_tool(self, zf):
        (q, err) = robot_trans.rtraf_7_6_gelenk(zf, self.kf, self.m_robot)
        axis_index = [1, 2, 4, 5, 6, 7]
        self.set_axis_angle(2, 0)
        for i, a_i in enumerate(axis_index):
            self.set_axis_angle(a_i, math.degrees(q[0][i]))