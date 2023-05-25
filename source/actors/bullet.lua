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

local size <const> = 5
local _image <const> = gfx.image.new(size, size)
local speed <const> = 180 * deltaTime

gfx.pushContext(_image)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillCircleInRect(0,0,size,size)
gfx.popContext()


function Bullet:init(x, y, facing)
  Bullet.super.init(self)
  self:setImage(_image)
  self:setCollideRect(0,0,self:getSize())
  self:setGroups({Group.bullet})
  self:setCollidesWithGroups({Group.solid, Group.solid_for_player, Group.enemy})

  self:moveTo(x, y)
  self.speed = speed * facing
end

function Bullet:destroy()
  smokePuff(self.x, self.y)
  Bullet.super.destroy(self)
end

function Bullet:update()
  local _, _, cols, l = self:moveWithCollisions(self.x+self.speed, self.y)
  if l ~= 0 then
    for _, col in pairs(cols) do
      local other = col.other
      if other:isa(Solid) then
        self:destroy()
      elseif other:isa(Snake) then -- TODO: enemy class
        other:hurt(1)
        self:destroy()
      end
    end
  end
end