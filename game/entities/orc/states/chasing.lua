local rand = math.random
local Public = {}

function Public.new(ent)
  local State = {}

  State.curAngle = nil
  State.rotationSpeed = 130
  State.speed = 120
  State.range = 180

  function State:update(player)
    if not self.curAngle then
      self.curAngle = _G.p.newFromSubtraction(player, ent):angle()
    end

    local offsetAngle = _G.p.newFromSubtraction(player, ent):angle()

    local differenceAngle = _G.p.shortestAngleBetween(self.curAngle, offsetAngle)

    local amtToRotate = self.rotationSpeed * _G.m.dt

    if math.abs(differenceAngle) < amtToRotate then
      amtToRotate = math.abs(differenceAngle)
    end

    amtToRotate = -_G.h.sign(differenceAngle) * amtToRotate
    self.curAngle = self.curAngle + amtToRotate

    local direction = _G.p.newFromAng(self.curAngle)

    ent:setLinearVelocity(direction.x * self.speed, direction.y * self.speed)

    local entPt = _G.p.new(ent)

    local spriteComponent = ent.components.sprite

    spriteComponent:setFacing('running-f-chasing', 'running-b-chasing', 'running-s-chasing')

    if entPt:distanceTo(player) > 200 then
      ent:setState('wandering', player)
    elseif entPt:distanceTo(player) <= ent.attackDistance + 10 and rand() < 0.75 then
      ent:setState('blocking', player)
    end
  end

  function State:start(player)
  end

  function State:exit(player)
  end

  return State
end

return Public
