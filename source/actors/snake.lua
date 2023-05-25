local gfx <const> = playdate.graphics
local speed <const> = 30 * deltaTime
local angrySpeed <const> = 50 * deltaTime

local function throwBody(x, y)
  if not parti then return end
  local w, h = _image_snake:getSize()
  parti:spawnParticle(PartiImage(x-w/2, y-h/2, _image_snake[1], {
    dx=math.random(-2, 2),
    dy=-4,
    ay=0.6,
    life=1500
  }))
end

local function smoke(x, y)

end

class("Snake").extends(Trigger)

function Snake:init(x, y)
  Snake.super.init(self)
  self.images = AnimatedImage.new(_image_snake, {loop=true, delay=200})

  self:setZIndex(ZIndex.enemy)
  self:setImage(self.images:getImage())
  self:moveTo(x, y)
  self:setCollideRect(0,0, self:getSize())
  self:setCollidesWithGroups({Group.solid})
  self:setGroups({Group.actor, Group.trigger, Group.enemy})

  self.speed = speed
  self.dy = 0
  self.img_flip = gfx.kImageFlippedX
  self.health = 1

  if math.random() > 0.5 then
    self.speed *= -1
    self.img_flip = gfx.kImageUnflipped
  end
end

function Snake:update()
  Snake.super.update(self)
  self:setImage(self.images:getImage())
  self:setImageFlip(self.img_flip)

  local ax, ay, cols, l = self:moveWithCollisions(self.x + self.speed, self.y)
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
  local _, fy, _, _ = self:moveWithCollisions(self.x, self.y+self.dy+gravity)
  self.dy = fy - sy

  if self.y > 260 then
    Signal:dispatch("enemy_angry", self)
  end
end

function Snake:perform(actor, col)
  actor:die()
end

function Snake:getAngry(x, y)
  self.speed = angrySpeed
  self:moveTo(x, y)
end

function Snake:hurt(damage)
  self.health -= 1
  if self.health <= 0 then
    throwBody(self.x, self.y)
    self:destroy()
  end
end