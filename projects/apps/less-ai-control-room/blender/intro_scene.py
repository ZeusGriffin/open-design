"""Original starter animation for Blender 4.x; run `blender -b -P intro_scene.py`.
Creates a tiny object-assembly scene and outputs 96 PNG frames to //renders/.
This script is untested without Blender. No third-party assets are used.
"""
import bpy
from math import radians
from mathutils import Vector

bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
scene = bpy.context.scene
scene.render.engine = 'BLENDER_EEVEE_NEXT'
scene.render.resolution_x = 960
scene.render.resolution_y = 540
scene.render.resolution_percentage = 65
scene.render.image_settings.file_format = 'PNG'
scene.render.filepath = '//renders/frame_'
scene.render.film_transparent = False
scene.frame_start,scene.frame_end = 1,96
scene.render.fps = 24
scene.world.color = (0.025,0.028,0.03)

def mat(name, rgb, metallic=0, rough=.4):
    m=bpy.data.materials.new(name)
    m.diffuse_color=(*rgb,1)
    m.use_nodes=True
    bsdf=m.node_tree.nodes.get('Principled BSDF')
    bsdf.inputs['Base Color'].default_value=(*rgb,1)
    bsdf.inputs['Metallic'].default_value=metallic
    bsdf.inputs['Roughness'].default_value=rough
    return m

silver=mat('Soft silver',(.43,.48,.48),.75,.3)
coal=mat('Graphite',(.055,.065,.072),.4,.42)
orange=mat('Warm orange',(.94,.35,.12),.3,.34)
parts=[(-1.7,0,0,'Left'),(0,0,0,'Core'),(1.7,0,0,'Right')]
for x,y,z,name in parts:
    bpy.ops.mesh.primitive_cube_add(size=1,location=(x,y,z))
    o=bpy.context.object;o.name=name
    o.scale=(.65,.6,.32)
    o.data.materials.append(orange if name=='Core' else silver)
    bevel=o.modifiers.new('Soft corners','BEVEL');bevel.width=.12;bevel.segments=4
    o.modifiers.new('Weighted normals','WEIGHTED_NORMAL')
    o.keyframe_insert(data_path='location',frame=1)
    o.location.x*=.34
    o.keyframe_insert(data_path='location',frame=65)
for obj in bpy.context.scene.objects:
    if obj.type=='MESH':
        for curve in obj.animation_data.action.fcurves:
            for k in curve.keyframe_points:k.interpolation='BEZIER'
bpy.ops.mesh.primitive_plane_add(size=200,location=(0,0,-.53))
bpy.context.object.data.materials.append(coal)

def lamp(name,loc,power,color):
    bpy.ops.object.light_add(type='AREA',location=loc)
    o=bpy.context.object;o.name=name;o.data.energy=power;o.data.color=color;o.data.shape='DISK';o.data.size=5
    o.rotation_euler=(Vector((0,0,0))-o.location).to_track_quat('-Z','Y').to_euler()
lamp('Softbox',(-2,-4,5),650,(1,.87,.72))
lamp('Rim',(3,1,4),650,(.62,.78,1))
bpy.ops.object.camera_add(location=(4,-7,3.7))
cam=bpy.context.object
cam.rotation_euler=(Vector((0,0,0))-cam.location).to_track_quat('-Z','Y').to_euler()
cam.data.type='ORTHO';cam.data.ortho_scale=6.2;scene.camera=cam
# Renders not performed automatically. Call bpy.ops.render.render(animation=True) if desired.
print('LESS scene created: 96 frames; run render animation to produce PNG sequence')