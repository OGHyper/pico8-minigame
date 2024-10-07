pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- For some reason, PICO8 won't load the .p8 file, but the .lua file instead.

-- Global variables
MAP_X = 128
MAP_Y = 128

function init_actors()
  ply1={x=8,y=8,spr=0}
end

function draw_ply1()
  spr(ply1.spr,ply1.x,ply1.y)
end

function setup_map()
  wall = 0
end

function draw_map()
  map(0,0,0,0,128,128)
end

function is_tile(tile_type, x, y)
  tile_x = x // 8
  tile_y = y // 8
  tile = mget(tile_x, tile_y)
  has_flag = fget(tile, tile_type)
  return has_flag
end

function can_move(x,y)
  return not is_tile(wall, x, y)
end

function update_ply1()
  if (btn(0)) then ply1.x -= 2 end
  if (btn(1)) then ply1.x += 2 end
  if (btn(2)) then ply1.y -= 2 end
  if (btn(3)) then ply1.y += 2 end
end

function _init()
  init_actors()
  setup_map()
end

function _update()
  update_ply1()
end

function _draw()
  cls()
  draw_map()
  draw_ply1()
end