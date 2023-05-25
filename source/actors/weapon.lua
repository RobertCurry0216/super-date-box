local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Weapon").extends(Actor)
local offset <const> = 10
local bullet_offset <const> = 20

function Weapon:init(actor)
  Weapon.super.init(self)
  self:setImage(_image_pistol)
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

  if pd.buttonJustPressed("b") then
    Bullet(actor.x + offset*facing, actor.y, facing)
  end
end