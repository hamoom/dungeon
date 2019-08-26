local Public = {}

function Public:new(ent)

  local State = {}

  State.initialTime = 1
  State.flashTime = 1
  State.spriteListener = nil

  local impulseSpeed = 30

  function State:update(player)

  end

  function State:start(player)
    local spriteComponent = ent.components.sprite

    self.spriteListener = function(event)
      if event.phase == 'ended' then
        spriteComponent:setAnim('attacking')
        diff = _G.p.newFromSubtraction(player, ent):normalize()

        ent.isAttacking = true
        ent:applyLinearImpulse(impulseSpeed * diff.x, impulseSpeed * diff.y, ent.x, ent.y)

        local vx, _ = ent:getLinearVelocity()
        ent.xScale = math.round(vx) > 0 and -1 or 1

        self.stoppedTimer = _G.m.addTimer(200, function()
          ent:setState('stopped', player)
        end)
      end
    end

    ent.isAttacking = false
    ent.isLit = false
    ent:setLinearVelocity(0, 0)

    local totalTime = 300

    local diff

    ent.xScale = player.x < ent.x and 1 or -1
    spriteComponent:setAnim('charging')
    spriteComponent:getSprite():addEventListener('sprite', self.spriteListener)

  end

  function State:exit()
    if self.stoppedTimer then
      timer.cancel(self.stoppedTimer)
    end
    local spriteComponent = ent.components.sprite
    spriteComponent:getSprite():removeEventListener('sprite', self.spriteListener)
    ent.isLit = false
    ent.isAttacking = false
  end

  return State
end


return Public
