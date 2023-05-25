local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Weapon").extends(Actor)
local offset <const> = 10
local bullet_offset <const> = 20

function Weapon:init(actor, image)
  Weapon.super.init(self)
  self:setImage(image)
  self:setCenter(0, 0.5)
  self:setZIndex(ZIndex.weapon)
  self:moveTo(actor.x + offset, actor.y)
  self.actor = actor
end

function Weapon:update()
  local actor = self.actor
  local flip = actor:getImageFlip()
  local facing = flip == gfx.kImageUnflipped and 1 or -1
  self:setCenter(facing == 1 and 0 or 1, 0.5)
  self:moveTo(actor.x + offset*facing, actor.y)
  self:setImageFlip(flip)

  self:fire(facing)
end

function Weapon:fire(facing)
  -- override
end


class("Pistol").extends(Weapon)

local p_size <const> = 5
local p_bullet_img <const> = gfx.image.new(p_size, p_size)
local p_speed <const> = 180 * deltaTime
local p_damage <const> = 2

gfx.pushContext(p_bullet_img)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillCircleInRect(0,0,p_size,p_size)
gfx.popContext()

function Pistol:init(actor)
  Pistol.super.init(self, actor, _image_pistol)
end

function Pistol:fire(facing)
  if pd.buttonJustPressed("b") then
    local actor = self.actor
    Bullet(p_bullet_img, p_damage, actor.x + bullet_offset*facing, actor.y, p_speed*facing, 0)
  end
end


class("Magnum").extends(Weapon)

local m_size <const> = 8
local m_bullet_img <const> = gfx.image.new(m_size, m_size)
local m_speed <const> = 180 * deltaTime
local m_damage <const> = 5
local m_knockback <const> = -150

gfx.pushContext(m_bullet_img)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillCircleInRect(0,0,m_size,m_size)
gfx.popContext()

function Magnum:init(actor)
  Magnum.super.init(self, actor, _image_pistol)
end

function Magnum:fire(facing)
  if pd.buttonJustPressed("b") then
    local actor = self.actor
    Bullet(m_bullet_img, m_damage, actor.x + bullet_offset*facing, actor.y, m_speed*facing, 0)
    Signal:dispatch("player_knockback", facing*m_knockback)
  end
end


class("Shotgun").extends(Weapon)

local sg_size <const> = 3
local sg_bullet_img <const> = gfx.image.new(sg_size, sg_size)
local sg_speed <const> = 350 * deltaTime
local sg_damage <const> = 2
local sg_spread <const> = math.rad(16)
local sg_rate <const> = 600
local sg_knockback <const> = -200

gfx.pushContext(sg_bullet_img)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillCircleInRect(0,0,sg_size,sg_size)
gfx.popContext()

function Shotgun:init(actor)
  Shotgun.super.init(self, actor, _image_shotgun)
  self.last = 0
end

function Shotgun:fire(facing)
  local theata = facing == 1 and math.rad(-4) or math.rad(184)
  local actor = self.actor
  local time = pd.getCurrentTimeMilliseconds()
  if pd.buttonJustPressed("b") and time - self.last >= sg_rate then
    self.last = time
    for i=1, 8 do
      local dx, dy = math.from_polar(theata+(math.random()*2-1)*(sg_spread))
      Pellet(sg_bullet_img, sg_damage, actor.x + bullet_offset*facing, actor.y, dx*sg_speed, dy*sg_speed)
    end
    Signal:dispatch("player_knockback", facing*sg_knockback)
  end
end


class("MachingGun").extends(Weapon)

local mg_size <const> = 3
local mg_bullet_img <const> = gfx.image.new(mg_size, mg_size)
local mg_speed <const> = 350 * deltaTime
local mg_damage <const> = 1
local mg_spread <const> = math.rad(6)
local mg_rate <const> = 100
local mg_knockback <const> = -100

gfx.pushContext(mg_bullet_img)
  gfx.setColor(gfx.kColorWhite)
  gfx.fillCircleInRect(0,0,mg_size,mg_size)
gfx.popContext()

function MachingGun:init(actor)
  MachingGun.super.init(self, actor, _image_rifle)
  self.last = 0
end

function MachingGun:fire(facing)
  local theata = facing == 1 and math.rad(-2) or math.rad(182)
  local actor = self.actor
  local time = pd.getCurrentTimeMilliseconds()
  if pd.buttonIsPressed("b") and time - self.last >= mg_rate then
    self.last = time
    local dx, dy = math.from_polar(theata+(math.random()*2-1)*(sg_spread))
    Bullet(sg_bullet_img, sg_damage, actor.x + bullet_offset*facing, actor.y, dx*sg_speed, dy*sg_speed)
    Signal:dispatch("player_knockback", facing*mg_knockback)
  end
end