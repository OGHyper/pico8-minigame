pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- album, a music visualizer
-- by bikibird
-- for the pico-8 new music jam
-- record function based on code by packbat.

-- 1. add sfxes/music patterns.
-- 2. add meta-data to tab 2.

-- list of visualizers and suggested palettes
-- see comments in tab 2 for more info

-- bubble
-- cover
-- harp: {[0]=0,130,141,13,12,140,1,131,3,139,11,138,135,10,9,137}
-- piano_roll
-- ripples
-- stars

--[[export with fadeout and repeats
extcmd("audio_rec")
n=10--set to beginning of song
repeats=2--number of loops before fadeout
fadeout=8000--in milliseconds, max 32767
music(n)--start music
for i_r=1,repeats do
    flip()
    repeat
        flip()
    until stat(55)>stat(54)-n--loop detection
    --stat(55)=number of patterns played
    --stat(54)=current pattern number
    --if number of patterns played exceeds number of patterns advanced,
    --song has looped
    n=stat(54)-stat(55)--reset to detect next repeat
end
music(-1,fadeout)
repeat
    flip()
until not stat(57)--when playing, stat(57)==true
extcmd("audio_end")
-->8
-- visualizers
function bubble()
    -- bubble is formed from map 0,0,16,16
    local delta,collapse_rate=0,tune.collapse_rate and tune.collapse_rate or .4
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    while true do
        _cover()
        if #events>1 then
            if new_flag  then
                for i=1,4 do
                    if events[#events][i].hold then
                        --delta-=1
                    else   
                        delta+=1 
                    end
                end
            end
            local r=flr(35+delta) --+sqrt(high-low)*4 +delta
            delta=delta<=0 and 0 or delta-collapse_rate
            local rsquare=r*r
            local ysquare,newx
            local x,y=r,0
            while (y<=x) do
                tline(63-x,63+y,63+x,63+y,1,16*y/r,7/x)
                tline(63-x,63-y,63+x,63-y,1,16*y/r,7/x)
                tline(63-y,63+x,63+y,63+x,1,16*x/r,7/y)
                tline(63-y,64-x,63+y,64-x,1,16*x/r,7/y)
                y+=1
                ysquare=y*y
                newx=x+1
                if (newx)*(newx)+(ysquare) <= rsquare then
                    x=newx
                else
                    if (x)*(x)+(ysquare) <= rsquare then
                    else
                        x-=1
                    end   
                end
            end
            local t_left=palt(left,false)
            local t_right=palt(right,false)
            if left>-1 then
                circ(63,64,r,left)
            end
            if right>-1 then
                circ(64,63,r,right)
            end
            palt(left,t_left)
            palt(left,t_right)

        end
        display_credits()
        yield()
    end
end

function cover()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    while true do 
        _cover()
        display_credits()
        yield()
    end
end
function _cover()
    local background =tune.background
    if background then
        if background==-1 then
            map(0,0)
        else
            cls(background)
        end
    end
end
function harp()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local offset=tune.offset or 0
    local spacing=tune.spacing or 2
    local width,height=spacing,128
    if type(spacing)=="table" then width,height=unpack(spacing) end
    while true do
        _cover()
        local t_left=palt(left,false)
        local t_right=palt(right,false)
        if #events>0 then
        for i=1,4 do
                local pitch=events[#events][i].pitch
                local x=(pitch+offset)*width
                if events[#events][i].volume >0 then
                    line(x,0,x,127,pitch_colors[pitch%12])
                    if left>-1 then
                        line(x-1,0,x-1,127,left)
                    end
                    if right>-1 then
                        line(x+1,0,x+1,127,right)
                    end
                end
            end 
        end   
        palt(left,t_left)
        palt(right,t_right)
        display_credits()
        yield()
    end

end
function stars()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local offset=tune.offset or 0
    local spacing=tune.spacing or 16
    local starfield={}
    for i=0,7 do
        for j=0,7 do
            add(starfield,{j*16+16-rnd(16),127*spacing/16-(i*spacing+spacing-rnd(spacing))})
        end
    end
    while true do
        _cover()
        rectfill(0,0,127,127*spacing/16,0)
        for star in all(starfield) do
            pset(star[1],star[2],13)    
        end
        if #events>0 then
            for i=1,4 do
                local pitch=events[#events][i].pitch
                local volume=events[#events][i].volume
                if volume >0 then 
                    local star=starfield[pitch+1+offset]
                    local x,y=star[1],star[2]
                    if volume <3 then
                        pset(x,y,7) 
                    elseif volume <5 then
                        line(x-1,y,x+1,y,13)
                        line(x,y-1,x,y+1,13)
                        pset(x,y,7) 
                    else
                        pset(x-1,y-1,12)
                        pset(x+1,y+1,12)
                        pset(x-1,y+1,11)
                        pset(x+1,y-1,11)
                        line(x-2,y,x+2,y,7) 
                        line(x,y-2,x,y+2,7) 
                        pset(x-3,y,14)
                        pset(x+3,y,15)
                        pset(x,y-3,9)
                        pset(x,y+3,10)
                        pset(x-4,y,5)
                        pset(x+4,y,5)
                        pset(x,y-4,5)
                        pset(x,y+4,5)
                    end
                end
            end 
        end   
        display_credits()    
    yield()  
    end
end
function ripples()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local offset=tune.offset or 0
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local foreground=tune.foreground or {12,12,12,12}
    local spacing=tune.spacing or 16
    local water=tune.background>-1 and tune.background or 0
    local horizon=127-127*spacing/16
    local rings={}
    for i=0,7 do
        for j=0,7 do
            add(rings,{x=j*16+16-rnd(16),y=127-(i*spacing+spacing-rnd(spacing)),radius=rnd{spacing-5,spacing-3,spacing+1},pitch=i*8+j})
        end
    end
    
    while true do
        _cover()
        if horizon>0 then
            rectfill(0,127-127*spacing/16,127,127,water)
        end
        local transparency=palt(left,false)
        local vibrations={}
        for ring in all(rings) do
            if #events>0 then
                local shadow=true
                for i=1,4 do
                    if events[#events][i].volume > 0 then
                        local pitch=events[#events][i].pitch+1+offset
                        if ring.pitch==pitch then
                        shadow=false 
                        end
                    end
                end
                if shadow then
                    if left>-1 then
                        circ(ring.x,ring.y,ring.radius-5,left)
                    end
                else
                    add(vibrations,{ring.x,ring.y,ring.radius+rnd(2)-1})
                    
                end
            end   
        end
        local c=1
        for vibe in all(vibrations) do
            color(foreground[c])
            circ(unpack(vibe))
            c+=1
        end
        palt(left,transparency)
        display_credits()
        yield()  
    end
end
function piano_roll()
    if (tune.palette) then 
        pal(tune.palette,1)
    else
        pal()
    end
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local offset=tune.offset or 0
    local spacing=tune.spacing or 2
    local foreground=tune.foreground or {8,8,8,8}
    local pitches={}
    while true do
        _cover()
        local t_left=palt(left,false)
        local t_right=palt(right,false)
        if #events>0 and (stat(46)>-1 or stat(47)>-1 or stat(48)>-1 or stat(49)>-1)then
            local event =events[#events]
            add(pitches,{
                event[1].volume>0 and event[1].pitch or -1,
                event[2].volume>0 and event[2].pitch or -1,
                event[3].volume>0 and event[3].pitch or -1,
                event[4].volume>0 and event[4].pitch or -1})
            if (#pitches>128) deli(pitches,1)
            for i=1,#pitches do
                local tracks=pitches[i] 
                local y=128-#pitches+i   
                for j=1,4 do
                    if tracks[j]>-1 then
                        local x=(tracks[j]+offset)*spacing  -- *spacing
                        pset(x,y,foreground[j])
                        if left>-1 then
                            pset(x-1,y,left)
                        end
                        if right>-1 then
                            pset(x+1,y,right)
                        end
                    end
                end
            end
        end

        palt(left,t_left)
        palt(right,t_right)
        display_credits()
        yield()  
    end
end
-->8
-- tunes
-- visualizers: -- bubble, cover, harp, piano_roll, ripples, stars
-- there are many options to customize.
-- see https://www.lexaloffle.com/bbs/?tid=55641&tkey=nJgBghT3cHfLF3diOmaf for details.
tunes=
{
    {
        pattern=0,  --music pattern number to play
        title="noodle cafe", 
        credit="fettuccini", 
        visualizer=piano_roll, -- bubble, cover, harp, piano_roll, ripples, stars
        background=-1, --background color, -1 for sprite sheet
    },
    {
        pattern=10,  --music pattern number to play
        title="noodle cafe (no percussion)", 
        credit="fettuccini", 
        visualizer=piano_roll, -- bubble, cover, harp, piano_roll, ripples, stars
        background=-1, --background color, -1 for sprite sheet
    },
}

-->8
-- custom instruments
-- pitch shift for custom instruments

instruments=
{
    [0]=0,[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,
    [8]=0, --custom instrument 0
    [9]=0, --custom instrument 1
    [10]=0, --custom instrument 2
    [11]=0, --custom instrument 3
    [12]=0, --custom instrument 4
    [13]=0, --custom instrument 5
    [14]=0, --custom instrument 6
    [15]=0, --custom instrument 7
}

-->8
-- init
function _init()
    frame=0
    sfx_addr = 0x3200
    left,right,up,down,fire1,fire2=0,1,2,3,4,5
    pitch_colors={[0]=  4,  11,  6,  13,  8,  15,  10,  5,  12,  7,  14, 9}
    track=1
    tune=tunes[track]
    visualize=cocreate(tune.visualizer)
    credits=true
    play_tune()
end
function play_tune()
    music(-1)
    events={}
    music(tune.pattern)
end

-->8
-- update
function _update()
    if btnp(right) then 
        track+=1
        if (track>#tunes)track=1
        tune=tunes[track]
        visualize=cocreate(tune.visualizer)
        credits=true
        play_tune()
    elseif btnp(left) then
        track-=1
        if (track<1)track=#tunes
        tune=tunes[track]
        visualize=cocreate(tune.visualizer)
        credits=true
        play_tune()
    elseif btnp(up) then
        credits=false
    elseif btnp(down) then
        credits=true
    elseif btnp(fire1) or btnp(fire2) then
        events={}
        visualize=cocreate(tune.visualizer)
        play_tune()
    end
    frame+=1
    get_notes()
end

function get_notes()
    --First byte / Low 8 bits--     w	w	p	p	p	p	p	p
    --Second byte / High 8 bits--   c	e	e	e	v	v	v	w
    local sfx_indices={stat(46),stat(47),stat(48),stat(49)}
    local note_indices={stat(50),stat(51),stat(52),stat(53) }
    local sounds={}
    local pitch,volume,effect,intstrument,hold
    new_flag=new_event(sfx_indices,note_indices) 
    if new_flag then
        for i=1,4 do
            if sfx_indices[i]>-1 then
                local addr= sfx_addr+sfx_indices[i]*68+note_indices[i]*2
                local byte1, byte2 =peek(addr),peek(addr+1)

                pitch=byte1 & 0x3f
                volume=(byte2&0x0e)\2
                effect=(byte2&0x70)\16
                instrument=(byte2&0x80)\16+(byte2&0x01)*4+byte1\64
                if instrument > 7 then --custom instrument
                    pitch+=instruments[instrument] --transpose pitch if necessary
                end
            else
                pitch,volume,effect,instrument,hold=-1,0,-1,-1
            end
            
            if #events>0 and pitch==events[#events][i].pitch then
                hold=true
            else
                hold=false
            end 
            add(sounds,{pitch=pitch,volume=volume,effect=effect,instrument=instrument,hold=hold})
        end
        add(events,sounds)
        events[#events].sfx_indices=sfx_indices
        events[#events].note_indices=note_indices
        if #events>128 then
            deli(events,1)
        end
    end
    return new_flag
end

function new_event(sfx_indices,note_indices)
    local result=false
    if #events==0 then
        for i=1,4 do
            if sfx_indices[i]>-1 then
                result=true
                break
            end
        end
    else
        for i=1,4 do
            if note_indices[i] !=events[#events].note_indices[i] then
                result=true
                break
            end
            if sfx_indices[i] !=events[#events].sfx_indices[i] then
                result=true
                break
            end
        end
    end
    return result
end
-- record function based on code by packbat
function record(pattern,repeats,fadeout)
    --export with fadeout and repeats
    extcmd("audio_rec")
    pattern=pattern or 0--set to beginning of song
    repeats=repeats or 1--number of loops before fadeout
    fadeout=fadeout or 5000--in milliseconds, max 32767
    print("recording")
    music(pattern)--start music
    for i_r=1,repeats+1 do
        print("recording... "..i_r)
        flip()
        repeat
            flip()
        until stat(55)>stat(54)-pattern or not stat(57)--loop detection
        --stat(55)=number of patterns played
        --stat(54)=current pattern number
        --if number of patterns played exceeds number of patterns advanced,
        --song has looped
        
        pattern=stat(54)-stat(55)--reset to detect next repeat
    end
    music(-1,fadeout)
    repeat
        flip()
    until not stat(57)--when playing, stat(57)==true
    extcmd("audio_end")
    print("recorded; check desktop.")
end
-->8
-- draw
function _draw()
    cls()
    local status, err = coresume(visualize)
    if not status then
        cls()
        stop(err)
    end
end
function display_credits()
    if credits then
        local credit,title=tune.credit,tune.title
        outline_print(title,1,1)
        outline_print(credit,1,7)
    end
end
function outline_print(text,x,y)
    local outline=tune.outline or 1
    local left, right=outline,outline
    if type(outline)=="table" then left,right=unpack(outline) end
    local c=tune.text or 7
    local t_left=palt(left,false)
    local t_right=palt(right,false)
    if left >-1 then
        print(text,x,y-1,left)
        print(text,x-1,y,left)
        print(text,x-1,y-1,left)
    end
    if right>-1 then
        print(text,x,y+1,right)
        print(text,x+1,y,right)
        print(text,x+1,y+1,right)
    end
    print(text,x,y,c)
    palt(left,t_left)
    palt(right,t_right)
end

__gfx__
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff44444444444ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff444444444444444ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffff4444444444444444444ffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffff44444444444444444444444ffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffff444444444442222244444444444ffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffff4444444444422211122244444444444ffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffff44444444444222311111322244444444444ffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffff444444444442223b3111113b322244444444444ffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffff44444444444222333b3111113b33322244444444444ffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffff444444444442223b333b3111113b333b322244444444444ffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff44444444444222333b333b3111113b333b33322244444444444ffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffff444444444442223b333b333b3111113b333b333b322244444444444ffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffff44444444444222333b333b333b3111113b333b333b33322244444444444ffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffff444444444442223b333b333b333b3111113b333b333b333b322244444444444ffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffff44444444444222333b333b333b333b3111113b333b333b333b33322244444444444ffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffff444444444442223b333b333b333b333b3111113b333b333b333b333b322244444444444ffffffffffffffffffffffffffff
fffffffffffffffffffffffffff44444444444222333b333b333b333b333b3111113b333b333b333b333b33322244444444444ffffffffffffffffffffffffff
fffffffffffffffffffffffff444444444442223b333b333b333b333b333b3111113b333b333b333b333b333b322244444444444ffffffffffffffffffffffff
fffffffffffffffffffffff44444444444222333b333b333b333b3367d33b3111113b3677763b333b333b333b33322244444444444ffffffffffffffffffffff
fffffffffffffffffffff444444444442223b333b333b333b333b6777d33b3111113b3a767776333b333b333b333b322244444444444ffffffffffffffffffff
fffffffffffffffffff44444444444222333b333b333b333b3367777df33b3111113b3a467777763b333b333b333b33322244444444444ffffffffffffffffff
fffffffffffffffff444444444442223b333b333b333b333b6777774da33b3111113b3a4246777776333b333b333b333b322244444444444ffffffffffffffff
fffffffffffffff44444444444222333b333b333b333b33677777424da33b3111113b3a4444467777763b333b333b333b33322244444444444ffffffffffffff
fffffffffffff444444444442223b333b333b333b333b677777d4444da33b3111113b3a44444446777776333b333b333b333b322244444444444ffffffffffff
fffffffffff44444444444222333b333b333b333b33677777644444d4a33b3111113b3a44449922267777763b333b333b333b33322244444444444ffffffffff
fffffffff444444444442223b333b333b333b333b677777d42e4944d4a33b3111113b3a449942224046777776333b333b333b333b322244444444444ffffffff
fffffff44444444444222333b333b333b333b33677777d44edd449944a33b3111113b3a9a924447ffff4f6777763b333b333b333b33322244444444444ffffff
fffff444444444442223b333b333b333b333b677777f44222dd444499a33b3111113b3a9224444ffffff446677776333b333b333b333b32224444444444fffff
fffff044444444222333b333b333b333b33677777fa0444d662444444a33b3111113b39a442429444449442f77777763b333b333b333b33322244444440fffff
fffff00024442223b333b333b333b333b677777644a44444444444449a33b3111113b3449a44229999a4242a0d7777776333b333b333b333b3222444200fffff
fffff00002422333b333b333b333b3367777764444a444444424449a9433b3111113b333449a92244444224a442d77777763b333b333b333b3332240000fffff
fffff0000243b333b333b333b333b6777776444444a9449444449a944333b3111113b333b3449a424442444a44444d7777776333b333b333b333b240000fffff
fffff0000243b333b333b333b33677777644e6f444a24424249a9443b333b3111113b333b333449a4244444a4444442d76777763b333b333b333b240000fffff
fffff0000243b333b333b333b6777776444dd6d444a422449a944333b333b3111113b333b333b3449a44444a44449444467777776333b333b333b240000fffff
fffff0000243b333b333b3367777764249446dd444a4449a9443b333b333b3111113b333b333b333449a444a24994444404d76777763b333b333b240000fffff
fffff0000243b333b333bd77777644442944444444a049944333b333b333b3111113b333b333b333b3449a4a994244444422267677776333b333b240000fffff
fffff0000243b333b333b7777613344f4949244944aa9443b333b333b333b3111113b333b333b333b333449a444424444442444d77777763b333b240000fffff
fffff0000243b333b333b7674333339f4449444499a44333b333b333b333b3111113b333b333b333b333b34a44444444e44f44244d7777776333b240000fffff
fffff0000243b333b333b76733333344494444249993b333b333b333b333b3111113b333b333b333b333b333a944244944ffff44444d77777733b240000fffff
fffff0000243b333b333b7674334d744444444999433b333b333b333b333b3111113b333b333b333b333b333b3a9442244666d44444406767733b240000fffff
fffff0000243b333b333b7674dfff6f244449a944333b333b333b333b333b3424423b333b333b333b333b333b333a942244d44444444400d6733b240000fffff
fffff0000243b333b333b7671d66ff44449a9443b333b333b333b333b333444424444333b333b333b333b333b333b3a942244448884447764733b240000fffff
fffff0000243b333b333b767444442249a944333b333b333b333b333b342242444442243b333b3331773b333b333b333a9424444884d66ffe733b240000fffff
fffff0000243b333b333b7674444249a9443b333b333b333b333b33344444224442244444333b34677777333b333b333b3a94444442d6777e733b240000fffff
fffff0000243b333b333b76744449a944333b333b333b333b333b34444244422022444244494477777776773b333b333b333a94242246d6d6733b240000fffff
fffff0000243b333b333b767249a9443b333b333b3336677b33344242444422202222444244f7f77776633667333b333b333b3a949a477776733b240000fffff
fffff0000243b333b333b7679a944333b333b333b377774477444444444222220222222444af77fff76d3f464773b333b333b333a94444444733b240000fffff
fffff0000243b333b333b6679443b333b333b3337f6d488847774444422222220222222222a99f77fff7f84d77776333b333b333b3a944444733b240000fffff
fffff0000243b333b333b3344333b333b333b3777767444776d7f442222222220220022222a1499f77fff7777ff7fa43b333b333b333a9244733b240000fffff
fffff0000243b333b333b333b333b333b33377d667777748f6776222222222220222200222a1114a9f77ffff77f94943b333b333b333b3a94733b240000fffff
fffff0000243b333b333b333b333b333b3faff63367777747766d222222202220222222002a11411999f77f7f9444943b333b333b333b3339733b240000fffff
fffff0000243b333b333b333b333b333fffffaf766777777666dd22222222022022222222299441d44499ff944444943b333b333b333b333b333b240000fffff
fffff0000243b333b333b333b333b3fafffffffaf77776666d67d222022202220220022222a2994414319449444449499333b333b333b333b333b240000fffff
fffff0000243b333b333b333b3337ffffffffaf77776666d6644d222202222220222200222a04499443194494444ff404993b333b333b333b333b240000fffff
fffff0000243b333b333b333b376b6fffffaf77776666dd7d004d222022222220222222002a0004499d1944949ff400106099333b333b333b333b240000fffff
fffff0000243b333b333b3337777666faff77776666dd7600004d22222222222022222222290440042999449990010640144d993b333b333b333b240000fffff
fffff0000243b333b333b376d36776d7777776666496d0000004d222222222220222222222999444002294499999004000d410099333b333b333b240000fffff
fffff0000243b333b3336666dd766776776666649aa600000004d2222222220000022222229499944400944999999900041006744993b333b333b240000fffff
fffff0000243b333b3334466666d67777666649a44a600000004d222222200eeeee002222294449994449449004a99990007600410999333b333b240000fffff
fffff0000243b333b3334444666677666664994004a600000004d2222200eeeeeeeee002229444449994944900004a999900461099999933b333b240000fffff
fffff0000243b333b333444444666666649a400044a600000046d22200eeeeeeeeeeeee002944444449994490000004a9999109999944933b333b240000fffff
fffff0000243b333b3334444444466f49aa9004444a600004764d200eeeeeeeeeeeeeeeee004444444449449042000404a99999944444933b333b240000fffff
fffff0000243b333b33344444444499a44a904229a9600476d6600eee00eeeeeeeeeeeeeeee0044444449449000420100049999444444933b333b240000fffff
fffff0000243b333b333444444444a4049a9204a42ad16646600eee0050eeeeeeeeee00eeeeee00444449449000004400000499444444933b333b240000fffff
fffff0000243b333b333444444444a29a9a9aa4004a76dd600eee005550eeeeeeeeee0500eeeeee004449449011000444000099444444933b333b240000fffff
fffff0000243b333b333444444444aa444a9400004ad6600eee00555550eeeeeeeeee055500eeeeee0049449001110400440099444444933b333b240000fffff
fffff0000243b333b333444444444a0449a4004444a600eeeee05555550eeeeaaeeee05555500eeeeee00249000000400004499444444933b333b240000fffff
fffff0000243b333b333444444444a9442a404449a00eeeeeee05555550eeaa99aaee05555550eeeeeeee009400000201100099444444933b333b240000fffff
fffff0000243b333b333444444444a0014a444aa00eeeeeeeee05555550aa977779aa05555550eeeeeeeeee0044000201114099444444933b333b240000fffff
fffff0000243b333b333444444444a2444a4aa00eeeeeeeeeee055555aa9977777799aa555550eeeeeeeeeeee00440200001099444444933b333b240000fffff
fffff0000243b333b333004444444a4449a900eeeeeeeeeeeee0555aa999977777a9949aa5550eeeeeeeeeeeeee004400000099444444933b333b240000fffff
fffff0000243b333b333ee0044444a04a900eeeeeeeeeeeeeee05aa9999996777a6999999aa50eeeeeeeeeeeeeeee0044400099444444033b333b240000fffff
fffff0000243b333b3eeeeee00444aa900eeeeeeeeeeeeeeeeeaa9999aa99966669999f9999aaeeeeeeeeeeeeeeeeee00492099444400ee3b333b240000fffff
fffff0000243b333eeeeeeeeee004a00eeeeeeeeeeeeeeeeeea99999ffff99999999f7f7a9999aeeeeeeeeeeeeeeeeeee0044994400eeeeee333b240000fffff
fffff0000243b3eeeeeeeeeeeeee00eeeeeeeeeeeeeeeeeeee2aa999f4e4f999999974e4f99aa2eeeeeeeeeeeeeeeeeeeee009900eeeeeeeeee3b240000fffff
fffff0000043eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee222aa99ee799444499afef9aa222eeeeeeeeeeeeeeeeeeeeeee00eeeeeeeeeeeeee240000fffff
fffff0000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22222aa9999943b499999aa22222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000fffff
fffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2205222aa9999a4a999aa2225022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000fffff
fffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee220550222aa999999aa222055022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffff
fffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22000eee222aa99aa222eee00022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffff
fffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeee220eeeeee0222aa2220eeeeee022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffff
fffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeee220eeeeee0ee2222ee0eeeeee022eeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffff
fffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeee220eeeeeeeeee22eeeeeeeeee022eeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffff
fffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeee220eeeeeeeeee22eeeeeeeeee022eeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffff
fffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffff
fffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffff
fffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffff
fffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffff
fffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffff
fffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffff000000000eeeee000000000ffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
__label__
111ff111f111111f11ff1111fffff111111111111111ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1771117711771771171f17771fff11771777177717771fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1717171717171717171f17111fff17111717171117111fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1717171717171717171f1771ffff171f177717711771ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
171717171717171717111711ffff1711171717111711ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1717177117711777177717771ffff1771717171f17771fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1111111111111111111111111111111111111111f1111fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
17771777177717771717117711771777177117771fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
17111711117111711717171117111171171711711fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
17711771f171f1711717171f171ff17117171171fffffffffffffffffff44444444444ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
17111711f171f171171717111711117117171171fffffffffffffffff444444444444444ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
171f17771171f171f177117711771777171717771ffffffffffffff4444444444444444444ffffffffffffffffffffffffffffffffffffffffffffffffffffff
f11ff1111f11ff11ff111f111f111111111111111ffffffffffff44444444444444444444444ffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffff444444444442222244444444444ffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffff4444444444422211122244444444444ffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffff44444444444222311111322244444444444ffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffff444444444442223b3111113b322244444444444ffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffff44444444444222333b3111113b33322244444444444ffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffff444444444442223b333b3111113b333b322244444444444ffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff44444444444222333b333b3111113b333b33322244444444444ffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffff444444444442223b333b333b3111113b333b333b322244444444444ffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffff44444444444222333b333b333b3111113b333b333b33322244444444444ffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffff444444444442223b333b333b333b3111113b333b333b333b322244444444444ffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffff44444444444222333b333b333b333b3111113b333b333b333b33322244444444444ffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffff444444444442223b333b333b333b333b3111113b333b333b333b333b322244444444444ffffffffffffffffffffffffffff
fffffffffffffffffffffffffff44444444444222333b333b333b333b333b3111113b333b333b333b333b33322244444444444ffffffffffffffffffffffffff
fffffffffffffffffffffffff444444444442223b333b333b333b333b333b3111113b333b333b333b333b333b322244444444444ffffffffffffffffffffffff
fffffffffffffffffffffff44444444444222333b333b333b333b3367d33b3111113b3677763b333b333b333b33322244444444444ffffffffffffffffffffff
fffffffffffffffffffff444444444442223b333b333b333b333b6777d33b3111113b3a767776333b333b333b333b322244444444444ffffffffffffffffffff
fffffffffffffffffff44444444444222333b333b333b333b3367777df33b3111113b3a467777763b333b333b333b33322244444444444ffffffffffffffffff
fffffffffffffffff444444444442223b333b333b333b333b6777774da33b3111113b3a4246777776333b333b333b333b322244444444444ffffffffffffffff
fffffffffffffff44444444444222333b333b333b333b33677777424da33b3111113b3a4444467777763b333b333b333b33322244444444444ffffffffffffff
fffffffffffff444444444442223b333b333b333b333b677777d4444da33b3111113b3a44444446777776333b333b333b333b322244444444444ffffffffffff
fffffffffff44444444444222333b333b333b333b33677777644444d4a33b3111113b3a44449922267777763b333b333b333b33322244444444444ffffffffff
fffffffff444444444442223b333b333b333b333b677777d42e4944d4a33b3111113b3a449942224046777776333b333b333b333b322244444444444ffffffff
fffffff44444444444222333b333b333b333b33677777d44edd449944a33b3111113b3a9a924447ffff4f6777763b333b333b333b33322244444444444ffffff
fffff444444444442223b333b333b333b333b677777f44222dd444499a33b3111113b3a9224444ffffff446677776333b333b333b333b32224444444444fffff
fffff044444444222333b333b333b333b33677777fa0444d662444444a33b3111113b39a442429444449442f77777763b333b333b333b33322244444440fffff
fffff00024442223b333b333b333b333b677777644a44444444444449a33b3111113b3449a44229999a4242a0d7777776333b333b333b333b3222444200fffff
fffff00002422333b333b333b333b3367777764444a444444424449a9433b3111113b333449a92244444224a442d77777763b333b333b333b3332240000fffff
fffff0000243b333b333b333b333b6777776444444a9449444449a944333b3111113b333b3449a424442444a44444d7777776333b333b333b333b240000fffff
fffff0000243b333b333b333b33677777644e6f444a24424249a9443b333b3111113b333b333449a4244444a4444442d76777763b333b333b333b240000fffff
fffff0000243b333b333b333b6777776444dd6d444a422449a944333b333b3111113b333b333b3449a44444a44449444467777776333b333b333b240000fffff
fffff0000243b333b333b3367777764249446dd444a4449a9443b333b333b3111113b333b333b333449a444a24994444404d76777763b333b333b240000fffff
fffff0000243b333b333bd77777644442944444444a049944333b333b333b3111113b333b333b333b3449a4a994244444422267677776333b333b240000fffff
fffff0000243b333b333b7777613344f4949244944aa9443b333b333b333b3111113b333b333b333b333449a444424444442444d77777763b333b240000fffff
fffff0000243b333b333b7674333339f4449444499a44333b333b333b333b3111113b333b333b333b333b34a44444444e44f44244d7777776333b240000fffff
fffff0000243b333b333b76733333344494444249993b333b333b333b333b3111113b333b333b333b333b333a944244944ffff44444d77777733b240000fffff
fffff0000243b333b333b7674334d744444444999433b333b333b333b333b3111113b333b333b333b333b333b3a9442244666d44444406767733b240000fffff
fffff0000243b333b333b7674dfff6f244449a944333b333b333b333b333b3424423b333b333b333b333b333b333a942244d44444444400d6733b240000fffff
fffff0000243b333b333b7671d66ff44449a9443b333b333b333b333b333444424444333b333b333b333b333b333b3a942244448884447764733b240000fffff
fffff0000243b333b333b767444442249a944333b333b333b333b333b342242444442243b333b3331773b333b333b333a9424444884d66ffe733b240000fffff
fffff0000243b333b333b7674444249a9443b333b333b333b333b33344444224442244444333b34677777333b333b333b3a94444442d6777e733b240000fffff
fffff0000243b333b333b76744449a944333b333b333b333b333b34444244422022444244494477777776773b333b333b333a94242246d6d6733b240000fffff
fffff0000243b333b333b767249a9443b333b333b3336677b33344242444422202222444244f7f77776633667333b333b333b3a949a477776733b240000fffff
fffff0000243b333b333b7679a944333b333b333b377774477444444444222220222222444af77fff76d3f464773b333b333b333a94444444733b240000fffff
fffff0000243b333b333b6679443b333b333b3337f6d488847774444422222220222222222a99f77fff7f84d77776333b333b333b3a944444733b240000fffff
fffff0000243b333b333b3344333b333b333b3777767444776d7f442222222220220022222a1499f77fff7777ff7fa43b333b333b333a9244733b240000fffff
fffff0000243b333b333b333b333b333b33377d667777748f6776222222222220222200222a1114a9f77ffff77f94943b333b333b333b3a94733b240000fffff
fffff0000243b333b333b333b333b333b3faff63367777747766d222222202220222222002a11411999f77f7f9444943b333b333b333b3339733b240000fffff
fffff0000243b333b333b333b333b333fffffaf766777777666dd22222222022022222222299441d44499ff944444943b333b333b333b333b333b240000fffff
fffff0000243b333b333b333b333b3fafffffffaf77776666d67d222022202220220022222a2994414319449444449499333b333b333b333b333b240000fffff
fffff0000243b333b333b333b3337ffffffffaf77776666d6644d222202222220222200222a04499443194494444ff404993b333b333b333b333b240000fffff
fffff0000243b333b333b333b376b6fffffaf77776666dd7d004d222022222220222222002a0004499d1944949ff400106099333b333b333b333b240000fffff
fffff0000243b333b333b3337777666faff77776666dd7600004d22222222222022222222290440042999449990010640144d993b333b333b333b240000fffff
fffff0000243b333b333b376d36776d7777776666496d0000004d222222222220222222222999444002294499999004000d410099333b333b333b240000fffff
fffff0000243b333b3336666dd766776776666649aa600000004d2222222220000022222229499944400944999999900041006744993b333b333b240000fffff
fffff0000243b333b3334466666d67777666649a44a600000004d222222200eeeee002222294449994449449004a99990007600410999333b333b240000fffff
fffff0000243b333b3334444666677666664994004a600000004d2222200eeeeeeeee002229444449994944900004a999900461099999933b333b240000fffff
fffff0000243b333b333444444666666649a400044a600000046d22200eeeeeeeeeeeee002944444449994490000004a9999109999944933b333b240000fffff
fffff0000243b333b3334444444466f49aa9004444a600004764d200eeeeeeeeeeeeeeeee004444444449449042000404a99999944444933b333b240000fffff
fffff0000243b333b33344444444499a44a904229a9600476d6600eee00eeeeeeeeeeeeeeee0044444449449000420100049999444444933b333b240000fffff
fffff0000243b333b333444444444a4049a9204a42ad16646600eee0050eeeeeeeeee00eeeeee00444449449000004400000499444444933b333b240000fffff
fffff0000243b333b333444444444a29a9a9aa4004a76dd600eee005550eeeeeeeeee0500eeeeee004449449011000444000099444444933b333b240000fffff
fffff0000243b333b333444444444aa444a9400004ad6600eee00555550eeeeeeeeee055500eeeeee0049449001110400440099444444933b333b240000fffff
fffff0000243b333b333444444444a0449a4004444a600eeeee05555550eeeeaaeeee05555500eeeeee00249000000400004499444444933b333b240000fffff
fffff0000243b333b333444444444a9442a404449a00eeeeeee05555550eeaa99aaee05555550eeeeeeee009400000201100099444444933b333b240000fffff
fffff0000243b333b333444444444a0014a444aa00eeeeeeeee05555550aa977779aa05555550eeeeeeeeee0044000201114099444444933b333b240000fffff
fffff0000243b333b333444444444a2444a4aa00eeeeeeeeeee055555aa9977777799aa555550eeeeeeeeeeee00440200001099444444933b333b240000fffff
fffff0000243b333b333004444444a4449a900eeeeeeeeeeeee0555aa999977777a9949aa5550eeeeeeeeeeeeee004400000099444444933b333b240000fffff
fffff0000243b333b333ee0044444a04a900eeeeeeeeeeeeeee05aa9999996777a6999999aa50eeeeeeeeeeeeeeee0044400099444444033b333b240000fffff
fffff0000243b333b3eeeeee00444aa900eeeeeeeeeeeeeeeeeaa9999aa99966669999f9999aaeeeeeeeeeeeeeeeeee00492099444400ee3b333b240000fffff
fffff0000243b333eeeeeeeeee004a00eeeeeeeeeeeeeeeeeea99999ffff99999999f7f7a9999aeeeeeeeeeeeeeeeeeee0044994400eeeeee333b240000fffff
fffff0000243b3eeeeeeeeeeeeee00eeeeeeeeeeeeeeeeeeee2aa999f4e4f999999974e4f99aa2eeeeeeeeeeeeeeeeeeeee009900eeeeeeeeee3b240000fffff
fffff0000043eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee222aa99ee799444499afef9aa222eeeeeeeeeeeeeeeeeeeeeee00eeeeeeeeeeeeee240000fffff
fffff0000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22222aa9999943b499999aa22222eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000fffff
fffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2205222aa9999a4a999aa2225022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000fffff
fffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee220550222aa999999aa222055022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffff
fffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22000eee222aa99aa222eee00022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffff
fffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeee220eeeeee0222aa2220eeeeee022eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffff
fffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeee220eeeeee0ee2222ee0eeeeee022eeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffff
fffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeee220eeeeeeeeee22eeeeeeeeee022eeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffff
fffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeee220eeeeeeeeee22eeeeeeeeee022eeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffff
fffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffff
fffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeee22eeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffff
fffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffff
fffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffff
fffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffff
fffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeee22eeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffff000000000eeeeeeeee000000000ffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffff000000000eeeee000000000ffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff

__map__
100102030405060708090a0b0c0d0e0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
101112131415161718191a1b1c1d1e1f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
202122232425262728292a2b2c2d2e2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
303132333435363738393a3b3c3d3e3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
404142434445464748494a4b4c4d4e4f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
505152535455565758595a5b5c5d5e5f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
606162636465666768696a6b6c6d6e6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
707172737475767778797a7b7c7d7e7f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
808182838485868788898a8b8c8d8e8f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
909192939495969798999a9b9c9d9e9f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0a1a2a3a4a5a6a7a8a9aaabacadaeaf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b0b1b2b3b4b5b6b7b8b9babbbcbdbebf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c2c3c4c5c6c7c8c9cacbcccdcecf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d2d3d4d5d6d7d8d9dadbdcdddedf00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e1e2e3e4e5e6e7e8e9eaebecedeeef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15100000160430c0300c0350c035356130c0000e0300e030160430e0300e0300e032356130e0350e0350e03516043100301003510035356130c0000e0300e030160430e0300e0300e032356130e0320e0320e032
0d1000001c0341c0301c0351c0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0351d0351d0351f0341f0301f0351f0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0321d0321d032
15100000160430c0300c0350c035356130c0000e0300e030160430e0300e0300e032356130e0350e0350e03516043100301003510035356130c0000f0300f035160430e0300e0300e032356130e0320e0320e032
0d1000001c0341c0301c0351c0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0351d0351d0351f0341f0301f0351f0350c0001e0001e0301e0351d0341d0301d0301d0321d0341d0321d0321d032
15100000160430c0300c0350c035356130c0000e0300e030160430e0300e0300e032356130e0350e0350e03516043100301003510035356130c0000f0300f035160430e0300e0300e03235613100351003210033
0d1000001c0341c0301c0351c0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0351d0351d0351f0341f0301f0351f0350c0001e0001e0301e0351d0341d0301d0301d0321f0341f0352003220033
1510000016043110301103511035356130c0001303013030160431303013030130303561313035130351303516043100301003510035356130c00015030150301604315030150301503235613150321503215032
0d100000210342103021035210350c0000c0001c0301c0301a0341a0301a0301c0311c0341c0351a0351a0351f0341f0301f0351f0350c0000c00018030180301803418030180301803218034180321803218032
15100000160430e0300e0330e00035613100401003510000160431104011043110003561312040120431303016043130301303513035356131303213032130321604313022130221302235613130121301213015
151000001d0341d0321d0331d0001c0441c0421c0351c000150341504215043000001a0311a0321a0331803018032180321803218032180321803218032180321802218022180221802218012180121801218015
051000002874428743007002a7002b7402b7432b7002b7002474424740247402474026741267422674226745287412874026740267402474024745217451f7401f7401f7401f7421f7421f7351f7352174524755
05100000007000070028740287432a7002b7412b7402b74024744247402474024743267402674026740267452874128740267402674024740247452d7452b7402b7402b7422b7422b7422b743000001f0001f000
0510000024700187002b7402b7432d7402174528741287402b7412b7402b7402d7412d7402d7402b7402b74300700007002b740297402874029740260002874128740267402674224742247421f7451f7421f743
0510000024700247002474426740267402674028740287402b7412b7402b7401f7452b74529740287402674524730267302b7402d7402b74028740267302874228733247302673224722217221f732217551f755
0510000024744247402474326741267402674528740287432b7442b7402b7402d7412d7402d7402b7402b74300700007002b7402b7432d7402f74000000307403074030730307323072230722307123074532745
051000003573435730357332670034734347303473328700307343073030733217002d7312d7302d7352b7302b7302b7302b7302b7302b7322b7222b7222b7222b7222b7222b7222b7122b7122b7122b7122b715
151000000c0340c0300c0350c0353c6000c0000e0300e0300e0340e0300e0300e0320e0340e0350e0350e035100341003010035100353c6000c0000e0300e0300e0340e0300e0300e0320e0340e0320e0320e032
151000000c0340c0300c0350c0353c6000c0000e0300e0300e0340e0300e0300e0320e0340e0350e0350e035100341003010035100353c6000c0000f0300f0350e0340e0300e0300e0320e0340e0320e0320e032
151000000c0340c0300c0350c0353c6000c0000e0300e0300e0340e0300e0300e0320e0320e0350e0350e035100341003010035100353c6000c0000f0300f0350e0340e0300e0300e0320e034100351003210033
15100000110341103011035110353c6000c00013030130301303413030130301303013034130351303513035100341003010035100353c6000c00015030150301503415030150301503215034150321503215032
151000000e0340e0320e0330e00010044100421003510000110441104211043110001204112042120431303013032130321303513035130321303213032130321302213022130221302213012130121301213015
__music__
01 08095355
00 0a0b5353
00 08091254
00 0a0b1355
00 08091254
00 0c0d1355
00 0e0f1455
00 0e0f1555
00 0e0f1655
02 10111755
01 18095355
00 190b5353
00 18091254
00 190b1355
00 18091254
00 1a0d1355
00 1b0f1455
00 1b0f1555
00 1b0f1655
02 1c111755
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52
00 494a4b52

