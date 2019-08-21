local Public = {}
Public.name = 'weapon'

function Public.new(ent, args)
  local w, h = unpack(args)
  local weaponGroup = display.newGroup()
  ent:insert(weaponGroup)
  local weapon = display.newRect(weaponGroup, 0, 0, w, h)
  weapon.isAttacking = false
  weapon.isVisible = false

  function weaponGroup:getHitBox()
    return weapon
  end

  function weaponGroup:getGroup()
    return self
  end

  function weaponGroup:setAttacking(isAttacking)
    self:getHitBox().isAttacking = isAttacking
    -- self.isVisible = isAttacking
  end

  return weaponGroup
end

return Public
