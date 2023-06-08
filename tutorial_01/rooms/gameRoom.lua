local gfx <const> = playdate.graphics

class("GameRoom").extends(Room)

function GameRoom:enter()
  gfx.setBackgroundColor(gfx.kColorBlack)
  gfx.clear(gfx.kColorBlack)
  Player(200, 120)

  -- bounding walls
	Solid.addEmptyCollisionSprite(0, -10, 400, 11):setGroups({Group.solid_for_player})
	Solid.addEmptyCollisionSprite(0, 240, 400, 10):setGroups({Group.solid_for_player})
	Solid.addEmptyCollisionSprite(-10, 0, 10, 240):setGroups({Group.solid_for_player})
	Solid.addEmptyCollisionSprite(400, 0, 10, 240):setGroups({Group.solid_for_player})
end
