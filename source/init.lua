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
_image_player_die = gfx.image.new("images/die")

_image_box = gfx.image.new("images/box")
_image_enemy_small = gfx.imagetable.new("images/enemy_small")
_image_enemy_large = gfx.imagetable.new("images/enemy_large")
_image_enemy_flying = gfx.imagetable.new("images/enemy_flying")

_image_pistol = gfx.image.new("images/pistol")
_image_shotgun = gfx.image.new("images/shotgun")
_image_rifle = gfx.image.new("images/rifle")

-- fonts
small_font = gfx.font.new("fonts/BitPotion")

-- rooms
import "rooms/splashRoom"
import "rooms/gameRoom"
import "rooms/highscoreRoom"
import "rooms/gameOverRoom"

-- actors
import "actors/box"
import "actors/enemy"
import "actors/weapon"
import "actors/bullet"

-- player
import "player/player"
import "player/deadState"

-- globals
gravity = 10 * deltaTime

ZIndex = enum({
  "solid",
  "solid_for_player",
  "enemy",
	"boxes",
  "player",
  "weapon",
	"ui"
})

Group = enum({
  "actor",
  "solid",
  "trigger",
  "solid_for_player",
  "bullet",
  "enemy"
})

-- load world
local ldtk <const> = LDtk
ldtk.load("levels/world.ldtk")

function loadLevel(levelName)
	local player
	local layerSprites = {}
	local spawn_zones = {}
	for layerName, layer in pairs(ldtk.get_layers(levelName)) do
		if layer.tiles then
			local tilemap = ldtk.create_tilemap(levelName, layerName)

			local layerSprite = gfx.sprite.new()
			layerSprite:setTilemap(tilemap)
			layerSprite:moveTo(0, 0)
			layerSprite:setCenter(0, 0)
			layerSprite:setUpdatesEnabled(false)
			layerSprite:setZIndex(layer.zIndex)
			layerSprite:add()
			layerSprites[layerName] = layerSprite

			local sx, sy = tilemap:getTileSize()
			-- solids
			local emptySolidTiles = ldtk.get_empty_tileIDs(levelName, "Solid", layerName)
			if emptySolidTiles then
				local colRecs = tilemap:getCollisionRects(emptySolidTiles)
				for _, rect in ipairs(colRecs) do
					local x, y, w, h = rect:unpack()
					Solid.addEmptyCollisionSprite(x*sx, math.max(y*sy, 1), w*sx, h*sy)
				end
			end

			-- player solids
			local emptyPlayerTiles = ldtk.get_empty_tileIDs(levelName, "PlayerSolid", layerName)
			if emptyPlayerTiles then
				local colRecs = tilemap:getCollisionRects(emptyPlayerTiles)
				for _, rect in ipairs(colRecs) do
					local x, y, w, h = rect:unpack()
					Solid.addEmptyCollisionSprite(x*sx, math.max(y*sy, 1), w*sx, h*sy):setGroups({Group.solid_for_player})
				end
			end
		end

		-- entities
		local entities = ldtk.get_entities(levelName, layerName)
		if entities then
			for _, entity in pairs(entities) do
				if entity.name == "Player" then
					player = Player(entity.position.x, entity.position.y)
				elseif entity.name == "BoxSpawn" then
					table.insert(spawn_zones, {x=entity.position.x, y=entity.position.y, w=entity.size.width, h=entity.size.height})
				end
			end
		end
	end
	return layerSprites, player, spawn_zones
end
