pico-8 cartridge // http://www.pico-8.com
version 35
__lua__

-- Global variables
MAP_X = 128
MAP_Y = 128
actors = {}

-- From zep
function make_actor(x, y)
  a={}
  a.x = x
  a.y = y
  a.dx = 0
  a.dy = 0
  a.spr = 0
  a.frame = 0
  a.t = 0
  a.inertia = 0.6
  a.bounce  = 1
  
  -- half-width and half-height
  -- slightly less than 0.5 so
  -- that will fit through 1-wide
  -- holes.
  a.w = 0.4
  a.h = 0.4
  
  add(actors,a)
  
  return a
 end

 -- from zep
 function solid(x, y)
  -- grab the cell value
  val = mget(x, y)
  -- check if flag 1 is set (flag 1 being my 'is a wall' flag)
  return fget(val, 1)
  end
 
 -- from zep
 function solid_area(x,y,w,h)
  return 
    solid(x-w,y-h) or
    solid(x+w,y-h) or
    solid(x-w,y+h) or
    solid(x+w,y+h)
  end

 -- from zep
 function move_actor(a)
  -- only move actor along x
  -- if the resulting position
  -- will not overlap with a wall
  if not solid_area(a.x + a.dx, a.y, a.w, a.h) then
    a.x += a.dx
  else   
    -- otherwise bounce
    a.dx *= -a.bounce
  end

  -- ditto for y
  if not solid_area(a.x, a.y + a.dy, a.w, a.h) then
    a.y += a.dy
  else
    a.dy *= -a.bounce
  end

  a.dx *= a.inertia
  a.dy *= a.inertia
 
 -- advance one frame every
 -- time actor moves 1/4 of
 -- a tile
 
  a.frame += abs(a.dx) * 4
  a.frame += abs(a.dy) * 4
  a.frame %= 2 -- always 2 frames

  a.t += 1
end

function control_player(pl)
  -- how fast to accelerate
  accel = 0.1
  if (btn(0)) then pl.dx -= accel end
  if (btn(1)) then pl.dx += accel end
  if (btn(2)) then pl.dy -= accel end
  if (btn(3)) then pl.dy += accel end

end

function update_pl()
  if (btn(0)) then pl.x -= 2 end
  if (btn(1)) then pl.x += 2 end
  if (btn(2)) then pl.y -= 2 end
  if (btn(3)) then pl.y += 2 end
end

function draw_actor(a)
  local sx = (a.x * 8) - 4
  local sy = (a.y * 8) - 4
  spr(a.spr + a.frame, sx, sy)
end

function init_menu()
  _update = update_menu
  _draw = draw_menu
end

function update_menu()
  -- menu code here
  if btnp(❎) then
    init_game()
  end
end

function draw_menu()
  -- menu code here
  cls()
  print("press ❎ to start", 30, 63)
end

function _init()
  init_menu()
end

function init_game()
  music(0)
  pl = make_actor(2, 2)
  pl.spr = 16
  local ball = make_actor(8.5,7.5)
  ball.spr = 33
  ball.dx = 0.4
  ball.dy =- 0.1
  ball.inertia = 1
  _update = update_game
  _draw = draw_game
end

function update_game()
  control_player(pl)
  foreach(actors, move_actor)
end

function draw_game()
  cls()
  map(0,0,0,0,16,16)
  foreach(actors, draw_actor)
end