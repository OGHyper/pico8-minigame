pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- For some reason, PICO8 won't load the .p8 file, but the .lua file instead.

function init_actors()
    ply1={x=8,y=8,spr=0}
end

function draw_ply1()
    spr(ply1.spr,ply1.x,ply1.y)
end

function update_ply1()
  if btn(0) then
    ply1.x -= 2
  end
  if btn(1) then
    ply1.x += 2
  end
  if btn(2) then
    ply1.y -= 2
  end
  if btn(3) then
    ply1.y += 2
  end
end

function _init()
    init_actors()
end

function _update()
    update_ply1()
end

function _draw()
    cls()
    draw_ply1()
end