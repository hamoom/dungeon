local floor = math.floor
local mabs = math.abs
local mround = math.round
local physics = require('physics')
local Helper = {}


function Helper.formatTime(seconds)
  local secs = floor(seconds)
  local secsDec = (seconds - secs) * 100
  return string.format("%02d.%02d", secs, secsDec)
end


function Helper.countDown(timer, max, reset, action)
  timer = timer - _G.m.dt
  if reset then reset() end
  if timer <= 0 then
    if action then action() end
    timer = max
  end

  return timer
end

function Helper.isActive(obj, paddingX, paddingY)

  if obj.localToContent then
    local localX, localY = obj:localToContent(0, 0)

    paddingX = paddingX or 0
    paddingY = paddingY or 0

    local minX, maxX = -obj.width/2 - paddingX, display.contentWidth + obj.width/2 + paddingX
    local minY, maxY = -obj.height/2 - paddingY, display.contentHeight + obj.height/2 + paddingY

    return (localX > minX and localX < maxX) and (localY > minY and localY < maxY)
  else
    return false
  end
end

function Helper.sign(num)
  return (num < 0) and -1 or 1
end

function Helper.easeSin(f,a, damping)
  return function(t, tMax, start, delta)
    a = a * damping
    return start + delta + a * math.sin((t/tMax) * f * math.pi * 2)
  end
end

function Helper.randomBetween(min, max)
  if max < min then
    error("max cannot be less than min")
  end
  return math.random() * (max - min) + min
end
function Helper.randomSign()
  return (math.random(0, 1) == 1) and 1 or -1
end

function Helper.oscillate(f, a, axis, howlong, damping, fn)

  if not damping then damping = 0.7 end
  return function(thing)
    transition.to(thing, {time=howlong, delta=true, [axis]=0, transition=Helper.easeSin(f, a, damping), onComplete=function()
      if fn then
        fn()
      end
    end})
  end
end

function Helper.oscillateMultiple(maxCount, obj, fn, f, a, axis, howlong, damping)
  local count = 0
  f = f or 3
  a = a or 3
  axis = axis or 'x'
  howlong = howlong or 300
  damping = damping or 1

  local function oscillateMultiple()
    _G.h.oscillate(f, a, axis, howlong, damping, function()
      count = count + 1
      if count < maxCount then
        oscillateMultiple()
      elseif fn then
        fn()
      end
    end)(obj)
  end

  oscillateMultiple()
end

function Helper.clamp(num, min, max)
    if num < min then num = min elseif num > max then num = max end
    return num
end

function Helper.hasCollided(obj1, obj2)
    if obj1 == nil
    or obj1.state and obj1.state.name == 'death' then  -- Make sure the first object exists
      return false
    end
    if obj2 == nil
    or obj2.state and obj2.state.name == 'death' then  -- Make sure the other object exists
      return false
    end

    local function left()
      return obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    end

    local function right()
      return obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    end

    local function up()
      return obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    end

    local function down()
      return obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
    end

    return (left() or right()) and (up() or down())
end

function Helper.dumpvar(data)
    -- cache of tables already printed, to avoid infinite recursive loops
    local tablecache = {}
    local buffer = ""
    local padder = "  "

    local function _dumpvar(d, depth)
        local t = type(d)
        local str = tostring(d)
        if (t == "table") then
            if (tablecache[str]) then
                -- table already dumped before, so we dont
                -- dump it again, just mention it
                buffer = buffer.."<"..str..">\n"
            else
                tablecache[str] = (tablecache[str] or 0) + 1
                buffer = buffer.."("..str..") {\n"
                for k, v in pairs(d) do
                    buffer = buffer..string.rep(padder, depth+1).."["..k.."] => "
                    _dumpvar(v, depth+1)
                end
                buffer = buffer..string.rep(padder, depth).."}\n"
            end
        elseif (t == "number") then
            buffer = buffer.."("..t..") "..str.."\n"
        else
            buffer = buffer.."("..t..") \""..str.."\"\n"
        end
    end
    _dumpvar(data, 0)
    print(buffer)
end

function Helper.findValidCoord(ent, map, range)

  local randomPt ={
    x = ent.x + math.random(-range, range),
    y = ent.y + math.random(-range, range)
  }
  --
  -- randomPt.x = Helper.clamp(randomPt.x, ent.x - range, ent.x + range)
  -- randomPt.y = Helper.clamp(randomPt.y, ent.y - range, ent.y + range)

-- for obj in map.layer['barriers'].objects() do

  local coorx, coory = map.pixelsToTiles(randomPt.x, randomPt.y)
  local validTile = map.layer["ground"].tile(coorx, coory)
    and not map.layer["walls"].tile(coorx, coory)


  local hits = physics.rayCast(ent.x, ent.y, randomPt.x, randomPt.y, 'closest')
  -- line = display.newLine(m.map.layer['ground'], ent.x, ent.y, randomPt.x, randomPt.y)

  local clearPath = not hits

  return (validTile and clearPath) and randomPt or nil
end


function Helper.getAngle(x, lastX, y, lastY)

  local real_vx, real_vy = x - lastX, y - lastY
  local avx, avy = mround(mabs(real_vx)), mround(mabs(real_vy))
  local angle

  if avy > avx then
    if real_vy < 0 then
      angle = -180
      -- print('top')
    elseif real_vy > 0 then
      angle = 0
      -- print('bottom')
    end
  elseif avx > avy then

    if real_vx > 0 then
      angle = -90
      -- print('right')
    elseif real_vx < 0 then
      angle = 90
      -- print('left')
    end
  end

  return angle
end

function Helper.getFacing(x, lastX, y, lastY)
  local angle = Helper.getAngle(x, lastX, y, lastY)
  if angle == -180 then return 'top' end
  if angle == 0 then return 'bottom' end
  if angle == -90 then return 'right' end
  if angle == 90 then return 'left' end
end

function Helper.getAngleFromDir(dir)
  local angles = {
    top = -180,
    bottom = 0,
    right = -90,
    left = 90
  }
  return angles[dir]
end


function Helper.rotateToward(obj1, obj2)
  local angle

  local absX, absY = math.abs(obj1.x - obj2.x), math.abs(obj1.y - obj2.y)

  if absY > absX then
    if obj1.y > obj2.y then
      angle = -180
    else
      angle = 0
    end
  else
    if obj1.x < obj2.x then
      angle = -90
    else
      angle = 90
    end
  end

  return angle
end

function Helper.stutter()

  physics.pause()

  for _, v in pairs(_G.m.spriteList) do
    if v.pause then v:pause() end
  end

  for _, v in pairs(_G.m.timers) do
    if not v._expired then
      timer.pause(v)
    end
  end
  transition.pause()

  timer.performWithDelay(100, function()
    physics.start()

    for _, v in pairs(_G.m.spriteList) do
      if v.play then v:play() end
    end

    for _, v in pairs(_G.m.timers) do
      if not v._expired then
        timer.resume(v)
      end
    end
    transition.resume()
  end, 1)

end

return Helper
