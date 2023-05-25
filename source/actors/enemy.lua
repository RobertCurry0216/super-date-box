local gfx <const> = playdate.graphics
local speed <const> = 45 * deltaTime
local angrySpeed <const> = 1.5

local function throwBody(x, y, image)
  if not parti then return end
  local w, h = image:getSize()
  parti:spawnParticle(PartiImage(x-w/2, y-h/2, image, {
    dx=math.random(-2, 2),
    dy=-4,
    ay=0.6,
    life=1500
  }))
end

local function smoke(x, y)
  if not parti then return end
  local dx = (math.random()-0.5) * 16
  local dy = (math.random()-0.5) * 16
  parti:spawnParticle(PartiFadingCircle(x+dx, y+dy, 0, -2, 3))
end


class("Enemy").extends(Trigger)

function Enemy:init(images, x, y)
  Enemy.super.init(self)
  self.images = AnimatedImage.new(images, {loop=true, delay=200})

  self:setZIndex(ZIndex.enemy)
  self:setImage(self.images:getImage())
  self:moveTo(x, y)
  self:setCollideRect(0,0, self:getSize())
  self:setCollidesWithGroups({Group.solid})
  self:setGroups({Group.actor, Group.trigger, Group.enemy})

  self.speed = speed
  self.health = 4
  self.dy = 0
  self.img_flip = gfx.kImageFlippedX
  self.timer = nil

  if math.random() > 0.5 then
    self.speed *= -1
    self.img_flip = gfx.kImageUnflipped
  end
end

function Enemy:remove()
  if self.timer then self.timer:remove() end
  self.timer = nil
  Enemy.super.remove(self)
end

function Enemy:getMoveDelta()
  return self.speed, self.dy+gravity
end

function Enemy:update()
  Enemy.super.update(self)
  self:setImage(self.images:getImage())
  self:setImageFlip(self.img_flip)

  local dx, dy = self:getMoveDelta()

  local ax, ay, cols, l = self:moveWithCollisions(self.x + dx, self.y)
  for _, col in ipairs(cols) do
    if col.other:isa(Solid) then
      self.speed *= -1
      if self.speed < 0 then
        self.img_flip = gfx.kImageUnflipped
      else
        self.img_flip = gfx.kImageFlippedX
      end
      break
    end
  end

  local sy = self.y
  local _, fy, _, _ = self:moveWithCollisions(self.x, self.y+dy)
  self.dy = fy - sy

  if self.y > 260 then
    Signal:dispatch("enemy_angry", self)
  end
end

function Enemy:perform(actor, col)
  actor:die()
end

function Enemy:getAngry(x, y)
  self.speed *= angrySpeed
  self:moveTo(x, y)
  if not self.timer then
    self.timer = playdate.timer.performAfterDelay(100, function() smoke(self.x, self.y) end)
    self.timer.discardOnCompletion = false
    self.timer.repeats = true
  end
end

function Enemy:hurt(damage)
  self.health -= damage
  if self.health <= 0 then
    throwBody(self.x, self.y, self.images:getImage())
    self:destroy()
  end
end

class("EnemySmall").extends(Enemy)

function EnemySmall:init(x, y)
  EnemySmall.super.init(self, _image_enemy_small, x, y)
end

class("EnemyLarge").extends(Enemy)

local speed_large <const> = 35 * deltaTime

function EnemyLarge:init(x, y)
  EnemyLarge.super.init(self, _image_enemy_large, x, y)
  self.speed = speed_large
  self.health = 30

  if math.random() > 0.5 then
    self.speed *= -1
    self.img_flip = gfx.kImageUnflipped
  end
end

class("EnemyFlying").extends(Enemy)

local speed_flying <const> = 20 * deltaTime

function EnemyFlying:init(x, y, actor)
  EnemyFlying.super.init(self, _image_enemy_flying, x, y)
  self.speed = speed_flying
  self.health = 3
  self:setCollidesWithGroups({})
  self.actor = actor
end

function EnemyFlying:getMoveDelta()
  local actor = self.actor
  local dx, dy
  if actor.y > self.y then
    dx, dy = math.normalize(actor.x-self.x, actor.y-self.y)
  else
    dx, dy = math.normalize(200-self.x, 270-self.y)
  end
  return dx*speed_flying, math.max(dy, 0.2)*speed_flying
end

