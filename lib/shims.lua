function wav(s)
  return "/home/we/dust/audio/voyage/"..s..".wav"
end

function nature(vol)
  if vol==nil then
    vol=0
  end
  engine.wav(4,wav("birds_eating"))
  engine.wav(5,wav("birds_morning"))
  engine.wav(6,wav("waves"))
  engine.amp(4,1*vol)
  engine.amp(5,2*vol)
  engine.amp(6,0.2*vol)
end

function expand(name,num)
  ta:expand(name,num)
end

function cclfo(name,ccnum,period,slo,shi)
  ta:add(name..ccnum,er(string.format('mp:cc("%s",%d,lfo(%2.2f,%d,%d))',name,ccnum,period,slo,shi),12),1)
end

function play(name,notes,i)
  if name=="crow" then
    ta:add(name,ta:sound(notes,'crow.output[1].volts=<v>;crow.output[2]()'),i)
  elseif name=="kick" or name=="hh" or name=="clap" or name=="sd" or name=="oh" then
    for i,v in ipairs(notes) do
      if v~="" then
        notes[i]=name..":hit()"
      end
    end
    ta:add(name,notes,i)
  elseif mp:ismidi(name) then
    ta:add(name,ta:sound(notes,"mp:on('"..name.."',<m>,<sn>)","mp:off('"..name.."',-1)"),i)
  else
    ta:add(name,notes,i)
  end
end

function stop(name)
  if mp:ismidi(name) then
    mp:off(name,-1)
  end
  ta:rm(name)
end

function tapebreak()
  engine.tapebreak()
end

function tapestop()
  engine.tapebreak()
  engine.taperate(0.01)
end

function tapestart()
  clock.run(function()
    engine.taperate(1)
    clock.sync(8)
    engine.tapebreak()
  end)
end

function arp(s,num)
  local t=string.split(s)
  if num==nil then
    num=16
  end
  local t2={}
  local tlen=#t
  for i=1,num do
    table.insert(t2,t[(i-1)%tlen+1])
  end
  return table.concat(t2," ")
end

function arpr(s,num)
  local t=string.split(s)
  if num==nil then
    num=16
  end
  local t2={}
  for i=1,num do
    table.insert(t2,t[math.random(#t)])
  end
  return table.concat(t2," ")
end

function carp(s,num)
  local t=string.split(s)
  local notearray={}
  for _, ss in ipairs(t) do
    local notes=music.to_midi(ss)
    for _, n in ipairs(notes) do
      table.insert(notearray,string.lower(n.n))
    end
  end
  return arp(table.concat(notearray," "),num)
end

function carpr(s,num)
  local t=string.split(s)
  local notearray={}
  for _, ss in ipairs(t) do
    local notes=music.to_midi(ss)
    for _, n in ipairs(notes) do
      table.insert(notearray,string.lower(n.n))
    end
  end
  return arpr(table.concat(notearray," "),num)
end

function reverse_prob(i,v)
  if v==nil then
    v=0
  end
  play("bbr",er("if math.random()<"..v.." then engine.reverse("..i..",1) end",5))
end

function glitch_prob(i,v)
  if v==nil then
    v=0
  end
  ta:add("bbb",er("if math.random()<"..v.." then; v=math.random(); engine.loop("..i..",v,v+math.random()/40+0.01) end",4),1)
end


function beatsync(i,totalbeats)
  local v = totalbeats*4
  ta:add("bb",er("if math.random()<0.5 then engine.pos("..i..",(<sn>-1)%"..v.."/"..v..") end",4),1)
end
