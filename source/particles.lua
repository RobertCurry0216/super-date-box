local gfx <const> = playdate.graphics

-- base classes to move to parti

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
  if idx == self.final then return true end

  self.dx += self.ax
  self.dy += self.ay

  self.x += self.dx
  self.y += self.dy

  self.table:getImage(idx):draw(self.x+offx, self.y+offy)
end

-- helper

function lerp(a, b, t)
	return a + (b - a) * t
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


