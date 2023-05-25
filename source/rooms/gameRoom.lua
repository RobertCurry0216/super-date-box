local Timer <const> = playdate.timer

local listen_to <const> = {
  "box_picked_up",
  "enemy_angry",
  "restart_level"
}

class("GameRoom").extends(Room)

local spawn_x <const> = 200
local spawn_y <const> = -10

function GameRoom:enter()
  parti = parti or PartiSystem()
  parti:add()

  parti:spawnParticle(PartiFadingCircle(50,50,0,0))

  local _, player, spawn_zones = loadLevel("Level_0")
  self.spawn_zones = spawn_zones

  -- bounding walls
	Solid.addEmptyCollisionSprite(0, -10, 400, 11):setGroups({Group.solid_for_player})

  -- spawn timer
  local timer = Timer.new(4000, function() self:spawn() end)
  timer.repeats = true
  timer.discardOnCompletion = false
  self.timer = timer

  -- listener
  self:subscribe()

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
end

function GameRoom:spawn()
  Snake(spawn_x, spawn_y)
  self.timer.duration = math.max(self.timer.duration-100, 1000)
end

function GameRoom:spawnBox()
  local zone = self.spawn_zones[math.random(1, #self.spawn_zones)]
  Box(zone.x + math.random(zone.w), zone.y + math.random(zone.h))
end

function GameRoom:on_box_picked_up()
  self:spawnBox()
end

function GameRoom:on_enemy_angry(_, enemy)
  enemy:getAngry(spawn_x, spawn_y)
end

function GameRoom:on_restart_level()
  manager:resetAndEnter(GameRoom())
end