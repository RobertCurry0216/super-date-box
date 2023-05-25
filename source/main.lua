import "init"

local pd <const> = playdate
local gfx <const> = pd.graphics

local function init()
	gfx.sprite.setAlwaysRedraw(true)
	manager = Manager()
	manager:resetAndEnter(GameRoom())
end

local function updateGame()
	pd.timer.updateTimers()
	gfx.sprite.update()
	manager:emit("update")
end

init()
--pd.setMinimumGCTime(2)

function playdate.update()
	updateGame()
	pd.drawFPS(2,0) -- FPS widget
end