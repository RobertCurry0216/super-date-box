local Timer <const> = playdate.timer
local gfx <const> = playdate.graphics

local listen_to <const> = {
  "box_picked_up",
  "enemy_angry",
  "restart_level"
}

class("GameRoom").extends(Room)

local spawn_x <const> = 200
local spawn_y <const> = -10

local score_x <const> = 200
local score_y <const> = 30

local pool_1 <const> = {"Small", "Small"}
local pool_2 <const> = {"Small", "Small", "Small", "Small", "Large", "Flying"}
local pool_3 <const> = {"Small", "Small", "Small", "Large", "Large", "Flying", "Flying"}
local pool_4 <const> = {"Small", "Small", "Large", "Large", "Large", "Flying", "Flying"}
local pool_5 <const> = {"Large", "Large", "Large", "Flying", "Flying"}

function GameRoom:enter()
  parti = parti or PartiSystem()
  parti:add()

  local _, player, spawn_zones = loadLevel("Level_0")
  self.spawn_zones = spawn_zones
  self.player = player

  -- bounding walls
	Solid.addEmptyCollisionSprite(0, -10, 400, 11):setGroups({Group.solid_for_player})
  
  -- spawn timer
  local timer = Timer.new(4000, function() self:spawn() end)
  timer.repeats = true
  timer.discardOnCompletion = false
  self.timer = timer

  -- enmey pool
  self.pool = pool_1

  Timer.performAfterDelay(20000, function() self.pool = pool_2 end)
  Timer.performAfterDelay(35000, function() self.pool = pool_3 end)
  Timer.performAfterDelay(50000, function() self.pool = pool_4 end)
  Timer.performAfterDelay(120000, function() self.pool = pool_5 end)
  
  -- listener
  self:subscribe()

  -- score
  self.score = 0
  local image = gfx.image.new(50, 50)
  self.score_sprite = gfx.sprite.new(image)
  self.score_sprite:setZIndex(ZIndex.ui)
  self.score_sprite:setUpdatesEnabled(false)
  self.score_sprite:moveTo(score_x, score_y)
  self.score_sprite:add()
  self:updateScoreSprite()

  self:spawnBox()
end

function GameRoom:subscribe()
  for _, key in pairs(listen_to) do
    Signal:add(key, self, self["on_"..key])
  end
end

function GameRoom:unsubscribe()
  for _, key in pairs(listen_to) do
    Signal:remove(key, self["on_"..key])
  end
end

function GameRoom:resume()
  GameRoom.super.resume(self)
  self.timer:start()
  self:subscribe()
end

function GameRoom:pause()
  GameRoom.super.pause(self)
  self.timer:pause()
  self:unsubscribe()
end

function GameRoom:leave()
  GameRoom.super.leave(self)
  self.timer:remove()
  self:unsubscribe()
  for _, timer in pairs(playdate.timer.allTimers()) do
    timer:remove()
  end
end

function GameRoom:spawn()
  _G["Enemy"..self.pool[math.random(1, #self.pool)]](spawn_x, spawn_y, self.player)
  self.timer.duration = math.max(self.timer.duration-50, 1500)
end

function GameRoom:spawnBox()
  local zone = self.spawn_zones[math.random(1, #self.spawn_zones)]
  Box(zone.x + math.random(zone.w), zone.y + math.random(zone.h))
end

function GameRoom:updateScoreSprite()
  local img = self.score_sprite:getImage()
  gfx.pushContext(img)
    gfx.clear(gfx.kColorClear)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawTextInRect("*"..tostring(self.score).."*", 0, 0, 50, 50, nil, nil, kTextAlignment.center)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
  gfx.popContext()
  self.score_sprite:setImage(img)
end

function GameRoom:on_box_picked_up()
  self.score += 1
  self:spawnBox()
  self:updateScoreSprite()
end

function GameRoom:on_enemy_angry(_, enemy)
  enemy:getAngry(spawn_x, spawn_y)
end

function GameRoom:on_restart_level()
  manager:resetAndEnter(GameRoom())
end