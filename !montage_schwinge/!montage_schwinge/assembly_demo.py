"""
Zusammenbau eines virtuellen Roboters
Initialisierung:
    Auskommentieren der passenden vizconnect-Zeile, siehe VIZCONNECT

Schritte:
    1. Teile werden aufgenommen und in die Naehe der korrekten
        Einbau-Position gebracht. Nur das korrekte Teil kann
        mit der virtuellen Hand aufgenommen werden. Beim Loslassen
        wird ueberprueft, ob sich das Teil nah genug an der richtigen
        Position befindet. Falls ja, rastet es ein, falls nein faellt
        es herunter.
    2. Nachdem der Roboter zusammengebaut wurde, kann der Ball
        aufgenommen werden und das Werkzeug des Roboters folgt
        dem Ball.

Technische Realisierung:
    1. Ein Roboter wird anhand der DH-Parameter komplett aufgebaut,
        das Werkzeug wird positioniert und der Roboter wird komplett
        unsichtbar gemacht.
    2. Die auf dem Tisch positionierten Teile werden an diesem
        unsichtbaren Roboter ausgerichtet, sobald sie in der
        Naehe losgelassen werden. Der unsichtbare Roboter dient
        also als Schablone.
    3. Nach dem Zusammenbaur wird der neu aufgebaute Roboter
        unsichtbar gemacht, das Template wird sichtbar und
        folgt dem Ball.
"""

# Import der Pakete
# Test change, new branch
import os
import numpy as np

import viz
import vizact
import vizshape
import vizconnect
import tools
import vizact

import RobotModel
import random

robot = None
robot_parts = []


def define_table():
    """
        Zusammenbau des Tischs.
        Quelle: Herr Hofmann
    """
    table1_plate = vizshape.addBox(size=[2,0.1,2],
                pos=[0,1,5],alpha=1)
    table1_plate.collideBox()
    table1_plate.disable(viz.DYNAMICS)
    table1_foot1 = vizshape.addBox(size=[0.25,1,0.25],
                        pos=[0.7,0.5,4.5],alpha=1)
    table1_foot1.collideBox()
    table1_foot1.disable(viz.DYNAMICS)
    table1_foot2 = vizshape.addBox(size=[0.25,1,0.25],
                pos=[-0.7,0.5,5.5],alpha=1)
    table1_foot2.collideBox()
    table1_foot2.disable(viz.DYNAMICS)
    table1_foot3 = vizshape.addBox(size=[0.25,1,0.25],
                pos=[-0.7,0.5,4.5],alpha=1)
    table1_foot3.collideBox()
    table1_foot3.disable(viz.DYNAMICS)
    table1_foot4 = vizshape.addBox(size=[0.25,1,0.25],
                pos=[0.7,0.5,5.5],alpha=1)
    table1_foot4.collideBox()
    table1_foot4.disable(viz.DYNAMICS)
    
    
    podest = vizshape.addBox(size=[1.3,0.65,1.7],  #Podest für omnRobh
                        pos=[-1.9,0,5.0],alpha=1)
    podest.color(.5, .5, .7)                   
    
    
    #KUKA-Logo
    
    logo = vizshape.addBox(size=[2.4,2.0,0.01],
                pos=[0,4.0,7],alpha=1)
    logo.texture(viz.addTexture('logo.jpg'))
    
    
   

    # Textures
    table1_plate.texture(viz.addTexture('Maserung.jpg'))
    table1_foot1.texture(viz.addTexture('Maserung.jpg'))
    table1_foot2.texture(viz.addTexture('Maserung.jpg'))
    table1_foot3.texture(viz.addTexture('Maserung.jpg'))
    table1_foot4.texture(viz.addTexture('Maserung.jpg'))


def load_robot(base_pos):
    """
        Laden des kompletten Roboters, der als Template dient.

        Args:
            base_pos: Position der Basis im Raum
    """
    robot = RobotModel.LBR_Model(r'STL')
    # Positionierung des Werkzeugs
    ZF = np.array([
        [0, 1, 0,  0.5],
        [1, 0, 0, 0.5],
        [0, 0, -1, 0.5],
        [0, 0, 0, 1]
        ], np.float32)
    robot.set_tool(ZF)
    # Positionierung des Roboters
    robot.set_position(base_pos)
    return robot


def load_robot_parts():
    """
        Die Einzelteile des Roboters werden geladen und auf
        dem Tisch positioniert. Die Positionen sthen in der
        globalen Liste positions.
    """
    global robot, positions
    robot_parts = []
    i = 0
    for file_name, dh_parameters in robot.objects_STL:
        full_file_name = os.path.join(r'STL', file_name)
        current_object = viz.addChild(full_file_name)
        current_object.color(1.0, 0.5, 0) # current_object.color(.5, .5, .7)
        current_object.specular(.1, .1, .1)
        current_object.shininess(50)
        # Die Basis des Roboters wird nicht auf dem
        # Tisch positioniert
        if robot_parts:
            current_object.setPosition([positions[i], 1.1, 4.5])
            current_object.collideBox()
            i += 1
        robot_parts.append(current_object)
        # Positionierung der Basis
    robot_parts[0].setPosition(robot.get_position(0))
   #robot_parts[0].setPosition([0,-0.3,0],viz.REL_LOCAL)
    robot_parts[0].setAxisAngle(robot.get_orientation(0))
    robot_parts[0].collideMesh()
    robot_parts[1].setAxisAngle([0,0,1,90])
    robot_parts[4].setAxisAngle([0,0,1,90])
    robot_parts[5].setAxisAngle([1,0,0,90])
    
    robot_parts[1].color(.8, .8, .8)
    robot_parts[3].color(.8, .8, .8)
    robot_parts[5].color(.8, .8, .8)
    robot_parts[7].color(.8, .8, .8)
       
    
    return robot_parts

""" 
def robot_follows_marker(robot, marker):
    """ """ 
        Das Werkzeug folgt der Position des Markers.

        Args:
            robot: Roboter-Objekt
            marker: Objekt, dem das Werkzeug des Roboters folgt.
    """  """ 
    robot_pos = robot.get_position()
    marker_pos = marker.getPosition()
    p = [marker_pos[0] - robot_pos[0],
         marker_pos[1] - robot_pos[1],
         marker_pos[2] - robot_pos[2]]

    ZF = np.array([
        [0, 1, 0,  p[0]],
        [1, 0, 0, -p[2]],
        [0, 0, -1, p[1]],
        [0, 0, 0, 1]
        ], np.float32)
    
    print ZF

    robot.set_tool(ZF)
""" 

def robot_follows_marker(robot, marker):
    
    i = 0.001

    robot_pos = robot.get_position()
    ZF = np.array([
        [0, 1, 0, robot_pos[0] + i],
        [1, 0, 0, robot_pos[1] + i],
        [0, 0, -1, robot_pos[2] + i],
        [0, 0, 0, 1]
        ], np.float32)
    
    new_pos = [robot_pos[0] + i, robot_pos[1] + i, robot_pos[2] + i]
    
    robot.set_position(new_pos)
    print ZF
    print i

    robot.set_tool(ZF)


def on_release(e):
    """
        Callback-Funktion, die bem Loslassen eines Bauteils
        aufgerufen wird.

        Args:
            e: Event, wird nicht verwendet
    """
    global robot, robot_parts, part_index
    # Position des Bauteils mit der des Templates vergleichen
    part = robot_parts[part_index]
    pos_1 = np.array(part.getPosition(viz.ABS_GLOBAL), dtype=np.float32)
    pos_2 = np.array(robot.get_position(part_index), dtype=np.float32)
    dist = np.linalg.norm(pos_1 - pos_2)
    # Falls sich das Bauteil nahe genug an der korrekten Position befindet
    # TODO: Orientierung ueberpruefen
    if dist <= max_dist:
                # Bauteil positionieren und Physik fuer dieses
                # Bauteil ausschalten
        part.disable(viz.DYNAMICS)
        part.collideMesh()
        part.setPosition(robot.get_position(part_index), viz.ABS_GLOBAL)
        part.setAxisAngle(robot.get_orientation(part_index),
                          viz.ABS_GLOBAL)
        # Falls noch Bauteile uebrig geblieben sind, das
        # naechste Bauteil fuer den grabber freischalten
        if part != robot_parts[-1]:
            part_index += 1
            grabber.setItems(robot_parts[part_index:part_index+1])
            # Ansonsten den Ball fuer den Grabber freischalten und
            # den Roboter dem Ball folgen lassen.
        else:
            # Template sichtbar machen
            robot.visible(True)
            # Neu gebauten Roboter unsichtbar machen
            for p in robot_parts:
                p.visible(False)
            # Ball freischalten
            grabber.setItems([ball])
            # Roboter folgt dem Ball
            vizact.ontimer(1./float(viz.getOption(
                           'viz.max_frame_rate')),
                           robot_follows_marker, robot, ball)

# Einstellungen
CYCLES_PER_SEC = 0.05
viz.setMultiSample(4)
# Flimmern vermeiden
viz.setOption('viz.max_frame_rate', 60)
viz.vsync(viz.ON)
viz.go()

# VIZCONNECT
# Hier muss die passende Zeile auskommentiert werden.
# Tastatur
vizconnect.go(r'vizconnect_keyboard.py')
# HTC Vive
## vizconnect.go(r'vizconnect_hand_vive2.py')
#vizconnect.go(r'vizconnect_hand_vive.py')
# M2.01
#vizconnect.go(r'vizconnect_powerwall_with_wand')

# Globale Variablen initialisieren
part_index = 1
# Distanz, bei der das Bauteil "einrastet" (original bei 0.4)
max_dist = 10.0

print 'XXXXX'

viz.collision(viz.ON)
viz.phys.enable()

grabber = vizconnect.getRawTool('grabber')

# Labor und Boden laden
room = viz.add('lab.osgb')
ground = viz.add('ground.osgb')
ground.setPosition([0, .01, 0])
ground.collideplane()

# Tisch definieren
define_table()
# Roboter laden
robot = load_robot([-2, 1, 5])
# Template wird unsichtbar
robot.visible(False)

# Zufaellige Positionen fuer die Bauteile auf dem Tisch generieren. !!!
positions = [-0.7 + i * 0.2 for i in range(len(robot.objects_STL))]
#random.shuffle(positions)

# Bauteile laden
robot_parts = load_robot_parts()

# Ball laden
ball = viz.addChild('ball.wrl', scale=[0.15, 0.15, 0.15])
ball.setPosition([positions[-1], 1.1, 4.5])
ball.collideSphere()


# Erstes Bauteil freischalten
grabber.setItems(robot_parts[part_index:part_index+1])
# Callback-Funktion fuer den grabber aufsetzen
viz.callback(tools.grabber.RELEASE_EVENT, on_release)
