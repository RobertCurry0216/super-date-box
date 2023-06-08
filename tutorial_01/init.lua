local gfx <const> = playdate.graphics
deltaTime = 1 / playdate.display.getRefreshRate()

-- playdate libs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- toybox
import "../toyboxes/toyboxes.lua"

-- utilities
import "lib/enum"

-- assets
_image_player_idle = gfx.image.new("images/idle")
_image_player_run = gfx.imagetable.new("images/run")
_image_player_jump = gfx.image.new("images/jump")
_image_player_fall = gfx.image.new("images/fall")

-- fonts
small_font = gfx.font.new("fonts/BitPotion")

-- rooms
import "rooms/gameRoom"

-- player
import "player/player"

-- globals
ZIndex = enum({
  "solid",
  "solid_for_player",
	"player"
})

Group = enum({
  "actor",
  "solid",
  "trigger",
  "solid_for_player",
})

