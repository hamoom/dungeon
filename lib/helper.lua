local floor = math.floor
-- local m = require("myapp")
local Helper = {}

Helper.chain = {}

-- function Helper.chain.new()

--     local function formatEvent(self, event, counter)

--         local func = function() end

--         if event then
--             if event.dispatch then
--                 func = function()
--                     Runtime:dispatchEvent({name=event.dispatch, onComplete=self:formatEvent(self.sequence[counter+1], counter+1)})
--                 end
--             elseif event.timer then
--                 func = function()
--                      m.addTimer(event.timer, self:formatEvent(self.sequence[counter+1], counter+1), 1)
--                 end
--             elseif event.transition then
--                 func = function()
--                     event.transition.onComplete = self:formatEvent(self.sequence[counter+1], counter+1)
--                     transition.to(event.obj, event.transition)
--                 end
--             elseif event.fn then
--                 func = function()
--                     event.fn()
--                     self:formatEvent(self.sequence[counter+1], counter+1)()
--                 end
--             end
--         end

--         return func
--     end

--     local function run(self, events)
--         self.sequence = events
--         self:formatEvent(self.sequence[1], 1)()
--     end

--     local chain = {}
--     chain.sequence = {}

--     chain.formatEvent = formatEvent
--     chain.run = run
--     return chain
-- end

function Helper.formatTime(seconds)
    local secs = floor(seconds)
    local secsDec = (seconds - secs) * 100
    return string.format("%02d.%02d", secs, secsDec)
end


function Helper.countDown(timer, max, reset, action)
    timer = timer - m.dt
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
        -- print(localX, localY)

        local paddingX = paddingX or 0
        local paddingY = paddingY or 0

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
    local a = a
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
        transition.to(thing, {time=howlong, delta=true, [axis]=0, transition=Helper.easeSin(f,a, damping), onComplete=function()
            if fn then
                fn()
            end
        end})
    end
end


function Helper.impulse(objects, duration)
    duration = duration / 1000

    local function animation()
        duration = duration - m.dt
        for _, obj in ipairs(objects) do
            if obj.x and obj.y then
                obj.x = obj.x + (obj.vector.x * obj.speed * m.dt)
                obj.y = obj.y + (obj.vector.y * obj.speed * m.dt)

                if obj.vector.y < 1 then
                    obj.vector.y = obj.vector.y + 0.045
                end

                if duration <= 0 then
                    Runtime:removeEventListener("enterFrame", animation)
                    m.eachFrameRemove(animation)
                    obj.isVisible = false
                end
            end
        end
    end
    m.eachFrame(animation)
end

function Helper.verticalCollisions(velocityStep, obj1, obj2)
    local yMod = math.abs(velocityStep.y)
    local xMod = math.abs(velocityStep.x)

    local bottom = (
        yMod > xMod
        and velocityStep.y > 0
        and math.floor(Helper.bottomEdge(obj1) - math.abs(velocityStep.y)) <= math.ceil(Helper.topEdge(obj2))
    ) and true or false


    local top = (
        yMod > xMod
        and velocityStep.y < 0
        and math.floor(Helper.topEdge(obj1) + math.abs(velocityStep.y)) >= math.ceil(Helper.bottomEdge(obj2))
    ) and true or false

    return {
        bottom = bottom,
        top = top
    }
end

function Helper.clamp(num, min, max)
    if num < min then num = min elseif num > max then num = max end
    return num
end

function Helper.bottomEdge(obj)
    return obj.y + obj.height/2
end

function Helper.topEdge(obj)
    return obj.y - obj.height/2
end

function Helper.leftEdge(obj)
    return obj.x - obj.width/2
end

function Helper.rightEdge(obj)
    return obj.x + obj.width/2
end

function Helper.leftBoundary(obj1, obj2)
    local offset = (obj2.x + obj2.width/2) - (obj1.x - obj1.width/2)
    return Helper.clamp(offset, 0, offset)
end

function Helper.rightBoundary(obj1, obj2)
    local offset = (obj1.x + obj1.width/2) - (obj2.x - obj2.width/2)
    return Helper.clamp(offset, 0, offset)
end

function Helper.bottomBoundary(obj1, obj2)
    local offset = (obj1.y + obj1.height/2) - (obj2.y - obj2.height/2)
    return Helper.clamp(offset, 0, offset)
end

function Helper.topBoundary(obj1, obj2)
    local offset = (obj2.y + obj2.height/2) - (obj1.y - obj1.height/2)
    return Helper.clamp(offset, 0, offset)
end

function Helper.boundaries(obj1, obj2)
    return {
        top=Helper.topBoundary(obj1, obj2),
        bottom=Helper.bottomBoundary(obj1, obj2),
        right=Helper.rightBoundary(obj1, obj2),
        left=Helper.leftBoundary(obj1, obj2)
    }
end

function Helper.shortestBoundary(obj1, obj2)
    local boundaries = Helper.boundaries(obj1, obj2)
    local collision = {}

    -- find side of collision
    for direction, boundary in pairs(boundaries) do
        if not collision.boundary then
            collision.direction = direction
            collision.boundary = boundary
        end

        if collision.boundary > boundary then
            collision.direction = direction
            collision.boundary = boundary
        end
    end

    return boundaries, collision
end


function Helper.hasCollided(obj1, obj2)
    if ( obj1 == nil ) then  -- Make sure the first object exists
        return false
    end
    if ( obj2 == nil ) then  -- Make sure the other object exists
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

    return (left or right) and (up or down)
end

return Helper