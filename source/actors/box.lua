local gfx <const> = playdate.graphics

class("Box").extends(Trigger)

function Box:init(x, y)
  Box.super.init(self)

  self:setZIndex(ZIndex.boxes)
  self:setImage(_image_box)
  self:moveTo(x, y)
  self:setCollideRect(0,0, self:getSize())
  self:setCollidesWithGroups({Group.solid, Group.solid_for_player})
  self.dy = 0
end

function Box:update()
  Box.super.update(self)
  local sy = self.y
  local _, fy, _, _ = self:moveWithCollisions(self.x, self.y+self.dy+gravity)
  self.dy = fy - sy
end

function Box:perform(actor, col)
  Signal:dispatch("box_picked_up")
  self:destroy()
end
