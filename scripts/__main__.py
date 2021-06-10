from drawing import draw_cuboid_sprite_map
from make_sprites import SpriteMap, process_sprite_maps

draw_cuboid_sprite_map('graphics/cuboid.png', steps=4, sprite_w=80, sprite_h=72)
process_sprite_maps(ram_top=0x10000)
