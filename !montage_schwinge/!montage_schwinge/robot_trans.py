from __future__ import print_function, division
from oct2py import octave
import numpy as np

M_FILE_PATH = r'.\Trafos_LBR_Stark'

def setup_octave():
    if not M_FILE_PATH in octave.path():
        octave.addpath(M_FILE_PATH)
   
def get_robot():
    return octave.LBR_PLAT_DAT()
    
def get_default_kf():
    return np.array([0, 0, 0])
    
def rtraf_7_6_gelenk(ZF, kf, robot):
    (q, err) = octave.rtraf_7_6_gelenk(ZF, kf, robot)
    return (q, err)

if __name__ == '__main__':
    setup_octave()
    robot = get_robot()
    ZF = np.array([
        [0, 1, 0, 0.4],
        [1, 0, 0, 0],
        [0, 0, -1, 0.56],
        [0, 0, 0, 1]
        ], np.float32)
    kf = get_default_kf()
    (q, err) = rtraf_7_6_gelenk(ZF, kf, robot)
    print(type(q))
    print('q:', q)
    print('err:', err)
    (model, kf_neu) = octave.dkin_7(q, robot)
    # Vorsicht beim Zugriff auf Indizes (matlab / Python) !
    TCP = model[7]
    print('TCP:\n', TCP)
    