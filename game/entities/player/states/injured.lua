local Public = {}
local mrand = math.random
local mabs = math.abs
function Public:new(ent)
  local State = {}
  State.bloods = {}

  for i = 1, 10 do
    local blood = display.newRect(_G.m.map.layer["ground"], 0, 0, mrand(2,4), mrand(2,4))
    blood:setFillColor(1,0,0)
    blood.isVisible = false
    State.bloods[#State.bloods+1] = blood
  end

  local function bloodSplosion()

    for _, blood in pairs(State.bloods) do
      local randomSpread = math.random(-5,5)
      blood.vector = {x=_G.h.randomBetween(-1,1), y=_G.h.randomBetween(-1,1)}
      blood.speed = 300
      blood.isVisible = true
      blood.x, blood.y = ent.x + randomSpread, ent.y + randomSpread
    end
    _G.h.impulse(State.bloods, 100)
  end

  function State:update()
    self.bloodTimer = self.bloodTimer - (_G.m.dt * 1000)

    if self.bloodTimer <= 0 then

      local sizeX, sizeY = mrand(2, 7), mrand(2, 7)

      local group = _G.m.map.layer['ground']

      for i = 1, self.bloodAmount do
        local blood = display.newRect(group, ent.x + mrand(-5, 5), ent.y + mrand(-5, 5), sizeX, sizeY)
        blood:setFillColor(1,0,0)
        transition.to(blood, {delay = 4000, alpha = 0, time = 1500, onComplete = function()
          display.remove(blood)
        end})

      end
      self.bloodAmount = self.bloodAmount - 3
      if self.bloodAmount < 1 then self.bloodAmount = 1 end

      self.bloodTimer = self.bloodtimerMax

    end
  end

  function State:start(enemy)
    ent.health = ent.health - 3

    Runtime:dispatchEvent({ name = 'changeHealth', params = { health = ent.health }})

    local diff = _G.p.newFromSubtraction(ent, enemy):normalize()

    diff.x = diff.x + (mrand(-100, 100) / 100)
    diff.y = diff.y + (mrand(-100, 100) / 100)

    ent:setLinearVelocity(0,0)
    ent:applyLinearImpulse(0.2 * diff.x, 0.2  * diff.y, ent.x, ent.y)
    -- ent.alpha = 0.3

    self.bloodtimerMax = 1
    self.bloodTimer = 0
    self.bloodAmount = 10
    bloodSplosion()
    ent.sprite.fill.effect = 'filter.brightness'
    ent.sprite.fill.effect.intensity = 1

    _G.m.addTimer(50, function()
      ent.sprite.fill.effect = ""

      if ent.health <= 0 then
        ent:setState('death')
      else
        _G.m.addTimer(250, function()
          ent:setState('stopped')
        end)
      end
    end)
    
    _G.h.stutter()

  end

  function State:exit()
  end

  return State
end


return Public
