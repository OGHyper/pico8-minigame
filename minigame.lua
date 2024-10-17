pico-8 cartridge // http://www.pico-8.com
version 35
__lua__

-- Global variables
MAP_X = 128
MAP_Y = 128
actors = {}
coins_collected = 0
lives = 3

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

 -- copy solid and solid area to modify it to check for the coin flagged sprite
 function solid(x, y)
  -- grab the cell value
  val = mget(x, y)
  -- check if flag 1 is set (flag 1 being my 'is a wall' flag)
  return fget(val, 1)
  end
 
 function solid_area(x,y,w,h)
  return 
    solid(x-w,y-h) or
    solid(x+w,y-h) or
    solid(x-w,y+h) or
    solid(x+w,y+h)
  end

  function solid_actor(a, dx, dy)
    for a2 in all(actors) do
      if a2 != a then
        local x=(a.x+dx) - a2.x
        local y=(a.y+dy) - a2.y
        
        if (a.spr == 20 and a2.spr == 32) or (a.spr == 32 and a2.spr == 20) then
          -- Skip collision processing between treasure and ball
          goto continue
        end

        if ((abs(x) < (a.w+a2.w)) and
             (abs(y) < (a.h+a2.h)))
        then
          -- moving together?
          -- this allows actors to
          -- overlap initially 
          -- without sticking together    
          -- process each axis separately
          -- along x
          if (dx != 0 and abs(x) <
              abs(a.x-a2.x))
          then
            v=abs(a.dx)>abs(a2.dx) and 
              a.dx or a2.dx
            a.dx,a2.dx = v,v
            local ca=
             collide_event(a,a2) or
             collide_event(a2,a)
            return not ca
          end

          -- along y
          if (dy != 0 and abs(y) <
               abs(a.y-a2.y)) then
            v=abs(a.dy)>abs(a2.dy) and 
              a.dy or a2.dy
            a.dy,a2.dy = v,v
            local ca=
             collide_event(a,a2) or
             collide_event(a2,a)
            return not ca
          end
        end
      end
      ::continue::
    end
    return false
  end

-- checks both walls and actors
function solid_a(a, dx, dy)
	if solid_area(a.x+dx, a.y+dy, a.w, a.h) then
		return true
  end
	return solid_actor(a, dx, dy) 
end

function collide_event(a1, a2)
  -- AND a2 == coin sprite
  if (a1 == pl and a2.spr == 20) then
    del(actors, a2)
    -- sfx here
    coins_collected += 1
    return true
  end
  if (a1 == pl and a2.spr == 32) then
    lives -= 1
  end
  -- bump sfx
  return false
end

 function move_actor(a)
  -- only move actor along x
  -- if the resulting position
  -- will not overlap with a wall
  if not solid_a(a, a.dx, 0) then
		a.x += a.dx
	else
		a.dx *= -a.bounce
	end

	-- ditto for y

	if not solid_a(a, 0, a.dy) then
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
  if (btn(❎)) then
    accel = 0.2
  else
    accel = 0.1
  end
  
  if (btn(0)) then pl.dx -= accel end
  if (btn(1)) then pl.dx += accel end
  if (btn(2)) then pl.dy -= accel end
  if (btn(3)) then pl.dy += accel end

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
  print ("avoid the ball", 30, 49)
  print("press ❎ to start", 30, 63)
end

function _init()
  init_menu()
end

function init_game()
  music(0)
  coins_collected = 0
  lives = 3
  pl = make_actor(1.5, 1.5)
  pl.spr = 16
  
  local ball1 = make_actor(8,3)
  ball1.spr = 32
  ball1.dx = 0.4
  ball1.dy =- 0.1
  ball1.inertia = 1
  
  local ball2 = make_actor(8,9)
  ball2.spr = 32
  ball2.dx = 0.4
  ball2.dy =- 0.1
  ball2.inertia = 1

  for i = 1.5, 14.5, 2 do
    for j = 1.5, 11.5, 2 do
      if  not solid(i, j) do
        a = make_actor(i, j)
        a.spr = 20
      end
    end
  end
  _update = update_game
  _draw = draw_game
end

function update_game()
  control_player(pl)
  foreach(actors, move_actor)
  if (lives == 0) then
    init_endscreen()
  end
  if (coins_collected == 39) then
    init_winscreen()
  end
end

function draw_game()
  cls()
  map(0,0,0,0,16,16)
  foreach(actors, draw_actor)
  print("lives: "..lives, 4, 13*8)
  print("coins: "..coins_collected, 4, 14*8)
end

function init_endscreen()
  actors = {}
  _update = update_endscreen
  _draw = draw_endscreen
end

function update_endscreen()
  if btnp(❎) then
    _init()
  end
end

function draw_endscreen()
  cls()
  print ("game over :(", 30, 49)
  print("press ❎ to return to main menu", 5, 63)
end

function init_winscreen()
  actors = {}
  _update = update_winscreen
  _draw = draw_winscreen
end

function update_winscreen()
  if btnp(❎) then
    init_menu()
  end
end

function draw_winscreen()
  cls()
  print ("you win! :)", 30, 49)
  print("press ❎ to return to main menu", 5, 63)
end