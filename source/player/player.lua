local pd <const> = playdate
local gfx <const> = playdate.graphics


local function toast(x, y, text)
  if not parti then return end
  local w, h = 80, 20
  local image = gfx.image.new(w, h)
  gfx.pushContext(image)
    gfx.setFont(small_font)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawTextInRect(text, 0, 0, w, h, nil, nil, kTextAlignment.center)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
  gfx.popContext()

  parti:spawnParticle(PartiImage(x-w/2, y-h/2, image, {
    life=1000
  }))
end

class("Player").extends(DefaultPlatformer)
local w, h <const> = _image_player_idle:getSize()


local listen_to <const> = {
  "player_knockback",
  "box_picked_up"
}

local _images <const> = {
  idle = _image_player_idle,
  run = _image_player_run,
  jump = _image_player_jump,
  fall = _image_player_jump
}

local weapons <const> = {
  Pistol,
  Magnum,
  Shotgun,
  MachingGun
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

  self.weapon = Pistol(self)

  self:subscribe()
end

function Player:remove()
  self:unsubscribe()
  Player.super.remove(self)
end

function Player:subscribe()
  for _, key in pairs(listen_to) do
    Signal:add(key, self, self["on_"..key])
  end
end

function Player:unsubscribe()
  for _, key in pairs(listen_to) do
    Signal:remove(key, self["on_"..key])
  end
end

function Player:die()
  self.sm:die()
  self.weapon:destroy()
  self:unsubscribe()
end

function Player:on_player_knockback(_, force)
  self.dx += force
end

function Player:on_box_picked_up()
  self.weapon:remove()
  self.weapon = weapons[math.random(1, #weapons)](self)
  toast(self.x, self.y-20, string.upper(self.weapon.className))
end