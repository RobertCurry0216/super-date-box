local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Player").extends(DefaultPlatformer)
local w, h <const> = _image_player_idle:getSize()

local _images <const> = {
  idle = _image_player_idle,
  run = _image_player_run,
  jump = _image_player_jump,
  fall = _image_player_jump
}

function Player:init(x, y)
  Player.super.init(self, _images)
  self:moveTo(x, y)
  self:setZIndex(ZIndex.player)
  self:setCollideRect(1, 2, w-2, h-2)
  self:setCollidesWithGroups({
    Group.solid, Group.trigger, Group.solid_for_player
  })

  self.run_speed_max = 120
  self.air_speed_max = 120
  self.jump_max_time = 300
  self.jump_min_time = 100
  self.fall_max = 200
  self.jump_boost = 250
  self.jump_dcc = 10 --gravity

  self.sm:addState('dead', DeadState(self))
  self.sm:addEvent({name='die', from={'idle', 'run', 'jump', 'fall'}, to='dead'})

  self.weapon = Weapon(self)
end

function Player:die()
  self.sm:die()
  self.weapon:destroy()
end
