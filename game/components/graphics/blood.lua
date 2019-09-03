local mrand = math.random
local Public = {}
Public.name = 'blood'

function Public.new(ent, args)
  local customBlood = unpack(args)
  local bloodColor = customBlood or {r = 1, g = 0, b = 0}
  local BloodComponent = {}

  BloodComponent.bloodtimerMax = 1
  BloodComponent.bloodTimer = 0
  BloodComponent.bloodAmount = 10
  BloodComponent.totalBleedTime = 2

  function BloodComponent:createStreak()
    self.bloodTimer = self.bloodTimer - (_G.m.dt * 1000)

    if self.bloodTimer <= 0 then
      local sizeX, sizeY = mrand(2, 7), mrand(2, 7)

      local group = _G.m.map.layer['ground']

      for i = 1, self.bloodAmount do
        local blood = display.newRect(group, ent.x + mrand(-5, 5), ent.y + mrand(-5, 5), sizeX, sizeY)
        blood:setFillColor(bloodColor.r, bloodColor.g, bloodColor.b)
        blood.alpha = 0.8
      end
      self.bloodAmount = self.bloodAmount - 3
      if self.bloodAmount < 1 then
        self.bloodAmount = 1
      end

      self.bloodTimer = self.bloodtimerMax
    end
  end

  function BloodComponent:splash()
    local group = _G.m.map.layer['ground']

    local sprite = ent.components.sprite:getSprite()
    if sprite then
      sprite.fill.effect = 'filter.brightness'
      sprite.fill.effect.intensity = 1

      _G.m.addTimer(
        50,
        function()
          sprite.fill.effect.intensity = 0
        end
      )
    end

    for _ = 1, 12 do
      local sizeX, sizeY = mrand(2, 7), mrand(2, 7)
      local blood = display.newRect(group, ent.x + mrand(-5, 5), ent.y + mrand(-5, 5), sizeX, sizeY)
      blood:setFillColor(bloodColor.r, bloodColor.g, bloodColor.b)
      blood.alpha = 0.8
      local moveTime = 200
      transition.to(blood, {x = mrand(-40, 40), time = moveTime, delta = true})
      transition.to(
        blood,
        {y = mrand(-30, -10), delay = 0, time = moveTime / 2, transition = easing.outCirc, delta = true}
      )
      transition.to(
        blood,
        {y = mrand(10, 30), delay = moveTime / 2, time = moveTime / 2, transition = easing.inCirc, delta = true}
      )
    end
  end

  return BloodComponent
end

return Public
