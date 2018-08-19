import bpy
import random

# dimensions of txt file: 720 x 960 px


def readFile():
    l = []
    f = open(bpy.path.abspath('//data/man_01_tracked.txt'), 'r')
    # read data into list l
    for i in f:
        l.append(int(i) / 400)
    # convert into vectors for x and z
    for i in range(0, len(l), 2):
        v.append( ( l[i] - .9 , random.random() / 10 , (-1 * l[i + 1]) + 1.2 ) )


def addInstance(pos):
    inst = bpy.data.objects.new('Instance', None)
    inst.dupli_type = 'GROUP'
    inst.empty_draw_size = 0
    inst.dupli_group = bpy.data.groups["myGroup"]
    inst.rotation_euler = ( random.random(), random.random(), random.random() )
    inst.location = pos
    bpy.context.scene.objects.link(inst)


def myHandlerFunction(scene):
    if scene.frame_current < len(v):
        addInstance(v[scene.frame_current])
    if scene.frame_current == 0:
        for i in bpy.data.objects:
            if i.type == 'EMPTY':
                bpy.data.objects.remove(i)
    
v = []
readFile()
bpy.app.handlers.frame_change_pre.clear()
bpy.app.handlers.frame_change_pre.append(myHandlerFunction)
