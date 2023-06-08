import "init"

local pd <const> = playdate
local gfx <const> = pd.graphics

local function init()
  -- setup game
	manager = Manager()
	manager:resetAndEnter(GameRoom())
end

init()

function playdate.update()
	pd.timer.updateTimers()
	gfx.sprite.update()
	manager:emit("update")
end