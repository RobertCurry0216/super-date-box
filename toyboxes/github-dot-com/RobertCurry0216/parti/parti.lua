import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("PartiSystem").extends(gfx.sprite)

function PartiSystem:init(cap, w, h)
  PartiSystem.super.init(self)

  self._img = gfx.image.new(w or 400, h or 240, gfx.kColorClear)
  self:setImage(self._img)
  self:setCenter(0,0)
  self:setIgnoresDrawOffset(true)
  self:setZIndex(32767)

  self._particles = table.create(1000)
  self.count = 0
  self.cap = cap or 50
end

function PartiSystem:update()
  local particles = self._particles
  local l = #particles
  if self._last_count == 0 and l == 0 then
    return
  end
  self._last_count = l
  self:markDirty()

  local time = pd.getCurrentTimeMilliseconds()

  local img = self._img
  img:clear(gfx.kColorClear)
  local offx, offy = gfx.getDrawOffset()
  offx = offx - self.x
  offy = offy - self.y

  gfx.pushContext(img)
    for i=l, 1, -1 do
      local particle = particles[i]
      local isDone = particle:draw(time - particle.__start, offx, offy)
      if isDone then
        table.remove(particles, i)
        self.count -= 1
      end
    end
  gfx.popContext()
end

function PartiSystem:clear()
  self._particles = table.create(1000)
  self.count = 0
end

function PartiSystem:spawnParticle(particle)
  if self.count >= self.cap then
    print("Parti: particle cap reached", self.count)
    return
  end
  particle.__start = pd.getCurrentTimeMilliseconds()
  table.insert(self._particles, particle)
  self.count += 1
end


class("PartiParticle").extends()

function PartiParticle:draw(age, offx, offy) end


class("PartiImage").extends(PartiParticle)

function PartiImage:init(x, y, image, options)
  self.x = x
  self.y = y
  self.image = image
  self.dx = options.dx or 0
  self.dy = options.dy or 0
  self.ax = options.ax or 0
  self.ay = options.ay or 0
  self.life = options.life or 300
end

function PartiImage:draw(age, offx, offy)
  if age >= self.life then return true end

  self.dx += self.ax
  self.dy += self.ay

  self.x += self.dx
  self.y += self.dy

  self.image:draw(self.x+offx, self.y+offy)
end


class("PartiImageTable").extends(PartiParticle)

function PartiImageTable:init(x, y, table, options)
  self.x = x
  self.y = y
  self.table = table
  self.dx = options.dx or 0
  self.dy = options.dy or 0
  self.ax = options.ax or 0
  self.ay = options.ay or 0
  self.step = options.step or 1
  self.frame_rate = options.frame_rate or 100
  self.start = options.start or 1
  self.final = options.final or #table+1
end

function PartiImageTable:draw(age, offx, offy)
  local idx = self.start + self.step * (age // self.frame_rate)
  local step, final = self.step, self.final
  if step >= 1 and idx >= final then return true end
  if step <= 1 and idx <= final then return true end

  self.dx += self.ax
  self.dy += self.ay

  self.x += self.dx
  self.y += self.dy

  self.table:getImage(idx):draw(self.x+offx, self.y+offy)
end

local circles <const> = gfx.imagetable.new(10)
gfx.setColor(gfx.kColorWhite)
for i=1, 10 do
  local img = gfx.image.new(20, 20)
  gfx.pushContext(img)
    gfx.fillCircleAtPoint(10, 10, i)
  gfx.popContext()
  circles:setImage(i, img)
end


class("PartiFadingCircle").extends(PartiImageTable)

function PartiFadingCircle:init(x, y, dx, dy, life)
  PartiFadingCircle.super.init(self, x-10, y-10, circles, {
    dx=dx,
    dy=dy,
    step=-1,
    final=0,
    start=life,
  })
end


