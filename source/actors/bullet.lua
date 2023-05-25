local pd <const> = playdate
local gfx <const> = playdate.graphics

local function smokePuff(x, y)
  if not parti then return end
  for i=1, 6 do
    local dx, dy = math.from_polar(math.random()*6.28)
    parti:spawnParticle(PartiFadingCircle(x, y, dx, dy, math.random(2,4)))
  end
end

class("Bullet").extends(Actor)

Bullet.collisionResponse = gfx.sprite.kCollisionTypeOverlap

function Bullet:init(image, damage, x, y, dx, dy)
  Bullet.super.init(self)
  self:setImage(image)
  self:setCollideRect(0,0,self:getSize())
  self:setGroups({Group.bullet})
  self:setCollidesWithGroups({Group.solid, Group.solid_for_player, Group.enemy})

  self:moveTo(x, y)
  self.dx = dx
  self.dy = dy
  self.damage = damage
end

function Bullet:destroy()
  smokePuff(self.x, self.y)
  Bullet.super.destroy(self)
end

function Bullet:update()
  local _, _, cols, l = self:moveWithCollisions(self.x+self.dx, self.y+self.dy)
  self:handleCollisions(cols, l)
end

function Bullet:handleCollisions(cols, l)
  if l ~= 0 then
    for _, col in pairs(cols) do
      local other = col.other
      if other:isa(Solid) then
        self:destroy()
      elseif other:isa(Enemy) then
        other:hurt(self.damage)
        self:destroy()
      end
    end
  end
end

class("Pellet").extends(Bullet)

function Pellet:init(...)
  Pellet.super.init(self, ...)
  self.decay = math.random()*0.1 + 0.8
end

function Pellet:update()
  Pellet.super.update(self)
  self.dx *= self.decay
  self.dy *= self.decay
  if math.abs(self.dx) <= 0.1 or math.abs(self.dy) <= 0.1 then
    self:remove()
  end
end