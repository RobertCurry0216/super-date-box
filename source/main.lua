import "init"

local pd <const> = playdate
local gfx <const> = pd.graphics

local function init()
  -- save data
  local data = pd.datastore.read()
  if not data then
    pd.datastore.write({
      highscores={0,0,0,0,0,0,0,0,0,0}
    })
  end

  -- setup game
	gfx.sprite.setAlwaysRedraw(true)
	manager = Manager()
	manager:resetAndEnter(SplashRoom())
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