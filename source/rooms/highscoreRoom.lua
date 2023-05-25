local gfx <const> = playdate.graphics

local bold_font <const> = gfx.getFont(gfx.font.kVariantBold)
local bold_spacing <const> = bold_font:getHeight() + 3
local small_spacing <const> = small_font:getHeight() + 1

class("HighscoreRoom").extends(PauseRoom)

function HighscoreRoom:enter()
  HighscoreRoom.super.enter(self)
  local data = playdate.datastore.read()
  self:createSprite(data.highscores)
end

function HighscoreRoom:update()
  if playdate.buttonJustReleased("b") then
    manager:pop()
  end
end


function HighscoreRoom:createSprite(scores)
  local img <const> = gfx.image.new(400, 240, gfx.kColorBlack)
  gfx.pushContext(img)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    bold_font:drawTextAligned("HIGH SCORES", 200, 30, kTextAlignment.center)

    local y = 60
    for i=1, 10 do
      local score = tostring(scores[i])
      local pad = string.sub("--------------------", 1, 20-#score)
      small_font:drawTextAligned(tostring(i)..pad..score, 200, y, kTextAlignment.center)
      y += small_spacing
    end
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
  gfx.popContext()


  local spr = gfx.sprite.new(img)
  spr:setIgnoresDrawOffset(true)
  spr:setUpdatesEnabled(false)
  spr:setCenter(0,0)
  spr:moveTo(0,0)
  spr:setZIndex(ZIndex.ui)
  spr:add()
end