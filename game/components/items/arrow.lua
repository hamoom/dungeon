local Public = {}
Public.name = 'arrow'

function Public.new(ent, args)
  local obj, group = unpack(args)

  local Arrow = display.newRect(group, obj.x, obj.y, 24, 6)
  Arrow.isAttacking = false
  Arrow.isVisible = false
  Arrow:setFillColor(1,1,0)

  physics.addBody(Arrow, 'dynamic', {
    bounce = 0.5,
    density = 0.1,
    filter = {
      categoryBits = 2,
      maskBits = 1
    }
  })
  Arrow.isFixedRotation = true
  Arrow.isSensor = true


  function Arrow:collisionCallBack()
    self.isVisible = false
    self.isAttacking = false
  end

  function Arrow:shoot(player)

    self.x, self.y = ent.x, ent.y
    self.isAttacking = true
    self.isVisible = true
    self.rotation = _G.p.new(self):subtract(player):angle()

    local speed = 200

    self.arrowVelocity = _G.p.new(player)
      :subtract(self)
      :normalize()
      :multiply(speed)
  end

  function Arrow:fly()
    if self.arrowVelocity then
      self:setLinearVelocity(self.arrowVelocity.x, self.arrowVelocity.y)
    end
  end

  function Arrow:cancel()
    self.arrowVelocity = nil
  end


  return Arrow
end

return Public
